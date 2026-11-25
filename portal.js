const http = require('http');
const fs = require('fs');

const HTML = fs.readFileSync(__dirname + '/portal.html', 'utf8');
const BACKEND_HOST = process.env.BACKEND_HOST || '127.0.0.1';
const BACKEND_PORT = Number(process.env.BACKEND_PORT || 8000);
const PORTAL_PORT = Number(process.env.PORTAL_PORT || 3000);

const server = http.createServer((req, res) => {
    if (req.url === '/' && req.method === 'GET') {
        res.writeHead(200, { 'Content-Type': 'text/html' });
        res.end(HTML);
    } else if (req.url.startsWith('/proxy/')) {
        let targetPath = req.url.replace('/proxy/', '/');
        const options = {
            hostname: BACKEND_HOST,
            port: BACKEND_PORT,
            path: targetPath,
            method: req.method,
            headers: Object.assign({}, req.headers),
            timeout: 300000
        };
        // Remove host header to avoid mismatches
        delete options.headers.host;
        
        let body = [];
        req.on('data', chunk => body.push(chunk));
        req.on('end', () => {
            options.headers['content-length'] = Buffer.concat(body).length;
            const proxyReq = http.request(options, proxyRes => {
                res.writeHead(proxyRes.statusCode, proxyRes.headers);
                proxyRes.pipe(res);
            });
            proxyReq.on('timeout', () => {
                proxyReq.destroy(new Error('Backend request timed out'));
            });
            proxyReq.on('error', err => {
                if (!res.headersSent) {
                    res.writeHead(502, { 'Content-Type': 'application/json' });
                }
                res.end(JSON.stringify({error: `Backend not available at ${BACKEND_HOST}:${BACKEND_PORT}`, details: err.message}));
            });
            if(body.length) proxyReq.write(Buffer.concat(body));
            proxyReq.end();
        });
    } else {
        res.writeHead(404);
        res.end();
    }
});

server.listen(PORTAL_PORT, () => console.log(`Portal started on http://localhost:${PORTAL_PORT} (backend: ${BACKEND_HOST}:${BACKEND_PORT})`));

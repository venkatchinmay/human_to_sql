const http = require('http');
const fs = require('fs');

const HTML = fs.readFileSync(__dirname + '/portal.html', 'utf8');

const server = http.createServer((req, res) => {
    if (req.url === '/' && req.method === 'GET') {
        res.writeHead(200, { 'Content-Type': 'text/html' });
        res.end(HTML);
    } else if (req.url.startsWith('/proxy/')) {
        let targetPath = req.url.replace('/proxy/', '/');
        const options = {
            hostname: '127.0.0.1',
            port: 8000,
            path: targetPath,
            method: req.method,
            headers: Object.assign({}, req.headers)
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
            proxyReq.on('error', err => {
                res.writeHead(500, { 'Content-Type': 'application/json' });
                res.end(JSON.stringify({error: "Backend not available on port 8000. Is kubectl port-forward running?", details: err.message}));
            });
            if(body.length) proxyReq.write(Buffer.concat(body));
            proxyReq.end();
        });
    } else {
        res.writeHead(404);
        res.end();
    }
});

server.listen(3000, () => console.log('Portal started natively on http://localhost:3000'));

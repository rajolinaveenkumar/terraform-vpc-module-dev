# What is AWS ALB (Application Load Balancer)?
* ALB is a Layer 7 (HTTP/HTTPS) Load Balancer that automatically distributes incoming application traffic - - across multiple targets like:
    - EC2 instances
    - Containers (ECS, EKS)
    - Lambda functions
    - IP addresses

It is smart and content-aware — meaning it understands URLs, headers, and cookies.

**OR**
* ALB stands for Application Load Balancer, a Layer 7 load balancer in AWS that:
    * Distributes HTTP/HTTPS traffic across multiple targets (EC2, ECS, Lambda)
    * Understands application-level data like paths, headers, cookies
    * Supports routing rules, SSL termination, sticky sessions, etc.


### Where is ALB used?
You use ALB when you want to:

- Balance traffic between web servers
- Host multiple apps on same domain (path-based routing)
- Handle HTTPS traffic securely
- Do blue-green or canary deployments (target groups)
- Monitor traffic using CloudWatch

### Key ALB Components
**1. Load Balancer**
- The main ALB resource, public or internal.
- Exposes a DNS name to receive traffic (e.g. my-app-alb-123456.ap-south-1.elb.amazonaws.com).

**2. Listeners**
- Listens on a port (usually 80 or 443).
- Routes traffic to target groups based on rules.
Example:
```
Port 80 —> Target Group A
Port 443 —> Target Group B (HTTPS)
```
**3. Listener Rules**
* Defines how to forward traffic:
    - Path-based (e.g., /api/* goes to backend)
    - Host-based (e.g., admin.example.com goes to admin app)

**4. Target Groups**
* Group of resources ALB forwards requests to.
* Can contain:
        - EC2 instances
        - ECS services
        - Lambda functions
        - IPs
    Health checks are configured here.

**5. Health Checks**
* ALB continuously checks targets’ health:
    - If healthy → sends traffic
    - If unhealthy → skips that instance
* You define:
    - Protocol (HTTP/HTTPS)
    - Path (e.g. /health)
    - Port

**5. Sticky Sessions (Session Affinity)**
-  ALB supports sticky sessions!
- When enabled, the client’s requests are always routed to the same target.
- Uses a cookie called AWSALB.
- You enable it per target group.

✅ Use case:
    * Useful for applications that store session data locally (not in Redis/DB).

**6. ✅ SSL/TLS Termination**
- ALB supports SSL/TLS termination.
- You can upload SSL certificates using AWS Certificate Manager (ACM).
- ALB handles encryption/decryption, so backend EC2s get plain HTTP.
✅ Use case:
     * Secures frontend traffic (HTTPS), but keeps backend communication simple.

**7. WebSocket Support**
- ALB supports WebSocket-based apps (like chat apps).

**8. Redirects and Fixed Responses**
- Redirect HTTP → HTTPS
- Return static messages (e.g. 403 Maintenance Page)

**9. WAF Integration**
- AWS Web Application Firewall can be attached to ALB for DDoS and bot protection.

**10. Logging & Monitoring**
- Access logs can be saved in S3.
- Metrics available via CloudWatch (request count, 5xx errors, latency).
- Supports AWS X-Ray for request tracing.

**11. Security**
- Use Security Groups for ALB to allow incoming traffic.
- ALB itself sits in public subnet, targets in private subnets.

**12. IPv6 Support**
- You can enable IPv6 for your ALB.

# When to Use ALB?
### Use AWS ALB when:
* You need smart routing based on path or hostname.
* You want to host multiple services on same domain.
* You want HTTPS with SSL certificate support.
* You need sticky sessions.
* You need container-based apps (ECS/EKS).
* You want to integrate with Lambda functions.

### Comparison Recap: ALB vs NLB vs CLB

| Feature         | ALB            | NLB                            | CLB              |
| --------------- | -------------- | ------------------------------ | ---------------- |
| Layer           | 7 (HTTP/HTTPS) | 4 (TCP/UDP)                    | 4 & 7            |
| Sticky Sessions | ✅ Yes          | ❌ No                           | ✅ Yes            |
| SSL Termination | ✅ Yes          | ✅ (Limited via TLS listener)   | ✅ Yes            |
| WebSocket       | ✅ Yes          | ✅ Yes                          | ❌ No             |
| Lambda Support  | ✅ Yes          | ❌ No                           | ❌ No             |
| Best For        | Web apps, APIs | Gaming, real-time, low-latency | Legacy workloads |

### Real-World Example (Simplified)
**Let’s say:**
    - / → React frontend → EC2 (public)
    - /api → Node.js backend → EC2 (private)
    - /admin → Admin UI → ECS container
    - All use one ALB, with path-based routing and SSL from ACM

**You can:**
- Use SSL termination at ALB
- Enable sticky sessions on /api target group
- Use CloudWatch to monitor ALB health
- Let me know if you'd like:
- Terraform code for ALB setup
- Architecture diagram
- Interview-based summary of this content
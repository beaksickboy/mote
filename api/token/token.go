package token

// https://security.stackexchange.com/questions/180357/store-auth-token-in-cookie-or-header
// https://www.youtube.com/watch?v=67mezK3NzpU

/*
- Dont compare JWT with Cookie, bcz they are different stuff
- Token by reference (Session Id)
- Token by value (JWT)
*/

/*
Session id
- store in db
- When scaling => multiple instance -> load balancer with sticky session + distributed cache
- Dont want to use one cache server => bc if this server down => lose every thing
*/
// Benefit of JWT over session id, dont have to has db to store those session id

/*
Cookies
- Secure Httponly will stop any js code from access cookie
*/

/*
JWT
Signartures
- Symmetric: Shared secret
- Asymmetric: Private key, Public key
*/

// CSRF | XSRF

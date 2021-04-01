
export function saveUserToken(userToken) {
    if (userToken === null) { localStorage.removeItem("TOKEN"); }
    else { localStorage.setItem("TOKEN", userToken); }
}

export function getUserToken() {
    return localStorage.getItem("TOKEN");
}
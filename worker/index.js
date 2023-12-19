addEventListener('fetch', event => {
    event.respondWith(handleRequest(event.request))
  })
  
  async function errorState() {
    let response = {
      'message': 'Not a valid route!'
    }
    const responseInit = {
        status: 400,
        headers: {'Content-Type': 'application/json'}
    }
    return new Response(
      JSON.stringify(response),
      responseInit
    )
  }
  
  async function statusState() {
    let response = {
      'message': 'Everything works!'
    }
    const responseInit = {
        status: 200,
        headers: {'Content-Type': 'application/json'}
    }
    return new Response(
      JSON.stringify(response),
      responseInit
    )
  }
  
  async function successState() {
    let response = {
        "appVersion": {
          "minimum": 5,
          "current": 5
        },
        "outage": {
          "showMaintenancePage": false
        },
        "share": {
          "prefix": "Look at this meme",
          "suffix": "Shared by Funny Memes...",
          "appPrefix": "Download the app from: ",
          "appLink": "https://play.google.com/store/apps/details?id=com.nextgenkiapp.funnymemes",
          "showAppLink": true
        }
    }
    const responseInit = {
        status: 200,
        headers: {'Content-Type': 'application/json'}
    }
    return new Response(
      JSON.stringify(response),
      responseInit
    )
  }
  
  /**
   * Respond to the request
   * @param {Request} request
   */
  async function handleRequest(request) {
    let pathName = new URL(request.url).pathname;
    switch(pathName) {
      case '/': return statusState()
      case '/config': return successState()
      default: return errorState()
    }
  }
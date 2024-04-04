local errorPageTemplate = [[
    <!DOCTYPE html>
    <html lang="en">
      <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>{{title}}</title>
        <style>
          /* http://meyerweb.com/eric/tools/css/reset/ 
       v2.0 | 20110126
       License: none (public domain)
    */
    
          html,
          body,
          div,
          span,
          applet,
          object,
          iframe,
          h1,
          h2,
          h3,
          h4,
          h5,
          h6,
          p,
          blockquote,
          pre,
          a,
          abbr,
          acronym,
          address,
          big,
          cite,
          code,
          del,
          dfn,
          em,
          img,
          ins,
          kbd,
          q,
          s,
          samp,
          small,
          strike,
          strong,
          sub,
          sup,
          tt,
          var,
          b,
          u,
          i,
          center,
          dl,
          dt,
          dd,
          ol,
          ul,
          li,
          fieldset,
          form,
          label,
          legend,
          table,
          caption,
          tbody,
          tfoot,
          thead,
          tr,
          th,
          td,
          article,
          aside,
          canvas,
          details,
          embed,
          figure,
          figcaption,
          footer,
          header,
          hgroup,
          menu,
          nav,
          output,
          ruby,
          section,
          summary,
          time,
          mark,
          audio,
          video {
            margin: 0;
            padding: 0;
            border: 0;
            font-size: 100%;
            font: inherit;
            vertical-align: baseline;
          }
          /* HTML5 display-role reset for older browsers */
          article,
          aside,
          details,
          figcaption,
          figure,
          footer,
          header,
          hgroup,
          menu,
          nav,
          section {
            display: block;
          }
          body {
            line-height: 1;
          }
          ol,
          ul {
            list-style: none;
          }
          blockquote,
          q {
            quotes: none;
          }
          blockquote:before,
          blockquote:after,
          q:before,
          q:after {
            content: "";
            content: none;
          }
          table {
            border-collapse: collapse;
            border-spacing: 0;
          }
    
          /* Custom CSS */
          body {
            background-color: #292929;
    
            font-family: Arial, Helvetica, sans-serif;
            overflow: hidden;
          }
    
          main {
            display: flex;
            justify-content: center;
            align-items: center;
            flex-direction: column;
            width: 70%;
            height: 100vh;
            margin-top: 1rem;
            margin-left: auto;
            margin-right: auto;
          }
    
          h1 {
            font-size: 3rem;
            font-weight: bold;
            color: #fff;
            text-align: center;
          }
    
          p {
            font-size: 1.5rem;
            color: #fff;
            text-align: center;
          }
        </style>
      </head>
      <body>
        <main>
          <div>
            <p
              style="
                font-size: 1rem;
                color: rgb(200, 200, 200);
                position: absolute;
                top: 1rem;
                right: 0;
                left: 0;
              "
              id="websiteUrl"
            ></p>
          </div>
    
          <div>
            <h1>{{status}}</h1>
    
            <p>{{message}}</p>
          </div>
        </main>
    
        <script>
          document.getElementById("websiteUrl").innerHTML = window.location.href;
        </script>
      </body>
    </html>    
]]

local function errorPage(status, message): string
    return errorPageTemplate:gsub("{{title}}", _G.config.title or "Aurora"):gsub("{{status}}", status):gsub("{{message}}", message)
end

return errorPage
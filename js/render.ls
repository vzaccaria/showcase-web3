
rg =    //
        (                           # wrap whole match in $1
            \[
                [ \t]*
                read
            (
                (?:
                    \[[^\]]*\]      # allow brackets nested one level
                    |
                    [^\[\]]         # or anything else
                )*
            )
            \]
            \(                      # literal paren
            [ \t]*
            ()                      # no id, so leave $3 empty
            <?(                     # href = $4
                (?:
                    \([^)]*\)       # allow one level of (correctly nested) parens (think MSDN)
                    |
                    [^()\s]
                )*?
            )>?                
            [ \t]*
            (                       # $5
                (['"])              # quote char = $6
                (.*?)               # Title = $7
                \6                  # matching quote
                [ \t]*              # ignore any spaces/tabs between closing quote and )
            )?                      # title is optional
            \)
        )
        //

render-text-at = (url, suffix, cb) ->
    data <~ $.get(url)
    render-text(data, suffix)
    if cb? then cb()

replace-markdown-link-at = (text, cb) ->
    mt = rg.exec(text)
    if mt?
        # console.log JSON.stringify(mt, null, 4)
        type = window._.string.trim(mt[2])
        link = window._.string.trim(mt[4])
        # console.log "`#type`"
        data <~ $.get(link)
        new-text = """
        ```#{type}
        #{data}
        ```
        """
        to-be-replaced = text.replace(rg, new-text) 
        cb(to-be-replaced, true)
    else 
        cb(text, false)


split-at-separator = (text) ->
    window._.string.words(text, '---')

convert-index = (converter, index, txt, suffix) -> 
    # console.log txt
    let index,txt 
        replace-markdown-link-at txt, (txt, is-code) ->
            ht = converter.makeHtml(txt)
            # console.log  "\#text#{index}"
            $(ht).appendTo("\##{suffix}#{index}") 
            
            # $("pre code").each( (i, e) ->
            #      hljs.highlightBlock(e, '    '))
            
            $("table").attr('class', 'table table-bordered')
   
render-text = (text, suffix) ->
    converter   = new Showdown.converter({ extensions: [ 'table' ] })
    text-boxes  = split-at-separator(text)
    for index, txt of text-boxes
        convert-index(converter, index, txt, suffix)

load-tty-recording = (url, id) ->
    data <~ $.getJSON(url)
    playterm_player.data = data 
    playterm_player.init id 
    
window.render-text-at = render-text-at




$ = @jQuery ? require 'jQuery'
 
detectBaseline = (el = 'body') ->

  $container = $('<div style="visibility:hidden;"/>')
  $smallA    = $('<span style="visibility:hidden;font-size:0;">A</span>')
  $bigA      = $('<span style="visibility:hidden;font-size:999px;">A</span>')
  
  $container
    .append($smallA).append($bigA)
    .appendTo(el);
  setTimeout (-> $container.remove()), 1 
 
  $smallA.position().top / $bigA.height()
 
$.fn.detect-baseline = ->
  detectBaseline(@get(0))



# class vertical-rythm-machine
#     (@selector) ~>
#         @curr-baseline = $(@selector).detect-baseline()
#         @curr-size     = $(@selector).css('font-size')
#         console.log("#{@selector} - #{@curr-size} - #{@curr-baseline}");


# new vertical-rythm-machine('.word-status')









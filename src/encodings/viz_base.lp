#const color_darkblue="#00305E".
#const color_green="#6F9C68".
#const color_lightgreen="#ADCEA8".
#const color_blue="#5985AF".
#const color_lightblue="#CED6DE".
#const color_red="#CE474F".
#const color_lightred="#DF9CA0".
#const color_yellow="#F0EEDE".
#const color_purple="#9b9bc7".
#const color_organge="#BC7933".
#const color_lightorgange="#F3BD70".

#script (python)
from clingo.symbol import String, Number
def join(base,*args):
    return String(str(base).strip('"').join([str(x).strip('"') for x in args]))

def q2texlbl(mel_f):
    print(mel_f)
    args = mel_f.arguments
    name = mel_f.name
    if len(args)>0:
        interval = args[0]

    if name == "top":
        return r"\top"
    if name == "bottom":
        return r"\bot"
    if name == "initially":
        return r"\bm{\mathsf{I}}"
    if name == "evetually":
        return r"\Diamond"+q2texlbl(args[1])
    if name == "always":
        return r"\square"+q2texlbl(args[1])
    if name == "until":
        return q2texlbl(args[1])+r"\mathsf{U}"+q2texlbl(args[2])
    else:
        return name

def lbl(mel_f):
    print(mel_f)
    args = mel_f.arguments
    name = mel_f.name
    if len(args)>0:
        interval = args[0]
        m = interval.arguments[0]
        n = interval.arguments[1]
        interval_str= f'<FONT POINT-SIZE="5">[{m},{n}]</FONT>'

    if name == "top":
        return "⊤"
    if name == "bottom":
        return "⊥"
    if name == "initially":
        return "𝗜"
    if name == "evetually":
        return "◇"+interval_str+lbl(args[1])
    if name == "always":
        return "◻︎"+interval_str+lbl(args[1])
    if name == "until":
        return lbl(args[1])+"𝕌"+lbl(args[2])
    else:
        return name

def get_lbl(mel_f):
    return String(str(lbl(mel_f)+"<br/>"))

#end.

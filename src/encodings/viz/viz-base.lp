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
#const color_lightgray="#E8E8E8".

#script (python)
from clingo.symbol import String, Number
def join(base,*args):
    return String(str(base).strip('"').join([str(x).strip('"') for x in args]))

interval_operators = ["next","previous","eventually","always","until","release","since","trigger"]
boolean_operators = ["top","bot","initially","finally","if","or","and"]

def lbl(mel_f):
    args = mel_f.arguments
    name = mel_f.name
    if name in interval_operators:
        interval = args[0]
        m = interval.arguments[0]
        n = interval.arguments[1]
        interval_str= f'<FONT POINT-SIZE="5">[{m},{n}]</FONT>'
    if name == "top":
        return "⊤"
    if name == "bot":
        return "⊥"
    if name == "initially":
        return "𝗜"
    if name == "finally":
        return "𝔽"
    if name == "if":
        return lbl(args[0]) + " → " + lbl(args[1])
    if name == "or":
        return lbl(args[0]) + " | " + lbl(args[1])
    if name == "and":
        return lbl(args[0]) + " & " + lbl(args[1])
    if name == "next":
        return "○"+interval_str+lbl(args[1])
    if name == "previous":
        return "●"+interval_str+lbl(args[1])
    if name == "eventually":
        return "◇"+interval_str+lbl(args[1])
    if name == "always":
        return "◻︎"+interval_str+lbl(args[1])
    if name == "until":
        return lbl(args[1])+" 𝕌" +interval_str +lbl(args[2])
    if name == "release":
        return lbl(args[1])+" ℝ" +interval_str +lbl(args[2])
    if name == "since":
        return lbl(args[1])+" 𝗦" +interval_str +lbl(args[2])
    if name == "trigger":
        return lbl(args[1])+" 𝗧" +interval_str +lbl(args[2])
    else:
        return '<I>' + str(mel_f) +"</I>"

def get_lbl(mel_f):
    l = str(lbl(mel_f))
    return String(l+"<br ALIGN='LEFT'/>")

#end.

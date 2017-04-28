package hamlit;

import java.util.Arrays;

import org.jruby.Ruby;
import org.jruby.RubyClass;
import org.jruby.RubyObject;
import org.jruby.anno.JRubyClass;
import org.jruby.anno.JRubyMethod;
import org.jruby.runtime.ThreadContext;
import org.jruby.runtime.builtin.IRubyObject;
import org.jruby.javasupport.util.RuntimeHelpers;

@JRubyClass(name="Hamlit::Utils")
public class Utils extends RubyObject {
    public Utils(Ruby ruby, RubyClass klass) {
        super(ruby, klass);
    }

    @JRubyMethod(name="escape_html", meta = true, required = 1)
    public static IRubyObject buildClass(ThreadContext context, IRubyObject klass, IRubyObject value) {
        String str = RuntimeHelpers.invoke(context, value, "to_s").toString();
        return context.getRuntime().newString(escapeHtml(str));
    }

    private static String escapeHtml(String str) {
        return str
            .replace("&", "&amp;")
            .replace("\"", "&quot;")
            .replace("'", "&#39;")
            .replace("<", "&lt;")
            .replace(">", "&gt;");
    }
}

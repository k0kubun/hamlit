package hamlit;

import java.util.Arrays;

import org.jruby.Ruby;
import org.jruby.RubyArray;
import org.jruby.RubyString;
import org.jruby.RubyClass;
import org.jruby.RubyObject;
import org.jruby.anno.JRubyClass;
import org.jruby.anno.JRubyMethod;
import org.jruby.runtime.ThreadContext;
import org.jruby.runtime.builtin.IRubyObject;
import org.jruby.javasupport.util.RuntimeHelpers;

@JRubyClass(name="Hamlit::AttributeBuilder")
public class AttributeBuilder extends RubyObject {
    public AttributeBuilder(Ruby ruby, RubyClass klass) {
        super(ruby, klass);
    }

    @JRubyMethod(name="build_class", meta = true, required = 2, rest = true)
    public static IRubyObject buildClass(ThreadContext context, IRubyObject klass, IRubyObject[] args) {
        IRubyObject escapeAttrs = args[0];
        switch (args.length) {
            case 2:
                return buildSingleClass(context, args[0], args[1]);
            default:
                return buildMultiClass(context, args[0], Arrays.copyOfRange(args, 1, args.length));
        }
    }

    private static IRubyObject buildSingleClass(ThreadContext context, IRubyObject escapeAttrs, IRubyObject value) {
        if (value instanceof RubyString) {
            // noop
        } else if (value instanceof RubyArray) {
            value = RuntimeHelpers.invoke(context, value, "flatten");
            deleteFalseyValues((RubyArray)value);
            value = RuntimeHelpers.invoke(context, value, "join", context.getRuntime().newString(" "));
        } else if (value.isTrue()) {
            value = RuntimeHelpers.invoke(context, value, "to_s");
        } else {
            value = context.getRuntime().newString("");
        }
        return escapeAttribute(context, escapeAttrs, value);
    }

    private static IRubyObject buildMultiClass(ThreadContext context, IRubyObject escapeAttrs, IRubyObject[] values) {
        IRubyObject buf = RubyArray.newArray(context.getRuntime());

        for (int i = 0; i < values.length; i++) {
            IRubyObject value = values[i];
            if (value instanceof RubyString) {
                value = RuntimeHelpers.invoke(context, value, "split", context.getRuntime().newString(" "));
                RuntimeHelpers.invoke(context, buf, "concat", value);
            } else if (value instanceof RubyArray) {
                value = RuntimeHelpers.invoke(context, value, "flatten");
                deleteFalseyValues((RubyArray)value);
                RuntimeHelpers.invoke(context, buf, "concat", value);
            } else if (value.isTrue()){
                value = RuntimeHelpers.invoke(context, value, "to_s");
                RuntimeHelpers.invoke(context, buf, "push", value);
            }
        }

        RuntimeHelpers.invoke(context, buf, "sort!");
        RuntimeHelpers.invoke(context, buf, "uniq!");
        IRubyObject result = RuntimeHelpers.invoke(context, buf, "join", context.getRuntime().newString(" "));
        return escapeAttribute(context, escapeAttrs, result);
    }

    private static void deleteFalseyValues(RubyArray values) {
        for (int i = values.length().getIntValue() - 1; 0 <= i; i--) {
            IRubyObject value = values.entry(i);
            if (!value.isTrue()) {
                values.delete_at(i);
            }
        }
    }

    private static IRubyObject escapeAttribute(ThreadContext context, IRubyObject escapeAttrs, IRubyObject str) {
        if (escapeAttrs.isTrue()) {
            return context.getRuntime().newString(Utils.escapeHtml(str.toString()));
        } else {
            return str;
        }
    }
}

package hamlit;

import org.jruby.Ruby;
import org.jruby.RubyModule;
import org.jruby.runtime.load.BasicLibraryService;

public class HamlitService implements BasicLibraryService {
    public boolean basicLoad(Ruby ruby) {
        init(ruby);
        return true;
    }

    private void init(Ruby ruby) {
        RubyModule hamlit = ruby.defineModule("Hamlit");
        RubyModule utils = hamlit.defineModuleUnder("Utils");
        utils.defineAnnotatedMethods(Utils.class);
    }
}

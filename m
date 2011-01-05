From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: What is OFED? (vs in-kernel drivers)
Date: Wed, 5 Jan 2011 12:18:47 -0700
Message-ID: <20110105191847.GB1211@obsidianresearch.com>
References: <4D246301.40006@shiftmail.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="TB36FDmn/VVEgNH/"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4D246301.40006-9AbUPqfR1/2XDw4h08c5KA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jabe <jabe.chapman-9AbUPqfR1/2XDw4h08c5KA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 05, 2011 at 01:24:33PM +0100, Jabe wrote:
> Excuse the newbie question...
> What is the relationship between OFED and in-kernel infiniband
> drivers?

They are related but separate. OFED started as a way to deliver IB
driver code and supporting userspace to Enterprise (ie old) operating
systems. In that sense it is a back port project. But it also evolved
to accept patches to the backports before those patches made it into
newline, so in that sense it is also a new development project.

AFAIK 100% of the patches from the mainline are incorporated into
OFED, but the reverse is currently not true.

If you need something that is OFED only then you should use OFED and
an OFED supported distro. Everything in OFED can be build pretty easy
from git for ubuntu, including the mellanox flash tools.

> I am on ubuntu + vanilla kernel. What is the suggested approach to
> install ofed in ubuntu? I see there are rpms but not debs: should I
> go with git?

Ubuntu maverick comes with a good kernel side, but the user space is
old. I generally build from git for my Ubuntu machines. I've attached
a script that does the job, quick and easy:

$ apt-get install gcc flex bison automake libtool autoconf
$ mkdir /opt/ofa
$ cd /opt/ofa
$ ofabuild clone
$ ofabuild build -V ofa-1.5.1 -p /opt/ofa-1.5.1

But the install goes into /opt, not /usr/lib so you have to use
something like

LD_LIBRARY_PATH=/opt/ofa-1.5.1/lib/
CPPFLAGS=-I/opt/ofa-1.5.1/include LDFLAGS="-L/opt/ofa-1.5.1/lib/ -Wl,-rpath=/opt/ofa-1.5.1/lib/"
PATH=$PATH:/opt/ofa-1.5.1/bin:/opt/ofa-1.5.1/sbin

When building other stuff.

On the other hand you can have multiple releases install for testing
that too..

This builds 'approximately' what is in OFED 1.5.1 without any of the
OFED patches directly from git.

Jason

--TB36FDmn/VVEgNH/
Content-Type: text/x-python; charset=us-ascii
Content-Disposition: attachment; filename="ofabuild.py"

#! /usr/bin/env python
# This script placed under the GPLv2 or later.

from __future__ import with_statement;
import sys,os,optparse,inspect,traceback,subprocess,re,collections
from contextlib import *;

components = {
    "libibverbs": {
        "URI": "git://git.kernel.org/pub/scm/libs/infiniband/libibverbs.git",
        },
    "libibcm": {
        "URI": "git://git.openfabrics.org/~shefty/libibcm.git",
        "depends": ("libibverbs",),
        },
    # "libibsa":
    "libmlx4": {
        "URI": "git://git.kernel.org/pub/scm/libs/infiniband/libmlx4.git",
        "depends": ("libibverbs",),
        },
    "libmthca": {
        "URI": "git://git.kernel.org/pub/scm/libs/infiniband/libmthca.git",
        "depends": ("libibverbs",),
        },
    "libipathverbs": {
        "URI": "git://git.openfabrics.org/~ralphc/libipathverbs.git",
        "depends": ("libibverbs",),
        },
    "libnes": {
        "URI": "git://git.openfabrics.org/~ctung/libnes.git",
        "depends": ("libibverbs",),
        },
    "librdmacm": {
        "URI": "git://git.openfabrics.org/~shefty/librdmacm.git",
        "depends": ("libibverbs",),
        },
    "management": {
        "URI": "git://git.openfabrics.org/~sashak/management.git",
        "buildRoot": None,
        },
    "perftest": {
        "URI": "git://git.openfabrics.org/~shamoya/perftest.git",
        "buildRoot": None,
        "depends": ("libibverbs",),
        },

    "opensm": {
        "inside": "management",
        "buildRoot": "opensm",
        "depends": ("libibmad",),
        },
    # IB Common has been removed in newer releases
    "libibcommon": {
        "inside": "management",
        "buildRoot": "libibcommon",
        },
    "libibumad": {
        "inside": "management",
        "buildRoot": "libibumad",
        "depends": ("libibcommon",),
        },
    "libibmad": {
        "inside": "management",
        "buildRoot": "libibmad",
        "depends": ("libibumad",),
        },
    "infiniband-diags": {
        "inside": "management",
        "buildRoot": "infiniband-diags",
        "depends": ("libibmad","libibverbs","opensm"),
        },
    };

versionSet = {
    "ofa-1.5.1": {
        "libibverbs": "libibverbs-1.1.4",
        "libibcm": "1.0.5",
        "libmlx4": "libmlx4-1.0",
        "libmthca": "libmthca-1.0.5",
        "libipathverbs": "35a0caac4868136d4eb85d84768fa9ec4eb83293",
        "libnes": "c731f12630a0c42d19270a65b7cbc7fe7c9f1276",
        "librdmacm": "v1.0.13",
        "opensm": "opensm-3.3.5",
        "libibcommon": None,
        "libibumad": "libibumad-1.3.4",
        "libibmad": "libibmad-1.3.4",
        "infiniband-diags": "infiniband-diags-1.5.5",
        },

    "ofa-1.4.1": {
        "libibverbs": "libibverbs-1.1.2",
        "libibcm": "v1.0.4",
        "libmlx4": "libmlx4-1.0",
        "libmthca": "libmthca-1.0.5",
        "libipathverbs": "337df3c1cbe43c3e9cb58e7f6e91f44603dd23fb",
        "librdmacm": "v1.0.8",
        "opensm": "da4775b4b832afa9f89954ccdd502e1b9701f132", # "opensm-3.2.6",
        "libibumad": "dd5aa2cebc760f239b965c87388ffe9b0401c5d2", # ? "libibumad-1.2.3",
        "libibmad": "dd5aa2cebc760f239b965c87388ffe9b0401c5d2", # ? "libibmad-1.2.3",
        "infiniband-diags": "b6d92f16d846bf55528502e3fa77429d3277fad5", # "infiniband-diags-1.4.4",
        "libibcommon": "6556babd612d54e0cb2a7428099cc7d18d58ae16", # "libibcommon-1.1.2"
        },

    # HEAD means don't change the git checkouts
    "HEAD": dict((k,"HEAD") for k in components.iterkeys()),

    # origin means use the remote, ie top of tree.
    "origin": dict((k,"origin/master") for k in components.iterkeys()),
    };
versionSet["HEAD"]["libibcommon"] = None;
versionSet["origin"]["libibcommon"] = None;

def componentURIs(I):
    uris = components[I].get("URI",());
    if isinstance(uris,tuple):
        return uris
    return (uris,);

def getSrcPath(comp):
    cdata = components[comp];
    if "inside" in cdata:
        return "%s/%s"%(cdata["inside"],cdata.get("buildRoot",""))
    return comp;

class MyHelpFormatter(optparse.IndentedHelpFormatter):
    def format_usage(self, usage):
        return usage + "\n";

class MyOptParse(optparse.OptionParser):
    def __init__(self,option_list = [],description = None,
                 expected_values = -1):
        optparse.OptionParser.__init__(self,option_list=option_list,
                                       description=description,
                                       formatter=MyHelpFormatter());
        self.expected_values = expected_values;

        self.current_command = traceback.extract_stack(limit=2)[0][2];
        self.set_usage(inspect.getdoc(globals()[self.current_command]));

    def parse_args(self,args,values = None):
        (args,values) = optparse.OptionParser.parse_args(self,args,values);
        if self.expected_values != -1 and \
           len(values) != self.expected_values:
            self.error("Got %u arguments but expected %u"%(len(values),
                                                        self.expected_values));
        return (args,values);

    def error(self,msg):
        print msg;
        sys.exit(2);

@contextmanager
def inDirectory(dir):
    cdir = os.getcwd();
    try:
        os.chdir(dir);
        yield True;
    finally:
        os.chdir(cdir);

def shCmd(args,allowfail=False):
    print args
    sys.stdout.flush();
    p = subprocess.Popen(args=args);
    p.wait();
    if not allowfail and p.returncode:
        raise subprocess.CalledProcessError(p.returncode,args[0]);

def shCmdToStr(args,allowfail=False):
    sys.stdout.flush();
    p = subprocess.Popen(args=args,stdout=subprocess.PIPE);
    res = p.communicate()[0];
    if not allowfail and p.returncode:
        raise subprocess.CalledProcessError(p.returncode,args[0]);
    return res;

def cmd_clone(argv):
    """Clone or fetch all of the required git repositories.
       Usage: %prog clone

       The repositories are all cloned into the current directory."""
    o = MyOptParse(expected_values = 0);
    (args,values) = o.parse_args(argv);

    for I in components.iterkeys():
        uris = componentURIs(I)
        if not uris:
            continue;

        if not os.path.exists(I):
            shCmd(["git","clone","-s",uris[0],I]);
            uris = uris[1:];
        with inDirectory(I):
            for U in uris:
                shCmd(["git","fetch",U,
                       "+refs/heads/*:refs/remotes/origin/*"]);

def doPrepare(itms,vset):
    """This gets everything ready to go, notably running autogen.sh
    which has to be done on a machine with a fairly new libtool/etc/"""
    itms = [(comp,vset[comp],getSrcPath(comp))
            for comp in itms]
    for comp,version,src in itms:
        if version == None:
            continue;
        print "Cleaning up",comp
        with inDirectory(src):
            if os.path.exists("build/."):
                shCmd(["rm","-rf","build/"]);
            os.system("git ls-files -z -o | xargs -0 rm -f");
            os.mkdir("build/");

    for comp,version,src in itms:
        if version == None:
            continue;
        print "Autoconfing",comp
        with inDirectory(src):
            # Refresh the index so that --hard doesn't muck timestamps up
            os.system("git status > /dev/null");
            shCmd(["git","reset","--hard",version]);
            shCmd(["./autogen.sh"]);

def doBuild(dest,comp,version):
    src = getSrcPath(comp);

    print "Building",comp
    with inDirectory(src):
        # Refresh the index so that --hard doesn't muck timestamps up
        os.system("git status > /dev/null");
        shCmd(["git","reset","--hard",version]);
        head = shCmdToStr(["git","rev-parse","HEAD"]).strip();
        headDesc = shCmdToStr(["git","describe","--tags","HEAD"],True).strip();

        if os.path.exists("build/."):
            shCmd(["rm","-rf","build/"]);
        os.mkdir("build/");
        os.chdir("build");

        shCmd(["../configure","--prefix=%s"%(dest),
               "--with-perl-installdir=%s/lib/perl"%(dest),
               "--cache-file=%s/config.cache"%(dest),
               ]);
        shCmd(["make"]);
        shCmd(["make","install"]);
        return head,headDesc

def fixDrivers(dest):
    """Make the paths to the libibverbs hardware driver be absolute"""
    with inDirectory("%s/etc/libibverbs.d/"%(dest)):
        for fn in os.listdir("."):
            if fn.find(".driver") == -1:
                continue;

            with file(fn,"r") as inf:
                lines = inf.readlines();
            with file(fn,"wt") as outf:
                for I in lines:
                    print >> outf, re.sub("^driver ([^/]+)$","driver %s/lib/lib\\1"%(dest),
                                          I);

def getArgs(args,dest):
    if args.version:
        if args.version not in versionSet:
            o.error("Bad version '%s'"%(args.version));
        vset = versionSet[args.version];
    else:
        vset = versionSet["origin"];

    if dest:
        if dest[-1] == '/':
            dest = dest[:-1];
            if not os.path.exists(dest + "/share/man/."):
                os.makedirs("%s/share/man/"%(dest));
    return vset,dest;

def cmd_build(argv):
    """Perform the build sequence.
       Usage: %prog build [-V VER] [-p] dest_dir

       If VER is specified then that version of the OFA collection is built,
       otherwise the top of tree of everything is built.

       VER can be one of $(VERSET)."""
    o = MyOptParse(expected_values = 1);
    o.set_usage(o.get_usage().strip().replace("$(VERSET)",str(versionSet.keys())));
    o.add_option('-V', '--version', dest='version',
                 help="Set the OFA version set to use");
    o.add_option('-p', '--no-prepare', action="store_true", dest='no_prepare',
                 help="Assume the source trees have already been prepared");
    (args,values) = o.parse_args(argv);
    (vset,dest) = getArgs(args,values[0]);

    done = set(k for k,v in components.iteritems() if
               v.get("buildRoot","") == None or vset[k] == None);
    todo = set(components.iterkeys())
    todo.difference_update(done);

    if not args.no_prepare:
        doPrepare(todo,vset);

    os.putenv("LD_LIBRARY_PATH","%s/lib"%(dest));
    os.putenv("LDFLAGS","-L%s/lib -Wl,-rpath=%s/lib"%(dest,dest));
    os.putenv("CPPFLAGS","-I%s/include"%(dest));

    refs = {};
    while todo:
        for cur in todo:
            deps = components[cur].get("depends",());
            if done.issuperset(set(deps)):
                break;
        else:
            print todo;
            print done;
            o.error("Can't find something to do!?");

        refs[cur] = doBuild(dest,cur,vset[cur]);
        done.add(cur);
        todo.remove(cur);

    print "Fixing path to the libibverbs drivers."
    fixDrivers(dest);

    with file("%s/git-refs"%(dest),"wt") as outf:
        for k,v in refs.iteritems():
            print >> outf,"%s %s\n\t%s"%(k,v[1],v[0]);

def cmd_prepare(argv):
    """Just prepare the source trees for building.
       Usage: %prog build [-V VER]

       If VER is specified then that version of the OFA collection is
       prepared, otherwise the top of tree of everything is prepared.
       Preparation needs to be done on a machine with a recent
       libtool/autotools setup since many of the repositories require
       that. After this the directories can be copied to another machine
       to actually build.

       VER can be one of $(VERSET)."""
    o = MyOptParse(expected_values = 0);
    o.set_usage(o.get_usage().strip().replace("$(VERSET)",str(versionSet.keys())));
    o.add_option('-V', '--version', dest='version')
    (args,values) = o.parse_args(argv);
    (vset,dest) = getArgs(args,None);

    done = set(k for k,v in components.iteritems() if v.get("buildRoot","") == None);
    todo = set(components.iterkeys())
    todo.difference_update(done);
    doPrepare(todo,vset);

def cmd_help(argv):
    """Display the help text
       Usage: %prog help"""
    if len(argv) == 0:
        # Abuse the optparse help formatter to format the help text for
        # our commands
        class Formatter(MyHelpFormatter):
            def format_option(self, option):
                if option.action == "help":
                    self.option_strings[option] = "help";
                else:
                    self.option_strings[option] = self.option_strings[option][3:];
                return MyHelpFormatter.format_option(self,option);

        o = MyOptParse();
        for k,v in sorted(commands.items()):
            doc = inspect.getdoc(v);
            doc = [i for i in doc.split("\n") if len(i) != 0];
            o.add_option("--x" + k,action="store_true",help=doc[0]);

        print "Script to fetch and build OFA libraries"
        print "Usage: ofabuild command [args]"
        print
        print o.format_option_help(Formatter());
        print "ofabuild help [command] shows detailed help for each command";
        return;

    if len(argv) == 1 and commands.has_key(argv[0]):
        commands[argv[0]](["--help"]);
    else:
        print "No help text for %s"%(argv);
    return True;

# Generate the global command map
commands = {};
for k,v in globals().items():
    if k[:4] == "cmd_" and inspect.isfunction(v):
        cmd = k[4:].replace('_','-');
        commands[cmd] = v;

if len(sys.argv) == 1:
    cmd_help([]);
    sys.exit(0);

argv = sys.argv[2:];
cmd = sys.argv[1];
if commands.has_key(cmd):
    if not commands[cmd](argv):
        sys.exit(100);
else:
    sys.stderr.write("Bad command %s\n"%(sys.argv[1]));
    sys.exit(1);

--TB36FDmn/VVEgNH/--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

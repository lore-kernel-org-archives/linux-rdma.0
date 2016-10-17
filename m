From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 2/4] glue/redhat: add udev/systemd/etc
 infrastructure bits
Date: Mon, 17 Oct 2016 11:31:37 -0600
Message-ID: <20161017173137.GA6430@obsidianresearch.com>
References: <20161014192136.11731-1-jarod@redhat.com>
 <20161014192136.11731-3-jarod@redhat.com>
 <20161014231934.GC16509@obsidianresearch.com>
 <1e03ceea-5584-6bbb-6fbe-e11d9d251649@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1e03ceea-5584-6bbb-6fbe-e11d9d251649-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Oct 16, 2016 at 10:40:27AM -0400, Doug Ledford wrote:
> >> +Requires=rdma.service
> >> +After=rdma.service opensm.service
> > 
> > This is the only RH specific thiing I see.. Could we standardize on
> > something here and use it on all distros? rdma-available.target?
> 
> You can't, unless you rename the rdma.service unit file to something
> else.  They are tied in that way.

Well, I don't really care about names too much, rdma-whatever.target
is fine...

> >> +++ b/glue/redhat/rdma.cxgb4.sys.modprobe
> >> @@ -0,0 +1 @@
> >> +install cxgb4 /sbin/modprobe --ignore-install cxgb4 $CMDLINE_OPTS && /sbin/modprobe iw_cxgb4
> > 
> > What are these for? Should they be cross distro? Why are only a few
> > drivers this special?
> 
> We have one of these for every two (or more) part driver.  They aren't
> special, it's just the multipart drivers that are.

So, should we move them into the provider directories? Or patch some
kind of request_module into the kernel?

> > I wonder if this could be split into a generic 'load the modules' part
> > and a distro specific part? Every distro needs systemd to load the
> > extra modules because out auto-loading is broken - IMHO, and that is
> > pretty complex unfortunately.
> 
> Yes, this probably could be broken out.

So, I think the 'systemd way' would be a rdma-load-modules.service
onshot and a rdma-whatever.target

This way a distro can add their other stuff with additional drops ins,
eg rdma-bios-fixup.service (after load-modules, before
rdma-whatever.target)

> >> +[Unit]
> >> +Description=Initialize the iWARP/InfiniBand/RDMA stack in the kernel
> >> +Documentation=file:/etc/rdma/rdma.conf
> >> +RefuseManualStop=true
> >> +DefaultDependencies=false
> >> +Conflicts=emergency.target emergency.service
> >> +Before=network.target remote-fs-pre.target
> > 
> > This is an area we really need to cross-distro standardize - we really
> > need a set of rdma-*.targets.
> > 
> > eg
> >  rdma-available.target
> >    - RDMA hardware is available and all prep is done
> >      opensm (if installed) is started, etc
> >      Use in place of rdma.service
> >   rdma-detected.target
> >    - udev detected rdma hardware
> 
> It's not that easy, unfortunately.  Creating a target is a big deal.

Okay, do you mean big deal in the sense we need to get approval from
systemd folks or something? We are a big grown up subsystem now, and
good systemd integration is very important to a good user experience
these days.

I think we are in a better place now, because the target(s) *really*
needs to be cross distro and maintained 'upstream' - rdma-core is the
natural place to do that.

> I could be wrong).  I would have thought it means "Start this unit
> before starting the target listed in the Before= line", instead it
> means "Start this unit and make sure it finishes before the target
> in the Before= line is considered complete".  It can be started
> after the listed target is started, but the listed target won't be
> considered complete until it is also complete.

I'm not sure I follow the issue?

Your description matches how I understand systemd - a .target will not
become ready until all the prerequisits reach a 'ready' state (eg a
oneshot script completes). As the target does not become 'ready' until
its prerequisites are all 'ready', and dependents never start until
the parent is 'ready', this provides a reliable ordering sequence
point in the startup.

The order of starting is simply that target prerequisites are started
before the target becomes ready.

When systemd enabling anything it is important to keep in mind the
distinction between 'started' and 'ready' - and broadly speaking, our
daemons do not do this correctly today :/.

So the design goal is to make a target(s) that indicates enough of the
RDMA core systems is 'ready' so that we can begin to start things that
use rdmacm, etc.

We have problems with our daemons not properly interacting with
systemd to indicate 'ready', and that will cause bugs, but the overall
idea should be sound.

So this is a sketch of what I am thinking about.

rdma-fix-bios.service:
 [Unit]
 Type=oneshot
 Before=rdma-available.target, rdma-load-modules.service
rdma-load-modules.service:
 [Unit]
 Type=oneshot
 Before=rdma-available.target
iwpmd.service:
 [Unit]
 After=rdma-load-modules.service
 Before=rdma-available.target
opensm.service:
 [Unit]
 After=rdma-load-modules.service
 Before=rdma-available.target

rdma-available.target:
 [Unit]
 Description=Target indicating that the RDMA kernel stack is setup for user use.

srp_daemon.service:
 [Unit]
 After=rdma-available.target
 Before=remote-fs-pre.target

'Type=oneshot' will prevent anything past rdma-available.target from
starting until the scripts complete.

Internal ordering in the 'before' section has stuff like opensm and
iwpmd taken care of, and all 'user' daemons have a clear single
.target to depend on that works no matter what the distro or
underlying RDMA protocol.

To be clear, I'm proposing something like this as a goal, there will
certainly be some needed work on the C daemons to get there:
 - iwpmd forks in the wrong place, it needs to fork after it sets up
   netlink, or stop forking and use sd_notify. (or even better, we
   should figure out how to use ListenNetlink !!)
 - ibacmd needs to use socket activation/sd_notify/fork order to ensure
   acm is started before rdma cm users start
 - srp_daemon needs to respond to dynamic prefix changes and probably
   use sd_notify/fork order to indicate that it is OK to move on to
   mounting FS.

Why is this more important now?
 1) There are more SM's than opensm, it makes those peoples lives
    very hard if 'opensm' is hardcoded into all the service files for
    correctness, hard to swap out opensm with something else. Eg hfi
    does not use opensm.
 2) iwarp is involved in all of this too, and we need to start iwpmd
    before moving on to other services that might need rdmacm. Ditto
    for ibacm
 3) Things like rxe could use additional 'before' service plugins to
    enable rxe mode on interfaces.

So, I think this is a subject worth tackling.. (over the long term,
let us not block Jarod's stuff)

The goal would be to standardize the .target names and be able to use
upstream .service files for many of the things, and allow
distros/users/other to reliably 'drop in' additional stuff (eg the
bios-fixup) at various well defined sequence points.

> Fortunately, the targets listed in the unit files are pretty standard
> (they are part of the systemd upstream), and so I think they can be
> cross distro just as they are.

Sure, the pre-existing targets are, it is stuff like opensm.service
that seems off to me.

> >> +Description=Start or stop the daemon that attaches to SRP devices
> >> +Documentation=file:///etc/rdma/rdma.conf file:///etc/srp_daemon.conf
> >> +DefaultDependencies=false
> >> +Conflicts=emergency.target emergency.service
> >> +Requires=rdma.service
> >> +Wants=opensm.service
> >> +After=rdma.service opensm.service
> >> +After=network.target
> >> +Before=remote-fs-pre.target
> > 
> > Also should be common, why does it reference opensm.service?
> 
> Because if opensm is running on this host, then it must be up before the
> configured srp targets are valid any time there is a non-default subnet
> prefix.

Well, that kinda sounds like a srp_daemon bug - how does it work
race-free with an external SM?

Even with an on-node opensm, how does this work without a race?  Is
After=opensm.service enough to assert that opensm has completed a
sweep and assigned the subnet prefix?

If we can have srp_daemon respond to dynamic changes in the subnet
prefix can we drop this from the unit file?

> >> +[Service]
> >> +Type=simple
> >> +ExecStart=/usr/sbin/srp_daemon.sh
> > 
> > Hurm, someday we have to make better systemd integration for these
> > daemons..
> 
> There really isn't any better integration to get with our complex
> daemons unless we update the daemons themselves to get rid of their
> shell script starters...

Exactly, update the daemons.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

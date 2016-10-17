From: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-core 2/4] glue/redhat: add udev/systemd/etc
 infrastructure bits
Date: Mon, 17 Oct 2016 12:22:21 -0400
Message-ID: <20161017162221.GI14983@redhat.com>
References: <20161014192136.11731-1-jarod@redhat.com>
 <20161014192136.11731-3-jarod@redhat.com>
 <20161014231934.GC16509@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161014231934.GC16509-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Oct 14, 2016 at 05:19:34PM -0600, Jason Gunthorpe wrote:
> On Fri, Oct 14, 2016 at 03:21:34PM -0400, Jarod Wilson wrote:
> > Red Hat has been shipping an "rdma" package, as well as it's own systemd
> > unit files for some daemons for a while now, in both Fedora and Red Hat
> > Enterprise Linux. Some of these are fairly RH-specific, but might be of
> > use to others, so we'd like to move them into the upstream source tree.
> 
> We have a directory called 'debian', so lets just have one called
> 'redhat'..

Worksforme. As mentioned in reply to Leon, I really don't care what the
directory is called, just that we get this stuff out there, instead of
being in our own custom glue package. I do think maybe Leon's suggestion
of having a directory to put a bunch of distro-specific directories under
would be good for cleanliness, but I also seem to recall that debian
actually looks for a directory in the root of the tarball, so it may need
to stay like it is.

> The below comments are my view on what we should try and move into
> common cross-distro locations..

I should have been more clear: some of this is just an initial dump of
everything we ship, and there's absolutely a desire to extract anything
from this pile that is generic and usable by all distros into a common
location. Just pressed for time, and sending it out this way was the
fastest way to get it in front of eyeballs. :)

> Common stuff should be installed via cmake
> 
> > diff --git a/glue/redhat/ibacm.service b/glue/redhat/ibacm.service
> > new file mode 100644
> > index 0000000..1cd031a
> > +++ b/glue/redhat/ibacm.service
> 
> Can we just put this in ibacm/ ?

Probably.

> > +Requires=rdma.service
> > +After=rdma.service opensm.service
> 
> This is the only RH specific thiing I see.. Could we standardize on
> something here and use it on all distros? rdma-available.target?

I'll defer to what Doug said on this one.

> > +++ b/glue/redhat/iwpmd.service
> > @@ -0,0 +1,12 @@
> > +[Unit]
> > +Description=Starts the IWPMD daemon
> > +Documentation=file:///usr/share/doc/iwpmd/README
> 
> File does not exit? There is a man page now
> 
> We already have a iwpmd/iwpmd.service that is almost identical, can you
> you just update it and drop this version?

Bah, that's a carryover from our individually packaged iwpmd, didn't look
closely enough. Can we merge a bit from ours into the 'stock' one? The
main relevant difference I see is we have ours set to load after
syslog.target as well as network.target.

> > +++ b/glue/redhat/rdma.cxgb3.sys.modprobe
> > @@ -0,0 +1 @@
> > +install cxgb3 /sbin/modprobe --ignore-install cxgb3 $CMDLINE_OPTS && /sbin/modprobe iw_cxgb3
> > diff --git a/glue/redhat/rdma.cxgb4.sys.modprobe b/glue/redhat/rdma.cxgb4.sys.modprobe
> > new file mode 100644
> > index 0000000..44163ab
> > +++ b/glue/redhat/rdma.cxgb4.sys.modprobe
> > @@ -0,0 +1 @@
> > +install cxgb4 /sbin/modprobe --ignore-install cxgb4 $CMDLINE_OPTS && /sbin/modprobe iw_cxgb4
> 
> What are these for? Should they be cross distro? Why are only a few
> drivers this special?

What Doug said.

> > +++ b/glue/redhat/rdma.fixup-mtrr.awk
> > @@ -0,0 +1,160 @@
> > +# This is a simple script that checks the contents of /proc/mtrr to see if
> > +# the BIOS maker for the computer took the easy way out in terms of
> > +# specifying memory regions when there is a hole below 4GB for PCI access
> > +# and the machine has 4GB or more of RAM.  When the contents of /proc/mtrr
> > +# show a 4GB mapping of write-back cached RAM, minus punch out hole(s) of
> > +# uncacheable regions (the area reserved for PCI access), then it becomes
> > +# impossible for the ib_ipath driver to set write_combining on its PIO
> > +# buffers.  To correct the problem, remap the lower memory region in various
> > +# chunks up to the start of the punch out hole(s), then delete the punch out
> > +# hole(s) entirely as they aren't needed any more.  That way, ib_ipath will
> > +# be able to set write_combining on its PIO memory access region.
> 
> Yuk, a thousand times yuk.
> 
> I thought the mtrr cleanup built into modern kernel took care of this?
> 
> Really though, this needs to be fixed upstream in the kernel :|

Yeah, this is still floating around for hysterical raisins, as Doug said.
We might be able to drop this, or at least relegate it to a dark corner
with a huge warning label...

> > diff --git a/glue/redhat/rdma.kernel-init b/glue/redhat/rdma.kernel-init
> > new file mode 100644
> > index 0000000..6cb4732
> > +++ b/glue/redhat/rdma.kernel-init
> 
> I wonder if this could be split into a generic 'load the modules' part
> and a distro specific part? Every distro needs systemd to load the
> extra modules because out auto-loading is broken - IMHO, and that is
> pretty complex unfortunately.

Possibly. Not sure how much you'd save by splitting it though, the added
complexity of playing connect the dots to see how things come up could be
counter-productive. Haven't looked very closely at that though.

> > +errata_58()
> > +{
> > +    # Check AMD chipset issue Errata #58
> > +    if test -x /sbin/lspci && test -x /sbin/setpci; then
> > +	if ( /sbin/lspci -nd 1022:1100 | grep "1100" > /dev/null ) &&
> > +	   ( /sbin/lspci -nd 1022:7450 | grep "7450" > /dev/null ) &&
> > +	   ( /sbin/lspci -nd 15b3:5a46 | grep "5a46" > /dev/null ); then
> > +	    CURVAL=`/sbin/setpci -d 1022:1100 69`
> 
> Another yuk. Why isn't this handled upstream in drivers/pci/quirks.c
> with the rest of the 8131 errata?
> 
> Fortunately I expect all 8131 hardware is long since gone, that chip
> was end-of-manufacturing'd very quickly 2003ish IIRC.

More hysterical raisins.

> > +++ b/glue/redhat/rdma.service
> > @@ -0,0 +1,15 @@
> > +[Unit]
> > +Description=Initialize the iWARP/InfiniBand/RDMA stack in the kernel
> > +Documentation=file:/etc/rdma/rdma.conf
> > +RefuseManualStop=true
> > +DefaultDependencies=false
> > +Conflicts=emergency.target emergency.service
> > +Before=network.target remote-fs-pre.target
> 
> This is an area we really need to cross-distro standardize - we really
> need a set of rdma-*.targets.
> 
> eg
>  rdma-available.target
>    - RDMA hardware is available and all prep is done
>      opensm (if installed) is started, etc
>      Use in place of rdma.service
>   rdma-detected.target
>    - udev detected rdma hardware

Deferring to Doug ehre too.

> > +++ b/glue/redhat/rdma.udev-ipoib-naming.rules
> > @@ -0,0 +1,13 @@
> > +# This is a sample udev rules file that demonstrates how to get udev to
> > +# set the name of IPoIB interfaces to whatever you wish.  There is a
> > +# 16 character limit on network device names though, so don't go too nuts
> > +#
> > +# Important items to note: ATTR{type}=="32" is IPoIB interfaces, and the
> > +# ATTR{address} match must start with ?* and only reference the last 8
> > +# bytes of the address or else the address might not match on any given
> > +# start of the IPoIB stack
> > +#
> > +# Note: as of rhel7, udev is case sensitive on the address field match
> > +# and all addresses need to be in lower case.
> > +#
> > +# ACTION=="add", SUBSYSTEM=="net", DRIVERS=="?*", ATTR{type}=="32", ATTR{address}=="?*00:02:c9:03:00:31:78:f2", NAME="mlx4_ib3"
> 
> This should be a cross distro file.
> 
> > +++ b/glue/redhat/rdma.udev-rules
> > @@ -0,0 +1,18 @@
> > +# We list all the various kernel modules that drive hardware in the
> > +# InfiniBand stack (and a few in the network stack that might not actually
> > +# be RDMA capable, but we don't know that at this time and it's safe to
> > +# enable the IB stack, so do so unilaterally) and on load of any of that
> > +# hardware, we trigger the rdma.service load in systemd
> > +
> > +SUBSYSTEM=="module", KERNEL=="cxgb*", ACTION=="add", TAG+="systemd", ENV{SYSTEMD_WANTS}="rdma.service"
> > +SUBSYSTEM=="module", KERNEL=="ib_*", ACTION=="add", TAG+="systemd", ENV{SYSTEMD_WANTS}="rdma.service"
> > +SUBSYSTEM=="module", KERNEL=="mlx*", ACTION=="add", TAG+="systemd", ENV{SYSTEMD_WANTS}="rdma.service"
> > +SUBSYSTEM=="module", KERNEL=="iw_*", ACTION=="add", TAG+="systemd", ENV{SYSTEMD_WANTS}="rdma.service"
> > +SUBSYSTEM=="module", KERNEL=="be2net", ACTION=="add", TAG+="systemd", ENV{SYSTEMD_WANTS}="rdma.service"
> > +SUBSYSTEM=="module", KERNEL=="enic", ACTION=="add", TAG+="systemd", ENV{SYSTEMD_WANTS}="rdma.service"
> 
> Also cross distro

Yeah, these are definitely prime candidates for being cross-distro. And
really, I was thinking maybe these should be part of the core upstream
udev/systemd rules set, rather than something we ship here.

> > +# When we detect a new verbs device is added to the system, set the node
> > +# description on that device
> > +# If rdma-ndd is installed, defer the setting of the node description to it.
> > +SUBSYSTEM=="infiniband", KERNEL=="*", ACTION=="add", TEST!="/usr/sbin/rdma-ndd", RUN+="/bin/bash -c 'sleep 1; echo -n `hostname -s` %k > /sys/class/infiniband/%k/node_desc'"
> 
> Shouldn't this udev drop-in by in the rdma-ndd package?

Honestly don't even have a clue what rdma-ndd is. :) Don't remember what
Doug said about this one...

> > +++ b/glue/redhat/srp_daemon.service
> > @@ -0,0 +1,17 @@
> > +[Unit]
> > +Description=Start or stop the daemon that attaches to SRP devices
> > +Documentation=file:///etc/rdma/rdma.conf file:///etc/srp_daemon.conf
> > +DefaultDependencies=false
> > +Conflicts=emergency.target emergency.service
> > +Requires=rdma.service
> > +Wants=opensm.service
> > +After=rdma.service opensm.service
> > +After=network.target
> > +Before=remote-fs-pre.target
> 
> Also should be common, why does it reference opensm.service?
> 
> > +
> > +[Service]
> > +Type=simple
> > +ExecStart=/usr/sbin/srp_daemon.sh
> 
> Hurm, someday we have to make better systemd integration for these
> daemons..

More deferrals to Doug!

-- 
Jarod Wilson
jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

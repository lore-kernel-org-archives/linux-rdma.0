From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC] Proposal to change Node Description naming scheme for HCA's
Date: Thu, 5 Apr 2012 12:19:24 -0600
Message-ID: <20120405181924.GB6032@obsidianresearch.com>
References: <20120330173908.0abdd264.weiny2@llnl.gov>
 <F93D748CDCC46C42B498F40A38D90369641004@FMSMSX107.amr.corp.intel.com>
 <20120402184545.GA1311@obsidianresearch.com>
 <20120403191442.ce88dc0a.weiny2@llnl.gov>
 <20120404171200.GC20889@obsidianresearch.com>
 <4F7DDA6B.7090304@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4F7DDA6B.7090304-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, "Heinz, Michael William" <michael.william.heinz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bob Ciotti <Bob.Ciotti-NSQ8wuThN14@public.gmane.org>, James Silva <jsilva-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Apr 05, 2012 at 01:46:19PM -0400, Doug Ledford wrote:

> > The purpose of the udev hook path is to set the node description on
> > initial device insertion, which may be before, or after the DHCP
> > process completes, in such cases.
> 
> Well, a udev rule is guaranteed to be before dhcp completes *on that
> device*.  It might be that dhcp has completed on another device and that
> the other device is actually where the hostname is pulled, but the udev
> rule will always be before this given device in the rule has completed dhcp.

The case where the hostname comes from management ethernet DHCP is
what I was thinking of..
 
> > IMHO we should have a udev rule that also loads the higher level IB
> > modules when any RDMA capable device is discovered, including the mlx4
> > IB layer, uverbs, umad, etc. This way systems that have RDMA will load
> > the right modules and systems that don't, won't. Fully supporting hot
> > plug, of course.
> 
> One of the niceties of the rdma/openibd init script is the ability to
> completely reload the stack.  That goes away if we switch to a udev load
> of the stack (well, unless you now create a script in /sbin and have the
> udev rule call that script, but the script should no longer be in the
> initrddir if it's not an init script).

I'm not sure how valuable this really is, in practice we shouldn't be
unloading/reloading kernel modules. Every time I've run into problems
an unload of the mlx4 drivers alone was enough to fix them. The verbs,
mad, srp, etc, don't often need to be unloaded in my experience,
certainly never all as a unit. It is also difficult to make this
actually work since you need to be aware of all RDMA using stuff in
the system. You may also need to restart MPI? DB2? RAC? etc?

Do other large scale kernel stacks in RHEL have module restart script?
If so a rdma-stack-restart script in /usr/sbin would seem appropriate
to me.

This would also fix the bug of trying to unload modules on shutdown
via the init script, that is unnecessary/sketchy, IMHO.

> >> I agree there might be better ways but I am not sure I follow your
> >> proposal.  Furthermore, I don't know that a start up script of some
> >> sort is all that evil.
> >>
> >> Finally, I think Michael brings up a good point about which package
> >> should own any such scripts.
> > 
> > udev is like if-up.d/, there is a rules directory packages can drop
> > hook scripts into that run at the appropriate time.
 
> Correct.  On Red Hat Enterprise Linux I could have the rdma package drop
> in an /sbin/rdma script that would bring the stack up (and possibly
> reload it, but I'm a bit sketchy on that idea given that this would no
> longer be an init script but something else), have it drop a small
> script in /etc/dhcp/dhclient.d/ to set the node description after dhcp
> completes (the script in /sbin would also have to set the node
> description from whatever information is available on load just in case
> the machine doesn't even use dhcp though), have it drop a rules file in
> /etc/udev.d/rules.d for bringing up the stack on device discovery
> (this

> one is a bit tricky though, you basically have to match against all
> possible RDMA devices and bring up the stack on the presence of any one
> of them, and your script that you call to bring the stack up needs
> to be

There are a couple independent things here..

1) PCI auto probe will start mlx4_core (and other core drivers, that
   is getting common). This is already done..

2) When mlx4_core/etc is loaded udev should auto load mlx4_en/mlx4_ib/etc
   There is currently no auto-probe system at all for these layered
   drivers, it is annoying it doesn't work automatically :)

3) When a driver is loaded that has the sysfs child attributes
   {node_guid,node_desc,node_type} load the IB user space modules:
     ib_ucm
     ib_umad
     ib_uverbs
   Which pull in the core kernel modules too

4) 'some other sysfs test for iWarp/ROCEE' - load ib_uverbs. If there
    isn't a sysfs already we should add one.

5) Various ULPs can be loaded contingent on the ib_verbs/ib_cm module being
   loaded, or on-demand from other init scripts (e.g. load srp/iser in the
   same way the system loads iscsi)

udev alread has modprobe calling rules, so I think we are good without
any external scripts or complex serialization.

I don't have any rules already that do this, every time I've tangled
with udev I end up screaming at my monitor :(

> So, I'd say it's doable to change this over, but I'm not sure I would
> recommend it in a minor point release.  I'd probably save this sort of
> change for a major release update.

Sure, but it is the sort of thing I think is appropriate for OFED to
prototype so everyone can have something well tested for their next
major releases.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

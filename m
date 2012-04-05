From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [RFC] Proposal to change Node Description naming scheme for
 HCA's
Date: Wed, 4 Apr 2012 18:24:08 -0700
Message-ID: <20120404182408.7f4362b7.weiny2@llnl.gov>
References: <20120330173908.0abdd264.weiny2@llnl.gov>
	<F93D748CDCC46C42B498F40A38D90369641004@FMSMSX107.amr.corp.intel.com>
	<20120402184545.GA1311@obsidianresearch.com>
	<20120403191442.ce88dc0a.weiny2@llnl.gov>
	<20120404171200.GC20889@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120404171200.GC20889-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "Heinz, Michael William" <michael.william.heinz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Bob Ciotti <Bob.Ciotti-NSQ8wuThN14@public.gmane.org>, James Silva <jsilva-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 4 Apr 2012 11:12:00 -0600
Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:

> On Tue, Apr 03, 2012 at 07:14:42PM -0700, Ira Weiny wrote:
> > On Mon, 2 Apr 2012 12:45:45 -0600
> > Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> > 
> > > On Mon, Apr 02, 2012 at 03:27:35PM +0000, Heinz, Michael William wrote:
> > > 
> > > > Any ideas on how we could solve the hostname problem while we're
> > > > changing the description?
> > > 
> > > The node description needs to be set from the DCHP notifier script
> > > chain (eg /etc/network/if-up.d/ on Debian) and also from a udev rule
> > > triggered on device insertion.
> > 
> > Jason, I'm confused.  Do you mean DHCP?
> 
> Yes..
> 
> > It seems are you indicating you would like to see if[up/down] bring
> > ports up/down like they do for IP?
> 
> No..
> 
> > On my ubuntu box (the closest thing I have to Debian) it looks like
> > ifupdown owns /etc/network/if-up.d and that is not specific to DHCP.
> > I don't think DHCP should be required for IB.
> 
> if-up.d/ is a '.d' directory, the idea is individual packages drop
> their script files in the directory and the system runs them at
> defined times. No package owns the directory.
> 
> The purpose of placing a hook here is this call path is used when the
> hostname changes via DHCP so you can have a chance to reset the node
> description.

Ok, I see what you are saying now.

> 
> > Using udev to set this __seems__ like a better idea although I have
> > not prototyped it.
> 
> The purpose of the udev hook path is to set the node description on
> initial device insertion, which may be before, or after the DHCP
> process completes, in such cases.

Yes I think doing this on device insertion is a good thing.

> 
> It may also be before or after the openibd script.. Having init.d
> scripts depend on the ordering of hardware discovery and module
> loading is considered sketchy these days with all the parallel boot
> fancyness and what not.
> 
> IMHO we should have a udev rule that also loads the higher level IB
> modules when any RDMA capable device is discovered, including the mlx4
> IB layer, uverbs, umad, etc. This way systems that have RDMA will load
> the right modules and systems that don't, won't. Fully supporting hot
> plug, of course.

Great idea perhaps you have these rules files and could supply patches to the
various packages?  ie libibumad should probably manage its own rules.

> 
> This would broadly eliminate the openibd script, integrate more
> correctly with the modern distro world, be better prepared for systemd
> and just be an overall better example for distros to follow :)
> 
> > > It should probably not be set from the openibd script..
> > 
> > I agree there might be better ways but I am not sure I follow your
> > proposal.  Furthermore, I don't know that a start up script of some
> > sort is all that evil.
> > 
> > Finally, I think Michael brings up a good point about which package
> > should own any such scripts.
> 
> udev is like if-up.d/, there is a rules directory packages can drop
> hook scripts into that run at the appropriate time.

As I said good idea but each rule file need to be owned by some package.
Preferably the package which needs them.  Node description is "universal" so
who owns its udev rule file, dhcp script file, etc?  I guess this is where the
RHEL rdma package comes in.

One final issue, is there a hook to be able to do this when someone runs
"hostname"?

Ira

>  
> Jason


-- 
Ira Weiny
Member of Technical Staff
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

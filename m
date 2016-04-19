From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 0/7] IB/hfi1: Remove write() and use ioctl() for user
 access
Date: Tue, 19 Apr 2016 15:38:25 -0600
Message-ID: <20160419213825.GA18297@obsidianresearch.com>
References: <20160414153727.6387.96381.stgit@scvm10.sc.intel.com>
 <20160414164550.GC6247@obsidianresearch.com>
 <20160418130909.GD11508@infradead.org>
 <20160418174047.GB13865@obsidianresearch.com>
 <20160418182411.GA4904@infradead.org>
 <20160419173817.GF20844@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB0439B0@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB0439B0-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Apr 19, 2016 at 08:44:50PM +0000, Hefty, Sean wrote:
> > Right - and the RDMA uAPI has always had an integrated driver-bypass
> > channel as part of the verb uAPI calls, extending that to allow for
> > new-driver-specific calls seems very natural.
> 
> I remain unconvinced that having the equivalent of:
> 
> 1 open unrelated-interface
> 2 ioctl open-file
> 3 close unrelated-interface
> 
> is desirable.

I think you should explain what you see as the down side.

So far the counter arguments seem terribly weak:
 - The file is called /dev/uverbs0 so everything in it must be 'verbs'
   and anything else new needs a new name (the name has no functional
   purpose, compatability requires some sacrifices)
 - Our current kapi requires a driver provide all the verbs before
   it can create uverbs0 (we could fix this)
 - The driver-specific ioctls have nothing to do with the subsystem
   and shouldn't be a part of it (then get the code out of
   drivers/infiniband)

I've already outlined the tangible advantages from the whole system
perspective on discoverability/security/deployment/etc.

If you don't like the sub-fd then advocate for driver-specific ioctl
on the main fd, I don't much care. <shrug>

> If you want to push for a generic mechanism for mapping NIC
> resources into user space, then separate that from the device
> implementation.

I don't understand this sentence, is it another shot at the fact the
RDMA device specific cdev is called 'uverbs' ??

Seriously, every single new char dev that requires the same security
context as uverbs (ie access from unprivledged users) is a *huge pain*
to deploy out into the world, sysadmins need to be trained, distros
need to be updated, orchestration stuff needs fixing, etc. It is
simply not a sane path for our subsystem to require a multitude of
these cdevs.

If /dev/hfiX was to remain as root.root 0600 in the typical
deployment, like most driver-specific cdevs then I'd be alot less
concerned. But it isn't, and the garbage that was in there (like
eeprom writing!?!) is totally *insane* for an unprivileged fd.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

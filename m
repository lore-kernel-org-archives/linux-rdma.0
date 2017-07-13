From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] Add rdma service for kernel boot support
Date: Thu, 13 Jul 2017 16:41:37 -0600
Message-ID: <20170713224137.GA24689@obsidianresearch.com>
References: <20170713172057.25411-1-benjamin.drung@profitbricks.com>
 <1499968101.2740.10.camel@wdc.com>
 <20170713182018.GE11069@obsidianresearch.com>
 <1499970786.2740.17.camel@wdc.com>
 <20170713221520.GA10088@obsidianresearch.com>
 <1499985409.2740.24.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1499985409.2740.24.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org" <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 13, 2017 at 10:36:49PM +0000, Bart Van Assche wrote:
> On Thu, 2017-07-13 at 16:15 -0600, Jason Gunthorpe wrote:
> > The one nit that I don't have an easy solution for is starting modules
> > depending on the device technology, eg not starting srp or ipoib on
> > !IB devices. The issue is that I can't think of an easy way to detect
> > the device technology from the udev rule, at least not without a
> > helper script or additional kernel sysfs..
> 
> Are users expected to modify the kernel-boot/modules/*.conf files? I
> expect that only a minority of the RDMA users will want to load the ib_srpt
> and ib_isert kernel modules. 

I'd say in the same way they would be expected to modify the RedHat
/etc/rdma/rdma.conf file. I copied the defaults from that file, which
was to autoload target drivers.

I agree with you, they probably don't make sense to be defaulted on.
Ideally their respective supporting packages or kernel would ensure
the modules autoload if someone is working with RDMA... I know nothing
about the target infrastructure - can you see a way to do that?

Thanks,
Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

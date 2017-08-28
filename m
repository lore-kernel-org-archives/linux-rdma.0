From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 1/2] suse: Add spec file for SUSE
Date: Mon, 28 Aug 2017 11:29:54 -0600
Message-ID: <20170828172954.GA21341@obsidianresearch.com>
References: <abf2bc82-824b-a1d9-bc6b-a3a77045d633@suse.de>
 <20170827214704.GC14542@obsidianresearch.com>
 <ecddc225-0dc5-c51f-535b-c2bee252d5ed@suse.de>
 <20170828060758.GD12880@mtr-leonro.local>
 <86a21008-c993-de29-2cb9-845af14c4cd5@suse.de>
 <20170828090537.GG12880@mtr-leonro.local>
 <0754696d-42d5-5083-8ed0-435ab3f189de@suse.de>
 <20170828152254.GB7867@obsidianresearch.com>
 <ea729fa9-6f6e-9834-ff77-377b1e843f79@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <ea729fa9-6f6e-9834-ff77-377b1e843f79-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Cc: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Aug 28, 2017 at 10:23:56AM -0700, Adit Ranadive wrote:
> On 8/28/17 8:22 AM, Jason Gunthorpe wrote:
> > Adit: vmw_rdma is also missing, can you test it? This is probably
> > the fix:
> > 
> > diff --git a/kernel-boot/rdma-description.rules b/kernel-boot/rdma-description.rules
> > index f37e6a86f21efc..bb33dce40bd621 100644
> > +++ b/kernel-boot/rdma-description.rules
> > @@ -34,6 +34,7 @@ DRIVERS=="hns", ENV{ID_RDMA_ROCE}="1"
> >  DRIVERS=="mlx4_core", ENV{ID_RDMA_ROCE}="1"
> >  DRIVERS=="mlx5_core", ENV{ID_RDMA_ROCE}="1"
> >  DRIVERS=="qede", ENV{ID_RDMA_ROCE}="1"
> > +DRIVERS=="vmw_pvrdma", ENV{ID_RDMA_ROCE}="1"
> >  DEVPATH=="*/infiniband/rxe*", ATTR{parent}=="*", ENV{ID_RDMA_ROCE}="1"
> 
> Thanks. Do I need to generate rpms to test this to install the udev rules?

For best results, yes.. You have to disable the rdma.service that still comes in
the rpms.

After booting run

udevadm info /sys/class/infiniband/XX

where XX is the rdma name of a vmw_pvrdma device, and confirm the
ID_RDMA_ROCE is setup. Check the rest of the modules loaded and so forth.

Thanks,
Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC rdma-core 2/2] verbs: Introduce non-contiguous memory
 registration
Date: Wed, 31 Jan 2018 11:38:10 -0700
Message-ID: <20180131183810.GA23352@mellanox.com>
References: <20180111122206.GB2800@yuvallap>
 <20180111164455.GA1309@ziepe.ca>
 <VI1PR05MB1278C4C4FF78B4B1A551252EB9EC0@VI1PR05MB1278.eurprd05.prod.outlook.com>
 <20180123202954.GA14007@yuvallap>
 <VI1PR05MB12787572593F02F05AA20DE1B9E10@VI1PR05MB1278.eurprd05.prod.outlook.com>
 <20180128203746.GA11635@yuvallap>
 <20180129172717.GW23852@mellanox.com>
 <12d04e1b-6024-0763-f5c5-46ca8b0823a6@redhat.com>
 <20180130154200.GD21679@mellanox.com>
 <76b5a8cf-b3ed-c76d-6157-91fc5f6f2b35@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <76b5a8cf-b3ed-c76d-6157-91fc5f6f2b35-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Marcel Apfelbaum <marcel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Alex Margolin <alexma-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 31, 2018 at 02:27:01PM +0200, Marcel Apfelbaum wrote:

> It is good to know, but still, passing so much information to kernel
> when we can rather "compress" it, maybe it worth a second thought.

Not sure. Have to see the whole thing..

> > Well, actually, only a 3rd :| The new MR would likely be 0 based, but
> > the VM guest doesn't know about this. So you'd need an API that can do
> > arbitrary based to really solve your probably. I guess all HW should
> > be able to do this so maybe it is OK?
> 
> The way we solve "the other" half is by intercepting the post-send
> requests in hypervisor. At hypervisor level we don't have contiguous virtual
> addresses anymore, but we don't need them for 0 based MRs:
> The guest still register regular MRs, while the hypervisor will
> register a 0 based MR save the guest virtual address of the MR.
> At post-send we simply substract the saved MR base address from the work request
> buffers and we are back to 0 based MR.

That only works for lkeys, the rkey expoeses the base address to the
remote - the HV can't fix it..

> Do you have a model in mind? We would really want to try it out.
> 
> By the way, I tried to search in the kernel for vendors implementing
> it and I saw maybe one vendor... so maybe 0 based MR is a nice idea
> but nothing more.

Try the mlx drivers, I think at least one of them can do it today.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

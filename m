From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 1/2] libibverbs: Allow 3rd party extensions to verb
 routines
Date: Mon, 1 Aug 2011 23:38:24 -0600
Message-ID: <20110802053824.GA23512@obsidianresearch.com>
References: <1828884A29C6694DAF28B7E6B8A8237302123C@ORSMSX101.amr.corp.intel.com>
 <BANLkTimwTs4EK19PiTq6yMzPCQrLt0bALw@mail.gmail.com>
 <1828884A29C6694DAF28B7E6B8A823730218F4@ORSMSX101.amr.corp.intel.com>
 <201108011508.06521.jackm@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <201108011508.06521.jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> In fact, I'm not sure if it will fail loading because of unresolved
> references).  Indeed, I am not sure that the app can run at all due
> to unresolved references.

The dlopen of mlx4 should fail due to unresolved references, so the
net effect will be that no apps cannot open the RDMA device in this
situation - so it is an invalid system configuration that is properly
detected by the runtime.

> The problem here is that the new additions need support in
> libibverbs in order to work (this is not simply a "pass-through" by
> libibverbs to the lower layer).

The hope is once the infrastructure is in libibverbs there will not
be as much need to change libibverbs, just the apps and the drivers.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

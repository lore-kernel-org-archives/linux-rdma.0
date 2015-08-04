From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH, RFC] rdma: split struct ib_send_wr
Date: Tue, 4 Aug 2015 19:23:28 +0200
Message-ID: <20150804172328.GA22468@lst.de>
References: <1438672609-12599-1-git-send-email-hch@lst.de> <55C0F108.4090003@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55C0F108.4090003-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 04, 2015 at 08:06:16PM +0300, Sagi Grimberg wrote:
> Question though, a ULP may want to keep a couple of WRs around instead
> of having each allocated in the stack and handled one by one. We need
> to provide it with a hint of what is the size it needs.

Note that with the drastic shrink of the struct size the typical case
of needing a fast_reg + one send or a few rdma wr should be just fine
on stack now.  Even more so with your registration cleanups which
will drastically shrink the size of the fast reg mrs again.

> I just posted a patch to do that in iser 
> (http://www.spinics.net/lists/linux-rdma/msg27632.html).

That's actually part of the reason why I didn't manage to convert iser
as it seems so convoluted..

> So if I would want to preallocate an array of work requests, what is the
> size of the space I'd need?
> is it some form of max(sizeof(struct ib_send_wr),
>                        sizeof(struct ib_fastreg_wr),
>                        sizeof(struct sig_handover), ..)?

Preferably you'd preallocate them in a type safe manner, if you really
need to overlay them do it as a proper union.  For example the rds
code is doing that although it only preallocates on per work item.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

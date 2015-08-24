From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [PATCH 1/3] IB/uverbs: reject invalid or unknown opcodes
Date: Mon, 24 Aug 2015 08:55:01 +0200
Message-ID: <20150824065501.GA31990@lst.de>
References: <1440002254-795-1-git-send-email-hch@lst.de> <HE1PR05MB13557ADB8FA73865B659C6D0C1640@HE1PR05MB1355.eurprd05.prod.outlook.com> <20150822082516.GC1857@lst.de> <55DABF1E.2050804@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55DABF1E.2050804-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Aug 24, 2015 at 09:52:14AM +0300, Haggai Eran wrote:
> Okay. Maybe you can just add a case for IB_WR_SEND in this patch to
> avoid hurting bisectability.

I've done this already, just waiting for more feedback before resending:

http://git.infradead.org/users/hch/rdma.git/commitdiff/20f34ca8ecac302984f3a92b9ad29f5f4b41780d

> Looking at the uverbs part in patch 2, I think the changes are okay. I
> noticed there's a (__be32 __force) cast of the immediate data from
> userspace (it was already in the existing code). I wonder, why not
> define the field in the uapi struct as __be32 in the first place?

It looks odd to me as well, but it's not really something I want to
change in this series.  Note that sparse annoted types like __be32
aren't really common in userspace, but with a bit of effort they can
be supported.  We have them and regularly run sparse for xfsprogs for
example.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

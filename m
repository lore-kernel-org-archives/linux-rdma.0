From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v2] IB/core: remove dead code
Date: Tue, 7 Jun 2016 05:42:59 -0700
Message-ID: <20160607124259.GA3906@infradead.org>
References: <1465247706-4418-1-git-send-email-sudipm.mukherjee@gmail.com>
 <5756C0E0.7090303@lightbits.io>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5756C0E0.7090303-ImC7XgPzLAfvYQKSrp0J2Q@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-ImC7XgPzLAfvYQKSrp0J2Q@public.gmane.org>
Cc: Sudip Mukherjee <sudipm.mukherjee-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Jun 07, 2016 at 03:41:04PM +0300, Sagi Grimberg wrote:
> Actually it looks like the data-integrity insert/strip operation
> (where protection sg list does not exist) is broken.
> 
> It looks that the protection scatterlist should be done only if
> prot_sg_count was provided...
> 
> I don't have access to mlx5 devices at the moment (still waiting
> to get some...)

I've reported the brokenness in the existing iSER code when I started
working on signature MR support in the generic API.  As no one helped
managed to figure out the issue or how it should operate I clone the
existing semantics, even given I knew they are broken.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

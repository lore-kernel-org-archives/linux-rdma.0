From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Bug#881731: rdma-core: FTBFS on armhf and mips*: missing providers that need coherent DMA
Date: Tue, 14 Nov 2017 12:08:05 -0700
Message-ID: <20171114190805.GF4263@ziepe.ca>
References: <151067381730.19157.7563136692092597267.reportbug@ghostwheel.internal.ucko.debian.net>
Reply-To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, 881731-61a8vm9lEZVf4u+23C9RwQ@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 881731-61a8vm9lEZVf4u+23C9RwQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> However, it would of course be better to teach udma_barrier.h about
> these architectures.

The issue is that some architectures just can't do cache coherent DMA
on any implementation. eg m68k

There is no correct udma_barrier.h at all in those cases.

We need to teach debian to follow cmake and exclude the missing
installables in these cases..

Or do not build at all on these arch's..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: Processed: libibverbs-dev no longer ships infiniband/driver.h
Date: Wed, 15 Nov 2017 10:16:57 -0700
Message-ID: <20171115171657.GQ25894@ziepe.ca>
References: <151075140461.17370.2844187627354872362.reportbug@localhost>
 <151075140461.17370.2844187627354872362.reportbug@localhost>
 <handler.s.B.15107514116787.transcript@bugs.debian.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <handler.s.B.15107514116787.transcript-61a8vm9lEZVf4u+23C9RwQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 881814-61a8vm9lEZVf4u+23C9RwQ@public.gmane.org
Cc: Adrian Bunk <bunk-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


> libibverbs-dev
> src:librdmacm
> src:libcxgb3
> src:libmlx4
> src:libipathverbs
> src:libmlx5
> src:libibcm
> src:libmthca
> src:libnes

These are now all part of rdma-core. These packages should be removed
from unstable and all other release suites that have rdma-core.

It is an error to attempt to build them against rdma-core.

> src:libfabric

This is has been fixed in libfabric upstream, look for patches from me.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

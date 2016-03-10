From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 00/16] IB/hfi1: Add a page pinning cache for PSM sdma
Date: Thu, 10 Mar 2016 09:11:29 +0200
Message-ID: <CAJ3xEMgoRW22SW287Zs-Sc2svZvcro2iN4F-ja1G9D5Vq9LFNQ@mail.gmail.com>
References: <20160308191210.30542.91885.stgit@scvm10.sc.intel.com>
	<CAJ3xEMj8gz6Xw1bqA677fC8=U2ktLQ6b4W20SeNrztN7u6UKZg@mail.gmail.com>
	<20160309002157.GA20105@phlsvsds.ph.intel.com>
	<20160309050731.GM13396@leon.nu>
	<20160309192109.GB15031@phlsvsds.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160309192109.GB15031-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Mar 9, 2016 at 9:21 PM, Dennis Dalessandro
<dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

> We should not be putting something which is specific to PSM in the IB core.
> We feel the driver is the most appropriate place for this.


Actually, the cache itself belongs to user space.

What is needed in the kernel is code that uses MMU notifications to
invalidate the cache when munmap and friends
were done on a cache entry. This is too generic functionality that you
can add to the IB core which does have a char device
or (better) to a generic char device you will write and PSM to use.
There have been some works on that in the 2000s, look
for code from Roland Dreier and/or Pete Wyckoff

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/2] IB/ipoib: Clean up send-only multicast joins
Date: Thu, 3 Sep 2015 11:50:54 -0500 (CDT)
Message-ID: <alpine.DEB.2.11.1509031149080.24505@east.gentwo.org>
References: <1440200053-18890-1-git-send-email-jgunthorpe@obsidianresearch.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1440200053-18890-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, 21 Aug 2015, Jason Gunthorpe wrote:

> Even though we don't expect the group to be created by the SM we
> sill need to provide all the parameters to force the SM to validate
> they are correct.

Just ran into this issue with Redhat 7.1. Earlier code base. Same
problem. qkey etc not set. OFED-1.5.4.1 did sets these parameters
correctly and it was a surprise that the kernel IB stack never had these
fixes.

The way sendonly joins are handled now is a bit bothering me now. The join
is delayed? How can that work? We are sending the multicast packets before
the join is complete? This means the multicast packets are going to be
dropped since there is no multicast subscription.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

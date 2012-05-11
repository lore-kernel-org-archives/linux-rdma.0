From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 2/6] IB/core: fix mismatch between locked and
 pinned pages
Date: Fri, 11 May 2012 12:06:39 -0500 (CDT)
Message-ID: <alpine.DEB.2.00.1205111205530.31049@router.home>
References: <1336681689-16668-1-git-send-email-ogerlitz@mellanox.com> <1336681689-16668-3-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1336681689-16668-3-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 10 May 2012, Or Gerlitz wrote:

> Commit bc3e53f68 "mm: distinguish between mlocked and pinned pages"
> introduced a separate counter for pinned pages and used it over
> the IB stack. Specifically, in ib_umem_get the pinned counter
> is incremented, but ib_umem_release wrongly decrements the
> locked counter, fix that.

This looks like a stable fix or at least something that should be merged
upstream asap. Patch is missing my reviewed-by tag.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

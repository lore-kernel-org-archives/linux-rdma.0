From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH net/for-next V1 1/1] IB/ipoib: break linkage to neighbouring
 system
Date: Thu, 19 Jul 2012 09:42:36 -0500 (CDT)
Message-ID: <alpine.DEB.2.00.1207190938190.28115@router.home>
References: <1342703938-29904-1-git-send-email-ogerlitz@mellanox.com> <1342703938-29904-2-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342703938-29904-2-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 19 Jul 2012, Or Gerlitz wrote:

> Aged ipoib_neigh instances are deleted by a garbage collection task that runs every
> 30 seconds and deletes every ipoib_neigh instance that was idle for at least 60
> seconds. The deletion is safe since the ipoib_neigh instances are protected
> using RCU and reference count mechanisms.

Could we have the idle time configurable please? For many use cases we
want a much longer retention of the neighbors (actually we typically use 4
hrs).

Also wish we would not run useless code every 30 seconds (create noise
events especially if its per cpu). Could we only run those events as
necessary and group the expiration of neighbors to reduce the events?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

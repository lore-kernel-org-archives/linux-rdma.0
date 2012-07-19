From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH net/for-next V1 1/1] IB/ipoib: break linkage to neighbouring
 system
Date: Thu, 19 Jul 2012 10:24:53 -0500 (CDT)
Message-ID: <alpine.DEB.2.00.1207191023130.29808@router.home>
References: <1342703938-29904-1-git-send-email-ogerlitz@mellanox.com> <1342703938-29904-2-git-send-email-ogerlitz@mellanox.com> <alpine.DEB.2.00.1207190938190.28115@router.home> <50082183.5000402@mellanox.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50082183.5000402-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shlomo Pongartz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, 19 Jul 2012, Shlomo Pongartz wrote:

> The garbage collection and stale times follow the default ipv4/6
> neigh.default.gc_yyy
> sysctl values, for example
>
> net.ipv4.neigh.default.gc_interval = 30
> net.ipv4.neigh.default.gc_stale_time = 60
>
> If given access to these values from IPoIB, we will be happy
> to integrate them into that logic

It looks like the values are hardcoded right now.

> Please clarify what do you mean by group expiration.

If you have neighbor expiration periods of 4 hrs and it is necessary to
run the expiration logic then please expire all the neighbor entries due a
certain period after that as well to avoid running the expiration again in
the next minute or so. I guess the fuzz factor needs to scale depending on
the expiration period.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

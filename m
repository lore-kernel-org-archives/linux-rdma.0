From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH RESEND for-next 3/7] IB/mlx4: increase the number of
 vectors (EQs) available for ULPs
Date: Wed, 16 May 2012 23:42:11 +0300
Message-ID: <CAJZOPZ+53S5q+S2ToiqFQFo6oUP7tpO6gZA4Cu4pBWxrjL-wXA@mail.gmail.com>
References: <1336494151-31050-1-git-send-email-ogerlitz@mellanox.com>
	<1336494151-31050-4-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1336494151-31050-4-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, May 8, 2012 at 7:22 PM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:

> Enable IB ULPs to use a larger portion of the device EQs (which map
> to IRQs). The mlx4_ib driver follows the mlx4_core framework of the
> EQs to be divided among the device ports. In this scheme, for each IB
> port, the number of allocated EQs follows the number of cores, subject
> to other system constraints, such as number available MSI-X vectors.

Hi Roland,

This patch is kind of following the "occupy wall street" spirit, e.g
let mlx4/IB consumers get the available EQs reserved/allocated for
them by mlx4_core, which does so per port. Its basic for RSS later and
also for optimizations in more ULPs down the road, will be happy to
get any feedback if you have comments here.

Also, another long pending patch is the one to allow for multiple IPoIB childs @
http://marc.info/?l=linux-rdma&m=132630202116857&w=2 , which will be
of use by the eIPoIB - the "Ethernet IPoIB" driver which was presented
in the last OFA conference, the patch was initially posted back in
November, so far no comment.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

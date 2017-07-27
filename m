From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 5/7] IB/rxe: Fix destination cache for IPv6
Date: Thu, 27 Jul 2017 15:07:27 +0300
Message-ID: <CAG9sBKP5Z6PFRZm+6=0yAs6UCkh6ExAU0NMot_ueUVw04H+DdA@mail.gmail.com>
References: <1500989968-30889-1-git-send-email-andrew.boyer@dell.com> <1500989968-30889-6-git-send-email-andrew.boyer@dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1500989968-30889-6-git-send-email-andrew.boyer-8PEkshWhKlo@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, allen.hubbe-8PEkshWhKlo@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 25, 2017 at 4:39 PM, Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org> wrote:
> To successfully match an IPv6 path, the path cookie must match. Store it
> in the QP so that the IPv6 path can be reused.
>
> Replace open-coded version of dst_check() with the actual call, fixing the
> logic. The open-coded version skips the check call if dst->obsolete is 0
> (DST_OBSOLETE_NONE), proceeding to replace the route. DST_OBSOLETE_NONE
> means that the route may continue to be used, though.
>
> Add dst_clone() in prepare_ipv6_hdr(). Otherwise the reference count goes
> negative as packets complete.
>
> Replace sk_dst_get()/dst_release() in rxe_qp_cleanup() with sk_dst_reset().
> sk_dst_get() takes a new reference on dst, so the dst_release() doesn't
> actually release the original reference, which was the design intent.
>
> Remove unneeded initialization in prepare6().
>
> Fixes: 4ed6ad1eb30e ("IB/rxe: Cache dst in QP instead of getting it...")
> Signed-off-by: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
> ---
>  drivers/infiniband/sw/rxe/rxe_net.c   | 9 ++++++---
>  drivers/infiniband/sw/rxe/rxe_qp.c    | 9 ++-------
>  drivers/infiniband/sw/rxe/rxe_verbs.h | 1 +
>  3 files changed, 9 insertions(+), 10 deletions(-)
>
Fixes seem to be correct but I identify here 3 unrelated patches.
Please split
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

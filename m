From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 00/11] IB/rxe: Bug fixes
Date: Sun, 27 Aug 2017 15:33:10 +0300
Message-ID: <20170827123309.GF10450@yuvallap>
References: <1500989968-30889-1-git-send-email-andrew.boyer@dell.com>
 <1503687956-7110-1-git-send-email-andrew.boyer@dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1503687956-7110-1-git-send-email-andrew.boyer-8PEkshWhKlo@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
Cc: monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Marcel Apfelbaum <marcel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Andrew,
I'm working on a bug that prevents RXE from routing between two instances of
RXE on the same host (https://patchwork.kernel.org/patch/9865227/).

When working on latest branches (since intro of 587fea741134) i started to
get system panic and i was not able to continue.

With your patch-set it works excellent!!!

So, besides some comments for one or two patches and besides some patches
which i skip the review because of lack of background, you have my:

Tested-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

And

Big-Thanks-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

Yuval

On Fri, Aug 25, 2017 at 03:05:45PM -0400, Andrew Boyer wrote:
> This patch set addresses a few issues which we have found in RXE.
> The first patch fixes a serious issue that causes kernel panics during
> network congestion.
> 
> Changes for v1:
> * Address review comments and add review tags from Moni
> * Split destination cache patch into 4 smaller patches
> * Added CONFIG_IPV6 check to destination cache patch
> * Added new NETDEV_CHANGE patch
> 
> Andrew Boyer (11):
>   IB/rxe: Move refcounting earlier in rxe_send()
>   IB/rxe: Disable completion upcalls when a CQ is destroyed
>   IB/rxe: Remove dangling prototype
>   IB/rxe: Fix up the responder's find_resources() function
>   IB/rxe: Fix destination cache for IPv6
>   IB/rxe: Add dst_clone() in prepare_ipv6_hdr()
>   IB/rxe: Fix up rxe_qp_cleanup()
>   IB/rxe: Remove unneeded initialization in prepare6()
>   IB/rxe: Another fix for broken receive queue draining
>   IB/rxe: Avoid ICRC errors by copying into the skb first
>   IB/rxe: Handle NETDEV_CHANGE events
> 
>  drivers/infiniband/sw/rxe/rxe_cq.c    | 19 +++++++++++++++++++
>  drivers/infiniband/sw/rxe/rxe_loc.h   |  4 ++--
>  drivers/infiniband/sw/rxe/rxe_mr.c    | 12 ++++++------
>  drivers/infiniband/sw/rxe/rxe_net.c   | 26 +++++++++++++++++++-------
>  drivers/infiniband/sw/rxe/rxe_qp.c    |  9 ++-------
>  drivers/infiniband/sw/rxe/rxe_req.c   |  4 +++-
>  drivers/infiniband/sw/rxe/rxe_resp.c  |  2 +-
>  drivers/infiniband/sw/rxe/rxe_verbs.c |  2 ++
>  drivers/infiniband/sw/rxe/rxe_verbs.h |  2 ++
>  9 files changed, 56 insertions(+), 24 deletions(-)
> 
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

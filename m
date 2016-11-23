From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 7/7] IB/rxe: Fix ref leaks in duplicate_request() and rxe_create_qp()
Date: Wed, 23 Nov 2016 18:00:48 +0200
Message-ID: <CAG9sBKNuhC5u3u_WspbMSFndWC_QOLQXa2h2gRMny7xmMsUpWg@mail.gmail.com>
References: <1479479809-10798-1-git-send-email-andrew.boyer@dell.com> <1479479809-10798-7-git-send-email-andrew.boyer@dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1479479809-10798-7-git-send-email-andrew.boyer-8PEkshWhKlo@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Nov 18, 2016 at 4:36 PM, Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org> wrote:
> In duplicate_request(), a ref was added after the call to skb_clone().
>
> In rxe_create_qp(), the udata->inlen error path needs to clean up the ref
> added by rxe_alloc().
>
> Signed-off-by: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
> ---
>  drivers/infiniband/sw/rxe/rxe_resp.c  | 1 +
>  drivers/infiniband/sw/rxe/rxe_verbs.c | 7 ++++---
>  2 files changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
> index a5e9ce3..8643797 100644
> --- a/drivers/infiniband/sw/rxe/rxe_resp.c
> +++ b/drivers/infiniband/sw/rxe/rxe_resp.c

I would consider splitting to 2 different patches but besides that

Acked-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

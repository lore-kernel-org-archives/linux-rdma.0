From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 2/7] IB/rxe: Disable completion upcalls when a CQ is destroyed
Date: Thu, 27 Jul 2017 12:35:14 +0300
Message-ID: <CAG9sBKOet0xv9YaJAc58erVrnTGwzMd630goDgrxUEx4PhXK+g@mail.gmail.com>
References: <1500989968-30889-1-git-send-email-andrew.boyer@dell.com> <1500989968-30889-3-git-send-email-andrew.boyer@dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1500989968-30889-3-git-send-email-andrew.boyer-8PEkshWhKlo@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, allen.hubbe-8PEkshWhKlo@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 25, 2017 at 4:39 PM, Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org> wrote:
> This prevents the stack from accessing userspace objects while they
> are being torn down.
>
> Fixes: 8700e3e7c485 ("Soft RoCE driver")
> Signed-off-by: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
> ---
>  drivers/infiniband/sw/rxe/rxe_cq.c    | 19 +++++++++++++++++++
>  drivers/infiniband/sw/rxe/rxe_loc.h   |  2 ++
>  drivers/infiniband/sw/rxe/rxe_verbs.c |  2 ++
>  drivers/infiniband/sw/rxe/rxe_verbs.h |  1 +
>  4 files changed, 24 insertions(+)
>
> diff --git a/drivers/infiniband/sw/rxe/rxe_cq.c b/drivers/infiniband/sw/rxe/rxe_cq.c
> index 49fe42c..c4aabf7 100644
> --- a/drivers/infiniband/sw/rxe/rxe_cq.c
> +++ b/drivers/infiniband/sw/rxe/rxe_cq.c
> @@ -69,6 +69,14 @@ int rxe_cq_chk_attr(struct rxe_dev *rxe, struct rxe_cq *cq,
>  static void rxe_send_complete(unsigned long data)
>  {
>         struct rxe_cq *cq = (struct rxe_cq *)data;
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&cq->cq_lock, flags);
> +       if (cq->is_dying) {
> +               spin_unlock_irqrestore(&cq->cq_lock, flags);
> +               return;
> +       }
> +       spin_unlock_irqrestore(&cq->cq_lock, flags);
What if CQ is destroyed here after you pass the is_dying test?
Maybe you should think of a solution based on ref counting.
>         cq->ibcq.comp_handler(&cq->ibcq, cq->ibcq.cq_context);
>  }
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [PATCH 2195/2195] Staging: rdma: amso1100: Fix multiple
 assignments on single line.
Date: Sun, 25 Oct 2015 13:12:02 +0200
Message-ID: <CALq1K=Lt+LT17exUqvgFFVW5epMK6URUHcku23KV-rxHtj2Gcw@mail.gmail.com>
References: <1445770206-9645-1-git-send-email-weston.silbaugh@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1445770206-9645-1-git-send-email-weston.silbaugh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Weston Silbaugh <weston.silbaugh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: gregkh <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Oct 25, 2015 at 12:50 PM, Weston Silbaugh
<weston.silbaugh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Multiple assignments should be avoided.
>
> For example:
>
> cm_event.ird = cm_event.ord = 128;
>
> Should be:
>
> cm_event.ird = 128;
> cm_event.ord = 128;
>
> Signed-off-by: Weston Silbaugh <weston.silbaugh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/staging/rdma/amso1100/c2_ae.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/staging/rdma/amso1100/c2_ae.c b/drivers/staging/rdma/amso1100/c2_ae.c
> index eb7a92b..20d98b7 100644
> --- a/drivers/staging/rdma/amso1100/c2_ae.c
> +++ b/drivers/staging/rdma/amso1100/c2_ae.c
> @@ -173,7 +173,8 @@ void c2_ae_event(struct c2_dev *c2dev, u32 mq_index)
>         resource_user_context =
>             (void *) (unsigned long) wr->ae.ae_generic.user_context;
>
> -       status = cm_event.status = c2_convert_cm_status(c2_wr_get_result(wr));
> +       status = c2_convert_cm_status(c2_wr_get_result(wr));
> +       cm_event.status = c2_convert_cm_status(c2_wr_get_result(wr));
This is wrong fro two reasons:
1. In case of wrong status it will print twice the same error line
"Unable to convert CM status"
2. The better solution will be to rewrite the patch to remove "status
variable" at all.

>
>         pr_debug("event received c2_dev=%p, event_id=%d, "
>                 "resource_indicator=%d, user_context=%p, status = %d\n",
> @@ -294,7 +295,8 @@ void c2_ae_event(struct c2_dev *c2dev, u32 mq_index)
>                  * Until ird/ord negotiation via MPAv2 support is added, send
>                  * max supported values
>                  */
> -               cm_event.ird = cm_event.ord = 128;
> +               cm_event.ird = 128;
> +               cm_event.ord = 128;
>
>                 if (cm_id->event_handler)
>                         cm_id->event_handler(cm_id, &cm_event);
> --
> 2.4.3
>
> _______________________________________________
> devel mailing list
> devel-tBiZLqfeLfOHmIFyCCdPziST3g8Odh+X@public.gmane.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 4/7] IB/rxe: Fix up the responder's find_resources() function
Date: Thu, 27 Jul 2017 13:54:47 +0300
Message-ID: <CAG9sBKN_jtEzUe4SjLxFLvGcPF4=ChYvNwEqoGy=aXfKZTe78w@mail.gmail.com>
References: <1500989968-30889-1-git-send-email-andrew.boyer@dell.com> <1500989968-30889-5-git-send-email-andrew.boyer@dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1500989968-30889-5-git-send-email-andrew.boyer-8PEkshWhKlo@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, allen.hubbe-8PEkshWhKlo@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 25, 2017 at 4:39 PM, Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org> wrote:
> The resource array is sized by max_dest_rd_atomic, not max_rd_atomic.
>
The patch seems correct. However the commit message lacks an explanation why.
Please improve

> Fixes: 8700e3e7c485 ("Soft RoCE driver")
> Signed-off-by: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
> ---
>  drivers/infiniband/sw/rxe/rxe_resp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
> index a958ee9..4240866 100644
> --- a/drivers/infiniband/sw/rxe/rxe_resp.c
> +++ b/drivers/infiniband/sw/rxe/rxe_resp.c
> @@ -1055,7 +1055,7 @@ static struct resp_res *find_resource(struct rxe_qp *qp, u32 psn)
>  {
>         int i;
>
> -       for (i = 0; i < qp->attr.max_rd_atomic; i++) {
> +       for (i = 0; i < qp->attr.max_dest_rd_atomic; i++) {
>                 struct resp_res *res = &qp->resp.resources[i];
>
>                 if (res->type == 0)
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

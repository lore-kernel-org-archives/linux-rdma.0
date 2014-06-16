From: Nick Krause <xerofoify-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv3]Checks for Null value in function *get_skub
Date: Mon, 16 Jun 2014 11:10:30 -0400
Message-ID: <CAPDOMVi9V6ezvDWTKChv5afb_0M=ch0wog2b699fuOOe=sGVXA@mail.gmail.com>
References: <1402931337-3543-1-git-send-email-xerofoify@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1402931337-3543-1-git-send-email-xerofoify-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The bug is open here https://bugzilla.kernel.org/show_bug.cgi?id=44631.
I would recommend closing it now as I seem to have fixed it.
Cheers Nick

On Mon, Jun 16, 2014 at 11:08 AM, Nicholas Krause <xerofoify-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Signed-off-by: Nicholas Krause <xerofoify-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/hw/cxgb4/cm.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
> index f9477e2..2d56983 100644
> --- a/drivers/infiniband/hw/cxgb4/cm.c
> +++ b/drivers/infiniband/hw/cxgb4/cm.c
> @@ -340,15 +340,13 @@ static int status2errno(int status)
>   */
>  static struct sk_buff *get_skb(struct sk_buff *skb, int len, gfp_t gfp)
>  {
>  if (skb && !skb_is_nonlinear(skb) && !skb_cloned(skb)) {
>                 skb_trim(skb, 0);
>                 skb_get(skb);
>                 skb_reset_transport_header(skb);
>         } else {
> +               if (skb)
> +                       kfree (skb);
>                 skb = alloc_skb(len, gfp);
>         }
>         t4_set_arp_err_handler(skb, NULL, NULL);
> --
> 1.9.1
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Mathias Krause <minipli-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Subject: Re: [PATCH] IB/netlink: remove superfluous RDMA_NL_GET_OP() masking
Date: Tue, 15 Oct 2013 18:10:27 +0200
Message-ID: <CA+rthh87D+yLE-nTQwVG-LGar_e8sYUKievWUnmk30RH-q7=GA@mail.gmail.com>
References: <1380571434-15391-1-git-send-email-minipli@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1380571434-15391-1-git-send-email-minipli-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Mathias Krause <minipli-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 30 September 2013 22:03, Mathias Krause <minipli-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org> wrote:
> 'op' is the already RDMA_NL_GET_OP() masked 'type'. No need to mask it
> again.
>
> Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Mathias Krause <minipli-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
> ---
>  drivers/infiniband/core/netlink.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/infiniband/core/netlink.c b/drivers/infiniband/core/netlink.c
> index da06abd..a1e9cba 100644
> --- a/drivers/infiniband/core/netlink.c
> +++ b/drivers/infiniband/core/netlink.c
> @@ -148,7 +148,7 @@ static int ibnl_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
>         list_for_each_entry(client, &client_list, list) {
>                 if (client->index == index) {
>                         if (op < 0 || op >= client->nops ||
> -                           !client->cb_table[RDMA_NL_GET_OP(op)].dump)
> +                           !client->cb_table[op].dump)
>                                 return -EINVAL;
>
>                         {
> --
> 1.7.10.4
>

Ping. Comments, anybody?

Mathias
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

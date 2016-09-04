From: Moni Shoua <monis@mellanox.com>
Subject: Re: [PATCH] IB/rxe: fix GFP_KERNEL in spinlock context
Date: Sun, 4 Sep 2016 13:01:29 +0300
Message-ID: <CAG9sBKPQf=G0WpJXf0UAhDXdtaF9i5ZXBQ8rCv9nEORBKjp28g@mail.gmail.com>
References: <1472849213-27579-1-git-send-email-khoroshilov@ispras.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1472849213-27579-1-git-send-email-khoroshilov@ispras.ru>
Sender: linux-kernel-owner@vger.kernel.org
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma <linux-rdma@vger.kernel.org>, linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Sep 2, 2016 at 11:46 PM, Alexey Khoroshilov
<khoroshilov@ispras.ru> wrote:
> There is skb_clone(skb, GFP_KERNEL) in spinlock context
> in rxe_rcv_mcast_pkt().
>
> Found by Linux Driver Verification project (linuxtesting.org).
>
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> ---
>  drivers/infiniband/sw/rxe/rxe_recv.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/infiniband/sw/rxe/rxe_recv.c b/drivers/infiniband/sw/rxe/rxe_recv.c
> index 3d464c23e08b..144d2f129fcd 100644
> --- a/drivers/infiniband/sw/rxe/rxe_recv.c
> +++ b/drivers/infiniband/sw/rxe/rxe_recv.c
> @@ -312,7 +312,7 @@ static void rxe_rcv_mcast_pkt(struct rxe_dev *rxe, struct sk_buff *skb)
>                  * make a copy of the skb to post to the next qp
>                  */
>                 skb_copy = (mce->qp_list.next != &mcg->qp_list) ?
> -                               skb_clone(skb, GFP_KERNEL) : NULL;
> +                               skb_clone(skb, GFP_ATOMIC) : NULL;
>
>                 pkt->qp = qp;
>                 rxe_add_ref(qp);
> --
> 2.7.4
>
Acked-by: Moni Shoua <monis@mellanox.com>

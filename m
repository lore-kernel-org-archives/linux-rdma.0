From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v2] IB/rxe: don't crash, if allocation of crc algorithm failed
Date: Tue, 31 Oct 2017 13:08:46 +0200
Message-ID: <CAG9sBKPFGjz8TE-M7_ak3kCypG6m6fJvFpeL3DXEjhjvo_0yWw@mail.gmail.com>
References: <20171031101647.45111-1-tbogendoerfer@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171031101647.45111-1-tbogendoerfer-l3A5Bk7waGM@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Bogendoerfer <tbogendoerfer-l3A5Bk7waGM@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailinglist <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 31, 2017 at 12:16 PM, Thomas Bogendoerfer
<tbogendoerfer-l3A5Bk7waGM@public.gmane.org> wrote:
> Following crash happens, if crc algorithm couldn't be allocated:
>
> [ 1087.989072] rdma_rxe: loaded
> [ 1097.855397] PCLMULQDQ-NI instructions are not detected.
> [ 1097.901220] rdma_rxe: failed to allocate crc algorithmi err:-2
> [ 1097.901248] BUG: unable to handle kernel
> [ 1097.901249] NULL pointer dereference
> [ 1097.901250]  at 0000000000000046
> [...]
>
> Reason is that rxe->tfm is assigned the error return, which will then
> be used for crypto_free_shash() in rxe_cleanup. Fix by using a
> temporary variable and assigning it rxe->tfm after allocation succeeded.
>
> Fixes: cee2688e3cd6 ("IB/rxe: Offload CRC calculation when possible")
> Signed-off-by: Thomas Bogendoerfer <tbogendoerfer-l3A5Bk7waGM@public.gmane.org>
> ---
>  drivers/infiniband/sw/rxe/rxe_verbs.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c b/drivers/infiniband/sw/rxe/rxe_verbs.c
> index ff77f4f66970..d03002b9d84d 100644
> --- a/drivers/infiniband/sw/rxe/rxe_verbs.c
> +++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
> @@ -1192,6 +1192,7 @@ int rxe_register_device(struct rxe_dev *rxe)
>         int err;
>         int i;
>         struct ib_device *dev = &rxe->ib_dev;
> +       struct crypto_shash *tfm;
>
>         strlcpy(dev->name, "rxe%d", IB_DEVICE_NAME_MAX);
>         strlcpy(dev->node_desc, "rxe", sizeof(dev->node_desc));
> @@ -1289,12 +1290,13 @@ int rxe_register_device(struct rxe_dev *rxe)
>         dev->get_hw_stats = rxe_ib_get_hw_stats;
>         dev->alloc_hw_stats = rxe_ib_alloc_hw_stats;
>
> -       rxe->tfm = crypto_alloc_shash("crc32", 0, 0);
> -       if (IS_ERR(rxe->tfm)) {
> +       tfm = crypto_alloc_shash("crc32", 0, 0);
> +       if (IS_ERR(tfm)) {
>                 pr_err("failed to allocate crc algorithm err:%ld\n",
> -                      PTR_ERR(rxe->tfm));
> -               return PTR_ERR(rxe->tfm);
> +                      PTR_ERR(tfm));
> +               return PTR_ERR(tfm);
>         }
> +       rxe->tfm = tfm;
>
>         err = ib_register_device(dev, NULL);
>         if (err) {
> --
> 2.12.3
>
> --
Thanks

Acked-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

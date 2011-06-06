From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: [PATCH] ib: mlx4 map fix for large hugetlb areas
Date: Mon, 6 Jun 2011 09:09:42 -0700
Message-ID: <BANLkTikatAo9FYO=iuNzCk2X9x_mAr3mZg@mail.gmail.com>
References: <20110606112953.GA20154@alonid-pc>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110606112953.GA20154@alonid-pc>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan aloni <alonid-IGuEOkGjbyfby3iVrkZq2A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Julian Satran <julians-IGuEOkGjbyfby3iVrkZq2A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 6, 2011 at 4:29 AM, Dan aloni <alonid-IGuEOkGjbyfby3iVrkZq2A@public.gmane.org> wrote:
> --- a/drivers/infiniband/hw/mlx4/mr.c
> +++ b/drivers/infiniband/hw/mlx4/mr.c
> @@ -140,7 +140,7 @@ static int handle_hugetlb_user_mr(struct ib_pd *p=
d, struct mlx4_ib_mr *mr,
> =A0 =A0 =A0 =A0int off =3D start & (HPAGE_SIZE - 1);
>
> =A0 =A0 =A0 =A0n =3D DIV_ROUND_UP(off + umem->length, HPAGE_SIZE);
> - =A0 =A0 =A0 arr =3D kmalloc(n * sizeof *arr, GFP_KERNEL);
> + =A0 =A0 =A0 arr =3D vmalloc(n * sizeof *arr);
> =A0 =A0 =A0 =A0if (!arr)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -ENOMEM;
>

I'm not able to find anywhere in the mlx4 driver where this patch
would have a chance at applying??

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

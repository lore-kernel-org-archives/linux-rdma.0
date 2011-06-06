From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] ib: mlx4 map fix for large hugetlb areas
Date: Mon, 6 Jun 2011 22:27:43 +0300
Message-ID: <20110606192743.GA418@mtldesk30>
References: <20110606112953.GA20154@alonid-pc>
 <BANLkTikatAo9FYO=iuNzCk2X9x_mAr3mZg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <BANLkTikatAo9FYO=iuNzCk2X9x_mAr3mZg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: Dan aloni <alonid-IGuEOkGjbyfby3iVrkZq2A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Julian Satran <julians-IGuEOkGjbyfby3iVrkZq2A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jun 06, 2011 at 09:09:42AM -0700, Roland Dreier wrote:
> On Mon, Jun 6, 2011 at 4:29 AM, Dan aloni <alonid-IGuEOkGjbyfby3iVrkZq2A@public.gmane.org> wrot=
e:
> > --- a/drivers/infiniband/hw/mlx4/mr.c
> > +++ b/drivers/infiniband/hw/mlx4/mr.c
> > @@ -140,7 +140,7 @@ static int handle_hugetlb_user_mr(struct ib_pd =
*pd, struct mlx4_ib_mr *mr,
> > =A0 =A0 =A0 =A0int off =3D start & (HPAGE_SIZE - 1);
> >
> > =A0 =A0 =A0 =A0n =3D DIV_ROUND_UP(off + umem->length, HPAGE_SIZE);
> > - =A0 =A0 =A0 arr =3D kmalloc(n * sizeof *arr, GFP_KERNEL);
> > + =A0 =A0 =A0 arr =3D vmalloc(n * sizeof *arr);
> > =A0 =A0 =A0 =A0if (!arr)
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -ENOMEM;
> >
>=20
> I'm not able to find anywhere in the mlx4 driver where this patch
> would have a chance at applying??
>=20

I submitted this patch about 2 years ago. As far as I recall there was
a problem to obtain the huge page size for powerpc archs and that's
were the patch died. We're are using it in OFED for x86_64 and it
gives significant improvement when registering huge pages. I will
re-submit an up to date version.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

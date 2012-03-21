From: <Parav.Pandit-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH 6/9] ocrdma: Driver for Emulex OneConnect RDMA adapter
Date: Wed, 21 Mar 2012 11:56:12 -0700
Message-ID: <88B766C272F2C64B944B21AD078333151C964A63E7@EXMAIL.ad.emulex.com>
References: <1332283154-16369-1-git-send-email-parav.pandit@emulex.com>
 <1332283154-16369-2-git-send-email-parav.pandit@emulex.com>
 <1332283154-16369-3-git-send-email-parav.pandit@emulex.com>
 <1332283154-16369-4-git-send-email-parav.pandit@emulex.com>
 <1332283154-16369-5-git-send-email-parav.pandit@emulex.com>
 <1332283154-16369-6-git-send-email-parav.pandit@emulex.com>
 <5abe3043-81f8-448a-9e55-b29e23f4eb9a@exht1.ad.emulex.com>
 <4F6A130E.2030602@systemfabricworks.com>
 <CAL1RGDXaV5nWoa5eHBHPCAomx04NHK2bA+yuuf4cqmF6RodrkQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDXaV5nWoa5eHBHPCAomx04NHK2bA+yuuf4cqmF6RodrkQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Inline.

> -----Original Message-----
> From: Roland Dreier [mailto:roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org]
> Sent: Wednesday, March 21, 2012 11:27 PM
> To: frank zago
> Cc: Pandit, Parav; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [PATCH 6/9] ocrdma: Driver for Emulex OneConnect RDMA
> adapter
>=20
> On Wed, Mar 21, 2012 at 10:42 AM, frank zago
> <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org> wrote:
> > On 03/20/2012 05:39 PM, parav.pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org wrote:
> >> +struct ib_mr *ocrdma_get_dma_mr(struct ib_pd *ibpd, int acc) {
> >> + =A0 =A0 struct ocrdma_mr *mr;
> >> +
> >> + =A0 =A0 mr =3D ocrdma_alloc_lkey(ibpd, acc, 0,
> >> + OCRDMA_ADDR_CHECK_DISABLE);
> >> + =A0 =A0 if (!mr)
> >> + =A0 =A0 =A0 =A0 =A0 =A0 return ERR_PTR(-ENOMEM);
> >
> > ocrdma_alloc_lkey does not return NULL on error.
>=20
I'll fix this part.

> Good catch!  Even more to the point, ocrdma_alloc_lkey() doesn't retu=
rn a
> struct ocrdma_mr* on success.  So this function is totally broken.
>=20
It does returns ocrdma_mr* on success. Why do you think it doesn't retu=
rn? Below is the snippet.

        status =3D ocrdma_mbx_alloc_lkey(dev, &mr->hwmr, pd->id, addr_c=
heck);
        if (status) {
                kfree(mr);
                return ERR_PTR(-ENOMEM);
        }
        mr->pd =3D pd;
        atomic_inc(&pd->use_cnt);
        mr->ibmr.lkey =3D mr->hwmr.lkey;
        if (mr->hwmr.remote_wr || mr->hwmr.remote_rd)
                mr->ibmr.rkey =3D mr->hwmr.lkey;
        return mr;
>  - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 14/14] RDMA/bnxt_re: Update the driver version
Date: Thu, 11 May 2017 11:27:00 +0300
Message-ID: <20170511082700.GA3616@mtr-leonro.local>
References: <1494413139-11883-1-git-send-email-selvin.xavier@broadcom.com>
 <1494413139-11883-15-git-send-email-selvin.xavier@broadcom.com>
 <84d9a0ce-0e5c-fc50-237f-b7ad9d541324@intel.com>
 <20170510155430.GC1839@mtr-leonro.local>
 <CA+sbYW2ObMdDOdhPL9GMe5YNk7P2MsG5q=f+Ke5e4MU6A=WV6w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="BOKacYhQ+x31HxR3"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CA+sbYW2ObMdDOdhPL9GMe5YNk7P2MsG5q=f+Ke5e4MU6A=WV6w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--BOKacYhQ+x31HxR3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 11, 2017 at 10:52:31AM +0530, Selvin Xavier wrote:
> Thanks Leon and Dennis for your comments.
>
> The main intention of this patch is to easily map the upstream driver
> to the level of supported features in the
> internal code base. I understand the point you and others are
> mentioning while porting to older kernels or during
> the bug fixes/feature additions from other contributors. But, can we
> consider it as just a number to enable vendors
> to track their base branch?

It is up to you, just wanted to warn you that in long run it won't give
you any information. We are in similar situation and decided to change
versions in really rare situations, like addition of new driver. In other
cases, it is useless.

>
> If you still feel that this patch doesn't make sense, please let me
> know. I will post a v2 after dropping the change.
>
> Thanks,
> Selvin
>
> On Wed, May 10, 2017 at 9:24 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > On Wed, May 10, 2017 at 11:06:31AM -0400, Dennis Dalessandro wrote:
> >> On 5/10/2017 6:45 AM, Selvin Xavier wrote:
> >> > Update the driver version to the scheme used in the internal
> >> > development branches.
> >>
> >> See the feedback [1] we got from Greg KH on a similar patch.
> >>
> >> [1] https://patchwork.kernel.org/patch/7490321/
> >
> > Yeah, the things go worse when this driver ported to old kernel. This
> > numbers are entirely useless.
> >
> >>
> >> > Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> >> > ---
> >> >  drivers/infiniband/hw/bnxt_re/bnxt_re.h | 2 +-
> >> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >> >
> >> > diff --git a/drivers/infiniband/hw/bnxt_re/bnxt_re.h b/drivers/infiniband/hw/bnxt_re/bnxt_re.h
> >> > index 30bff05..9041c23b 100644
> >> > --- a/drivers/infiniband/hw/bnxt_re/bnxt_re.h
> >> > +++ b/drivers/infiniband/hw/bnxt_re/bnxt_re.h
> >> > @@ -40,7 +40,7 @@
> >> >  #ifndef __BNXT_RE_H__
> >> >  #define __BNXT_RE_H__
> >> >  #define ROCE_DRV_MODULE_NAME               "bnxt_re"
> >> > -#define ROCE_DRV_MODULE_VERSION            "1.0.0"
> >> > +#define ROCE_DRV_MODULE_VERSION            "20.6.1.0u"
> >> >
> >> >  #define BNXT_RE_DESC       "Broadcom NetXtreme-C/E RoCE Driver"
> >> >
> >> >
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> >> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--BOKacYhQ+x31HxR3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlkUIFQACgkQ5GN7iDZy
WKfV4xAAqMbXDrr7E2Ce2mo01oeB0qTRvoYiQtOkzpEoGiQXdpRz5WalKcqeIgJ5
SZU8O+DmMOMZnO3WdU3l73FqliKzPS9rEfiH1pWzwH5eFDSUqUFBnmKwNw4ynRqJ
xzFNw0ay7s1iNHanOx9/2R1XS/ULAcGO9Vmh9UV0+KbL3znTFfppZwZ8DPrxmd9A
6wpwXKrBIgF0TxgRH7xJxTbFnKwVkWzs14DJ/wRRqu13cKUogzTUDgPuBIZeGvBR
n8Nj9/siWxTr8VpmAYSY83OwXGjnRoElZAyQ9mcWRBgMtFqpxH+WxS0ukSMC8kAg
Mcgt30TocDDwkqJjxmN/gbBN0ptS4zBG4DUCVV8Y4eYHbWpH2lHOrlh1uR3zSTOU
lIfbx6v84G7qQpzXZ2F7GdoE/wVnW9KjV9wR3Wn4GKUNPhDZ/92DC98nf/GMpsVn
zlOn6BOzc1MdMq6A/0Qvjnn+9ujS3XL75wxFvy1Msb61KbHeSGeKMeO0+TMd4Pwu
OOLMfh/gaQojNaMyEpJr+AO6hKzhrLYh0OSVfeJyXLTSN3S2HOF6tRXSGwq2XmKD
wJyxIQYA13+TcQ+6v3jxmWQSKJqTN7QySfF8u+bUFA6Oe+BVZeQVV94GTp0BjQsw
Tkdg1qu9WuqUsqmh/LGKsr1Wp9QpoCuJSjovlBS2G0v29s1RdXg=
=s8++
-----END PGP SIGNATURE-----

--BOKacYhQ+x31HxR3--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

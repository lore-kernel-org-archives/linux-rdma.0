From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Endianess in cxgb4
Date: Tue, 24 Oct 2017 22:01:42 +0300
Message-ID: <20171024190142.GM16127@mtr-leonro.local>
References: <20171024183759.GK16127@mtr-leonro.local>
 <069401d34cf8$5171f6e0$f455e4a0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="zHDeOHGDnzKksZSU"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <069401d34cf8$5171f6e0$f455e4a0$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: 'RDMA mailing list' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--zHDeOHGDnzKksZSU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 24, 2017 at 01:45:52PM -0500, Steve Wise wrote:
> >
> > Hi Steve,
> >
> > I reviewed my reports from various static checkers and saw strange code
> > in build_tpte_memreg() function that in drivers/infiniband/hw/cxgb4/qp.c.
> >
> > That function has following code:
> >  614         fr->r2 = cpu_to_be32(0);
> >  615         fr->stag = cpu_to_be32(mhp->ibmr.rkey);
> >
> > The r2, stag and rkey are u32, why do you need cpu_to_be32() conversion?
> >
>
> Hey Leon,
>
> The r2 and stag fields in struct fw_ri_fr_nsmr_tpte_wr should be __be32.

it is not how it is declared in drivers/infiniband/hw/cxgb4/t4fw_ri_api.h

672 struct fw_ri_fr_nsmr_tpte_wr {
673         __u8    opcode;
674         __u8   flags;
675         __u16  wrid;
676         __u8   r1[3];
677         __u8   len16;
678         __u32  r2;
679         __u32  stag;
680         struct fw_ri_tpte tpte;
681         __u64  pbl[2];
682 };

Thanks

>
> Steve.
>

--zHDeOHGDnzKksZSU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnvjhYACgkQ5GN7iDZy
WKc+KxAAsU1uGwhHEaahRhVCScr1bHFp17zvV+aIq6cfvFTqrq5+UdfQMcOZaZAp
TPmMiTsbfbJ7COiRSsVLBlB4bWtHbBYlG5pksCdZV/q91U5MzYgOlBeZ0HxBzqlz
ZP3mPEjzAi1YYRHbfJfXYvj+xLg2BXzfpx0cnbc47edSLdFgR/8GxwJwWkAcZH2D
AJKFywerHOmiyUQMGJvu2XHjTbzkTcCxvzY5ZVzRILht4A0jn1Do8YTr5FXNFE6V
6gF4esRR1oONhm56yuoy8ydX0NgtlYZjnXWOXJTOZ10HalZoyYakiAf70/sRtpNm
u6tVREgrMSCA1lOCZrBmt4GWQ+8aTrH6cYLOC1e/RW9+uyXG+JA4m9BLJqfg0ZHz
mNBCBRw/+7qsGzGpANxsRBhFJyMNvFZAdPWMljWmmEJelR/PlyeYMeMJ1QYh64jT
msaDCnw6duqe2t06Dccoyd1zhm1gGOGisTaYapYeJW/LOI6fMWOzPfgcS/QE89+O
lILwer9FtVuNes6UpHNcoATJUeGPHcuFAZNDf5WhM3N3gzdvzHeuwjZB1QbMAJFV
9ANnwr/hc1vuYEDOi7sXdS/zyFZr6jxz6Wpkf4p4cXOXmDI9T9+EayDiu8Ylu/wT
B4aWwLynmk5s2jZf+q38pYx2uIWkCTzNez2LmrfsWka7/x33Qxc=
=ss8I
-----END PGP SIGNATURE-----

--zHDeOHGDnzKksZSU--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

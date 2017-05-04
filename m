From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma] IB/rxe: Update caller's CRC for RXE_MEM_TYPE_DMA
 memory type
Date: Thu, 4 May 2017 17:15:38 +0300
Message-ID: <20170504141538.GX22833@mtr-leonro.local>
References: <20170504123607.22708-1-leon@kernel.org>
 <D530A2EB.16906%Andrew.Boyer@emc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="20XocjIeMTCm4X0r"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <D530A2EB.16906%Andrew.Boyer-mb1K0bWo544@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Boyer, Andrew" <Andrew.Boyer-8PEkshWhKlo@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--20XocjIeMTCm4X0r
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 04, 2017 at 01:21:15PM +0000, Boyer, Andrew wrote:
>
> On 5/4/17, 8:36 AM, "linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org on behalf of Leon
> Romanovsky" <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org on behalf of
> leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> >From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> >Callers of rxe_mem_copy() provide pointer to store updated CRC
> >value. That pointer was supposed to be updated, but the
> >commit cee2688e3cd6 ("IB/rxe: Offload CRC calculation when possible")
> >mistakenly removed that assignment for RXE_MEM_TYPE_DMA memory type.
> >
> >The code worked because there are no actual callers with
> >RXE_MEM_TYPE_DMA, who are interested in returned value of crcp.
> >The one caller in read_reply(), who uses the returned crcp didn't
> >set RXE_MEM_TYPE_DMA as mem->type.
> >
> >Fixes: cee2688e3cd6 ("IB/rxe: Offload CRC calculation when possible")
> >Reported-by: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
> >Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >Acked-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >---
> >Hi Doug,
> >
> >It will be great if you forward this patch as part of your second pull
> >request.
> >As you can see from the commit message, it fixes issue spotted by Andrew.
> >
> >Thanks
> >---
> > drivers/infiniband/sw/rxe/rxe_mr.c | 2 +-
> > 1 file changed, 1 insertion(+), 1 deletion(-)
>
> Reviewed-by: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>

Thank you for catching, reviewing and testing it.

--20XocjIeMTCm4X0r
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlkLN4oACgkQ5GN7iDZy
WKfnsQ/6A/ydccYwcSXvFWSPZLvL1NuZb5hyU40+AMyYNKNF453J52iFDb5OSdBo
q37/jYetwqd2/iNmCzRnB0+TWAm+he4dOj5i5D/aLhqb9Zbs/udTuF3SMdz7RkgN
DIB/WZjQQoDPyqjKqN5PW+aXSv0nGBEnGT3SlHt3lEUPtKYgyUOLmRR5+uc7ELNq
p8UcmwlqEyebjLhmn5fHhIymhZHpTdFXPqO+NiP200i3Q4zczSYxE3Utkx3qv2lw
XsDT7ziEyzqb369CHfPc4Pk9PGwMOwt4NU1o5fa6RLWeaFvsvhtEc2yTJBgLjfQP
gtvG+yHX5WZR2bhDCBta7YrV1KTq0AoYgiUf6a0smjXlO8x27trqQRnKoXE6Kwnb
klYSdaznJbxZCtsOed5ons46JuQn3tIhpc6Rhi2s7GeJUGsgVMJLloDYocwvP8PP
D0n9eldkrAbdTuasgP2SH8l7EfEc9hHw5dMEgoDvau42NTt9pdDymj/7ZRlWJ7/6
Fqylq4p/3DWVrdP3463HoIOFSrVdPTNqAaN8HyA8Fb5xX+904h5YaFWuNV2HCi3w
TEplUAWflmgNfJglgIfmkWrrke7zXaq+XCqH2BWmtd8nyltZZO/zVI+hzIPHo3/c
ePi8AdnZ7HQCft/YABaX/4+t4hi4UuOUFiyctYEXm4ZzQh6/57o=
=oxD5
-----END PGP SIGNATURE-----

--20XocjIeMTCm4X0r--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

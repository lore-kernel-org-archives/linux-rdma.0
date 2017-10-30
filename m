From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: IB/mlx4: Use common error handling code in
 __mlx4_ib_create_flow()
Date: Mon, 30 Oct 2017 10:34:02 +0200
Message-ID: <20171030083402.GV16127@mtr-leonro.local>
References: <0bcea3cf-91e3-01d5-8d80-34cd6b611fb1@users.sourceforge.net>
 <70843f43-03c5-8295-643a-4f228ff2e907@intel.com>
 <0c92fc8e-ecb8-c7ed-0b4c-721752297222@users.sourceforge.net>
 <20171027193601.GI16127@mtr-leonro.local>
 <e2febce9-4b80-a40e-024e-5c24964301ac@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="yrxji9MxLi9YGTOD"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <e2febce9-4b80-a40e-024e-5c24964301ac-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: SF Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--yrxji9MxLi9YGTOD
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 30, 2017 at 09:04:36AM +0100, SF Markus Elfring wrote:
> >>> I mean you aren't really making the code any smaller
> >>
> >> Would anybody like to check corresponding effects in more detail
> >> after a specific function call was replaced by a goto statement?
> >
> > You are supposed to do it and not "anybody".
>
> I can offer another bit of information for this software development disc=
ussion.
>
> The following build settings were active in my =E2=80=9CMakefile=E2=80=9D=
 for this Linux test case.
>
> =E2=80=A6
> HOSTCFLAGS   =3D -Wall -Wmissing-prototypes -Wstrict-prototypes -O0 -fomi=
t-frame-pointer -std=3Dgnu89
> =E2=80=A6
>
>
> The affected source file can be compiled for the processor architecture =
=E2=80=9Cx86_64=E2=80=9D
> by a tool like =E2=80=9CGCC 6.4.1+r251631-1.3=E2=80=9D from the software =
distribution
> =E2=80=9CopenSUSE Tumbleweed=E2=80=9D with the following command example.
>
> my_cc=3D/usr/bin/gcc-6 \
> && my_module=3Ddrivers/infiniband/hw/mlx4/main.o \
> && git checkout next-20171009 \
> && make -j4 CC=3D"${my_cc}" HOSTCC=3D"${my_cc}" allmodconfig "${my_module=
}" \
> && size "${my_module}" \
> && git checkout next_fine-tuning_in_mlx4_1 \
> && make -j4 CC=3D"${my_cc}" HOSTCC=3D"${my_cc}" allmodconfig "${my_module=
}" \
> && size "${my_module}"
>
>
> Do you find the following details useful for further clarification?

Almost, you should compare sizes of mlx4_ib.ko and not drivers/infiniband/h=
w/mlx4/main.o.

Thanks

>
> text: -32
> data: 0
> bss:  0
>
> Regards,
> Markus

--yrxji9MxLi9YGTOD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAln24/kACgkQ5GN7iDZy
WKdaIBAAnV+G8rsHI06i5tZhAabB/8l85gS92t2Cdz4r1XJZg0i1sun1twxiLUZG
NbVOjrzXTyaa9hKOXIBnFIbNXgnufiKlm0gopRxbXRGl7xavNFV/sD6XB1iRDM5T
X0i09pFYJCP/mZIaeEskcam4Ayk3cCHnOXSp/EFYM1eq2hktJaaHPjju4CDiWXIs
g4zdHWgHrWTOl4Gw1IRsuyIFhqHf+WuRAZ0SUC0FOiHUFPE/py8HmZl93WmX8d14
zDwrU4eQHsMSWcX1EJRSBO1nH9NeDXo+0YZeNG01vyPWnkKgy8up6YC197XX/qev
5bz4cerl/2TAnkv/1oI4o2xInniAmir5A/qRrAMfr2UtHEG/Zy9JEOoj+/4t7eUk
rel9JCBXjQgfH786Z/B0pcp4EeD7ruBt8Dgb3grYVw5l9MXxP13gn/TKG36QjhFT
Jb8U9uF7oN3Xpj5a5lPzy+oLzaLGB8f1QMDX6f8gYgPkfXQaQx2wfWCe90vogbhV
uxuNLVlrqV6EWL61tHMyqSng6YwtVHQiY5BGt4Na9C5wL9BeE7kGfgxuTyjLK3/J
yVms7F1zexuCFpo1gJIb8Ug9s0HVcUxuaqLnxxyFjo8Mkgk+bnTt4gI+BEZYN2Nu
0FawFcy8s4KSZOKddwYZFYZ3f8ZxHifg4kFtisCuOs7za0YhQaA=
=CNsQ
-----END PGP SIGNATURE-----

--yrxji9MxLi9YGTOD--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

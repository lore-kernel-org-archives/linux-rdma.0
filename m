From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH V2 rdma-core 0/5] Userspace library matching for hip08
 RoCE
Date: Tue, 24 Oct 2017 15:13:54 +0300
Message-ID: <20171024121354.GG16127@mtr-leonro.local>
References: <1508812550-98920-1-git-send-email-oulijun@huawei.com>
 <20171024043742.GF16127@mtr-leonro.local>
 <6b081786-72a5-5add-a302-37b51a6c02a4@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="hTiIB9CRvBOLTyqY"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <6b081786-72a5-5add-a302-37b51a6c02a4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--hTiIB9CRvBOLTyqY
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 24, 2017 at 04:41:57PM +0800, oulijun wrote:
> =E5=9C=A8 2017/10/24 12:37, Leon Romanovsky =E5=86=99=E9=81=93:
> > On Tue, Oct 24, 2017 at 10:35:45AM +0800, Lijun Ou wrote:
> >> This patch series add userspace library for hip08 RoCE driver. It will
> >> work with the kernel driver of hip08 RoCE(hns-roce-hw-v2.ko).
> >>
> >> Change from V1:
> >> - Fix build warning due to the strange placement of fprintf
> >>
> >
> > It still fails to build cleanly.
> > https://travis-ci.org/linux-rdma/rdma-core/builds/291891845?utm_source=
=3Dgithub_status&utm_medium=3Dnotification
> >
> > [74/190] Building C object providers/h...s/hns-rdmav16.dir/hns_roce_u_h=
w_v2.c.o
> > FAILED: /usr/bin/clang-4.0 -Dhns_rdmav16_EXPORTS -Werror -Wall -Wextra =
-Wno-sign-compare -Wno-unused-parameter -Wmissing-prototypes -Wmissing-decl=
arations -Wwrite-strings -Wformat=3D2 -Wshadow -Wstrict-prototypes -Wold-st=
yle-definition -Wredundant-decls -O2 -g -fPIC -Iinclude -I/usr/include/libn=
l3 -std=3Dgnu11 -MMD -MT providers/hns/CMakeFiles/hns-rdmav16.dir/hns_roce_=
u_hw_v2.c.o -MF providers/hns/CMakeFiles/hns-rdmav16.dir/hns_roce_u_hw_v2.c=
=2Eo.d -o providers/hns/CMakeFiles/hns-rdmav16.dir/hns_roce_u_hw_v2.c.o -c =
=2E./providers/hns/hns_roce_u_hw_v2.c
> > ../providers/hns/hns_roce_u_hw_v2.c:40:20: error: unused function 'set_=
raddr_seg_v2' [-Werror,-Wunused-function]
> > static inline void set_raddr_seg_v2(struct hns_roce_v2_wqe_raddr_seg *r=
seg,
> >  ^
> > 1 error generated.
> > [74/190] Building C object providers/h...s/hns-rdmav16.dir/hns_roce_u_h=
w_v1.c.o
> >
> > Please use buildlib/cbuild script to test your patch series, the option=
 "travis" will run the same checkers as I'm running.
> >
> > Thanks
> >
> Hi=EF=BC=8C leon
>  sorry, I am fail to run cbuild tools.
>  the cmd as follows:
>  oulijun@Turing-Arch-b:~/rdma/rdma-core/buildlib$ ./cbuild pkg travis
> HEAD is now at 5d410f5 libhns: Update consolidate repo for userspace libr=
ary of hip08 RoCE
>
> Can I use the cbuild tools quickly? Can I use buildlib/cbuild scripts for=
 check?

It was our intention.

You are supposed to run cbuild script directly from source root directory.

There is extensive help in the beginning of cbuild script, but it can be
narrowed to the following three commands:

1) Create and download docker images (you are supposed to run this once
only, per requested operating system)
=E2=9E=9C  rdma-core git:(master) ./buildlib/cbuild build-images travis

2) Compile for the target
=E2=9E=9C  rdma-core git:(master) ./buildlib/cbuild make travis

3) Actually run all scripts specific to that target
=E2=9E=9C  rdma-core git:(master) ./buildlib/cbuild pkg travis

Thanks

>
> thanks
> Lijun Ou
>

--hTiIB9CRvBOLTyqY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnvLoIACgkQ5GN7iDZy
WKen/hAAqi0WW8HcAkLww2SA3SUd4IVS/sRllGpIusjXxUOMrGk4kBok2AigrJCG
E/vtxfHx4xC+iylFSCX9nL3RZcX9fvapmf5lLiStMsMApNn/DPCxFrT7g37/1Tut
KuDwHTjbj0VYSmOCGJz87EgNwVNQx7wYE89karYmT4UhF+Aejy4J2B5HGSh8HhwF
imuU7SsJ3MgEPdKkRum1K+Zb87Sgyw9n75nG5jkTtEEvWElI/DXs55UdmJBH2aqz
Y/HAD7wYZOHXMvar3BJpjhAqV/wgeZsUTGdRSxPZnQG5haszUq8v1UoBYngWvApn
+BQvacnDs/QMujtp3ASDUwjwm9+7IpsPthv8GsGUG6W+ARFNDU/Q0wtjdYSF5DkC
7/Cg36xdBn86F7VOE1sai1NorFCmPFVBX60oMt4Vt+1jRT5bUNkajhNEwIyJhKdb
vmal5vJW3Gce4lpvI/BKe8zsApP0Eb6nkCMl2MFIjoKlCnRfvfMAsVO9IckHX7et
m2lwJuvusL/w6NSc8RiaSfo8H5HfdMxXAbV5u7hHLqqwOgyeYkF9O9lMyzkssKb0
GyTISwyD+CHK8B32igvF9GjVYrAiNeBj9AYzcZJdWsf86p4dCzAa1QEx245hwEEy
nd7AOUUWWPAoBBWMBqTimEq+hOi2axYHTk+PHsMF4nrHrNfBnF0=
=yclX
-----END PGP SIGNATURE-----

--hTiIB9CRvBOLTyqY--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

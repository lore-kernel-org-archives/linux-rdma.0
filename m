From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core 0/5] Userspace library matching for hip08 RoCE
Date: Mon, 23 Oct 2017 20:27:25 +0300
Message-ID: <20171023172725.GN2106@mtr-leonro.local>
References: <1508245946-145697-1-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="i8OEs6gA6Pkg4k/n"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1508245946-145697-1-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--i8OEs6gA6Pkg4k/n
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 17, 2017 at 09:12:21PM +0800, Lijun Ou wrote:
> This patch series add userspace library for hip08 RoCE driver. It will
> work with the kernel driver of hip08 RoCE(hns-roce-hw-v2.ko).
>
> Lijun Ou (5):
>   libhns: Add new PCI device matching for hip08
>   libhns: Introduce QP operations refered to hip08 RoCE device
>   libhns: Introduce CQ operations refered to hip08 device
>   libhns: Reimplement verbs of post_send and post_recv for hip08 RoCE
>   libhns: Update consolidate repo for userspace library of hip08 RoCE
>

Hi Lijun,

sorry for my slow response, your code causes to warnings during
compilation:

-- Build files have been written to: /home/leonro/src/rdma-core/build
[81/190] Building C object providers/hns/CMakeFiles/hns-rdmav16.dir/hns_roc=
e_u_hw_v2.c.o
=2E./providers/hns/hns_roce_u_hw_v2.c: In function =E2=80=98hns_roce_v2_han=
dle_error_cqe=E2=80=99:
=2E./providers/hns/hns_roce_u_hw_v2.c:62:3: warning: statement will never b=
e executed [-Wswitch-unreachable]
   fprintf(stderr, PFX "error cqe!\n");
   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Please fix it.

Thanks

--i8OEs6gA6Pkg4k/n
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnuJn0ACgkQ5GN7iDZy
WKfr/BAAhve8fAaYhPmDSYcesmV/83in6E7A9KhzVPz7wBC+jT8K5BcIi3VF+1kM
ruBbDbIVfwSpIrgJ/NIK7p97VnK2AiX3XKa6qy9+3Btncg3VXJmP+dWf5LRjxoe7
AoC8+NbcyN6ahPaXj4OX9lctBLS2JHYry2Y8HnC5co1gGbg0EnGyyBhulCW5jxbC
R6bBYUcpX4NhoR/wYsVPMLP+RN1QWQ9A6wvKTwj4nALC8KS+PNHi9hs6xfgJbT9j
cFgImkpkiC3IBsT0yUmQFZYW3WvH0yVREgiaVpZm/9Nh9Q/PgEnxJJ2jSb57mOZM
NSVHg39BZA6jfrfJRolaaLaYhrla3tpJAiaxuvjzbhekS2rpoGlA5+23nPro7c1c
hN/RfYdMmcZYy1vbOVWZZ9Flg4NuDaC+bWM5CebMle1rke/exRdnU/93BWH0QKpi
mbHm0GzCuyXJ9aEWd1RsPFytth5BlrA5adOlfwQJkZ/9lds0K3yB8+z6qB9Wmbc5
wwFTzbWNVtmPCkq3QX5BR98uDkOM5wkz/lpVC2jyARAHpI2/Z1otlfDCyNMEen7s
cpkGSTSuTprZZzq/RHG627Et7JyuIJjAbE2d/ypaEGVaYh/vH3tblFSk9Ymz5hYZ
0MoafW8dK32MUYI2G2gqqr1OR/ScQ4ImlEMyBvJ8IMCQjvm235w=
=gWsh
-----END PGP SIGNATURE-----

--i8OEs6gA6Pkg4k/n--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

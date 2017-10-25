From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH V3 rdma-core 0/5] Userspace library matching for hip08
 RoCE
Date: Wed, 25 Oct 2017 10:34:30 +0300
Message-ID: <20171025073430.GO16127@mtr-leonro.local>
References: <1508851309-183263-1-git-send-email-oulijun@huawei.com>
 <20171024152836.GJ16127@mtr-leonro.local>
 <20171025053833.GN16127@mtr-leonro.local>
 <7689f70b-746a-44b8-91b3-81294d83b2a6@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="TYjWXklH5JTzT8n9"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <7689f70b-746a-44b8-91b3-81294d83b2a6-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--TYjWXklH5JTzT8n9
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 25, 2017 at 02:29:26PM +0800, oulijun wrote:
> =E5=9C=A8 2017/10/25 13:38, Leon Romanovsky =E5=86=99=E9=81=93:
> > On Tue, Oct 24, 2017 at 06:28:36PM +0300, Leon Romanovsky wrote:
> >> On Tue, Oct 24, 2017 at 09:21:44PM +0800, Lijun Ou wrote:
> >>> This patch series add userspace library for hip08 RoCE driver. It will
> >>> work with the kernel driver of hip08 RoCE(hns-roce-hw-v2.ko).
> >>>
> >>> Change from V2:
> >>> - Fix the spelling with referred
> >>> - Eliminate the warning by travis-CI
> >>>
> >>> Change from V1:
> >>> - Fix build warning due to the strange placement of fprintf
> >>>
> >>
> >> I created pull request, but Travis CI doesn't seem like working.
> >> https://github.com/linux-rdma/rdma-core/pull/230
> >>
> >> I'll try to restart it a little bit later.
> >
> > OK, I gave up and rerun it locally and it fails to compile.
> >
> > Did you run cbuild travis?
> >
> Sorry, I have tried to run cbuild travis before send PATCH V2 and it is o=
k.
> I also run it according to you provide way. it is print as follows:
> oulijun@Turing-Arch-b:~/rdma/rdma-core/buildlib$ python2 cbuild pkg travis

I don't know if it matters, but I run the cbuild from top-directory,
e.g. python2 buildlib/cbuild ...

Can i assume that you run "cbuild build-image travis" and "cbuild make trav=
is" before?
Did it finish successfully?

=46rom the error below seems like you had an issue with your internet
connection.

Thanks


> HEAD is now at d0a1424 libhns: Update consolidate repo for userspace libr=
ary of hip08 RoCE
> fatal: unable to access 'https://github.com/linux-rdma/rdma-core.git/': F=
ailed to connect to github.com port 443: Connection timed out
> Traceback (most recent call last):
>   File "cbuild", line 789, in <module>
>     args.func(args);
>   File "cbuild", line 618, in cmd_pkg
>     run_travis_build(args,env);
>   File "cbuild", line 565, in run_travis_build
>     "master"]);
>   File "/usr/lib/python2.7/subprocess.py", line 540, in check_call
>     raise CalledProcessError(retcode, cmd)
> subprocess.CalledProcessError: Command '['git', '--git-dir', '/home/oulij=
un/rdma/rdma-core/.git', 'fetch', '--no-tags', 'https://github.com/linux-rd=
ma/rdma-core.git', 'HEAD', 'master']' returned non-zero exit status 128
>
>
> > =E2=9E=9C  rdma-core git:(2017-10-24-2) python2 ./buildlib/cbuild pkg t=
ravis
> > <....>
> > [70/183] Building C object providers/i40iw/CMakeFiles/i40iw-rdmav16.dir=
/i40iw_umain.c.o
> > FAILED: /usr/bin/gcc-7  -Dhns_rdmav16_EXPORTS -Werror -m32  -std=3Dgnu1=
1 -Wall -Wextra -Wno-sign-compare -Wno-unused-parameter -Wmissing-prototype=
s -Wmissing-declarations -Wwrite-strings -Wformat=3D2 -Wshadow -Wstrict-pro=
totypes -Wold-style-definition -Wredundant-decls -O2 -g  -fPIC -Iinclude -M=
MD -MT providers/hns/CMakeFiles/hns-rdmav16.dir/hns_roce_u_hw_v2.c.o -MF "p=
roviders/hns/CMakeFiles/hns-rdmav16.dir/hns_roce_u_hw_v2.c.o.d" -o provider=
s/hns/CMakeFiles/hns-rdmav16.dir/hns_roce_u_hw_v2.c.o   -c ../providers/hns=
/hns_roce_u_hw_v2.c
> > ../providers/hns/hns_roce_u_hw_v2.c: In function 'get_send_wqe':
> > ../providers/hns/hns_roce_u_hw_v2.c:131:18: error: cast from pointer to=
 integer of different size [-Werror=3Dpointer-to-int-cast]
> >   return (void *)((uint64_t)(qp->buf.buf) + qp->sq.offset +
> >                   ^
> > ../providers/hns/hns_roce_u_hw_v2.c:131:9: error: cast to pointer from =
integer of different size [-Werror=3Dint-to-pointer-cast]
> >   return (void *)((uint64_t)(qp->buf.buf) + qp->sq.offset +
> >          ^
> > ../providers/hns/hns_roce_u_hw_v2.c: In function 'get_send_sge_ex':
> > ../providers/hns/hns_roce_u_hw_v2.c:137:18: error: cast from pointer to=
 integer of different size [-Werror=3Dpointer-to-int-cast]
> >   return (void *)((uint64_t)(qp->buf.buf) + qp->sge.offset +
> >                   ^
> > ../providers/hns/hns_roce_u_hw_v2.c:137:9: error: cast to pointer from =
integer of different size [-Werror=3Dint-to-pointer-cast]
> >   return (void *)((uint64_t)(qp->buf.buf) + qp->sge.offset +
> >          ^
> > cc1: all warnings being treated as errors
> > ninja: build stopped: subcommand failed.
> >
> > Thanks
> >
> >>
> >> Thanks
> >
> >
>

--TYjWXklH5JTzT8n9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnwPoYACgkQ5GN7iDZy
WKd2YBAAkFeVLuhuLJfIdXMY7dt0q7ESaSA5unP/oArI0UqvpfSLX9eKvXVUbaou
KdFpyRVBsOAiajiNahdwJB7lnuUzpxKG9lLORpzgGXC9aKJgW8kWlfopVrk1F2iV
rHHDELWMNBmBTdi+feaslqrridodryVIbjR7RDAJJnPDu0ri8uCwZBOUtJHA59mb
yXLRqka1T0OJ5ii3VVURmzyLvqdzVlGCGlf88uj89UsWa6EHBufIXqpnnokpkbBO
nAncgLT8Dpo6yqJJP89H1bM92zEWBsi3KbHVqQNHCH+p/C9lquL6N2id0ePeg+Xk
71T5i6PGb8APeVQc8orZPUpVvSGPsdpZrVG2TSuaGXiUSrg9nV9Nzwtuz9yXOOzS
TAHbyd0qG/eU3ylqIEGqZ2/PacnJYDZ0qjl39ZTqgZt8PGqZaucbdBxR/2ZAYW3o
kfBIhWrWs/MCFBzNy5Cr9BlxXSsBmP5JeTJiG+PlUFeuCS85u/styzkYe/awfyrK
8UWMGLz/5kJxVLqps/5jsJNCgwIm+N/7x7soxW+YcBW842NuWIKz99iis415wuzV
beAvz+K9kMgGh1i5Oz3iy7Cn8s3l9XqBwxYPIt587eYSpErEIu387YsUHcXRlzxn
Lv+KBvm31SXSYSVPcTJge0PoIWxdhZLOdcBdBSzMJaXji/ANf5k=
=gmcV
-----END PGP SIGNATURE-----

--TYjWXklH5JTzT8n9--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

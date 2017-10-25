From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH V3 rdma-core 0/5] Userspace library matching for hip08
 RoCE
Date: Wed, 25 Oct 2017 08:38:33 +0300
Message-ID: <20171025053833.GN16127@mtr-leonro.local>
References: <1508851309-183263-1-git-send-email-oulijun@huawei.com>
 <20171024152836.GJ16127@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Ll0BBk1HBk/f94B0"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171024152836.GJ16127-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--Ll0BBk1HBk/f94B0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 24, 2017 at 06:28:36PM +0300, Leon Romanovsky wrote:
> On Tue, Oct 24, 2017 at 09:21:44PM +0800, Lijun Ou wrote:
> > This patch series add userspace library for hip08 RoCE driver. It will
> > work with the kernel driver of hip08 RoCE(hns-roce-hw-v2.ko).
> >
> > Change from V2:
> > - Fix the spelling with referred
> > - Eliminate the warning by travis-CI
> >
> > Change from V1:
> > - Fix build warning due to the strange placement of fprintf
> >
>
> I created pull request, but Travis CI doesn't seem like working.
> https://github.com/linux-rdma/rdma-core/pull/230
>
> I'll try to restart it a little bit later.

OK, I gave up and rerun it locally and it fails to compile.

Did you run cbuild travis?

=E2=9E=9C  rdma-core git:(2017-10-24-2) python2 ./buildlib/cbuild pkg travis
<....>
[70/183] Building C object providers/i40iw/CMakeFiles/i40iw-rdmav16.dir/i40=
iw_umain.c.o
FAILED: /usr/bin/gcc-7  -Dhns_rdmav16_EXPORTS -Werror -m32  -std=3Dgnu11 -W=
all -Wextra -Wno-sign-compare -Wno-unused-parameter -Wmissing-prototypes -W=
missing-declarations -Wwrite-strings -Wformat=3D2 -Wshadow -Wstrict-prototy=
pes -Wold-style-definition -Wredundant-decls -O2 -g  -fPIC -Iinclude -MMD -=
MT providers/hns/CMakeFiles/hns-rdmav16.dir/hns_roce_u_hw_v2.c.o -MF "provi=
ders/hns/CMakeFiles/hns-rdmav16.dir/hns_roce_u_hw_v2.c.o.d" -o providers/hn=
s/CMakeFiles/hns-rdmav16.dir/hns_roce_u_hw_v2.c.o   -c ../providers/hns/hns=
_roce_u_hw_v2.c
=2E./providers/hns/hns_roce_u_hw_v2.c: In function 'get_send_wqe':
=2E./providers/hns/hns_roce_u_hw_v2.c:131:18: error: cast from pointer to i=
nteger of different size [-Werror=3Dpointer-to-int-cast]
  return (void *)((uint64_t)(qp->buf.buf) + qp->sq.offset +
                  ^
=2E./providers/hns/hns_roce_u_hw_v2.c:131:9: error: cast to pointer from in=
teger of different size [-Werror=3Dint-to-pointer-cast]
  return (void *)((uint64_t)(qp->buf.buf) + qp->sq.offset +
         ^
=2E./providers/hns/hns_roce_u_hw_v2.c: In function 'get_send_sge_ex':
=2E./providers/hns/hns_roce_u_hw_v2.c:137:18: error: cast from pointer to i=
nteger of different size [-Werror=3Dpointer-to-int-cast]
  return (void *)((uint64_t)(qp->buf.buf) + qp->sge.offset +
                  ^
=2E./providers/hns/hns_roce_u_hw_v2.c:137:9: error: cast to pointer from in=
teger of different size [-Werror=3Dint-to-pointer-cast]
  return (void *)((uint64_t)(qp->buf.buf) + qp->sge.offset +
         ^
cc1: all warnings being treated as errors
ninja: build stopped: subcommand failed.

Thanks

>
> Thanks



--Ll0BBk1HBk/f94B0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnwI1kACgkQ5GN7iDZy
WKeiYQ/+Nk9zkh9V+NhorGlbo8v9uNzofqzIvo/a25lKmkaLrjZL7Ma7F81yVpL/
u1be93sDkwKDgLEb2nYhuMwiGqJKj/iHJU27dAHwdmTaT/Kv2cVnyr000zGB0pAV
F/RHp/Ihs/O0nblyRHxtAz6GCiCnS98rGUzfuqNGfv59BDEOng/w3ms+TR3SUfgY
mYNavf69szqT8auKOsMi23aj1t95Brcw9sBbM2cQo2CNW7l6DJXJdKf9Ky6Qi81o
EEh8guCH5oRVI06uGFr2AxYVPcSjzHc+t+blMCWjBl/sofZwYJK1td3uvzDNubgF
hziYIc9hcNwiceB9HskjUZSjN8hxwD8C40t5n7IGzrk1CGNyl7o1du7DDggu3Ngz
z8CwrE20GeqsAE52jSerHssbOobYhCeacY0y8OlLCJgY2IELKG19xLzVenbYUupJ
8pC8NLl1wH4fh8JUBk/iZxDF36UARUAaVIue8IjM7xXbnvcQXl7NT3LHE/btVKJz
f25ojCJxEnEBCZy2HMKnBpSFrcdwYWZSAhXavm36pwIikw8yuXFyC845kU8DZmiM
cxKB8rmTEfilt254KQDW9BGrELZxGUFMh6zMFJF89SkFKxybqjZVeYUgZYUQziwk
OanyBRGM6IGXVWkZGdQqKNCw8gfYMw+p16xuWpElOwUpWe/tKFA=
=4vQc
-----END PGP SIGNATURE-----

--Ll0BBk1HBk/f94B0--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 00/13] IB/hfi1,qib: Round 2 of hfi1/qib fixes for 4.9
Date: Sun, 2 Oct 2016 09:29:02 -0400
Message-ID: <76e5572a-e71e-51d1-b97b-7fbabb99bd05@redhat.com>
References: <20160925143656.10261.85231.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="rH6IKOCOg6RK5V0wEMdhXg2BgcaoivND8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160925143656.10261.85231.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jakub Pawlak <jakub.pawlak-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--rH6IKOCOg6RK5V0wEMdhXg2BgcaoivND8
Content-Type: multipart/mixed; boundary="7bgfeC3NgCKU5oHLCkj7B5mbIo7idoI0F";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jakub Pawlak <jakub.pawlak-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 Jianxin Xiong <jianxin.xiong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Message-ID: <76e5572a-e71e-51d1-b97b-7fbabb99bd05-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 00/13] IB/hfi1,qib: Round 2 of hfi1/qib fixes for 4.9
References: <20160925143656.10261.85231.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
In-Reply-To: <20160925143656.10261.85231.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>

--7bgfeC3NgCKU5oHLCkj7B5mbIo7idoI0F
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 9/25/2016 10:40 AM, Dennis Dalessandro wrote:
> Here is the next round of fixes and clean ups for hfi1/qib for 4.9. Mos=
tly minor
> fixes but there is a fix for stable in here. It is marked to Cc the sta=
ble list
> in the commit message so no special handling should be needed on your p=
art.
>=20
> Patches should apply on your GitHub hfi1 branch and are availabe in my =
GitRepo as
> well:
> https://github.com/ddalessa/kernel/tree/for-4.9
>=20
> ---
>=20
> Dean Luick (2):
>       IB/hfi1: Extend i2c timeout
>       IB/hfi1: Act on external device timeout
>=20
> Dennis Dalessandro (3):
>       IB/qib: Remove qpt_mask global
>       IB/hfi1: Cleanup tasklet refs in comments
>       IB/hfi1: Remove unused variable from devdata
>=20
> Harish Chegondi (1):
>       IB/hfi1: Adjust hardware buffering parameter
>=20
> Jakub Pawlak (1):
>       IB/hfi1: Fix resource release in context allocation
>=20
> Jianxin Xiong (1):
>       IB/hfi1: Increase default settings of max_cqes and max_qps
>=20
> Mike Marciniszyn (2):
>       IB/hfi1: Consolidate pio control masks into single definition
>       IB/hfi1: Fix defered ack race with qp destroy
>=20
> Sebastian Sanchez (3):
>       IB/hfi1: Remove filtering of Set(PkeyTable) in HFI SMA
>       IB/hfi1: Do not read more than a SGE length
>       IB/hfi1: Combine shift copy and byte copy for SGE reads

Thanks, series applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--7bgfeC3NgCKU5oHLCkj7B5mbIo7idoI0F--

--rH6IKOCOg6RK5V0wEMdhXg2BgcaoivND8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJX8QueAAoJELgmozMOVy/dl0IQAJoFtPV9qooqfrdBkPLUtedj
jAPfTsDNBsscD3Xx05B4TweZ0FJuxAupf7IuJXS0EJ6vPdQ/MJsHTlLfETAz+moE
ejhOcQnQXKk1KFprLViLWTk/P+8d1uttfKkcKIuOSKEGLKvqu9ea90qSHnCUvSCT
5wybCc8EVisOqPUnhPizesfO6+3S5uy33a/tE6u7V14YSIRUY5LgcuKjFI89xZJ5
gTsTiPELZrmLgvGVAJPAFf2AG6QZ2QdAPuoO4wskqaIs7kHPTznjnwRjdmNUSweT
rytYuxsbhPwaBiQtVXEVF0xvhiKvC+x3AEvWlPrXo6yoWEkqQ3HtVWZt5MDvzQjm
0WQzWAstv4a7KvyIkF+FSbbVpGkpfEfcqkIoxI/NgrgXh6G3zuB6DQA4DZzIQUcy
qzC0HLEYt3E1dZCCVSAlu4YA0v1HzlA4iCJZxc4g84ICuTzhoYlrIGXaYRPqfoSu
VkYaRF2U3iVG3dfBy5ebZtQSYINhsTdryW349AQgWi5sDgYPL9vADL3FENeg4J0o
xNQpf4TgQpChbHAQtUudwo0HKr1zNs9Q/stQ/Qoto9J27SWcb5jngTt3wSdctMNY
jmDXRVWwX2iTakfRaKOjJRIv4TvObUCkVdlzgveuhULXfYcXnAuoswsfKsTpYPM3
ZTsAtS/Ir8QJgsu2V+fW
=R5b1
-----END PGP SIGNATURE-----

--rH6IKOCOg6RK5V0wEMdhXg2BgcaoivND8--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

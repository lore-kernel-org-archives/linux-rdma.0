From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 for-rdma 0/5] Expose Issues for HNS driver
Date: Sat, 22 Jul 2017 13:10:49 -0400
Message-ID: <57355f75-5196-9a0c-9af5-7bd2ebcc1263@redhat.com>
References: <1497091765-10513-1-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ihc5M0f95BSUMEdKfGVsBO1an3ufJ5LVI"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1497091765-10513-1-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ihc5M0f95BSUMEdKfGVsBO1an3ufJ5LVI
Content-Type: multipart/mixed; boundary="iHA3mxDc8RdXqFu1mnn979a2m2sHeTlWH";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Message-ID: <57355f75-5196-9a0c-9af5-7bd2ebcc1263-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 for-rdma 0/5] Expose Issues for HNS driver
References: <1497091765-10513-1-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
In-Reply-To: <1497091765-10513-1-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

--iHA3mxDc8RdXqFu1mnn979a2m2sHeTlWH
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 6/10/2017 6:49 AM, Lijun Ou wrote:
> This patch set mainly fixes some issues exposed for hns driver. The iss=
ue
> list as follows:
>   1. Unload hns driver when test on the board which its ports less than=
 six
>   2. May happen wild pointer error excepted exit when destroy rc qp
>   3. Should use rdma_wr() for RDMA operation when post send
>   4. Delete unnecessary lock operation in hns_roce_mac()
>   5. Fix checkpatch.pl check warnings.
>=20
> Change from v1:
> - re-write the changelog
> - assgin rdma_ah_type type for roce in hns_roce_rsv_lp_qp()
>   according to 4.12
>=20
> Lijun Ou (5):
>   IB/hns: Fix the bug of polling cq failed for loopback Qps
>   IB/hns: Fix the bug with wild pointer when destroy rc qp
>   IB/hns: Fix the bug with rdma operation
>   IB/hns: Fix the bug with modifying the MAC address without removing
>     the driver
>   IB/hns: Fix for checkpatch.pl comment style warnings
>=20
>  drivers/infiniband/hw/hns/hns_roce_hw_v1.c | 83 ++++++++++++++++++----=
--------
>  drivers/infiniband/hw/hns/hns_roce_main.c  |  3 --
>  2 files changed, 51 insertions(+), 35 deletions(-)
>=20

This series has been accepted into 4.13-rc, thanks.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--iHA3mxDc8RdXqFu1mnn979a2m2sHeTlWH--

--ihc5M0f95BSUMEdKfGVsBO1an3ufJ5LVI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJZc4cZAAoJELgmozMOVy/dRVoP/jTtsOgw7PA/M8dH8I9InFVQ
PNZ4KKt9SMT4tWKH7Z/cWG8QDkm2MQIjlF62REExETTzLSgjtjV2ldatwBHDw0id
7xlDOPrRiLKkWz5cjLuGm3BYCv12ZYq+G4TLgQlc1ZCYOa6z3faaz+QTzDPRpsxx
P42S1Bvs661AunbjF3qr8fffFPRboJfbEMGrQLg2NcRRqHzjlBnAkJu+r8p1VG1r
gZkjeyjUsshm2YtnmcrPlyA0fjZKYYOKet1DhVQyr61uvsWA3VQW1vlNlAspy+/Q
nitngw8d+Qvx+KHSZdOTnEcI/0leCZW7gYP2f9u8R/0PEhj1wfzQ22ju9os10WC/
K9DZ+bqK3vs+ID7smQqXKEedXbjZTBt8vjvkJ9POca8q0H/IBH8fAZMJ6+CW1cwc
AlIhZPJHubneFNDESmOrgGtKcjFR55gee+eWk4K3FR1zrEmtExRqFueSSRoSTO7m
LXDuvnTGxws/3/Spa2lz5CbBU/OZZJfIOCNVtclFwWDIj1Y+vjuft1Q5Gchg/8Hg
kD+X5k88Vkip7MOblvdwaeKhtrr7/7ZIxWWae18E7SfzsWEaN33GTeVDszIf5sGo
aAEuR1kthi/uWKEQMDsluZAHHyyeguzACroXo7DnwlJcLKBlGTecn8btql1DxVmI
nDN18qdj1DifTkJJUMWT
=yEn2
-----END PGP SIGNATURE-----

--ihc5M0f95BSUMEdKfGVsBO1an3ufJ5LVI--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

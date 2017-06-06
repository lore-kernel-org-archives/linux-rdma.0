From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 0/5] Some fixes for HNS RoCE driver
Date: Tue, 6 Jun 2017 09:21:44 +0300
Message-ID: <20170606062144.GU6868@mtr-leonro.local>
References: <1496712288-63434-1-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Q8a9NmTVi5AMeZ2v"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1496712288-63434-1-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--Q8a9NmTVi5AMeZ2v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 06, 2017 at 09:24:43AM +0800, Lijun Ou wrote:
> This patchset introduces some fixes for the identified problems
> according to the changed IB/core and others reviews.
>
> Lijun Ou (5):
>   IB/hns: Fix the bug of polling cq failed for loopback Qps
>   IB/hns: Fix the bug with wild pointer when destroy rc qp
>   IB/hns: Fix the bug with rdma operation
>   IB/hns: Fix the bug with modifying the MAC address without removing
>     the driver
>   IB/hns: Fix for checkpatch.pl comment style warnings

It will be really helpful if you follow the SubmittingPatches guide,
use proper title, add Fixes line and provide meaningful description.

Thanks

>
>  drivers/infiniband/hw/hns/hns_roce_hw_v1.c | 82 ++++++++++++++++++------------
>  drivers/infiniband/hw/hns/hns_roce_main.c  |  3 --
>  2 files changed, 50 insertions(+), 35 deletions(-)
>
> --
> 1.9.1
>

--Q8a9NmTVi5AMeZ2v
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlk2SfgACgkQ5GN7iDZy
WKfX/RAAkHs6BqzbITutgRhQOtjOrBnk6pPkZp9E3xVJJ34SiJ1urVOYiI7hWRyg
hvAVbjPHltM71cQwOpyV+Je9Z8G4Oe+xptpLADqD+YXa9QN99djnKTzKDGk1ttLW
oWFymE1OomBmDbAkMYP6VZfHbS/aPi6dajSuYiH86Arvz9Nt3MbPArdoIbwymC6l
1diIt/yieXPeWz24XwmlIGSR6sWUzdEdQraamV3UfZ2hvaBYu2yWpWcJSfPg/DAR
LFy3sQd/HynA3ERn/mZx1xgu6095uA+ebwDfV2Gs9kIvEezZn0wmU1nx6NlyDM9O
MKMdjQ1qMpMwbF51Ezv5KZ4cauJBpJKo0yno6DMFOxBDjm4uEgp+XuQX2FIMxmqJ
oOtIEwAKbvN/W+Ay9rdS0VC+SG3Ey3bKXh9iIJNVQd77SM2Nc96fvTah/eFZ6rxG
iF09IadBmEUPrmteiQC4BOksyybuPajY11x8u2nopL/SxjH2bXWTLZlHed9yjRmX
dC77eQBWG0HvD5vHcDPFS3aMz3IA+GPxMqTejzTWRABXzhbNtClD3QF2jQqeQVR8
QlxCWXTeQAlid8HZT/uxODq2heenY2hfCoE6zRmwCitc/F8AUM/IfB8dVXj6T8JP
8y1TcIhsp7dNREdoRK1RaJK/lTpnuCAlz3e+XDtjqnUYLAqD1uU=
=S3Jo
-----END PGP SIGNATURE-----

--Q8a9NmTVi5AMeZ2v--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH v1 iproute2-next 2/4] Sync up rdma_netlink.h
Date: Sat, 23 Feb 2019 11:28:20 +0200
Message-ID: <20190223092820.GN23561@mtr-leonro.mtl.com>
References: <cover.1550773362.git.swise@opengridcomputing.com>
 <ff4f692bee0d683c0638cf88cbf14faf94ea87af.1550773362.git.swise@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="QxIEt88oQPsT6QmF"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <ff4f692bee0d683c0638cf88cbf14faf94ea87af.1550773362.git.swise@opengridcomputing.com>
Sender: netdev-owner@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>
Cc: dsahern@gmail.com, stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--QxIEt88oQPsT6QmF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 21, 2019 at 08:19:07AM -0800, Steve Wise wrote:
> Pull in the latest rdma_netlink.h to get the RDMA_NLDEV_CMD_NEWLINK /
> RDMA_NLDEV_CMD_DELLINK API.
>
> Signed-off-by: Steve Wise <swise@opengridcomputing.com>
> ---
>  rdma/include/uapi/rdma/rdma_netlink.h | 74 +++++++++++++++++++++++++++--------
>  1 file changed, 58 insertions(+), 16 deletions(-)
>

If my series go first, this patch won't be needed.

Thanks,
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>

--QxIEt88oQPsT6QmF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJccRI0AAoJEORje4g2clinHyUP/jTj+rA0W+dpBahR9d56ebW7
FSytV4P1JtFp8iAsuuXM2zTydtfH6My96v3qGwyHDFgYWrC+LMODveyoPbEZrFbT
8oRcw/V3e3A6t9WCdBo2O0qiZQy/ptS3PyaNjYe/NHqJmc7RXJaXMI9CYX6i+dg5
Uo66XGM92EC4GrHt//cJAlhGGlV1AgR5MhWzc4g4skaXHmF79K7sEZlUEGTncyfA
bEi8VFdQQDd6gh6Rh70pkUBmyFmO3G1Mrph/CjhHXDQ7XhCagoxbARnIQuyeSNJP
YJ8z3nJpZuh8DIqudiMzK3C3siEq623Mm5qpuCEIpbBxndrO+dxHWS92vGfpOses
cS5dSfurGI/B5XHDDGHSrb91mA7ZiD9RuXjOqqxa9V6/Q+0epCFCJnCybUi+I653
+YUR8YnULcx1PWBX7ao/Ti10Krp+g/+ZjrwrbgVo5m4BvBKwwAvII2r8NaXprJ9c
G2SWfdlfXB4fg+GY2zhKc0WQKyzHoe2cPEC+ZMsxfnm7I+u314ibt0zs3RQc1E23
lr5DSBRMzyyMqGnv+cXOZAyzP5h7FOxCN3xTwvmkVlpD4b74cQPSDkp9mEsBWAy1
jnt9L8J+ZCJbz1cTTsPbl61qMd1XPhul6R67RiYRsdjNYIaXG47VZ/ex/KiBaDBq
FRMNxb2xFHedwm6C/oho
=k7fM
-----END PGP SIGNATURE-----

--QxIEt88oQPsT6QmF--

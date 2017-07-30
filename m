From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 6/8] IB/hfi1: Create workqueue for link events
Date: Sun, 30 Jul 2017 12:46:00 +0300
Message-ID: <20170730094600.GO13672@mtr-leonro.local>
References: <20170729154124.21487.53119.stgit@scvm10.sc.intel.com>
 <20170729154348.21487.66943.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="HVCoas+krw6dou6l"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170729154348.21487.66943.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--HVCoas+krw6dou6l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jul 29, 2017 at 08:43:49AM -0700, Dennis Dalessandro wrote:
> From: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>
> Currently, link down interrupts queue link entries
> on a workqueue intended for sending events only.
> Create a workqueue for queuing link events.
>
> Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Sebastian Sanchez <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/infiniband/hw/hfi1/chip.c   |   20 ++++++++++----------
>  drivers/infiniband/hw/hfi1/driver.c |    2 +-
>  drivers/infiniband/hw/hfi1/hfi.h    |    1 +
>  drivers/infiniband/hw/hfi1/init.c   |   26 ++++++++++++++++++++++++++
>  drivers/infiniband/hw/hfi1/pio.c    |    2 +-
>  drivers/infiniband/hw/hfi1/sdma.c   |    2 +-
>  6 files changed, 40 insertions(+), 13 deletions(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--HVCoas+krw6dou6l
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAll9qtgACgkQ5GN7iDZy
WKfccA/8DhHMWIVYUunCPk2FjGI8gzB2CPokoq4VWyBRAoAxb8N7NY/9PY7wKTCi
/RJyt0Hym9uwdY7mRPgZOR8BeRglE74g2mZ7eBYDwH8KHxAKzx58odRDpPuSA4N2
Cen28+BkDcqdTiApajCS15Z+h9a6aqsaz6FieLa+EjuTHCqL3UTGLEYhaQoZe9Ef
ZIhocaD3YW+xfJHDoGueyIzGCkjM+ND70GU81IVO5dJwETAsAOgF+0oAAeB6RwWq
A0H5zYO1pupumXuzwtu5H2PtCzbyyMTu+m/ZHmkS94CkzkRpeyR0WXxaV1zFSLY3
xqXTsKwxXdz48/V4opuY5C86CgHtm/5UR8zoyjWmgQbeYgRbwkazXG7o2kj3xcYh
SYegMpsjiG6SugIa9kdmmBlScm7WZI9LRr/EC7U7FNje8P1pGcgb8zeO+Ydi6UTd
De/EcL13vZqoCa+Xoab4nTwCtFAB9u7EFbIDVUTlBDabIHV5Fsuwomx0g8Yr5S59
TQg6e3rgL+zZMcpX6/u/ligH843eE53pSXBWn0y0ccc1ZsgQHISSoGGvc9Vg4orD
IQlzOS8tg5YHNJ3YyuqwmRKiNS1Nb35s7cUauec1fVM9M3866pyWp/USmpauBTAL
Lx46FqAYBnxkmRhi9mcNi/Mv4uTZNy+uK6u1cSrjV7wyY2Uud6g=
=lM5g
-----END PGP SIGNATURE-----

--HVCoas+krw6dou6l--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

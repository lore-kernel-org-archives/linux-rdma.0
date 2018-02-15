From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH RESEND v1 rdma-next 3/6] RDMA/nldev: provide detailed CQ
 information
Date: Thu, 15 Feb 2018 15:28:01 +0200
Message-ID: <20180215132801.GF2197@mtr-leonro.local>
References: <cover.1518552800.git.swise@opengridcomputing.com>
 <624bf08040287a4c558f3b84d2bd60a9423b8dca.1518552800.git.swise@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="cmVHo2jXx4bdYlgS"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <624bf08040287a4c558f3b84d2bd60a9423b8dca.1518552800.git.swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--cmVHo2jXx4bdYlgS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 01, 2018 at 08:58:48AM -0800, Steve Wise wrote:
> Implement the RDMA nldev netlink interface for dumping detailed
> CQ information.
>
> Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> ---
>  drivers/infiniband/core/nldev.c  | 172 +++++++++++++++++++++++++++++++++++++++
>  include/uapi/rdma/rdma_netlink.h |   8 ++
>  2 files changed, 180 insertions(+)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--cmVHo2jXx4bdYlgS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlqFiuEACgkQ5GN7iDZy
WKfRVQ//UPj9zQBOYzvkAyDmKtIJiSrPa6RTq6c/YPAQ63pxpdMLVDWU3vKO4VvN
ZgkzOymfKUQybwrfpptGvMMa6hOQ7tToDXFZq9es6nUyhO1q15Ap79z+1qfVxfFZ
AM1mBUHFZtH1wHQDE2ZPNyrFjqt6NNNKDUXDuH+3X0LqchBiMQYKV/icMCmtY4uw
FIrc1B+GM5vyJpuGhM8HDpYx7f7beeimVRUNN5hC6SajOs8t7XmnQUvLpOgx1J48
GolqwSnWaZgLowoqKPUe908QMXBuzgMEolfsVnS5y0DRJMwaWTJfGRlirTQT5+Yg
xdnDPDNQJ/BamGtryopgyn4cQ3i2DlIyhGjQeQ4r3op3RhPHAwvXfSOfuBBIIGjT
/MTkAhNtE2nRRfth16uNhh+AGj14BT3ls3jJQ92GQ8vh+5XMDsqsM8RbkT8+z4aS
Scd4JxJcE6QH0JL9XJZzfKWm6Kg10FIwSGqlxg8KTbjvF81gIy2nFkIRfeJEGXKX
XDj6Y2wXj4fFUeLWIHatTEemxy2jASG4G94hqZ6pCKMDDwofqub2x8j/NEQdt+bI
J92RFwuL3luKAdqkD4ucxUn3dUeqvM7ItsKtpUcuDi6IGhW59BnTjXNqgWDLgCGB
2evuuQeMwYC/+WBmF24ziIAsQC+4bGQuGictBSahGw0KhBzLzRw=
=LnYw
-----END PGP SIGNATURE-----

--cmVHo2jXx4bdYlgS--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/3] Autoloading for RDMA netlink modules
Date: Tue, 25 Jul 2017 09:32:36 +0300
Message-ID: <20170725063236.GQ3259@mtr-leonro.local>
References: <1500935204-6505-1-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="5lVNUoiW0yyvItcX"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1500935204-6505-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <notifications-9UaJU3cA/F/QT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--5lVNUoiW0yyvItcX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 24, 2017 at 04:26:41PM -0600, Jason Gunthorpe wrote:
> This provides the necessary infrastructure for the kernel to automatically
> load RDMA associated netlink modules when users space sends messages to them.
>
> This is at least enough support for the kernel to autoload everything required
> for iwpmd to run.
>
> Jason Gunthorpe (3):
>   rdma: Allow demand loading of NETLINK_RDMA
>   rdma: Autoload netlink client modules
>   iwpmd: Suppress expected kernel message
>
>  drivers/infiniband/core/cma.c     |  2 +
>  drivers/infiniband/core/device.c  |  2 +
>  drivers/infiniband/core/iwcm.c    |  9 ++++
>  drivers/infiniband/core/netlink.c | 99 +++++++++++++++++++++++----------------
>  include/rdma/rdma_netlink.h       | 12 +++++
>  5 files changed, 83 insertions(+), 41 deletions(-)

There are number of reasons why I don't really like this series.

First, it interferes badly with my RDMA netlink series posted here in
previous cycle and I'm expecting to see it in, so I can move forward
with RDMAtool implementation.

Second, from brief review, it is unclear to me, how do you protect
autoload caused by regular user who sends netlink message to ib_core.

Third, it is ib_core who should autoload modules by default, and not some
random daemon in user space.

My 2-cents.

>
> --
> 2.7.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--5lVNUoiW0yyvItcX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAll25gQACgkQ5GN7iDZy
WKfDRBAAyYgl4gv3cWc3v2J5pWYlkBCGAUy2ZxxRGMRz+Id3nfFDGHwi4qiqb5R7
GUeLCH+Gj71NRZQADRvYMqFiG7um0uyt83i9oA386JDecGTU1Oj/cSTyRv/HQ7nY
RVhes2wkAaF7BZIzMWOLB/nzXWjgh/WmRoWxWbcm+rql74ihqdiBpS4ftqFhJ16g
jwXJHYzDZEXNaIjrX91Q72gjTb4DPjfiFkSHRi7LraGY36KVsRVmdZASH3/yoWPg
DbL5ryfBEsQLZuj7jjp9SIuR3hFlQB+9vg5gMZZ/D9OBN2UNRGLRiBzgaK2GKm0S
Q1nuguq3+KM1vVvy+CParO48taxoa2jsmBX6sf87jGQPtMOw2rqIa2heKj8HJzKk
KaF3wTdoCBrQFwmQMqpugz1goSKtjb5xmQd4/JeIfaEBgq5HGdQDd8cmDU5LQSvI
6H0wBl297nwUYJ05tcg9URCtOvMGTzITPp1a14yy5+VevJaPL/ia6Jrevp8i4SH4
ILBEgiG/RA4UClbfqXrjJn++9HFnLJoTrcaovqTU1De0ZVTbaB2q1fSg0h9dgmST
iQduIGmy1S6ZC5oLN3VcyVLyVvWWV5WQtfG/0cIclpa0dv0QzYwKr+SIK0F7dKZR
aJmXIHahe2+S22/hrq8jjIMQPqn6LWxsZGnin/kzgrU9TxbXggk=
=KZko
-----END PGP SIGNATURE-----

--5lVNUoiW0yyvItcX--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

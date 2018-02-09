From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] RDMA/nldev: Fix multiple potential NULL pointer
 dereferences
Date: Fri, 9 Feb 2018 14:25:49 +0200
Message-ID: <20180209122549.GK2197@mtr-leonro.local>
References: <20180209063702.GA28685@embeddedgus>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ZmUaFz6apKcXQszQ"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180209063702.GA28685@embeddedgus>
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <garsilva@embeddedor.com>
List-Id: linux-rdma@vger.kernel.org


--ZmUaFz6apKcXQszQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 09, 2018 at 12:37:02AM -0600, Gustavo A. R. Silva wrote:
> In case the message header and payload cannot be stored, function
> nlmsg_put returns null.
>
> Fix this by adding multiple sanity checks and avoid a potential
> null dereference on _nlh_ when calling nlmsg_end.
>
> Addresses-Coverity-ID: 1454215 ("Dereference null return value")
> Addresses-Coverity-ID: 1454223 ("Dereference null return value")
> Addresses-Coverity-ID: 1454224 ("Dereference null return value")
> Addresses-Coverity-ID: 1464669 ("Dereference null return value")
> Addresses-Coverity-ID: 1464670 ("Dereference null return value")
> Addresses-Coverity-ID: 1464672 ("Dereference null return value")
> Fixes: e5c9469efcb1 ("RDMA/netlink: Add nldev device doit implementation")
> Fixes: c3f66f7b0052 ("RDMA/netlink: Implement nldev port doit callback")
> Fixes: 7d02f605f0dc ("RDMA/netlink: Add nldev port dumpit implementation")
> Fixes: b5fa635aab8f ("RDMA/nldev: Provide detailed QP information")
> Fixes: bf3c5a93c523 ("RDMA/nldev: Provide global resource utilization")
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
>  drivers/infiniband/core/nldev.c | 26 +++++++++++++++++++++++++-
>  1 file changed, 25 insertions(+), 1 deletion(-)
>

It will be much better to fix the tool instead of fixing ghost case.
This scenario is impossible for all those flows.
We can receive the skv/msg in two ways:
 * First by allocating new message with NLMSG_DEFAULT_SIZE, which has more room
   than nlmsg_total_size(payload), payload is 0.
 * Second by getting from netlink.c and it will be at least "struct nlmsghdr" too.

Can you please add this info to the commit message?

Thanks

--ZmUaFz6apKcXQszQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlp9k00ACgkQ5GN7iDZy
WKdHARAA0vr4FdI42q35LgsZcsrFVfY5zgTZm0x4dSJbPEJ3B9FMhdr+1GOh7DFs
mn8KmIsmRMV8fgIHolE0/nOiB0devQYsw2xeOejewfld9nXd66jmFKydqmOe9NXZ
LyWv2SJzjk2ce02JDArsv6/DDKOx8HQvCW658WQFfTlV0iFQ0qQV99ZHSjbNUsNe
v2tanY8gDi0MMZKtkqquJaEviGxc+7kYctFlUDRIm7CYD/i9ZziWokFK+iQuobyZ
MG1pROsTRGXNiBuYIbUW/8F3+rz0xTLrafemsw7FqvlpMR8ttD8u/Hbm85X5e+NL
qZ0rqjAN7iRYbDChJeYpBvf/uOgE0EWBfBoKHFjxDNEfKh/dOKPRCXRyWB5H8CDE
J1OTFsDBDkA5udsApEiZFwzBnR9LQ0oo0FYO6mpGj10zlhuMdB/ZMDiBsaEJy946
xCPtHEAqFqAkrQbjWsINThhTCO4VYjE8+1Hoq1las494pc3+KgCBzLKk7+ucj6nF
qbf6fs5IZtOWkH8ro1cimfW2uVAYQe71ng4I3ibzrl5vo3vUwH6Z9DMiw+EhShiS
Sf03Uqk2Q93vwRKZyQjFCWZdD0u5gJ5NaYVUszj2bxONe+a8H0a0EGUUnBkTKtNb
PUVfmrU7JF0Iiw5h3mlwj+7IVhMT4WO8EfS1AmFBy8ph7ErxJp8=
=Glsf
-----END PGP SIGNATURE-----

--ZmUaFz6apKcXQszQ--

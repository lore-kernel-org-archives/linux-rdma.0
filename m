From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next V2 0/6] Refactor RDMA IOCTL declarations
Date: Wed, 24 Aug 2016 13:14:56 +0300
Message-ID: <20160824101456.GR15065@leon.nu>
References: <1471987907-6336-1-git-send-email-leon@kernel.org>
 <20160823214759.GA16595@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="3XZQkxCYp0f/VEFS"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160823214759.GA16595-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--3XZQkxCYp0f/VEFS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 23, 2016 at 03:47:59PM -0600, Jason Gunthorpe wrote:
> On Wed, Aug 24, 2016 at 12:31:41AM +0300, Leon Romanovsky wrote:
> > This patch set refactors RDMA IOCTL declarations, unifies their
> > location, moves all current IOCTL exporters to one place and renames
> > them to fix the differences in coding style.
>
> The end result looks reasonable enough to me.
>
> For the series
>
> Reviewed-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

Thank you

>
> Jason

--3XZQkxCYp0f/VEFS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXvXOgAAoJEORje4g2clin7oUQAKmwYWDlMASasKnZc9ElWp4a
vbfmxZnGQtSoHqx9mjVJTnnafh+HAmutcxvTqInMVcuOc5dqzBs0j+e9rBPGwHVI
pyZ+gEggrzU0NjoBXAcHHyJ6HRjmP2tv5AoGuOLDuSoHra6zxw70qYjj/jR2UtJM
BEEoGwPzDRI1T/zqvcpIgt1GqowLOaap4YV1irqvhv7QeulD4dGpMyB/rVf9t3MV
IuR4R1U6hySTV931PhpULiXJHEonF/ISW+GC9hZQ+4TDuje4beNyNK16Uqpqa8/F
migSdhdV8aVcmZfj8yGcjXrDGel29Cvy70FAkipP7maHAYcoq7vbakawtfUlqISQ
xY5Kjvk7turXqGmlpDdMSwBDzY8OBoE3NzOkaTveP/giwtuekTWm94QGNQ7i2jdV
PNiPIR0CG7u1lIZUBwGNJ5nOhwKIa5EBYZeNzrh0Qa/xLHH7v/4OVJd/3lt5eCjZ
n9zXoQsy/Qt2zSAJ+fuJL69KFh/s21xuAJvZyPJapnyQ7dcNnqnuP/O1S5VIFL3o
c4uPgoO7dI5xraqEjkYnhVLg/ln+F+VxBgQIW4Dx3bL8QdOTgLgPQlNoL4WdjRLt
myozSNW52juYL5HX7OlU4+p8lWSyoHaoEaCM0D2g5oGljEhuwH+zdUfiY0roEYJ2
XiOQAzKmNxjMjcW6xSSn
=gXXO
-----END PGP SIGNATURE-----

--3XZQkxCYp0f/VEFS--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

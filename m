From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: rdma-core make install is failing
Date: Mon, 10 Jul 2017 08:27:11 +0300
Message-ID: <20170710052711.GK1528@mtr-leonro.local>
References: <CAGxzWdAvjAgeiRsR0UvArC0L+n_PbiuNJfoDvkWzV0Y3hypSeg@mail.gmail.com>
 <CANjDDBj4tSozHvEjqR1=QyydpH2iG7yBHU=FUyGj+oVn7Yvz+w@mail.gmail.com>
 <20170709164203.GA3058@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="pDtNmxPr5KTxcQ6Z"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170709164203.GA3058-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Suman Debnath <suman.14san-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--pDtNmxPr5KTxcQ6Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jul 09, 2017 at 10:42:03AM -0600, Jason Gunthorpe wrote:
> There is nothing special about bnxt_re - it should build in all cases,
> unless your source tree is older than the patch. Are you sure your
> build step is not failing for some reason?
>
> > Adding Jason, Seemingly a bug in the make-install path.
>
> Looks to me like a build problem, install assumes a successfull build,
> if it expects bnxt_re then it should have been built.
>
> The other option is your build output tree got confused when you
> switched between a tree before/after bnxt_re introduction, but even that is
> supposed to work automatically.

Jason,

They are building with build.sh script with -DIN_PLACE=1.

It is documentation issue on the rationale of building _in_place_ and why
installation is not needed for the developers and how RPM/DEB files
of rdma-core are generated.

Thanks

>
> Jason
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--pDtNmxPr5KTxcQ6Z
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlljEC8ACgkQ5GN7iDZy
WKf9IA//XWl+P2wkEoQvifmgEUpiWEIlHjUnqojnrToCEueIaoqnE7ddJ23tzO4k
+S2X6Z5ZxRuUEJzPt+OtZlsa9YZUrEUPB1XYBnqXEWJdTmNVLsfvSUJEovb0ZCW+
Vum3GSWcYsOsm5wqb1botpj/4ypP7AFm2OH8IJ9TLmvM9wUi4gT2xAYVb6kt757V
5budHFZG25APZ/C6IlxdVuyP5d/fB/5nvOrnKoI69EmkZ8wkMkTa+IgbtV24OyJ/
uFRwKvIAvEBeYXtdQN4pKjecDhfU8dihs3cSF7Rrfgqzo1bCx0XT2D94Rt7bBHIu
q24J95ScfKpvE6NETbMgxG3k+VY+/BSxwJqcGdRKwgdg8GIj5YPjBA76OnwCwAca
d43DAH3hLhMHAMadjtlHxjmbPB+5Lm3436Vw/qWXEAtDP937l0b3ugfjCcvw+Pm7
0DDULUorvieWn+g03V1jCUFSSe/yJ4z6X2toZ5zT6VB16g4shoGow2sS5nLIcJW3
OGYYPIR/ldMSmYRe3ZwGsB7Q8/0IZ6d7GrukkTiTIW8z9FSbha1yQQwVJcUxkHkt
5KhedoXr2tcKyCAkUOUnPWs12V5IiusNJ4iBEHhaIvNF5wSO9ezzENYilPa5U8x/
QDXV1txUrx1HOeh59KtrK7YU/MSmwUTc90fHCpKRan1nWsi1u4E=
=Emm9
-----END PGP SIGNATURE-----

--pDtNmxPr5KTxcQ6Z--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

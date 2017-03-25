From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH V2 rdma-core 6/6] Bump version and update debian
Date: Sat, 25 Mar 2017 10:19:56 +0300
Message-ID: <20170325071956.GG20443@mtr-leonro.local>
References: <1490277329-8738-1-git-send-email-yishaih@mellanox.com>
 <1490277329-8738-7-git-send-email-yishaih@mellanox.com>
 <20170323171916.GB5840@obsidianresearch.com>
 <20170323191155.GC20443@mtr-leonro.local>
 <20170323200214.GA10344@obsidianresearch.com>
 <20170324134905.GE20443@mtr-leonro.local>
 <20170324180914.GA13059@obsidianresearch.com>
 <20170325071326.GF20443@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="wtjvnLv0o8UUzur2"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170325071326.GF20443-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--wtjvnLv0o8UUzur2
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 25, 2017 at 10:13:26AM +0300, Leon Romanovsky wrote:
> On Fri, Mar 24, 2017 at 12:09:14PM -0600, Jason Gunthorpe wrote:
> > On Fri, Mar 24, 2017 at 04:49:05PM +0300, Leon Romanovsky wrote:
> > > On Thu, Mar 23, 2017 at 02:02:14PM -0600, Jason Gunthorpe wrote:
> > > > On Thu, Mar 23, 2017 at 09:11:55PM +0200, Leon Romanovsky wrote:
> > > > > > > index 3defc05..f47fcec 100644
> > > > > > > +++ b/debian/changelog
> > > > > > > @@ -1,5 +1,8 @@
> > > > > > > -rdma-core (13-1) unstable; urgency=3Dlow
> > > > > > > +rdma-core (14-1) unstable; urgency=3Dlow
> > > > > > > +
> > > > > > > +  * Bump version.
> > > > > >
> > > > > > I haven't been adding new change log entires in the past, this =
is just
> > > > > > a standin file - Debian will maintain their own in their .diff.=
 Same
> > > > > > with rpm.
> > > > >
> > > > > It was more convenient for me to bump version in this file too,
> > > > > so new symbols in debian/*.symbol will have more clear minimal
> > > > > version (14-1), which is close to rdma-core-14.
> > > >
> > > > I meant, you still have to bump the version, I was just doing it in
> > > > place, because we are not actually keeping a changelog.
> > >
> > > And what about 13-1 in all *.symbols files? It will need to be changed
> > > too.
> >
> > Do you need a changelog entry to have stuff in the symbols file?
>
> I think that we need corresponding version in changelog.
>
> If we change version to be 14-1, so all previous declarations in
> ibverbs-providers.symbols will need to be updated, because version 13-1
> won't exist anymore.
>
> =E2=9E=9C  rdma-core git:(master) cat debian/ibverbs-providers.symbols
> libmlx5.so.1 ibverbs-providers #MINVER#
>  MLX5_1.0@MLX5_1.0 13-1
>  mlx5dv_init_obj@MLX5_1.0 13-1
>  mlx5dv_query_device@MLX5_1.0 13-1
>
> >
> > BTW, there are bad looking things in travis with this PR:
> >
> > parsechangelog/debian: warning:     debian/changelog(l5): found start o=
f entry where expected more change data or trailer
> > LINE: rdma-core (13-1) unstable; urgency=3Dlow
> > parsechangelog/debian: warning:     debian/changelog(l5): found eof
> > where expected more change data or trailer
> >
> >  libmlx5.so.1 ibverbs-providers #MINVER#
> >   MLX5_1.0@MLX5_1.0 13-1
> >   MLX5_1.14@MLX5_1.14 14-1
> > + MLX5_1.1@MLX5_1.1 14-1
> > + mlx5dv_create_cq@MLX5_1.1 14-1
> >
> > Etc..
>
> It is actual error, strange that travis passed while it was supposed to f=
ail.
>
> The commit https://github.com/linux-rdma/rdma-core/pull/103/commits/4ba27=
e66294f59db7c969bde1580e7aa8d718cd7
> added MLX5_1.1, but in commit https://github.com/linux-rdma/rdma-core/pul=
l/103/commits/9614ecdae2a6a5448cab819a057c703a570b3686
> debian was updated with incorrect stanza (MLX5_1.14).

https://github.com/linux-rdma/rdma-core/pull/107

>
> >
> > https://travis-ci.org/linux-rdma/rdma-core/builds/214329236
>
> >
> > Jason



--wtjvnLv0o8UUzur2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAljWGhwACgkQ5GN7iDZy
WKdVEg//fIUHOTPZb2VLTI8r8ewRrRBaVdlEIbm+ozkJwSXB8+n2S3j5cI+dWzpZ
sX4MMdDAIWBuhiHZ6H1taXGVFh+qG8C6ZyzFJoYuY/ThYqmBw8pT9FlHqpduUTCx
Xts+xqC8xHpvSiqhRrlLLndmyD6fj9/J+Fe6OGfHNFKAH3kUFAAVfc/PlYl+Iolq
1kcilc65scs4ZwOhh7H7MKQNBfnWnwvYxPcOWAS8yJAv0qWOpZG4DStsQ8VHXDwT
c8eZQav6EqWX2s7o/m75QdDaJfCIs6eQZdKWkEmZ6s+sNqFE+6ix9myUEdc3w9Ae
DIn1J/1+Jb0++eCNFFmgjb+eKu0FrHfchMs06fqbIDNPob48w/PqLrYUGt4NPzPC
LCzuGddTKO3P4ser/hicdstQfgizEHkU2svoiHGOiiwRdkas28bbTB2h7hotaw51
9hPYH+wkZL+CrMpW2o8h322jbLzALrjTHz9AbPa/st0Y0FoCyPsS8bWGghzHy62q
kEDop3Yn7KwVCOQjhaATHbOih6joyff5DdrDrF7Toa4XcULlBZujWOuQAdr9R2ri
TUG8hp5yIbvSLiyHqlD0cjd8AeKHigXC1nuDbmdB5OcV581P4jJZSDEetn+3It3v
sSkDaM4Vcoe0oJByoC6QLyXvN9hfvHsRbD5t24q+6euBwoJJfUo=
=cQs7
-----END PGP SIGNATURE-----

--wtjvnLv0o8UUzur2--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

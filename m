From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH V2 rdma-core 6/6] Bump version and update debian
Date: Sat, 25 Mar 2017 10:13:26 +0300
Message-ID: <20170325071326.GF20443@mtr-leonro.local>
References: <1490277329-8738-1-git-send-email-yishaih@mellanox.com>
 <1490277329-8738-7-git-send-email-yishaih@mellanox.com>
 <20170323171916.GB5840@obsidianresearch.com>
 <20170323191155.GC20443@mtr-leonro.local>
 <20170323200214.GA10344@obsidianresearch.com>
 <20170324134905.GE20443@mtr-leonro.local>
 <20170324180914.GA13059@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="tVmo9FyGdCe4F4YN"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170324180914.GA13059-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--tVmo9FyGdCe4F4YN
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 24, 2017 at 12:09:14PM -0600, Jason Gunthorpe wrote:
> On Fri, Mar 24, 2017 at 04:49:05PM +0300, Leon Romanovsky wrote:
> > On Thu, Mar 23, 2017 at 02:02:14PM -0600, Jason Gunthorpe wrote:
> > > On Thu, Mar 23, 2017 at 09:11:55PM +0200, Leon Romanovsky wrote:
> > > > > > index 3defc05..f47fcec 100644
> > > > > > +++ b/debian/changelog
> > > > > > @@ -1,5 +1,8 @@
> > > > > > -rdma-core (13-1) unstable; urgency=3Dlow
> > > > > > +rdma-core (14-1) unstable; urgency=3Dlow
> > > > > > +
> > > > > > +  * Bump version.
> > > > >
> > > > > I haven't been adding new change log entires in the past, this is=
 just
> > > > > a standin file - Debian will maintain their own in their .diff. S=
ame
> > > > > with rpm.
> > > >
> > > > It was more convenient for me to bump version in this file too,
> > > > so new symbols in debian/*.symbol will have more clear minimal
> > > > version (14-1), which is close to rdma-core-14.
> > >
> > > I meant, you still have to bump the version, I was just doing it in
> > > place, because we are not actually keeping a changelog.
> >
> > And what about 13-1 in all *.symbols files? It will need to be changed
> > too.
>
> Do you need a changelog entry to have stuff in the symbols file?

I think that we need corresponding version in changelog.

If we change version to be 14-1, so all previous declarations in
ibverbs-providers.symbols will need to be updated, because version 13-1
won't exist anymore.

=E2=9E=9C  rdma-core git:(master) cat debian/ibverbs-providers.symbols
libmlx5.so.1 ibverbs-providers #MINVER#
 MLX5_1.0@MLX5_1.0 13-1
 mlx5dv_init_obj@MLX5_1.0 13-1
 mlx5dv_query_device@MLX5_1.0 13-1

>
> BTW, there are bad looking things in travis with this PR:
>
> parsechangelog/debian: warning:     debian/changelog(l5): found start of =
entry where expected more change data or trailer
> LINE: rdma-core (13-1) unstable; urgency=3Dlow
> parsechangelog/debian: warning:     debian/changelog(l5): found eof
> where expected more change data or trailer
>
>  libmlx5.so.1 ibverbs-providers #MINVER#
>   MLX5_1.0@MLX5_1.0 13-1
>   MLX5_1.14@MLX5_1.14 14-1
> + MLX5_1.1@MLX5_1.1 14-1
> + mlx5dv_create_cq@MLX5_1.1 14-1
>
> Etc..

It is actual error, strange that travis passed while it was supposed to fai=
l.

The commit https://github.com/linux-rdma/rdma-core/pull/103/commits/4ba27e6=
6294f59db7c969bde1580e7aa8d718cd7
added MLX5_1.1, but in commit https://github.com/linux-rdma/rdma-core/pull/=
103/commits/9614ecdae2a6a5448cab819a057c703a570b3686
debian was updated with incorrect stanza (MLX5_1.14).

>
> https://travis-ci.org/linux-rdma/rdma-core/builds/214329236

>
> Jason

--tVmo9FyGdCe4F4YN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAljWGJYACgkQ5GN7iDZy
WKfQYxAAh2JwjeJ5Li+ASj02SCCXtWb37FKMsa1bXO53MIci7syf7Bc2f/wFPrOj
+b7e6bNz1E9S/QnrcRiY6XFVqm/SVyWDhS0WY5iuN55r4pgkqPcbvL6w/SiSWxml
LOpvgR7Wn7uWgURwed5wNnzo3I4vPnCuZdzLMNA/ePhLGUPM1cbRagAcZ75micdb
xahg59yHHL+h6RGpVgbp3jG2G6Gn260GTYXv3Y6DzYJ6QH+QHT2pK+8R60YofMs3
0m4v9qBkBVpkqdv0f3EYXzdapInOTsm5G6AJ2EMStaq/HjHCbpzKYgVvtIB47LWO
cVYaUHjWHkLlTErVHGAxFpNApkuq1XS0T2Vnm7bw6nnDg57qxeCbAL+NhRiKLlyD
YPwp+pFPeftQZHGr9m+wZY1clzTz0fLY4vs+nb1gvtndFRw2ISis1R5KP8PX1JTt
G+caRxPkEmdzdNQMIrtgEzWntclqaj360txEkQ6GU0qgdUbgArS3ZWOQ/6UKZsQc
b2bz1VIpw3VzSsgrBsOWYUdFQ0sF8G0d6OZK9gJRyzWBZLk66MhIJHfOgogwRQVi
m3KvlYXqT6rPdOMDtOjGZRTpTTYpjnHmvzR34TeDiC4uV1tM5uymWjuwCOpJNWuP
5/5zi4pLtKKflWEmJP0dAnPqIcrMFvWPQCy5IeMok5XV+vAxDJ8=
=Dbpr
-----END PGP SIGNATURE-----

--tVmo9FyGdCe4F4YN--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

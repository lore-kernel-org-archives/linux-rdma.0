From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: rdma-core debian/master branch
Date: Thu, 16 Nov 2017 08:47:30 +0200
Message-ID: <20171116064730.GG18825@mtr-leonro.local>
References: <1510658470.4026.27.camel@profitbricks.com>
 <20171114184725.GH18825@mtr-leonro.local>
 <1510686066.4026.43.camel@profitbricks.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="g2oeex4xcrwBLAZl"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1510686066.4026.43.camel-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Linux RDMA Mailing List <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--g2oeex4xcrwBLAZl
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 14, 2017 at 08:01:06PM +0100, Benjamin Drung wrote:
> Am Dienstag, den 14.11.2017, 20:47 +0200 schrieb Leon Romanovsky:
> > On Tue, Nov 14, 2017 at 12:21:10PM +0100, Benjamin Drung wrote:
> > > Hi,
> > >
> > > I have a debian/master branch in my personal rdma-core fork:
> > > https://github.com/bdrung/rdma-core/commits/debian/master
> > > In addition, I tagged the upload with debian/15-1.
> > >
> > > This branch contains the exact content of the uploaded package to
> > > Debian. It would be nice if this branch could be included in the
> > > linux-
> > > rdma/rdma-core repository.
> >
> > Is it possible to align it with stable-v15 branch?
>
> Not really. This branch is more or less aligned with the master branch
> (as long as Debian does not hit the feature freeze), i.e. I will upload
> rdma-core 16 to Debian unstable once it is released (instead of 15.1).

Last question, will this branch be rolling or you will need to create
new branch for "next" unstable?

Thanks

>
> And I will do an 15-2 upload to address the build failures. So there is
> some divergence (at least in debian/changelog).
>
> --
> Benjamin Drung
> System Developer
> Debian & Ubuntu Developer
>
> ProfitBricks GmbH
> Greifswalder Str. 207
> D - 10405 Berlin
>
> Email: benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
> URL: https://www.profitbricks.de
>
> Sitz der Gesellschaft: Berlin
> Registergericht: Amtsgericht Charlottenburg, HRB 125506 B
> Gesch=E4ftsf=FChrer: Achim Weiss, Matthias Steinberg



--g2oeex4xcrwBLAZl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloNNIIACgkQ5GN7iDZy
WKeVtw/+PvYieYmMegWKekDIMovWLx6f1/f0rNpAwsdas/i45FUN2eEZpQzY0mbS
EdEO9hQUamzpCvJ1chQNnsk2wLGEsUrBGKJbZTcE0/A5pbPZ4X7OSiRoE8AjY/88
Sc4qu+nejwOpIE1N5DudH0WUGzWgL7XfQzg3ojiqjCyWaYWBonc8jOKC/RHibfYD
9cElhnRNFbvSeLAUQsxJjkcJh9cnoXHplfk79zpP605eV4O39mbQLOVDveg9zZvH
eHsmyX+8fn3RCshc2aBTJFhJ6zvZsXpSi08BmJDf6w3NgJ+M0zPluDBytcPggWHm
ONb/iDIWP0GF1kXXcdLGCN7YCkCTwGcWiQjR8pU9YzIRq27qoB1REDnno8/gZPB5
1Q9CwgtmnqXNOc52znWmgQa6MMlyZWCdvyW+dZpTeFM/ECKfysIiwxY04tGZhv7l
pi2u7QKmAKbWkMSzM9yserm47Epm8F0QptpqbxLUpZes6Rmm73Wc9sWqYJNL+W1z
DTAhfoSqSvrDeuMowq89ZinxbhmhpsR/0WshVlZZhSfCIkDdrOEWI/Qj5j0DdHSc
jwdtN4pGiJRmcv1KivG3X5reV6CqR/H/Yglfs30psFrCwiI0Lh5JO4yqE6IjqT0N
L7xduB4r38Rl/6iHVbtT0kSv8Twps0HpPVCZ9AGBMGvr9xqg3RY=
=/EIx
-----END PGP SIGNATURE-----

--g2oeex4xcrwBLAZl--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Bug#881731: rdma-core: FTBFS on armhf and mips*: missing providers that need coherent DMA
Date: Wed, 15 Nov 2017 07:44:00 +0200
Message-ID: <20171115054400.GP18825@mtr-leonro.local>
References: <151067381730.19157.7563136692092597267.reportbug@ghostwheel.internal.ucko.debian.net> <20171114190805.GF4263@ziepe.ca> <151067381730.19157.7563136692092597267.reportbug@ghostwheel.internal.ucko.debian.net> <7f295a93-e27e-6661-7e57-743818e12ef5@redhat.com> <151067381730.19157.7563136692092597267.reportbug@ghostwheel.internal.ucko.debian.net>
Reply-To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, 881731-61a8vm9lEZVf4u+23C9RwQ@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="5BSwYavaev5qNTlX"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <7f295a93-e27e-6661-7e57-743818e12ef5-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Don Dutile <ddutile-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 881731-61a8vm9lEZVf4u+23C9RwQ@public.gmane.org
Cc: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--5BSwYavaev5qNTlX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 14, 2017 at 03:41:13PM -0500, Don Dutile wrote:
> On 11/14/2017 02:08 PM, Jason Gunthorpe wrote:
> > > However, it would of course be better to teach udma_barrier.h about
> > > these architectures.
> >
> > The issue is that some architectures just can't do cache coherent DMA
> > on any implementation. eg m68k
> >
> > There is no correct udma_barrier.h at all in those cases.
> >
> > We need to teach debian to follow cmake and exclude the missing
> > installables in these cases..
> >
> > Or do not build at all on these arch's..
> >
> > Jason
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> Jason:
> Why am I being cc'd on this debian bug?
> I also received a notice about a bug fix in debian, and I had zip to do with it.
>
> Is my name tagged in Debian wrt rdma for some reason? by someone? other?

Don,

All of us received this email [1], because maintainer of rdma-core package
is mailing list:

"Package: src:rdma-core; Maintainer for src:rdma-core is Linux RDMA
Mailing List <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>;"

[1] https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=881731

Thanks

>
> -dd
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--5BSwYavaev5qNTlX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloL1CAACgkQ5GN7iDZy
WKdCWw/6Ax3O69sYK68msjwdtxFXe181yRI1VLriAynRKYH+Srxq8G8JvDc8vWfI
Rit2dVofkkC0FJrFRCIjEBPqPOQsJrkyBOMqP5xpAIDZWQBeMRtQTG1YRLHqs8Iq
jqhQn7Qv8i+4bq9DCt+S8HbBljTA6WKmA7jf8U2LhVKvzNSqH+9nOPKD0eoEHHoo
kRZhrek1JCoy9gr4tVH1BuyhPrCsP9HGAAhwt7lxJ8GAC6FbmS0jVYT65meuGpzQ
2bJ8SFRTBdamSa+sG9qPabLH85Ht3Ll1cJJCtIbvlqRMenIutNyoDliV6BkQp+/V
H8yFNWyszFghbCjA4VUcGOsHmz4Un46tIEM7pFAsZ9n6yPrmiNTJilw1bTG5uYeN
RAhYc04xE7fmRQVVxqI0FYqw5CB5H9wuIDFpbHzcmyk+6ImMDOy7VcERJ4si17fB
YOW4YqaTY7Su7y8QkecQWOcmoO3xlHJGQ7ZHfDSuGKW50fWRPFECfcbBzZ+nlF0B
7+4eu5KAN5ty914KiBRomxV6oC+vZIGza4285aWT2QTbiuKVhfYhNo28top9RWYl
gpi0rmSWAMHA2Qw8BRwIkL8Z1BWXRev1lan8zlGcfori17vC9+/6pilpGq9kdbJR
HNEtQBVmPWA8SqhIG97KB/r1FS5IFRNCdHU4d5wAUIUwHf2kSsg=
=pTgU
-----END PGP SIGNATURE-----

--5BSwYavaev5qNTlX--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

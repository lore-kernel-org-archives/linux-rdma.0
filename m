From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] ib_core: Enable and expose force_mr module parameter
Date: Wed, 28 Jun 2017 12:56:40 +0300
Message-ID: <20170628095640.GB1248@mtr-leonro.local>
References: <20170619152351.2866.11046.stgit@klimt.1015granger.net>
 <20170620073236.GO17846@mtr-leonro.local>
 <DE0C511C-A4CB-4D76-8BA7-6BFF81F590B3@oracle.com>
 <20170620180348.GV17846@mtr-leonro.local>
 <C27E2410-44B7-451E-8069-DF1444048158@oracle.com>
 <20170620184046.GW17846@mtr-leonro.local>
 <B34E95B2-A7D9-4725-B7C2-3DA4DACD29B7@oracle.com>
 <16d52534-5564-8137-a8b3-6c66df6bb508@grimberg.me>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="iwX7oKFvAj2SwWc7"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <16d52534-5564-8137-a8b3-6c66df6bb508-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--iwX7oKFvAj2SwWc7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 27, 2017 at 12:24:20PM +0300, Sagi Grimberg wrote:
>
> > > It will be "marked" as UAPI and we won't be able to change it,
> > > which IMHO bad for the debug. It also invites users to set it
> > > and in perfect world, we should test our HCAs with this flag
> > > on and off, because curious user can set it.
> >
> > We have loads of legacy debugging interfaces.
> >
> > And yes, ULP developers should be aware of it and test with
> > both settings.
> >
> > I'm not convinced any of this is a problem for this particular
> > setting. However, I guess the thing for you to do is propose a
> > patch.
>
> Are you guys seriously still on this? Its simply a trivial
> debug flag, whats all the fuss really about?

I hope that we are done.
https://patchwork.kernel.org/patch/9808615/

Thanks

--iwX7oKFvAj2SwWc7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAllTfVgACgkQ5GN7iDZy
WKeoWBAAlFQF1DAMKA0Rg6CEiESwuJ4mGqUE+EzAsJhRdycZk9I798K7Zt6GJ8HN
2C9oTEsIoz0QUSaU4x2e4CvRdKdpIWo8QD6+1YnN9cCyo+ANhaUrgZh9F9PaVBUk
3ikWzBhQne5rF/QgWYKJjbNm/6gVWr50wsL3vlM4s6NpkgkIy646e5+NxFR4qWrR
I08LzxS1kTH8BL80bnszjSsFxHMY1nCcxxnQerECgqPztc7pP7cZ6ytaoekiZB8T
ixC1sI0nxPXIs2IDG3xRjrTH2fGojWgWjUYUqJYWp3m1Tv1KwlzYPyFFVpUuMqge
1F53/c4qNXAHcO7fJli1E72/SaHkHqIblWPVH3vti/qX7hTRResvJE3KKjPuyndq
qBKGTzVUT3cuQwADTcg6e48nTqu1vIhlwE4QWl9cX/5Rt+OaKujIPFAfYQPG4q8+
EFaFyqL1QmNXz1foTF5ToR1lwCota2CaguyFDIbP2DyeIk7Q+io6+ego3ZSX4NJr
IVjg2RZ33HqaMruSZ1SJB90UmGvpelF1F/8jJNX3a35XeHJPGmzHN9RcqFwH35Sf
Ik7ibhuArQE29dZNfPt8AIMMldWYKrajtpfOvNc1f7IlS1pIHziVqJgdBya6Ak5L
SexSQLykqTuvUxrB2esTOSaufMr4GMmbjkzvZKyBHX7jwUDtAJM=
=uMdD
-----END PGP SIGNATURE-----

--iwX7oKFvAj2SwWc7--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

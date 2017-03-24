From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH V2 rdma-core 6/6] Bump version and update debian
Date: Fri, 24 Mar 2017 16:49:05 +0300
Message-ID: <20170324134905.GE20443@mtr-leonro.local>
References: <1490277329-8738-1-git-send-email-yishaih@mellanox.com>
 <1490277329-8738-7-git-send-email-yishaih@mellanox.com>
 <20170323171916.GB5840@obsidianresearch.com>
 <20170323191155.GC20443@mtr-leonro.local>
 <20170323200214.GA10344@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="+KJYzRxRHjYqLGl5"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170323200214.GA10344-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--+KJYzRxRHjYqLGl5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 23, 2017 at 02:02:14PM -0600, Jason Gunthorpe wrote:
> On Thu, Mar 23, 2017 at 09:11:55PM +0200, Leon Romanovsky wrote:
> > > > index 3defc05..f47fcec 100644
> > > > +++ b/debian/changelog
> > > > @@ -1,5 +1,8 @@
> > > > -rdma-core (13-1) unstable; urgency=low
> > > > +rdma-core (14-1) unstable; urgency=low
> > > > +
> > > > +  * Bump version.
> > >
> > > I haven't been adding new change log entires in the past, this is just
> > > a standin file - Debian will maintain their own in their .diff. Same
> > > with rpm.
> >
> > It was more convenient for me to bump version in this file too,
> > so new symbols in debian/*.symbol will have more clear minimal
> > version (14-1), which is close to rdma-core-14.
>
> I meant, you still have to bump the version, I was just doing it in
> place, because we are not actually keeping a changelog.

And what about 13-1 in all *.symbols files? It will need to be changed
too.
>
> Jason

--+KJYzRxRHjYqLGl5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAljVI9AACgkQ5GN7iDZy
WKdtzg/8C/CoZauL9ruM/AsWxhmB88lGZ50h3ul/QTEeP3un+3C+f1OJ6zGj1GQJ
dqEBlCEewVxp0aqAYabZ64k3fppXmVDIbSz21/q/zFT9G57+AcKbc/h63vqnXAdf
0yvxDiDYkVKHV6oZNLsrPSDgVXqlnMyN9Ebi1DPHoMHgSDGa0uvWI4ggRHcwuW0T
/YRTjCh4TPnIdbECtAOMrLJn9cD+FbwGix0e14kwKFBHqfYFQa5I5e2hrS4tyVYJ
z+5RK5wbVATXORZhTX9WBLTQ+3VpeEPcIFtM3/+2crl/mmGu398K/pj5F4O9p7QW
jnyYWAAJFsPHfLrYbYsJgobsvBaLiAJT4Dxz0dKN8mqRItOgZfmZ7oLpGZ9a3i1n
4piMAW8/HCojyfe5ZJI930yi9L6y972N8+eP26/uAlUVMrczFN9EyK2EXSnsxNEH
OCULQrMtz5lV/i4FKG8dp7s7D/D8EszijUHO0+PnAjAiFW7kSldBOOu42qa0zkOp
N50IjrgcFnKHdEi7QaPa6gf8MBtW253NXOh1nHDSxbsqtgAYxYOioPi3zWZNjFdx
EStWB3ZAZz02UQa/NlMyU/UbBY3GDSYCwng+s52fTdvWlAHHAxMz+AsM0QkHSdtP
qhuDkb55EClFXwS4Y/w2+jx5yWTka24b+/OfbT4DPJn9vH2DSzA=
=HrWV
-----END PGP SIGNATURE-----

--+KJYzRxRHjYqLGl5--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

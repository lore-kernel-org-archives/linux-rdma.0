From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 1/2] IB/uverbs: Fix race between uverbs_close
 and remove_one
Date: Wed, 3 Aug 2016 08:18:33 +0300
Message-ID: <20160803051832.GD27667@leon.nu>
References: <1467548899-21923-1-git-send-email-leon@kernel.org>
 <1467548899-21923-2-git-send-email-leon@kernel.org>
 <1470162706.18081.27.camel@redhat.com>
 <CALq1K=LUb+bvx5+3JYLQw+OnhzP5MuqmuydMS8G7eS8Kvyb9Ow@mail.gmail.com>
 <20160802192647.GB20709@obsidianresearch.com>
 <1470192194.18081.49.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mJm6k4Vb/yFcL9ZU"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1470192194.18081.49.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--mJm6k4Vb/yFcL9ZU
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 02, 2016 at 10:43:14PM -0400, Doug Ledford wrote:
> On Tue, 2016-08-02 at 13:26 -0600, Jason Gunthorpe wrote:
> > On Tue, Aug 02, 2016 at 09:50:14PM +0300, Leon Romanovsky wrote:
> > >=20
> > > >=20
> > > > The only reason I hadn't taken this patch before is because Jason
> > > > said
> > > > it was totally untested and someone (Devesh in this case) needed
> > > > to
> > > > test it to make sure it resolved their problem.=A0=A0I don't see a
> > > > test-by
> > > > line here, so has this happened?
> > >=20
> > > I can't say about Devesh, but we verified it as part of our
> > > verification phase.
> > > Do you need anything special except Yishai's SOB?
> >=20
> > I was hoping to see Devesh confirm that the race he was able to
> > reproduce is in fact closed, unless Mellanox did the reproduction?
> >=20
> > At least your testing shows it doesn't make things worse, so it is
> > probably OK to go ahead if Devesh does not respond soon.
> >=20
> > Jason
>=20
> I'm not sure what Devesh is off doing now a days, so I went ahead and
> took this. =A0With the fact that Mellanox tested it, I'd rather have it
> in than out.

Thanks

>=20
> --=20
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>               GPG KeyID: 0E572FDD



--mJm6k4Vb/yFcL9ZU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXoX6oAAoJEORje4g2clinDfsP/3EjNDxhFwKaTHwc2ahulO4G
y/XGnEbwxxq8rrvt4bJx7I4tEjZD5I2LF8GEprY0LWe/qoSaoJ8c7eeGV0F7a8tE
RyMUUbDyLtfl7LxECV97sI/2shCeIPYGhXofzsuNDjayxUhDaXbEOPqDCl2No4Qh
+uDXlk3lE4mv6N2T7XJhSDDdX1RuGQIqmVXbzqld2VYbX0aeWG0uyIy+AJ9tHCxm
S0q+bP0jhjRiX6vgkDKkqWiEEG2TPE+c/GMa6nO7gyyikLxDlGOkQqtJqC7I/QPl
2HRdoUIOfLcAAQN/PY8xoD2uQfmY9ADay7uXle3lt8CmY39CHfY/o36dnOxQqLcF
m7ZXXPbTrX4DrYH2pAivmSbvYraLBD9e/Pvem4FhpLztBVfosxelYjqNLcF1fxDY
G8Blw1pd2GYifpBoxWDlmMWh1RvpBskb9uppm0GdYvAqwEeHkW3YjGrqkMNaeFsl
GwW9O2G8qTn33jDfDZKJaaviGv5EZCS35fF3K5wAjhK1H6HKR1ULHoIx8Av6Za+y
swPA5wql7bNyLaWQx15FBxvLWnj4Ma/6bxRhkRcKjjtBJlYBkCLQH+ZV082sDEZ8
Ogi8QSRDF5nZAPyVPTwzEbr1Pt+ZoSU/CxtT34aTN9XXu9nJtgQCy4SrwVZkYJs4
vSaxZiBGfAoooiahnT3r
=0trK
-----END PGP SIGNATURE-----

--mJm6k4Vb/yFcL9ZU--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

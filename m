From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] iw_cxgb4: set correct FetchBurstMax for QPs
Date: Sun, 18 Dec 2016 13:36:41 -0500
Message-ID: <043916ec-00fb-838f-7e9d-e292704c4892@redhat.com>
References: <20161215210330.81B67E08C3@smtp.ogc.us>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="GXa5OxpXMDwWh7od13cRbpDfQ0BwHsvVe"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161215210330.81B67E08C3-/5N3P9jjx0xzbRFIqnYvSA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--GXa5OxpXMDwWh7od13cRbpDfQ0BwHsvVe
Content-Type: multipart/mixed; boundary="6j8J9DkwJaMnaWms4RGlGal80JWDF0LRg";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <043916ec-00fb-838f-7e9d-e292704c4892-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] iw_cxgb4: set correct FetchBurstMax for QPs
References: <20161215210330.81B67E08C3-/5N3P9jjx0xzbRFIqnYvSA@public.gmane.org>
In-Reply-To: <20161215210330.81B67E08C3-/5N3P9jjx0xzbRFIqnYvSA@public.gmane.org>

--6j8J9DkwJaMnaWms4RGlGal80JWDF0LRg
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/15/2016 11:09 AM, Steve Wise wrote:
> The current QP FetchBurstMax value is 256B, which
> is incorrect since a WR can exceed that value.  The
> result being a partial WR fetched by hardware, and
> a fatal "bad WR" error posted by the SGE.
>=20
> So bump the FetchBurstMax to 512B.
>=20
> Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

Thanks, queued for -rc.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--6j8J9DkwJaMnaWms4RGlGal80JWDF0LRg--

--GXa5OxpXMDwWh7od13cRbpDfQ0BwHsvVe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYVtc5AAoJELgmozMOVy/dD1IQAIzAVVgKMSOyG1HerQ3aPDdB
lc1+seerhKvsF6CX64BHes+EgKCWSqbHqR1TjC8VNEGlQ2dpgAlD8HjLCRjI6ARF
gsJW4jScwMT4og6+KcrbPXGERR3/2xErinyENbSPW9pD0F3KM83hxOjvGvT1LGlG
sOgnmpUhCYIGppQX1t+RwjUiEE/gb4FKeh65z7hoHRkMZEKSxmqdzFSQAjBUW0Fz
44d/fzEblh9loe15t+ODGB8K/uw3sMI7mZb2zqwYF6HY2IuwpBhqVdk8NFx0WSEx
WNl1MTtliVERk++D+HWmdwbjbM+YRg2oFkINW5ywnFOrLrYqEFBBe2tNdlOXZ5WO
abzOQJY7K0mwOieIOBpq0ZeRvMyD85l9u17/U9V3vwgA2h/theQklxXubdPhfELJ
zopuoA8GvQSF6g6CBjoxncuDTQALwe7zcYJ8T3Luc5GoGWIgTot/Gublf7/j/PU3
1Bd/sCmbximgOm+erN6psLAA6V2s8WDeUmXTZn3KQW/tg+5pZ5Dp4WTjADvz+Ulw
+pl7RX1GkMWI7pJWENdfBrl64SboMkEJBPTi/gRrFF8uraK3R4XDMjBOyAar5C+T
49V73lAoNy7FW1XitUNQrPR6zLEPHMO3IIVU1IWeADucr13xe2y9Fcj9ClkA1Q24
4m3Wwq8sBZkTijmgOcDf
=ywwb
-----END PGP SIGNATURE-----

--GXa5OxpXMDwWh7od13cRbpDfQ0BwHsvVe--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

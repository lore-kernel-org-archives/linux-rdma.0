From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH FIX For-3.19 v4 0/7] IB/ipoib: follow fixes for
 multicast handling
Date: Wed, 21 Jan 2015 16:48:43 -0500
Message-ID: <1421876923.3352.125.camel@redhat.com>
References: <cover.1421725318.git.dledford@redhat.com>
	 <54BE7F66.4070404@dev.mellanox.co.il>
	 <CAL1RGDVPCH3h7nZMd9=4rFPqbKEGZiXQC+Atvfwj5kWcf2S3Qg@mail.gmail.com>
	 <CAJ3xEMi5vGc-Urv_7RSWCn9-ZAiq0WzVn3y0__jrTc48jM9gpQ@mail.gmail.com>
	 <CAG4TOxO3wTguFbffxPFANrVTQo7=gVDzEAWwoDhh_acNTixXpQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-9SGyUS1+xhzuATZNDrvQ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAG4TOxO3wTguFbffxPFANrVTQo7=gVDzEAWwoDhh_acNTixXpQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eyal Perry <eyalpe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-9SGyUS1+xhzuATZNDrvQ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2015-01-21 at 12:37 -0800, Roland Dreier wrote:
> On Wed, Jan 21, 2015 at 12:34 PM, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote=
:
> >> Because Doug's changes fixed some bad, easy-to-reproduce issues.  On
> >> the other hand we don't want to introduce new regressions to fix the
> >> old issues.
> >
> > See above, we did introduced regressions.
>=20
> Yes, I know, that's my whole point.
>=20
> We need to fix the current 3.19-rc code, and the two choices are to
> keep the fixes we added during 3.19 or revert back to 3.18.
>=20
> Doug's opinion is that your proposed fix is broken, and we don't have
> an alternate fix.
>=20
> So I suggest we revert the whole series from 3.19 and get this right for =
3.20.
>=20
>  - R.

Give me 24 hours before making a final decision on that please.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--=-9SGyUS1+xhzuATZNDrvQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABAgAGBQJUwB67AAoJELgmozMOVy/dx6UQALIhDb69LMh3Zgf5QAQ93jqX
aGUIk5CvTxnwsOvKV1Qz/i5UGR3Y2V4e15KtEzdp5HRa32JWCUbUxjx0AAKaGpHq
m39i2Cs8ND8kfd1ArVaT4oYrzNCEiF2gwr6WnVsvny3daAjNiYYlW5DlaeeqJ0Gm
/1/tmK3gTEcMVz3YEoRJcDrPa5+U+/bf7RMRYTaUuZ12mhSby5UFIWEITai1LJ3j
kiYxn2KM5VeVHfM/vzQKZtxWm7WJzSiuyKZovrparJkYenGNkUpukyVl8SlxGlos
mFCxpVNm/zircGAdOmzH1SdFiOviFuSrXBROoKsCyy97k5NEHD4wojMOCtFg6gGZ
NZF4xh5zhok4xZYKryaOa/ZaQJMHFB9zObSL0GGTXzq+KUcth47ECW5UFz3w6kF0
wF0SVVdqO5/L+mrNJwulL+65dFfunJa76bFShypr2Lvs0E0mu4sXUA8YP+37qcYp
2nGuIp0lJcL4+TckEciuqd/AFOtCr/hdHDQ02icUEnQFQ7t64NiPeTu04VAG7kvT
3y+8n8HeJzXW1sJb4hVl+bQ1X6NitfqHETU3D/E9PhaVb0g8uMO3KBBkTOQIram+
8U5bspcFU7gMPH6NiOvCVvoWB8nYF7hjX8T0PgBHjmp06QLL+DWdLYQaj/NCNVt0
U3GhCFKjmvbH4nt/uuJ/
=Nroj
-----END PGP SIGNATURE-----

--=-9SGyUS1+xhzuATZNDrvQ--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

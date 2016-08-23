From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] i40iw: Protect req_resource_num update
Date: Tue, 23 Aug 2016 12:45:20 -0400
Message-ID: <2b8bca23-25b7-4c31-2ddf-3194e13f0206@redhat.com>
References: <1471907758-80028-1-git-send-email-shiraz.saleem@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="DPLauMc9ce6pv0rtRcH95tTWtKmF1HDQM"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1471907758-80028-1-git-send-email-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--DPLauMc9ce6pv0rtRcH95tTWtKmF1HDQM
Content-Type: multipart/mixed; boundary="SH8Qk56ptIeb0JD0WnwC49iVOh1RMxM4p"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org,
 Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Message-ID: <2b8bca23-25b7-4c31-2ddf-3194e13f0206-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] i40iw: Protect req_resource_num update
References: <1471907758-80028-1-git-send-email-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
In-Reply-To: <1471907758-80028-1-git-send-email-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

--SH8Qk56ptIeb0JD0WnwC49iVOh1RMxM4p
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 8/22/2016 7:15 PM, Shiraz Saleem wrote:
> From: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>=20
>=20
> In i40iw_alloc_resource(), ensure that the update to
> req_resource_num is protected by the lock.
>=20
> Fixes: 8e06af711bf2 ("i40iw: add main, hdr, status")
>=20
> Reported-by: Stefan Assmann <sassmann-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Applied, thanks.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--SH8Qk56ptIeb0JD0WnwC49iVOh1RMxM4p--

--DPLauMc9ce6pv0rtRcH95tTWtKmF1HDQM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXvH2gAAoJELgmozMOVy/dqw4P/AkBs1AuDuF7ZPki6X7AKXU+
6qBgHVul/d9oDETyBhxcCt6rDTtPEl88cIy6u3oJuSCDQxhN5TzgsKKxT1fBSoz0
+QsstPasoJ4z9H3T0cRz6AnRdL5ll5rjn0//0rK62ikqS+2AFhsqPZCRMd4nEn93
zlfFfGXKhNpRvJLqSpLzLMBUZmKMgC1TqnJcTA1rQLsnmPICKfz5bCj/YOgosMUQ
1T/GESDs8g92U0Ti6hq6EEXCW4UqrkGlp95uevjS/AioqlWjEtiFBjndpyg8+QGj
ThYeCXEPWYH1ud3QNL19gB3O38RawW8POFe9X9TWFCEHtzIxjFcwj5DZhwvJDC1i
hI5FQDpnh9AoM5AmZekS4MOd2EdFbTqc5nzQXYDsNwnSctiOtIsxFNvI+dXW5UFn
93fUsVyvGZQOhXxuS3ankSnXa+rcN5UUZ6y81Gk3ujaOY2R5+ykZ4dzLelyl02IH
7l/NWUvEThd8ZPy5UbX2VKlhd4EGNJ/NZ0JsXLDnMmlyCIKWM8uquzyS/t3nHOO4
1JAuPut7fhQVQnwMqle2TFoHgiI/77M+n9LjgzQMYFWHLccY2FIocgqvd8xBHkoT
kxHfA3wprzO0ys1vy3n/hoUZ+roohWZqAXaMmSkpdTwSP7oaQadQsyVAJZLpX1Uv
nV/iBrxtz38LmEYxF5Hv
=tGIa
-----END PGP SIGNATURE-----

--DPLauMc9ce6pv0rtRcH95tTWtKmF1HDQM--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

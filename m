From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/6] move port mapper code to iwcm
Date: Thu, 3 Mar 2016 10:49:17 -0500
Message-ID: <56D85CFD.2040109@redhat.com>
References: <1456499885-8044-1-git-send-email-faisal.latif@intel.com>
 <CAJ3xEMjdLCNfUY9r7KfH4iMi=CRHjqAQcmpyLxbCQLSCeQxOXQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="IEGd02OdGMT9BkNlIt24Dawjo8eecg05H"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMjdLCNfUY9r7KfH4iMi=CRHjqAQcmpyLxbCQLSCeQxOXQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--IEGd02OdGMT9BkNlIt24Dawjo8eecg05H
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 02/28/2016 04:41 AM, Or Gerlitz wrote:
> On Fri, Feb 26, 2016 at 5:17 PM, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> =
wrote:
>=20
>>  18 files changed, 414 insertions(+), 1019 deletions(-)
>=20
> Didn't look on the patches, but LOC wise, nice cleanup!
>=20
> The i40 iwarp driver is not upstream yet.
>=20
> Hence, it's wrong to add duplicated code there and  then come up with
> a patch that fixes that.
>=20
> You need to rebase the i40w series on this one and not the other way ar=
ound.
>=20

I've already pulled in both series, so I'm fine with it just like it is.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--IEGd02OdGMT9BkNlIt24Dawjo8eecg05H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJW2Fz9AAoJELgmozMOVy/dtw4P/iEdzjMuxRZkkSu4Hoh5Ng0A
Ws3ER2KdSHtXmncetszTq+zZqfnZjQ6pCc5qWQ5+UGF43k4tH7E7SWFIRNM7Afg3
4DZK+DIBTQvnQkT2z0Nk6Bk7eoctrB8HMC9/L4nFQB+djdFuUcQjZutV1bNkNNao
+//fHO1A9tW9viR0kBmzRL2skscasdPIrj2UYW7fC2TIIiA7y+8GHuIDFeoiqbD9
5Sc4pbl/WiNgmVaxUmct75iFpEGaO5VIeUuS2CWgl1QrAHEvy6mTwKfl06wBc2kq
opbC8d75XaHpDC+5zO0xSh7ii06iXak780alcxBLurYQL/UYMBfyQ0GjWZ7AJAZt
gSQTRKj3jU6kJxAFT3RhCoVgyAYorO0fud3YGNVTU/ZDVAtDxGf57d7/izRtW+L7
t2IbKmlB6Cv3ldRuHlUwovCSdJvvGDHWF/BJMdjaXHa73BVg81ztMuqJJt2KDzri
QH/ZhwgV4WfSnWwA5iOEXC3pQpdgRkjIq5/d3vqhyzop1JfU5hfk3vzzKboGhoI+
g80C0WikNKPU4dN0l9H7YdC7+2If3D+IlvgZplCxjmFwO32uMHx6mvhklqA7PxNA
WpUgIbJavZJ3Mt3V3qgdZS02KF6ZicINnlAhKwgDtWn3Mz3B1+KvK2DKNnRFLX3Y
7hdn1FtNVemNeSKqa4EZ
=uJrF
-----END PGP SIGNATURE-----

--IEGd02OdGMT9BkNlIt24Dawjo8eecg05H--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

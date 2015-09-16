From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next V1 00/10] Add RoCE GID cache usage in verbs/cma
Date: Wed, 16 Sep 2015 10:53:14 -0400
Message-ID: <55F9825A.5000408@redhat.com>
References: <1438952463-23707-1-git-send-email-matanb@mellanox.com>
 <55F9651E.5040906@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="HkiNXLKQe4h63Dj4LVviPr5rRkrDtJAi1"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55F9651E.5040906-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-idTK6quXuVSLFuii7jzJGg@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--HkiNXLKQe4h63Dj4LVviPr5rRkrDtJAi1
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 09/16/2015 08:48 AM, Or Gerlitz wrote:
> On 8/7/2015 4:00 PM, Matan Barak wrote:
>> This purpose of this series is to add usage of the GID cache to
>> the CMA and IB stack. Instead of passing Ethernet L2 attributes
>> via QP attributes, we could just use the GID cache that's already
>> points to a ndev and thus to all required L2 attributes.
>=20
> [...]
>=20
> Hi Doug,
>=20
> So 4.3-rc1 is out by now... can we start making progress on this series=

> and the RoCE V2 one?

Yes, here shortly.  Probably after 4.3-rc2.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--HkiNXLKQe4h63Dj4LVviPr5rRkrDtJAi1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJV+YJaAAoJELgmozMOVy/dzuwP/jUhAMx6/fHt4fEdV2BIWvkp
yW71wz0UdObTh+kJ29KNwDvkka6Z/mBnuXMF1G7HapCwAY2vO5nWgNEpSvNB9cWT
Lsb8lUhFrOSBHxmcEkdolTpb/InJRMBEtz0LFcs0zpZIuQcig7S72BsRhNaekSXo
ZLC2U+4oL63Kbjz/TR8iJLfYAlxdSTgRshhAnJz7zZdj4UCD1W2hdXPvlZuNXWTz
JMNgBGQrUYTyLIHRiNtGNAld2Hh4V20RXuIaOsvXqxDEEooOL87q+Ex3uQeslnEO
oMWwadTkIc7ea82qpkeKIAnidRjQCoFbbjTgk1CBi3DoqkuRn3RD3UXAnurN6myL
FZvR0MIS/UcayKqhUvLlqsugzrvLjnjgVRAmlpUMkOoB1njV9C2QYlF/h6qbgiNu
NM4gxIOIM5HF2Pj8hT2NZTGZlbLszDcefmpzdxDFeYBjxH2ogIrXcBro5wihGdHT
51qgNx4d/wcW3BHkrd7YdnfAyZv6f4teP7b0Dv27Z1L/DJvmH6ZNzEc+vmyS42gv
DuAFRaf0Dgz8X8+92HA1W+iUg3uEeYR5FBXxJlkoXjIz8XvOz+W0uEV7xRIIUXxg
CLXYZx2Ha3szrBdT8Xtn3hb2AVmxSrgZXEtPPwzKeoVoOMKfxuEr7paMUqerVhcJ
vK8iOo+GtjPXnF2cDSTK
=freF
-----END PGP SIGNATURE-----

--HkiNXLKQe4h63Dj4LVviPr5rRkrDtJAi1--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

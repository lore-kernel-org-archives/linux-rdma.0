From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/cma: Fix net_dev reference leak with failed requests
Date: Sun, 30 Aug 2015 18:25:19 -0400
Message-ID: <55E382CF.9040506@redhat.com>
References: <1440680115-9164-1-git-send-email-haggaie@mellanox.com>
 <CAJ3xEMhtnzHu23wnpsHex5_xt3MV=z3ERoX6T5d=RoTVdOVrpw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="UaAFDNtk2g82rL5nep2WghBKeVX4ieRKG"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMhtnzHu23wnpsHex5_xt3MV=z3ERoX6T5d=RoTVdOVrpw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--UaAFDNtk2g82rL5nep2WghBKeVX4ieRKG
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 08/30/2015 02:12 AM, Or Gerlitz wrote:
> On Thu, Aug 27, 2015 at 5:55 AM, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wro=
te:
>> When no matching listening ID is found for a given request, the net_de=
v
>> that was used to find the request isn't released.
>>
>> Fixes: 20c36836ecad ("IB/cma: Use found net_dev for passive connection=
s")
>=20
> same here, Doug,

Same as the last email, I have the commit ID now, and I fixed up the
commit message.



--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--UaAFDNtk2g82rL5nep2WghBKeVX4ieRKG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJV44LPAAoJELgmozMOVy/dDV4P/35WzmKXG6ZrCT4JwNKzU81A
3FyCGBp3e6Yy+7cnkYulneb60+G4S0hiVqO1eVIVIMhzXAEqvIjSlCgwvovXmtbY
WKJUhC5mJgJhePUmjpFBE7KisR3sYMLwGC7+sybe6jAnsBZMQX7ms1iUA1ZGYRnp
b+8VoLZsEXUXo5VuSbUEbslGOGxV8U4389NT8WBIlcDqb334Za5wuPTKAvQPXV7n
Mg/4uTwS3iE9h5XVj/biV1VYAgbGjoqZda/HfezXtX/nFfPsIeyOy+RdWZlpbiY8
wEFkVIaLG5GWOcxvcXcCdZnLK2zfzWSdwpRHhPDZmDzD1sm9ZR4qpXyc/u6n9I6O
VW9Lt+6IzZfjxlQENm7sGlet0eiNm0IdAfuuLIxVUrcJ2JrSO0NmT2npk3cVcl32
fs1vHccAgD0b/C/N0y3+/KZhDyXcehO1LYWOmTxaeNhfFAT/bYW2CnUhj/hHFKbB
eU1m1VlT5Y495MkQC7JFt0s4VMWby00nyO/C+BD5sHXrnyZum2fM153eXHjrxamh
lWN+sF9gu4pLVEvBksIE96ciGTbjEB+tgEisEalsazVHGqFdj/zDr0mEwrq/Gi0f
/m2eNhzN+uFY9wpNA3JnMDq7DiBGf5BPkqMM2047UMWSrptB7GYd+2lDKwmmhHkD
HQ/cDrnxW3UvGX14ZDJh
=R/wD
-----END PGP SIGNATURE-----

--UaAFDNtk2g82rL5nep2WghBKeVX4ieRKG--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma 1/3] RDMA/qedr: Prevent memory overrun in verbs' user
 responses
Date: Sat, 22 Jul 2017 13:54:16 -0400
Message-ID: <172676bc-4007-5c24-e44a-9c4ac2a031a7@redhat.com>
References: <1498493106-28604-1-git-send-email-Ram.Amrani@cavium.com>
 <1498493106-28604-2-git-send-email-Ram.Amrani@cavium.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="VmL4wXfB7SOXKxrW17h7W061oU8v4odfm"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1498493106-28604-2-git-send-email-Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--VmL4wXfB7SOXKxrW17h7W061oU8v4odfm
Content-Type: multipart/mixed; boundary="e92HJ08eadpw65XXOsU4PnmbqOw7iVPaj";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
Message-ID: <172676bc-4007-5c24-e44a-9c4ac2a031a7-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma 1/3] RDMA/qedr: Prevent memory overrun in verbs' user
 responses
References: <1498493106-28604-1-git-send-email-Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
 <1498493106-28604-2-git-send-email-Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
In-Reply-To: <1498493106-28604-2-git-send-email-Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>

--e92HJ08eadpw65XXOsU4PnmbqOw7iVPaj
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 6/26/2017 12:05 PM, Ram Amrani wrote:
> Wrap ib_copy_to_udata with a function that ensures that the data
> being copied over to user space isn't longer than the allowed.
>=20
> Fixes: cecbcddf6461 ("qedr: Add support for QP verbs")
> Fixes: a7efd7773e31 ("qedr: Add support for PD,PKEY and CQ verbs")
> Fixes: ac1b36e55a51 ("qedr: Add support for user context verbs")
> Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>

This was accepted into 4.13-rc, thanks.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--e92HJ08eadpw65XXOsU4PnmbqOw7iVPaj--

--VmL4wXfB7SOXKxrW17h7W061oU8v4odfm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJZc5FIAAoJELgmozMOVy/dCCEP/0xaZZmuwEzwVhFaBtTJD+9L
RUeTCMjF4f28N/GnVFQOW6qwD4QXG2TvZF/aplfF7eSwYKdLNJijZ3qoDkQ6BXYr
aG+J1t7A6N+GDnA5klRl28+MbCVRDrLwgOWfU+0oDsA+Tkv3FAhrY+nKxOrVEcUK
aSMOXGh60kXf1jcQW+xQbxznCkNGUm1bmBG9ZWYuizwUbEbsiEz7JjlplUbbRSZo
Mnn1DNaSy1sRo4+Swwz/wNGlUqTMXm75VxtZcse5nHj5x3/7V7WTfZtkgUFXeoSB
gCa2TsSqLfbr9qUJQQiLjoU9NXIRYDJX7+n6KWEfheZl61miplmETSC5X2eogPAf
30cq7Z4Hck53aVUvXY06XyJb8SkgRsV30jFDJvKYw0RG6ONJ4zEnEiVhHxPizVIi
VMYemtR9GHwJ723qpdJF5bYOPsief0PLIROB1gbsZlswsjUY6GOI5ps0JZf1y8p8
JjSureoLHnLFPsa+vzrEidNvj7JXnkPOP3AQ1whtJlJ6ndNSFxfv8AdGaFXft/mh
MIdzvYwrrCDeQO+hJhQHhctHizniJMgt0wua8tpLYUrWlfCPeQW2McQhcP/tD+2x
HMRtADBs0TpxuOBb3jV51ZdWtMowJA0Vy+oAEIeQPP8MLwJTBSHOyDUCPBcs1lRC
1S2lYt1h/3PNLESRp2kW
=gT8S
-----END PGP SIGNATURE-----

--VmL4wXfB7SOXKxrW17h7W061oU8v4odfm--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

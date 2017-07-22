From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] iw_cxgb4: don't use WR keys/addrs for 0 byte reads
Date: Sat, 22 Jul 2017 13:45:48 -0400
Message-ID: <28274f11-5702-3df1-8186-9a7a38c052e1@redhat.com>
References: <1498055143-15035-1-git-send-email-ganeshgr@chelsio.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="J6KRJhBjWGrAHaMfTSCBSiiX7tkOAgEoj"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1498055143-15035-1-git-send-email-ganeshgr-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ganesh Goudar <ganeshgr-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, indranil-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, venkatesh-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--J6KRJhBjWGrAHaMfTSCBSiiX7tkOAgEoj
Content-Type: multipart/mixed; boundary="NsbvIUQWVc78rtqbpHdNMPNJsIDaqbNhK";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Ganesh Goudar <ganeshgr-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, indranil-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org,
 venkatesh-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Message-ID: <28274f11-5702-3df1-8186-9a7a38c052e1-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] iw_cxgb4: don't use WR keys/addrs for 0 byte reads
References: <1498055143-15035-1-git-send-email-ganeshgr-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
In-Reply-To: <1498055143-15035-1-git-send-email-ganeshgr-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

--NsbvIUQWVc78rtqbpHdNMPNJsIDaqbNhK
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 6/21/2017 10:25 AM, Ganesh Goudar wrote:
> Only use the read sge lkey/addr and the remote rkey/addr if the
> length of the read is not zero. Otherwise the read response might
> be treated as the RTR read response and not delivered to the
> application. Or worse Terminator hardware will fail a 0B read
> if the STAG is 0 even if the read length is 0.
>=20
> Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> Signed-off-by: Ganesh Goudar <ganeshgr-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>

This was accepted into 4.13-rc, thanks.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--NsbvIUQWVc78rtqbpHdNMPNJsIDaqbNhK--

--J6KRJhBjWGrAHaMfTSCBSiiX7tkOAgEoj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJZc49NAAoJELgmozMOVy/dnZwQAL3vB56nNASXVVEfjThKGCDx
MxCSRFABzbk6AzAczm2ad1BsBnuEJZf0xkpulukNPJ9U477YgF4Rs1waSEyf6TTX
YPRp1IJk58tCVuNoDN/9Rku17rdTGpEaDjb+JIIVqDghRFKRZDFXRyt5e9OqqytS
uuF78ncliPLwQJGVecQPgKyH4XW5OnKvYHqcMdppVqzWlo0Da/B4RNLgrEljXTmj
/gjpkia5vln5BD8CZPQrRGdd7L7Jex1HfLI5hcZTUi644ubhKbmVFgPU7lCxt4a4
M/cvqv99tdvorMc8LV296aJ9Lbs2BM9wJ9r5NO1OH5ht5IAyhndpIMPlEnXO7vbU
LyKIttzoj0LKfCUuPcthK5zaOknwPoaS9Q/ub5yTjzY2jIw3YF9LMvrZmuDdmX+b
D8O5zt3BaMZeGjN8ncIKsy57tW09i97cjEDSIEiTR6kgRYMTvB+3qpbcK8UiC4Ua
eo7cHR+pRrkwPn9q9/SXMM8Tc6nTz/NZb2wfRJ3f6fsoi3lmnyi6sUxWCqiAY0S+
JQHSLIexC6aH1pqeuNdcOwfH/hGu7IX+BlEym+em1xdg1ov8tslvq4phwpUJTujJ
JWZ0zFiI3L/8y5yFWvJhJnnODJ27lE+eDv1NA93rgNNBIL0fPyhEKXufB5zRawxx
ZBxK6E9+aOwgrK4ZLFj7
=rOag
-----END PGP SIGNATURE-----

--J6KRJhBjWGrAHaMfTSCBSiiX7tkOAgEoj--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: BUG: unable to handle kernel paging request at 0000000000070a78
 IPoIB
Date: Thu, 23 May 2013 13:41:45 -0400
Message-ID: <519E54D9.1050506@redhat.com>
References: <51963BC6.1050901@profitbricks.com> <519B6DD6.4090502@profitbricks.com> <519B909A.8010004@profitbricks.com> <519E37DE.1080504@profitbricks.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2XJJMBFMFPPRURSKVGLSK"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <519E37DE.1080504-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2XJJMBFMFPPRURSKVGLSK
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 05/23/2013 11:38 AM, Jack Wang wrote:
> Tainted: G           O 3.4.23-pserver-hotfix+ #109 System manufacturer
                         ^^^^^^^

I would try a newer kernel.  There are a couple known issues fixed since
this kernel (including a memory corrupter that was involved with
neighbor list handling, and some of your traces look vaguely familiar to
that old failuer).



--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD
	      http://people.redhat.com/dledford



------enig2XJJMBFMFPPRURSKVGLSK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJRnlTZAAoJELgmozMOVy/dNO4QAKqE29WdakCnx0cl/r/dlJlp
qD/KYj+inz1aDpt/iZr/ubNhqee92eh6OCep0XYCXN3pFmX7vn5nOTFXt8vyc+IQ
2xiQ+CpkwFDJvx6lHvqMK54xHljHk9EUnAdApdAwu11yKlOIYd7vR9QvfngcVafJ
GlsEMUy9488z1rcuH3FuIlNcy3NsS3QHWsmdhi/GKgbaytCTOxOG8gSQTGlj+EEY
mAvWCkbufVGWbTT33gnG495se0En1aUMz9BM2/gM6oJh4g2jB85kyi5xtFn9N1h9
usdfIqnwjKPcS2isT+/524aR4rDMsAAtbRrjfAQkbmBsNtbGq2sCaqCofNVR00p2
H1El4rIauMTbczIZ0UvYeC3Sf3xrrY+AK+AO90zyD97j/PDiLdNH30qoxNrydXob
wP7qtMz0O0xYsQlRBNJxq04cMd3Uv/UDTOcifrcSNq/MHM6+iKmznde+2L18PQpm
7Nz1p4AR3qwJhhKjCWUN2fPTTncv7+z1/vzKNF5qNU34whq7v6SyUHE+FKtXJP+q
SFIg3/kVuUP9CjydGcD+9wg/RKKVoJ8UIiLQq2OQmkiHvnWeRwDKtIe6NUrS7E7P
o77DKVbEWFCoUbZSU3VWnzkJ5c2uPpiiAX6s+50eu05Li6Chd4HRUlYhWEzFdJ0/
+Uw898f4PcFcRE8gZ/Ax
=mVkr
-----END PGP SIGNATURE-----

------enig2XJJMBFMFPPRURSKVGLSK--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

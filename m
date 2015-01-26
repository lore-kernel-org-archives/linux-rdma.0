From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH FIX For-3.19 v5 00/10] Fix ipoib regressions
Date: Mon, 26 Jan 2015 07:51:52 -0500
Message-ID: <1422276712.2854.5.camel@redhat.com>
References: <cover.1421936879.git.dledford@redhat.com>
		 <1422031938.3352.286.camel@redhat.com>
		 <54C4E793.2010103@dev.mellanox.co.il>
	 <1422224477.3352.373.camel@redhat.com>
	 <54C616A8.3050804@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-uDyFVKo2BClLADj5Xgk7"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54C616A8.3050804-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eyal Perry <eyalpe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-uDyFVKo2BClLADj5Xgk7
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2015-01-26 at 12:27 +0200, Erez Shitrit wrote:

> New (and full) dmesg attached, (after modprobe ib_ipoib, with all debug=
=20
> flags set) it is all there.

Thank you, I know what's going on here now.  Will correct shortly.

> >> The main cause is the concept that was broken for the send-only join,
> >> when you treat the sendonly like a regular mcg and add it to the mc li=
st
> >> and to the mc_task etc.
> > I'm looking at 3.18 right now, and 3.18 adds sendonly groups to the mcg
> > just like my current code does.  The only difference, and I do mean
> > *only*, is that it calls sendonly_join directly instead of via the
> > mcast_task.
>=20
> Yes, and i already wrote that it is more than just "only", it changed=20
> the concept of the sendonly mc packet.

Be more specific please.  What do you mean by "concept"?  And just so we
are clear, this all started because the existing multicast code was
super easy to break and was racy, so if the "concept" you are referring
to is what made the original code easy to break and racy, I'm not going
to care one whit that I changed that concept.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--=-uDyFVKo2BClLADj5Xgk7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABAgAGBQJUxjhoAAoJELgmozMOVy/deqsP/2V/uuHrxTzN7MKJcYNfdl6e
y/6+6aSS+virKkwCsEwnWyxKcuSnLnhRq58s5nHtNNV8bMO9+T9O7Uj1XQDNUbzL
AExv5/kb/QpTInmJvkLvpdItzppJ98uAHUDYTIw3cLiMZptAEbBYdm5FnVpSzyjT
s1mi6mFMth5oSBPRtVMk/eZKSqDDupz+x1I83eblh5nlPgmJoI0/CDMFlKxVFYvm
Kn5/+4thgLfljvo6zT6mjFX51aopssMrbeR2cfVEO1lgvOGONeRR7iLer+bQJVKh
SN+J/D6vYgalrogyVNnw5crVRHFw4jPf0o9AP62Cd72Al62GCLVmGfj3Jm15Clib
6KVDSbS3D5Lop/E2NLY6RnhmD3IgtTmhZetz+9xJbmmVlroUUBgQHtRGaMuP2+yX
xBBVLTuksLXAeCiNJgqBr4flnjMvrFVqc+vGoRTiLrQEyEcEkxrC8h8zK2ofQKjD
IcTvXKUHqaBTYUGWzRXle7mdYrv3ieao1QR3ffuiI+MIEGI3Fadi0topvlrykbpA
aHpaWx6wk1KaB4bIC9LSusyswCZP3lVyY3xlLAAyMEyDuXwlIsDuJ23FT+mWfjdQ
MyjwLyNCyVoFYIo1On26WEXjYjTbZa/SMufd/CL3bCk92J1mBzoO7CkChDcO9zEm
z87qVSQTr16Pe6ekNcIx
=+Dzd
-----END PGP SIGNATURE-----

--=-uDyFVKo2BClLADj5Xgk7--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Subject: linux-next: manual merge of the bkl-llseek tree with the infiniband
 tree
Date: Wed, 13 Oct 2010 14:32:29 +1100
Message-ID: <20101013143229.fc579ee4.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__13_Oct_2010_14_32_29_+1100_EB_bHW5lctvxejg+"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

--Signature=_Wed__13_Oct_2010_14_32_29_+1100_EB_bHW5lctvxejg+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Arnd,

Today's linux-next merge of the bkl-llseek tree got a conflict in
drivers/infiniband/hw/cxgb4/device.c between commit
8bbac892fb75d20fa274ca026e24faf00afbf9dd ("RDMA/cxgb4: Add default_llseek
to debugfs files") from the infiniband tree and commit
9711569d06e7df5f02a943fc4138fb152526e719 ("llseek: automatically
add .llseek fop") from the bkl-llseek tree.

Not really a conflict.  The infiniband tree patch is a superset of the
part of the bkl-llseek commit that affects this file.
--=20
Cheers,
Stephen Rothwell                    sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__13_Oct_2010_14_32_29_+1100_EB_bHW5lctvxejg+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMtShNAAoJEDMEi1NhKgbs3owH/jJReSEeLFwAYGRwqa9WEr5d
v49RgXTm5rCA9NtDQwApxTQ0N3BXYoPhdUalAQ0A4FNn24DCpOuJ0NIQhIIfS0Kn
n5HO0bo7itLEh01rY6s6XHTrk/mzcbHiP5GRvBU/Z164KE/HuWWBDLOvR3i/VvmA
CaDeyGd7S+eiP4pvUg0iqm9OgXNI/Umvvemp4BQ3Ee86MwPJY4gt9f9ReosRJhvG
x0rpdyMtU+I45HV4Dl4+kx+yUBV/oOqboV6Y718uWOKSZtmY2tM5HGT0qXFjDXh8
56/qUy2SwK8Bw1f8SAOIVoncdkrUWhohArjfcPSx00AeQS2j1Ix3RRgxNHICcmk=
=3JCm
-----END PGP SIGNATURE-----

--Signature=_Wed__13_Oct_2010_14_32_29_+1100_EB_bHW5lctvxejg+--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

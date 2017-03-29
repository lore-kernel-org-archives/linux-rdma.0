From: Vangelis Tasoulas <vangelis-S8y2klWGCOFhl2p70BpVqQ@public.gmane.org>
Subject: Extend LID space in InfiniBand beyond 48k? Is this really possible?
Date: Wed, 29 Mar 2017 18:07:47 +0200
Message-ID: <b9531f99-c350-3985-edae-296b1bc97509@simula.no>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="kjukd2sbHuFVuBRbprsVNRU1l8wbMTqc9"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux RDMA Mailing List <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--kjukd2sbHuFVuBRbprsVNRU1l8wbMTqc9
Content-Type: multipart/mixed; boundary="bUBjG14FfaQUX7Tec1IvJsbM1NwUtW0L0";
 protected-headers="v1"
From: Vangelis Tasoulas <vangelis-S8y2klWGCOFhl2p70BpVqQ@public.gmane.org>
To: Linux RDMA Mailing List <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <b9531f99-c350-3985-edae-296b1bc97509-S8y2klWGCOFhl2p70BpVqQ@public.gmane.org>
Subject: Extend LID space in InfiniBand beyond 48k? Is this really possible?

--bUBjG14FfaQUX7Tec1IvJsbM1NwUtW0L0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hello,

I was reading a year+ old article where Steve Scott (CRAY CTO) was
interviewed here:
https://www.nextplatform.com/2016/01/08/cray-cto-connects-the-dots-on-fut=
ure-interconnects/

At a certain point Steve mentions (or at least that's what the article
claims):

/InfiniBand has another limit in terms of the number of logical IDs, or
LIDs, it can support, which is around 48,000 end points, and for the
most point, people have stayed within that limit. There is an extended
version that has some higher packet overhead that can go to higher
scalability./

Is this true? Is there any reference that one can point me to for the
part of the "extended version that has some higher packet overhead that
can go to higher scalability"?

To the best of my knowledge, there is no extended version defined in the
InfiniBand specification. What is mentioned is that /The unicast LID
range is a flat identifier space defined as 0x0001 to 0xBFFF./

Vangelis


--bUBjG14FfaQUX7Tec1IvJsbM1NwUtW0L0--

--kjukd2sbHuFVuBRbprsVNRU1l8wbMTqc9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJY29vWAAoJEBVCOlepmNphF0sIAK+9diZeDOWGJS7TLWMxhSc/
TdjQ9paA6LYAm1qvBKynk0xXyeoULFba36fgctPwFa0rB5Fp3+O7iNlUsigTHI6z
VyAC8jq6FkkXCKdqgZ7OkFGBzhHUQF9IR1JpcDAsWWZ2F9FNFqkBIiou39fKlYfU
i/slAmhkRWiYXCXqj8f4UmwUCYWYSyDMlpVAUx6Kvr8hdwVzNhlTsiemlTXOElSv
bC12SM9EW+c0ny0dBCnyg4jnAQWwQ+d3xWWKvHKM95B1TQiQ8Qe++3XwZpvduXml
nsE87d3iL2MpHo92KBqdBZkWj+AKnIaCXFd/dChlFRG4jQsyWN9U7AQuxTouRDo=
=BJrh
-----END PGP SIGNATURE-----

--kjukd2sbHuFVuBRbprsVNRU1l8wbMTqc9--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

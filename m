From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V3 1/5] RDMA/core: Transport-independent access flags
Date: Fri, 10 Jul 2015 18:30:17 -0400
Message-ID: <55A04779.6080201@redhat.com>
References: <20150707161751.GA623@obsidianresearch.com> <559BFE03.4020709@dev.mellanox.co.il> <20150707213628.GA5661@obsidianresearch.com> <559CD174.4040901@dev.mellanox.co.il> <20150708190842.GB11740@obsidianresearch.com> <20150708203205.GA21847@infradead.org> <20150709000337.GE16812@obsidianresearch.com> <559EF332.7060103@redhat.com> <20150709225306.GA30741@obsidianresearch.com> <559FC710.1050307@talpey.com> <20150710161108.GA19042@obsidianresearch.com> <55A00754.4010009@redhat.com> <55A01225.9000000@talpey.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="efGwjwxgr24V1itLNu41345x8vNxn2UAG"
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55A01225.9000000-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: 'Christoph Hellwig' <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--efGwjwxgr24V1itLNu41345x8vNxn2UAG
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 07/10/2015 02:42 PM, Tom Talpey wrote:
> However, it's an extremely bad idea to codify writable privileged rmr's=

> in the API as best practice. So under no circumstance should that becom=
e
> the long term plan.

Agree 100%.  Which is why I requested a big warning in the dmesg output
that pointed a big, accusatory finger at the offending module with the
long term goal of reforming the memory registration models to a method
that eliminates this problem in the kernel.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--efGwjwxgr24V1itLNu41345x8vNxn2UAG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJVoEd5AAoJELgmozMOVy/dF3cQAJU6aH5cHEKhFA6iwUlcZhZ8
+Wer68w1fuYslUQSeGZ+9UQ3ewWy+T5rkT51QibryiZSXuqWcNrQJ2GErNowwb/F
kK3WjKwI+26mSA3lOU7xHOTB8ZJEvzmA6bemOiKz7D3/rrYRvwEf54qaQqifyY7A
1uLleycCFSzumiFPku1qfwQtvyXLEkpvBLDmn022lvRo24+QSVpXFWnumHgf684R
1vpXeq1blTKakMwiHu18nmiMtuulhK6EH+8AD9lsNuhn+qMmgXhNPQwD7pZAE/10
5kL+Kg2ohw6CqWK9+XVzSXVLRJ02AFTrNa+M2XWACaSW/kZHZO2UW+3zCMWICEcL
e5PbUAhCszLFw6eMzQgTkYsguVL/g0gym9gd2UHMhOmRFvR09s8suilieqP5sryx
RbL1iV7UWJ6tjh4oXYK7/7gC6CAPKuoeh4Rix2tAWU6AEDaD3RvDZZ8ctcMl6WZY
RGFTN8tNyVofMaP2CbtH4ymo1tkLszJywZ5Xaup5iW4FtT01XUzgd0Ml4jFlA0o6
aQoMob2T7q+iD1rNJinFviKH0imosM5RULdTVK24NcggeHZxi+1d+Hf6uozjqhrY
5n/6f/O05YrHtAx63tHSJIzy0t+l2Kk7Ru2VBCv34ARzZpgmlwgHjOPC2tGUwpb2
crSvEE5lpZUd31n1smXp
=Yp3g
-----END PGP SIGNATURE-----

--efGwjwxgr24V1itLNu41345x8vNxn2UAG--
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

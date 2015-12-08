From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 0/2] Handle mlx4 max_sge_rd correctly
Date: Tue, 8 Dec 2015 12:58:09 -0500
Message-ID: <56671A31.7090401@redhat.com>
References: <1446031696-19022-1-git-send-email-sagig@mellanox.com>
 <5641C8BC.40507@dev.mellanox.co.il> <20151203142730.GA20520@infradead.org>
 <56605AB7.3000705@dev.mellanox.co.il> <20151208170139.GA425@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="AqV73AoGjU9AoGBKkpGDgEsWP4PS8xRoQ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151208170139.GA425-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--AqV73AoGjU9AoGBKkpGDgEsWP4PS8xRoQ
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/08/2015 12:01 PM, Christoph Hellwig wrote:
> On Thu, Dec 03, 2015 at 05:07:35PM +0200, Sagi Grimberg wrote:
>>
>>> Did we ever make progress on this?
>>
>> Just up to Doug to pull it in.
>=20
> Doug, any chance to get this into the 4.4 queue?  It's annoying
> having to work around this driver bug in every new ULP.

I've pulled these in.  Both of them failed to apply, and the first one
was just flat baffling in terms of how Sagi is working from a source
base so different than the one in the upstream kernel.  They should be
double checked just to make sure I'm not missing something since they
were so far off from applying to an upstream kernel.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--AqV73AoGjU9AoGBKkpGDgEsWP4PS8xRoQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWZxoxAAoJELgmozMOVy/doYsQALI7dq/XaupgohR8wqSrPE0u
jEAmdU82SyLXFG1PmKYZV3dHyPPQbqLyMG6vjrN8882dBZooV0vo0JOthDmetC2C
eYvBdQHxRwthm4mXMGxLAl5chJPMG7fvfTS5vBLUUZlz4gd0r3wa4/OpssYLQaF7
LaduX6BPDQXiCrH0vPz8AG2K8hr40E7Vi1yrAysui1P/JtPpCVxr37l2ElpipICd
XBvBS/SZcvJdv0pzwUGovNBdIx00JoKWIn2pfHKVt8VLP9fvYLSMjd+xvYbyGMDT
vkbcaXyhFscUzhKCjhs9gU2gZ3tMgYMshj2QcTQRQufQU7vjinkGWkUkEfIN+Wq8
3+njWPHnYoffttITGluMyRPz+5QgTCvp5SxtK2wpXOqlvv1dzP6tsQUl3FNrzhOT
KRWOMLyd34Xeta2jvkIaY8J1nx60xlIjRPbBzsx5QC353FVJN+Z3cQkqC+KRB87R
KhIGvuHy2WbIEX0m89C7f3m1YF9Pq2/0WB9eZyATiU5HYXnnp72fkNKyJG4TM42K
Sq0aqpHslRLGpumcHbe0Bw2M8I7ftqOlPtWeLlqAv58MdyZt7wYq8tgm3OFTwRqw
V89qvpz5SkPXB7d5TAGpxYYzgkNrfVyrNQEB96JX9fdiK8kRoCiRoBmxUS7x/G3N
mztVCcOksgU16gS9tanj
=hrcj
-----END PGP SIGNATURE-----

--AqV73AoGjU9AoGBKkpGDgEsWP4PS8xRoQ--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

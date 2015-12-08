From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: device attr cleanup (was: Handle mlx4 max_sge_rd correctly)
Date: Tue, 8 Dec 2015 17:04:19 -0500
Message-ID: <566753E3.9060301@redhat.com>
References: <CAJ3xEMj2EOxX1CiA93MPOsM-FdU9ijcWCYm9tObbkLqqja0PoA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="HsD2rhd6vnxHaN60HcSSTPkGlmGN1mvsw"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMj2EOxX1CiA93MPOsM-FdU9ijcWCYm9tObbkLqqja0PoA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--HsD2rhd6vnxHaN60HcSSTPkGlmGN1mvsw
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 12/08/2015 04:00 PM, Or Gerlitz wrote:
> On Tue, Dec 8, 2015 at 8:17 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrot=
e:
>>
>> On 12/08/2015 01:13 PM, Sagi Grimberg wrote:
>=20
>=20
>>
>>> I mentioned this in v1. This patch set is applied over Christoph's
>>> device attributes patch. Will it go in as well?
>>
>> No, that's too big and not the right sort of fix for 4.4-rc.  I had it=

>> on my radar for getting into for-next.
>=20
>=20
>=20
> Doug, re the device attribute patch, I have expressed my opinion that
> --- we should be going in a slightly different direction of stashing a
> struct ib_device_attr as a direct or pointer field of struct ib_device
> and have the device or the core to fill it up just before the device
> instance creation with the core is to be complete. This way we can
> remove all the annoying calls from ULPs to query device and avoid
> adding so many fields to the device structure itself.
>=20
> So there are two suggestions on the table here and we need to hear the
> maintainer thinking. I do expect that your response will not be "I
> applied X" but rather you'll allow the time to try and convince you on
> whatever direction, this is pending for long time and we're on
> 4.4-rc4, there should be no rush to cut this over night and push to
> k.o the code for this small cleanup.
>=20
> I didn't submit a patch that follows my suggestion, but Ira did so in
> one of the OPA submission rounds, if you're OK with that proposal or
> if you even just want to see the patch to cast your vote/decision, I
> will rebase it and complete.
>=20
> Makes sense?

Makes sense.  Show me what you are talking about (either a link to Ira's
patch you are referring to or your own patch).


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--HsD2rhd6vnxHaN60HcSSTPkGlmGN1mvsw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWZ1PjAAoJELgmozMOVy/dtZ0QALjc7oAgeDL3pE5Cu0Q6aCOd
RNpPZ/AgkjAuBPqjJdxGg60Ij2spcrr3/QSQqWycNINWA1KB2wqTTpJT3Ht2Sgyg
crXSQpgbrugvue+W9JTICtv6/agSaXrl8EyRVhzlRq87Tcfo47BGcf7kpd3FD0L1
hydu8Wuy8yAuvQH6QRe2UZoG1VJxCxw9k+CDjHN87rtDXXxBxpC7rdTBHQQbarnt
Pp9g6vE0JX9HoEqFyHYVp4x214+j3u4BEJ+DmmsZ8BwbJ+NjtF8M1Q607Z2SFlhb
0X9BllaVBHDt8GqhTlOZ3SskDpedJoFmdQUiigu20gU+1Nmjf0pGFneYr+fGc36G
g8f/CSupOnLuouZvbMGgI0iNXv9s75i/RbxUxk038dZGe+Jyo+3SfT/jB61rdRMC
3VbFf/5jHptX67ipPLHQ4KlRM8ocmyM9NqhPthocgOT61lpHjWMqp5Z/jSmQ6lQ1
OTAn9OeuiK74k4LsAGsjKIA5u66+8ELHbNDqGDNPoOErZhs50EzHitKZlXIM9VFc
ygrRucm88Xg2TGxhF8UycDuHm0GjlyGmUVvXUN6CxAji9u2AqKAzKygb80P/u/lS
VFghhUnpORgKccnxcjjHc7zC3WXgPtnTvqSnjr6TCpyqBz91uPo6cg4u9qqy7gWq
X7OiAN6pd1MGBQBaQdJD
=77Wq
-----END PGP SIGNATURE-----

--HsD2rhd6vnxHaN60HcSSTPkGlmGN1mvsw--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

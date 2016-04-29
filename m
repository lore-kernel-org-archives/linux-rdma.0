From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 3/4] IB/core: Support new type of join-state for
 multicast
Date: Thu, 28 Apr 2016 22:34:33 -0400
Message-ID: <5722C839.2070704@redhat.com>
References: <1461070287-13469-1-git-send-email-erezsh@mellanox.com>
 <1461070287-13469-4-git-send-email-erezsh@mellanox.com>
 <alpine.DEB.2.20.1604261514590.2663@east.gentwo.org>
 <1828884A29C6694DAF28B7E6B8A82373AB045BD0@ORSMSX109.amr.corp.intel.com>
 <20160427064239.GO7974@leon.nu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="mX1cUcecSsrcWkwcaBBQDXFm4KD9n8Fas"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160427064239.GO7974-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--mX1cUcecSsrcWkwcaBBQDXFm4KD9n8Fas
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 04/27/2016 02:42 AM, Leon Romanovsky wrote:
> On Tue, Apr 26, 2016 at 08:57:08PM +0000, Hefty, Sean wrote:
>>>> +* There are 4 types of join states:
>>>> +* FullMember, NonMember, SendOnlyNonMember, SendOnlyFullMember.
>>>> +*/
>>>> +enum {
>>>> +	FULLMEMBER_JOIN,
>>>> +	NONMEMBER_JOIN,
>>>> +	SENDONLY_NONMEBER_JOIN,
>>>> +	SENDONLY_FULLMEMBER_JOIN,
>>>> +	NUM_JOIN_MEMBERSHIP_TYPES =3D 4
>>
>> These seem better suited as flags -- fullmember (y/n), sendonly (y/n) =

>=20
> Thanks, excellent point.

This doesn't seem to make any sense to me.  Without going back and
re-reading this part of the spec, as I recall, there is:

UnJoined
SendOnly Join
Full Join

You can never have a SendOnly_FullMember join.  Once you are FullMember,
you are no longer SendOnly.

Is a NonMember (assuming here that NonMember is referring to what the CA
is listed as according to the SM) even allowed to join, either as
SendOnly or FullMember?  I would have thought if the SM listed that CA
as a NonMember, that any joins would be flat rejected and NonMember join
states wouldn't make any sense.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--mX1cUcecSsrcWkwcaBBQDXFm4KD9n8Fas
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXIsg5AAoJELgmozMOVy/d/p4QAIvLP0n/gmNpH2EojKLL5nvH
1n9wjViIrapx3vz59EM0qICrmY7vd8l9kzPGIVh4MHXmVX9b6g9QbHWYiV1D6RK5
5MBZIXvWnQpduYkhDcgrm1n1Kju3DKYi55CiDyZbd9zx1tgLpjDFT7YLM9cTqSzs
KGauTXYlY6/4gI5tMAHryX5RdivQZgD5dL3k3Hf6NtsDmkGkPjPZixqWZDKXwx25
IJY2JhWPaS7iw/2gLAtUHB42wuDFmBWR/gP5dKQVmxuQ2VXiZUhtAtTdXSkeH66W
FDra4ZNZxkAPV85cBL1CENog1mt3wC1Yrdfv2hONaVOB1A3LoEN/kVVENGgoEA4j
lAz8PStPrsMMMl407GiK6aPkWdd4/TWdf7Jxwx2nl8vP0nmNjnSsq5fjLq67j82M
0yf4tGeHTPYE7SobjRgLebzrtemI+uStn6kmPu2aw9bqWVQcw2ErhTWQIlqulH5V
w4Te9yFns/F2ytvJ4v1SzOGNf1bqu8PbUuoteh7dXPQHZnXCr1pMHL88PYyu+g6y
7I3H8O400CZS2cKYcZUOl/CeRib7kCQbvlkRsKj76yOXK3eQss0VCe5de+1LcaWY
zG7R6dv/kdogEr+5mh8xB52zxIydOwt4+1XHOpgcmGiZCb1x6lOcHhYBfGBl2CCG
mx2Ac6sPKJPa6FOQUQ9T
=etyU
-----END PGP SIGNATURE-----

--mX1cUcecSsrcWkwcaBBQDXFm4KD9n8Fas--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

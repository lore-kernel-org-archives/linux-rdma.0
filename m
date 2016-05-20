From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Fwd: Re: [PATCH] IB/core: Make device counter infrastructure
 dynamic
Date: Thu, 19 May 2016 23:17:20 -0400
Message-ID: <5bbdc92e-364f-37ad-d7e8-2e32bd64fd88@redhat.com>
References: <fb1272e0-8c87-e51a-2220-5fdde598311f@redhat.com>
 <490a5365-ce89-f4a5-3547-32c37757da1d@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="abwn5x4mOuq4NSbOREJfgWWwCl0T2jd1T"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <490a5365-ce89-f4a5-3547-32c37757da1d-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--abwn5x4mOuq4NSbOREJfgWWwCl0T2jd1T
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 05/19/2016 11:15 PM, Doug Ledford wrote:
> On 05/19/2016 05:50 PM, Jason Gunthorpe wrote:
>> On Thu, May 19, 2016 at 05:35:13PM -0400, Doug Ledford wrote:
>>> +	[NR_COUNTERS] =3D NULL
>>
>> Don't really need this, just use ARRAY_SIZE(names) in place of
>> NR_COUTNERS
>=20
> The original code required a NULL terminated array.  Given that the att=
r
> array requires a NULL terminated array, and these are used to set that
> up, I'm not sure I mind burning an extra NULL for the semantic match,
> even though it's no longer necessary.

As a second issue, this is what allowed us to remove half of the
BUILD_BUG_ON statements.  So, removing it means putting those back in.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--abwn5x4mOuq4NSbOREJfgWWwCl0T2jd1T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXPoHAAAoJELgmozMOVy/d5Z8P/2c7evModIN5iOJkn/3CPiVl
lwsGpkB5irZV/h1idcfzrNQHHBCoSwFdci05Lmsre5jZ48CoVSZxjrzmtpIsvvvj
w2rIVhQoFD5+DUBZ/IHCBN4cMYvAEuLNZA3VD5C796Dy4VPnBn70/ezMgIdKfpzo
tOKh2Xi1fw5/qqa8R130f7oZsGJdFgg+l289bWNo3nWCZTxHxf8BWqVQHVn1qnDS
7oIUpbk6awABrszGjN1BQ+imsmGhfU/KGmLmkDMy7bevdwy77xAY2b2Gd/mcMvfn
3ncwrcmJ01Yjz5Sg5irsAsejatS1R+yPxgz2JbkQquZ66MFIMbPbhINdOxQmgR70
80NXGPcI9FSEHqNUxFd4UbKRtrR+8Z6bJjqsujytAgRsM1yS/TM/cQu0pZx0hhzn
1ZkLRHA5OZNqFHHASd4TRAW1WJPTS89GeDAYNZzhQbhlqJseOzdOvl2qLDl1euCj
9NIUQNEddmaUPYM5me4GAW7pDZt7YWZL/FzvxILdHCG/WaWj4I54qv+PcKYdEZ0p
fM6bKS4f9CpNEjfo11xSnN6BpX0irzlQz+XJGHIvbBz47W7Xb7iL6qN3tR+sir7E
bT3ZBU8ni09wzZmvCstmSecwvc9CzuCaQ3rpa9+iDVRHq1S8dGV3RD/zAAzlGfxE
zyVVWO4Yl3hCpCDFy6/n
=hcag
-----END PGP SIGNATURE-----

--abwn5x4mOuq4NSbOREJfgWWwCl0T2jd1T--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

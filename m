From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/cma: Fix net_dev reference leak with failed requests
Date: Mon, 31 Aug 2015 20:23:23 -0400
Message-ID: <55E4EFFB.6060001@redhat.com>
References: <1440680115-9164-1-git-send-email-haggaie@mellanox.com>
 <CAJ3xEMhtnzHu23wnpsHex5_xt3MV=z3ERoX6T5d=RoTVdOVrpw@mail.gmail.com>
 <55E382CF.9040506@redhat.com>
 <2807E5FD2F6FDA4886F6618EAC48510E1CB7D78D@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="IwTWHbcoeBoLnjPtoRjsUktDatPSaTRxd"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2807E5FD2F6FDA4886F6618EAC48510E1CB7D78D-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--IwTWHbcoeBoLnjPtoRjsUktDatPSaTRxd
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 08/31/2015 11:20 AM, Weiny, Ira wrote:
>>
>> On 08/30/2015 02:12 AM, Or Gerlitz wrote:
>>> On Thu, Aug 27, 2015 at 5:55 AM, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> wrote:
>>>> When no matching listening ID is found for a given request, the
>>>> net_dev that was used to find the request isn't released.
>>>>
>>>> Fixes: 20c36836ecad ("IB/cma: Use found net_dev for passive
>>>> connections")
>>>
>>> same here, Doug,
>>
>> Same as the last email, I have the commit ID now, and I fixed up the c=
ommit
>> message.
>>
>=20
> Doug I'm working on the clean up Hal suggested to the ib_mad.h file whi=
ch was updated in your to-be-rebased-4.3 branch via this patch.
>=20
> Fixes: abde0260e47b ("IB/core: Add header definitions")
>=20
> It looks like this is the patch destined for 4.3 on this branch k.o/for=
-4.3?
>=20
> Fixes: d4ab347005fb ("IB/core: Add core header changes needed for OPA")=


Correct.  I squashed the first two patches (which both touched core
files) down to just one.

> I personally did not mind the rebasing except for this issue.
>=20
> Let me know which branch I should base these changes off of.

Base if off of the k.o/for-4.3.  That's where it will go.  I'll just end
up applying this to the top of the stack.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--IwTWHbcoeBoLnjPtoRjsUktDatPSaTRxd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJV5O/7AAoJELgmozMOVy/dxWgQAI6w9UU0wMzjLlFGy8fQg1uo
1dyFjdzei1mTsktHs2pOyRwyBoUgzNFx/q1QugAfhDfmx7DzIoI82NtrZBPcEO7J
uH4V9TJ2/98nmP4OOnvRjwfjHw+LNrpAa3ZadOGOTzM4sVZuhu5W1KVHW0TIWfSn
67X1bSVBP63Xvuaf6Q4vposj0LJhfw0n+nUonWItlo8vmQvpMGDBy7oFW51H/8U6
PJDjpgwcUBByV36cwn8byNG32xHzx3FcSkQ82XgF0giJZtPDqGoEL5L+Cp6Fr+55
/lyni3FB828UARY0KoPIHHjO47StSXWRp0CI6mLWgXcRPkoLbFr6ISj7rIUP7ddz
n6n7f7JpJ+1i5mDEdTEHt6qsh0kBYvifX5x5MWJfnjy4AfjQHnkukLPDrzp0Mmcd
f8UP04tXRH+ssV0iUckD51ykzpY17OBQ6L9a3E068FrDN6iPw3k80ZylawEXiXMm
d4HnfCZC34k0OR/ESXXC7iRLfwqvtMU0Tvzd+oPo8iKZ5l91lXxlbLhyOTktsMQF
rPszC8Ubkefyj9SgzFiekFgAC2fRj2ugHTCHEt3OiGgvNZqvRUGvbOfzt7LSqQot
LdQDpWm64vkV833QbtZIJi2ExUtIbNKO+y5fMtgvyDhQoKW4z2AzJYsznoIz1OZ2
PnU/6eWqtoP+YR51vMt0
=qClX
-----END PGP SIGNATURE-----

--IwTWHbcoeBoLnjPtoRjsUktDatPSaTRxd--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

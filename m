From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git
Date: Fri, 18 Mar 2016 14:17:29 -0400
Message-ID: <56EC4639.1020307@redhat.com>
References: <56EAE9D6.2030908@redhat.com>
 <CA+55aFxxoO=i7neGBRGW_afHsSZ7K-x6fMO8v-8po3Ls_Ew0Rg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="AJaJPO2x0Av2aMedEW241gtLPd04L7SNW"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+55aFxxoO=i7neGBRGW_afHsSZ7K-x6fMO8v-8po3Ls_Ew0Rg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--AJaJPO2x0Av2aMedEW241gtLPd04L7SNW
Content-Type: multipart/mixed; boundary="kXbNMGsW9omT6XpALt19JwMHdEIAW4m7d"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <56EC4639.1020307-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git
References: <56EAE9D6.2030908-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <CA+55aFxxoO=i7neGBRGW_afHsSZ7K-x6fMO8v-8po3Ls_Ew0Rg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
In-Reply-To: <CA+55aFxxoO=i7neGBRGW_afHsSZ7K-x6fMO8v-8po3Ls_Ew0Rg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>

--kXbNMGsW9omT6XpALt19JwMHdEIAW4m7d
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 3/18/2016 12:52 PM, Linus Torvalds wrote:
> On Thu, Mar 17, 2016 at 10:31 AM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wr=
ote:
>>
>> There is the one merge issue between the net tree and this tree that w=
as
>> simple and obvious to fix up.  I've had a phone call with Mellanox abo=
ut
>> how to avoid this in the future (the result of that conversation was
>> that when they have a pre-req patch that is going through Dave's tree,=

>> but the dependent patches are going through my tree, then they should
>> submit the pre-req patch to me as well, we can carry identical patches=

>> in both trees, and when you merge the duplicate patches will just drop=

>> one and then there will be no merge issue).
>=20
> That will end up causing just more problems if there are then other
> patches on top in either tree.
>=20
> It would be much better to have the shared pre-requisite not as a
> _patch_, but as a separate branch. So that you actually share the
> commits, not just the diff.
>=20
> Other subsystems have been able to do that.

Fair enough, I'll "encourage" Mellanox to identify which patches will
have merge conflicts between the net/rdma trees, and when identified,
submit the patch series that contains the pre-req patch with a request
for a specific topic branch that I can pull from Dave, they can then be
on the hook for letting me know about the topic branch.

>>  drivers/infiniband/hw/mlx5/srq.c                  |  41 +-
> ..
>>  91 files changed, 3647 insertions(+), 1995 deletions(-)
>>  create mode 100644 drivers/infiniband/hw/mlx5/gsi.c
>=20
> My diffstat doesn't match yours, and it's that "srq.c" file in
> particular that I have no changes to, and see no changes in your pull
> request.
>=20
> Other than that it looks normal, but it makes me wonder how that diff
> was generated.

Sorry, that's my fault.  I have a little scriptlet that I feed whatever
kernel version I based my for-next work on and it spits out the pull
request using git request-pull and several static items and that kernel
version.  However, even though I had based my for-next work on v4.5-rc6
(I had been on v4.5-rc4 until I saw that Mellanox put the change to
their offset header file in via Dave's tree between rc5 and rc6, so I
rebased), I had also pulled in my final -rc pull request via this line
in my k.o/for-4.6-topics/ib_core:
bbdfcf18c3b5 Merge branch 'k.o/for-4.5-rc' into HEAD

That merge meant that the diffstat my pull request spit out is showing
the diffs from v4.5-rc6 to my last 4.5-rc pull request + the queued
for-next work.  So your diffstat should rightfully drop the changes to
that file since you have them already (and to three other core IB files).=





--kXbNMGsW9omT6XpALt19JwMHdEIAW4m7d--

--AJaJPO2x0Av2aMedEW241gtLPd04L7SNW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJW7EY5AAoJELgmozMOVy/dR6IP/iF3V2AVXRQCy9XStyIlNA6v
I1pE0GY/xMJ0BhvJkpltFDvjpvbwIQ+P3d0m3ibFMJjAV+rAjLOOcXvQ7ZiTDPKN
E+hcqpz+sGrOf6uY+nfAKXcse9C9Rjevak5hjXHcqWgPzVVNJfvPbH9zXJC4Q2CT
ngLIAPZTvQz8AgpzbCpIASki29Fa5ZPivcV0aoWlGgqL1D/pZfnMTohT3vuPwDkk
Loy+9ShZBrPzn9g29IU+chfThiV6VOFS1ts8RAYeB0UEhcDrwOVzXtENZVlsvsld
RrqbdKmLMN1PIO2MIz6oN78sscq8OOn6ZFcHyepk4CTb1MCfQl8T5U6Sv1YXlZka
03r//a87FwshupaePtHq6Nu2Pq2ZhIwu7RmlLcnhEDGM7nSIpnahgq/+kNE7RY2f
uc/8QKSCHu1/dErBp7kznkgvvCjDXyhn/lDNjbwVhNGYsk1wbtYjLmXBmwMu1hoY
qGQzzMkMWRoH6rRHACUQaKbMymu86ETYTC5NrGoqPtv6wd9ACAtrA9ztRoI9Qoiz
A5devKUpWNbEB+XGbiy8DE8Hgw+APZ0F5fdUvNI7pCVvdXY6u5vXiEHSVTWKT48w
vBRUthQ2TZMCFoG2g6pQ4ZM+FzCjp+YoOGVt85ArZgys4KZW3fdLu52bkvKplZIU
8ZHQx2shv+ZAWmUakpIs
=PGw7
-----END PGP SIGNATURE-----

--AJaJPO2x0Av2aMedEW241gtLPd04L7SNW--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

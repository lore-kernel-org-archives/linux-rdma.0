From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git
Date: Thu, 17 Nov 2016 21:01:19 -0500
Message-ID: <fea924a0-f399-8ecf-c039-5cb7c5e0acb8@redhat.com>
References: <58466423-c87e-3921-101e-bffab8989fd8@redhat.com>
 <20161117184950.GP4240@leon.nu> <582E089A.3040106@redhat.com>
 <20161117200203.GQ4240@leon.nu>
 <CAJ3xEMjXYYnhS6qUzM9F+yjtq8Aahn08MjsSU4OnLS66Cu7mgw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Kxma1qeEmpiPkrXfwNwE332Qa2xKelv1R"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMjXYYnhS6qUzM9F+yjtq8Aahn08MjsSU4OnLS66Cu7mgw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Kxma1qeEmpiPkrXfwNwE332Qa2xKelv1R
Content-Type: multipart/mixed; boundary="MXiR8pGUePSqIlrCtMqX4P1pRhHLQvdXq";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <fea924a0-f399-8ecf-c039-5cb7c5e0acb8-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PULL REQUEST] Please pull rdma.git
References: <58466423-c87e-3921-101e-bffab8989fd8-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <20161117184950.GP4240-2ukJVAZIZ/Y@public.gmane.org> <582E089A.3040106-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 <20161117200203.GQ4240-2ukJVAZIZ/Y@public.gmane.org>
 <CAJ3xEMjXYYnhS6qUzM9F+yjtq8Aahn08MjsSU4OnLS66Cu7mgw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
In-Reply-To: <CAJ3xEMjXYYnhS6qUzM9F+yjtq8Aahn08MjsSU4OnLS66Cu7mgw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>

--MXiR8pGUePSqIlrCtMqX4P1pRhHLQvdXq
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 11/17/2016 5:24 PM, Or Gerlitz wrote:
> On Thu, Nov 17, 2016 at 9:44 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
>> On 11/17/16 1:49 PM, Leon Romanovsky wrote:
>>> On Thu, Nov 17, 2016 at 07:13:54AM -0500, Doug Ledford wrote:
>>>> Hi Linus,
>>>>
>>>> Due to various issues, I've been away and couldn't send a pull reque=
st
>>>> for about three weeks.  There were a number of -rc patches that buil=
t up
>>>> in the meantime (some where there already from the early -rc stages)=
=2E
>>>> Obviously, there were way too many to send now, so I tried to pare t=
he
>>>> list down to the more important patches for the -rc cycle.
>=20
> Hi Doug,
>=20
> Except for the hfi1 patches, all the rest (core, mlx5, mlx4 and rxe)
> are marked now as only 21 hours old in your 4.9-rc branch and they
> seems be made from you picking partial subsets of multiple series,

Correct.

> with none of them acked by you on the list.

I had an all day meeting today and had to get out the door early.  The
patches will be responded to.

> If you agree that I am describing things correctly - how are we
> expected to follow on your patch picking? I find it sort of impossible
> and error prone.

When I started this I said the official, canonical source of information
on patches like this is patchworks.  That still holds true.  In this
case, I pulled the full series of patches into a single bundle, then
reviewed every patch individually.  I checked for importance and
dependence on other patches.  Those that I thought could be moved to
4.10 were moved into a new bundle and then removed from the existing
bundle.  In this way, the patches were always in one or the other.  When
I was done, I used git am on the two bundles and one into the 4.9-rc and
the other into a -next branch.  In that way I made sure I didn't miss
any from the four series that I pulled.  Finally, I used the bundles to
mark the patches as accepted in patchworks.  By marking the entire
bundles as accepted, and not individual patches, it makes sure that what
I mark accepted is the same as what I ran git am on.  So, if the patch
shows in patchworks as accepted, then I got it.  If it doesn't, then I
missed it.

>>> Are you adding the rest to your for-next branch? We would like to hav=
e
>>> enough time to check that nothing is lost.
>=20
>> Yes, it's already there in the mlx-next branch on github.
>=20
> Re the patches there, this one
>=20
> IB/mlx4: Set traffic class in AH
>=20
> "Set traffic class within sl_tclass_flowlabel when create iboe AH.
> Without this the TOS value will be empty when running VLAN tagged
> traffic, because the TOS value is taken from the traffic class in the
> address handle attributes.
>=20
> Fixes: 9106c41 ('IB/mlx4: Fix SL to 802.1Q priority-bits mapping for IB=
oE')"
>=20
> claims to fix my commit, I have approached Leon and Co for
> clarifications/questions over the list on the patch and nothing was
> answered.

I agree with you.  It doesn't fix your patch.  The commit message can
still be fixed up.

> Please do not send it to Linus and wait for them to respond. I
> disagree that it fixes my commit b/c my commit was prior to when
> route-able RoCE  was introduced and on that time TOS had no relation.

I agree.  A better fix tag would be the commit that added RoCEv2 support.=


> and this one
>=20
> "IB/mlx4: Put non zero value in max_ah device attribute
>=20
> Use INT_MAX since this is the max value the attribute can hold, though
> hardware capability is unlimited.
>=20
> Fixes: 225c7b1 ('IB/mlx4: Add a driver Mellanox ConnectX InfiniBand ada=
pters')"
>=20
> does a tiny enhancement for a 10y old commit of Roland, why you think
> we need it in 4.9-rc6 or 7??

I don't, it's in the mlx-next branch which means I'll queue it up for
the 4.10 merge window.  I have no plan on sending that branch for 4.9-rc.=


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--MXiR8pGUePSqIlrCtMqX4P1pRhHLQvdXq--

--Kxma1qeEmpiPkrXfwNwE332Qa2xKelv1R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYLmD1AAoJELgmozMOVy/dloMP/2TRMTVUHROykXZkEqcm9n8n
TNkrgrNiKmI96nEW8jq7QQN37zg3D4cQwjDenVO0eB3xGGTW52kMqiheT7gu3nJ2
r3ePShqiJX2yGLYiupeZtADiUqamQpA2uT4WgMo9OhxkxE6bBiQCNp8iFjTChrCH
NewlMdXresTj3g+OLNZ2eTWng4+PYfQxDOqJrylUksB0Fg+lEQHHVx+hSNXIzLyB
UZ1vA0D0DriDEs8EmxOdolzrVNRoGTqA4iFfXBInkwpqWJBVd479reVlkvAhS/d1
tEaNL4Twj54lqNzYYTCh1/6JEfJcDchzl8PFCp+pI95aYBn2RwDizzgk2S3L/uhK
+2oy0BQkv5RUc4BCkh/sZxw1yBMVx9dwO53sNf0SNkoBn95zEiHk4vuXkcImY5Nx
2V7uqEyflbbyMzLzZ5r0WWFKZSd3CcNByLN/UDuPs+tA16OyejjmEHprPD4kAsJG
x9yTkDAPeqQ6OF44k5KyCKE/7Sl4rtdOuS255lmDoxJUCq8JIFuhhqamw3uC/4Co
HWLkBHFPpxGx5X1kYc1m2SswYCEvhbx5specv/fqGRERmswPwwnRRZTgXwG/4ebI
OmAgG331eLPwfopVG4Vl3tfcp+/UCSufr7H7hSI8M+1GpyG/ZjRKSIjyYFg6pnLK
/QudgrjyLBgrGTE18SmK
=p36r
-----END PGP SIGNATURE-----

--Kxma1qeEmpiPkrXfwNwE332Qa2xKelv1R--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

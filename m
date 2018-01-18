From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH wip/dl-for-next] RDMA/bnxt_re: Fix kbuild error
Date: Thu, 18 Jan 2018 14:54:06 -0500
Message-ID: <1516305246.3403.301.camel@redhat.com>
References: <1516288665-11055-1-git-send-email-devesh.sharma@broadcom.com>
         <CANjDDBgnhRuroVEfGJ=gF9=dS47w7pcQh5hZsF=p5iF6mxmX9g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-sVIK7VhLdEY6oPICknDU"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANjDDBgnhRuroVEfGJ=gF9=dS47w7pcQh5hZsF=p5iF6mxmX9g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-sVIK7VhLdEY6oPICknDU
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2018-01-18 at 20:49 +0530, Devesh Sharma wrote:
> Hello Doug,
>=20
> Please pull this in, hopefully this will fix the latest build failure
> on your sub tree.
>=20
> -Regards
> Devesh

Hi Devesh,

Given that the code had only landed in my wip/ area, I took your patch
and squashed into the broken patch (which required a rebase) and then
pushed a new branch (wip/dl-for-next-rebased).  We'll see if it passes
the tests there (it passed build tests on my local system the first
time, so just have to wait for the 0day results).

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-sVIK7VhLdEY6oPICknDU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlpg+14ACgkQuCajMw5X
L92k3w//VRBwurl9rVrrlKiumcZRnNRL1C9pMY08YHFVohMgmmYNwUXtG3sIeZRH
gjxI8wZE0/nbKOgFiGMjUZBcCy/zW3qP4VF64ImHuZif/8K/o+Kp3bGLgL/91c9O
BSqXbnPxSTXYiAiqQvLuW5IXnjVDVkx4l50C7w+SBSwo80dMfGo6yg5MsqQDlXv6
dkWzx9O5MjzySJ7jzgsQRkm/aXpjVtFMf35BB8CwO/eDI4xexXVqUvfWRR9BxoT9
yjvk57TL4L/7iyT5IQzWamzpPeqVkElFRQO7saMAwc2a1cUVfVmZeu3MkU9CnA1q
tYvlmG+akhJQgYdc/EKEu1Jh7LgoKY/4l8PtFs2l74Qx/HdQj6cBX4UDBZoq1kD5
7L8s7FaUEiwRYSisC3lNc7kVcLLI5eqgB0UXcc53IN5Olz7rqKMIMoyk9Jq2NSiV
3BKvPeFjAu98g3JtLGziOfgsR5pzHYbXkoHMgk2uG1c3YGNfk7liDN49ex0ozgjq
vHXDbZbS/2fVtJ78CmdLXdmgw3L107vv5mzP+vtel6U8/KrXRPROjLhSvCkLfVp6
Bwm5yUawDNjrqcmbgmPgAk0F7tBondUxTEA6006p46QeVPA7qcs+EHCwa2f9amVb
qdDVRvo02Inch7BBgw35Pa53mCYb5XrQ5/Xuo5hzgp81VHQO2+Q=
=eXR6
-----END PGP SIGNATURE-----

--=-sVIK7VhLdEY6oPICknDU--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

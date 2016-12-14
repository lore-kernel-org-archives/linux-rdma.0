From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] qede: fix general protection fault may occur on probe
Date: Wed, 14 Dec 2016 14:17:38 -0500
Message-ID: <50c75e84-ff6b-a06f-a4c3-4d004d1b56b2@redhat.com>
References: <SN1PR07MB220763908ED050AAFE840CEAF8B70@SN1PR07MB2207.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="QOmkhvIu3C2nrb9ooRxN14Rj4wWlGT2fQ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <SN1PR07MB220763908ED050AAFE840CEAF8B70-mikhvbZlbf8TSoR2DauN2+FPX92sqiQdvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Mintz, Yuval" <Yuval.Mintz-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--QOmkhvIu3C2nrb9ooRxN14Rj4wWlGT2fQ
Content-Type: multipart/mixed; boundary="VkXaXLWCX7Vs70I3fANkalT6eP7l45kFr";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>,
 "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>,
 "Mintz, Yuval" <Yuval.Mintz-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>,
 "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Message-ID: <50c75e84-ff6b-a06f-a4c3-4d004d1b56b2-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] qede: fix general protection fault may occur on probe
References: <SN1PR07MB220763908ED050AAFE840CEAF8B70-mikhvbZlbf8TSoR2DauN2+FPX92sqiQdvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
In-Reply-To: <SN1PR07MB220763908ED050AAFE840CEAF8B70-mikhvbZlbf8TSoR2DauN2+FPX92sqiQdvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>

--VkXaXLWCX7Vs70I3fANkalT6eP7l45kFr
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 11/23/2016 3:03 AM, Amrani, Ram wrote:
> The recent introduction of qedr driver support in qede causes a GPF whe=
n probing the driver in a server without a RoCE enabled QLogic NIC. This =
fix avoids using an uninitialized pointer in such a case. Caught by the k=
ernel test robot.
>=20
> Signed-off-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
> ---
> drivers/net/ethernet/qlogic/qede/qede_roce.c | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/qlogic/qede/qede_roce.c b/drivers/net=
/ethernet/qlogic/qede/qede_roce.c
> index 9867f96..4927271 100644
> --- a/drivers/net/ethernet/qlogic/qede/qede_roce.c
> +++ b/drivers/net/ethernet/qlogic/qede/qede_roce.c
> @@ -191,8 +191,8 @@ int qede_roce_register_driver(struct qedr_driver *d=
rv)
>               }
>               mutex_unlock(&qedr_dev_list_lock);
>=20
> -              DP_INFO(edev, "qedr: discovered and registered %d RoCE f=
uncs\n",
> -                             qedr_counter);
> +             pr_notice("qedr: discovered and registered %d RoCE funcs\=
n",
> +                              qedr_counter);
>=20
>                return 0;
> }
> --
> 1.8.3.1
>=20

This patch was seriously malformed (spaces instead of tabs, no space
beginning the line that ends the patch, etc).  I redid it by hand, it's
now applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--VkXaXLWCX7Vs70I3fANkalT6eP7l45kFr--

--QOmkhvIu3C2nrb9ooRxN14Rj4wWlGT2fQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYUZrSAAoJELgmozMOVy/dHmcP/AvNAXFuVpjjmWNCh9D/iYNs
kvIVV3O5ZrS5H3QLO+hw6o1kpliaaCk/DudRcTUwQA+a3owjPRRNmOblawbVqlD8
G4TeSCfk7uSy5tJS4+3/sr9Dmwvz6HnYvWbMdHqFuSjipsEZacR6WOPFuS1F/nyR
/0nEIQhCDB8CgzDSpccCNWa0SPoTw/Xtsd6JLPSU9FgZybvgZuXi4+DI+MNpqXI1
wPmndj9AEUxU0c1ACeQvXVycHOo/GORBYC4fi5vYRkpKI43e1ZT4dIdlw/TM4gjb
Gt3CX/GBcayLxvKzAb48FyFxgenbShGFAexD8uShNKJZCKvwd/vId1q7DsxQGp8m
Z3VoayRslDdenB4WGWilb4h3+R/ySts7gUj+WXWpd0iIQzQh8PB27Q1S6Hab2dVK
U3zpYDEmPnOHTazqUcRetUERviFBFt7yLN7zFfuwcjKtc9FVIKnUulO51wXUzDVC
aezy5+C9QN1nT29rQpxBIgBon5a0u8czNueP0iV7ZqTTHDUouHCAwB6upHZfbNPb
TbniTNha0S50miOue1uRF/zqg0C7iWBh3sFSShh3FARj5c4zqngiuhwrTSeV+jNo
GtEyuvtEh7j1YnxOWaaT3SRKAG3mPPWCaaY5moePzUWiPETEMJCTB1oV9vs56DSI
oHc7xcTVI6RizLKOAdNa
=z9sP
-----END PGP SIGNATURE-----

--QOmkhvIu3C2nrb9ooRxN14Rj4wWlGT2fQ--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

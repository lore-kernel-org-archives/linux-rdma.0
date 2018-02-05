From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] net/mlx5: increase async EQ to avoid EQ overrun
Date: Mon, 5 Feb 2018 18:10:26 +0200
Message-ID: <20180205161026.GH2567@mtr-leonro.local>
References: <1517840992-29813-1-git-send-email-maxg@mellanox.com>
 <1517846530.3936.71.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="8TaQrIeukR7mmbKf"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1517846530.3936.71.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--8TaQrIeukR7mmbKf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 05, 2018 at 11:02:10AM -0500, Doug Ledford wrote:
> On Mon, 2018-02-05 at 16:29 +0200, Max Gurtovoy wrote:
> > Currently the async EQ has 256 entries only. It might not be big enough
> > for the SW to handle all the needed pending events. For example, in case
> > of many QPs (let's say 1024) connected to a SRQ created using NVMeOF target
> > and the target goes down, the FW will raise 1024 "last WQE reached" events
> > and may cause EQ overrun. Increase the EQ to more reasonable size, that beyond
> > it the FW should be able to delay the event and raise it later on using internal
> > backpressure mechanism.
> >
> > Signed-off-by: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> Thanks, applied.  But if this gets me in trouble with DaveM for sending
> a patch to drivers/net, I'm gonna tell him it's because you sent it here
> and excluded netdev@ and that it was part of a series related to an RDMA
> issue that I took it, all while giving you the evil eye ;-)

You can add that neither me nor Saeed didn't test it for any conflicts.

>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     GPG KeyID: B826A3330E572FDD
>     Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD



--8TaQrIeukR7mmbKf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlp4gfEACgkQ5GN7iDZy
WKfGeQ/+NOt7dmKjYQSVQuekwdReAPkXeYodmEv4OAxehArKhKqXcGOgj7+l1YZD
Kt9M2Pf16sft+gg2kqivzPKSG4cbyzKRltwQcB/V5xSYW+f4t11mL9dhyM1mFgNe
a8XQrs81uu0pEldJpCr30FxIGRorMPYuXfIEukoU23/aGFFEcgEFb3uz76IijI8T
xUKjSJ8iIY01vIOqLILYyw/kY0a1g+keY/lz1N0f7fWLzOpdEovtIN9+GA+KsDGJ
diFCoIK4BLIyd5ZXDcLgQt7WRDnGNbEFi2uBRL+PBDB9Waw0fgmF4sH+0xzGXzku
xp0KtUqCSU08Le2LzrqTJqcTgxmOOlHEXgY2yjrPaIHhGW36Adv0ibxZh30kL4+9
MFUZ5k9rqU2m1zJOcirWtixUFZNXF4aWdWdKnaj2IZaE1Q5NToUYTmMolT4dB/Mu
SCdaNZSSCFDoa53bizm60gXMJrmcywyfpjCZURZy5bhczKDumqxaWyoEVHLUzHiV
ikvKWZ3WdCYA1Yf3Jv1aya4P9PzQBSuN2cYHxoW3dohLKTOshOyE7PIEg2MTvfxQ
x/BOxy2tLbmE7gwpAbLlNFznaqWh+pRKBJjLkoxgjaVVTnV/67yBtnI90bptRc6h
cpN2OIVFf+gxjcXo7y1zc8vyohwftp0XCz3xrX4mQd4FQXlMCJ8=
=HCs4
-----END PGP SIGNATURE-----

--8TaQrIeukR7mmbKf--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

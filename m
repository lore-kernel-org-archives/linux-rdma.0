From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH 1/2] IB/mlx4: Enable debug print of SMPs
Date: Mon, 17 Sep 2018 20:52:31 +0300
Message-ID: <20180917175231.GO3661@mtr-leonro.mtl.com>
References: <20180917145309.1255642-1-Haakon.Bugge@oracle.com>
 <20180917145309.1255642-2-Haakon.Bugge@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="7mxbaLlpDEyR1+x6"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180917145309.1255642-2-Haakon.Bugge@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: =?iso-8859-1?Q?H=E5kon?= Bugge <Haakon.Bugge@oracle.com>
Cc: Doug Ledford <dledford@redhat.com>, yishaih@mellanox.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, jgg@ziepe.ca, jackm@dev.mellanox.co.il
List-Id: linux-rdma@vger.kernel.org


--7mxbaLlpDEyR1+x6
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 17, 2018 at 04:53:08PM +0200, H=E5kon Bugge wrote:
> IB Subnet Management Packets (SMPs) were excluded from debug prints.
>
> Fixed by enabling print even on QP0 MADs.
>
> Signed-off-by: H=E5kon Bugge <haakon.bugge@oracle.com>
> ---
>  drivers/infiniband/hw/mlx4/mad.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>

Thanks,
Acked-by: Leon Romanovsky <leonro@mellanox.com>

--7mxbaLlpDEyR1+x6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbn+nfAAoJEORje4g2clinoOUP/2j8KVolKlLI4unYeMHygihA
PoDSMe2dS643eNThDopdLmE19bMtRzS1doEkXgFUDCFycR+HjWbabZuV2CLEDSnW
DjcHqMFpobAK0GoogdBAO/yttuZUAMXVeOb4GLL1T5wQudkPDKVXlgEw5cFUonn5
AZnnJc6dIwy8vsZVp37hkVYf+ig9TcfSGhmQwo/jct2qCuOEWg+QkJSxXwedJnSc
DKPgPsON0ykaPrcq8m6ufFxheIfJBlAKx+/G6TM4q/fdVGYoI+yEFaiEIoWz2z8b
UiOWDLpfZIF/mV3GbX8LpL1ycCluQP7zUIxE1tDqnzeiUY5udGLG4E+p1P1qbTbA
FwF8HLfIMuwYz+DPP8eU7w7yRvlwcbaJWVu8IX5nkf0Xo8W+JsLjEypIiLo2CHdX
mtPkfd/n7y6PhCn4blMHP+DeTJTZ1d3H2K1fgU8SiAZjnHh24bRdkhpHu5RV4w8S
pc6m1UkvuhIRSxa0cAG6ZhhOuIkm0ltGe8CQIeiHgmlOFGZWrJRo2ORhSfhhZhah
QftH9sTBSQGYLN3lYUhgNVOkQzUYeKB55eiTfybN1deCLhgCzKPt/+MUzapysrTr
nr7bnGu9Usl1RptPaQ6Lub/OUxR1LHXJK0NA5k1yi3cIUHkX2uDubuGsjy01utG6
j87iXfQBdxThunT9vXRU
=8z77
-----END PGP SIGNATURE-----

--7mxbaLlpDEyR1+x6--

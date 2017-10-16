From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 0/5] RDMA core, mlx5 fixes and refactoring for
 4.15
Date: Mon, 16 Oct 2017 08:42:25 +0300
Message-ID: <20171016054225.GC2106@mtr-leonro.local>
References: <20171016052812.28802-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="N+dhEFW7Y2Uiel/w"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171016052812.28802-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--N+dhEFW7Y2Uiel/w
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 16, 2017 at 08:28:07AM +0300, Leon Romanovsky wrote:
>
> J=E9r=E9my Lefaure (1):
>   IB/mlx5: Use ARRAY_SIZE
>
> Parav Pandit (4):
>   IB: Let ib_core resolve destination mac address
>   IB/core: Fix unable to change lifespan entry for hw_counters
>   IB/core: Fix use workqueue without WQ_MEM_RECLAIM
>   IB/core: Take into account optional UDR, XRC headers and mandatory
>     ICRC for RoCE MTU

Doug,
Sorry, please drop this series, I missed one patch, it should be 6
patches and not 5.

Thanks

--N+dhEFW7Y2Uiel/w
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnkRsAACgkQ5GN7iDZy
WKc6aA/9EshUNS9AzUEroEBmErJ3e70vkqnJbQZT39B8GtwhaL2Dsbcg7aqutwDH
WjsvOWm5AuEa1P/n+oyw7SeFEsUaZub2HpDuf5UuWr+M3H6FdRkRs6J7A0+IEOMY
t5wwKyeVoMqu5RHZTQPrtXfMBvgHfBnjN2cLw4aJP31rh5evU8EoVDQwDJEMS/zG
tZ08eAYiwWrEeyr/iZWB1pHrHZW/6qhexDjdkDC1Z4MXaPocucfXy9g5VpnjCxYj
2H/xEVQTHdtlWLvBPcarbW4ER4Wn5ovTWCPvt7SpruFhmRj07U9Uppvijb6uyZ7a
XR+GbNBVedgCtkxcVLpwzqUSPQak7DhgZ0xJF5NI2wkwR+WXwaWSHLG3LQnA/Jii
WfTOxLUWo2l5ES/HGxzkTy/o7qK/RC5m2/Zg/Lwei+PrgG54u/KZfTUDsrLybezW
W23FmxOwUvIuAp3gdRpUR7wfBsTUnYchgdbKAE4Lup1PYf8v2IKl1Khs5+5bkHsD
NMNBuVOESD3DOONDFWI52j9kZvyUkn++od43mpBteKntvmqWbTrJehnECjY+0lMB
mo5+Q+1x1VJlYQdzIFeMjA+pmNmcZ53imCu7hRE9RfTTZOcKzZlBJ+wlozUG47SQ
aPC8Tug1RRZe9ye1b+YTMhoG8t/zn+WSJKrKyVMy8++dFf4m5xM=
=W7oC
-----END PGP SIGNATURE-----

--N+dhEFW7Y2Uiel/w--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

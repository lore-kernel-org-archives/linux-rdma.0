From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [rdma-rc 03/14] RDMA/core: Remove unimplemented node_types and
 node transport
Date: Mon, 31 Jul 2017 15:18:23 +0300
Message-ID: <20170731121823.GV13672@mtr-leonro.local>
References: <20170731070924.7193-1-leon@kernel.org>
 <20170731070924.7193-4-leon@kernel.org>
 <2e1b38f9-ae7a-4f5e-9cac-168f1f9b56af@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="/7+LvQqw8N5lf/3J"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2e1b38f9-ae7a-4f5e-9cac-168f1f9b56af-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--/7+LvQqw8N5lf/3J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 31, 2017 at 08:01:51AM -0400, Hal Rosenstock wrote:
> On 7/31/2017 3:09 AM, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
> > There is no need to carry code, which is not implemented in any
> > underlying hardware.
>
> AFAIK there are Linux based IB switch implementations and there may be
> IB router implementation(s) whose drivers have not been pushed upstream
> so it would be better to leave at least those 2 node types in.

So if they care, this code will be pushed together with needed fields.
Right now, this code is not connected in current linux kernel code,
not tested and can't be exposed.

It is dead code from upstream point of view.

Thanks

--/7+LvQqw8N5lf/3J
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAll/IA8ACgkQ5GN7iDZy
WKcRBw//Yi0dZmqjUmv9hgBT8RfdQgCUT+LXSBT44xgLn1lNxpGIbGIXA/MWwzgu
k28GFxGsh27WgkTp/Vuq9GzapGqwuJs3npKI1xaXD7i6S6jQrVHktbxqVCpojfPg
WrIVGSW9dTrp6KOAW2VZgk+9SNz2yPiIqCNlgo8/Z7jN477IAivR8hAMC50pxpLK
oNzRE8TLg1pCzjeT61gTECMjMZQ0ICRweaJzoCUt0FJzfNliwb6G/bZTQx2oi2/D
N8PotGFZWu0viAO7dN4TasS4yCV9I8gthjpwOZwncfgTaA2IJHkQWri0GG/2+axV
jVmU9ux0+Z2iqb88wWzAkTNcnNUToqf6NCWavRrlCzJJxvXDikJT22Foa3a+67NB
oyE1BfZt8/A3Js6ZBvTRJSkBaxEBlWtn+/Dz/MdgAn9ohAHP2pTN+BcttBF6hW2a
3ljK0qaSn02VZuEHGlCwZtdRhSY/1F7oyxcYER/eQgQSPRYDgxLLoKqdqD5ebCWh
+cOhP9EYupsTnIQI53e8cR7+jM/47qjjlIsp7Mwynb1j8PGUnpLsaYyXUpcD0PEe
c//OEUB0ztWCRLicKhdAmCxP3wQk4A2VL2nZC1oJTx8IyAGab8d/au1NR4nUCSyI
OW4BlUV71cHPosyDI1o2yh7v/bPT8nUpbAHuTFbl40uwFaRoFCE=
=d4w1
-----END PGP SIGNATURE-----

--/7+LvQqw8N5lf/3J--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

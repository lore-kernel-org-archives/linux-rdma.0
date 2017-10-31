From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core] libibumad/umad.c: In get_port, ignore sysfs
 rate file errors
Date: Tue, 31 Oct 2017 19:21:35 +0200
Message-ID: <20171031172135.GL16127@mtr-leonro.local>
References: <f4ae658c-0e2a-c264-e0b6-f1ed639237eb@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="IWOW6f13lWWiH/hK"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <f4ae658c-0e2a-c264-e0b6-f1ed639237eb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ghazale Hosseinabadi <ghazale.hosseinabadi-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--IWOW6f13lWWiH/hK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 31, 2017 at 08:14:58AM -0400, Hal Rosenstock wrote:
>
> This can cause ibpanic in ibstat when width is not set properly
> as can occur when QSPF is not plugged into port.
>
> ibpanic: [7851] main: stat of IB device 'mlx5_1' failed: Invalid argument
>
> It's caused by kernel sysfs.c:show_rate returning -EINVAL
> and that error being treated as failure in umad.c:get_port.
> With this change, Rate is displayed as 0 with ibstat for this scenario.
>
> Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  libibumad/umad.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>

Thanks, applied.

--IWOW6f13lWWiH/hK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAln4sR8ACgkQ5GN7iDZy
WKdroQ//Rmn9p0SJuEnc28/HxLXX2tpPgruuAXzLEa2CvQzQDlleBYRz1inPN6/Q
ARPlyoNfgptjZrnnLuEm4n//2zd+0xwQuAl9Xs+dsQn/yPLCJcznxxCAFZl8pBYt
nCavVwsKBEPNHJxQLyn40FVsStOTNTltQTjyzuRC4No94/cPS5ytdGmZrCpYArml
uaFh0PxH43cUEwnf3ZkVikjKy2TqbJNoRN0j2nwEwc2/+xnirc3zB+qnX3CH3lzv
RM1gQurAjdZhyduQv0KdTXxvob1YmH5Rs3Gb4U7Cstk/90VY2N2IHW2f5LLCT02W
dDkWUOHNxINAD0W5xnWb5oW3BWj/tbghATbq9aD0hyGqekp03AUOGwweeWNJYX63
WBXZ4TRx0Zb8majxLtFhwcqS3EboVizdikcQtZtNa6VAVZz6vD2Msv4LkhJsMCTz
7BB9Wb9zBw/bJgIAvCM5mWdJWN3S4d2l6QwReEO6mZ9i0ZnvVLDiiF53+4CjTTfC
aAktdaWiCfIXiFNQzyrho9tTYtnCmIa5edokY+miKeC2FgbZe+tGJJsMu4SlHpyr
Bf1ttY7G9N3oCCsRsJWWg3OAPDqFEMwPGFDUNRFWxw79/tByPDzc6wG5A9IpR/WD
VaEdme0Y7wKDWJQyKWFeplw6V7Zx/ZOXvMwdt6JzSxji74RBKWA=
=Gv0G
-----END PGP SIGNATURE-----

--IWOW6f13lWWiH/hK--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

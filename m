From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] net/mlx4_core: VF probe fail when HW support 64-bit
 coherent DMA
Date: Wed, 11 Jan 2017 10:53:58 +0200
Message-ID: <20170111085358.GX7218@mtr-leonro.local>
References: <1483954699-17826-1-git-send-email-shamir.rabinovitch@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="v9g2r9e2kvGs7M7R"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1483954699-17826-1-git-send-email-shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shamir Rabinovitch <shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--v9g2r9e2kvGs7M7R
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 09, 2017 at 04:38:19AM -0500, Shamir Rabinovitch wrote:
> If IOMMU support 64-bit coherent DMA mlx4_core driver will try to use it
> and VF probe will fail due to firmware error.
>
> Force all mlx4_core VFs coherent DMA to 32-bit only!
>
> Kernel log when issue occur:
>
> [1383654.766249] mlx4_core 0006:01:00.1: Sending reset
> [1383654.775971] mlx4_core 0006:01:00.0: Received reset from slave:1
> [1383654.788087] mlx4_core 0006:01:00.1: Sending vhcr0
> [1383664.318338] mlx4_core 0006:01:00.0: command 0x2e failed: fw status = 0x1
> [1383664.318342] mlx4_core 0006:01:00.0: mlx4_master_process_vhcr: Failed
> reading vhcr ret: 0xfffffffb
> [1383664.318345] mlx4_core 0006:01:00.0: Failed processing vhcr for slave:1,
> resetting slave
> [1383664.318352] mlx4_core 0006:01:00.0: Turn on internal error to force
> reset, slave=1, cmd=0x5
> [1383664.318415] mlx4_core 0006:01:00.0: slave:1 is out of sync, cmd=0x5,
> last command=0x0, reset is needed
> [1383664.318418] mlx4_core 0006:01:00.0: Turn on internal error to force
> reset, slave=1, cmd=0x5
> [1383664.318501] mlx4_core 0006:01:00.0: slave:1 is out of sync, cmd=0x5,
> last command=0x0, reset is needed
> [1383664.318504] mlx4_core 0006:01:00.0: Turn on internal error to force
> reset, slave=1, cmd=0x5
> [1383664.318513] mlx4_core 0006:01:00.1: HCA minimum page size:1
> [1383664.318515] mlx4_core 0006:01:00.1: UAR size:4096 != kernel PAGE_SIZE of
> 8192
> [1383664.318517] mlx4_core 0006:01:00.1: Failed to obtain slave caps
>
> Signed-off-by: Shamir Rabinovitch <shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>
> ---

Doug,
To be clear, NAK.
It is custom kernel with out-of-tree patches and very specific FW.

Thanks

--v9g2r9e2kvGs7M7R
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlh18qYACgkQ5GN7iDZy
WKefexAAhxMXnoKalUZwMN/XKINfTKhxsU35doHdH5NqGl1XLKGVpiyMGNOI39G2
i+FSAKwlaUT+tCSOP1SNClwk+KZ/B2YrtdG9KkxNKb+maEeDTIf7sLOazOIT0q5Q
3hi0WConUq7Jktw0xtHBdHMbn+Os6svhM8CYIEgIgr/Cv3e7ATikNYCOCHvCMKy4
y8yAItQi828nKQBqCZYu6BRpnU+wGrVO1cfe1AfwQ9zk2FeUw/f8Z8gljPMHBEPt
1ZlOfRNmyonzikUM0+OWYYnROPs+8KLAqXZg5WJD1v+qIBuGDfk1vPxBBYCUUCNp
cDATz4p2LtiMtN+awrUXnRa1MwiyktgrBSC4gREQy3yEl82b2vmdcmHIVKzrufh8
YdwchHDhNicNhbYB5dOo0XwxQxj6XRvEM8dboNdVrMmLZSulEl5XVWo2Te9OZUcI
E/W26gBR5A4JcQxD/oI3dhXmPwnsDgCDEQROLCvtg7fel961SHap2OvZ/SVuN/C9
Y7o7TTax5DQJ+TI4uTS52f2+cpIMcI3ZmQ15J0l4Nt1wEEtKE00qwicvzhi8vcXd
RtzVpB928cT/NyTZncT0abod8LDUxu4qtdVGEXIHSW/gCczeBqZgiCyYRkEs5cAM
3WouOQ3/BUnDLB+DQ4FmyVn56EpbBgEdEuJE/v0UmRUc8/CMDVc=
=rndo
-----END PGP SIGNATURE-----

--v9g2r9e2kvGs7M7R--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

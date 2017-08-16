From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 1/2] IB/mlx5: use kvmalloc_array for mlx5_ib_wq
Date: Wed, 16 Aug 2017 16:57:57 +0300
Message-ID: <20170816135757.GO24282@mtr-leonro.local>
References: <20170816133123.20497-1-dongyang.li@anu.edu.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="eMGrAD5L3cjpiKtl"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170816133123.20497-1-dongyang.li-FCV4sgi5zeUQrrorzV6ljw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Li Dongyang <dongyang.li-FCV4sgi5zeUQrrorzV6ljw@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--eMGrAD5L3cjpiKtl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 16, 2017 at 11:31:22PM +1000, Li Dongyang wrote:
> We observed multiple times on our Lustre OSS servers that when
> the system memory is fragmented, kmalloc() in create_kernel_qp()
> could fail order 4/5 allocations while we still have many free pages.
>
> Switch to kvmalloc_array() to allow the operation to contine.
>
> Signed-off-by: Li Dongyang <dongyang.li-FCV4sgi5zeUQrrorzV6ljw@public.gmane.org>
> ---
>  drivers/infiniband/hw/mlx5/qp.c  | 35 ++++++++++++++++++++---------------
>  drivers/infiniband/hw/mlx5/srq.c |  4 ++--
>  2 files changed, 22 insertions(+), 17 deletions(-)
>

Thanks,
Acked-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--eMGrAD5L3cjpiKtl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmUT2UACgkQ5GN7iDZy
WKdiKRAAhAKe8ML1XEmmsrEJQTKR08F4IBAVtXmuqMPqktQcTCZbwn6zJhbzT5Pp
bZSQVBMY9FgvvS9sRjo4njVSOR/jCkCK7hH/2xawqGqGKtkPQse6E+4I2VfD0pPO
8v1uhs/DvAjVTyvNFd18eZIV597B5blrQorQCJcxt92eJwRXKoIBAzQ4d+23sbHg
Ck21dlDO8F+5KnGViWtZOBmobs+gPes3SkN4J8LqTCcaCib2F7KpUhy85+te+95x
UlAwbQCfy/5yQaZYeO3LLX1B7V+DyTu0KOqOkcEFiDiE8f8Pq0KlQOZP96QtD1rZ
KoQ2SMXPs7gNdwvP0jRuBfjjhC0+pkHFX6BVIf5kWQPn9QLIYD9TXlj0kkbDWqw4
Ps+7KfV8zj6Vfg0cPVg1I67X/RI924/91p6Jfurf891GqkID2TVum7PXcagWNR/N
Q7gxSp8uUJf+pGncEv+13L82JnPxNZFHhDsBW/UxtTl9ZLsBwidPGmfGtyU6MEHM
KMiqATjsk/ydhKqRnwkrgxwe7AZPNJnJBjFM2MJjSKMu0g9UnE3ppPW2KojzqBAo
hN5ho+RPGRTMzZh9kWkSB5sx2vo7vE7jhfnAlfKeBVHTpFBQsciUs89tt95oDTSG
j/QM7Ik5PF5wyXL2vCSCeBvKoUVfqd3E6YlNCoZMc47ERnX+6Yo=
=QlSC
-----END PGP SIGNATURE-----

--eMGrAD5L3cjpiKtl--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

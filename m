From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH v2] IB/rxe: don't crash, if allocation of crc algorithm
 failed
Date: Tue, 31 Oct 2017 12:52:27 +0200
Message-ID: <20171031105227.GG16127@mtr-leonro.local>
References: <20171031101647.45111-1-tbogendoerfer@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="kY7Q1I7FwGue0/xS"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171031101647.45111-1-tbogendoerfer@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Bogendoerfer <tbogendoerfer@suse.de>
Cc: Moni Shoua <monis@mellanox.com>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--kY7Q1I7FwGue0/xS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 31, 2017 at 11:16:46AM +0100, Thomas Bogendoerfer wrote:
> Following crash happens, if crc algorithm couldn't be allocated:
>
> [ 1087.989072] rdma_rxe: loaded
> [ 1097.855397] PCLMULQDQ-NI instructions are not detected.
> [ 1097.901220] rdma_rxe: failed to allocate crc algorithmi err:-2
> [ 1097.901248] BUG: unable to handle kernel
> [ 1097.901249] NULL pointer dereference
> [ 1097.901250]  at 0000000000000046
> [...]
>
> Reason is that rxe->tfm is assigned the error return, which will then
> be used for crypto_free_shash() in rxe_cleanup. Fix by using a
> temporary variable and assigning it rxe->tfm after allocation succeeded.
>
> Fixes: cee2688e3cd6 ("IB/rxe: Offload CRC calculation when possible")
> Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
> ---
>  drivers/infiniband/sw/rxe/rxe_verbs.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c b/drivers/infiniband/sw/rxe/rxe_verbs.c
> index ff77f4f66970..d03002b9d84d 100644
> --- a/drivers/infiniband/sw/rxe/rxe_verbs.c
> +++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
> @@ -1192,6 +1192,7 @@ int rxe_register_device(struct rxe_dev *rxe)
>  	int err;
>  	int i;
>  	struct ib_device *dev = &rxe->ib_dev;
> +	struct crypto_shash *tfm;
>
>  	strlcpy(dev->name, "rxe%d", IB_DEVICE_NAME_MAX);
>  	strlcpy(dev->node_desc, "rxe", sizeof(dev->node_desc));
> @@ -1289,12 +1290,13 @@ int rxe_register_device(struct rxe_dev *rxe)
>  	dev->get_hw_stats = rxe_ib_get_hw_stats;
>  	dev->alloc_hw_stats = rxe_ib_alloc_hw_stats;
>
> -	rxe->tfm = crypto_alloc_shash("crc32", 0, 0);
> -	if (IS_ERR(rxe->tfm)) {
> +	tfm = crypto_alloc_shash("crc32", 0, 0);
> +	if (IS_ERR(tfm)) {
>  		pr_err("failed to allocate crc algorithm err:%ld\n",
> -		       PTR_ERR(rxe->tfm));
> -		return PTR_ERR(rxe->tfm);
> +		       PTR_ERR(tfm));
> +		return PTR_ERR(tfm);
>  	}
> +	rxe->tfm = tfm;

Thanks,
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>

--kY7Q1I7FwGue0/xS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAln4VesACgkQ5GN7iDZy
WKc+XxAAw+ngZXyQjZRrtZMSK3KfOiYXXUEaZezVs/D18dXwjKfSCJqwzaPIWMA7
rzLb2PFS8ZrQjh6NQXlEcKecrVkDt3vheN/stMAnNXuZM+mTHqwBLulhqstW8i2Q
zQjrxuRTHNp76RS56sxCKhm4oQUiBDm0ASGF/SKiEP6BjydD/DExaa0ZVCDo9jcT
7rtNZ8ng8GP4mgKgwrIBtdByLwFznhmYeS6fSIGjkwad9mlu190BlWKoQkv/+1+/
Ni2dhB4FSmbtymtM7DUwY5JFU7hHRmg8fb8O6qfiEIdfIOhYWGAdYcm3OWS8N8Ch
hZhNsuOwBGhxGEESgIBnzG+1t2la9PkdI8jU6a1lAxshrPQ9dLSCjMstyE+JBaSF
s7CeYqvDOQvDM2rKHiSrd9MKFRt699UI7fJMvqyLmAAJDN+TeZBmC5MNb7fInVys
drV4P1X64qOvPlPfMCp4ssp3G1r1OMeJ4e2WNhALzZMBplUF85zlqLuRNN7GW6wm
k95A55wbVbafs2tct2SQj9WiMPZ3hjlNf/uX6T9iE4dVJccreYJhc1IABhgXy1jW
aBkRpphao25U1SK+Aebg3kTmHWTlvLY6aB2Nk/osTg+4773Diylm8ILC0WUzcZZI
6zMIkzvUCPRr68+oQk5OZ9XpwTp07HoX8iqh1z+1TjRoKNJx+Nk=
=xFHO
-----END PGP SIGNATURE-----

--kY7Q1I7FwGue0/xS--

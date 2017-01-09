From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v2] net/mlx4_core: VF probe fail when HW support 64-bit
 coherent DMA
Date: Mon, 9 Jan 2017 12:21:48 +0200
Message-ID: <20170109102148.GY15685@mtr-leonro.local>
References: <1483954699-17826-1-git-send-email-shamir.rabinovitch@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="aBaYPhOdNx+t7mr3"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1483954699-17826-1-git-send-email-shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shamir Rabinovitch <shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tariq Toukan <tariqt-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jack Morgenstein <jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--aBaYPhOdNx+t7mr3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 09, 2017 at 04:38:19AM -0500, Shamir Rabinovitch wrote:
> If IOMMU support 64-bit coherent DMA mlx4_core driver will try to use it
> and VF probe will fail due to firmware error.
>
> Force all mlx4_core VFs coherent DMA to 32-bit only!

Hi Shamir,

Thank you for taking time and writing the patch.

Our verification labs are constantly running ConnectX-3 SR-IOV with
page sizes 4K and 64K and we didn't encounter such bug.

We will be very thankful to you, if you provide more information to help us
to understand the root cause:
 * Which OS (kernel) do you use?
 * What is the processor used?
 * Can you send us lspci -vvv output?

In the comment to the code, you mentioned CX3 with latest GA version of CX2.
Any chances to check with latest CX3 GA version?

Thanks

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
>
> Changelog:
>
> v1 -> v2:
> Review comments from Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>.
> Verified and only VF require 32-bit coherent DMA.
> PF can still use 64-bit coherent DMA.
>
> ---
>
> ---
>  drivers/net/ethernet/mellanox/mlx4/main.c |   20 +++++++++++++++++---
>  1 files changed, 17 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
> index bffa6f3..131cbc9 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/main.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/main.c
> @@ -3719,9 +3719,23 @@ static int __mlx4_init_one(struct pci_dev *pdev, int pci_dev_data,
>  			goto err_release_regions;
>  		}
>  	}
> -	err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
> -	if (err) {
> -		dev_warn(&pdev->dev, "Warning: couldn't set 64-bit consistent PCI DMA mask\n");
> +	if (!(pci_dev_data & MLX4_PCI_DEV_IS_VF)) {
> +		err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
> +		if (err) {
> +			dev_warn(&pdev->dev,
> +				 "Warning: couldn't set 64-bit consistent PCI DMA mask\n");
> +			err = pci_set_consistent_dma_mask(pdev,
> +							  DMA_BIT_MASK(32));
> +			if (err) {
> +				dev_err(&pdev->dev,
> +					"Can't set consistent PCI DMA mask, aborting\n");
> +				goto err_release_regions;
> +			}
> +		}
> +	} else {
> +		/* CX3 firmware 2.11.1280 does not support 64-bit coherent
> +		 * DMA for VFs.
> +		 */
>  		err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
>  		if (err) {
>  			dev_err(&pdev->dev, "Can't set consistent PCI DMA mask, aborting\n");
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--aBaYPhOdNx+t7mr3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlhzZDwACgkQ5GN7iDZy
WKcl2g/+MCDjbwIvRpUn/uWhXpneQ+o6mgWvrVG4pzCumb/E15pkl3dcIP6gwROS
ZuFIOEUSnor+z53FHJerSdbW3kvSTXyMMryt3B6G/33+HCW9ciBMtVw+PixAH5qz
sePwm2QFHWmknJH0CZxJzJmHeZoMDvItsKOFKrkUrlPe6REQEb5qJcyBV6Y3X8f+
d+cFJx1AgXXguBoHTy/XAuzK6vhgBAioiRfpAPyOJ7JMiNEKgbdwdpYecBTIdFXE
5L6xHRzblokIBeSOAsUaBnhOVRjUvXCY1MonUxZwxoliVNXslIuX02z0AZLnbBQ0
zitiDToGsa4nUexJ9iOhiQXGLSySUqNoK2G1P4xr9qijpWtIYIrg+hC8Cu0JiwCB
cYVWqaHCoFfmDQ2/kb+txm+TvVx2ZFmXal0Ym28gGirnxQiCZpIv3ki4pXiU/Jaj
kT1F5KhGZZaAVYhEZR1G76LARkA99hDY+YWMHZLr1nGvGrGBJRywGJCXAqsy3T/1
7XQKP+VeZayMM9/5MaGjogbjkATj4LvHh5nW5Ut8ZRXYtyuqumnM+j8Y1MEP4hf+
N6mchgBSRv/RPrpZtpE8k2Izq9gqZ4rb0HrQx2NpiD2Hikqlgil7DpBMzk+8IXrz
+s9SmMtsnfgianfX14+sPEOun7uR7u0/trhWS9oGQfZ8ZjZfJhY=
=Lk1Y
-----END PGP SIGNATURE-----

--aBaYPhOdNx+t7mr3--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] IB/core: Restore I/O MMU, s390 and powerpc support
Date: Mon, 13 Mar 2017 11:30:37 +0200
Message-ID: <20170313093037.GL2079@mtr-leonro.local>
References: <1D08B61A9CF0974AA09887BE32D889DA0DBFCB@ULS-OP-MBXIP03.sdcorp.global.sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="UthUFkbMtH2ceUK2"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1D08B61A9CF0974AA09887BE32D889DA0DBFCB-fxMRTlsoH6pS59oDqloDyoaX4dThiank9m7AsFVS2+l8Oh6FZyoiAQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sebastian Ott <sebott-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--UthUFkbMtH2ceUK2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 07, 2017 at 10:56:53PM +0000, Bart Van Assche wrote:
> Avoid that the following error message is reported on the console
> while loading an RDMA driver with I/O MMU support enabled:
>
> DMAR: Allocating domain for mlx5_0 failed
>
> Ensure that DMA mapping operations that use to_pci_dev() to
> access to struct pci_dev see the correct PCI device. E.g. the s390
> and powerpc DMA mapping operations use to_pci_dev() even with I/O
> MMU support disabled.
>
> This patch preserves the following changes of the DMA mapping updates
> patch series:
> - Introduction of dma_virt_ops.
> - Removal of ib_device.dma_ops.
> - Removal of struct ib_dma_mapping_ops.
> - Removal of an if-statement from each ib_dma_*() operation.
> - IB HW drivers no longer set dma_device directly.
>
> Reported-by: Sebastian Ott <sebott-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> Reported-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Fixes: commit 99db9494035f ("IB/core: Remove ib_device.dma_device")
> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> ---
>  drivers/infiniband/core/device.c | 26 ++++++++++++++++++++------
>  include/rdma/ib_verbs.h          | 30 +++++++++++++++++-------------
>  2 files changed, 37 insertions(+), 19 deletions(-)
>

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--UthUFkbMtH2ceUK2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAljGZr0ACgkQ5GN7iDZy
WKf9MxAAidVmX2gwlh14x+SQskEM3EPFFd0ahEOEDNUrhqWa4facW/FsjQHVt/rx
lYsJbeeNnIGyLMIFPrQ4zELDeqN39RH+VSL2iacN0Q6DJJEVJ1yfCkGg02peSQYk
2h6ZfL53/VCL1Cs84w7IYFkNzmX26ZCD7IStU+ZDxR9UHeuUENxi/kYDoirHq4ck
7/rI8KgG+Fp7r/vvRML5bDWCTfBrlC3YhBQgEmiWjDw8AWbId5wTLZCOAM8sRDJH
onO2Op39KSQV8oVDpgLx2Rt9+C8KydnGPDJwPQ/BINjxvYCeBPBaksXvaa7sRBBe
SBjkkmSS6EUDmOqXz1yR7Ur12JluYCSJczX9R4PvTqaDWSL4B5PE2G2LXadfaCev
mcpE6N4gc6pWh/uJzSboQU4cSbiDubE8B05B89GScub9T6L31427hJe32KYxIbDF
FWm/428fQlKHDXXT8i/4tOpYvDPorN0ruVFmr5M4emkyqEbr1YyvJXpwEefMAjVp
G9fS56M86sOxvGdBsH8Vkodcn3bpe/I9GxDHZn+IhPyCUzVSBsn3aFCjMf8gpg0d
4wb9K+wJhem2sD3f2qzPugs60JrfzhVi2G6nGywlLVmy4vS9b7nKiP3OMmN6KiOK
6NpU1d81JqIXngryEeQrOZ3nklESKdihkFMUrFnyNooJw104/Z4=
=yIrt
-----END PGP SIGNATURE-----

--UthUFkbMtH2ceUK2--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

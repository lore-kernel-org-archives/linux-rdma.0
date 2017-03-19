From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] IB/core: Restore I/O MMU, s390 and powerpc support
Date: Sun, 19 Mar 2017 11:26:05 +0200
Message-ID: <20170319092605.GS2079@mtr-leonro.local>
References: <1D08B61A9CF0974AA09887BE32D889DA0DBFCB@ULS-OP-MBXIP03.sdcorp.global.sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="twlwrnvElrG9k/1g"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1D08B61A9CF0974AA09887BE32D889DA0DBFCB-fxMRTlsoH6pS59oDqloDyoaX4dThiank9m7AsFVS2+l8Oh6FZyoiAQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Sebastian Ott <sebott-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--twlwrnvElrG9k/1g
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

Hi Doug,

Can you please forward this patch to Linus? The IB/core is broken
without this patch.

Thanks

--twlwrnvElrG9k/1g
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAljOTq0ACgkQ5GN7iDZy
WKc58A/+JWMQVuGKRwa0etoGWDjNIEX9SChQ1IayvHUXIMxs3Jqq1eZrjShu3DSf
QYxx/OePChOrXAgy6qk7WoH+QSTdmJ8tAoJwR9Yp6nw//PahtpfjXL+TuYOZKTXs
Lxn0VXfLzZBiy5B7qI0/ohP18XNyODXzHett/6JIGBCBOR4PZuYCsnVsawpWJREa
VyVsqWlJJzNobIDtyD2PX9o5LkRUNWHfmNUqqThUVMcUVJsfgiibb4Zkw8frVytd
bvWO8/ngII64Ufn0Qfi51AMDj+CGs0oRPgBxECWF4egJwUUdOEPqVjfcacBf7biS
p+S/tNrI7qrl/YhEYLUkSIXBzBEaFrIp1tZqzMChVrReFBAX5ZxpUtCvHFEXw06D
596VW+RH8HDg9anMTVw4tDd97IBc6qv+Av2ZvVWUPs9G1mG1bB5mmDWKrxj0mgbr
DiEsJOWsjC0HsUTj5CaHoDCwxdK+U98ngfCDjvIYK1pRToA8xBs9ya9iMXU3fXMS
z+hbtgySIx78/vl1Op7fbirgYF33cs7zj9iK0x3kd3yCYubTvhuQPNkXJX6mhm2L
5HKI2mqO2FjaUXHfvk485Aj/Mf54qOgpSH6JJS3yB8IXzbHqrOZcyNWHh5GHhMCY
UUnmiclWCEyUGab4ul4PTiYfb4sTXX2b4W+UWTkO4Zlf7zZ7XUE=
=+rkr
-----END PGP SIGNATURE-----

--twlwrnvElrG9k/1g--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

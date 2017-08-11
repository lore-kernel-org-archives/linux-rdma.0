From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next] IB/cma: Fix gid type setting for RoCE
Date: Fri, 11 Aug 2017 12:38:38 +0300
Message-ID: <20170811093838.GC24282@mtr-leonro.local>
References: <1502442585-22391-1-git-send-email-selvin.xavier@broadcom.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="PEIAKu/WMn1b1Hv9"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1502442585-22391-1-git-send-email-selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--PEIAKu/WMn1b1Hv9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 11, 2017 at 02:09:45AM -0700, Selvin Xavier wrote:
> RoCE gid_type should be 0 or 1 based on RoCE v1 or
> RoCE V2. Since bit mask is used now, cma_dev->default_gid_type
> is set to 2 (1 << IB_GID_TYPE_ROCE_UDP_ENCAP).
> Use the bit mask to check the prefered gid_type and
> assign the gid_type value to IB_GID_TYPE_ROCE(0) or
> IB_GID_TYPE_ROCE_UDP_ENCAP(1).
>
> Fixes: 3c7f67d1880d (IB/cma: Fix default RoCE type setting)
> Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/core/cma.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>

Hi Selvin,

We tested a little bit simple version of this fix.
https://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git/commit/?h=rdma-next&id=bf01e3dda415538fcb799bebfe60053cf6154490

Thanks,

--PEIAKu/WMn1b1Hv9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmNex0ACgkQ5GN7iDZy
WKcNvA/8DpUmuwsPdtc5MpJ7w8+nySsZmkreB+ilHRWzJOx2J+PJxKRLBiemjZU9
+gYeXsaoK253xAXNrjuKG6yK4+50tP0fdKYQBmawol8H+Vv2XuuiDat+vbbnN92f
z3FUCAMH65wTZ4NGoUbfAav7I+63p+A+O0NExcvz/bHGhNyGvC4pBcIN+EcTCjtO
dRN1SHgSIludPK3fgoRrqnPAQHtCk4R4T1JuDV61OszwAyvYC9qlDb4gSFSTBGIH
artOzA0VDNuVVRH3L4ZS0+qPSW88a9KpcN8+/0m/pkPjvBlUX4XIhuWDWPn5q8ql
KAu/iVObGIS4V+bhszGfjmVl+1uk4xi8Ixk2B2naWv8PL0J6iWadn+4c4pioVEtD
TOF5Vmp5ibFsrPCXdZXiNfGrRk1VRasZ5jU5NNnlV2fZyiZB2QZg/AzAxXJMiTwo
lN2kQa8e5zdO3WnSHgBQ91slyDvXNgii0YmYoVgRxFKbur7idHcxTuh+i+u5Fis4
XCblmwc/zYF05u6GsTgv5uW+Ios+XLapzaK3p3ssSGu/+WIFCjccSpzl3ZKTKvu/
UpXbMo0imYiHnD8lmUXjKywWLjtHHjY7klr1tqcpO2YyW7orIKZXlhyraN80K8bc
mAHrDYde3eeUfLytkPckJY7FjSsYe70s+ODg1Lo904SfcHfuYq8=
=cn8D
-----END PGP SIGNATURE-----

--PEIAKu/WMn1b1Hv9--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

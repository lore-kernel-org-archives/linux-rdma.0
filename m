From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 00/22] Remove deprecated create_workqueue instances
Date: Fri, 19 Aug 2016 18:48:14 +0300
Message-ID: <20160819154814.GH18515@leon.nu>
References: <cover.1471283717.git.bhaktipriya96@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="AqCDj3hiknadvR6t"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <cover.1471283717.git.bhaktipriya96-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bhaktipriya Shridhar <bhaktipriya96-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Hans Westgaard Ry <hans.westgaard.ry-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Florian Westphal <fw-HFFVJYpyMKqzQB+pC5nmwQ@public.gmane.org>, Guy Shapiro <guysh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiraz Saleem <shiraz.saleem@i>
List-Id: linux-rdma@vger.kernel.org


--AqCDj3hiknadvR6t
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 15, 2016 at 11:27:01PM +0530, Bhaktipriya Shridhar wrote:
> This patch set removes the instances of deprecated
> create_singlethread_workqueue (scheduled for removal) in
> drivers/infiniband by making the appropriate conversions.
>=20
> Bhaktipriya Shridhar (22):
>   IB/sa : Remove deprecated create_singlethread_workqueue
>   IB/mad: Remove deprecated create_singlethread_workqueue
>   IB/multicast: Remove deprecated create_singlethread_workqueue
>   IB/ucma: Remove deprecated create_singlethread_workqueue
>   IB/cma: Remove deprecated create_singlethread_workqueue
>   IB/addr: Remove deprecated create_singlethread_workqueue
>   IB/iwcm: Remove deprecated create_singlethread_workqueue
>   iw_cxgb3: Remove deprecated create_singlethread_workqueue
>   IB/qib: Remove deprecated create_singlethread_workqueue
>   iw_cxgb4: Remove deprecated create_singlethread_workqueue
>   IB/mthca: Remove deprecated create_singlethread_workqueue
>   i40iw_main: Remove deprecated create_singlethread_workqueue
>   i40iw_cm: Remove deprecated create_singlethread_workqueue
>   IB/mlx5: Remove deprecated create_singlethread_workqueue
>   IB/mlx5/odp: Remove deprecated create_singlethread_workqueue
>   IB/mlx4: Remove deprecated create_singlethread_workqueue
>   IB/mlx4/mad: Remove deprecated create_singlethread_workqueue
>   IB/mlx4/mcg: Remove deprecated create_singlethread_workqueue
>   IB/nes: Remove deprecated create_singlethread_workqueue
>   IB/ipoib: Remove deprecated create_singlethread_workqueue
>   IB/ipoib_verbs: Remove deprecated create_singlethread_workqueue
>   IB/mlx4/alias_GUID: Remove deprecated create_singlethread_workqueue

Thank you for doing it in one patch set, it is much easier to review.

--AqCDj3hiknadvR6t
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXtyo+AAoJEORje4g2clin6qAP/iga1I4U1F3z5ZaYENd7EIgv
N2zeM2e9+Jv1KkCof324Y9nGeu5WT/CZzf9400MtY0oHeINOJtT42Zju3oK65mNj
F84VTsdp2iAe8rqcWUgMO3nwe4urCpITGJBHXHO0XcTXou69yzi9pTJ/oQJRROgb
BR8mW3uU7pf5q2VDYOq0MTEhA6isrOqmlg5FysKm9PpdfnMIh3HFryXDeT0tpkct
rnxhrgTEBnKXzbyYzKyWDJKy1vbqyj27eRcb5psXZt88XS0HuoOu84ATEISQyzku
GChIZEXlIpLKBtsXXwy6u4PII6we6wsOqN7lyyk4XNvGNK9ZIiN+sHyLOCnrqJrS
j+ZRIPuO3Cc3P2/ppWkN9XWnRbmFYGXynFcHYEsC/77K935Z8JOFe5HBxplwaY0z
A9lfzZu55jet8fgIRnylUuhitMpjdp/seVeCjVg+212m92fDWGKNW1jigKtup7hi
oKIZz0fPudHfXleopiCe2iL9Inp7VjxGzsNeylmQ4VE1RQrM2Y1wNMf0D7hOCUj1
KnNHks+yIffBgOBjSlq+Gtl+F4h21QKZfNawQ1oAAlefiSKYNrc1brbtLigYZCK5
h3/9s+cSYCILi4l0tBSIaRDA91sq9yvzIdazgqBdkBs7ZS+dZHwGfp5yirqSn2BS
lJP0z8PUi3yxzjxcYOxe
=A2ar
-----END PGP SIGNATURE-----

--AqCDj3hiknadvR6t--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v1 0/2] ODP performance improvements
Date: Wed, 22 Apr 2015 15:15:48 -0400
Message-ID: <1429730148.121496.18.camel@redhat.com>
References: <1429189863-16460-1-git-send-email-guysh@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-rNXd5fXEyrvt3Mg7wbGa"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1429189863-16460-1-git-send-email-guysh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Guy Shapiro <guysh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-rNXd5fXEyrvt3Mg7wbGa
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2015-04-16 at 16:11 +0300, Guy Shapiro wrote:
> This patchset contains small changes that improve the performance of memo=
ry
> map updates.
>=20
> The patches reduce the execution time of ib_umem_odp_unmap_dma_pages when
> invalidating 4MB of memory from 46us to 13us. This amounts to a reduction=
 of
> about 30% in the total execution time of the invalidation flow. As this f=
low is
> called from the mmu_notifier hooks, this optimization can have a system-w=
ide
> performance impact.
>=20
> v1: Apply review comment by Sagi Grimberg
>=20
> Guy Shapiro (2):
>   IB/core: dma map/unmap locking optimizations
>   IB/core: dma unmap optimizations
>=20
>  drivers/infiniband/core/umem_odp.c |   12 +++++-------
>  1 files changed, 5 insertions(+), 7 deletions(-)

I've added these to the tree I have.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--=-rNXd5fXEyrvt3Mg7wbGa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABAgAGBQJVN/NkAAoJELgmozMOVy/d3MQP/Rzgb6bfh4qeDXV2piZ4J61V
j6k+ZJgFRQfV8Rz5ht3CsbWHyRww1mAmjDwwKv3l0OcOUltkeXlX3ojFcI+FOGsp
XX/glxyF0FkIIwXJgP45BzRoHyR4Ls4q+d9qNONuqi/4RL4wIvHz66/LJiRLZ9bl
eWGsVG601bQ4aawcTJh/9D7kxme+kcGz8yfxGjkRywfvvhbs9jbHqhC4qnNr6mUm
z6xWdnzWP+k7GKbVPDnM/fDi4fHeiHOjhOF63mfQ4SZDXlTANeLmf8UF4pwk4AMi
FY9yd4y62POpiWO69MLX/B1fEHXhDssFib1+Xx6yR1DlhVM+/m9zWaWYitmEF9W9
Fngg8g+AavM9I83gkACeQ0IIz4SGuXu03r0GeIZgs5Es8VCYYAvHRPQarjC0iDQt
BBgLOcmplsCShFjshFfHkPJdcD9nW/HJxRGV76a+8tCUjJapxvfoWdXJB8cpkLyu
o0Nnzh5erKpZCmy5wfKLttVH14d9RBdmWNaTDRCkcH2P8iAnKjEemSdvu7B3Phgy
WgoFU0/0bxQikGSde4u/KcCaMRHTXnChE1R8TNW7SI53DqAAw6gvsClxqmZ5MZGV
FuRQ1MkFSZEZmalvsacDv/bYa0Xln0F/iexMRdHu4gdvwZ8IUKisHvzgMqBMaI3h
bMLS6Zr/9y3F9Yy5LMl6
=SA2I
-----END PGP SIGNATURE-----

--=-rNXd5fXEyrvt3Mg7wbGa--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

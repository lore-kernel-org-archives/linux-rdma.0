From: =?utf-8?Q?H=C3=A5kon_Bugge?= <haakon.bugge-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next 6/6] staging/o2iblnd: Avoid calling ib_query_device
Date: Thu, 7 Jan 2016 17:00:42 +0100
Message-ID: <A69ACF81-2EF1-446D-8D46-EFE414C7DAC4@oracle.com>
References: <1450358340-19361-1-git-send-email-ogerlitz@mellanox.com> <1450358340-19361-7-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0 (Mac OS X Mail 9.1 \(3096.5\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450358340-19361-7-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Anna Schumaker <Anna.Schumaker-ZwjVKphTwtPQT0dZR+AlfA@public.gmane.org>, santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

I do have a holistic view on this and similar patches to avoid calling
ib_query_xyz().

Caching logic has been introduced in ibcore (cache.c). It does,
however, provide a non-transparent call to ib_query_xyz() attributes,
e.g., ib_get_cached_gid().

On my opinion, caching should be transparent.

(When caching in CPUs were introduced, we could still use the same
instructions, right?)

So, my proposal would be to make the ib_query_xyz() fast, by have
_its_ implementations using a cache.

This can be done by changing a single statement per query, and it will
take effect for all clients and ULPs:

Change ib_query_xyz() to call ib_get_cache_xyz() instead of
device->query_xyz().

This way, all legacy calls to ib_query_xyz() will use the cached
version and no changes are required in ULPs / clients.

The complication is to update the cache properly before events are
forwarded, but I think that can be done failry simply.

My 2 cents.


Thxs, H=C3=A5kon



> On 17. des. 2015, at 14.19, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>=20
> Instead, use the cached copy of the attributes present on the device.
>=20
> Based on a patch from Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
>=20
> Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
> drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c | 21 +-----------=
---------
> 1 file changed, 1 insertion(+), 20 deletions(-)
>=20
> diff --git a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c b/dr=
ivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c
> index 7c730e3..7231ef8 100644
> --- a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c
> +++ b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c
> @@ -2070,32 +2070,13 @@ static int kiblnd_net_init_pools(kib_net_t *n=
et, __u32 *cpts, int ncpts)
>=20
> static int kiblnd_hdev_get_attr(kib_hca_dev_t *hdev)
> {
> -	struct ib_device_attr *attr;
> -	int rc;
> -
> 	/* It's safe to assume a HCA can handle a page size
> 	 * matching that of the native system */
> 	hdev->ibh_page_shift =3D PAGE_SHIFT;
> 	hdev->ibh_page_size  =3D 1 << PAGE_SHIFT;
> 	hdev->ibh_page_mask  =3D ~((__u64)hdev->ibh_page_size - 1);
>=20
> -	LIBCFS_ALLOC(attr, sizeof(*attr));
> -	if (attr =3D=3D NULL) {
> -		CERROR("Out of memory\n");
> -		return -ENOMEM;
> -	}
> -
> -	rc =3D ib_query_device(hdev->ibh_ibdev, attr);
> -	if (rc =3D=3D 0)
> -		hdev->ibh_mr_size =3D attr->max_mr_size;
> -
> -	LIBCFS_FREE(attr, sizeof(*attr));
> -
> -	if (rc !=3D 0) {
> -		CERROR("Failed to query IB device: %d\n", rc);
> -		return rc;
> -	}
> -
> +	hdev->ibh_mr_size =3D hdev->ibh_ibdev->attrs.max_mr_size;
> 	if (hdev->ibh_mr_size =3D=3D ~0ULL) {
> 		hdev->ibh_mr_shift =3D 64;
> 		return 0;
> --=20
> 2.3.7
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

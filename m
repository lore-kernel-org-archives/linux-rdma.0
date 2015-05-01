From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] IB/core: Fix unaligned accesses
Date: Fri, 01 May 2015 10:45:25 +0200
Message-ID: <1430469925.2957.14.camel@opteya.com>
References: <1430448168-38479-1-git-send-email-david.ahern@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1430448168-38479-1-git-send-email-david.ahern-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Ahern <david.ahern-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

Le jeudi 30 avril 2015 =C3=A0 22:42 -0400, David Ahern a =C3=A9crit :
> Addresses the following kernel logs seen during boot of sparc systems=
:
>=20
> Kernel unaligned access at TPC[103bce50] cm_find_listen+0x34/0xf8 [ib=
_cm]
> Kernel unaligned access at TPC[103bce50] cm_find_listen+0x34/0xf8 [ib=
_cm]
> Kernel unaligned access at TPC[103bce50] cm_find_listen+0x34/0xf8 [ib=
_cm]
> Kernel unaligned access at TPC[103bce50] cm_find_listen+0x34/0xf8 [ib=
_cm]
> Kernel unaligned access at TPC[103bce50] cm_find_listen+0x34/0xf8 [ib=
_cm]
>=20
> Changed signature of cm_mask_copy from u8 to u32 as suggested by Jaso=
n
> Gunthorpe.

> Signed-off-by: David Ahern <david.ahern-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
> v2
> - updated per Jason's comments
>=20
>  drivers/infiniband/core/cm.c | 17 ++++++++---------
>  include/rdma/ib_cm.h         |  4 ++--
>  2 files changed, 10 insertions(+), 11 deletions(-)
>=20
> diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/c=
m.c
> index e28a494e2a3a..cbbf741987b3 100644
> --- a/drivers/infiniband/core/cm.c
> +++ b/drivers/infiniband/core/cm.c
> @@ -437,20 +437,19 @@ static struct cm_id_private * cm_acquire_id(__b=
e32 local_id, __be32 remote_id)
>  	return cm_id_priv;
>  }
> =20
> -static void cm_mask_copy(u8 *dst, u8 *src, u8 *mask)
> +static void cm_mask_copy(u32 *dst, u32 *src, u32 *mask)
>  {
>  	int i;
> =20
> -	for (i =3D 0; i < IB_CM_COMPARE_SIZE / sizeof(unsigned long); i++)
> -		((unsigned long *) dst)[i] =3D ((unsigned long *) src)[i] &
> -					     ((unsigned long *) mask)[i];
> +	for (i =3D 0; i < IB_CM_COMPARE_SIZE / sizeof(u32); i++)
> +		dst[i] =3D  src[i] & mask[i];
>  }
> =20
>  static int cm_compare_data(struct ib_cm_compare_data *src_data,
>  			   struct ib_cm_compare_data *dst_data)
>  {
> -	u8 src[IB_CM_COMPARE_SIZE];
> -	u8 dst[IB_CM_COMPARE_SIZE];
> +	u32 src[IB_CM_COMPARE_SIZE];
> +	u32 dst[IB_CM_COMPARE_SIZE];
> =20

You have to change IB_CM_COMPARE_SIZE, as it's going to allocate more
bytes than necessary.

Perhaps renaming IB_CM_COMPARE_SIZE to IB_CM_COMPARE_COUNT would be
good, then remove the division by sizeof(u32).

>  	if (!src_data || !dst_data)
>  		return 0;
> @@ -460,10 +459,10 @@ static int cm_compare_data(struct ib_cm_compare=
_data *src_data,
>  	return memcmp(src, dst, IB_CM_COMPARE_SIZE);
>  }
> =20
> -static int cm_compare_private_data(u8 *private_data,
> +static int cm_compare_private_data(u32 *private_data,
>  				   struct ib_cm_compare_data *dst_data)
>  {
> -	u8 src[IB_CM_COMPARE_SIZE];
> +	u32 src[IB_CM_COMPARE_SIZE];
> =20
>  	if (!dst_data)
>  		return 0;
> @@ -546,7 +545,7 @@ static struct cm_id_private * cm_find_listen(stru=
ct ib_device *device,
> =20
>  	while (node) {
>  		cm_id_priv =3D rb_entry(node, struct cm_id_private, service_node);
> -		data_cmp =3D cm_compare_private_data(private_data,
> +		data_cmp =3D cm_compare_private_data((u32 *) private_data,
>  						   cm_id_priv->compare_data);
>  		if ((cm_id_priv->id.service_mask & service_id) =3D=3D
>  		     cm_id_priv->id.service_id &&
> diff --git a/include/rdma/ib_cm.h b/include/rdma/ib_cm.h
> index 0e3ff30647d5..0dd576f40c83 100644
> --- a/include/rdma/ib_cm.h
> +++ b/include/rdma/ib_cm.h
> @@ -337,8 +337,8 @@ void ib_destroy_cm_id(struct ib_cm_id *cm_id);
>  #define IB_SDP_SERVICE_ID_MASK	cpu_to_be64(0xFFFFFFFFFFFF0000ULL)
> =20
>  struct ib_cm_compare_data {
> -	u8  data[IB_CM_COMPARE_SIZE];
> -	u8  mask[IB_CM_COMPARE_SIZE];
> +	u32  data[IB_CM_COMPARE_SIZE];
> +	u32  mask[IB_CM_COMPARE_SIZE];
>  };
> =20
>  /**

Anyway, you might want to compile this part of the kernel with
-Wcast-align and ignore the false positive (in particular
every other use of container_of()).

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

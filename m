From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/3] IB/core: Add on demand paging caps to
 ib_uverbs_ex_query_device
Date: Mon, 16 Feb 2015 22:04:54 +0100
Message-ID: <1424120694.32606.22.camel@opteya.com>
References: <1423394932-2965-1-git-send-email-haggaie@mellanox.com>
	 <1423394932-2965-3-git-send-email-haggaie@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1423394932-2965-3-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

Le dimanche 08 f=C3=A9vrier 2015 =C3=A0 13:28 +0200, Haggai Eran a =C3=A9=
crit :
> Add a on-demand capabilities reporting to the extended query device v=
erb.
>=20

"Add on-demand paging (ODP) capabilities [...]"

Perhaps we could also add a mention such the following to get an idea
of the purpose of those flags:
see also commit 860f10a799c8 ("IB/core: Add flags for on demand paging
support")

> Yann Droneaud writes:
> > Note: as offsetof() is used to retrieve the size of the lower chunk
> > of the response, beware that it only works if the upper chunk
> > is right after, without any implicit padding. And, as the size of
> > the latter chunk is added to the base size, implicit padding at the
> > end of the structure is not taken in account. Both point must be
> > taken in account when extending the uverbs functionalities.
>=20
> Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
> Cc: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> Cc: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/infiniband/core/uverbs_cmd.c | 20 +++++++++++++++++++-
>  include/uapi/rdma/ib_user_verbs.h    | 11 +++++++++++
>  2 files changed, 30 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniban=
d/core/uverbs_cmd.c
> index 8f507538c42b..04ca04559ce5 100644
> --- a/drivers/infiniband/core/uverbs_cmd.c
> +++ b/drivers/infiniband/core/uverbs_cmd.c
> @@ -3318,7 +3318,7 @@ int ib_uverbs_ex_query_device(struct ib_uverbs_=
file *file,
>  	if (cmd.reserved)
>  		return -EINVAL;
> =20
> -	resp.response_length =3D sizeof(resp);
> +	resp.response_length =3D offsetof(typeof(resp), odp_caps);
> =20
>  	if (ucore->outlen < resp.response_length)
>  		return -ENOSPC;
> @@ -3330,6 +3330,24 @@ int ib_uverbs_ex_query_device(struct ib_uverbs=
_file *file,
>  	copy_query_dev_fields(file, &resp.base, &attr);
>  	resp.comp_mask =3D 0;
> =20
> +	if (ucore->outlen < resp.response_length + sizeof(resp.odp_caps))
> +		goto end;
> +
> +#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
> +	resp.odp_caps.general_caps =3D attr.odp_caps.general_caps;
> +	resp.odp_caps.per_transport_caps.rc_odp_caps =3D
> +		attr.odp_caps.per_transport_caps.rc_odp_caps;
> +	resp.odp_caps.per_transport_caps.uc_odp_caps =3D
> +		attr.odp_caps.per_transport_caps.uc_odp_caps;
> +	resp.odp_caps.per_transport_caps.ud_odp_caps =3D
> +		attr.odp_caps.per_transport_caps.ud_odp_caps;
> +	resp.odp_caps.reserved =3D 0;
> +#else
> +	memset(&resp.odp_caps, 0, sizeof(resp.odp_caps));
> +#endif
> +	resp.response_length +=3D sizeof(resp.odp_caps);
> +
> +end:
>  	err =3D ib_copy_to_udata(ucore, &resp, resp.response_length);
>  	if (err)
>  		return err;
> diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib=
_user_verbs.h
> index f0f799afd856..b513e662d8e4 100644
> --- a/include/uapi/rdma/ib_user_verbs.h
> +++ b/include/uapi/rdma/ib_user_verbs.h
> @@ -207,10 +207,21 @@ struct ib_uverbs_ex_query_device {
>  	__u32 reserved;
>  };
> =20
> +struct ib_uverbs_odp_caps {
> +	__u64 general_caps;
> +	struct {
> +		__u32 rc_odp_caps;
> +		__u32 uc_odp_caps;
> +		__u32 ud_odp_caps;
> +	} per_transport_caps;
> +	__u32 reserved;
> +};
> +
>  struct ib_uverbs_ex_query_device_resp {
>  	struct ib_uverbs_query_device_resp base;
>  	__u32 comp_mask;
>  	__u32 response_length;
> +	struct ib_uverbs_odp_caps odp_caps;
>  };
> =20
>  struct ib_uverbs_query_port {

Reviewed-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>

Thanks a lot for this updated patch.

Regards.

--=20
Yann Droneaud
OPTEYA


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

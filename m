From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next V2 30/32] IB/rxe: Shared objects between user
 and kernel
Date: Thu, 18 Feb 2016 11:17:43 -0500
Message-ID: <56C5EEA7.8070503@redhat.com>
References: <1450948698-13383-1-git-send-email-kamalh@mellanox.com>
 <1450948698-13383-31-git-send-email-kamalh@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="8RmnFuB8WXhckEiup3L9Ei8Itb99E1PD6"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450948698-13383-31-git-send-email-kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--8RmnFuB8WXhckEiup3L9Ei8Itb99E1PD6
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/24/2015 4:18 AM, Kamal Heib wrote:
> From: Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>=20
> Objects used by the userspace to post work requests.
>=20
> Signed-off-by: Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  include/uapi/rdma/Kbuild   |   1 +
>  include/uapi/rdma/ib_rxe.h | 139 +++++++++++++++++++++++++++++++++++++=
++++++++
>  2 files changed, 140 insertions(+)
>  create mode 100644 include/uapi/rdma/ib_rxe.h
>=20
> diff --git a/include/uapi/rdma/Kbuild b/include/uapi/rdma/Kbuild
> index 231901b..94f9401 100644
> --- a/include/uapi/rdma/Kbuild
> +++ b/include/uapi/rdma/Kbuild
> @@ -6,3 +6,4 @@ header-y +=3D ib_user_verbs.h
>  header-y +=3D rdma_netlink.h
>  header-y +=3D rdma_user_cm.h
>  header-y +=3D hfi/
> +header-y +=3D ib_rxe.h
> diff --git a/include/uapi/rdma/ib_rxe.h b/include/uapi/rdma/ib_rxe.h
> new file mode 100644
> index 0000000..fc1d9ca
> --- /dev/null
> +++ b/include/uapi/rdma/ib_rxe.h
> @@ -0,0 +1,139 @@
> +/*
> + * Copyright (c) 2015 Mellanox Technologies Ltd. All rights reserved.
> + *
> + * This software is available to you under a choice of one of two
> + * licenses.  You may choose to be licensed under the terms of the GNU=

> + * General Public License (GPL) Version 2, available from the file
> + * COPYING in the main directory of this source tree, or the
> + * OpenIB.org BSD license below:
> + *
> + *     Redistribution and use in source and binary forms, with or
> + *     without modification, are permitted provided that the following=

> + *     conditions are met:
> + *
> + *	- Redistributions of source code must retain the above
> + *	  copyright notice, this list of conditions and the following
> + *	  disclaimer.
> + *
> + *	- Redistributions in binary form must reproduce the above
> + *	  copyright notice, this list of conditions and the following
> + *	  disclaimer in the documentation and/or other materials
> + *	  provided with the distribution.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS=

> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> + * SOFTWARE.
> + */
> +
> +#ifndef IB_RXE_H
> +#define IB_RXE_H
> +
> +#include <linux/types.h>
> +
> +union rxe_gid {
> +	__u8	raw[16];
> +	struct {
> +		__be64	subnet_prefix;
> +		__be64	interface_id;
> +	} global;
> +};
> +
> +struct rxe_global_route {
> +	union rxe_gid	dgid;
> +	__u32		flow_label;
> +	__u8		sgid_index;
> +	__u8		hop_limit;
> +	__u8		traffic_class;
> +};
> +
> +struct rxe_av {
> +	__u8			port_num;
> +	__u8			network_type;
> +	struct rxe_global_route	grh;
> +	union {
> +		struct sockaddr		_sockaddr;
> +		struct sockaddr_in	_sockaddr_in;
> +		struct sockaddr_in6	_sockaddr_in6;
> +	} sgid_addr, dgid_addr;
> +};
> +
> +struct rxe_send_wr {
> +	__u64			wr_id;
> +	__u32			num_sge;
> +	__u32			opcode;
> +	__u32			send_flags;
> +	union {
> +		__u32		imm_data;
> +		__u32		invalidate_rkey;
> +	} ex;
> +	union {
> +		struct {
> +			__u64	remote_addr;
> +			__u32	rkey;
> +		} rdma;
> +		struct {
> +			__u64	remote_addr;
> +			__u64	compare_add;
> +			__u64	swap;
> +			__u32	rkey;
> +		} atomic;
> +		struct {
> +			__u32	remote_qpn;
> +			__u32	remote_qkey;
> +			__u16	pkey_index;
> +		} ud;
> +	} wr;
> +};
> +
> +struct rxe_sge {
> +	__u64	addr;
> +	__u32	length;
> +	__u32	lkey;
> +};
> +
> +struct mminfo {
> +	__u64			offset;
> +	__u32			size;
> +	__u32			pad;
> +};

I'm highly leary of using this name for an rxe shared object.  I would
much prefer that this be rxe specific just to avoid the possibility of
future conflicts (I checked, there are no current conflicts, but the
name is still so generic that it could have future issues).

> +
> +struct rxe_dma_info {
> +	__u32			length;
> +	__u32			resid;
> +	__u32			cur_sge;
> +	__u32			num_sge;
> +	__u32			sge_offset;
> +	union {
> +		__u8		inline_data[0];
> +		struct rxe_sge	sge[0];
> +	};
> +};
> +
> +struct rxe_send_wqe {
> +	struct rxe_send_wr	wr;
> +	struct rxe_av		av;
> +	__u32			status;
> +	__u32			state;
> +	__u64			iova;
> +	__u32			mask;
> +	__u32			first_psn;
> +	__u32			last_psn;
> +	__u32			ack_length;
> +	__u32			ssn;
> +	__u32			has_rd_atomic;
> +	struct rxe_dma_info	dma;
> +};
> +
> +struct rxe_recv_wqe {
> +	__u64			wr_id;
> +	__u32			num_sge;
> +	__u32			padding;
> +	struct rxe_dma_info	dma;
> +};
> +
> +#endif /* IB_RXE_H */
>=20



--8RmnFuB8WXhckEiup3L9Ei8Itb99E1PD6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWxe6nAAoJELgmozMOVy/dk5YQAIH5VJh8xAMTpKh158ufWm/z
U6g2frjl6p5egJSCGm/2G/JHpw4et7ey6BeYT2a9jLFrOb1MUII4O5FAgcxP5BMN
aJd+o1hbKUvp5lpqVBduETNUurZ5aLrh0Oo74InS/Cb5bG/8aYTjXQqVk8My933c
o3/g/eRb5y1UTOGAjlrVqN1K9JD2ON9Cr4b1DjTnk6PA/a70PggurX48Pb+CSTN2
YNNyhYsAYf7uKiPMlJRI19UIj0vZzSl12JaJgWz9cCJhendOF033BlIZcblv5E/f
UkK/zckV6Lio3YHtUOcmLHCfWknqlNitIc7Y1TSjqW+X8z81bioeJRnU1sP3GI79
maDGlX1BbzBJujIyGgehYyR5R/ilZXX5C6+aqDMXhc71TUlZWzV+AltpU+Ccq2Zq
ROohXfBjAWnXLQRSxNIZwz8cMZbVwFjO+rcu77a9ltHElEWARIG3mzAQ/vwCGWeS
uXS+qorbpf/x4Xu/3UfRR+yYnhV3m1eI5VMAgndNkC9NZD/BxWLcT0W2w3OKCwEe
NGpPvUxNy04AWNb/nHcC42TtcFPJ3PLz1EAizc0dNk72ndF/TmYVuDZXz4rgRlQW
G3GHJc79M6bEti3HAAgUY4+TJK4eVX/xYdKBdZ+rmZcGJCUB9d6C01YMhCFUw2Sh
GMuE2Nxa+IqKw4xFyRgV
=w/5I
-----END PGP SIGNATURE-----

--8RmnFuB8WXhckEiup3L9Ei8Itb99E1PD6--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

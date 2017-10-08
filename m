From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 01/13] iWARP wire packet format definition
Date: Sun, 8 Oct 2017 15:35:47 +0300
Message-ID: <20171008123547.GT25829@mtr-leonro.local>
References: <20171006122853.16310-1-bmt@zurich.ibm.com>
 <20171006122853.16310-2-bmt@zurich.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="T/yvDUeUQRtJzDrt"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171006122853.16310-2-bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--T/yvDUeUQRtJzDrt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 06, 2017 at 08:28:41AM -0400, Bernard Metzler wrote:
> Signed-off-by: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
> ---
>  drivers/infiniband/sw/siw/iwarp.h | 381 ++++++++++++++++++++++++++++++++++++++
>  1 file changed, 381 insertions(+)
>  create mode 100644 drivers/infiniband/sw/siw/iwarp.h
>
> diff --git a/drivers/infiniband/sw/siw/iwarp.h b/drivers/infiniband/sw/siw/iwarp.h
> new file mode 100644
> index 000000000000..379091e3e09f
> --- /dev/null
> +++ b/drivers/infiniband/sw/siw/iwarp.h
> @@ -0,0 +1,381 @@
> +/*
> + * Software iWARP device driver for Linux
> + *
> + * Authors: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
> + *          Fredy Neeser <nfd-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
> + *
> + * Copyright (c) 2008-2017, IBM Corporation
> + *
> + * This software is available to you under a choice of one of two
> + * licenses. You may choose to be licensed under the terms of the GNU
> + * General Public License (GPL) Version 2, available from the file
> + * COPYING in the main directory of this source tree, or the
> + * BSD license below:
> + *
> + *   Redistribution and use in source and binary forms, with or
> + *   without modification, are permitted provided that the following
> + *   conditions are met:
> + *
> + *   - Redistributions of source code must retain the above copyright notice,
> + *     this list of conditions and the following disclaimer.
> + *
> + *   - Redistributions in binary form must reproduce the above copyright
> + *     notice, this list of conditions and the following disclaimer in the
> + *     documentation and/or other materials provided with the distribution.
> + *
> + *   - Neither the name of IBM nor the names of its contributors may be
> + *     used to endorse or promote products derived from this software without
> + *     specific prior written permission.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> + * SOFTWARE.
> + */
> +
> +#ifndef _IWARP_H
> +#define _IWARP_H
> +
> +#include <rdma/rdma_user_cm.h>	/* RDMA_MAX_PRIVATE_DATA */
> +#include <linux/types.h>
> +#include <asm/byteorder.h>
> +
> +
> +#define RDMAP_VERSION		1
> +#define DDP_VERSION		1
> +#define MPA_REVISION_1		1
> +#define MPA_REVISION_2		2
> +#define MPA_MAX_PRIVDATA	RDMA_MAX_PRIVATE_DATA
> +#define MPA_KEY_REQ		"MPA ID Req Frame"
> +#define MPA_KEY_REP		"MPA ID Rep Frame"
> +#define	MPA_IRD_ORD_MASK	0x3fff
> +
> +struct mpa_rr_params {
> +	__be16	bits;
> +	__be16	pd_len;
> +};
> +
> +/*
> + * MPA request/response Hdr bits & fields
> + */
> +enum {
> +	MPA_RR_FLAG_MARKERS	= __cpu_to_be16(0x8000),
> +	MPA_RR_FLAG_CRC		= __cpu_to_be16(0x4000),
> +	MPA_RR_FLAG_REJECT	= __cpu_to_be16(0x2000),
> +	MPA_RR_FLAG_ENHANCED	= __cpu_to_be16(0x1000),
> +	MPA_RR_RESERVED		= __cpu_to_be16(0x0f00),
> +	MPA_RR_MASK_REVISION	= __cpu_to_be16(0x00ff)
> +};
> +
> +/*
> + * MPA request/reply header
> + */
> +struct mpa_rr {
> +	__u8	key[16];
> +	struct mpa_rr_params params;
> +};
> +
> +
> +static inline void __mpa_rr_set_revision(u16 *bits, u8 rev)
> +{
> +	*bits = (*bits & ~MPA_RR_MASK_REVISION)
> +		| (cpu_to_be16(rev) & MPA_RR_MASK_REVISION);
> +}
> +
> +static inline u8 __mpa_rr_revision(u16 mpa_rr_bits)
> +{
> +	u16 rev = mpa_rr_bits & MPA_RR_MASK_REVISION;
> +
> +	return (u8)be16_to_cpu(rev);

It looks wrong "rev" is u16, while be16_to_cpu expect __be16

> +}
> +
> +enum mpa_v2_ctrl {
> +	MPA_V2_PEER_TO_PEER	= __cpu_to_be16(0x8000),
> +	MPA_V2_ZERO_LENGTH_RTR	= __cpu_to_be16(0x4000),
> +	MPA_V2_RDMA_WRITE_RTR	= __cpu_to_be16(0x8000),
> +	MPA_V2_RDMA_READ_RTR	= __cpu_to_be16(0x4000),
> +	MPA_V2_RDMA_NO_RTR	= __cpu_to_be16(0x0000),
> +	MPA_V2_MASK_IRD_ORD	= __cpu_to_be16(0x3fff)
> +};
> +
> +struct mpa_v2_data {
> +	__be16		ird;
> +	__be16		ord;
> +};
> +
> +struct mpa_marker {
> +	__be16	rsvd;
> +	__be16	fpdu_hmd; /* FPDU header-marker distance (= MPA's FPDUPTR) */
> +};
> +
> +/*
> + * maximum MPA trailer
> + */
> +struct mpa_trailer {
> +	char	pad[4];

char -> u8

> +	__be32	crc;
> +};
> +

--T/yvDUeUQRtJzDrt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnaG6MACgkQ5GN7iDZy
WKdglQ//feC1BEA6wMS4VzUoCLA8d1AqXDIdXP+ATim30+YbiAq8LRJBaxXO93pF
skJytfhy1m+lfEsf2on46nzZJtc7qImd1sx8hitlqp40zPK34xYGfUaDp0RtoLsD
SxJnJUNrgdbL5QVAxv+RY7tHxpWY5sv5vElC2HvbthChV2Xhnlq82FnC1u4Dv+lW
f06axUIHD0WCM/JvnqxAueS9XvRH/+i+AAVkaOp46UrTtzkOFTTn4AWJkAZ2A5pE
SM/1AFdh548IrvT2zy6lZgEC/aofvaXHM6KIE2fYrkCWDh4g9EkQAdLHqZeD1+Gr
+CoiLDEXle3dK1u52YyYk7xD1PTHZLdGEw9a6le2XR69Z/Tm/FMXbDDbSFGY66Zq
P8PJOcTm9m6XIxO890UYsEKH9TPDO9grlJBmHoorSZQEFKIpWrRskhjCtu71OD/y
cqdmOqUU3S4TdCrWwTKl7GiC+v+lpYMw2BrW55AAoWURkeW0o5MAIt+UQiGddfRl
TWNPhg69MkP/adlOFWqAq2XK2E6mXfj6frgAUMTpkrhZTssO0J3MqnXuTx1B+TXs
g9sWnsbNvSh1kCVeil0BvZULxnrpqI8YEIkQAyuAIcHXsZhYnI99sctWwr7we/4A
N3gCHMzIsYB/KeW+l0jTmlD5dLaZvDJTRs7X7rMlnGPyARDEjsg=
=H+1e
-----END PGP SIGNATURE-----

--T/yvDUeUQRtJzDrt--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

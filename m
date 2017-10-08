From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 04/13] SoftiWarp object management
Date: Sun, 8 Oct 2017 15:28:40 +0300
Message-ID: <20171008122839.GS25829@mtr-leonro.local>
References: <20171006122853.16310-1-bmt@zurich.ibm.com>
 <20171006122853.16310-5-bmt@zurich.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="bAwSoJxbKYwy34Oe"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171006122853.16310-5-bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--bAwSoJxbKYwy34Oe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 06, 2017 at 08:28:44AM -0400, Bernard Metzler wrote:
> Signed-off-by: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
> ---
>  drivers/infiniband/sw/siw/siw_obj.c | 428 ++++++++++++++++++++++++++++++++++++
>  drivers/infiniband/sw/siw/siw_obj.h | 113 ++++++++++
>  2 files changed, 541 insertions(+)
>  create mode 100644 drivers/infiniband/sw/siw/siw_obj.c
>  create mode 100644 drivers/infiniband/sw/siw/siw_obj.h
>
> diff --git a/drivers/infiniband/sw/siw/siw_obj.c b/drivers/infiniband/sw/siw/siw_obj.c
> new file mode 100644
> index 000000000000..a6d28773e09d
> --- /dev/null
> +++ b/drivers/infiniband/sw/siw/siw_obj.c
> @@ -0,0 +1,428 @@
> +/*
> + * Software iWARP device driver for Linux

No need to add "Linux" for the Linux Driver code in the Linux Kernel.

> + *
> + * Authors: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
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
> +#include <linux/spinlock.h>
> +#include <linux/kref.h>
> +#include <linux/vmalloc.h>
> +
> +#include "siw.h"
> +#include "siw_obj.h"
> +#include "siw_cm.h"
> +
> +
> +void siw_objhdr_init(struct siw_objhdr *hdr)
> +{
> +	kref_init(&hdr->ref);
> +}
> +
> +void siw_idr_init(struct siw_dev *sdev)
> +{
> +	spin_lock_init(&sdev->idr_lock);
> +
> +	idr_init(&sdev->qp_idr);
> +	idr_init(&sdev->cq_idr);
> +	idr_init(&sdev->pd_idr);
> +	idr_init(&sdev->mem_idr);
> +}
> +
> +void siw_idr_release(struct siw_dev *sdev)
> +{
> +	idr_destroy(&sdev->qp_idr);
> +	idr_destroy(&sdev->cq_idr);
> +	idr_destroy(&sdev->pd_idr);
> +	idr_destroy(&sdev->mem_idr);
> +}

Why do you need need idr_* calls and why can't IB/core idr_* management
be enough? I didn't review the various *_obj functions.

> +
> +static inline int siw_add_obj(spinlock_t *lock, struct idr *idr,
> +			      struct siw_objhdr *obj)

Please don't add inline functions in C files.

> +{
> +	unsigned long flags;
> +	int id, pre_id;
> +
> +	do {
> +		get_random_bytes(&pre_id, sizeof(pre_id));
> +		pre_id &= 0xffffff;
> +	} while (pre_id == 0);
> +again:
> +	spin_lock_irqsave(lock, flags);
> +	id = idr_alloc(idr, obj, pre_id, 0xffffff - 1, GFP_KERNEL);
> +	spin_unlock_irqrestore(lock, flags);
> +
> +	if (id > 0) {
> +		siw_objhdr_init(obj);
> +		obj->id = id;
> +		dprint(DBG_OBJ, "(OBJ%d): IDR New Object\n", id);

Please don't reinvent pr_debug infrastructure. There is no need in
custom dprint(..) logic.

> +	} else if (id == -ENOSPC && pre_id != 1) {
> +		pre_id = 1;
> +		goto again;
> +	} else {
> +		BUG_ON(id == 0);

No BUG_ON in new code.

> +		dprint(DBG_OBJ|DBG_ON, "(OBJ??): IDR New Object failed!\n");
> +	}
> +	return id > 0 ? 0 : id;
> +}
> +

--bAwSoJxbKYwy34Oe
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIyBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnaGfcACgkQ5GN7iDZy
WKcPJA/0CsIovhtHQ7wpYMZmWL1qS+m3UVzo5ilusy3xrkLj0YqG3piFAJ2qCh26
QG1tZZpMCT1DJLb/yJdcvVXA2m0h+mZqbmjrXoPm7XPqqMy1GgkdtyPc+jAppGXN
8ojHPzn0rjuJSOGLerbzy1Y7csZH58hx38r3ol4u0bg1VI4otmMDBiN3hGyTF3Kj
1q5ZBrKaJLCRH/eiekfjwnsqX6+HH1cNQ9kFLP5FqZkWEZSW3JN8ZZUwg06dtHwV
OOFYN9Z24Ynz77Glt//GbBO+gjdK0NSKTf3tWqQnPvxwpi+8Jd7F6Gh1MjnoUQc3
KRZPXh7BFLvCi2tmDYhQETLM0Xv91y7ke9WNDPmqSXDHLWA53rZ4296DjUDVeU2v
N7kB9mrTGQvhJIzS5tRAazLK87OMwYW39RwVVf3koym/KTV9+as2nxvral/nQc/C
CN3RC6YT3+P6c+Fh6hfGJg0ILFRxm8L1n+8lr05OdVTQlq3fIRVs9Mpx9xP/d4fW
Ek00MMGD5XrfMnahGXuOURQ3QvYVfk7d1C1awjCzZ4vew7eT2golmFxyjjDNd4EW
2bAyzhiX8MD3Hpd4gGGHEMLe5vtoOxgOhAnXrLZ2LW3iQZs41/wZy+qvB+pBnfW5
IkHFzFyHcomk4C13dUTRJ6jIRzU5AKVK6V0WCZiMqucHDZr1dQ==
=ptJu
-----END PGP SIGNATURE-----

--bAwSoJxbKYwy34Oe--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

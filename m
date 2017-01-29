From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core 11/11] libbnxtre: Add versioning support
Date: Sun, 29 Jan 2017 09:17:28 +0200
Message-ID: <20170129071728.GC6005@mtr-leonro.local>
References: <1485641622-30015-1-git-send-email-devesh.sharma@broadcom.com>
 <1485641622-30015-12-git-send-email-devesh.sharma@broadcom.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="j+Rb494BzBd9643b"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1485641622-30015-12-git-send-email-devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sriharsha Basavapatna <sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--j+Rb494BzBd9643b
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jan 28, 2017 at 05:13:42PM -0500, Devesh Sharma wrote:
> This patch adds a new header file to maintain
> the version of library code. Each time a new
> patch series is applied, this file would be
> updated.

No way, please preserve compatibility between different versions.

> Currently, the macros declared in this
> header are not referred anywhere in the code. however,
> those can be used during RPM file generation.
>
> Signed-off-by: Sriharsha Basavapatna <sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> ---
>  providers/bnxtre/version.h | 53 ++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 53 insertions(+)
>  create mode 100644 providers/bnxtre/version.h

Any reason why should your driver have different ABI compatibility and
RPM generation scheme?

>
> diff --git a/providers/bnxtre/version.h b/providers/bnxtre/version.h
> new file mode 100644
> index 0000000..415ef41
> --- /dev/null
> +++ b/providers/bnxtre/version.h
> @@ -0,0 +1,53 @@
> +/*
> + * Broadcom NetXtreme-E User Space RoCE driver
> + *
> + * Copyright (c) 2015-2016, Broadcom. All rights reserved.  The term
> + * Broadcom refers to Broadcom Limited and/or its subsidiaries.
> + *
> + * This software is available to you under a choice of one of two
> + * licenses.  You may choose to be licensed under the terms of the GNU
> + * General Public License (GPL) Version 2, available from the file
> + * COPYING in the main directory of this source tree, or the
> + * BSD license below:
> + *
> + * Redistribution and use in source and binary forms, with or without
> + * modification, are permitted provided that the following conditions
> + * are met:
> + *
> + * 1. Redistributions of source code must retain the above copyright
> + *    notice, this list of conditions and the following disclaimer.
> + * 2. Redistributions in binary form must reproduce the above copyright
> + *    notice, this list of conditions and the following disclaimer in
> + *    the documentation and/or other materials provided with the
> + *    distribution.
> + *
> + * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS''
> + * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
> + * THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
> + * PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS
> + * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
> + * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
> + * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
> + * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
> + * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
> + * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
> + * IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
> + *
> + * Description: current release version information
> + */
> +
> +#ifndef __BNXT_RE_VERSION_H__
> +#define __BNXT_RE_VERSION_H__
> +
> +#define	MAJOR_VERSION		"1"
> +#define	MINOR_VERSION		"0"
> +#define	SUB_MINOR_VERSION	"0"
> +
> +#define	LIBBNXT_RE_VERSION(a, b, c)	a"."b"."c
> +
> +#define LIBBNXT_RE_REL_VERSION	LIBBNXT_RE_VERSION(MAJOR_VERSION,\
> +						   MINOR_VERSION,\
> +						   SUB_MINOR_VERSION)
> +#define LIBBNXT_RE_BUILD_VERSION	1.0.0
> +
> +#endif	/* __BNXT_RE_VERSION_H__ */
> --
> 1.8.3.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--j+Rb494BzBd9643b
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAliNlwgACgkQ5GN7iDZy
WKe7lRAAkc0yUJvC5whSahnc3HPNqCU/ZT04lIQEGShrt7G4UHa0T3B+LzSLUbZ3
Q4wPNPtekMND8R0864WkiGwUUZtIQLE1Jg3eRsSKmymbORCcKPD8tFsCbmNd1BR9
rI1HNGhCsX19dbOyCZt13MBpuhILkwNK0nQZ7HI1W9Cndx4LvTqGgG92rJ+eSon1
sM0re10l2Zh0MzSVBTWI0pczH9+vSiY54LTLRsly/HckyAGWn6spChpgm0zZhtRc
Vu2g9DlSYbUfYOwEiR6858kh5oZhoiw4pa4GRB59LLetiMW5k9UsWn90qEa01upz
tDh18vgAbfgw4LoRO90ty6BS8usQm/I644UASwsh8A1Vx9EFZqPxmo1n8j6jEtB+
wO9lEvB9Em3HHyYDUInb84QQN5QlYy6VePGpVzNxhgdQX55iIEmUDt7AdkwYqqON
ZFRU9d28QOwbf6uANDjrikcq+NcwRbxTjWdiHyvk0Klbg7e05IOpep70HTv+edjc
r1sX7kWYTR+wspEqtAlQMwagUW9yLC6BZSccSv+xMdYLhnp9prStxeo040PrlrmP
E8X8UwEtrp/1AHpKf+fXeDV9BswV3Xru9SPXthc2C5kwGNB479gTE7uU5zAY6Jjo
qj9b1A4OTClcU1lrRlDDUpK6K79zNR56rRZX7iUUtsS9HrRmuJU=
=5iOp
-----END PGP SIGNATURE-----

--j+Rb494BzBd9643b--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

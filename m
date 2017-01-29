From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core 01/11] libbnxtre: introduce bnxtre user space
 RDMA provider
Date: Sun, 29 Jan 2017 09:25:15 +0200
Message-ID: <20170129072515.GD6005@mtr-leonro.local>
References: <1485641622-30015-1-git-send-email-devesh.sharma@broadcom.com>
 <1485641622-30015-2-git-send-email-devesh.sharma@broadcom.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="obAtV4On+KRLREo5"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1485641622-30015-2-git-send-email-devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sriharsha Basavapatna <sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--obAtV4On+KRLREo5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jan 28, 2017 at 05:13:32PM -0500, Devesh Sharma wrote:
> libnxtre is a user-space driver which provides RDMA
> capability to user applications. The current framework
> has following parts working:
>
>  -Basic Cmake framework to build and install the library.
>  -Register and unregister user-space driver with uverbs
>   interface.
>  -List all available bnxt_re devices using "ibv_devinfo"
>   admin command.
>  -List all the device and port attributes using
>   "ibv_devinfo" admin command.
>  -Support allocate/free of protection domains.
>  -Check ABI version between library and kernel module.
>  -Update MAINTAINERS file
>
> Signed-off-by: Sriharsha Basavapatna <sriharsha.basavapatna-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> ---
>  CMakeLists.txt                  |   1 +
>  MAINTAINERS                     |   5 +
>  providers/bnxtre/CMakeLists.txt |   4 +
>  providers/bnxtre/abi.h          |  59 ++++++++++
>  providers/bnxtre/bnxtre.driver  |   1 +
>  providers/bnxtre/main.c         | 192 +++++++++++++++++++++++++++++++
>  providers/bnxtre/main.h         | 108 ++++++++++++++++++
>  providers/bnxtre/verbs.c        | 247 ++++++++++++++++++++++++++++++++++++++++
>  providers/bnxtre/verbs.h        | 106 +++++++++++++++++
>  9 files changed, 723 insertions(+)
>  create mode 100644 providers/bnxtre/CMakeLists.txt
>  create mode 100644 providers/bnxtre/abi.h
>  create mode 100644 providers/bnxtre/bnxtre.driver
>  create mode 100644 providers/bnxtre/main.c
>  create mode 100644 providers/bnxtre/main.h
>  create mode 100644 providers/bnxtre/verbs.c
>  create mode 100644 providers/bnxtre/verbs.h
>
> diff --git a/CMakeLists.txt b/CMakeLists.txt
> index 8f7a475..b6f96c0 100644
> --- a/CMakeLists.txt
> +++ b/CMakeLists.txt
> @@ -382,6 +382,7 @@ add_subdirectory(providers/nes)
>  add_subdirectory(providers/ocrdma)
>  add_subdirectory(providers/qedr)
>  add_subdirectory(providers/vmw_pvrdma)
> +add_subdirectory(providers/bnxtre)
>  endif()
>
>  add_subdirectory(providers/hfi1verbs)
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 2ae504c..f52da1c 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -166,3 +166,8 @@ M:	Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
>  L:	pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
>  S:	Supported
>  F:	providers/vmw_pvrdma/
> +
> +BNXTRE USERSPACE PROVIDER (for bnxtre.ko)
> +M:	Devesh Sharma  <Devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> +S:	Supported
> +F:	providers/bnxtre

It should have "/" at the end of line.

> diff --git a/providers/bnxtre/CMakeLists.txt b/providers/bnxtre/CMakeLists.txt
> new file mode 100644
> index 0000000..4c61355
> --- /dev/null
> +++ b/providers/bnxtre/CMakeLists.txt
> @@ -0,0 +1,4 @@
> +rdma_provider(bnxtre
> +	main.c
> +	verbs.c
> +)
> diff --git a/providers/bnxtre/abi.h b/providers/bnxtre/abi.h
> new file mode 100644
> index 0000000..653ac71
> --- /dev/null
> +++ b/providers/bnxtre/abi.h
> @@ -0,0 +1,59 @@
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
> + * Description: ABI data structure definition
> + */
> +
> +#ifndef __BNXT_RE_ABI_H__
> +#define __BNXT_RE_ABI_H__
> +
> +#include <infiniband/kern-abi.h>
> +
> +#define BNXT_RE_ABI_VERSION 1
> +
> +struct bnxt_re_cntx_resp {
> +	struct ibv_get_context_resp resp;
> +	__u32 dev_id;
> +	__u32 max_qp; /* To allocate qp-table */
> +};
> +
> +struct bnxt_re_pd_resp {
> +	struct ibv_alloc_pd_resp resp;
> +	__u32 pdid;
> +	__u32 dpi;
> +	__u64 dbr;
> +};
> +
> +#endif
> diff --git a/providers/bnxtre/bnxtre.driver b/providers/bnxtre/bnxtre.driver
> new file mode 100644
> index 0000000..5ce796f
> --- /dev/null
> +++ b/providers/bnxtre/bnxtre.driver
> @@ -0,0 +1 @@
> +driver	bnxtre
> diff --git a/providers/bnxtre/main.c b/providers/bnxtre/main.c
> new file mode 100644
> index 0000000..0c26c8b
> --- /dev/null
> +++ b/providers/bnxtre/main.c
> @@ -0,0 +1,192 @@
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
> + * Description: Device detection and initializatoin
> + */
> +
> +#if HAVE_CONFIG_H
> +#include <config.h>
> +#endif                          /* HAVE_CONFIG_H */
> +

There is no need to guard config.h

> +#include <stdio.h>

--obAtV4On+KRLREo5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAliNmNoACgkQ5GN7iDZy
WKeithAAvN54h/8UtzwNFBcexMDZ8FnnuWm/Ex/M4wzlD0EJY6aPptw11tQ+euGM
LHt0DvWEd7+St2TLRoJjqQ4bgudsWZ3mOUQcmFcZeYYXbQSf4jI/JVGzSqxpAvpc
K58pT6zceGoJyPI1uIFPOZrHT26N35aLQROtDiosCrSnHgtkWDOFEjhWW1V+458W
yoeKwbyC1i5CfxlNi9EIa2cp2gyzDIdjUdvL4VtrhXV7dotH5EA00t9spzs/k/QG
D4C/zJVINDIlMS9D1AV0x42Q6vV8WT86wKs1XKI0LvLvX/8sjg88C0AxcVmYc3Mv
SzsgCnwBeZRO8aOIhixJ8ZBD1P1z73RD+WNAsENrdio69BU+YOHOzkJTBF38XCkj
7zmh/rR0WtrBM3IGzCD1IqwE6VJkMpnBMHuXXmsa6gEba7q6d1WIgmzCMj+xTskV
AxsDL7z0BkM9lH6mDXL6LfflrFbm8W519fjvdjkub232L+EOk8dVdK/oepaIjQP/
vR2j4kZV/QQcFYqROtsqhpyxLVIs6Gj78T7qy/7D6+Fh3cGLlFN7cTmxQvBFgEXC
yDRBt0fLlokxFFG0Q35NzELBqd8xYrSUf8+dldWOYcm3alBus2zkutY51kNwqAy8
ElcbzGr4ZcAPPVDGHWQ2OIvhhs4r47DtZlIGw4UilCG1TNcaO2U=
=zrgc
-----END PGP SIGNATURE-----

--obAtV4On+KRLREo5--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

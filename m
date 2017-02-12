From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core 10/10] verbs: Add a compatibility arch.h
Date: Sun, 12 Feb 2017 11:05:31 +0200
Message-ID: <20170212090531.GC14015@mtr-leonro.local>
References: <1486677212-3188-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1486677212-3188-11-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="0vzXIDBeUiKkjNJl"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1486677212-3188-11-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--0vzXIDBeUiKkjNJl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 09, 2017 at 02:53:32PM -0700, Jason Gunthorpe wrote:
> There is a bit of software out there that includes arch.h to get the
> swap macros. Continue to provider a header that serves that purpose
> but emit warnings when it is used.
>
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> ---
>  libibverbs/CMakeLists.txt |  1 +
>  libibverbs/arch.h         | 51 +++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 52 insertions(+)
>  create mode 100644 libibverbs/arch.h
>
> diff --git a/libibverbs/CMakeLists.txt b/libibverbs/CMakeLists.txt
> index 7e18a1e3e71d5e..7a52eddc810911 100644
> --- a/libibverbs/CMakeLists.txt
> +++ b/libibverbs/CMakeLists.txt
> @@ -1,4 +1,5 @@
>  publish_headers(infiniband
> +  arch.h
>    kern-abi.h
>    opcode.h
>    sa-kern-abi.h
> diff --git a/libibverbs/arch.h b/libibverbs/arch.h
> new file mode 100644
> index 00000000000000..bcbece8f2c521c
> --- /dev/null
> +++ b/libibverbs/arch.h
> @@ -0,0 +1,51 @@
> +/*
> + * This software is available to you under a choice of one of two
> + * licenses.  You may choose to be licensed under the terms of the GNU
> + * General Public License (GPL) Version 2, available from the file
> + * COPYING in the main directory of this source tree, or the
> + * OpenIB.org BSD license below:
> + *
> + *     Redistribution and use in source and binary forms, with or
> + *     without modification, are permitted provided that the following
> + *     conditions are met:
> + *
> + *      - Redistributions of source code must retain the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer.
> + *
> + *      - Redistributions in binary form must reproduce the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer in the documentation and/or other materials
> + *        provided with the distribution.
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
> +#ifndef INFINIBAND_ARCH_H
> +#define INFINIBAND_ARCH_H
> +
> +#include <stdint.h>
> +#include <endian.h>
> +
> +#warning "This header is obsolete."
> +
> +#ifndef ntohll
> +#undef htonll
> +#undef ntohll
> +/* Users should use the glibc functions directly, not these wrappers */
> +static inline __attribute__((deprecated)) uint64_t htonll(uint64_t x) { return htobe64(x); }
> +static inline __attribute__((deprecated)) uint64_t ntohll(uint64_t x) { return be64toh(x); }
> +#define htonll htonll
> +#define ntohll ntohll
> +#endif
> +
> +/* Barrier macros are no longer provided by libibverbs */
> +
> +#endif /* INFINIBAND_ARCH_H */

Is it possible to drop this file anyway?

> --
> 2.7.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--0vzXIDBeUiKkjNJl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAligJVsACgkQ5GN7iDZy
WKdPHg//X2H1vUUMXkChV6SuyAccVG7RZVXhfoWtTtxUJD5yEwuAyJFFEiSvizcE
/jph4Ex+bRank1K51Uu8JLEwZ4PoCyBeNI8RSAQeJRFPJ27PxTzuc18jj1c/tXu7
FFJ6jiSAqzOe5s9G+/TyROE8H3UL9PJOuh2KlEyBPqwjFY8ufmVMi6DxRDWjjitI
eIfekGKdwpf51KhN9AcNdmnjnuJAa7wEJAJxPHzrKFubSynqWERDFqbYu1GSPdim
ZF3ieW0+45yMlDF8k5QsQSdyOb2VFRUYML59q/oAcEpcRDd2evosG0FwaujmizLI
7XSDZHkJe/dpIyJfCQ4OxIdbdm/Pp2BU0o1BhwcCcFiofv5sSTbzcw6w/EEf1Qvk
dZUyoC5llHnJzeUwxnFoDbnz3g95M8Uu+R1VebLLvbRO9VerOatwui4c+CygDGFc
zzJoPkqa1bTiqALsPd7vdNLmm7gpfQoLxqdcmaRBM/dH3p5VHyvNoYa69Fs/MspV
/8TlABzReqpvatO30ur1X9mXtUTxzfA3errntwLisgDxDQ/WOTQT9dRyNUhkBsUy
LHDY/Xnfk5LnDJaRJftPwFiQcqPYGyrJf+HMuDyLHhpkq47T6120aznDJzqdbfG4
4vNX2z3ePGfaFvz+q7B1STFbhFzhciOLupATrmUqKYAmqNyU50s=
=6ETX
-----END PGP SIGNATURE-----

--0vzXIDBeUiKkjNJl--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794835742;
	b=pLzrIWvAlLzhMQDVcZDP8zqQqpZBb6jRzJZgqJainAzzTMKXxyOWV5WtkcUM3ZExM5/r
	 +xZoHV1ehFwWFhfsZhq8LtR9Rxiz32Gg8Weh9M6Yu9QrS6UWN/6j7nNz+eqTdALkoZ9CJ
	 O1pHnWZZQuHLFld9pwsx+8FbsmybX7HAWF375CeJatxmE6AdF5SkBAOK/omVzCcxM1nxt
	 2jqQkrfEmXd2IOiqJ1WxBnFjFV+Ggamsp/+bqd88fniiEDVV1PoDMHcvDxzCl8XJa4XHN
	 jhJaMZixrWCLgZl1hj9S3eirJGunznHzypFfBmCAfSC4EU4YxgxvGTYFWnrMIT6tLjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794835742;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=Icf+Ukx+/xB0xI3CpkNEA6yudDXzNQ5Xv0JjHMfWwc8=;
	b=XIl8BY903HZJ/NUmAntZEHFEEBe8Dgp1mVchYEUVSws82+CA86yRwS5aESDMwgOa7/Hc
	 m2fMSLu8GsNO/FDHOe9jbMh963Ye0+2dB6kIMSPkU7gvnl7TWGfMrHf2+nxkKNZV4+Mw5
	 glDSLbcPZSdimGBGnZCu/x56wAjdSmba6XqO6O2OiPjNi5yifY2f8YhfQ1PW4J5IWLfk0
	 j1xyQwU+OWYo3BD7iNSohrwUQMOn6eCjI/BTYjCf4BaiGTehXFuQeDOq+HzlLBpaNuy+3
	 q0Rk/bcCvxUG3l7g4X26cLtUqJMn5pg+E83lioZuLcsF7Zke+uNwDhkSHGTRyVQh+6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FplBRcrr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 740E1606A32A
	for <linux-rdma@vger.kernel.org>; Mon, 16 Nov 2026 13:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FplBRcrr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78CED1F000C4;
	Mon, 16 Nov 2026 13:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794835742;
	bh=Icf+Ukx+/xB0xI3CpkNEA6yudDXzNQ5Xv0JjHMfWwc8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FplBRcrrDF8t2A2LDHF71j9e+CpPFB9rvnYU8y9QsiyQt/RofTU8JXNhhkmdzQXKB
	 Wl3LXESAglmR1UiuASnZtcCZEuwNxLBg/MLe26BN8SZgVb+mDaYGjtAb9dcehGrzd2
	 X4kJAjB/gA7uOQSFQ8XpsseVKNL+8dHtHhXDr7sv7kI9GepdvFO3mxdQUHyQuw6xYS
	 PZjAwWqBN1O59/HsX3jhYUF3B1j8tQuhOHKeAyjQYk2UHI3sRfCpg7iEi3CAd3dmRT
	 yd6kmEXkOj3yodjt5Z5tyWcr4AHujf9VHVWcGjfolKR63QxKEps+jh2FASv8uIEkwQ
	 GjqVmpOGcGp4A==
Date: Mon, 16 Nov 2026 15:28:58 +0200
From: Leon Romanovsky <leon@kernel.org>
To: "david.lenrow@illumio.com" <david.lenrow@illumio.com>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	"yishaih@nvidia.com" <yishaih@nvidia.com>,
	"jgg@nvidia.com" <jgg@nvidia.com>
Subject: Re: [RFC PATCH] libibverbs: add authorization plugin hook for QP
 creation
Message-ID: <20261116132858.GN11319@unreal>
References: <DS0PR06MB111280BF26C8E962CC252A0669F7E2@DS0PR06MB11128.namprd06.prod.outlook.com>
 <DS0PR06MB11128BECCB1916D97FFC8372D9F7D2@DS0PR06MB11128.namprd06.prod.outlook.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DS0PR06MB11128BECCB1916D97FFC8372D9F7D2@DS0PR06MB11128.namprd06.prod.outlook.com>

On Sun, Nov 15, 2026 at 03:38:54PM +0000, david.lenrow@illumio.com wrote:
> Hi,
> 
> I'd like to propose adding an optional authorization hook to
> ibv_create_qp in libibverbs.
> 
> ibv_create_qp dispatches directly to the provider with no
> interposition point.  Other parts of the stack have grown
> optional policy hooks over time, but QP creation — the point
> at which a process gains the ability to issue RDMA operations —
> has none.
> 
> Multi-tenant clusters and shared-fabric deployments increasingly
> need a way to enforce workload identity or access policy at QP
> creation time.  Today the only options are kernel-level hooks
> (eBPF, LSM) or LD_PRELOAD interposition, both of which have
> deployment and portability costs that a simple in-library plugin
> point would avoid.

1. Your email didn't reach the mailing list; you may have sent it as HTML.
2. There must be a very good reason to duplicate existing functionality in
   libibverbs. Deployment and portability costs aren't it.

Thanks


> 
> Proposed change:
> 
> A new environment variable IBV_AUTH_PLUGIN.  When set to a
> shared library path, libibverbs dlopen's it once (via
> pthread_once) and calls its exported symbol before every
> ibv_create_qp dispatch:
> 
>     int ibv_auth_check_qp_create(struct ibv_pd *pd,
>                                  struct ibv_qp_init_attr *attr);
> 
> Returns 0 to allow, non-zero to deny (ibv_create_qp returns
> NULL with errno = EPERM).
> 
> When IBV_AUTH_PLUGIN is unset, the overhead is one pthread_once
> (a memory barrier after the first call) and one NULL pointer
> check.  No new exported symbols, no ABI change, no functional
> change for existing users.
> 
> I chose a plugin over a built-in policy because the right
> policy varies by deployment — cgroup-based identity on
> Kubernetes, namespace checks on shared clusters, site-specific
> allowlists on bare metal.  libibverbs should not embed any of
> these; it just needs the hook.
> 
> I've tested this on SoftRoCE with a plugin that checks the
> calling process's cgroup ID against an allowlist.  Five test
> cases pass: no plugin (baseline), allowed, denied, empty
> allowlist, and invalid plugin path (graceful fallthrough).
> 
> The patch is below.  I'll open a GitHub PR once I have feedback
> on the approach.
> 
> Questions for maintainers:
> 
>   1. Is an env-var-triggered dlopen plugin acceptable, or would
>      you prefer a different configuration mechanism (e.g., a
>      config file in /etc/libibverbs.d/)?
> 
>   2. Should this also cover ibv_create_qp_ex?  The same pattern
>      applies; I kept the initial patch minimal.
> 
>   3. Any concerns about the dlopen happening inside pthread_once
>      on the ibv_create_qp path?  It runs exactly once, but it
>      is on the first call.
> 
> Thanks,
> Dave Lenrow
> Illumio
> 
> ---
> 
>  libibverbs/verbs.c | 57 +++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 56 insertions(+), 1 deletion(-)
> 
> diff --git a/libibverbs/verbs.c b/libibverbs/verbs.c
> index 1959fcf..7390605 100644
> --- a/libibverbs/verbs.c
> +++ b/libibverbs/verbs.c
> @@ -54,6 +54,8 @@
>  #include <net/if.h>
>  #include <net/if_arp.h>
>  #include "neigh.h"
> +#include <dlfcn.h>
> +#include <pthread.h>
> 
>  #undef ibv_query_port
> 
> @@ -916,12 +918,65 @@ LATEST_SYMVER_FUNC(ibv_destroy_srq, 1_1, "IBVERBS_1.1",
>       return get_ops(srq->context)->destroy_srq(srq);
>  }
> 
> +/*
> + * Optional authorization plugin for QP creation.
> + *
> + * When IBV_AUTH_PLUGIN names a shared library, it is dlopen'd once and
> + * its ibv_auth_check_qp_create() symbol is called before every
> + * ibv_create_qp().  Returns 0 to allow, negative errno to deny.
> + *
> + * When the variable is unset, the overhead is a pthread_once and a
> + * NULL check per ibv_create_qp call.
> + */
> +typedef int (*ibv_auth_check_fn)(struct ibv_pd *pd,
> +                        struct ibv_qp_init_attr *attr);
> +
> +static ibv_auth_check_fn auth_check;
> +static pthread_once_t auth_once = PTHREAD_ONCE_INIT;
> +
> +static void auth_init(void)
> +{
> +     const char *plugin_path;
> +     void *handle;
> +
> +     plugin_path = getenv("IBV_AUTH_PLUGIN");
> +     if (!plugin_path || !*plugin_path)
> +           return;
> +
> +     handle = dlopen(plugin_path, RTLD_NOW | RTLD_LOCAL);
> +     if (!handle) {
> +           fprintf(stderr, "IBV_AUTH_PLUGIN: cannot load %s: %s\n",
> +                 plugin_path, dlerror());
> +           return;
> +     }
> +
> +     auth_check = (ibv_auth_check_fn)dlsym(handle,
> +                                    "ibv_auth_check_qp_create");
> +     if (!auth_check)
> +           fprintf(stderr, "IBV_AUTH_PLUGIN: %s missing "
> +                 "ibv_auth_check_qp_create symbol\n",
> +                 plugin_path);
> +}
> +
>  LATEST_SYMVER_FUNC(ibv_create_qp, 1_1, "IBVERBS_1.1",
>                struct ibv_qp *,
>                struct ibv_pd *pd,
>                struct ibv_qp_init_attr *qp_init_attr)
>  {
> -     struct ibv_qp *qp = get_ops(pd->context)->create_qp(pd, qp_init_attr);
> +     struct ibv_qp *qp;
> +
> +     pthread_once(&auth_once, auth_init);
> +
> +     if (auth_check) {
> +           int rc = auth_check(pd, qp_init_attr);
> +
> +           if (rc) {
> +                 errno = EPERM;
> +                 return NULL;
> +           }
> +     }
> +
> +     qp = get_ops(pd->context)->create_qp(pd, qp_init_attr);
> 
>       return qp;
>  }
> --
> 2.43.0
> 

From: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCHv7 4/9] ib_core: RoCEE CMA device binding
Date: Thu, 07 Jan 2010 16:02:31 +0200
Message-ID: <4B45E977.70805@Voltaire.com>
References: <20100105103257.GF31480@mtls03>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100105103257.GF31480@mtls03>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Eli Cohen wrote:
> +static int cma_resolve_rocee_route(struct rdma_id_private *id_priv)
[...]
> +	route->path_rec->hop_limit = 2;

why? does this value has any specific meaning?

> +	route->path_rec->mtu_selector = 2;

all the xxx_selector usages in this code should be 
transformed to be from the ib_sa.h selector enum.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

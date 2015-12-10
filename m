From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 04/37] IB/rdmavt: Add ib core device attributes to rvt
 driver params list
Date: Thu, 10 Dec 2015 14:29:18 +0200
Message-ID: <5669701E.7090302@mellanox.com>
References: <20151207204046.8144.18752.stgit@phlsvslse11.ph.intel.com>
 <20151207204314.8144.46170.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151207204314.8144.46170.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 07/12/2015 22:43, Dennis Dalessandro wrote:
>  struct rvt_dev_info {
> +	/*
> +	 * Prior to calling for registration the driver will be responsible for
> +	 * allocating space for this structure. The driver will also need to
> +	 * allocate space for any private device or per port data structures.
> +	 * Alternatively rvt could do this allocation and the registration API
> +	 * would then change to accept an "extra" piece to allocate.
I don't think you need rvt to allocate the private data, but even if you
decide to do that, there's no need for a comment that describes all the
alternative designs here.

> +	 *
> +	 * The driver will also be
> +	 * responsible for filling in certain members of dparms.props
> +	 */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 04/37] IB/rdmavt: Add ib core device attributes to rvt
 driver params list
Date: Thu, 10 Dec 2015 14:26:11 +0200
Message-ID: <56696F63.90707@mellanox.com>
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
> +	/*
> +	 * Drivers will need to support a number of notifications to rvt in
> +	 * accordance with certain events. This structure should contain a mask
> +	 * of the supported events. Such events that the rvt may need to know
> +	 * about include:
> +	 * port errors
> +	 * port active
> +	 * lid change
> +	 * sm change
> +	 * client reregister
> +	 * pkey change
Where are the event values defined?

> +	 *
> +	 * There may also be other events that the rvt layers needs to know
> +	 * about this is not an exhaustive list. Some events though rvt does not
> +	 * need to rely on the driver for such as completion queue error.
> +	 */
> +	 int rvt_signal_supported;

What will rvt do if it learns that the device doesn't support some of
the events?

Haggai
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

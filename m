From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 08/10] i40iw: Control debug error prints using
 env variable
Date: Thu, 8 Dec 2016 11:22:25 -0700
Message-ID: <20161208182225.GA32232@obsidianresearch.com>
References: <1481221001-1044-1-git-send-email-tatyana.e.nikolova@intel.com>
 <1481221001-1044-9-git-send-email-tatyana.e.nikolova@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1481221001-1044-9-git-send-email-tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 08, 2016 at 12:16:39PM -0600, Tatyana Nikolova wrote:

> +extern unsigned int i40iw_dbg;
> +#define i40iw_debug(fmt, args...) \
> +	if (i40iw_dbg) \
> +		fprintf(stderr, PFX "%s: " fmt, __FUNCTION__, ##args)
> +

No, this is an unsafe way to use defines, wrap it in do / while (0)

I would also welcome providing general infrastructure for this  -
every drvier seems to have this same basic approach.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [PATCH 01/37] IB/rdmavt: Create module framework and handle
 driver registration
Date: Tue, 8 Dec 2015 07:55:45 +0200
Message-ID: <20151208055545.GC7313@leon.nu>
References: <20151207204046.8144.18752.stgit@phlsvslse11.ph.intel.com>
 <20151207204300.8144.20089.stgit@phlsvslse11.ph.intel.com>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151207204300.8144.20089.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Dec 07, 2015 at 03:43:02PM -0500, Dennis Dalessandro wrote:
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include "vt.h"
> +
> +#define RDMAVT_DRIVER_VERSION "0.1"
Do we really need driver version?

> +
> +MODULE_LICENSE("Dual BSD/GPL");
> +MODULE_DESCRIPTION("RDMA Verbs Transport Library");
> +MODULE_VERSION(RDMAVT_DRIVER_VERSION);
> +
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

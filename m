From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 01/37] IB/rdmavt: Create module framework and handle driver registration
Date: Tue, 8 Dec 2015 18:06:13 -0500
Message-ID: <20151208230612.GB14221@phlsvsds.ph.intel.com>
References: <20151207204046.8144.18752.stgit@phlsvslse11.ph.intel.com> <20151207204300.8144.20089.stgit@phlsvslse11.ph.intel.com> <20151208055545.GC7313@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151208055545.GC7313-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 08, 2015 at 07:55:45AM +0200, Leon Romanovsky wrote:
>On Mon, Dec 07, 2015 at 03:43:02PM -0500, Dennis Dalessandro wrote:
>> +#include <linux/module.h>
>> +#include <linux/kernel.h>
>> +#include "vt.h"
>> +
>> +#define RDMAVT_DRIVER_VERSION "0.1"
>Do we really need driver version?

Based on these patches thus far. Probably not. We do still have a bit more 
development to go here, I added it more as a just in case but am not 
steadfast in keeping it.

What's the general rule here? Should we not assign a version if we aren't 
explicitly doing anything with it yet, but may at some point?

>
>> +
>> +MODULE_LICENSE("Dual BSD/GPL");
>> +MODULE_DESCRIPTION("RDMA Verbs Transport Library");
>> +MODULE_VERSION(RDMAVT_DRIVER_VERSION);
>> +

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

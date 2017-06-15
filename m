From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: rdma-core 13 fails to build on Ubuntu 16.04.1 LTS
Date: Thu, 15 Jun 2017 10:40:36 -0600
Message-ID: <20170615164036.GA23773@obsidianresearch.com>
References: <CO2PR07MB2584B40776D19F8302B387F2F8C00@CO2PR07MB2584.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CO2PR07MB2584B40776D19F8302B387F2F8C00-0HVHVVMgGXp9MDTzla2L+OFPX92sqiQdvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 15, 2017 at 04:29:29PM +0000, Amrani, Ram wrote:

> Is this a known issue?

Yes, you need to cherry pick this patch for ARM:

commit 3f26e322622e93546f1b3a1a89c788adcebedcbe
Author: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Date:   Wed Mar 22 22:12:24 2017 -0400

    Fix udma_to_device_barrier on aarch64
    
    The definition for udma_to_device_barrier on aarch64 is missing. Looks
    like an oversight in the commit that removed the old barrier macros and
    added this one.
    
    Fixes: 85a5529dead5 ("Remove the old barrier macros")
    Signed-off-by: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

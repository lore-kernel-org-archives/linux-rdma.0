From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 1/5] util: Add common mmio macros
Date: Wed, 19 Apr 2017 09:33:09 -0600
Message-ID: <20170419153309.GA29293@obsidianresearch.com>
References: <1492123127-6266-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1492123127-6266-2-git-send-email-jgunthorpe@obsidianresearch.com>
 <b35958cf-5e87-3149-5413-eb754ec89b4d@dev.mellanox.co.il>
 <20170418172852.GD7181@obsidianresearch.com>
 <20170418173815.GC14088@mtr-leonro.local>
 <20170418181736.GF7181@obsidianresearch.com>
 <20170419055517.GH14088@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170419055517.GH14088-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Apr 19, 2017 at 08:55:17AM +0300, Leon Romanovsky wrote:

> > Is this something like x32? We can certainly improve for x32.
> 
> From the customer ticket, the system is x86 (32 bits).

Then it will use the SSE path and run faster with this patch, so no
problem.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

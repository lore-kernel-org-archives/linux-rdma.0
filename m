From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] mlx5: Expose correct page_size_cap in device attributes
Date: Thu, 23 Jul 2015 15:48:32 -0600
Message-ID: <20150723214832.GA16756@obsidianresearch.com>
References: <1437478812-9650-1-git-send-email-sagig@mellanox.com>
 <55B15F92.6070604@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55B15F92.6070604-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 23, 2015 at 05:41:38PM -0400, Doug Ledford wrote:

> I assume this prevents the driver from working at all on certain arches
> (like ppc with 64k page size)?

Nothing uses page_size_cap correctly, so it has no impact.

Sagi, that is a good point, your generic code for the cleanup series
really should check that PAGE_SIZE is in page_size_cap and at least
fail the mr allocation if it isn't...

Maybe that would be enough to drop SRP's bogus usage of it...

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

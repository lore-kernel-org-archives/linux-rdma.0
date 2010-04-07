From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 22/37] librdmacm: add new call to create id
Date: Wed, 7 Apr 2010 13:34:02 -0600
Message-ID: <20100407193402.GH15629@obsidianresearch.com>
References: <F818D641D3E64DA197E789362F5F0222@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <F818D641D3E64DA197E789362F5F0222-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Apr 07, 2010 at 10:12:44AM -0700, Sean Hefty wrote:

> + *   The rdma_cm_id will be set to use synchronous operations (connect,
> + *   listen, and get_request).  To convert to synchronous operation, the
                                               ^^^^^^^^^

asynchronous?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-next 02/32] IB/core: Add SEND_LAST_INV and
 SEND_ONLY_INV opcodes
Date: Wed, 16 Sep 2015 11:08:37 -0600
Message-ID: <20150916170837.GC27294@obsidianresearch.com>
References: <1442410986-28232-1-git-send-email-kamalh@mellanox.com>
 <1442410986-28232-3-git-send-email-kamalh@mellanox.com>
 <20150916134424.GA31513@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150916134424.GA31513-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Sep 16, 2015 at 06:44:24AM -0700, Christoph Hellwig wrote:
> On Wed, Sep 16, 2015 at 04:42:36PM +0300, Kamal Heib wrote:
> > Intorduce Add SEND_LAST_INV and SEND_ONLY_INV opcodes in ib_pack.h to be
> > used by RXE for RC.
> 
> Why does RXE need new public opcodes?

At some point after the original ib_pack.h was written the IBA was
extended with a few new opcodes for X with INVALIDATE, but ib_pack.h
was never updated. See page 246

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

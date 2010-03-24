From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: Ummunotify: progress at last!
Date: Tue, 23 Mar 2010 22:55:08 -0700
Message-ID: <adapr2u2rib.fsf@roland-alpha.cisco.com>
References: <1CDB2AA4-A8DF-4169-943E-4EA190814596@cisco.com>
	<20100323165920.GH29129@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100323165920.GH29129-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> (Jason Gunthorpe's
	message of "Tue, 23 Mar 2010 10:59:20 -0600")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Linux RDMA List <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Brad Benton <brad.benton-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > I would prefer to do this by adding a new verbs call that returns a fd
 > directly. Ie use ib_uverbs_alloc_event_file and act like
 > ibv_create_comp_channel.
 > 
 > The main reason for the new FD is so it can be polled on..

Agree, we don't want a new device node I don't think -- too hard to
associate an fd you get from a separate open() with a uverbs context.

 > You can also avoid the mmap scheme by doing what perf events does,
 > pass in a pointer from userspace and have the kernel pin that page it
 > is on.

I wonder, is that a win?  I guess you don't even have to pin it, just do
copy_to_user() to update the counter, but mmap doesn't seem so bad.

I'll have to look at the perf code.
-- 
Roland Dreier  <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

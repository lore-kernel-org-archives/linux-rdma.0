From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: Ummunotify: progress at last!
Date: Tue, 23 Mar 2010 23:17:26 -0700
Message-ID: <adavdcm1bwp.fsf@roland-alpha.cisco.com>
References: <1CDB2AA4-A8DF-4169-943E-4EA190814596@cisco.com>
	<20100323165920.GH29129@obsidianresearch.com>
	<adapr2u2rib.fsf@roland-alpha.cisco.com>
	<20100324055913.GA9769@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100324055913.GA9769-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> (Jason Gunthorpe's
	message of "Tue, 23 Mar 2010 23:59:13 -0600")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Linux RDMA List <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Brad Benton <brad.benton-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > > I wonder, is that a win?  I guess you don't even have to pin it, just do
 > > copy_to_user() to update the counter, but mmap doesn't seem so bad.
 > 
 > Not sure you can call copy_to_user from a mmu_notifier callback? What
 > if it faults?

Good point... we could defer it to a context where we could block but...

 > I think the idea would be that by letting user space select the
 > counter location it could place it in a sensible cachline/etc and
 > probably avoid a pointer indirection.

OK, I have to look at the perf stuff.  That makes sense but OTOH
userspace could (unknowingly) pick a highmen page and then we end up
having to do kmap_atomic or something from an mmu notifier callback.
-- 
Roland Dreier  <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

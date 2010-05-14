From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv8 04/11] ib_core: IBoE CMA device binding
Date: Fri, 14 May 2010 15:08:14 -0700
Message-ID: <adaljbmp25t.fsf@roland-alpha.cisco.com>
References: <20100218172403.GE12286@mtls03>
	<adawrv8ubrh.fsf@roland-alpha.cisco.com>
	<20100513082613.GC16073@mtldesk030.lab.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100513082613.GC16073-8YAHvHwT2UEvbXDkjdHOrw/a8Rv0c6iv@public.gmane.org> (Eli Cohen's
	message of "Thu, 13 May 2010 11:26:13 +0300")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ewg <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > > I'm having a hard time working out why the iboe case needs to schedule
 > > to a work queue here since its already in process context, right?  It
 > > seems it would be really preferable to avoid all the extra pointer
 > > munging and reference counting, and just call things directly.

 > I assume that the caller might attempt to acquire the same lock when
 > calling join and in the callback. Specifically, ucma_join_multicast()
 > calls rdma_join_multicast() with file->mut acquired and
 > ucma_event_handler() does the same.

I see... we can't call the consumer's callback directly since it might
have locking assumptions.

It would be nice if we didn't have this reference counting sometimes
used and sometimes not used.  I'll have to think about whether this can
be made cleaner.

 - R.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

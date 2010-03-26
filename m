From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: Problem with RDMA device removal architecture
Date: Fri, 26 Mar 2010 16:00:05 -0700
Message-ID: <adad3yqy9hm.fsf@roland-alpha.cisco.com>
References: <4BACD985.1070906@opengridcomputing.com>
	<DAF23AFA2B904B32B418D9C8798D4276@amr.corp.intel.com>
	<4BACE28A.2080409@opengridcomputing.com>
	<adazl1vxb7p.fsf@roland-alpha.cisco.com>
	<06FEECB9AB064B309D21BA9AC0A4BFFD@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <06FEECB9AB064B309D21BA9AC0A4BFFD-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org> (Sean
	Hefty's message of "Fri, 26 Mar 2010 15:54:58 -0700")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > >uverbs is trickier, because a userspace process will typically have some
 > >hardware resources directly mmap'ed.  We need a way to "revoke" that
 > >mmap and have it point at a dummy page until userspace releases it --

 > What exactly would the dummy page contain and could the application/library read
 > it assuming that it is obtaining valid data?

It would be an all-0s page I guess (to avoid leaking kernel data).

What the device driver library would do with it is device-specific but
eg Mellanox uses it write-only.  Not sure if any other devices put
something readable there -- if so I guess that driver should put a safe
value there if possible.
-- 
Roland Dreier  <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

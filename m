From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 2/9] Remove HAVE_VALGRIND_MEMCHECK_H/INCLUDE_VALGRIND
Date: Thu, 29 Sep 2016 16:34:15 -0600
Message-ID: <20160929223415.GD27229@obsidianresearch.com>
References: <1475182076-5411-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1475182076-5411-3-git-send-email-jgunthorpe@obsidianresearch.com>
 <aef5ce41-14bf-9869-88c8-ab5796634a8c@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <aef5ce41-14bf-9869-88c8-ab5796634a8c-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Sep 29, 2016 at 02:01:26PM -0700, Bart Van Assche wrote:

> Independent of this patch: Valgrind has a stable ABI so I propose to add a
> copy of the memcheck.h header file to the rdma-core source tree. Many other
> open source projects already do this.

Interesting idea, what do you see as the benefit?

FWIW, I haven't had any problems getting the valgrind headers on any
supported distro.

I think I'd rather make the absence of valgrind a hard error (right
now cmake makes a warning in the summary) than worry about another
copied header...

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

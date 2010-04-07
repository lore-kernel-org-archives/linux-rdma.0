From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 13/51] IB/qib: Add qib_driver.c
Date: Wed, 07 Apr 2010 12:33:18 -0700
Message-ID: <ada7hoj2h35.fsf@roland-alpha.cisco.com>
References: <20091203190305.29507.58158.stgit@chromite.mv.qlogic.com>
	<20091203190413.29507.17962.stgit@chromite.mv.qlogic.com>
	<adafx3743n6.fsf@roland-alpha.cisco.com>
	<4BBCDBD6.8010809@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4BBCDBD6.8010809-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> (Steve Wise's message of
	"Wed, 07 Apr 2010 14:24:06 -0500")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Ralph Campbell <ralph.campbell-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

 > Where can I find information on trace events?  Something in Documentation/*?

Yep, Documentation/trace/events.txt.

Also look at eg include/trace/events/ext4.h and how the trace_ext4_{xxx}
functions are used in fs/ext4/*.

It's much better than anything you're going to hack up for a single
driver to use.

 - R.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

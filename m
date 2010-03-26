From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Problem with RDMA device removal architecture
Date: Fri, 26 Mar 2010 15:54:58 -0700
Message-ID: <06FEECB9AB064B309D21BA9AC0A4BFFD@amr.corp.intel.com>
References: <4BACD985.1070906@opengridcomputing.com>	<DAF23AFA2B904B32B418D9C8798D4276@amr.corp.intel.com>	<4BACE28A.2080409@opengridcomputing.com> <adazl1vxb7p.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adazl1vxb7p.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Roland Dreier' <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>uverbs is trickier, because a userspace process will typically have some
>hardware resources directly mmap'ed.  We need a way to "revoke" that
>mmap and have it point at a dummy page until userspace releases it --

What exactly would the dummy page contain and could the application/library read
it assuming that it is obtaining valid data?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

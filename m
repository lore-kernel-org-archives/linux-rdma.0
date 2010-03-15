From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: broken support for UC in rdma_cm
Date: Mon, 15 Mar 2010 08:38:00 -0700
Message-ID: <7E151C5823FF4048B15DCA15845BB0EB@amr.corp.intel.com>
References: <20100315111228.GC23358@mtldesk030.lab.mtl.com> <20100315134527.GA31210@mtldesk030.lab.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100315134527.GA31210-8YAHvHwT2UEvbXDkjdHOrw/a8Rv0c6iv@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Eli Cohen' <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ewg <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>I just noticed that Vlad already opened a bugzilla bug (1874) on this.
>I quote Sean's response:
>
>RDMA CM supports UD and RC QPs (port spaces UDP/TCP) only.  Support
>for UC QPs should come from another port space.
>
>This makes sense to me. Still we need to address the issues I raised
>below. Sean, are you going to fix this?

This is really a new feature request, which I may not have time to address.  It
depends on the scope of the changes that are needed.

If both sides try using UC QPs, do you know what specific setting causes the
connection to fail?
 
- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2] allow passthrough of rmpp packets to user mad clients
Date: Wed, 23 Jun 2010 10:26:37 -0700
Message-ID: <adad3vhvewi.fsf@roland-alpha.cisco.com>
References: <4C2744E8AD2982428C5BFE523DF8CDCB49A488DAD8@MNEXMB1.qlogic.org>
	<adask52o9p6.fsf@roland-alpha.cisco.com>
	<4C2744E8AD2982428C5BFE523DF8CDCB49D09E7C2F@MNEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C2744E8AD2982428C5BFE523DF8CDCB49D09E7C2F-amwN6d8PyQWXx9kJd3VG2h2eb7JE58TQ@public.gmane.org>
	(Mike Heinz's message of "Fri, 18 Jun 2010 08:42:38 -0500")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > Unfortunately for IB the size of an RMPP response and buffer cannot
 > be controlled by the kernel.  So if an application has a large
 > response to send, the entire buffer must be copied into the kernel
 > and the kernel cannot decide on its own segmentation boundaries.
 > Hence the ability for selected management applications to control and
 > limit the amount of kernel memory space is desirable.  These issues
 > become serious at scale when larger RMPP responses are needed and
 > more clients may also be issuing requests.  The two can combine and
 > result in N^2 types behavior for kernel memory footprint relative to
 > N=cluster node count or potentially N=cluster CPU core count.

So this is an interesting point.  However I don't think we really want
to solve this by adding some magic value of the version field that
changes the umad interface into a completely different mode and then
have every app implement its own copy of the RMPP protocol in userspace.
It would seem a lot cleaner to me to just fix up the kernel RMPP
implementation to avoid the huge double buffering; is that not possible?

The other argument (proprietary legacy apps) doesn't really carry any
weight with me.  We're not going to introduce duplicate APIs just so
someone doesn't have to port old code.

 - R.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

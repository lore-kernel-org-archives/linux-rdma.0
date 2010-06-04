From: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH v2] IB/util madeye.c
Date: Fri, 4 Jun 2010 11:18:51 -0500
Message-ID: <4C2744E8AD2982428C5BFE523DF8CDCB49A488DAC9@MNEXMB1.qlogic.org>
References: <4C2744E8AD2982428C5BFE523DF8CDCB49A488D5D7@MNEXMB1.qlogic.org>
	<CF9C39F99A89134C9CF9C4CCB68B8DDF255F32E369@orsmsx501.amr.corp.intel.com>
	<20100527094605.790bafee.weiny2@llnl.gov>
	<CF9C39F99A89134C9CF9C4CCB68B8DDF255F32E4CC@orsmsx501.amr.corp.intel.com>
 <adamxvlw6za.fsf@roland-alpha.cisco.com>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF255F46352E@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF255F46352E-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I could try - not sure how much time I'll be allowed to spend on it, but it's a worthwhile effort. We use madeye a lot, so extending it's capabilities would be a big win.

-----Original Message-----
From: Hefty, Sean [mailto:sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org] 
Sent: Thursday, June 03, 2010 12:32 PM
To: Roland Dreier
Cc: Ira Weiny; Mike Heinz; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: RE: [PATCH v2] IB/util madeye.c

> Another option would be to rip out all the MAD snooping stuff from the
> core and replace it with something based on the kernel's tracing
> infrastructure -- that would give us both a low-tech shell-based version
> of madeye (based on just using the pretty-printed ASCII dumps from the
> kernel trace stuff) and also allow for higher-tech userspace code to do
> smarter processing based on the binary trace interface.

Mike, is this something that you could look at?  This doesn't look like it would be that difficult.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

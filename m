From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2] IB/util madeye.c
Date: Thu, 27 May 2010 11:10:49 -0700
Message-ID: <adamxvlw6za.fsf@roland-alpha.cisco.com>
References: <4C2744E8AD2982428C5BFE523DF8CDCB49A488D5D7@MNEXMB1.qlogic.org>
	<CF9C39F99A89134C9CF9C4CCB68B8DDF255F32E369@orsmsx501.amr.corp.intel.com>
	<20100527094605.790bafee.weiny2@llnl.gov>
	<CF9C39F99A89134C9CF9C4CCB68B8DDF255F32E4CC@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF255F32E4CC-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
	(Sean Hefty's message of "Thu, 27 May 2010 10:42:22 -0700")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, "linux-rdma@vger.kernel.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > > Do you mean the controls?  not the snooping?

 > I mean port madeye to calling libibumad.  Replace module_params with
 > command line options, printk with printf, use the libibumad
 > registration calls, etc.

But we would need to extend the user MAD interface to support snooping,
right?  How easy would that be to slot in?

Another option would be to rip out all the MAD snooping stuff from the
core and replace it with something based on the kernel's tracing
infrastructure -- that would give us both a low-tech shell-based version
of madeye (based on just using the pretty-printed ASCII dumps from the
kernel trace stuff) and also allow for higher-tech userspace code to do
smarter processing based on the binary trace interface.

 - R.
-- 
Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

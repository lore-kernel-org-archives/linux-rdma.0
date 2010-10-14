From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC 1/2] IB/mad: Simplify snooping interface
Date: Thu, 14 Oct 2010 13:13:57 -0700
Message-ID: <adatykoilbu.fsf@cisco.com>
References: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B7DAA11F@orsmsx501.amr.corp.intel.com>
	<4C2744E8AD2982428C5BFE523DF8CDCB49D45E3FED@MNEXMB1.qlogic.org>
	<CF9C39F99A89134C9CF9C4CCB68B8DDF25B7E5EA22@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B7E5EA22-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
	(Sean Hefty's message of "Thu, 14 Oct 2010 09:02:57 -0700")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > Without breaking the umad ABI, GID filtering would be difficult.  LID
 > is possible, but I can't think of a good reason why the kernel should
 > perform that level of filtering.  Ideas?

How many MADs in real life even have a source GID?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

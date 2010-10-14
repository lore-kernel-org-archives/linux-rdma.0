From: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: RE: [RFC 1/2] IB/mad: Simplify snooping interface
Date: Thu, 14 Oct 2010 11:06:05 -0500
Message-ID: <4C2744E8AD2982428C5BFE523DF8CDCB49D45E3FFF@MNEXMB1.qlogic.org>
References: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B7DAA11F@orsmsx501.amr.corp.intel.com>
 <4C2744E8AD2982428C5BFE523DF8CDCB49D45E3FED@MNEXMB1.qlogic.org>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF25B7E5EA22@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B7E5EA22-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Well, the critical thing is that on a large fabric, capturing all the MADs would be quite a firehose of data. Being able to filter on a single source or destination would make the amount of data more manageable.

I'm flexible though, if the act of dumping all the data to a user-space app doesn't adversely affect the system too much, we could always have the user-space tool do the filtering.

-----Original Message-----
From: Hefty, Sean [mailto:sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org] 
Sent: Thursday, October 14, 2010 12:03 PM
To: Mike Heinz; Linux RDMA list
Subject: RE: [RFC 1/2] IB/mad: Simplify snooping interface

> Would it be worthwhile to filter based on the source LID/GID of the MAD?

Without breaking the umad ABI, GID filtering would be difficult.  LID is possible, but I can't think of a good reason why the kernel should perform that level of filtering.  Ideas?

I have thought about using the umad_send interface to specify more complex filters that could be handled by ib_user_mad, rather than ib_mad.  I just didn't want to get too fancy in the kernel, especially for an initial submission.

- Sean 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

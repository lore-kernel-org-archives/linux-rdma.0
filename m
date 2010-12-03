From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH V3] SA Busy Handling
Date: Fri, 3 Dec 2010 14:24:39 -0800
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B8A96DF3@orsmsx501.amr.corp.intel.com>
References: <4C2744E8AD2982428C5BFE523DF8CDCB4A208DF31E@MNEXMB1.qlogic.org>
	<CF9C39F99A89134C9CF9C4CCB68B8DDF25B8A20BC4@orsmsx501.amr.corp.intel.com>
	<4C2744E8AD2982428C5BFE523DF8CDCB4A208DF3B0@MNEXMB1.qlogic.org>
 <adamxomlefp.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adamxomlefp.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> However I think I would like to have at least some idea of what the
> smarter way to handle "busy" responses will be.  If we're always just
> going to treat them like timeouts, then it seems the SA would be smarter
> to avoid sending them in the first place.

I'm making stuff up here, but one possible difference between handling busy response versus a timeout could be: a busy response increases the timeout before a mad is retried and wouldn't necessarily decrease the total number of retries that would be attempted.  A timed out mad would be retried immediately, with a longer timeout on the back-end.

However, I can't think of a reason why it would be better for the SA to respond with busy under heavy load rather than just dropping the mad.  If busy conveyed some sort of retry time, that would be nice.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

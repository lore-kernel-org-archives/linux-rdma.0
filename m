From: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH V3] SA Busy Handling
Date: Mon, 6 Dec 2010 09:27:47 -0600
Message-ID: <4C2744E8AD2982428C5BFE523DF8CDCB4A208DF4C0@MNEXMB1.qlogic.org>
References: <4C2744E8AD2982428C5BFE523DF8CDCB4A208DF31E@MNEXMB1.qlogic.org>
	<CF9C39F99A89134C9CF9C4CCB68B8DDF25B8A20BC4@orsmsx501.amr.corp.intel.com>
	<4C2744E8AD2982428C5BFE523DF8CDCB4A208DF3B0@MNEXMB1.qlogic.org>
 <adamxomlefp.fsf@cisco.com>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF25B8A96DF3@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B8A96DF3-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Todd Rimmer <todd.rimmer-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sean's got the idea exactly right, but it's important to also remember that the BUSY response is part of the original spec and was part of the old IB Gold and Infinicon stacks as well. I'm not sure how IB Gold handled BUSY responses, but the ICS stack definitely used a separate, exponential retry/timing model for BUSY responses. Sean's idea about including a time value in the BUSY response is fine, but would involve changing the Infiniband specification.

So, what we have right now is that OFED treats BUSY as a hard error, which can cause some modules to  spam the SM. (In addition, none of the user-land tools use any kind of retries at all, but that's a different issue.)

Finally, another reason for using the BUSY is to *prevent* overloading and congestion by causing a percentage of requests to delay rather than simply waiting till the SM is overloaded and rejecting everything. Yes, you could simulate by throwing a percentage of the requests on the floor, but it is still more flexible for both the SM and the client to use the BUSY response.

-----Original Message-----
From: Hefty, Sean [mailto:sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org] 
Sent: Friday, December 03, 2010 5:25 PM
To: Roland Dreier; Mike Heinz
Cc: Hal Rosenstock; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: RE: [PATCH V3] SA Busy Handling

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

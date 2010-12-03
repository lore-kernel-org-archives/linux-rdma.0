From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V3] SA Busy Handling
Date: Fri, 03 Dec 2010 14:01:48 -0800
Message-ID: <adaipzaldmb.fsf@cisco.com>
References: <4C2744E8AD2982428C5BFE523DF8CDCB4A208DF31E@MNEXMB1.qlogic.org>
	<CF9C39F99A89134C9CF9C4CCB68B8DDF25B8A20BC4@orsmsx501.amr.corp.intel.com>
	<4C2744E8AD2982428C5BFE523DF8CDCB4A208DF3B0@MNEXMB1.qlogic.org>
	<adamxomlefp.fsf@cisco.com>
	<4C2744E8AD2982428C5BFE523DF8CDCB4A208DF428@MNEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C2744E8AD2982428C5BFE523DF8CDCB4A208DF428-amwN6d8PyQWXx9kJd3VG2h2eb7JE58TQ@public.gmane.org>
	(Mike Heinz's message of "Fri, 3 Dec 2010 15:50:08 -0600")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma@vger.kernel.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > The reason for preferring a BUSY response to simply having the SM
 > throw the packets on the floor is that it makes it possible to
 > differentiate between an overloaded SM and communications problems
 > when debugging a fabric problem.

Is that really the main reason for all this?  Wouldn't it be simpler to
have the SM log something locally when it's overloaded, rather than
generating even more traffic on the fabric?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH v2] Add exponential backoff + random delay to MADs when
 retrying after timeout.
Date: Wed, 3 Nov 2010 10:36:38 -0500
Message-ID: <4C2744E8AD2982428C5BFE523DF8CDCB4A207A813F@MNEXMB1.qlogic.org>
References: <4C2744E8AD2982428C5BFE523DF8CDCB49D4675DEB@MNEXMB1.qlogic.org>
 <4CC976CC.1080009@dev.mellanox.co.il>
 <4C2744E8AD2982428C5BFE523DF8CDCB4A207A80C5@MNEXMB1.qlogic.org>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF25B83084D5@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B83084D5-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Todd Rimmer <todd.rimmer-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sean said:
> When you consider RMPP, the timeout/retry values specified by 
> the user are not straightforward in their meaning.  I haven't 
> look at this patch in detail yet, but how do the timeout 
> changes work with RMPP MADs?  Is the timeout reset to the 
> minimum after an ACK is received?

Hal asked the same thing - and I'm confused because I thought
that if receiving an RMPP response times out, the entire transaction is
aborted. 

First, the existing code - before I patched it - doesn't distinguish 
between RMPP and regular MADs when dealing with timeouts. 

Second, the spec says (on p 788):

| If the Receiver does not receive all the packets in this transaction within 
| its transaction timer, it ABORTs the transaction and terminates.

As far as I can tell, that's what the current ib_mad module implements -
if the entire transaction doesn't complete with the receiver-specified
time out, the entire thing is retried.

> My personal preference at this time is to push more intelligence 
> into the timeout/retry algorithm used by the MAD layer, but 
> restricted to SA clients.  I'd like to see even more randomization 
> in the retry time, coupled with a TCP-like congestion windowing 
> implementation when issuing SA queries.

> For example: Never allow more than, say, 8 SA queries outstanding 
> at a time.  If an SA query times out, reduce the number of 
> outstanding queries to 1 until we get a response, then double the 
> number of queries allowed to be outstanding until we reach the max.  
> Have the mad layer calculate the SA query timeout based on the 
> actual SA response time, with randomization based on that.  The 
> user specified timeout value can basically be ignored.

>The only reason I'm suggesting we restrict the algorithm to SA 
> queries is to avoid storing per endpoint information.  That may 
> be better handled by the CM (since CM responses are sends).

> Given all this, then I think it would be okay to accept the 
> patch to drop busy responses from the SA until this framework 
> is in place, which wouldn't be until 2.6.38 or 39.

I'm open to this, but do we really need TCP/IP level congestion 
control? How many nodes are likely to have more than a few SA 
queries outstanding at a time?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

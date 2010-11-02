From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v2] Add exponential backoff + random delay to MADs when
 retrying after timeout.
Date: Tue, 2 Nov 2010 16:12:27 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B83084D5@orsmsx501.amr.corp.intel.com>
References: <4C2744E8AD2982428C5BFE523DF8CDCB49D4675DEB@MNEXMB1.qlogic.org>
 <4CC976CC.1080009@dev.mellanox.co.il>
 <4C2744E8AD2982428C5BFE523DF8CDCB4A207A80C5@MNEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C2744E8AD2982428C5BFE523DF8CDCB4A207A80C5-amwN6d8PyQWXx9kJd3VG2h2eb7JE58TQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Todd Rimmer <todd.rimmer-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> The problem with this approach is that if the same application or ulp is
> installed on many hundreds (or thousands) of nodes, all using the same
> retry
> interval, they could all end up retrying at roughly the same time, causing
> repeatable packet storms. On a large cluster, these storms can effectively
> act
> as a denial of service attack. To get around this, the retry timer should
> have
> a randomization component of a similar order of magnitude as the retries
> themselves. Since retries are usually on the order of one second, the patch
> defines the randomization component as between zero and roughly 1/2 second
> (511 ms) although the upper limit can tuned by changing a #define.
> 
> The other standard method for prevent storms of retries is to implement an
> exponential backoff, such as is used in the Ethernet protocol. However,
> because
> the user has also explicitly specified a timeout value, I chose to treat
> that value as a minimum delay, then I add an exponential value on top of
> that,
> defined as BASE*2^c, where 'c' is the number of retries already attempted,
> minus 1.
> 
> Currently, the base value is defined as 511 ms (1/2 second), so that the
> retry interval is defined as:
> 
> (minimum timeout) + 511<<c - (random value between 0 & 511)
> 
> This causes the following retry times:
> 
> 0:      minimum timeout
> 1:      minimum timeout + (random value between 0 & 511)
> 2:      minimum timeout + 1 second - (random value between 0 & 511)
> 3:      minimum timeout + 2 seconds - (random value between 0 & 511)
> 4:      minimum timeout + 4 seconds - (random value between 0 & 511)

When you consider RMPP, the timeout/retry values specified by the user are not straightforward in their meaning.  I haven't look at this patch in detail yet, but how do the timeout changes work with RMPP MADs?  Is the timeout reset to the minimum after an ACK is received?

My personal preference at this time is to push more intelligence into the timeout/retry algorithm used by the MAD layer, but restricted to SA clients.  I'd like to see even more randomization in the retry time, coupled with a TCP-like congestion windowing implementation when issuing SA queries.

For example: Never allow more than, say, 8 SA queries outstanding at a time.  If an SA query times out, reduce the number of outstanding queries to 1 until we get a response, then double the number of queries allowed to be outstanding until we reach the max.  Have the mad layer calculate the SA query timeout based on the actual SA response time, with randomization based on that.  The user specified timeout value can basically be ignored.

The only reason I'm suggesting we restrict the algorithm to SA queries is to avoid storing per endpoint information.  That may be better handled by the CM (since CM responses are sends).

Given all this, then I think it would be okay to accept the patch to drop busy responses from the SA until this framework is in place, which wouldn't be until 2.6.38 or 39.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

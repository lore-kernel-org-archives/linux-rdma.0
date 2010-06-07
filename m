From: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH] Handling busy responses from the SA
Date: Mon, 7 Jun 2010 10:42:48 -0500
Message-ID: <4C2744E8AD2982428C5BFE523DF8CDCB49A488DBFB@MNEXMB1.qlogic.org>
References: <4C2744E8AD2982428C5BFE523DF8CDCB49A488DAF3@MNEXMB1.qlogic.org>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF255F4DC96C@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF255F4DC96C-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org" <ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sean said:
> I don't object to the concept of treating a busy response as a timeout, but how does this help prevent overwhelming the SA?  It continues to retry the queries, even if the SA says that it's too busy to respond without adjusting the timeout specified by the user.  I would think that you'd at least want to adjust the timeout (double it or use some random backoff).


Well, the current behavior is to simply return the BUSY to the client or ULP, which  is either treated as a permanent error or causes an immediate retry. This can be a big problem with, for example, ipoib which sets retries to 15 and (as I understand it) immediately retries to connect when getting an error response from the SA. Other ulps have similar settings. Without some kind of delay, starting up ipoib on a large fabric (at boot time, for example) can cause a real packet storm. 

By treating BUSY replies identically to timeouts, this patch at least introduces a delay between attempts. In the case of the ULPs, the delay is typically 4 seconds.

Sean said:
> The general guideline that we've been using for adjusting timeouts has been to report the failures and let the caller make the a necessary adjustments.  As far as I know, the only way for user space applications to query the SA are through the librdmacm, which sets retries to 0, or through the libibumad interface directly.  I would expect any application using the latter to be intelligent enough to handle a busy response.


And this approach encourages applications to adjust their timeouts appropriately by treating BUSY responses as non-events and forcing the applications to wait for their request to time out.

Depending on the application developers to take BUSY responses into account seems to be asking for trouble - it allows one rogue app to bring the SA to its knees, for example. By enforcing this timeout model in the kernel, we guarantee that there will be at least some delay between each message when the SA is reporting a busy status. And as I previously mentioned this patch also affects kernel code, much of which does use retries.

Sean said:
> Maybe we should re-think that guideline and allow users to simply indicate that the MAD layer should use reasonable defaults.  This would enable the ib_mad module to adjust the timeout values for all consumers based on actual destination response times.  It could also back off retrying multiple requests that were initiated around the same time, instead only retrying the first request, while simply increasing the timeout values for the others.  This is more complex, but we should be able to start with something fairly simple.

It's an interesting idea, but in the meantime this is a problem that affects large clusters today.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

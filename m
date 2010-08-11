From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Update proposal for handling BUSY responses from the SA/SM
Date: Wed, 11 Aug 2010 10:00:24 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25A96016FF@orsmsx501.amr.corp.intel.com>
References: <4C2744E8AD2982428C5BFE523DF8CDCB49D4493A43@MNEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C2744E8AD2982428C5BFE523DF8CDCB49D4493A43-amwN6d8PyQWXx9kJd3VG2h2eb7JE58TQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Todd Rimmer <todd.rimmer-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> In addition to the patch itself, there has been significant discussion
> about changing the APIs to allow the application to explicitly specify how
> to handle BUSY.

The current code allows an app to explicitly handle BUSY replies, so we don't need changes for that.  I was advocating making things simpler for the user, with more intelligent retry/timeout handling done in the kernel.

For example:

umad_send() takes the timeout_ms and retries as int.  If a negative timeout_ms is given with retries set to 0, then the timeout is treated as the total amount of time to wait for a response.  The number of retries and timeout values between each one would be handled by the kernel.  This includes the kernel handling BUSY responses in whatever way seems most appropriate.

The kernel can be updated to use random retry intervals, exponential back-offs, windowing techniques, response time history, etc.  Of course, we can start with some simple kernel changes at first, then enhance them.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

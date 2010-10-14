From: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: RE: user SA notifications, redux
Date: Thu, 14 Oct 2010 10:04:25 -0500
Message-ID: <4C2744E8AD2982428C5BFE523DF8CDCB49D45E3FE3@MNEXMB1.qlogic.org>
References: <4C2744E8AD2982428C5BFE523DF8CDCB49D45E3EE4@MNEXMB1.qlogic.org>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF25B7DAA826@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B7DAA826-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org" <ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org>
Cc: "vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org" <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

By providing this mechanism, ib_usa provides a convenient and useful way for user applications to detect when nodes enter or leave the fabric. This is useful for fabric monitoring applications (like a system admin dashboard) or, conceivably, to allow a job scheduler to react to problems and to dynamically balance the computational load across the fabric.

As a reminder - the original proposal also supported allowing user applications to join multicast groups, but there was talk about adding that to rdma_cm, instead.

-----Original Message-----
From: Hefty, Sean [mailto:sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org] 
Sent: Wednesday, October 13, 2010 11:59 AM
To: Mike Heinz; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org
Cc: vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org; Roland Dreier
Subject: RE: user SA notifications, redux

> As I mentioned earlier, the reason ib_sa acts as a single access point for
> SA/SM traps and notices is because traps and notices are sent to ports, not
> to
> queue pairs and not to processes. That means only one entity can be
> subscribed
> for notices and traps at any particular time, and must manage them,
> "sharing
> them out" among all processes that are interested in them.

Can you provide a brief description of the intended usage model?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

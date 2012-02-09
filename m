From: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: RE: Possibly serious bug in ib_mad - Resolved.
Date: Thu, 9 Feb 2012 11:56:54 -0600
Message-ID: <4C2744E8AD2982428C5BFE523DF8CDCB5CD5AD8F13@MNEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Okay - I believe I've root-caused this problem, and it goes back to an older version of a patch to ib_mad. The older version of the patch had been integrated into our in-house builds and resulted in ib_mad generating a new MAD response whenever it received an undeliverable MAD response. The version of the patch actually committed in OFED 1.5.4.1 (http://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg10855.html) does not have this problem so no further action is needed.

-----Original Message-----
From: Hefty, Sean [mailto:sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org]
Sent: Thursday, February 09, 2012 2:57 AM
To: Mike Heinz; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Todd Rimmer
Subject: RE: Possibly serious bug in ib_mad: processing packets from ibping can consume 100% of CPU and may leave user processes locked in umad_recv

> Subject: Possibly serious bug in ib_mad: processing packets from
> ibping can consume 100% of CPU and may leave user processes locked in
> umad_recv

Is there a chance that the low level driver is asking to send the MAD to itself over and over again?


This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at  http://vger.kernel.org/majordomo-info.html


This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

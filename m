From: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: RE: Possibly serious bug in ib_mad: processing packets from ibping
 can consume 100% of CPU and may leave user processes locked in umad_recv
Date: Thu, 9 Feb 2012 07:33:24 -0600
Message-ID: <4C2744E8AD2982428C5BFE523DF8CDCB5CD5AD8EB8@MNEXMB1.qlogic.org>
References: <4C2744E8AD2982428C5BFE523DF8CDCB5CD5AD8E9A@MNEXMB1.qlogic.org>
 <1828884A29C6694DAF28B7E6B8A82373374C1F5D@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373374C1F5D-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Todd Rimmer <todd.rimmer-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I think there is. After I posted that trace I began running through the code - since the only (relevant) place agent_send_response is called is in response process_mad(), that is a distinct possibility. I've forwarded the information to the qib driver team.

If that's true, it would actually be good news - I posted the trace because was concerned that this could affect all fabrics.

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
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

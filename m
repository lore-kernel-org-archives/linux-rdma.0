From: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH] An argument for allowing applications to manually send
 RMPP packets if desired
Date: Mon, 19 Sep 2011 10:30:56 -0500
Message-ID: <4C2744E8AD2982428C5BFE523DF8CDCB4A5387EDB4@MNEXMB1.qlogic.org>
References: <4C2744E8AD2982428C5BFE523DF8CDCB4A5387E899@MNEXMB1.qlogic.org>
 <CAL1RGDUXM9-Ey1aF8xQo3X_L1PLrVyyLPYvqmy6Qeu5M2JnJPA@mail.gmail.com>
 <20110912172334.GC18574@obsidianresearch.com>
 <CAL1RGDVPZzMKmMg7mokhG0btX+3NH_+tL-9P5guV10h6X6i0iw@mail.gmail.com>
 <20110912190623.GD18574@obsidianresearch.com>
 <4C2744E8AD2982428C5BFE523DF8CDCB4A5387ECDF@MNEXMB1.qlogic.org>
 <20110917034251.GA6056@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A8237316E5B763@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237316E5B763-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Todd Rimmer <todd.rimmer-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The problem with creating a new protocol is that we would need to

a) design the protocol
b) get the IBTA to accept it
c) get the application developers to accept it.

I simply cannot see getting this process done in less than two years.  Meanwhile, the problem with SA/SM performance is an issue right now - and it's an issue that was created not by the IB spec but by the implementation.

-----Original Message-----
From: Hefty, Sean [mailto:sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org]
Sent: Sunday, September 18, 2011 8:35 PM
To: Jason Gunthorpe; Mike Heinz
Cc: Roland Dreier; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Todd Rimmer
Subject: RE: [PATCH] An argument for allowing applications to manually send RMPP packets if desired

> Ultimately I think the scalable/compatible answer is to move these
> RMPP work loads to a verbs QP and we need to have a user space RMPP
> implementation for that anyhow.

Many to one is never scalable.  The applications simply cannot rely on every node querying the SA at the same time, especially for large amounts of data.  And the overhead of MADs and RMPP is too high to be a useful solution to scaling.




This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

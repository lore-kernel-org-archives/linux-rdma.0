From: Eldad Zinger <eldadz-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: CMA handler status code
Date: Tue, 27 Jul 2010 07:34:29 +0300
Message-ID: <AANLkTik2eOWELUAwjL+tfjMb28L3OjWB57iMyvDpOWDm@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi everyone,
while developing SDP, I found a small problem with cma handlers:

drivers/infiniband/core/cma.c : 2204
drivers/infiniband/core/cma.c : 976

event.status = ib_event->param.sidr_rep_rcvd.status
event.status = ib_event->param.rej_rcvd.reason

event.status should be 0 for success, or negative value of generic error code.
In that code, the error code is positive and do not comply with
generic error code.

In order to make the status field available for other modules (like
SDP), that field should be format-consistent.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

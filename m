From: Larry Finger <Larry.Finger-tQ5ms3gMjBLk1uMJSBkQmQ@public.gmane.org>
Subject: Warnings when compiling drivers/infiniband/hw/amso1100/c2_vq.c on
 an i386 system
Date: Mon, 09 Aug 2010 19:49:02 -0500
Message-ID: <4C60A1FE.8060300@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

When building the current mainline on i386 architecture, I get the foll=
owing
warnings:

  CC [M]  drivers/infiniband/hw/amso1100/c2_vq.o
drivers/infiniband/hw/amso1100/c2_vq.c: In function =91vq_req_alloc=92:
drivers/infiniband/hw/amso1100/c2_vq.c:110:18: warning: cast from point=
er to
integer of different size
drivers/infiniband/hw/amso1100/c2_vq.c: In function =91vq_req_free=92:
drivers/infiniband/hw/amso1100/c2_vq.c:126:17: warning: cast from point=
er to
integer of different size
drivers/infiniband/hw/amso1100/c2_vq.c: In function =91vq_req_put=92:
drivers/infiniband/hw/amso1100/c2_vq.c:154:23: warning: cast from point=
er to
integer of different size

Each of them arises from a statement of the form:

    r->reply_msg =3D (u64) NULL;

Is that cast necessary? I would have expected gcc to generate a NULL of=
 the
proper length without it, or am I missing something? As I do not have t=
he
hardware and could not test any patches, I will not submit any, but I'm
interested in the answer.

Thanks,

Larry
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

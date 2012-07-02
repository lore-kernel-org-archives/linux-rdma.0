From: Hiroyuki Sato <hiroysato-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [Q] How to tranfer a file which is over 2GB(2^31) size in RDMA network?
Date: Mon, 2 Jul 2012 22:49:33 +0900
Message-ID: <CA+Tq-Rpk-Q74k2z=ToCK+eeDKuF_84fU2t0LwMBM==QG4P8XgA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Dear developers.

I'm writing simple file transfer program.

I would like to know about the following.
Q: How to tranfer a file which is over 2GB(2^31) size  in RDMA network?

Please imagine to transfer whole DVD(4.7GB) file via RDMA networok.

The maximum message size of RC is 2^31.
so I can't transfer it with one RDMA message.

Maybe It must split multiple parts.
When I sent first part with the following sequence,
how to transfer second part?

Do I have to call qp ibv_destroy_qp and recreate new qp?
Or can I reuse current qp?

I'm looking for similar example but I can't find it.
Any information is welcome.

Thank you for your advice.

Sincerely

--
Hiroyuki Sato.


File transfer sequence (1st part)

  ibv_open_device
  ibv_alloc_pd
  ibv_reg_mr
  ibv_create_cq
  ibv_create_qp
  ibv_modify_qp(RESET->INIT)
  ibv_post_recv
  exchange lid, sid,qpn
  ibv_connect
  ibv_modify_qp(INIT->RTR)
  ibv_modify_qp(RTR->RTS)
  ibv_post_send
  ...



Environment
 OS Scientific Linux 6.2
 OFED: 1.5.4.1

-- 
Hiroyuki Sato
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

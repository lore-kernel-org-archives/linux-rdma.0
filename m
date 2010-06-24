From: Andrea Gozzelino <Andrea.Gozzelino-PK20h7lG/Rc1GQ1Ptb7lUw@public.gmane.org>
Subject: RDMA synchronous operations
Date: Thu, 24 Jun 2010 16:33:27 +0200 (CEST)
Message-ID: <2389943.1277390007735.SLOX.WebMail.wwwrun@imap.lnl.infn.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi all,

I=E2=80=99m testing the latency time of an RDMA system (2 card and 1 sw=
itch).

The connection server/client is established and the code is just as
mirror on both sides.

The RDMA action scheme is below:
1-	client sends a buffer;
2-	server receives a buffer;
3-	server sends a buffer;
4-	client receives a buffer.

The scheme is in a for loop, so after step 4 client repeats step 1.
On client side I put a clock: t_start is before loop and t_end is after
loop.
I consider the round trip time RTT as (t_end-t_start)/NTX where NTX is
number of transfer (number of loop). The latency time is half RTT, if
transfer time is negligible, i.e. for small (8 Bytes =E2=80=93 4 Kbytes=
) buffer
size and high NTX value (> 10000) is true.

The RDMA communication stops casually with error status 5. It means tha=
t
the send or receive operation on one side (server or client) casually i=
s
not in time. I summarize post_send and post_receive operation are
quasi-synchronous. I would like that RDMA operation are completely
synchronous. I use the completion queue and the acknowledgement event.

Do you see the same character in other RDMA use? How can I synchronize
all RDMA operation?
Could you please give me some suggestions?

Thank you very much,
Andrea

Example of structure code:
Ibv_recv_wr rrq(mr), *bad_rrq;
		assert(!conn->post_recv(&rrq, &bad_rrq, 0));
		assert(!conn->get_completion(&compl_queue));
		//printf("ok %p %s
", compl_queue, strerror(errno));
		assert(1 =3D=3D compl_queue->poll(1, &wc));
		//printf("status %i
", (int)wc.status);
		if (wc.status !=3D0){
			printf("RDMA server closes.=20
");
			break;
			}
-----------------
Ibv_send_wr srq((void *)rpd->address, rpd->rkey), *bad_srq;
  		srq.add_sge(mr);
  		assert(!conn.post_send(&srq, &bad_srq, 0));
  		assert(!conn.get_completion(&compl_queue));
  		assert(1 =3D=3D compl_queue->poll(1, &wc));
 =20
  		//printf("ok %p %s status %i
", compl_queue, strerror(errno), wc.status);
  		//printf("loop %i
", i);
 =20
  		if (wc.status !=3D 0){
  			//printf("KO %p %s status %i
", compl_queue, strerror(errno), wc.status);
  			printf("RDMA data sending problem in loop %i.
", i);
  			break;
  		}
-----------
Andrea Gozzelino

INFN - Laboratori Nazionali di Legnaro	(LNL)
Viale dell'Universita' 2 -I-35020 - Legnaro (PD)- ITALIA
Office: E-101
Tel: +39 049 8068346
=46ax: +39 049 641925
Mail: andrea.gozzelino-PK20h7lG/Rc1GQ1Ptb7lUw@public.gmane.org
Cell: +39 3488245552			=09

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

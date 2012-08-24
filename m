From: Gaetano Mendola <mendola-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Writing RDMA applications on Linux
Date: Fri, 24 Aug 2012 17:01:58 +0200
Message-ID: <CAJycT5rf_SGPh2Gfg9C9aK2wm4uR6ZMsXeh1WD1gWGb-oqgnLg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=14dae9d7175ef9180d04c8044166
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

--14dae9d7175ef9180d04c8044166
Content-Type: text/plain; charset=ISO-8859-1

Hi,
as told you on twitter I wrote using ib berbs and rdma a communication
channel between a server and a client
.
I used your "paper" to understand the IBV/RDMA however I'm getting
only around 650 MBps when I should reach on my hardware 1500 MB
(at least ib_write_bw test is reporting me 1500MBps).

Basicaly this is what I do (pseudocode):

Active Side:

post a message receive
rdma connection
wait for rdma connection event
<<at this point transfer tx flow starts>>
start:
   register memory containing bytes to transfer
   wait remote memory region addr/key ( I wait for a ibv_wc)
   send data with ibv_post_send (IBV_WR_RDMA_WRITE)
   post a message receive
   wait for ibv_post_send event ( I wait for a ibv_wc) (this lasts
13.3 ms transfering 8MB)
   send message "DONE"
   unregister memory
goto start


Passive side:

post a message receive
rdma accept
wait for rdma connection event
<<at this point transfer rx flow starts>>
start:
   register memory that has to receive the bytes
   send addr/key of memory registered
   wait "DONE" message
   unregister memory
   post a message receive
goto start

This is the code I use to send the data:

ibv_sge sge;
sge.addr = (uintptr_t)memory_to_transfer;
sge.length = memory_to_transfer_size;
sge.lkey = memory_to_transfer_mr->lkey;

ibv_send_wr wr;
memset(&wr, 0, sizeof(wr));
wr.wr_id = 0;
wr.opcode = IBV_WR_RDMA_WRITE;
wr.sg_list = &sge;
wr.num_sge = 1;
wr.send_flags = IBV_SEND_SIGNALED;
wr.wr.rdma.remote_addr = (uintptr_t)thePeerMemoryRegion.addr;
wr.wr.rdma.rkey = thePeerMemoryRegion.rkey;

ibv_send_wr *bad_wr = NULL;
if (ibv_post_send(theCommunicationIdentifier->qp, &wr, &bad_wr) != 0) {
  notifyError("Unable to ibv post receive");
}

and this is how I was that data has been sent:

//Wait for completation
ibv_cq *cq;
void* cq_context;
if (ibv_get_cq_event(theCompletionEventChannel, &cq, &cq_context) != 0) {
  notifyError("Unable to get a ibv cq event");
}

ibv_ack_cq_events(cq, 1);

if (ibv_req_notify_cq(cq, 0) != 0) {
  notifyError("Unable to get a req notify");
}

ibv_wc wc;
int myRet = ibv_poll_cq(cq, 1, &wc);
if (myRet > 1) {
  LOG(WARNING) << "Got more than a single ibv_wc, expecting one";
}

I did modify your example code to transfer a chunk of 8MB instead of
the 2 bytes and it reports the same bandwith transfer of around
650MBps, I'm attaching the code.

I hope you can help me.

Regards
Gaetano
-- 
cpp-today.blogspot.com

--14dae9d7175ef9180d04c8044166
Content-Type: application/x-gzip; name="rdma_bench.tgz"
Content-Disposition: attachment; filename="rdma_bench.tgz"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h69eqrsv0

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
UAAA
--14dae9d7175ef9180d04c8044166--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

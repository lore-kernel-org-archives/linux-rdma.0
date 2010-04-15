From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: two questions about RDMA-WRITE
Date: Thu, 15 Apr 2010 10:17:03 -0700
Message-ID: <4B0EDAC5753E48CD8CE32B6E3EF15949@amr.corp.intel.com>
References: <q2v7bb361261004130308za7b4d6ccj6fdb657b7c7cc7e9@mail.gmail.com> <77BFFFE3D9C34D64A03DA5A9DC22F42D@amr.corp.intel.com> <20100414034142.GA5567@DINGDH.localhost.domain>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100414034142.GA5567-6UwBTAaVBkEeWBJJgrHO4P1unptsbck7@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Ding Dinghua' <dingdinghua85-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

>static void jm_cq_comp_handler(struct ib_cq *cq, void *context) {
>        struct jm_rdma_conn *conn = context;
>        struct ib_wc wc;
>        struct jm_send_ctx *send;
>
>        /* No idea why it should be called twice. */
>        printk("cq comp for id %p\n", conn->jc_id);
>        ib_req_notify_cq(cq, IB_CQ_NEXT_COMP);
>        while (ib_poll_cq(cq, 1, &wc) == 1) {
>                if (wc.opcode != IB_WC_RDMA_WRITE) {
>                        printk("completed unknown opcode %d\n", wc.opcode);
>                        /* continue; */
>                }
>                send = (struct jm_send_ctx *)wc.wr_id;
>                printk("got send=%p\n", send);
>                printk("completed RDMA_WRITE of IO(%Lu, %u)\n",
>                       send->s_offset, send->s_size);
>                send->s_done = wc.status == IB_WC_SUCCESS ? 1 : -EIO;
>                wake_up_all(&send->s_wait);
>        }
>        ib_req_notify_cq(cq, IB_CQ_NEXT_COMP);

unrelated to your problem, but this second call to ib_req_notify_cq isn't
necessary.

>static int jm_rdma_cm_event_handler(struct rdma_cm_id *id, struct rdma_cm_event
>*event) {
..
>        case RDMA_CM_EVENT_DISCONNECTED:
>                connstate = -ECONNABORTED;
>                goto connected;
..
>connected:
>                printk("%pI4:%u (event 0x%x)\n",
>                       &conn->jc_remoteaddr.sin_addr.s_addr,
>                       ntohs(conn->jc_remoteaddr.sin_port),
>                       event->event << 11);
>                conn->jc_connstate = connstate;
>                wake_up_all(&conn->jc_connect_wait);
>                break;

How quickly do you respond to the disconnect event?  The remote side will wait
until it receives a response or times out, which may be several seconds or
minutes.

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

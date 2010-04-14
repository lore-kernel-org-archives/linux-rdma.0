From: Ding Dinghua <dingdinghua85-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: two questions about RDMA-WRITE
Date: Wed, 14 Apr 2010 11:56:01 +0800
Message-ID: <20100414034142.GA5567@DINGDH.localhost.domain>
References: <q2v7bb361261004130308za7b4d6ccj6fdb657b7c7cc7e9@mail.gmail.com> <77BFFFE3D9C34D64A03DA5A9DC22F42D@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <77BFFFE3D9C34D64A03DA5A9DC22F42D-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Apr 13, 2010 at 08:48:42AM -0700, Sean Hefty wrote:
> >(2)  It takes a long time to finish rdma_disconnect work (about 10
> >seconds), so is it a reasonable time?
> 
> This is long.  How is your disconnect code structured?
>
Thanks for your reply.The project is mirror fs-metadata to another node in
HA-system, and IB is selected for its low latency.Since I'm a 100% newbie in IB development,
I think the problem may be caused by something very detail, just like problem (1).
so I paste all the connection-related function of my IB-transfer sample code(in kernel space),
Please have a look if you guys have time.

BTW: is there any docs about ib-core in kernel space? It's rather hard for me to understand
the code.

====
#include <linux/delay.h>
#include <linux/wait.h>
#include <linux/bio.h>
#include <rdma/ib_verbs.h>
#include <rdma/rdma_cm.h>

#define TEST_PAGES 16
#define RECV_PAGES 4096

#define JM_MAGIC  0xa0b0c0d0

struct connect_header {
        uint32_t        connect_magic;
        uint32_t        mirror_size; /* in 4k */
        uint64_t        addr;
        uint32_t        rkey;
};

struct jm_ib_device {
        struct list_head        conn_list;
        struct ib_device        *dev;
        struct ib_pd            *pd;
        struct ib_mr            *mr;
        int                     max_sge;
        unsigned int            max_wrs;
        spinlock_t              spinlock; /* protects all above */
};

struct jm_send_ctx {
        struct ib_sge           s_sge[64];
        u64                     s_offset;
        int                     s_size;
        int                     s_done;
        wait_queue_head_t       s_wait;
};

struct jm_rdma_conn {
        int                     jc_incoming;

        struct rdma_cm_id       *jc_id;

        struct ib_pd            *jc_pd;
        struct ib_mr            *jc_mr;

        struct ib_mr            *jc_map_mr;

        struct ib_cq            *jc_cq;
        struct ib_qp            *jc_qp;

        int                     jc_async_rc;
        struct completion       jc_done;

        wait_queue_head_t       jc_connect_wait;
        int                     jc_connstate;

        struct sockaddr_in      jc_remoteaddr;

        int                     jc_pb_nsegs;
        int                     jc_pb_segsize;
        u64                     jc_pb_addrs[64];
        u32                     jc_pb_rkey;

        struct page             *jc_pages[RECV_PAGES];
        unsigned long           jc_mappings[RECV_PAGES];
        int                     jc_page_count;

        struct list_head        list;
};

#define RDMA_RESOLVE_TIMEOUT    (5000)
#define RDMA_CONNECT_RETRY_MAX  (2)

#define JM_RDMA_MAX_DATA_SEGS   (16)

#define JM_RDMA_PORT            (18111) /* randomly chosen */

static int jm_disconnect(struct jm_rdma_conn *conn);
static void jm_conn_close(struct jm_rdma_conn *conn);
static int jm_handle_connect_req(struct rdma_cm_id *id,
                                 struct jm_rdma_conn **rconn, uint32_t mirror_size);
static struct rdma_cm_id *jm_listen_id = NULL;
static struct jm_ib_device *jm_ibdev = NULL;
static struct ib_client jm_ib_client = {
        .name   = "jm_ib",
        .add    = jm_ib_add_one,
        .remove = jm_ib_remove_one,
};

static void jm_cq_comp_handler(struct ib_cq *cq, void *context) {
        struct jm_rdma_conn *conn = context;
        struct ib_wc wc;
        struct jm_send_ctx *send;

        /* No idea why it should be called twice. */
        printk("cq comp for id %p\n", conn->jc_id);
        ib_req_notify_cq(cq, IB_CQ_NEXT_COMP);
        while (ib_poll_cq(cq, 1, &wc) == 1) {
                if (wc.opcode != IB_WC_RDMA_WRITE) {
                        printk("completed unknown opcode %d\n", wc.opcode);
                        /* continue; */
                }
                send = (struct jm_send_ctx *)wc.wr_id;
                printk("got send=%p\n", send);
                printk("completed RDMA_WRITE of IO(%Lu, %u)\n",
                       send->s_offset, send->s_size);
                send->s_done = wc.status == IB_WC_SUCCESS ? 1 : -EIO;
                wake_up_all(&send->s_wait);
        }
        ib_req_notify_cq(cq, IB_CQ_NEXT_COMP);
}

static void jm_cq_event_handler(struct ib_event *cause, void *context) {
        printk(KERN_ERR "got cq event %d\n", cause->event);
}

static void jm_qp_event_handler(struct ib_event *event, void *data) {
        switch (event->event) {
        case IB_EVENT_PATH_MIG:
        case IB_EVENT_COMM_EST:
        case IB_EVENT_SQ_DRAINED:
        case IB_EVENT_QP_LAST_WQE_REACHED:
                printk("got QP event %d received for QP=%p\n",
                       event->event, event->element.qp);
                break;
                /* These are considered fatal events */
        case IB_EVENT_PATH_MIG_ERR:
        case IB_EVENT_QP_FATAL:
        case IB_EVENT_QP_REQ_ERR:
        case IB_EVENT_QP_ACCESS_ERR:
        case IB_EVENT_DEVICE_FATAL:
        default:
                printk("got QP ERROR event %d for QP=%p\n",
                       event->event, event->element.qp);
                break;
        }
}

static int jm_setup_qp(struct jm_rdma_conn *conn, int outgoing) {
        struct ib_qp_init_attr iattr;
        int ret = 0;

        /* protection domain and memory region */
        conn->jc_mr = jm_ibdev->mr;
        conn->jc_pd = jm_ibdev->pd;

        /* create completion queue */
        conn->jc_cq = ib_create_cq(conn->jc_id->device,
                                   jm_cq_comp_handler,
                                   jm_cq_event_handler,
                                   conn, 16, 0);
        if (IS_ERR(conn->jc_cq)) {
                ret = PTR_ERR(conn->jc_cq);
                conn->jc_cq = NULL;
                printk("create cq failed: %d\n", ret);
                return ret;
        }
        if (outgoing)
                ret = ib_req_notify_cq(conn->jc_cq, IB_CQ_NEXT_COMP);
        else
                ret = ib_req_notify_cq(conn->jc_cq, IB_CQ_SOLICITED);
        if (ret) {
                printk("notify cq failed: %d\n", ret);
                goto out_destroy_cq;
        }

        /* create queue pair */
        memset(&iattr, 0, sizeof(iattr));
        if (outgoing) {
                iattr.cap.max_send_wr   = 16;
                iattr.cap.max_send_sge  = 16;
                iattr.cap.max_recv_wr   = 0;
                iattr.cap.max_recv_sge  = 0;
        } else {
                iattr.cap.max_send_wr   = 0;
                iattr.cap.max_send_sge  = 0;
                iattr.cap.max_recv_wr   = 16;
                iattr.cap.max_recv_sge  = 16;
        }
        iattr.send_cq           = conn->jc_cq;
        iattr.recv_cq           = conn->jc_cq;
        iattr.sq_sig_type       = IB_SIGNAL_REQ_WR;
        iattr.qp_type           = IB_QPT_RC;
        iattr.event_handler     = jm_qp_event_handler;
        iattr.qp_context        = conn;
        ret = rdma_create_qp(conn->jc_id, conn->jc_pd, &iattr);
        if (ret) {
                printk("create qp failed: %d\n", ret);
                goto out_destroy_cq;
        }
        conn->jc_qp = conn->jc_id->qp;
        printk("setup qp done\n");

        return 0;

out_destroy_cq:
        ib_destroy_cq(conn->jc_cq);
        conn->jc_cq = NULL;
        return ret;
}

static int jm_allocate_and_map_mr(struct jm_rdma_conn *conn,
                                        uint32_t mirror_size, struct connect_header *ch) {
        struct ib_phys_buf *ibp = NULL;
        struct page **buf_pages = NULL;
        u64 local_addr, addr;
        int i = 0, ret = -ENOMEM;

        buf_pages = kmalloc(sizeof(struct page *)*mirror_size, GFP_KERNEL);
        if (!buf_pages)
                goto out_free;
        ibp = kmalloc(sizeof(struct ib_phys_buf)*mirror_size, GFP_KERNEL);
        if (!ibp)
                goto out_free;
        for (i = 0; i < mirror_size; i++) {
                buf_pages[i] = alloc_page(GFP_KERNEL);
                if (!buf_pages[i])
                        goto out_free;
                addr = ib_dma_map_page(conn->jc_id->device, buf_pages[i],
                                       0, PAGE_SIZE, DMA_FROM_DEVICE);
                if (ib_dma_mapping_error(conn->jc_id->device, addr)) {
                        __free_page(buf_pages[i]);
                        goto out_free;
                }
                ibp[i].addr = addr;
                ibp[i].size = PAGE_SIZE;
        }
        /* call ib_dma_mapping_error to check for error */
        local_addr = ibp[0].addr;
        conn->jc_map_mr = ib_reg_phys_mr(conn->jc_pd, &ibp[0], mirror_size,
                                         IB_ACCESS_REMOTE_WRITE |
                                         IB_ACCESS_LOCAL_WRITE,
                                         &local_addr);
        if (IS_ERR(conn->jc_map_mr)) {
                ret = PTR_ERR(conn->jc_map_mr);
                conn->jc_map_mr = NULL;
                printk("get DMA mr failed: %d\n", ret);
                goto out_free;
        }
        conn->jc_pb_nsegs = 1;
        conn->jc_pb_segsize = PAGE_SIZE * mirror_size;
        conn->jc_pb_addrs[0] = local_addr;
        conn->jc_pb_rkey = conn->jc_map_mr->rkey;
        ch->addr = local_addr;
        ch->rkey = conn->jc_map_mr->rkey;
        for (i = 0; i < mirror_size; i++) {
                conn->jc_pages[i] = buf_pages[i];
                conn->jc_mappings[i] = ibp[i].addr;
                conn->jc_page_count++;
        }

        return 0;

out_free:
        printk("map mr failed at %d\n", i);
        for (i--; i >= 0; i--) {
                ib_dma_unmap_single(conn->jc_id->device, ibp[i].addr,
                                    PAGE_SIZE, DMA_FROM_DEVICE);
                __free_page(buf_pages[i]);
        }
        if (buf_pages)
                kfree(buf_pages);
        if (ibp)
                kfree(ibp);
        return ret;
}

static int jm_rdma_cm_event_handler(struct rdma_cm_id *id, struct rdma_cm_event *event) {
        struct jm_rdma_conn *conn = id->context;
        struct ib_qp_init_attr iattr;
        struct ib_qp_attr attr;
        int connstate = 0, ret = 0;
        struct connect_header *ch = NULL;

        printk("event %d comes in for id %p\n", event->event, id);
        switch (event->event) {
        case RDMA_CM_EVENT_CONNECT_REQUEST:
                ch = (struct connect_header*)event->param.conn.private_data;
                if (!ch || (ch->connect_magic != JM_MAGIC)) {
                        printk("Connect request error.\n");
                        ret = -EINVAL;
                        break;
                }
                /* in this case, it is a newly allocated cm_id */
                printk("Connect request, event=%d, mirror_size=%d\n", event->event,
                        ch->mirror_size);
                ret = jm_handle_connect_req(id, &conn, ch->mirror_size);
                break;

        case RDMA_CM_EVENT_ADDR_RESOLVED:
        case RDMA_CM_EVENT_ROUTE_RESOLVED:
                conn->jc_async_rc = 0;
                complete(&conn->jc_done);
                break;

        case RDMA_CM_EVENT_ADDR_ERROR:
                conn->jc_async_rc = -EHOSTUNREACH;
                printk("CM address resolution error\n");
                complete(&conn->jc_done);
                break;
        case RDMA_CM_EVENT_ROUTE_ERROR:
                conn->jc_async_rc = -ENETUNREACH;
                printk("CM route resolution error\n");
                complete(&conn->jc_done);
                break;

        case RDMA_CM_EVENT_ESTABLISHED:
                connstate = 1;
                ib_query_qp(id->qp, &attr,
                            IB_QP_MAX_QP_RD_ATOMIC | IB_QP_MAX_DEST_RD_ATOMIC,
                            &iattr);
                printk("%d responder resources (%d initiator)\n",
                       attr.max_dest_rd_atomic, attr.max_rd_atomic);
                jm_add_conn_to_list(conn);
                goto connected;

        case RDMA_CM_EVENT_CONNECT_ERROR:
                connstate = -ENOTCONN;
                goto connected;
        case RDMA_CM_EVENT_UNREACHABLE:
                connstate = -ENETDOWN;
                goto connected;
        case RDMA_CM_EVENT_REJECTED:
                connstate = -ECONNREFUSED;
                goto connected;
        case RDMA_CM_EVENT_DISCONNECTED:
                connstate = -ECONNABORTED;
                goto connected;

        case RDMA_CM_EVENT_DEVICE_REMOVAL:
                printk("Device removal id=%p\n", id);
                connstate = -ENODEV;
connected:
                printk("%pI4:%u (event 0x%x)\n",
                       &conn->jc_remoteaddr.sin_addr.s_addr,
                       ntohs(conn->jc_remoteaddr.sin_port),
                       event->event << 11);
                conn->jc_connstate = connstate;
                wake_up_all(&conn->jc_connect_wait);
                break;

        default:
                printk("unexpected CM event %d on id %p\n", event->event, id);
                break;
        }

        return ret;
}

static int jm_conn_open(struct jm_rdma_conn *conn, struct sockaddr *addr) {
        struct rdma_cm_id *id;
        int ret = 0;

        init_completion(&conn->jc_done);

        /* create interface device */
        id = rdma_create_id(jm_rdma_cm_event_handler, conn, RDMA_PS_TCP);
        if (IS_ERR(id)) {
                ret = PTR_ERR(id);
                printk("create RDMA id failed: %d\n", ret);
                goto out;
        }
        conn->jc_id = id;

        conn->jc_async_rc = -ETIMEDOUT;
        ret = rdma_resolve_addr(id, NULL, addr, RDMA_RESOLVE_TIMEOUT);
        if (ret) {
                printk("RDMA resolve addr failed: %d\n", ret);
                goto out_destroy_id;
        }
        wait_for_completion_interruptible_timeout(&conn->jc_done,
                                msecs_to_jiffies(RDMA_RESOLVE_TIMEOUT) + 1);
        ret = conn->jc_async_rc;
        if (ret)
                goto out_destroy_id;
        conn->jc_remoteaddr = *(struct sockaddr_in *)addr;

        conn->jc_async_rc = -ETIMEDOUT;
        ret = rdma_resolve_route(id, RDMA_RESOLVE_TIMEOUT);
        if (ret) {
                printk("RDMA resolve route failed: %d\n", ret);
                goto out_destroy_id;
        }
        wait_for_completion_interruptible_timeout(&conn->jc_done,
                                  msecs_to_jiffies(RDMA_RESOLVE_TIMEOUT) + 1);
        ret = conn->jc_async_rc;
        if (ret)
                goto out_destroy_id;
        printk("open conn ok\n");
        return 0;

out_destroy_id:
        rdma_destroy_id(conn->jc_id);
        conn->jc_id = NULL;
out:
        return ret;
}

static void jm_conn_close(struct jm_rdma_conn *conn) {
        if (conn->jc_qp) {
                rdma_destroy_qp(conn->jc_id);
                conn->jc_qp = NULL;
        }
        if (conn->jc_map_mr) {
                int i = conn->jc_page_count - 1;

                for (; i >= 0; i--) {
                        ib_dma_unmap_single(conn->jc_id->device,
                                            conn->jc_mappings[i],
                                            PAGE_SIZE, DMA_FROM_DEVICE);
                        conn->jc_mappings[i] = 0;
                        __free_page(conn->jc_pages[i]);
                        conn->jc_pages[i] = NULL;
                        conn->jc_page_count--;
                }
                ib_dereg_mr(conn->jc_map_mr);
                conn->jc_map_mr = NULL;
        }
        if (conn->jc_cq) {
                ib_destroy_cq(conn->jc_cq);
                conn->jc_cq = NULL;
        }
        if (conn->jc_id) {
                rdma_destroy_id(conn->jc_id);
                conn->jc_id = NULL;
        }
}

static int jm_connect(struct jm_rdma_conn *conn) {
        struct rdma_conn_param conn_param;
        struct connect_header header;
        int ret;

        ret = jm_setup_qp(conn, 1);
        if (ret)
                goto out;

        /* connect server */
        init_waitqueue_head(&conn->jc_connect_wait);
        conn->jc_connstate = 0;

        memset(&conn_param, 0, sizeof(conn_param));
        memset(&header, 0, sizeof(header));
        header.connect_magic = JM_MAGIC;
        header.mirror_size = RECV_PAGES;
        conn_param.private_data = &header;
        conn_param.private_data_len = sizeof(header);
        conn_param.initiator_depth = 1;
        conn_param.retry_count = 7;
        ret = rdma_connect(conn->jc_id, &conn_param);
        if (ret) {
                printk("RDMA connect failed: %d\n", ret);
                goto out;
        }
        wait_event_interruptible(conn->jc_connect_wait,
                                 conn->jc_connstate != 0);
        if (conn->jc_connstate < 0)
                ret = conn->jc_connstate;
out:
        return ret;
}

static int jm_disconnect(struct jm_rdma_conn *conn) {
        struct ib_wc wc;
        int flush_count = 0;
        int ret;

        if (conn->jc_connstate <= 0)
                return 0;

        while (ib_poll_cq(conn->jc_cq, 1, &wc) == 1)
                ++flush_count;
        printk("id(%p) is to disconnect, %d events flushed\n",
               conn->jc_id, flush_count);
        ret = rdma_disconnect(conn->jc_id);
        if (ret) {
                printk("unable to perform disconnect: %d\n", ret);
                conn->jc_connstate = ret;
        } else {
                wait_event_interruptible(conn->jc_connect_wait,
                                         conn->jc_connstate != 1);
                printk("id(%p) after disconnect, connstate is %d\n",
                       conn->jc_id, conn->jc_connstate);
        }

        return ret;
}

/* receiver side */
static int jm_handle_connect_req(struct rdma_cm_id *id,
                                 struct jm_rdma_conn **rconn, uint32_t mirror_size) {
        struct rdma_conn_param conn_param;
        struct jm_rdma_conn *conn;
        int ret = 0, destroy = 1;
        struct connect_header ch;

        memset(&ch, 0, sizeof(ch));
        if (mirror_size > RECV_PAGES) {
                ret = -EINVAL;
                goto out_reject;
        }
        conn = kzalloc(sizeof(*conn), GFP_KERNEL);
        if (!conn) {
                ret = -ENOMEM;
                goto out_reject;
        }

        init_waitqueue_head(&conn->jc_connect_wait);
        conn->jc_connstate = 0;

        conn->jc_id = id;
        id->context = conn;
        ret = jm_setup_qp(conn, 0);
        if (ret) {
                kfree(conn);
                conn = NULL;
                goto out_reject; 
        }

        memset(&conn_param, 0, sizeof(conn_param));
        /* XXX tune these? */
        conn_param.responder_resources = 1;
        conn_param.initiator_depth = 1;
        conn_param.retry_count = 7;
        conn_param.rnr_retry_count = 7;

        ch.connect_magic = JM_MAGIC;
        ch.mirror_size = mirror_size;
        conn_param.private_data = &ch;
        conn_param.private_data_len = sizeof(ch);
        printk("allocating memory and map it for receiver\n");
        if ((ret = jm_allocate_and_map_mr(conn, mirror_size, &ch))) {
                printk("failed to allocate and map mr: %d\n", ret);
                goto out_reject;
        }
        /* rdma_accept() calls rdma_reject() internally if it fails */
        ret = rdma_accept(id, &conn_param);
        if (!ret)
                conn->jc_connstate = 1;

        conn->jc_incoming = 1;
        *rconn = conn;
        return 0;

out_reject:
        rdma_reject(id, NULL, 0);
        return destroy;
}

-- 
Ding Dinghua
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

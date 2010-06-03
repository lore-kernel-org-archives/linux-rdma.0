From: Bryan Green <bryan.d.green-NSQ8wuThN14@public.gmane.org>
Subject: Re: librdmacm: select() gives false positive on cm channel file descriptor
Date: Thu, 03 Jun 2010 11:33:38 -0700
Message-ID: <20100603183338.229F222BCB@vis06.nas.nasa.gov>
References: <CF9C39F99A89134C9CF9C4CCB68B8DDF255F4634BE@orsmsx501.amr.corp.intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: Your message of "Thu, 03 Jun 2010 11:06:04 CDT."
             <CF9C39F99A89134C9CF9C4CCB68B8DDF255F4634BE-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

"Hefty, Sean" writes:
> > Any insights into what the problem might be?
> > I can provide code for a simple client and server that demonstrate the
> > problem.
> > I've been testing on a system with SLES 10, and the librdmacm version
> > appears
> > to be 1.0.11.
> 
> I believe that uDAPL once (or still does) use poll() to check for CQ, async
> , and communication events, and I'm not aware of any problems with it.  (It
>  may set the fd's to non-blocking though.)  The only thing different on the
>  server side is that it queues connection request events.
> 
> Can you post the code?
> 
> - Sean

Sure.  Here is the code for the client and the server.  Thank you for taking
a look at it.  I wouldn't be terribly surprised if it turns out I am doing
something naive.


//////////////////////////////////////////////////////////////////////////
// server.c
//////////////////////////////////////////////////////////////////////////
#include <stdlib.h>
#include <unistd.h>
#include <assert.h>
#include <errno.h>
#include <sys/select.h>
#include <stdio.h>
#include <string.h>

#include <rdma/rdma_cma.h>

static const char *wc_status_str[] = {
        "IBV_WC_SUCCESS",
        "IBV_WC_LOC_LEN_ERR",
        "IBV_WC_LOC_QP_OP_ERR",
        "IBV_WC_LOC_EEC_OP_ERR",
        "IBV_WC_LOC_PROT_ERR",
        "IBV_WC_WR_FLUSH_ERR",
        "IBV_WC_MW_BIND_ERR",
        "IBV_WC_BAD_RESP_ERR",
        "IBV_WC_LOC_ACCESS_ERR",
        "IBV_WC_REM_INV_REQ_ERR",
        "IBV_WC_REM_ACCESS_ERR",
        "IBV_WC_REM_OP_ERR",
        "IBV_WC_RETRY_EXC_ERR",
        "IBV_WC_RNR_RETRY_EXC_ERR",
        "IBV_WC_LOC_RDD_VIOL_ERR",
        "IBV_WC_REM_INV_RD_REQ_ERR",
        "IBV_WC_REM_ABORT_ERR",
        "IBV_WC_INV_EECN_ERR",
        "IBV_WC_INV_EEC_STATE_ERR",
        "IBV_WC_FATAL_ERR",
        "IBV_WC_RESP_TIMEOUT_ERR",
        "IBV_WC_GENERAL_ERR"
};

struct TAP_Control_;

typedef struct TAP_node_ {
    struct TAP_Control_ *cb;
    struct rdma_cm_id *cm_id;
    struct ibv_cq *cq;
    struct ibv_pd *pd;
    struct ibv_qp *qp;
    struct ibv_comp_channel *comp_channel;
    struct ibv_mr *rdma_mr;
    int connected;
} TAP_node;

// control block
typedef struct TAP_Control_ {
    struct rdma_event_channel *cm_channel;
    struct rdma_cm_id *listen_cm_id;

    struct ibv_context *context;

    TAP_node* node;
} TAP_Control;

void myerror(const char *msg, int res)
{
    if (res == -1)
        fprintf(stdout, "%s: %s\n", msg, strerror(errno));
    else
        fprintf(stdout, "%s: %d\n", msg, res);
}

//--------------------------------------------------------------------------
// RDMA routines

int tap_get_cm_event(TAP_Control *cb,
                     enum rdma_cm_event_type expected_state)
{
    int ret;
    struct rdma_cm_event *event;
    TAP_node *node;

    printf("    (rdma_get_cm_event)\n");
    if ((ret=rdma_get_cm_event(cb->cm_channel, &event))) {
        myerror("rdma_get_cm_event", ret);
        return -1;
    }

    ret = 0;
    node = (TAP_node*)event->id->context;

    switch (event->event) {
        case RDMA_CM_EVENT_ADDR_RESOLVED:
            if (expected_state != event->event) {
                printf( "not expecting ADDR_RESOLVED!\n");
                ret = -1;
            }
            break;
        case RDMA_CM_EVENT_ROUTE_RESOLVED:
            if (expected_state != event->event) {
                printf( "not expecting ROUTE_RESOLVED!\n");
                ret = -1;
            }
            break;
        case RDMA_CM_EVENT_ESTABLISHED:
            if (expected_state != event->event) {
                printf( "not expecting ESTABLISHED!\n");
                ret = -1;
            }
            break;
        case RDMA_CM_EVENT_ADDR_ERROR:
        case RDMA_CM_EVENT_ROUTE_ERROR:
        case RDMA_CM_EVENT_CONNECT_ERROR:
        case RDMA_CM_EVENT_UNREACHABLE:
        case RDMA_CM_EVENT_REJECTED:
            printf( "event: %s, error: %d\n",
                 rdma_event_str(event->event), event->status);
            ret = -1;
            break;
        case RDMA_CM_EVENT_DISCONNECTED:
            printf("event: %s\n",
                 rdma_event_str(event->event));
            rdma_disconnect(event->id);
            node->connected = 0;
            if (expected_state != event->event) {
                printf( "not expecting DISCONNECTED!\n");
                ret = -1;
            }
            break;
        case RDMA_CM_EVENT_DEVICE_REMOVAL:
            printf("event: %s\n", rdma_event_str(event->event));
            ret = -1;
            break;
        default:
            printf("event: %s\n", rdma_event_str(event->event));
            if (expected_state != event->event) {
                printf( "unexpected rdma_cm event!\n");
                ret = -1;
            }
            break;
    }

    rdma_ack_cm_event(event);
    return ret;
}

TAP_node *tap_create_node(struct rdma_cm_id *id,TAP_Control *cb)
{
    TAP_node *node = (TAP_node *)malloc(sizeof(TAP_node));
    if (!node) {
        perror("malloc(TAP_node)");
        return NULL;
    }

    int ret;

    node->cb = cb;

    node->cm_id = id;
    node->cm_id->context = node;

    if (cb->context == 0)
        cb->context = node->cm_id->verbs;

    assert(cb->context == node->cm_id->verbs);

    node->pd = ibv_alloc_pd(node->cm_id->verbs);
    if (!node->pd) {
        perror("ibv_alloc_pd");
        free(node);
        return NULL;
    }

    node->comp_channel = ibv_create_comp_channel(node->cm_id->verbs);
    if (!node->comp_channel) {
        perror("ibv_create_comp_channel");
        ibv_dealloc_pd(node->pd);
        free(node);
        return NULL;
    }

    node->cq = ibv_create_cq(node->cm_id->verbs, 2, node, node->comp_channel, 0);
    if (!node->cq) {
        perror("ibv_create_cq");
        ibv_destroy_comp_channel(node->comp_channel);
        ibv_dealloc_pd(node->pd);
        free(node);
        return NULL;
    }

    struct ibv_qp_init_attr init_attr;
    memset(&init_attr, 0, sizeof(init_attr));
    init_attr.cap.max_send_wr = 2;
    init_attr.cap.max_recv_wr = 2;
    init_attr.cap.max_recv_sge = 1;
    init_attr.cap.max_send_sge = 1;
    init_attr.qp_context = node;
    init_attr.qp_type = IBV_QPT_RC;
    init_attr.send_cq = node->cq;
    init_attr.recv_cq = node->cq;

    if ((ret=rdma_create_qp(node->cm_id, node->pd, &init_attr)) != 0) {
        myerror("rdma_create_qp", ret);
        ibv_destroy_cq(node->cq);
        ibv_destroy_comp_channel(node->comp_channel);
        ibv_dealloc_pd(node->pd);
        free(node);
        return NULL;
    }

    node->qp = node->cm_id->qp;

    node->connected = 0;

    return node;
}

void tap_free_node(TAP_node *node)
{
    int res;
    assert(!node->connected);
    ibv_destroy_qp(node->qp);
    ibv_destroy_cq(node->cq);
    ibv_destroy_comp_channel(node->comp_channel);
    ibv_dealloc_pd(node->pd);
    rdma_destroy_id(node->cm_id);
    free(node);
}

TAP_Control *tap_create()
{
    TAP_Control *cb = (TAP_Control*)malloc(sizeof(TAP_Control));
    if (!cb) {
        perror("malloc");
        return 0;
    }

    int r;

    memset(cb, 0, sizeof(*cb));

    // create channel to receive rdma_cm events
    cb->cm_channel = rdma_create_event_channel();
    if (!cb->cm_channel) {
        perror("rdma_create_event_channel");
        free(cb);
        return 0;
    }

    // create rdma_cm id (analogous to a socket id)
    if ((r=rdma_create_id(cb->cm_channel, &cb->listen_cm_id, cb, RDMA_PS_TCP)))
    {
        myerror("rdma_create_id", r);
        rdma_destroy_event_channel(cb->cm_channel);
        free(cb);
        return 0;
    }

    return cb;
}

void tap_free(TAP_Control *cb)
{
    int res;

    TAP_node *node = cb->node;
    if (cb->node->connected) {
        printf( "disconnecting\n");
        if ((res=rdma_disconnect(cb->node->cm_id)))
            myerror("rdma_disconnect", res);
        else
            cb->node->connected = 0;
    }

    struct rdma_cm_event *event;
    while (cb->node->connected) {
        printf( "waiting for disconnect\n");

        if ((res=rdma_get_cm_event(cb->cm_channel, &event))) {
            myerror("rdma_get_cm_event", res);
            break;
        }

        if (event->event == RDMA_CM_EVENT_DISCONNECTED) {
            printf( "got DISCONNECTED event\n");
            cb->node->connected = 0;
        }
        else
            printf( "unexpected event: %s\n",
                 rdma_event_str(event->event));

        rdma_ack_cm_event(event);
    }

    tap_free_node(cb->node);
    cb->node = 0;

    rdma_destroy_id(cb->listen_cm_id);
    rdma_destroy_event_channel(cb->cm_channel);
    free(cb);
}

int tap_bind(TAP_Control *cb,int port)
{
    int ret;

    struct sockaddr_in addr;
    memset(&addr, 0, sizeof(addr));
    addr.sin_family = AF_INET;
    addr.sin_addr.s_addr = INADDR_ANY;
    addr.sin_port = htons(port);

    if ((ret=rdma_bind_addr(cb->listen_cm_id, (struct sockaddr *)&addr)) != 0) {
        myerror("rdma_bind_addr", ret);
        return -1;
    }

    if ((ret=rdma_listen(cb->listen_cm_id, 128)) != 0) {
        myerror("rdma_listen", ret);
        return -1;
    }

    printf("listening on port %d\n", port);

    return 0;
}

int tap_accept(TAP_Control *cb)
{
    int connected = 0;
    int res;

    struct rdma_conn_param conn_param;
    memset(&conn_param, 0, sizeof(conn_param));
    conn_param.responder_resources = 1;
    conn_param.initiator_depth = 1;
    struct rdma_cm_event *event;

    while (!connected) {
        printf( "waiting for a cm event\n");

        event = 0;
        int ret;
        if ((ret=rdma_get_cm_event(cb->cm_channel, &event))) {
            myerror("rdma_get_cm_event", ret);
            break;
        }

        TAP_node *node;

        if (event->event == RDMA_CM_EVENT_CONNECT_REQUEST) {
            printf( "got a connection request\n");

            node = tap_create_node(event->id,cb);
            if (!node)
                break;

            cb->node = node;

            if ((ret=rdma_accept(node->cm_id, &conn_param)) != 0) {
                myerror("rdma_accept", ret);
                break;
            }
        }
        else if (event->event == RDMA_CM_EVENT_ESTABLISHED) {
            node = (TAP_node*)event->id->context;

            printf( "established connection\n");

            connected = node->connected = 1;

            break;
        }
        else if (event->event == RDMA_CM_EVENT_DISCONNECTED) {
            node = (TAP_node*)event->id->context;
            printf( "got disconnect event\n");
            assert(node->connected);
            if ((res=rdma_disconnect(node->cm_id)))
                myerror("rdma_disconnect", res);
            node->connected = 0;
            break;
        }
        else {
            printf( "unexpected event: %s\n",
                 rdma_event_str(event->event));
            break;
        }

        rdma_ack_cm_event(event);
    }

    if (event)
        rdma_ack_cm_event(event);

    if (!connected)
        return -1;

    return 0;
}

int tap_post_send(TAP_Control *cb)
{
    int res;
    struct ibv_send_wr send_wr, *bad_tx_wr;

    send_wr.wr_id = 2;
    send_wr.sg_list = 0;
    send_wr.num_sge = 0;
    send_wr.next = 0;
    send_wr.opcode = IBV_WR_SEND_WITH_IMM;
    send_wr.imm_data = 0xcaca;
    send_wr.send_flags =
        (enum ibv_send_flags)(IBV_SEND_SIGNALED | IBV_SEND_SOLICITED);

    TAP_node *node = cb->node;

    if ((res=ibv_req_notify_cq(node->cq, 0)) != 0) {
        myerror("ibv_req_notify_cq", res);
        return -1;
    }

    printf("sending imm %x\n", (unsigned)send_wr.imm_data);

    // tell the node that we are ready for timestep data
    if ((res=ibv_post_send(node->qp, &send_wr, &bad_tx_wr)) != 0) {
        myerror("ibv_post_send", res);
        return -1;
    }

    return 0;
}

int tap_wait(TAP_Control *cb)
{
    int res, n;
    struct ibv_cq *ev_cq;
    void *ev_ctx;
    TAP_node *node = cb->node;

    fd_set fds, nfds;
    int fdcnt = 0;

    FD_ZERO(&fds);

    assert (cb->cm_channel->fd != node->comp_channel->fd);

    // watch for rdma_cm event:
    // why does this return readable when there are no events?!
    FD_SET(cb->cm_channel->fd, &fds);
    if (cb->cm_channel->fd > fdcnt)
        fdcnt = cb->cm_channel->fd;

    // watch for completion event
    FD_SET(node->comp_channel->fd, &fds);
    if (node->comp_channel->fd > fdcnt)
        fdcnt = node->comp_channel->fd;

    ++fdcnt;

    printf("    (select)\n");
    nfds = fds;
    res = select(fdcnt, &nfds, 0, 0, 0);
    if (res == -1) {
        perror("select");
        return -1;
    }

    if (FD_ISSET(cb->cm_channel->fd, &fds)) {
        // got a disconnect event?
        printf( "event pending on connection channel\n");
        tap_get_cm_event(cb, RDMA_CM_EVENT_DISCONNECTED);
        return -1;
    }

    assert(FD_ISSET(node->comp_channel->fd, &fds));

    struct ibv_wc wc;
    int pollcnt = 0;

    printf("polling...\n");

    if ((res=ibv_get_cq_event(node->comp_channel, &ev_cq, &ev_ctx)) < 0) {
        myerror("ibv_get_cq_event", res);
        return -1;
    }

    assert(ev_cq == node->cq);

    ibv_ack_cq_events(ev_cq, 1);

    int completions = 0;
    while (completions < 1) {
        if ((res=ibv_poll_cq(node->cq, 1, &wc)) < 0) {
            myerror("ibv_poll_cq", res);
            return -1;
        }

        ++pollcnt;

        if (res == 0)
            continue;

        assert(res == 1);
        completions += res;

        if (wc.status != IBV_WC_SUCCESS) {
            printf("wc %lu error: %d %s\n",
                 (unsigned long)wc.wr_id,
                 wc.status, wc_status_str[wc.status]);
            return -1;
        }

        printf("received WC id %u (after %d polls)\n",
             (unsigned)wc.wr_id, pollcnt);

    }

    return 0;
}

int main(int argc,char *argv[])
{
    TAP_Control *cb = tap_create();

    if (tap_bind(cb, 15555))
        return 1;

    if (tap_accept(cb))
        return 1;

    tap_post_send(cb);

    while (tap_wait(cb) == 0)
        ;

    tap_free(cb);

    return 0;
}

//////////////////////////////////////////////////////////////////////////
// client.c
//////////////////////////////////////////////////////////////////////////
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <sys/select.h>
#include <netinet/in.h>
#include <netinet/tcp.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <unistd.h>
#include <string.h>
#include <errno.h>
#include <assert.h>

#include <rdma/rdma_cma.h>

static const char *wc_status_str[] = {
        "IBV_WC_SUCCESS",
        "IBV_WC_LOC_LEN_ERR",
        "IBV_WC_LOC_QP_OP_ERR",
        "IBV_WC_LOC_EEC_OP_ERR",
        "IBV_WC_LOC_PROT_ERR",
        "IBV_WC_WR_FLUSH_ERR",
        "IBV_WC_MW_BIND_ERR",
        "IBV_WC_BAD_RESP_ERR",
        "IBV_WC_LOC_ACCESS_ERR",
        "IBV_WC_REM_INV_REQ_ERR",
        "IBV_WC_REM_ACCESS_ERR",
        "IBV_WC_REM_OP_ERR",
        "IBV_WC_RETRY_EXC_ERR",
        "IBV_WC_RNR_RETRY_EXC_ERR",
        "IBV_WC_LOC_RDD_VIOL_ERR",
        "IBV_WC_REM_INV_RD_REQ_ERR",
        "IBV_WC_REM_ABORT_ERR",
        "IBV_WC_INV_EECN_ERR",
        "IBV_WC_INV_EEC_STATE_ERR",
        "IBV_WC_FATAL_ERR",
        "IBV_WC_RESP_TIMEOUT_ERR",
        "IBV_WC_GENERAL_ERR"
};

// control block
struct TAP_Control {
    struct rdma_event_channel *cm_channel;
    struct rdma_cm_id *cm_id;
    int connected;
    struct ibv_cq *cq;
    struct ibv_pd *pd;
    struct ibv_qp *qp;
    struct ibv_comp_channel *channel;
};

void myerror(const char *msg, int res)
{
    if (res == -1)
        printf("%s: %s\n", msg, strerror(errno));
    else
        printf("%s: %d %s\n", msg, res, strerror(res));
}

int tap_get_cm_event(struct TAP_Control *cb,
                     enum rdma_cm_event_type expected_state)
{
    int ret;
    struct rdma_cm_event *event;
    printf("    (rdma_get_cm_event)\n");
    if ((ret=rdma_get_cm_event(cb->cm_channel, &event))) {
        myerror("rdma_get_cm_event", ret);
        return -1;
    }

    ret = 0;

    switch (event->event) {
        case RDMA_CM_EVENT_ADDR_RESOLVED:
            if (expected_state != event->event) {
                printf("not expecting ADDR_RESOLVED!\n");
                ret = -1;
            }
            break;
        case RDMA_CM_EVENT_ROUTE_RESOLVED:
            if (expected_state != event->event) {
                printf("not expecting ROUTE_RESOLVED!\n");
                ret = -1;
            }
            break;
        case RDMA_CM_EVENT_ESTABLISHED:
            if (expected_state != event->event) {
                printf("not expecting ESTABLISHED!\n");
                ret = -1;
            }
            else {
                cb->connected = 1;
            }
            break;
        case RDMA_CM_EVENT_ADDR_ERROR:
        case RDMA_CM_EVENT_ROUTE_ERROR:
        case RDMA_CM_EVENT_CONNECT_ERROR:
        case RDMA_CM_EVENT_UNREACHABLE:
        case RDMA_CM_EVENT_REJECTED:
            printf("event: %s, error: %d; expected %s\n",
                    rdma_event_str(event->event), event->status,
                    rdma_event_str(expected_state));
            if (event->event == RDMA_CM_EVENT_ADDR_ERROR ||
                event->event == RDMA_CM_EVENT_ROUTE_ERROR)
                ret = -2;
            else
                ret = -1;
            break;
        case RDMA_CM_EVENT_DISCONNECTED:
            printf("event: %s\n", rdma_event_str(event->event));
            rdma_disconnect(event->id);
            cb->connected = 0;
            if (expected_state != event->event) {
                printf("    expected %s!\n",
                        rdma_event_str(expected_state));
                ret = -1;
            }
            break;
        case RDMA_CM_EVENT_DEVICE_REMOVAL:
            printf("event: %s\n", rdma_event_str(event->event));
            if (expected_state != event->event) {
                printf("    expected %s!\n",
                        rdma_event_str(expected_state));
                ret = -1;
            }
            ret = -1;
            break;
        default:
            printf("event: %s\n", rdma_event_str(event->event));
            if (expected_state != event->event) {
                printf("    expected %s!\n",
                        rdma_event_str(expected_state));
                ret = -1;
            }
            break;
    }

    rdma_ack_cm_event(event);
    return ret;
}


int tap_setup_qp(struct TAP_Control *cb)
{
    int ret;

    cb->pd = ibv_alloc_pd(cb->cm_id->verbs);
    if (!cb->pd) {
        printf("ibv_alloc_pd failed\n");
        return -1;
    }

    cb->channel = ibv_create_comp_channel(cb->cm_id->verbs);
    if (!cb->channel) {
        printf("ibv_create_comp_channel failed\n");
        goto fail1;
    }

    cb->cq = ibv_create_cq(cb->cm_id->verbs, 2, 0, cb->channel, 0);
    if (!cb->cq) {
        myerror("ibv_create_cq",-1);
        goto fail2;
    }

    struct ibv_qp_init_attr init_attr;
    memset(&init_attr, 0, sizeof(init_attr));
    init_attr.cap.max_send_wr = 1;
    init_attr.cap.max_send_sge = 1;
    init_attr.cap.max_recv_wr = 2;
    init_attr.cap.max_recv_sge = 1;
    init_attr.qp_type = IBV_QPT_RC;
    init_attr.sq_sig_all = 0;
    init_attr.send_cq = cb->cq;
    init_attr.recv_cq = cb->cq;

    if ((ret=rdma_create_qp(cb->cm_id, cb->pd, &init_attr)) != 0) {
        myerror("rdma_create_qp", ret);
        goto fail3;
    }

    cb->qp = cb->cm_id->qp;

    return 0;

fail3:
    ibv_destroy_cq(cb->cq);
fail2:
    ibv_destroy_comp_channel(cb->channel);
fail1:
    ibv_dealloc_pd(cb->pd);
    cb->cq = 0;
    cb->channel = 0;
    cb->pd = 0;
    return -1;
}

struct TAP_Control *tap_create(const char *addr,int port)
{
    int ret, nretries;
    struct sockaddr_in saddr_in;
    struct addrinfo *info;
    struct addrinfo hints;
    memset(&hints,0,sizeof(hints));
    hints.ai_family = AF_INET;
    hints.ai_flags = AI_CANONNAME;
    int r = getaddrinfo(addr, 0, &hints, &info);
    if (r) {
        printf("getaddrinfo(%s): %s\n", addr, gai_strerror(r));
        return 0;
    }

    printf("connecting to '%s:%d'\n",
           info->ai_canonname, port);

    saddr_in = *(struct sockaddr_in*)info->ai_addr;
    saddr_in.sin_port = htons((in_port_t)port);
    freeaddrinfo(info);

    struct TAP_Control *cb = malloc(sizeof(struct TAP_Control));
    if (!cb) {
        perror("malloc");
        return 0;
    }

    memset(cb, 0, sizeof(*cb));

    cb->connected = 0;

    // create channel to receive rdma_cm events
    cb->cm_channel = rdma_create_event_channel();
    if (!cb->cm_channel) {
        myerror("rdma_create_event_channel",-1);
        goto fail1;
    }

    // create rdma_cm id (analogous to a socket id)
    if ((ret=rdma_create_id(cb->cm_channel, &cb->cm_id, cb, RDMA_PS_TCP))) {
        myerror("rdma_create_id", ret);
        goto fail2;
    }

    nretries = 9;

    // resolve sink address
try_resolve_addr:
    printf("rdma_cm resolving address (try %d)\n", 10-nretries);
    if ((ret=rdma_resolve_addr(cb->cm_id, NULL, (struct sockaddr *)&saddr_in,
                               2000)))
    {
        myerror("rdma_resolve_addr", ret);
        goto fail3;
    }

    if ((ret=tap_get_cm_event(cb, RDMA_CM_EVENT_ADDR_RESOLVED))) {
        if (ret == -2) {
            // retry
            if (nretries--)
                goto try_resolve_addr;
        }
        goto fail3;
    }

    nretries = 9;

    // resolve route
try_resolve_route:
    printf("rdma_cm resolving route (try %d)\n", 10-nretries);
    if ((ret=rdma_resolve_route(cb->cm_id, 2000)))
    {
        myerror("rdma_resolve_route", ret);
        goto fail3;
    }

    if ((ret=tap_get_cm_event(cb, RDMA_CM_EVENT_ROUTE_RESOLVED))) {
        if (ret == -2) {
            // retry
            if (nretries--)
                goto try_resolve_route;
        }
        goto fail3;
    }

    if (tap_setup_qp(cb))
        goto fail3;

    return cb;

fail3:
    rdma_destroy_id(cb->cm_id);
fail2:
    rdma_destroy_event_channel(cb->cm_channel);
fail1:
    free(cb);
    return 0;
}

void tap_free(struct TAP_Control *cb)
{
    if (cb->connected) {
        int res;
        if ((res=rdma_disconnect(cb->cm_id))) {
            myerror("rdma_disconnect", res);
            //return;
        }
    }

    if (cb->cq) {
        ibv_destroy_cq(cb->cq);
        ibv_destroy_comp_channel(cb->channel);
        ibv_dealloc_pd(cb->pd);
    }

    rdma_destroy_id(cb->cm_id);
    rdma_destroy_event_channel(cb->cm_channel);

    free(cb);
}

int tap_handle_cq_event(struct TAP_Control *cb, unsigned *id)
{
    int res;
    struct ibv_cq *ev_cq;
    void *ev_ctx;

    fd_set fds;
    int fdcnt = 0;

    FD_ZERO(&fds);

    FD_SET(cb->channel->fd, &fds);
    fdcnt = cb->channel->fd + 1;

    FD_SET(cb->cm_channel->fd, &fds);
    if (cb->cm_channel->fd+1 > fdcnt)
        fdcnt = cb->cm_channel->fd+1;

    printf("    (select)\n");
    res = select(fdcnt, &fds, NULL, NULL, 0);
    if (res == -1) {
        myerror("select",-1);
        return -1;
    }

    if (FD_ISSET(cb->cm_channel->fd, &fds)) {
        // got a disconnect event?
        tap_get_cm_event(cb, RDMA_CM_EVENT_DISCONNECTED);
        return -1;
    }

    assert(FD_ISSET(cb->channel->fd,&fds));
    printf("    (ibv_get_cq_event)\n");
    if ((res=ibv_get_cq_event(cb->channel, &ev_cq, &ev_ctx)) < 0) {
        myerror("ibv_get_cq_event", res);
        return -1;
    }

    ibv_ack_cq_events(ev_cq, 1);
    assert(ev_cq == cb->cq);

    struct ibv_wc wc;

    int pollcnt = 0;
    int completions = 0;
    while (completions < 1) {
        if ((res=ibv_poll_cq(cb->cq, 1, &wc)) < 0) {
            myerror("ibv_poll_cq", res);
            return -1;
        }

        ++pollcnt;

        if (res == 0)
            continue;

        assert(res == 1);
        completions += res;

        if (wc.status != IBV_WC_SUCCESS) {
            printf("wc %lu error: %d %s\n",
                    (unsigned long)wc.wr_id,
                    wc.status, wc_status_str[wc.status]);
            return -1;
        }

        printf("    (got wc, id %u, pollcnt %d)\n",
               (unsigned)wc.wr_id, pollcnt);
        if (wc.wc_flags & IBV_WC_WITH_IMM)
            printf("    imm = %x\n", (unsigned)wc.imm_data);
        if (id) *id = wc.wr_id;
    }

    return 0;
}

int tap_connect(struct TAP_Control *cb)
{
    int ret;
    struct rdma_conn_param conn_param;
    memset(&conn_param, 0, sizeof(conn_param));
    conn_param.responder_resources = 1;
    conn_param.initiator_depth = 1;
    conn_param.retry_count = 10;

    printf("rdma_cm connecting\n");
    if ((ret=rdma_connect(cb->cm_id, &conn_param))) {
        myerror("rdma_connect", ret);
        return -1;
    }

    if (tap_get_cm_event(cb, RDMA_CM_EVENT_ESTABLISHED))
        return -1;

    printf("rdma_cm connect successful\n");

    return 0;
}

int tap_post_recv(struct TAP_Control *cb,int id)
{
    int res;
    struct ibv_recv_wr wr, *bad_wr;

    if ((res=ibv_req_notify_cq(cb->cq, 0)) != 0) {
        myerror("ibv_req_notify_cq", res);
        return -1;
    }

    wr.wr_id = id;
    wr.sg_list = NULL;
    wr.num_sge = 0;
    wr.next = NULL;

    if ((res=ibv_post_recv(cb->qp, &wr, &bad_wr)) != 0) {
        myerror("ibv_post_recv", res);
        return -1;
    }

    return 0;
}

int tap_complete_work(struct TAP_Control *cb,unsigned id)
{
    int res;
    unsigned wr_id;
    if ((res=tap_handle_cq_event(cb, &wr_id)))
        return -1;
    if (wr_id != id) {
        printf("unexpected wr_id: %u != %u\n",
                wr_id, id);
        return -1;
    }

    return 0;
}

#define RECV_ID 11000

int main(int argc,char *argv[])
{
    struct TAP_Control *cb = tap_create("localhost",15555);
    if (!cb)
        return 1;

    if (tap_post_recv(cb,RECV_ID)) {
        tap_free(cb);
        return 1;
    }

    if (tap_connect(cb)) {
        tap_free(cb);
        return 1;
    }

    printf("waiting for recv id %d\n", RECV_ID);
    if (tap_complete_work(cb,RECV_ID)) {
        tap_free(cb);
        return -1;
    }

    printf("sleeping\n");
    sleep(5);

    printf("cleaning up\n");
    tap_free(cb);

    printf("finished\n");

    return 0;
}

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

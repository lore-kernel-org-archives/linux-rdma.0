From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/3] ibacm: enhance debug messages
Date: Tue, 16 Nov 2010 16:10:51 -0800
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B86168B9@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Prefix all log messages with time stamp information.  This
provides useful debugging information regarding the timing of
various operations.

To help match up various operations with each other, improve
and simplify logging of endpoint and destination names.  We
save printable names with all destinations.  The
function to display address information is removed in favor
of using the normal logging function, a call to format address
data, and per thread logging data.

Finally, we add ability to handle LID/GID addresses in acm_log_addr.
This is required to display SA and multicast destination addresses
in the acm log file.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 linux/osd.h   |    1 +
 src/acm.c     |  105 +++++++++++++++++++++++++++++++++++++++------------------
 windows/osd.h |    1 +
 3 files changed, 73 insertions(+), 34 deletions(-)

diff --git a/linux/osd.h b/linux/osd.h
index 28c3647..33ea842 100644
--- a/linux/osd.h
+++ b/linux/osd.h
@@ -148,6 +148,7 @@ static inline uint64_t time_stamp_us(void)

 #define time_stamp_ms() (time_stamp_us() / 1000)

+#define PER_THREAD __thread
 static inline int beginthread(void (*func)(void *), void *arg)
 {
        pthread_t thread;
diff --git a/src/acm.c b/src/acm.c
index 820365c..404d2b5 100644
--- a/src/acm.c
+++ b/src/acm.c
@@ -37,6 +37,7 @@
 #include <osd.h>
 #include <arpa/inet.h>
 #include <sys/stat.h>
+#include <sys/time.h>
 #include <infiniband/acm.h>
 #include <infiniband/umad.h>
 #include <infiniband/verbs.h>
@@ -74,6 +75,7 @@ enum acm_route_prot
 struct acm_dest
 {
        uint8_t                address[ACM_MAX_ADDRESS]; /* keep first */
+       char                   name[ACM_MAX_ADDRESS];
        struct ibv_ah          *ah;
        struct ibv_ah_attr     av;
        struct ibv_path_record path;
@@ -134,6 +136,7 @@ struct acm_ep
        uint8_t               *recv_bufs;
        DLIST_ENTRY           entry;
        union acm_ep_info     addr[MAX_EP_ADDR];
+       char                  name[MAX_EP_ADDR][ACM_MAX_ADDRESS];
        uint8_t               addr_type[MAX_EP_ADDR];
        void                  *dest_map[ACM_ADDRESS_RESERVED - 1];
        struct acm_dest       mc_dest[MAX_EP_MC];
@@ -193,6 +196,7 @@ static struct acm_client client[FD_SETSIZE - 1];

 static FILE *flog;
 static lock_t log_lock;
+PER_THREAD char log_data[ACM_MAX_ADDRESS];

 static char *opts_file = "/etc/ibacm/acm_opts.cfg";
 static char *addr_file = "/etc/ibacm/acm_addr.cfg";
@@ -216,49 +220,53 @@ static uint8_t min_rate = IBV_RATE_10_GBPS;
 static void acm_write(int level, const char *format, ...)
 {
        va_list args;
+       struct timeval tv;

        if (level > log_level)
                return;

+       gettimeofday(&tv, NULL);
        va_start(args, format);
        lock_acquire(&log_lock);
+       fprintf(flog, "%u.%03u: ", (unsigned) tv.tv_sec, (unsigned) (tv.tv_usec / 1000));
        vfprintf(flog, format, args);
        fflush(flog);
        lock_release(&log_lock);
        va_end(args);
 }

-static void acm_log_addr(int level, const char *msg, uint16_t addr_type, uint8_t *addr)
+static void
+acm_format_name(int level, char *name, size_t name_size,
+               uint8_t addr_type, uint8_t *addr, size_t addr_size)
 {
        struct ibv_path_record *path;
-       char ip_addr[ACM_MAX_ADDRESS];

        if (level > log_level)
                return;

-       lock_acquire(&log_lock);
-       fprintf(flog, msg);
        switch (addr_type) {
        case ACM_EP_INFO_NAME:
-               fprintf(flog, "%s\n", addr);
+               memcpy(name, addr, addr_size);
                break;
        case ACM_EP_INFO_ADDRESS_IP:
-               inet_ntop(AF_INET, addr, ip_addr, ACM_MAX_ADDRESS);
-               fprintf(flog, "%s\n", ip_addr);
+               inet_ntop(AF_INET, addr, name, name_size);
                break;
        case ACM_EP_INFO_ADDRESS_IP6:
-               inet_ntop(AF_INET6, addr, ip_addr, ACM_MAX_ADDRESS);
-               fprintf(flog, "%s\n", ip_addr);
+       case ACM_ADDRESS_GID:
+               inet_ntop(AF_INET6, addr, name, name_size);
                break;
        case ACM_EP_INFO_PATH:
                path = (struct ibv_path_record *) addr;
-               fprintf(flog, "path record, SLID 0x%x, DLID 0x%x\n",
+               sprintf(name, "SLID(%d) DLID(%d)",
                        ntohs(path->slid), ntohs(path->dlid));
                break;
+       case ACM_ADDRESS_LID:
+               sprintf(name, "LID(%d)", *((uint16_t *) addr));
+               break;
        default:
-               fprintf(flog, "unknown address 0x%x\n", addr_type);
+               strcpy(name, "Unknown");
+               break;
        }
-       lock_release(&log_lock);
 }

 static int acm_compare_dest(const void *dest1, const void *dest2)
@@ -275,6 +283,7 @@ acm_init_dest(struct acm_dest *dest, uint8_t addr_type, uint8_t *addr, size_t si
        atomic_init(&dest->refcnt);
        atomic_set(&dest->refcnt, 1);
        lock_init(&dest->lock);
+       acm_format_name(0, dest->name, sizeof dest->name, addr_type, addr, size);
 }

 static struct acm_dest *
@@ -289,7 +298,7 @@ acm_alloc_dest(uint8_t addr_type, uint8_t *addr)
        }

        acm_init_dest(dest, addr_type, addr, ACM_MAX_ADDRESS);
-       acm_log(1, "%p\n", dest);
+       acm_log(1, "%s\n", dest->name);
        return dest;
 }

@@ -303,17 +312,20 @@ acm_get_dest(struct acm_ep *ep, uint8_t addr_type, uint8_t *addr)
        if (tdest) {
                dest = *tdest;
                (void) atomic_inc(&dest->refcnt);
+               acm_log(2, "%s\n", dest->name);
        } else {
                dest = NULL;
+               acm_format_name(2, log_data, sizeof log_data,
+                               addr_type, addr, ACM_MAX_ADDRESS);
+               acm_log(2, "%s not found\n", log_data);
        }
-       acm_log(2, "%p\n", dest);
        return dest;
 }

 static void
 acm_put_dest(struct acm_dest *dest)
 {
-       acm_log(2, "%p\n", dest);
+       acm_log(2, "%s\n", dest->name);
        if (atomic_dec(&dest->refcnt) == 0) {
                free(dest);
        }
@@ -324,7 +336,9 @@ acm_acquire_dest(struct acm_ep *ep, uint8_t addr_type, uint8_t *addr)
 {
        struct acm_dest *dest;

-       acm_log_addr(2, "acm_acquire_dest: ", addr_type, addr);
+       acm_format_name(2, log_data, sizeof log_data,
+                       addr_type, addr, ACM_MAX_ADDRESS);
+       acm_log(2, "%s\n", log_data);
        lock_acquire(&ep->lock);
        dest = acm_get_dest(ep, addr_type, addr);
        if (!dest) {
@@ -342,7 +356,7 @@ acm_acquire_dest(struct acm_ep *ep, uint8_t addr_type, uint8_t *addr)
 //static void
 //acm_remove_dest(struct acm_ep *ep, struct acm_dest *dest)
 //{
-//     acm_log_addr(2, "acm_remove_dest: ", dest->addr_type, dest->addr);
+//     acm_log(2, "%s\n", dest->name);
 //     tdelete(dest->address, &ep->dest_map[dest->addr_type - 1], acm_compare_dest);
 //     acm_put_dest(dest);
 //}
@@ -361,7 +375,7 @@ acm_alloc_req(struct acm_client *client, struct acm_resolve_msg *msg)
        (void) atomic_inc(&client->refcnt);
        req->client = client;
        memcpy(&req->msg, msg, sizeof(req->msg));
-       acm_log(2, "%p\n", req);
+       acm_log(2, "client %d, req %p\n", client->index, req);
        return req;
 }

@@ -736,7 +750,7 @@ static uint8_t acm_resolve_path(struct acm_ep *ep, struct acm_dest *dest,
        struct acm_send_msg *msg;
        struct ib_sa_mad *mad;

-       acm_log(2, "\n");
+       acm_log(2, "%s\n", dest->name);
        msg = acm_alloc_send(ep, &ep->port->sa_dest, sizeof(*mad));
        if (!msg) {
                acm_log(0, "ERROR - cannot allocate send msg\n");
@@ -764,7 +778,7 @@ acm_record_acm_addr(struct acm_ep *ep, struct acm_dest *dest, struct ibv_wc *wc,
 {
        int index;

-       acm_log(2, "\n");
+       acm_log(2, "%s\n", dest->name);
        index = acm_best_mc_index(ep, rec);
        if (index < 0) {
                acm_log(0, "ERROR - no shared multicast groups\n");
@@ -814,7 +828,7 @@ acm_send_addr_resp(struct acm_ep *ep, struct acm_dest *dest)
        struct acm_send_msg *msg;
        struct acm_mad *mad;

-       acm_log(2, "\n");
+       acm_log(2, "%s\n", dest->name);
        msg = acm_alloc_send(ep, dest, sizeof (*mad));
        if (!msg) {
                acm_log(0, "ERROR - failed to allocate message\n");
@@ -845,7 +859,7 @@ acm_client_resolve_resp(struct acm_client *client, struct acm_resolve_msg *req_m
        struct acm_resolve_msg *resp_msg = (struct acm_resolve_msg *) &msg;
        int ret;

-       acm_log(1, "status 0x%x\n", status);
+       acm_log(1, "client %d, status 0x%x\n", client->index, status);
        memset(&msg, 0, sizeof msg);

        lock_acquire(&client->lock);
@@ -900,7 +914,7 @@ acm_complete_queued_req(struct acm_dest *dest, uint8_t status)
                req = container_of(entry, struct acm_request, entry);
                lock_release(&dest->lock);

-               acm_log(2, "completing client request\n");
+               acm_log(2, "completing request, client %d\n", req->client->index);
                acm_client_resolve_resp(req->client,
                        (struct acm_resolve_msg *) &req->msg, dest, status);
                acm_free_req(req);
@@ -922,10 +936,11 @@ acm_dest_sa_resp(struct acm_send_msg *msg, struct ibv_wc *wc, struct acm_mad *ma
        } else {
                status = ACM_STATUS_ETIMEDOUT;
        }
-       acm_log(2, "resp status 0x%x\n", status);
+       acm_log(2, "%s status=0x%x\n", dest->name, status);

        lock_acquire(&dest->lock);
        if (dest->state != ACM_QUERY_ROUTE) {
+               acm_log(2, "discarding SA response\n");
                lock_release(&dest->lock);
                return;
        }
@@ -992,11 +1007,13 @@ acm_process_addr_req(struct acm_ep *ep, struct ibv_wc *wc, struct acm_mad *mad)
                dest->req_id = mad->tid;

        lock_acquire(&dest->lock);
+       acm_log(2, "dest state %d\n", dest->state);
        switch (dest->state) {
        case ACM_READY:
                if (dest->remote_qpn == wc->src_qp)
                        break;

+               acm_log(2, "src service has new qp, resetting\n");
                ibv_destroy_ah(dest->ah); // TODO: ah could be in use
                /* fall through */
        case ACM_INIT:
@@ -1078,6 +1095,7 @@ put:
 static void acm_process_acm_recv(struct acm_ep *ep, struct ibv_wc *wc, struct acm_mad *mad)
 {
        struct acm_send_msg *req;
+       struct acm_resolve_rec *rec;
        int free;

        acm_log(2, "\n");
@@ -1092,6 +1110,13 @@ static void acm_process_acm_recv(struct acm_ep *ep, struct ibv_wc *wc, struct ac
                return;
        }

+       rec = (struct acm_resolve_rec *) mad->data;
+       acm_format_name(2, log_data, sizeof log_data,
+                       rec->src_type, rec->src, sizeof rec->src);
+       acm_log(2, "src  %s\n", log_data);
+       acm_format_name(2, log_data, sizeof log_data,
+                       rec->dest_type, rec->dest, sizeof rec->dest);
+       acm_log(2, "dest %s\n", log_data);
        if (mad->method & IB_METHOD_RESP) {
                acm_log(2, "received response\n");
                req = acm_get_request(ep, mad->tid, &free);
@@ -1187,7 +1212,7 @@ static void acm_process_recv(struct acm_ep *ep, struct ibv_wc *wc)
 {
        struct acm_mad *mad;

-       acm_log(2, "\n");
+       acm_log(2, "base endpoint name %s\n", ep->name[0]);
        mad = (struct acm_mad *) (uintptr_t) (wc->wr_id + sizeof(struct ibv_grh));
        switch (mad->mgmt_class) {
        case IB_MGMT_CLASS_SA:
@@ -1481,7 +1506,9 @@ static void acm_process_timeouts(void)
                msg = container_of(entry, struct acm_send_msg, entry);
                rec = (struct acm_resolve_rec *) ((struct acm_mad *) msg->data)->data;

-               acm_log_addr(0, "acm_process_timeouts: dest ", rec->dest_type, rec->dest);
+               acm_format_name(0, log_data, sizeof log_data,
+                               rec->dest_type, rec->dest, sizeof rec->dest);
+               acm_log(0, "dest %s\n", log_data);
                msg->resp_handler(msg, NULL, NULL);
        }
 }
@@ -1635,7 +1662,7 @@ static void acm_svr_accept(void)

        client[i].sock = s;
        atomic_set(&client[i].refcnt, 1);
-       acm_log(2, "assigned client id %d\n", i);
+       acm_log(2, "assigned client %d\n", i);
 }

 static uint8_t acm_svr_query_sa(struct acm_ep *ep, struct acm_request *req)
@@ -1671,7 +1698,9 @@ acm_get_ep(struct acm_ep_addr_data *data)
        DLIST_ENTRY *dev_entry, *ep_entry;
        int i;

-       acm_log_addr(2, "acm_get_ep: ", data->type, data->info.addr);
+       acm_format_name(2, log_data, sizeof log_data,
+                       data->type, data->info.addr, sizeof data->info.addr);
+       acm_log(2, "%s\n", log_data);
        for (dev_entry = dev_list.Next; dev_entry != &dev_list;
                 dev_entry = dev_entry->Next) {

@@ -1700,7 +1729,9 @@ acm_get_ep(struct acm_ep_addr_data *data)
                }
        }

-       acm_log_addr(0, "acm_get_ep: could not find ", data->type, data->info.addr);
+       acm_format_name(0, log_data, sizeof log_data,
+                       data->type, data->info.addr, sizeof data->info.addr);
+       acm_log(0, "could not find %s\n", log_data);
        return NULL;
 }

@@ -1711,7 +1742,7 @@ acm_svr_query(struct acm_client *client, struct acm_resolve_msg *msg)
        struct acm_ep *ep;
        uint8_t status;

-       acm_log(2, "processing client query\n");
+       acm_log(2, "client %d\n", client->index);
        if (msg->hdr.length != ACM_MSG_HDR_LENGTH + ACM_MSG_EP_LENGTH) {
                acm_log(0, "ERROR - invalid length: 0x%x\n", msg->hdr.length);
                status = ACM_STATUS_EINVAL;
@@ -1916,7 +1947,7 @@ acm_svr_queue_req(struct acm_dest *dest, struct acm_client *client,
 {
        struct acm_request *req;

-       acm_log(2, "\n");
+       acm_log(2, "client %d\n", client->index);
        req = acm_alloc_req(client, msg);
        if (!req) {
                return ACM_STATUS_ENOMEM;
@@ -1935,6 +1966,7 @@ acm_svr_resolve(struct acm_client *client, struct acm_resolve_msg *msg)
        uint8_t status;
        int ret;

+       acm_log(2, "client %d\n", client->index);
        status = acm_svr_verify_resolve(msg, &saddr, &daddr);
        if (status) {
                acm_log(0, "misformatted or unsupported request\n");
@@ -1947,14 +1979,18 @@ acm_svr_resolve(struct acm_client *client, struct acm_resolve_msg *msg)
                return acm_client_resolve_resp(client, msg, NULL, status);
        }

-       acm_log_addr(2, "acm_svr_resolve: source ", saddr->type, saddr->info.addr);
+       acm_format_name(2, log_data, sizeof log_data,
+                       saddr->type, saddr->info.addr, sizeof saddr->info.addr);
+       acm_log(2, "src  %s\n", log_data);
        ep = acm_get_ep(saddr);
        if (!ep) {
                acm_log(0, "unknown local end point\n");
                return acm_client_resolve_resp(client, msg, NULL, ACM_STATUS_ESRCADDR);
        }

-       acm_log_addr(2, "acm_svr_resolve: dest ", daddr->type, daddr->info.addr);
+       acm_format_name(2, log_data, sizeof log_data,
+                       daddr->type, daddr->info.addr, sizeof daddr->info.addr);
+       acm_log(2, "dest %s\n", log_data);

        dest = acm_acquire_dest(ep, daddr->type, daddr->info.addr);
        if (!dest) {
@@ -2006,7 +2042,7 @@ static void acm_svr_receive(struct acm_client *client)
        struct acm_resolve_msg *resolve_msg = (struct acm_resolve_msg *) &msg;
        int ret;

-       acm_log(2, "\n");
+       acm_log(2, "client %d\n", client->index);
        ret = recv(client->sock, (char *) &msg, sizeof msg, 0);
        if (ret <= 0 || ret != msg.hdr.length) {
                acm_log(2, "client disconnected\n");
@@ -2239,6 +2275,7 @@ static int acm_assign_ep_names(struct acm_ep *ep)

                        ep->addr_type[index] = type;
                        acm_log(1, "assigning %s\n", addr);
+                       strncpy(ep->name[index], addr, ACM_MAX_ADDRESS);
                        if (type == ACM_ADDRESS_IP)
                                memcpy(ep->addr[index].addr, &ip_addr, 4);
                        else if (type == ACM_ADDRESS_IP6)
diff --git a/windows/osd.h b/windows/osd.h
index 9587c51..2ca2c52 100644
--- a/windows/osd.h
+++ b/windows/osd.h
@@ -84,6 +84,7 @@ static __inline UINT64 time_stamp_us(void)
 #define time_stamp_ms() (time_stamp_us() * 1000)

 #define getpid() ((int) GetCurrentProcessId())
+#define PER_THREAD __declspec(thread)
 #define beginthread(func, arg) (int) _beginthread(func, 0, arg)
 #define container_of CONTAINING_RECORD


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

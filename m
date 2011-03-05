From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/7] ibacm: Move endpoint activation to another thread
Date: Fri, 4 Mar 2011 16:02:35 -0800
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25CC92EAC1@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

To support dynamic changes, move endpoint activation from
the main thread into a dedicated thread that will also
process asynchronous events (to be added separately).  The
main thread will still initialize the device and port
list, but activation code will be handled by the new thread,
so that endpoints can be deferred until their associated
ports are activated.

This also means that multicast joins are deferred, and
additional state checking is needed to prevent the main
thread (which processes client requests) from accessing
endpoints which are not yet fully active.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/acm.c |  379 ++++++++++++++++++++++++++++++++-----------------------------
 1 files changed, 197 insertions(+), 182 deletions(-)

diff --git a/src/acm.c b/src/acm.c
index f21f702..10680f8 100644
--- a/src/acm.c
+++ b/src/acm.c
@@ -294,15 +294,22 @@ static int acm_compare_dest(const void *dest1, const void *dest2)
 }

 static void
-acm_init_dest(struct acm_dest *dest, uint8_t addr_type, uint8_t *addr, size_t size)
+acm_set_dest_addr(struct acm_dest *dest, uint8_t addr_type, uint8_t *addr, size_t size)
 {
        memcpy(dest->address, addr, size);
        dest->addr_type = addr_type;
+       acm_format_name(0, dest->name, sizeof dest->name, addr_type, addr, size);
+}
+
+static void
+acm_init_dest(struct acm_dest *dest, uint8_t addr_type, uint8_t *addr, size_t size)
+{
        DListInit(&dest->req_queue);
        atomic_init(&dest->refcnt);
        atomic_set(&dest->refcnt, 1);
        lock_init(&dest->lock);
-       acm_format_name(0, dest->name, sizeof dest->name, addr_type, addr, size);
+       if (size)
+               acm_set_dest_addr(dest, addr_type, addr, size);
 }

 static struct acm_dest *
@@ -1477,10 +1484,9 @@ out:
        free(umad);
 }

-static void acm_port_join(void *context)
+static void acm_port_join(struct acm_port *port)
 {
        struct acm_device *dev;
-       struct acm_port *port = (struct acm_port *) context;
        struct acm_ep *ep;
        union ibv_gid port_gid;
        DLIST_ENTRY *ep_entry;
@@ -1513,33 +1519,6 @@ static void acm_port_join(void *context)
                port->port_num);
 }

-static void acm_join_groups(void)
-{
-       struct acm_device *dev;
-       struct acm_port *port;
-       DLIST_ENTRY *dev_entry;
-       int i;
-
-       acm_log(1, "initiating multicast joins for all ports\n");
-       for (dev_entry = dev_list.Next; dev_entry != &dev_list;
-                dev_entry = dev_entry->Next) {
-
-               dev = container_of(dev_entry, struct acm_device, entry);
-
-               for (i = 0; i < dev->port_cnt; i++) {
-                       port = &dev->port[i];
-                       if (port->state != IBV_PORT_ACTIVE)
-                               continue;
-
-                       acm_log(1, "starting join for device %s, port %d\n",
-                               dev->verbs->device->name, port->port_num);
-                       // TODO: handle dynamic changes
-                       //beginthread(acm_port_join, port);
-                       acm_port_join(port);
-               }
-       }
-}
-
 static void acm_process_timeouts(void)
 {
        DLIST_ENTRY *entry;
@@ -1730,12 +1709,42 @@ acm_is_path_from_port(struct acm_port *port, struct ibv_path_record *path)
 }

 static struct acm_ep *
+acm_get_port_ep(struct acm_port *port, struct acm_ep_addr_data *data)
+{
+       struct acm_ep *ep;
+       DLIST_ENTRY *ep_entry;
+
+       if (port->state != IBV_PORT_ACTIVE)
+               return NULL;
+
+       if (data->type == ACM_EP_INFO_PATH &&
+           !acm_is_path_from_port(port, &data->info.path))
+               return NULL;
+
+       for (ep_entry = port->ep_list.Next; ep_entry != &port->ep_list;
+                ep_entry = ep_entry->Next) {
+
+               ep = container_of(ep_entry, struct acm_ep, entry);
+               if (ep->state != ACM_READY)
+                       continue;
+
+               if ((data->type == ACM_EP_INFO_PATH) &&
+                   (!data->info.path.pkey || (ntohs(data->info.path.pkey) == ep->pkey)))
+                       return ep;
+
+               if (acm_addr_index(ep, data->info.addr, (uint8_t) data->type) >= 0)
+                       return ep;
+       }
+
+       return NULL;
+}
+
+static struct acm_ep *
 acm_get_ep(struct acm_ep_addr_data *data)
 {
        struct acm_device *dev;
-       struct acm_port *port;
        struct acm_ep *ep;
-       DLIST_ENTRY *dev_entry, *ep_entry;
+       DLIST_ENTRY *dev_entry;
        int i;

        acm_format_name(2, log_data, sizeof log_data,
@@ -1746,28 +1755,11 @@ acm_get_ep(struct acm_ep_addr_data *data)

                dev = container_of(dev_entry, struct acm_device, entry);
                for (i = 0; i < dev->port_cnt; i++) {
-                       port = &dev->port[i];
-
-                       if (data->type == ACM_EP_INFO_PATH &&
-                           !acm_is_path_from_port(port, &data->info.path))
-                               continue;
-
-                       for (ep_entry = port->ep_list.Next; ep_entry != &port->ep_list;
-                                ep_entry = ep_entry->Next) {
-
-                               ep = container_of(ep_entry, struct acm_ep, entry);
-                               if (ep->state != ACM_READY)
-                                       continue;
-
-                               if ((data->type == ACM_EP_INFO_PATH) &&
-                                   (!data->info.path.pkey ||
-                                    (ntohs(data->info.path.pkey) == ep->pkey)))
-                                       return ep;
-
-                               if (acm_addr_index(ep, data->info.addr,
-                                   (uint8_t) data->type) >= 0)
-                                       return ep;
-                       }
+                       lock_acquire(&dev->port[i].lock);
+                       ep = acm_get_port_ep(&dev->port[i], data);
+                       lock_release(&dev->port[i].lock);
+                       if (ep)
+                               return ep;
                }
        }

@@ -2385,6 +2377,22 @@ err:
        return -1;
 }

+static FILE *acm_open_addr_file(void)
+{
+       FILE *f;
+
+       if ((f = fopen(addr_file, "r")))
+               return f;
+
+       acm_log(0, "notice - generating acm_addr.cfg file\n");
+       if (!(f = popen("ib_acme -A", "r"))) {
+               acm_log(0, "ERROR - cannot generate acm_addr.cfg\n");
+               return NULL;
+       }
+       pclose(f);
+       return fopen(addr_file, "r");
+}
+
 static int acm_assign_ep_names(struct acm_ep *ep)
 {
        FILE *faddr;
@@ -2490,7 +2498,7 @@ static int acm_init_ep_loopback(struct acm_ep *ep)
        return 0;
 }

-static int acm_activate_ep(struct acm_port *port, struct acm_ep *ep, uint16_t pkey_index)
+static int acm_ep_up(struct acm_port *port, struct acm_ep *ep, uint16_t pkey_index)
 {
        struct ibv_qp_init_attr init_attr;
        struct ibv_qp_attr attr;
@@ -2593,24 +2601,61 @@ err1:
        return -1;
 }

-static void acm_activate_port(struct acm_port *port)
+static void acm_port_up(struct acm_port *port)
 {
+       struct ibv_port_attr attr;
+       union ibv_gid gid;
+       uint16_t pkey;
        struct acm_ep *ep;
        int i, ret;

-       acm_log(1, "%s %d\n", port->dev->verbs->device->name,
-               port->port_num);
+       acm_log(1, "%s %d\n", port->dev->verbs->device->name, port->port_num);
+       ret = ibv_query_port(port->dev->verbs, port->port_num, &attr);
+       if (ret) {
+               acm_log(0, "ERROR - unable to get port state\n");
+               return;
+       }
+       if (attr.state != IBV_PORT_ACTIVE) {
+               acm_log(1, "port not active\n");
+               return;
+       }
+
+       port->mtu = attr.active_mtu;
+       port->rate = acm_get_rate(attr.active_width, attr.active_speed);
+       port->subnet_timeout = 1 << (attr.subnet_timeout - 8);
+       for (;; port->gid_cnt++) {
+               ret = ibv_query_gid(port->dev->verbs, port->port_num, port->gid_cnt, &gid);
+               if (ret || !gid.global.interface_id)
+                       break;
+       }
+
+       for (;; port->pkey_cnt++) {
+               ret = ibv_query_pkey(port->dev->verbs, port->port_num, port->pkey_cnt, &pkey);
+               if (ret || !pkey)
+                       break;
+       }
+       port->lid = attr.lid;
+       port->lid_mask = 0xffff - ((1 << attr.lmc) - 1);
+
+       acm_set_dest_addr(&port->sa_dest, ACM_ADDRESS_LID,
+               (uint8_t *) &attr.sm_lid, sizeof(attr.sm_lid));
+       port->sa_dest.av.src_path_bits = 0;
+       port->sa_dest.av.dlid = attr.sm_lid;
+       port->sa_dest.av.sl = attr.sm_sl;
+       port->sa_dest.av.port_num = port->port_num;
+       port->sa_dest.remote_qpn = 1;

        port->sa_dest.ah = ibv_create_ah(port->dev->pd, &port->sa_dest.av);
        if (!port->sa_dest.ah)
-               goto err1;
+               return;

        for (i = 0; i < port->pkey_cnt; i++) {
+               /* TODO: Check if endpoint already exists in port list */
                ep = calloc(1, sizeof *ep);
                if (!ep)
                        break;

-               ret = acm_activate_ep(port, ep, (uint16_t) i);
+               ret = acm_ep_up(port, ep, (uint16_t) i);
                if (!ret) {
                        DListInsertHead(&ep->entry, &port->ep_list);
                } else {
@@ -2619,103 +2664,71 @@ static void acm_activate_port(struct acm_port *port)
                }
        }

-       if (DListEmpty(&port->ep_list))
-               goto err2;
-
-       port->mad_portid = umad_open_port(port->dev->verbs->device->name, port->port_num);
-       if (port->mad_portid < 0) {
-               acm_log(0, "ERROR - unable to open MAD port\n");
-               goto err3;
-       }
-
-       port->mad_agentid = umad_register(port->mad_portid,
-               IB_MGMT_CLASS_SA, 1, 1, NULL);
-       if (port->mad_agentid < 0) {
-               acm_log(0, "ERROR - unable to register MAD client\n");
-               goto err4;
-       }
-
-       return;
-
-err4:
-       umad_close_port(port->mad_portid);
-err3:
-       /* TODO: cleanup ep list */
-err2:
-       ibv_destroy_ah(port->sa_dest.ah);
-err1:
-       port->state = IBV_PORT_NOP;
+       acm_port_join(port);
+       lock_acquire(&port->lock);
+       port->state = IBV_PORT_ACTIVE;
+       lock_release(&port->lock);
 }

-static int acm_activate_dev(struct acm_device *dev)
+/*
+ * There is one event handler thread per device.  This is the only thread that
+ * modifies the port state or a port endpoint list.  Other threads which access
+ * those must synchronize against changes accordingly, but this thread only
+ * needs to lock when making modifications.
+ */
+static void CDECL_FUNC acm_event_handler(void *context)
 {
+       struct acm_device *dev = (struct acm_device *) context;
        int i;

-       acm_log(1, "%s\n", dev->verbs->device->name);
-       dev->pd = ibv_alloc_pd(dev->verbs);
-       if (!dev->pd)
-               return ACM_STATUS_ENOMEM;
-
-       dev->channel = ibv_create_comp_channel(dev->verbs);
-       if (!dev->channel) {
-               acm_log(0, "ERROR - unable to create comp channel\n");
-               goto err;
-       }
-
+       acm_log(1, "started\n");
        for (i = 0; i < dev->port_cnt; i++) {
-               acm_log(2, "checking port %d\n", dev->port[i].port_num);
-               if (dev->port[i].state == IBV_PORT_ACTIVE)
-                       acm_activate_port(&dev->port[i]);
+               acm_port_up(&dev->port[i]);
        }
+       /* TODO: wait for port up/down events */
+}

-       acm_log(1, "starting completion thread\n");
-       beginthread(acm_comp_handler, dev);
-       return 0;
+static void acm_activate_devices()
+{
+       struct acm_device *dev;
+       DLIST_ENTRY *dev_entry;

-err:
-       ibv_dealloc_pd(dev->pd);
-       return -1;
+       acm_log(1, "\n");
+       for (dev_entry = dev_list.Next; dev_entry != &dev_list;
+               dev_entry = dev_entry->Next) {
+
+               dev = container_of(dev_entry, struct acm_device, entry);
+               beginthread(acm_event_handler, dev);
+               beginthread(acm_comp_handler, dev);
+       }
 }

-static void acm_init_port(struct acm_port *port)
+static void acm_open_port(struct acm_port *port, struct acm_device *dev, uint8_t port_num)
 {
-       struct ibv_port_attr attr;
-       union ibv_gid gid;
-       uint16_t pkey;
-       int ret;
-
-       acm_log(1, "%s %d\n", port->dev->verbs->device->name, port->port_num);
+       acm_log(1, "%s %d\n", dev->verbs->device->name, port_num);
+       port->dev = dev;
+       port->port_num = port_num;
        lock_init(&port->lock);
        DListInit(&port->ep_list);
-       ret = ibv_query_port(port->dev->verbs, port->port_num, &attr);
-       if (ret)
-               return;
+       acm_init_dest(&port->sa_dest, ACM_ADDRESS_LID, NULL, 0);

-       port->state = attr.state;
-       port->mtu = attr.active_mtu;
-       port->rate = acm_get_rate(attr.active_width, attr.active_speed);
-       port->subnet_timeout = 1 << (attr.subnet_timeout - 8);
-       for (;; port->gid_cnt++) {
-               ret = ibv_query_gid(port->dev->verbs, port->port_num, port->gid_cnt, &gid);
-               if (ret || !gid.global.interface_id)
-                       break;
+       port->mad_portid = umad_open_port(dev->verbs->device->name, port->port_num);
+       if (port->mad_portid < 0) {
+               acm_log(0, "ERROR - unable to open MAD port\n");
+               return;
        }

-       for (;; port->pkey_cnt++) {
-               ret = ibv_query_pkey(port->dev->verbs, port->port_num, port->pkey_cnt, &pkey);
-               if (ret || !pkey)
-                       break;
+       port->mad_agentid = umad_register(port->mad_portid,
+               IB_MGMT_CLASS_SA, 1, 1, NULL);
+       if (port->mad_agentid < 0) {
+               acm_log(0, "ERROR - unable to register MAD client\n");
+               goto err;
        }
-       port->lid = attr.lid;
-       port->lid_mask = 0xffff - ((1 << attr.lmc) - 1);

-       acm_init_dest(&port->sa_dest, ACM_ADDRESS_LID,
-               (uint8_t *) &attr.sm_lid, sizeof(attr.sm_lid));
-       port->sa_dest.av.src_path_bits = 0;
-       port->sa_dest.av.dlid = attr.sm_lid;
-       port->sa_dest.av.sl = attr.sm_sl;
-       port->sa_dest.av.port_num = port->port_num;
-       port->sa_dest.remote_qpn = 1;
+       port->state = IBV_PORT_DOWN;
+       return;
+err:
+       umad_close_port(port->mad_portid);
 }

 static void acm_open_dev(struct ibv_device *ibdev)
@@ -2748,25 +2761,59 @@ static void acm_open_dev(struct ibv_device *ibdev)
        dev->guid = ibv_get_device_guid(ibdev);
        dev->port_cnt = attr.phys_port_cnt;

-       for (i = 0; i < dev->port_cnt; i++) {
-               dev->port[i].dev = dev;
-               dev->port[i].port_num = i + 1;
-               acm_init_port(&dev->port[i]);
+       dev->pd = ibv_alloc_pd(dev->verbs);
+       if (!dev->pd) {
+               acm_log(0, "ERROR - unable to allocate PD\n");
+               goto err2;
        }

-       if (acm_activate_dev(dev))
-               goto err2;
+       dev->channel = ibv_create_comp_channel(dev->verbs);
+       if (!dev->channel) {
+               acm_log(0, "ERROR - unable to create comp channel\n");
+               goto err3;
+       }
+
+       for (i = 0; i < dev->port_cnt; i++)
+               acm_open_port(&dev->port[i], dev, i + 1);

-       acm_log(1, "%s opened\n", ibdev->name);
        DListInsertHead(&dev->entry, &dev_list);
+
+       acm_log(1, "%s opened\n", ibdev->name);
        return;

+err3:
+       ibv_dealloc_pd(dev->pd);
 err2:
        free(dev);
 err1:
        ibv_close_device(verbs);
 }

+static int acm_open_devices(void)
+{
+       struct ibv_device **ibdev;
+       int dev_cnt;
+       int i;
+
+       acm_log(1, "\n");
+       ibdev = ibv_get_device_list(&dev_cnt);
+       if (!ibdev) {
+               acm_log(0, "ERROR - unable to get device list\n");
+               return -1;
+       }
+
+       for (i = 0; i < dev_cnt; i++)
+               acm_open_dev(ibdev[i]);
+
+       ibv_free_device_list(ibdev);
+       if (DListEmpty(&dev_list)) {
+               acm_log(0, "ERROR - no devices\n");
+               return -1;
+       }
+
+       return 0;
+}
+
 static void acm_set_options(void)
 {
        FILE *f;
@@ -2852,22 +2899,6 @@ static FILE *acm_open_log(void)
        return f;
 }

-static FILE *acm_open_addr_file(void)
-{
-       FILE *f;
-
-       if ((f = fopen(addr_file, "r")))
-               return f;
-
-       acm_log(0, "notice - generating acm_addr.cfg file\n");
-       if (!(f = popen("ib_acme -A", "r"))) {
-               acm_log(0, "ERROR - cannot generate acm_addr.cfg\n");
-               return NULL;
-       }
-       pclose(f);
-       return fopen(addr_file, "r");
-}
-
 static int acm_open_lock_file(void)
 {
        int lock_fd;
@@ -2921,9 +2952,7 @@ static void show_usage(char *program)

 int CDECL_FUNC main(int argc, char **argv)
 {
-       struct ibv_device **ibdev;
-       int dev_cnt;
-       int op, i, daemon = 0;
+       int op, daemon = 0;

        while ((op = getopt(argc, argv, "DA:O:")) != -1) {
                switch (op) {
@@ -2963,27 +2992,13 @@ int CDECL_FUNC main(int argc, char **argv)
        DListInit(&dev_list);
        DListInit(&timeout_list);
        event_init(&timeout_event);
-
        umad_init();
-       ibdev = ibv_get_device_list(&dev_cnt);
-       if (!ibdev) {
-               acm_log(0, "ERROR - unable to get device list\n");
-               return -1;
-       }
-
-       acm_log(1, "opening devices\n");
-       for (i = 0; i < dev_cnt; i++)
-               acm_open_dev(ibdev[i]);
-
-       ibv_free_device_list(ibdev);
-       if (DListEmpty(&dev_list)) {
-               acm_log(0, "ERROR - no devices\n");
+       if (acm_open_devices()) {
+               acm_log(0, "ERROR - unable to open any devices\n");
                return -1;
        }

-       acm_log(1, "initiating multicast joins\n");
-       acm_join_groups();
-       acm_log(1, "multicast joins done\n");
+       acm_activate_devices();
        acm_log(1, "starting timeout/retry thread\n");
        beginthread(acm_retry_handler, NULL);
        acm_log(1, "starting server\n");


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

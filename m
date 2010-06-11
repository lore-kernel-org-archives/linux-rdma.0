From: "Walukiewicz, Miroslaw" <Miroslaw.Walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: FW: [PATCH] librdmacm/mcraw: Add a new test application for
 user-space IBV_QPT_RAW_ETH QP type
Date: Fri, 11 Jun 2010 15:41:19 +0100
Message-ID: <BE2BFE91933D1B4089447C64486040801E7635F7@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


The patch adds a new test application describing a usage of the IBV_QPT_RAW_ETH
for IPv4 multicast acceleration on iWARP cards.

See man mcraw for parameters description.

Signed-of-by: Mirek Walukiewicz <miroslaw.walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

diff --git a/Makefile.am b/Makefile.am
index 4ddbcfa..0132b36 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -18,7 +18,7 @@ src_librdmacm_la_LDFLAGS = -version-info 1 -export-dynamic \
 src_librdmacm_la_DEPENDENCIES =  $(srcdir)/src/librdmacm.map

 bin_PROGRAMS = examples/ucmatose examples/rping examples/udaddy examples/mckey \
-              examples/rdma_client examples/rdma_server
+              examples/rdma_client examples/rdma_server examples/mcraw
 examples_ucmatose_SOURCES = examples/cmatose.c
 examples_ucmatose_LDADD = $(top_builddir)/src/librdmacm.la
 examples_rping_SOURCES = examples/rping.c
@@ -31,6 +31,8 @@ examples_rdma_client_SOURCES = examples/rdma_client.c
 examples_rdma_client_LDADD = $(top_builddir)/src/librdmacm.la
 examples_rdma_server_SOURCES = examples/rdma_server.c
 examples_rdma_server_LDADD = $(top_builddir)/src/librdmacm.la
+examples_mcraw_SOURCES = examples/mcraw.c
+examples_mcraw_LDADD = $(top_builddir)/src/librdmacm.la

 librdmacmincludedir = $(includedir)/rdma
 infinibandincludedir = $(includedir)/infiniband
@@ -77,7 +79,8 @@ man_MANS = \
        man/udaddy.1 \
        man/mckey.1 \
        man/rping.1 \
-       man/rdma_cm.7
+       man/rdma_cm.7 \
+       man/mcraw.1

 EXTRA_DIST = include/rdma/rdma_cma_abi.h include/rdma/rdma_cma.h \
             include/infiniband/ib.h include/rdma/rdma_verbs.h \
diff --git a/examples/mcraw.c b/examples/mcraw.c
new file mode 100644
index 0000000..864c20d
--- /dev/null
+++ b/examples/mcraw.c
@@ -0,0 +1,897 @@
+/*
+ * Copyright (c) 2010 Intel Corporation.  All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ *
+ */
+
+#include <stdlib.h>
+#include <string.h>
+#include <stdio.h>
+#include <errno.h>
+#include <sys/types.h>
+#include <netinet/in.h>
+#include <arpa/inet.h>
+#include <sys/socket.h>
+#include <netdb.h>
+#include <byteswap.h>
+#include <unistd.h>
+#include <getopt.h>
+
+#include <sys/ioctl.h>
+#include <linux/if_vlan.h>
+#include <linux/sockios.h>
+#include <linux/version.h>
+#include <net/if.h>
+#include <netinet/ip.h>
+#include <linux/udp.h>
+
+#include <rdma/rdma_cma.h>
+
+#define IB_SEND_IP_CSUM        0x10
+#define IMA_VLAN_FLAG          0x20
+
+#define  VLAN_PRIORITY 0x0
+
+#define UDP_HEADER_SIZE        (sizeof(struct udphdr))
+
+#define HEADER_LEN    14 + 28
+
+struct cmatest_node {
+       int                     id;
+       struct rdma_cm_id       *cma_id;
+       int                     connected;
+       struct ibv_pd           *pd;
+       struct ibv_cq           *scq;
+       struct ibv_cq           *rcq;
+       struct ibv_mr           *mr;
+       struct ibv_ah           *ah;
+       uint32_t                remote_qpn;
+       uint32_t                remote_qkey;
+       uint8_t                 *mem;
+       struct ibv_comp_channel *channel;
+};
+
+struct cmatest {
+       struct rdma_event_channel *channel;
+       struct cmatest_node     *nodes;
+       int                     conn_index;
+       int                     connects_left;
+
+       struct sockaddr_in6     dst_in;
+       struct sockaddr         *dst_addr;
+       struct sockaddr_in6     src_in;
+       struct sockaddr         *src_addr;
+       int                     fd[1024];
+};
+
+static struct cmatest test;
+static int connections = 1;
+static int message_size = 100;
+static int message_count = 10;
+static int is_sender;
+static int unmapped_addr;
+static char *dst_addr;
+static char *src_addr;
+static enum rdma_port_space port_space = RDMA_PS_UDP;
+
+int vlan_flag;
+int vlan_ident;
+
+static int cq_len = 512;
+static int qp_len = 256;
+
+uint16_t IP_CRC(void *buf, int hdr_len)
+{
+       unsigned long sum = 0;
+       const uint16_t *ip1;
+
+       ip1 = (uint16_t *)buf;
+       while (hdr_len > 1) {
+               sum += *ip1++;
+               if (sum & 0x80000000)
+                       sum = (sum & 0xFFFF) + (sum >> 16);
+               hdr_len -= 2;
+       }
+
+       while (sum >> 16)
+               sum = (sum & 0xFFFF) + (sum >> 16);
+
+       return ~sum;
+}
+
+uint16_t udp_checksum(struct udphdr *udp_head,
+               int header_size,
+               int pay_load_size,
+               uint32_t src_addr,
+               uint32_t dest_addr,
+               unsigned char *payload)
+{
+       uint16_t *buf = (void *)udp_head;
+       uint16_t *ip_src = (void *)&src_addr;
+       uint16_t *ip_dst = (void *)&dest_addr;
+       uint32_t sum;
+       size_t len = header_size;
+
+       sum = 0;
+       while (len > 1) {
+               sum += *buf++;
+               if (sum & 0x80000000)
+                       sum = (sum & 0xFFFF) + (sum >> 16);
+               len -= 2;
+       }
+
+       buf = (void *)payload;
+       len = pay_load_size;
+       while (len > 1) {
+               sum += *buf++;
+               if (sum & 0x80000000)
+                       sum = (sum & 0xFFFF) + (sum >> 16);
+               len -= 2;
+       }
+
+       if (len & 1)
+               sum += *((uint8_t *)buf);
+       sum += *(ip_src++);
+       sum += *ip_src;
+
+       sum += *(ip_dst++);
+       sum += *ip_dst;
+
+       sum += htons(IPPROTO_UDP);
+       len = (header_size + pay_load_size);
+       sum += htons(len);
+
+       while (sum >> 16)
+               sum = (sum & 0xFFFF) + (sum >> 16);
+
+       return (uint16_t)(~sum);
+}
+
+static int create_message(struct cmatest_node *node)
+{
+       if (!message_size)
+               message_count = 0;
+
+       if (!message_count)
+               return 0;
+
+       node->mem = NULL;
+       posix_memalign((void *)&node->mem, 4096,
+                       (message_size + HEADER_LEN ) * sizeof(char));
+       if (node->mem == NULL) {
+               printf("failed message allocation\n");
+               return -1;
+       }
+
+       node->mr = ibv_reg_mr(node->pd, node->mem,
+                               message_size + HEADER_LEN,
+                               IBV_ACCESS_LOCAL_WRITE);
+       if (!node->mr) {
+               printf("failed to reg MR\n");
+               goto err;
+       }
+       return 0;
+err:
+       free(node->mem);
+       return -1;
+}
+
+static int verify_test_params(struct cmatest_node *node)
+{
+       struct ibv_port_attr port_attr;
+       int ret;
+
+       ret = ibv_query_port(node->cma_id->verbs, node->cma_id->port_num,
+                            &port_attr);
+       if (ret)
+               return ret;
+
+       printf("\nibv_query_port %x\n", node->cma_id->port_num);
+       if (message_count && message_size > (1 << (port_attr.active_mtu + 7))) {
+               printf("mcraw: message_size %d is larger than active mtu %d\n",
+                      message_size, 1 << (port_attr.active_mtu + 7));
+               return -EINVAL;
+       }
+
+       return 0;
+}
+
+static int init_node(struct cmatest_node *node)
+{
+       struct ibv_qp_init_attr init_qp_attr;
+       int cqe, ret;
+
+       node->pd = ibv_alloc_pd(node->cma_id->verbs);
+       if (!node->pd) {
+               ret = -ENOMEM;
+               printf("mcraw: unable to allocate PD\n");
+               goto out;
+       }
+       node->channel = ibv_create_comp_channel(node->cma_id->verbs);
+       if (!(node->channel)) {
+               printf("\nibv_create_comp_channel error\n");
+               ret = -ENOMEM;
+               goto out;
+       }
+
+       cqe = cq_len;
+       node->scq = ibv_create_cq(node->cma_id->verbs,
+                               cqe, node, node->channel, 0);
+       if (!node->scq) {
+               ret = -ENOMEM;
+               printf("mcraw: unable to create CQ\n");
+               goto out;
+       }
+
+       node->rcq = ibv_create_cq(node->cma_id->verbs,
+                               cqe, node, node->channel, 0);
+       if (!node->rcq) {
+               ret = -ENOMEM;
+               printf("mcraw: unable to create CQ\n");
+               goto out;
+       }
+
+       memset(&init_qp_attr, 0, sizeof init_qp_attr);
+       init_qp_attr.cap.max_send_wr = qp_len;
+       init_qp_attr.cap.max_recv_wr = qp_len;
+       init_qp_attr.cap.max_send_sge = 1;
+       init_qp_attr.cap.max_recv_sge = 1;
+       init_qp_attr.qp_context = node;
+       init_qp_attr.qp_type = IBV_QPT_RAW_ETH;
+       init_qp_attr.send_cq = node->scq;
+       init_qp_attr.recv_cq = node->rcq;
+       ret = rdma_create_qp(node->cma_id, node->pd, &init_qp_attr);
+       if (ret) {
+               printf("mcraw: unable to create QP: %d\n", ret);
+               goto out;
+       }
+
+       printf("mcraw: qp ptr = %p\n", node->cma_id->qp);
+
+       ret = create_message(node);
+       if (ret) {
+               printf("mcraw: failed to create messages: %d\n", ret);
+               goto out;
+       }
+out:
+       return ret;
+}
+
+static int post_recvs(struct cmatest_node *node, int num_to_post)
+{
+       struct ibv_recv_wr recv_wr, *recv_failure;
+       struct ibv_sge sge;
+       int i, ret = 0;
+
+       if (!message_count)
+               return 0;
+
+       recv_wr.next = NULL;
+       recv_wr.sg_list = &sge;
+       recv_wr.num_sge = 1;
+       recv_wr.wr_id = (uintptr_t) node;
+
+       sge.length = message_size + HEADER_LEN;
+       sge.lkey = node->mr->lkey;
+       sge.addr = (uintptr_t) node->mem;
+
+       for (i = 0; i < num_to_post && !ret; i++) {
+               ret = ibv_post_recv(node->cma_id->qp, &recv_wr, &recv_failure);
+               if (ret) {
+                       printf("mcraw: failed to post receives: %d\n", ret);
+                       break;
+               }
+       }
+       return ret;
+}
+
+static int post_sends(struct cmatest_node *node, int signal_flag)
+{
+       struct ibv_send_wr send_wr, *bad_send_wr;
+       struct ibv_sge sge;
+       int i, ret = 0;
+       int eth_len = 0;
+       int count = 0;
+       int vlan_tag = 0;
+
+       char eth_hdr[14];
+
+       int fd;
+       int numifs = 100;
+       int bufsize;
+       struct ifreq *reqbuf;
+       struct ifconf ifc;
+       struct ifreq *ifr;
+       struct vlan_ioctl_args ifreq_vlan;
+       uint32_t haddr = inet_addr(src_addr);
+       int n = 0;
+       struct sockaddr_in *sin;
+       unsigned char *pUDPData;
+       struct iphdr *ip_head;
+       struct udphdr *udp_head;
+       short int Datagram_size, UDP_packet_size;
+
+       memset(&eth_hdr[0], 0, sizeof(eth_hdr));
+
+       if (!node->connected || !message_count)
+               return 0;
+
+       ip_head = (struct iphdr *)calloc(1, sizeof(struct iphdr));
+       if (ip_head == NULL) {
+               printf("\nerror\n");
+               return -1;
+       }
+
+       udp_head = (struct udphdr *)calloc(1, sizeof(struct udphdr));
+       if (udp_head == NULL) {
+               printf("\nerror\n");
+               return -1;
+       }
+
+
+       Datagram_size = message_size + sizeof(struct iphdr) + sizeof(struct udphdr);
+       UDP_packet_size = message_size  + sizeof(struct udphdr);
+
+       ip_head->version = 0x4;
+       ip_head->ihl = 0x5;
+       ip_head->tos = 0x00;
+       ip_head->tot_len = ntohs(Datagram_size);
+       ip_head->id = ntohs(0x0000);
+       ip_head->frag_off = ntohs(0x4000);
+       ip_head->ttl = 0x01;
+       ip_head->protocol = 0x11;
+
+       ip_head->saddr = inet_addr(src_addr);
+       ip_head->daddr = inet_addr(dst_addr);
+       ip_head->check = IP_CRC((void *)ip_head, sizeof(struct iphdr));
+
+       /* Fill udp CRC at user space */
+       udp_head->source = ntohs(12345);
+       udp_head->dest = ntohs(12345);
+       udp_head->len = ntohs(UDP_packet_size);
+       pUDPData = (unsigned char *)malloc(sizeof(char) * message_size);
+
+       if (pUDPData == NULL) {
+               printf("\nmalloc errro\n");
+               return -1;
+       }
+
+       fd = socket(AF_INET, SOCK_DGRAM, 0);
+       if (fd < 0)
+               return -1;
+
+
+       bufsize = numifs * sizeof(struct ifreq);
+       reqbuf = (struct ifreq *)malloc(bufsize);
+       if (reqbuf == NULL) {
+               fprintf(stderr, "out of memory\n");
+               return -1;
+       }
+       ifc.ifc_buf = (caddr_t)&reqbuf[0];
+       ifc.ifc_len = bufsize;
+
+       if (ioctl(fd, SIOCGIFCONF, (char *)&ifc) == -1) {
+               perror("ioctl(SIOCGIFCONF)");
+               close(fd);
+               free(reqbuf);
+               return -1;
+       }
+
+       ifr = ifc.ifc_req;
+
+       for (n = ifc.ifc_len/sizeof(struct ifreq); --n >= 0; ifr++) {
+               if (ifr->ifr_addr.sa_family != AF_INET)
+                       continue;
+
+               if (ioctl(fd, SIOCGIFFLAGS, (char *) ifr) < 0) {
+                       perror("ioctl(SIOCGIFFLAGS)");
+                       close(fd);
+                       free(reqbuf);
+                       return -1;
+               }
+
+               /* Skip boring cases */
+               if ((ifr->ifr_flags & IFF_UP) == 0)
+                       continue;
+               if (ifr->ifr_flags & IFF_LOOPBACK)
+                       continue;
+               if ((ifr->ifr_flags & IFF_POINTOPOINT))
+                       continue;
+               sin = (struct sockaddr_in *)&ifr->ifr_addr;
+
+               if (haddr != sin->sin_addr.s_addr) {
+                       continue;
+               }
+               if (ioctl(fd, SIOCGIFHWADDR, ifr) < 0) {
+                       perror("ioctl(SIOCGIFHWADD)");
+                       close(fd);
+                       free(reqbuf);
+                       return -1;
+               }
+               vlan_flag = 0;
+
+#if LINUX_VERSION_CODE > KERNEL_VERSION(2, 6, 9)
+               memset(&ifreq_vlan, 0, sizeof(ifreq_vlan));
+
+               ifreq_vlan.cmd = GET_VLAN_VID_CMD;
+               strcpy(ifreq_vlan.device1, ifr->ifr_name);
+               vlan_ident = 0;
+               if (ioctl(fd, SIOCSIFVLAN, &ifreq_vlan) >= 0) {
+                       vlan_flag = 1;
+                       vlan_ident = 0;
+                       vlan_ident = (VLAN_PRIORITY << 13) |
+                                       (ifreq_vlan.u.VID & 0xfff);
+               }
+#endif
+
+               eth_hdr[0] = 0x01;
+               eth_hdr[1] = 0x00;
+               eth_hdr[2] = 0x5e;
+               eth_hdr[3] = ((ip_head->daddr) >> 8) & 0x7f;
+               eth_hdr[4] = ((ip_head->daddr) >> 16) & 0xff;
+               eth_hdr[5] = ((ip_head->daddr) >> 24) & 0xff;
+
+
+               eth_hdr[6] = ifr->ifr_hwaddr.sa_data[0];
+               eth_hdr[7] = ifr->ifr_hwaddr.sa_data[1];
+               eth_hdr[8] = ifr->ifr_hwaddr.sa_data[2];
+               eth_hdr[9] = ifr->ifr_hwaddr.sa_data[3];
+               eth_hdr[10] = ifr->ifr_hwaddr.sa_data[4];
+               eth_hdr[11] = ifr->ifr_hwaddr.sa_data[5];
+
+               eth_hdr[12] = 0x08;
+               eth_hdr[13] = 0x00;
+
+               close(fd);
+               free(reqbuf);
+               break;
+       }
+
+       for (i = 0; i < message_size; i++)
+               pUDPData[i] = i+1;
+
+       udp_head->check = udp_checksum(udp_head,
+               sizeof(struct udphdr),
+               (message_size - (sizeof(struct iphdr) + UDP_HEADER_SIZE)),
+               inet_addr(src_addr),
+               inet_addr(dst_addr),
+               pUDPData);
+
+       eth_len = 14;
+       memcpy((void *)node->mem, (void *)eth_hdr, eth_len);
+       memcpy((void *)node->mem + eth_len, (void *)ip_head,
+                               sizeof(struct iphdr));
+       memcpy(((void *)node->mem) + eth_len + sizeof(struct iphdr),
+               (void *)udp_head, UDP_HEADER_SIZE);
+       memcpy(((void *)node->mem) + eth_len +
+               sizeof(struct iphdr) + UDP_HEADER_SIZE,
+               (void *)(pUDPData),
+               message_size);
+
+       free(ip_head);
+       free(pUDPData);
+       free(udp_head);
+
+       send_wr.next = NULL;
+       send_wr.sg_list = &sge;
+       send_wr.num_sge = 1;
+       send_wr.opcode = IBV_WR_SEND_WITH_IMM;
+       send_wr.send_flags = signal_flag;
+       send_wr.wr_id = (unsigned long)node;
+       send_wr.send_flags = IB_SEND_IP_CSUM;
+
+       if (vlan_flag == 1) {
+               vlan_tag = vlan_ident & 0xffff;
+
+               send_wr.send_flags |= IMA_VLAN_FLAG;
+               send_wr.imm_data = vlan_tag ;
+       }
+       sge.length = message_size + HEADER_LEN;
+       sge.lkey = node->mr->lkey;
+       sge.addr = (uintptr_t) node->mem;
+
+       for (i = 0; i < message_count && !ret; i++) {
+               struct ibv_wc wc;
+
+               ret = ibv_post_send(node->cma_id->qp, &send_wr, &bad_send_wr);
+               if (ret)
+                       printf("failed to post sends: ret = %d i = %d\n",
+                                                               ret, i);
+
+               count = 0;
+               while (count == 0) {
+                       count = ibv_poll_cq(node->scq, 1, &wc);
+                       if (count > 0)
+                               printf("wc[%d].status = %d wr_id=%x\n", count,
+                                                       wc.status,
+                                                       (unsigned int)wc.wr_id);
+                       if (count < 0) {
+                               printf("mcraw: failed polling SCQ: %d\n", ret);
+                               return ret;
+                       }
+               }
+       }
+       return ret;
+}
+
+static void connect_error(void)
+{
+       test.connects_left--;
+}
+
+static int addr_handler(struct cmatest_node *node)
+{
+       int ret;
+
+       unsigned char mcast_mac_addr[6];
+       union ibv_gid sgid;
+       struct sockaddr_in      *multicast_address;
+       ret = verify_test_params(node);
+       if (ret)
+               goto err;
+
+       ret = init_node(node);
+       if (ret)
+               goto err;
+
+       if (!is_sender) {
+               ret = post_recvs(node, qp_len);
+               if (ret)
+                       goto err;
+       }
+
+       multicast_address = (struct sockaddr_in *) test.dst_addr;
+
+       mcast_mac_addr[0] = 0x01;
+       mcast_mac_addr[1] = 0x00;
+       mcast_mac_addr[2] = 0x5e;
+       mcast_mac_addr[3] = (multicast_address->sin_addr.s_addr >> 8) & 0x7f;
+       mcast_mac_addr[4] = (multicast_address->sin_addr.s_addr >> 16) & 0xff;
+       mcast_mac_addr[5] = (multicast_address->sin_addr.s_addr >> 24) & 0xff;
+
+       /* compatybility issue with ibv_attach_mcast */
+       memset(&sgid, 0, sizeof(sgid));
+
+       /* multicast address is in last 6 bytes of gid raw */
+       memcpy(&sgid.raw[10], mcast_mac_addr, 6);
+
+       ret = ibv_attach_mcast(node->cma_id->qp, &sgid, 0);
+       if (ret) {
+               printf("mcraw: ibv_attach_mcast: %d\n", ret);
+               connect_error();
+               return ret;
+       }
+       node->connected = 1;
+       test.connects_left--;
+       return 0;
+err:
+       connect_error();
+       return ret;
+}
+
+
+static void destroy_node(struct cmatest_node *node)
+{
+       if (!node->cma_id)
+               return;
+
+
+       if (node->cma_id->qp)
+               rdma_destroy_qp(node->cma_id);
+
+       if (node->scq)
+               ibv_destroy_cq(node->scq);
+
+       if (node->rcq)
+               ibv_destroy_cq(node->rcq);
+
+       if (node->mem) {
+               ibv_dereg_mr(node->mr);
+               free(node->mem);
+       }
+
+       if (node->pd)
+               ibv_dealloc_pd(node->pd);
+
+       /* Destroy the RDMA ID after all device resources */
+       rdma_destroy_id(node->cma_id);
+}
+
+static int alloc_nodes(void)
+{
+       int ret, i;
+
+       test.nodes = malloc(sizeof *test.nodes * connections);
+       if (!test.nodes) {
+               printf("mcraw: unable to allocate memory for test nodes\n");
+               return -ENOMEM;
+       }
+       memset(test.nodes, 0, sizeof *test.nodes * connections);
+
+       for (i = 0; i < connections; i++) {
+               test.nodes[i].id = i;
+               ret = rdma_create_id(test.channel, &test.nodes[i].cma_id,
+                                    &test.nodes[i], port_space);
+               if (ret)
+                       goto err;
+       }
+       return 0;
+err:
+       while (--i >= 0)
+               rdma_destroy_id(test.nodes[i].cma_id);
+       free(test.nodes);
+       return ret;
+}
+
+static void destroy_nodes(void)
+{
+       int i;
+
+       for (i = 0; i < connections; i++)
+               destroy_node(&test.nodes[i]);
+       free(test.nodes);
+}
+
+static int poll_cqs(void)
+{
+       struct ibv_wc wc;
+       int i, ret;
+       int count = 0;
+       for (i = 0; i < connections; i++) {
+               if (!test.nodes[i].connected)
+                       continue;
+
+               while (count < message_count) {
+                       ret = ibv_poll_cq(test.nodes[i].rcq, 1, &wc);
+                       if (ret > 0) {
+                               count += ret;
+                               printf("mcraw: wc.status=%d wr_id=%d vid=%d\n",
+                                       wc.status,
+                                       (unsigned int)wc.wr_id,
+                                       wc.pkey_index);
+                               ret = post_recvs(&test.nodes[i], 1);
+                               if (ret != 0)
+                                       printf("mcraw: cannot post a buffer\n");
+                       }
+                       if (ret < 0) {
+                               printf("mcraw: failed polling CQ: %d\n", ret);
+                               return ret;
+                       }
+               }
+       }
+       return 0;
+}
+
+
+static int get_addr(char *dst, struct sockaddr *addr)
+{
+       struct addrinfo *res;
+       int ret;
+
+       ret = getaddrinfo(dst, NULL, NULL, &res);
+       if (ret) {
+               printf("getaddrinfo failed - invalid hostname or IP address\n");
+               return ret;
+       }
+
+       memcpy(addr, res->ai_addr, res->ai_addrlen);
+       freeaddrinfo(res);
+       return ret;
+}
+
+static int run(void)
+{
+       int i, ret;
+
+       struct ip_mreq group;
+       printf("mcraw: starting %s\n", is_sender ? "client" : "server");
+       if (src_addr) {
+               ret = get_addr(src_addr, (struct sockaddr *) &test.src_in);
+               if (ret)
+                       return ret;
+       }
+
+       ret = get_addr(dst_addr, (struct sockaddr *) &test.dst_in);
+       if (ret)
+               return ret;
+
+       printf("mcraw: joining\n");
+       for (i = 0; i < connections; i++) {
+               if (src_addr) {
+                       ret = rdma_bind_addr(test.nodes[i].cma_id,
+                                            test.src_addr);
+                       if (ret) {
+                               printf("mcraw: addr bind failure: %d\n", ret);
+                               connect_error();
+                               return ret;
+                       }
+               }
+               printf("mcraw: get socket\n");
+
+               test.fd[i] = socket(AF_INET, SOCK_DGRAM, 0);
+               if (test.fd[i] < 0) {
+                       printf("mcraw: cannot open socket\n");
+                       connect_error();
+                       return -1;
+               }
+
+               group.imr_multiaddr.s_addr = inet_addr(dst_addr);
+               group.imr_interface.s_addr = inet_addr(src_addr);
+
+               if (setsockopt(test.fd[i], IPPROTO_IP,
+                                       IP_ADD_MEMBERSHIP,
+                                       &group, sizeof(group)) < 0) {
+                       printf("mcraw: Cannot subscribe multicast\n");
+                       connect_error();
+                       return -1;
+               }
+
+               printf("mcraw: joining\n");
+
+               ret = addr_handler(&test.nodes[i]);
+               if (ret) {
+                       printf("mcraw: resolve addr failure: %d\n", ret);
+                       connect_error();
+                       return ret;
+               }
+       }
+
+       /*
+        * Pause to give SM chance to configure switches.  We don't want to
+        * handle reliability issue in this simple test program.
+        */
+       printf("mcraw: sleep\n");
+
+       sleep(3);
+
+       if (message_count) {
+               if (is_sender) {
+                       printf("initiating data transfers\n");
+                       for (i = 0; i < connections; i++) {
+                               ret = post_sends(&test.nodes[i], 0);
+                               if (ret)
+                                       goto out;
+                       }
+               } else {
+                       printf("receiving data transfers\n");
+                       ret = poll_cqs();
+                       if (ret)
+                               goto out;
+               }
+               printf("data transfers complete\n");
+       }
+out:
+       for (i = 0; i < connections; i++) {
+               unsigned char mcast_mac_addr[6];
+               union ibv_gid sgid;
+               struct sockaddr_in      *multicast_address;
+
+               multicast_address = (struct sockaddr_in *) test.dst_addr;
+
+               mcast_mac_addr[0] = 0x01;
+               mcast_mac_addr[1] = 0x00;
+               mcast_mac_addr[2] = 0x5e;
+               mcast_mac_addr[3] =
+                       (multicast_address->sin_addr.s_addr >> 8) & 0x7f;
+               mcast_mac_addr[4] =
+                       (multicast_address->sin_addr.s_addr >> 16) & 0xff;
+               mcast_mac_addr[5] =
+                       (multicast_address->sin_addr.s_addr >> 24) & 0xff;
+
+               /* compatybility issue with ibv_attach_mcast */
+               memset(&sgid, 0, sizeof(sgid));
+
+               /* multicast address is in last 6 bytes of gid raw */
+               memcpy(&sgid.raw[10], mcast_mac_addr, 6);
+
+               ret = ibv_detach_mcast(test.nodes[i].cma_id->qp, &sgid, 0);
+               if (ret)
+                       printf("mcraw: failure leaving: %d\n", ret);
+
+               close(test.fd[i]);
+       }
+       return ret;
+}
+
+int main(int argc, char **argv)
+{
+       int op, ret;
+
+
+       while ((op = getopt(argc, argv, "m:M:sb:c:C:S:p:v:")) != -1) {
+               switch (op) {
+               case 'm':
+                       dst_addr = optarg;
+                       break;
+               case 's':
+                       is_sender = 1;
+                       break;
+               case 'b':
+                       src_addr = optarg;
+                       test.src_addr = (struct sockaddr *) &test.src_in;
+                       break;
+               case 'c':
+                       connections = atoi(optarg);
+                       if (connections > 1024)
+                                       connections = 1024;
+                       if (connections <= 0)
+                                       connections = 1;
+                       break;
+               case 'C':
+                       message_count = atoi(optarg);
+                       break;
+               case 'S':
+                       message_size = atoi(optarg);
+                       break;
+               case 'p':
+                       port_space = strtol(optarg, NULL, 0);
+                       break;
+               case 'v':
+                       vlan_flag = 1 ;
+                       vlan_ident = strtol(optarg, NULL, 0);
+                       break;
+               default:
+                       printf("usage: %s\n", argv[0]);
+                       printf("\t-m multicast_address\n");
+                       printf("\t[-s(ender)]\n");
+                       printf("\t[-b bind_address]\n");
+                       printf("\t[-c connections]\n");
+                       printf("\t[-C message_count]\n");
+                       printf("\t[-S message_size]\n");
+                       printf("\t[-v vlan tag]\n");
+                       printf("\t[-p port_space - %#x for UDP (default), "
+                              "%#x for IPOIB]\n", RDMA_PS_UDP, RDMA_PS_IPOIB);
+                       exit(1);
+               }
+       }
+
+       test.dst_addr = (struct sockaddr *) &test.dst_in;
+       test.connects_left = connections;
+
+       test.channel = rdma_create_event_channel();
+       if (!test.channel) {
+               printf("failed to create event channel\n");
+               exit(1);
+       }
+
+       if (alloc_nodes())
+               exit(1);
+
+       ret = run();
+
+       printf("test complete\n");
+
+       destroy_nodes();
+       rdma_destroy_event_channel(test.channel);
+
+       printf("return status %d\n", ret);
+       return ret;
+}
+
diff --git a/man/mcraw.1 b/man/mcraw.1
new file mode 100644
index 0000000..5bd7680
--- /dev/null
+++ b/man/mcraw.1
@@ -0,0 +1,51 @@
+.TH "MCRAW" 1 "2007-05-15" "librdmacm" "librdmacm" librdmacm
+.SH NAME
+mcraw \- RDMA CM multicast setup using IBV_QPT_RAW_ETH and simple data transfer test.
+.SH SYNOPSIS
+.sp
+.nf
+\fImcraw\fR -m multicast_address [-s] [-b bind_address] [-c connections]
+               [-C message_count] [-S message_size] [-p port_space]
+\fImcraw\fR -m multicast_address -s [-b bind_address] [-c connections]
+               [-C message_count] [-S message_size] [-p port_space]
+.fi
+.SH "DESCRIPTION"
+Establishes a set of RDMA multicast communication paths between nodes
+using the librdmacm, optionally transfers datagrams to receiving nodes,
+then tears down the communication.
+.SH "OPTIONS"
+.TP
+\-m multicast_address
+IP multicast address to join.
+.TP
+\-s
+Send datagrams to the multicast group.
+.TP
+\-b bind_address
+The local network address to bind to.
+.TP
+\-c connections
+The number of QPs to join the multicast group.  (default 1)
+.TP
+\-C message_count
+The number of messages to transfer over each connection.  (default 10)
+.TP
+\-S message_size
+The size of each message transferred, in bytes.  This value must be smaller
+than the MTU of the underlying RDMA transport, or an error will occur.
+(default 100)
+.TP
+\-p port_space
+The port space of the datagram communication.  May be either the RDMA
+UDP (0x0111) or IPoIB (0x0002) port space.  (default RDMA_PS_UDP)
+.SH "NOTES"
+Basic usage is to start mcraw -m multicast_address on a server system,
+then run mcraw -m multicast_address -s on a client system.
+.P
+The supported multicast addresses are IPv4 IGMP addresses (224.x.x.x)
+.P
+Because this test maps RDMA resources to userspace, users must ensure
+that they have available system resources and permissions.  See the
+libibverbs README file for additional details.
+.SH "SEE ALSO"
+rdma_cm(7), ucmatose(1), udaddy(1), rping(1), mckey(1)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

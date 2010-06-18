From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] librdmacm/mcraw: Add a new test application for
 user-space IBV_QPT_RAW_ETH QP type
Date: Thu, 17 Jun 2010 17:09:35 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF259E5A7887@orsmsx501.amr.corp.intel.com>
References: <BE2BFE91933D1B4089447C64486040801E7635F7@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BE2BFE91933D1B4089447C64486040801E7635F7-IGOiFh9zz4wLt2AQoY/u9bfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Walukiewicz, Miroslaw" <Miroslaw.Walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

FYI - I don't track the ewg mail list, so I missed any discussion there.

See my detailed comments inline.  I track the librdmacm against Roland's libibverbs releases and upstream kernel features, rather than against OFED features.  As a result, I do think there's some functionality missing in both the upstream libibverbs and kernel that need to be resolved.  I tried to identify these below.

> The patch adds a new test application describing a usage of the
> IBV_QPT_RAW_ETH

Where is IBV_QPT_RAW_ETH defined?

Roland's version of verbs.h only defines IBV_QPT_RC/UC/UD.  I think we need to get this defined there first, then figure out if anything new is needed for the librdmacm.

Also, if I understand this correctly, a RAW_ETH QP exposes the contents of the Ethernet frame and header to the user.  This should be restricted to privileged applications, and I'm guessing uverbs should verify that before allocating a RAW_ETH QP for the user.

> +struct cmatest {
> +     struct rdma_event_channel *channel;
> +     struct cmatest_node     *nodes;
> +     int                     conn_index;
> +     int                     connects_left;
> +
> +     struct sockaddr_in6     dst_in;
> +     struct sockaddr         *dst_addr;
> +     struct sockaddr_in6     src_in;
> +     struct sockaddr         *src_addr;
> +     int                     fd[1024];

See comments below regarding the fd array usage.

> +};
> +
> +static struct cmatest test;
> +static int connections = 1;
> +static int message_size = 100;
> +static int message_count = 10;
> +static int is_sender;
> +static int unmapped_addr;
> +static char *dst_addr;
> +static char *src_addr;
> +static enum rdma_port_space port_space = RDMA_PS_UDP;
> +
> +int vlan_flag;
> +int vlan_ident;
> +
> +static int cq_len = 512;
> +static int qp_len = 256;
> +
> +uint16_t IP_CRC(void *buf, int hdr_len)
> +{
> +     unsigned long sum = 0;
> +     const uint16_t *ip1;
> +
> +     ip1 = (uint16_t *)buf;
> +     while (hdr_len > 1) {
> +             sum += *ip1++;
> +             if (sum & 0x80000000)
> +                     sum = (sum & 0xFFFF) + (sum >> 16);
> +             hdr_len -= 2;
> +     }
> +
> +     while (sum >> 16)
> +             sum = (sum & 0xFFFF) + (sum >> 16);
> +
> +     return ~sum;
> +}
> +
> +uint16_t udp_checksum(struct udphdr *udp_head,
> +             int header_size,
> +             int pay_load_size,
> +             uint32_t src_addr,
> +             uint32_t dest_addr,
> +             unsigned char *payload)
> +{
> +     uint16_t *buf = (void *)udp_head;
> +     uint16_t *ip_src = (void *)&src_addr;
> +     uint16_t *ip_dst = (void *)&dest_addr;
> +     uint32_t sum;
> +     size_t len = header_size;
> +
> +     sum = 0;
> +     while (len > 1) {
> +             sum += *buf++;
> +             if (sum & 0x80000000)
> +                     sum = (sum & 0xFFFF) + (sum >> 16);
> +             len -= 2;
> +     }
> +
> +     buf = (void *)payload;
> +     len = pay_load_size;
> +     while (len > 1) {
> +             sum += *buf++;
> +             if (sum & 0x80000000)
> +                     sum = (sum & 0xFFFF) + (sum >> 16);
> +             len -= 2;
> +     }
> +
> +     if (len & 1)
> +             sum += *((uint8_t *)buf);
> +     sum += *(ip_src++);
> +     sum += *ip_src;
> +
> +     sum += *(ip_dst++);
> +     sum += *ip_dst;
> +
> +     sum += htons(IPPROTO_UDP);
> +     len = (header_size + pay_load_size);
> +     sum += htons(len);
> +
> +     while (sum >> 16)
> +             sum = (sum & 0xFFFF) + (sum >> 16);
> +
> +     return (uint16_t)(~sum);
> +}

The above two calls look like candidates for common code - not part of librdmacm, but common to some other library that provides functionality similar to: ip_crc(), udp_checksum(), format_eth_hdr(), format_ip_hdr(), format_udp_hdr(), etc.  Even separating that functionality out into another source file would make it easier for another application to pick up and reuse.

> +static int create_message(struct cmatest_node *node)
> +{
> +     if (!message_size)
> +             message_count = 0;
> +
> +     if (!message_count)
> +             return 0;
> +
> +     node->mem = NULL;
> +     posix_memalign((void *)&node->mem, 4096,
> +                     (message_size + HEADER_LEN ) * sizeof(char));
> +     if (node->mem == NULL) {
> +             printf("failed message allocation\n");
> +             return -1;
> +     }
> +
> +     node->mr = ibv_reg_mr(node->pd, node->mem,
> +                             message_size + HEADER_LEN,
> +                             IBV_ACCESS_LOCAL_WRITE);
> +     if (!node->mr) {
> +             printf("failed to reg MR\n");
> +             goto err;
> +     }
> +     return 0;
> +err:
> +     free(node->mem);
> +     return -1;
> +}
> +
> +static int verify_test_params(struct cmatest_node *node)
> +{
> +     struct ibv_port_attr port_attr;
> +     int ret;
> +
> +     ret = ibv_query_port(node->cma_id->verbs, node->cma_id->port_num,
> +                          &port_attr);
> +     if (ret)
> +             return ret;
> +
> +     printf("\nibv_query_port %x\n", node->cma_id->port_num);
> +     if (message_count && message_size > (1 << (port_attr.active_mtu +
> 7))) {
> +             printf("mcraw: message_size %d is larger than active mtu %d\n",
> +                    message_size, 1 << (port_attr.active_mtu + 7));
> +             return -EINVAL;
> +     }
> +
> +     return 0;
> +}
> +
> +static int init_node(struct cmatest_node *node)
> +{
> +     struct ibv_qp_init_attr init_qp_attr;
> +     int cqe, ret;
> +
> +     node->pd = ibv_alloc_pd(node->cma_id->verbs);
> +     if (!node->pd) {
> +             ret = -ENOMEM;
> +             printf("mcraw: unable to allocate PD\n");
> +             goto out;
> +     }
> +     node->channel = ibv_create_comp_channel(node->cma_id->verbs);
> +     if (!(node->channel)) {
> +             printf("\nibv_create_comp_channel error\n");
> +             ret = -ENOMEM;
> +             goto out;
> +     }
> +
> +     cqe = cq_len;
> +     node->scq = ibv_create_cq(node->cma_id->verbs,
> +                             cqe, node, node->channel, 0);
> +     if (!node->scq) {
> +             ret = -ENOMEM;
> +             printf("mcraw: unable to create CQ\n");
> +             goto out;
> +     }
> +
> +     node->rcq = ibv_create_cq(node->cma_id->verbs,
> +                             cqe, node, node->channel, 0);
> +     if (!node->rcq) {
> +             ret = -ENOMEM;
> +             printf("mcraw: unable to create CQ\n");
> +             goto out;
> +     }
> +
> +     memset(&init_qp_attr, 0, sizeof init_qp_attr);
> +     init_qp_attr.cap.max_send_wr = qp_len;
> +     init_qp_attr.cap.max_recv_wr = qp_len;
> +     init_qp_attr.cap.max_send_sge = 1;
> +     init_qp_attr.cap.max_recv_sge = 1;
> +     init_qp_attr.qp_context = node;
> +     init_qp_attr.qp_type = IBV_QPT_RAW_ETH;
> +     init_qp_attr.send_cq = node->scq;
> +     init_qp_attr.recv_cq = node->rcq;
> +     ret = rdma_create_qp(node->cma_id, node->pd, &init_qp_attr);
> +     if (ret) {
> +             printf("mcraw: unable to create QP: %d\n", ret);
> +             goto out;
> +     }

I realize that this was written before the latest version of the librdmacm, but we can make use of optional parameters and let the librdmacm allocate the pd and cq for us.  There may be other areas where the code can be simplified; look at the rdma_verbs.h header file and latest man pages for rdma_create_qp, rdma_create_ep, and rdma_getaddrinfo.

> +
> +     printf("mcraw: qp ptr = %p\n", node->cma_id->qp);
> +
> +     ret = create_message(node);
> +     if (ret) {
> +             printf("mcraw: failed to create messages: %d\n", ret);
> +             goto out;
> +     }
> +out:
> +     return ret;
> +}
> +
> +static int post_recvs(struct cmatest_node *node, int num_to_post)
> +{
> +     struct ibv_recv_wr recv_wr, *recv_failure;
> +     struct ibv_sge sge;
> +     int i, ret = 0;
> +
> +     if (!message_count)
> +             return 0;
> +
> +     recv_wr.next = NULL;
> +     recv_wr.sg_list = &sge;
> +     recv_wr.num_sge = 1;
> +     recv_wr.wr_id = (uintptr_t) node;
> +
> +     sge.length = message_size + HEADER_LEN;
> +     sge.lkey = node->mr->lkey;
> +     sge.addr = (uintptr_t) node->mem;
> +
> +     for (i = 0; i < num_to_post && !ret; i++) {
> +             ret = ibv_post_recv(node->cma_id->qp, &recv_wr, &recv_failure);
> +             if (ret) {
> +                     printf("mcraw: failed to post receives: %d\n", ret);
> +                     break;
> +             }
> +     }
> +     return ret;
> +}
> +
> +static int post_sends(struct cmatest_node *node, int signal_flag)
> +{

This function is in serious need of needing to be broken up.  o_O

> +     struct ibv_send_wr send_wr, *bad_send_wr;
> +     struct ibv_sge sge;
> +     int i, ret = 0;
> +     int eth_len = 0;
> +     int count = 0;
> +     int vlan_tag = 0;
> +
> +     char eth_hdr[14];
> +
> +     int fd;
> +     int numifs = 100;
> +     int bufsize;
> +     struct ifreq *reqbuf;
> +     struct ifconf ifc;
> +     struct ifreq *ifr;
> +     struct vlan_ioctl_args ifreq_vlan;
> +     uint32_t haddr = inet_addr(src_addr);
> +     int n = 0;
> +     struct sockaddr_in *sin;
> +     unsigned char *pUDPData;
> +     struct iphdr *ip_head;
> +     struct udphdr *udp_head;
> +     short int Datagram_size, UDP_packet_size;

Can we avoid mixed case variable names?

> +
> +     memset(&eth_hdr[0], 0, sizeof(eth_hdr));
> +
> +     if (!node->connected || !message_count)
> +             return 0;
> +
> +     ip_head = (struct iphdr *)calloc(1, sizeof(struct iphdr));
> +     if (ip_head == NULL) {
> +             printf("\nerror\n");
> +             return -1;
> +     }
> +
> +     udp_head = (struct udphdr *)calloc(1, sizeof(struct udphdr));
> +     if (udp_head == NULL) {
> +             printf("\nerror\n");
> +             return -1;
> +     }

I don't understand the need to allocate separate buffers for ip_head, udp_head, and pUDPData only to copy them into a single buffer later and free them.  Can't we just define some structure that contains the Ethernet, IP, and UDP headers and cast node->mem to it?

> +
> +
> +     Datagram_size = message_size + sizeof(struct iphdr) + sizeof(struct
> udphdr);
> +     UDP_packet_size = message_size  + sizeof(struct udphdr);
> +

// start of new call
void format_ip_hdr(...)
{

> +     ip_head->version = 0x4;
> +     ip_head->ihl = 0x5;
> +     ip_head->tos = 0x00;
> +     ip_head->tot_len = ntohs(Datagram_size);
> +     ip_head->id = ntohs(0x0000);
> +     ip_head->frag_off = ntohs(0x4000);

We want hton here instead of ntoh to better document the usage.

> +     ip_head->ttl = 0x01;
> +     ip_head->protocol = 0x11;
> +
> +     ip_head->saddr = inet_addr(src_addr);
> +     ip_head->daddr = inet_addr(dst_addr);
> +     ip_head->check = IP_CRC((void *)ip_head, sizeof(struct iphdr));

}
// end format_ip_hdr

> +
> +     /* Fill udp CRC at user space */
> +     udp_head->source = ntohs(12345);
> +     udp_head->dest = ntohs(12345);

Where did 12345 come from?

> +     udp_head->len = ntohs(UDP_packet_size);

hton

> +     pUDPData = (unsigned char *)malloc(sizeof(char) * message_size);

message_size is in bytes.  What's the purpose behind multiplying by sizeof(char)?

> +
> +     if (pUDPData == NULL) {
> +             printf("\nmalloc errro\n");
> +             return -1;
> +     }
> +


> +     fd = socket(AF_INET, SOCK_DGRAM, 0);
> +     if (fd < 0)
> +             return -1;
> +
> +
> +     bufsize = numifs * sizeof(struct ifreq);
> +     reqbuf = (struct ifreq *)malloc(bufsize);
> +     if (reqbuf == NULL) {
> +             fprintf(stderr, "out of memory\n");
> +             return -1;
> +     }
> +     ifc.ifc_buf = (caddr_t)&reqbuf[0];
> +     ifc.ifc_len = bufsize;
> +
> +     if (ioctl(fd, SIOCGIFCONF, (char *)&ifc) == -1) {
> +             perror("ioctl(SIOCGIFCONF)");
> +             close(fd);
> +             free(reqbuf);
> +             return -1;
> +     }
> +
> +     ifr = ifc.ifc_req;
> +
> +     for (n = ifc.ifc_len/sizeof(struct ifreq); --n >= 0; ifr++) {
> +             if (ifr->ifr_addr.sa_family != AF_INET)
> +                     continue;
> +
> +             if (ioctl(fd, SIOCGIFFLAGS, (char *) ifr) < 0) {
> +                     perror("ioctl(SIOCGIFFLAGS)");
> +                     close(fd);
> +                     free(reqbuf);
> +                     return -1;
> +             }
> +
> +             /* Skip boring cases */
> +             if ((ifr->ifr_flags & IFF_UP) == 0)
> +                     continue;
> +             if (ifr->ifr_flags & IFF_LOOPBACK)
> +                     continue;
> +             if ((ifr->ifr_flags & IFF_POINTOPOINT))
> +                     continue;
> +             sin = (struct sockaddr_in *)&ifr->ifr_addr;
> +
> +             if (haddr != sin->sin_addr.s_addr) {
> +                     continue;
> +             }
> +             if (ioctl(fd, SIOCGIFHWADDR, ifr) < 0) {
> +                     perror("ioctl(SIOCGIFHWADD)");
> +                     close(fd);
> +                     free(reqbuf);
> +                     return -1;
> +             }
> +             vlan_flag = 0;
> +
> +#if LINUX_VERSION_CODE > KERNEL_VERSION(2, 6, 9)
> +             memset(&ifreq_vlan, 0, sizeof(ifreq_vlan));
> +
> +             ifreq_vlan.cmd = GET_VLAN_VID_CMD;
> +             strcpy(ifreq_vlan.device1, ifr->ifr_name);
> +             vlan_ident = 0;
> +             if (ioctl(fd, SIOCSIFVLAN, &ifreq_vlan) >= 0) {
> +                     vlan_flag = 1;
> +                     vlan_ident = 0;
> +                     vlan_ident = (VLAN_PRIORITY << 13) |
> +                                     (ifreq_vlan.u.VID & 0xfff);
> +             }
> +#endif

IMO, a user of the librdmacm shouldn't need to do anything like the above code.  This steps outside of the RDMA stack in an unnatural way.  rdma_bind_addr should return the underlying HW address.  Steve Wise submitted a fix for this, but it hasn't been merged upstream that I see.  The vlan part is missing, so would need to be added.

> +
> +             eth_hdr[0] = 0x01;
> +             eth_hdr[1] = 0x00;
> +             eth_hdr[2] = 0x5e;
> +             eth_hdr[3] = ((ip_head->daddr) >> 8) & 0x7f;
> +             eth_hdr[4] = ((ip_head->daddr) >> 16) & 0xff;
> +             eth_hdr[5] = ((ip_head->daddr) >> 24) & 0xff;

Putting this into a well named function would help document what this assignment is.

> +
> +
> +             eth_hdr[6] = ifr->ifr_hwaddr.sa_data[0];
> +             eth_hdr[7] = ifr->ifr_hwaddr.sa_data[1];
> +             eth_hdr[8] = ifr->ifr_hwaddr.sa_data[2];
> +             eth_hdr[9] = ifr->ifr_hwaddr.sa_data[3];
> +             eth_hdr[10] = ifr->ifr_hwaddr.sa_data[4];
> +             eth_hdr[11] = ifr->ifr_hwaddr.sa_data[5];
> +
> +             eth_hdr[12] = 0x08;
> +             eth_hdr[13] = 0x00;

Can we define struct ethhdr if it doesn't already exist somewhere?

> +
> +             close(fd);
> +             free(reqbuf);
> +             break;
> +     }
> +
> +     for (i = 0; i < message_size; i++)
> +             pUDPData[i] = i+1;
> +
> +     udp_head->check = udp_checksum(udp_head,
> +             sizeof(struct udphdr),
> +             (message_size - (sizeof(struct iphdr) + UDP_HEADER_SIZE)),
> +             inet_addr(src_addr),
> +             inet_addr(dst_addr),
> +             pUDPData);
> +
> +     eth_len = 14;
> +     memcpy((void *)node->mem, (void *)eth_hdr, eth_len);
> +     memcpy((void *)node->mem + eth_len, (void *)ip_head,
> +                             sizeof(struct iphdr));
> +     memcpy(((void *)node->mem) + eth_len + sizeof(struct iphdr),
> +             (void *)udp_head, UDP_HEADER_SIZE);
> +     memcpy(((void *)node->mem) + eth_len +
> +             sizeof(struct iphdr) + UDP_HEADER_SIZE,
> +             (void *)(pUDPData),
> +             message_size);
> +
> +     free(ip_head);
> +     free(pUDPData);
> +     free(udp_head);
> +

This is where I would start the actual post_send function.

> +     send_wr.next = NULL;
> +     send_wr.sg_list = &sge;
> +     send_wr.num_sge = 1;
> +     send_wr.opcode = IBV_WR_SEND_WITH_IMM;
> +     send_wr.send_flags = signal_flag;
> +     send_wr.wr_id = (unsigned long)node;
> +     send_wr.send_flags = IB_SEND_IP_CSUM;

libibverbs uses IBV_ for the prefix, and IBV_SEND_IP_CSUM would need to be defined.  It would help to know what that flag meant.

> +
> +     if (vlan_flag == 1) {
> +             vlan_tag = vlan_ident & 0xffff;
> +
> +             send_wr.send_flags |= IMA_VLAN_FLAG;

This flag is also not defined.  IMA VLAN?  ;)

> +             send_wr.imm_data = vlan_tag ;

Not knowing what the HW does, it seems odd to expose the raw ethernet frame to the user, but specify the vlan using immediate data rather than setting it directly into the frame.  Can someone explain the rationale behind this to me?

> +     }
> +     sge.length = message_size + HEADER_LEN;
> +     sge.lkey = node->mr->lkey;
> +     sge.addr = (uintptr_t) node->mem;
> +
> +     for (i = 0; i < message_count && !ret; i++) {
> +             struct ibv_wc wc;
> +
> +             ret = ibv_post_send(node->cma_id->qp, &send_wr, &bad_send_wr);
> +             if (ret)
> +                     printf("failed to post sends: ret = %d i = %d\n",
> +                                                             ret, i);
> +
> +             count = 0;
> +             while (count == 0) {
> +                     count = ibv_poll_cq(node->scq, 1, &wc);
> +                     if (count > 0)
> +                             printf("wc[%d].status = %d wr_id=%x\n", count,
> +                                                     wc.status,
> +                                                     (unsigned int)wc.wr_id);
> +                     if (count < 0) {
> +                             printf("mcraw: failed polling SCQ: %d\n", ret);
> +                             return ret;
> +                     }
> +             }
> +     }
> +     return ret;
> +}
> +
> +static void connect_error(void)
> +{
> +     test.connects_left--;
> +}
> +
> +static int addr_handler(struct cmatest_node *node)
> +{
> +     int ret;
> +
> +     unsigned char mcast_mac_addr[6];
> +     union ibv_gid sgid;
> +     struct sockaddr_in      *multicast_address;
> +     ret = verify_test_params(node);
> +     if (ret)
> +             goto err;
> +
> +     ret = init_node(node);
> +     if (ret)
> +             goto err;
> +
> +     if (!is_sender) {
> +             ret = post_recvs(node, qp_len);
> +             if (ret)
> +                     goto err;
> +     }
> +
> +     multicast_address = (struct sockaddr_in *) test.dst_addr;
> +
> +     mcast_mac_addr[0] = 0x01;
> +     mcast_mac_addr[1] = 0x00;
> +     mcast_mac_addr[2] = 0x5e;
> +     mcast_mac_addr[3] = (multicast_address->sin_addr.s_addr >> 8) & 0x7f;
> +     mcast_mac_addr[4] = (multicast_address->sin_addr.s_addr >> 16) &
> 0xff;
> +     mcast_mac_addr[5] = (multicast_address->sin_addr.s_addr >> 24) &
> 0xff;

A function for this sort of assignment would be nice.  :)

> +
> +     /* compatybility issue with ibv_attach_mcast */
> +     memset(&sgid, 0, sizeof(sgid));
> +
> +     /* multicast address is in last 6 bytes of gid raw */
> +     memcpy(&sgid.raw[10], mcast_mac_addr, 6);
> +
> +     ret = ibv_attach_mcast(node->cma_id->qp, &sgid, 0);

Someone help me out here.  Is this the right interface?  This takes an IPv4 address, maps it to Ethernet, then uses that as a GID for the multicast group to join.  Would we be better off just using the IPv4 address directly into a call like rdma_join_multicast, and/or passing an IPv4 mapped IPv6 address into ibv_attach_mcast?

I think Or was recommending that the join go through rdma_join_multicast rather than calling ibv_attach_mcast directly.  Either way should work, but is the value passed into ibv_attach_mcast in the ideal format?

> +     if (ret) {
> +             printf("mcraw: ibv_attach_mcast: %d\n", ret);
> +             connect_error();
> +             return ret;
> +     }
> +     node->connected = 1;
> +     test.connects_left--;
> +     return 0;
> +err:
> +     connect_error();
> +     return ret;
> +}
> +
> +
> +static void destroy_node(struct cmatest_node *node)
> +{
> +     if (!node->cma_id)
> +             return;
> +
> +
> +     if (node->cma_id->qp)
> +             rdma_destroy_qp(node->cma_id);
> +
> +     if (node->scq)
> +             ibv_destroy_cq(node->scq);
> +
> +     if (node->rcq)
> +             ibv_destroy_cq(node->rcq);
> +
> +     if (node->mem) {
> +             ibv_dereg_mr(node->mr);
> +             free(node->mem);
> +     }
> +
> +     if (node->pd)
> +             ibv_dealloc_pd(node->pd);
> +
> +     /* Destroy the RDMA ID after all device resources */
> +     rdma_destroy_id(node->cma_id);
> +}
> +
> +static int alloc_nodes(void)
> +{
> +     int ret, i;
> +
> +     test.nodes = malloc(sizeof *test.nodes * connections);
> +     if (!test.nodes) {
> +             printf("mcraw: unable to allocate memory for test nodes\n");
> +             return -ENOMEM;
> +     }
> +     memset(test.nodes, 0, sizeof *test.nodes * connections);
> +
> +     for (i = 0; i < connections; i++) {
> +             test.nodes[i].id = i;
> +             ret = rdma_create_id(test.channel, &test.nodes[i].cma_id,
> +                                  &test.nodes[i], port_space);
> +             if (ret)
> +                     goto err;
> +     }
> +     return 0;
> +err:
> +     while (--i >= 0)
> +             rdma_destroy_id(test.nodes[i].cma_id);
> +     free(test.nodes);
> +     return ret;
> +}
> +
> +static void destroy_nodes(void)
> +{
> +     int i;
> +
> +     for (i = 0; i < connections; i++)
> +             destroy_node(&test.nodes[i]);
> +     free(test.nodes);
> +}
> +
> +static int poll_cqs(void)
> +{
> +     struct ibv_wc wc;
> +     int i, ret;
> +     int count = 0;
> +     for (i = 0; i < connections; i++) {
> +             if (!test.nodes[i].connected)
> +                     continue;
> +
> +             while (count < message_count) {
> +                     ret = ibv_poll_cq(test.nodes[i].rcq, 1, &wc);
> +                     if (ret > 0) {
> +                             count += ret;
> +                             printf("mcraw: wc.status=%d wr_id=%d vid=%d\n",
> +                                     wc.status,
> +                                     (unsigned int)wc.wr_id,
> +                                     wc.pkey_index);
> +                             ret = post_recvs(&test.nodes[i], 1);
> +                             if (ret != 0)
> +                                     printf("mcraw: cannot post a buffer\n");
> +                     }
> +                     if (ret < 0) {
> +                             printf("mcraw: failed polling CQ: %d\n", ret);
> +                             return ret;
> +                     }
> +             }
> +     }
> +     return 0;
> +}
> +
> +
> +static int get_addr(char *dst, struct sockaddr *addr)
> +{
> +     struct addrinfo *res;
> +     int ret;
> +
> +     ret = getaddrinfo(dst, NULL, NULL, &res);

The newer version of the librdmacm provides the call rdma_getaddrinfo, which may be easier to use.  It may need to be updated to handle the new QP type.

> +     if (ret) {
> +             printf("getaddrinfo failed - invalid hostname or IP
> address\n");
> +             return ret;
> +     }
> +
> +     memcpy(addr, res->ai_addr, res->ai_addrlen);
> +     freeaddrinfo(res);
> +     return ret;
> +}
> +
> +static int run(void)
> +{
> +     int i, ret;
> +
> +     struct ip_mreq group;
> +     printf("mcraw: starting %s\n", is_sender ? "client" : "server");
> +     if (src_addr) {
> +             ret = get_addr(src_addr, (struct sockaddr *) &test.src_in);
> +             if (ret)
> +                     return ret;
> +     }
> +
> +     ret = get_addr(dst_addr, (struct sockaddr *) &test.dst_in);
> +     if (ret)
> +             return ret;
> +
> +     printf("mcraw: joining\n");
> +     for (i = 0; i < connections; i++) {
> +             if (src_addr) {
> +                     ret = rdma_bind_addr(test.nodes[i].cma_id,
> +                                          test.src_addr);
> +                     if (ret) {
> +                             printf("mcraw: addr bind failure: %d\n", ret);
> +                             connect_error();
> +                             return ret;
> +                     }
> +             }
> +             printf("mcraw: get socket\n");
> +
> +             test.fd[i] = socket(AF_INET, SOCK_DGRAM, 0);
> +             if (test.fd[i] < 0) {
> +                     printf("mcraw: cannot open socket\n");
> +                     connect_error();
> +                     return -1;
> +             }
> +
> +             group.imr_multiaddr.s_addr = inet_addr(dst_addr);
> +             group.imr_interface.s_addr = inet_addr(src_addr);
> +
> +             if (setsockopt(test.fd[i], IPPROTO_IP,
> +                                     IP_ADD_MEMBERSHIP,
> +                                     &group, sizeof(group)) < 0) {
> +                     printf("mcraw: Cannot subscribe multicast\n");
> +                     connect_error();
> +                     return -1;
> +             }

Again, I don't think an RDMA app should need to step outside of the RDMA stack like this.  I would rather this functionality be performed by the driver or library as part of attaching to the multicast group.

> +
> +             printf("mcraw: joining\n");
> +
> +             ret = addr_handler(&test.nodes[i]);
> +             if (ret) {
> +                     printf("mcraw: resolve addr failure: %d\n", ret);
> +                     connect_error();
> +                     return ret;
> +             }
> +     }
> +
> +     /*
> +      * Pause to give SM chance to configure switches.  We don't want to
> +      * handle reliability issue in this simple test program.
> +      */
> +     printf("mcraw: sleep\n");
> +
> +     sleep(3);
> +
> +     if (message_count) {
> +             if (is_sender) {
> +                     printf("initiating data transfers\n");
> +                     for (i = 0; i < connections; i++) {
> +                             ret = post_sends(&test.nodes[i], 0);
> +                             if (ret)
> +                                     goto out;
> +                     }
> +             } else {
> +                     printf("receiving data transfers\n");
> +                     ret = poll_cqs();
> +                     if (ret)
> +                             goto out;
> +             }
> +             printf("data transfers complete\n");
> +     }
> +out:

I asked the code below, and it told me that it wants to find a nice little cozy function to live in.

> +     for (i = 0; i < connections; i++) {
> +             unsigned char mcast_mac_addr[6];
> +             union ibv_gid sgid;
> +             struct sockaddr_in      *multicast_address;
> +
> +             multicast_address = (struct sockaddr_in *) test.dst_addr;
> +
> +             mcast_mac_addr[0] = 0x01;
> +             mcast_mac_addr[1] = 0x00;
> +             mcast_mac_addr[2] = 0x5e;
> +             mcast_mac_addr[3] =
> +                     (multicast_address->sin_addr.s_addr >> 8) & 0x7f;
> +             mcast_mac_addr[4] =
> +                     (multicast_address->sin_addr.s_addr >> 16) & 0xff;
> +             mcast_mac_addr[5] =
> +                     (multicast_address->sin_addr.s_addr >> 24) & 0xff;

A function for something like this would be wonderful. ;)

> +
> +             /* compatybility issue with ibv_attach_mcast */
> +             memset(&sgid, 0, sizeof(sgid));
> +
> +             /* multicast address is in last 6 bytes of gid raw */
> +             memcpy(&sgid.raw[10], mcast_mac_addr, 6);
> +
> +             ret = ibv_detach_mcast(test.nodes[i].cma_id->qp, &sgid, 0);
> +             if (ret)
> +                     printf("mcraw: failure leaving: %d\n", ret);
> +
> +             close(test.fd[i]);
> +     }
> +     return ret;
> +}
> +
> +int main(int argc, char **argv)
> +{
> +     int op, ret;
> +
> +
> +     while ((op = getopt(argc, argv, "m:M:sb:c:C:S:p:v:")) != -1) {
> +             switch (op) {
> +             case 'm':
> +                     dst_addr = optarg;
> +                     break;
> +             case 's':
> +                     is_sender = 1;
> +                     break;
> +             case 'b':
> +                     src_addr = optarg;
> +                     test.src_addr = (struct sockaddr *) &test.src_in;
> +                     break;
> +             case 'c':
> +                     connections = atoi(optarg);
> +                     if (connections > 1024)
> +                                     connections = 1024;
> +                     if (connections <= 0)
> +                                     connections = 1;
> +                     break;
> +             case 'C':
> +                     message_count = atoi(optarg);
> +                     break;
> +             case 'S':
> +                     message_size = atoi(optarg);
> +                     break;
> +             case 'p':
> +                     port_space = strtol(optarg, NULL, 0);
> +                     break;
> +             case 'v':
> +                     vlan_flag = 1 ;
> +                     vlan_ident = strtol(optarg, NULL, 0);
> +                     break;
> +             default:
> +                     printf("usage: %s\n", argv[0]);
> +                     printf("\t-m multicast_address\n");
> +                     printf("\t[-s(ender)]\n");
> +                     printf("\t[-b bind_address]\n");
> +                     printf("\t[-c connections]\n");
> +                     printf("\t[-C message_count]\n");
> +                     printf("\t[-S message_size]\n");
> +                     printf("\t[-v vlan tag]\n");
> +                     printf("\t[-p port_space - %#x for UDP (default), "
> +                            "%#x for IPOIB]\n", RDMA_PS_UDP, RDMA_PS_IPOIB);

I would think that this is limited to UDP port space.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

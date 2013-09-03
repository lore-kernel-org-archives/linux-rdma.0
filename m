From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH 2/4] RDMA/nes: Add support for iWARP Port Mapper user
 space service
Date: Tue, 03 Sep 2013 11:16:42 -0500
Message-ID: <52260B6A.4090006@opengridcomputing.com>
References: <20130831194415.GA27632@TENIKOLO-MOBL1>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130831194415.GA27632@TENIKOLO-MOBL1>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, robert.o.sharp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, john.s.lacombe-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 8/31/2013 2:44 PM, Tatyana Nikolova wrote:
> Add support for iWARP Port Mapper (IWPM) user space service
>
> Signed-off-by: Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Reviewed-by: Robert Sharp <robert.o.sharp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Reviewed-by: Donald Wood <donald.e.wood-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Reviewed-by: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>
> ---
>   drivers/infiniband/hw/nes/Makefile      |    2 +-
>   drivers/infiniband/hw/nes/nes.c         |   16 +-
>   drivers/infiniband/hw/nes/nes.h         |    2 +
>   drivers/infiniband/hw/nes/nes_cm.c      |  189 ++++--
>   drivers/infiniband/hw/nes/nes_cm.h      |   12 +-
>   drivers/infiniband/hw/nes/nes_netlink.c | 1223 +++++++++++++++++++++++++++++++
>   drivers/infiniband/hw/nes/nes_netlink.h |  108 +++
>   drivers/infiniband/hw/nes/nes_nic.c     |    5 +
>   8 files changed, 1502 insertions(+), 55 deletions(-)
>   create mode 100644 drivers/infiniband/hw/nes/nes_netlink.c
>   create mode 100644 drivers/infiniband/hw/nes/nes_netlink.h
>
> diff --git a/drivers/infiniband/hw/nes/Makefile b/drivers/infiniband/hw/nes/Makefile
> index 97820c2..5b6cec2 100644
> --- a/drivers/infiniband/hw/nes/Makefile
> +++ b/drivers/infiniband/hw/nes/Makefile
> @@ -1,3 +1,3 @@
>   obj-$(CONFIG_INFINIBAND_NES) += iw_nes.o
>   
> -iw_nes-objs := nes.o nes_hw.o nes_nic.o nes_utils.o nes_verbs.o nes_cm.o nes_mgt.o
> +iw_nes-objs := nes.o nes_hw.o nes_nic.o nes_utils.o nes_verbs.o nes_cm.o nes_mgt.o nes_netlink.o
> diff --git a/drivers/infiniband/hw/nes/nes.c b/drivers/infiniband/hw/nes/nes.c
> index 4291410..9be43b3 100644
> --- a/drivers/infiniband/hw/nes/nes.c
> +++ b/drivers/infiniband/hw/nes/nes.c
> @@ -68,7 +68,6 @@ MODULE_VERSION(DRV_VERSION);
>   int max_mtu = 9000;
>   int interrupt_mod_interval = 0;
>   
> -
>   /* Interoperability */
>   int mpa_version = 1;
>   module_param(mpa_version, int, 0644);
> @@ -672,6 +671,18 @@ static int nes_probe(struct pci_dev *pcidev, const struct pci_device_id *ent)
>   	}
>   	nes_notifiers_registered++;
>   
> +	spin_lock_init(&nes_nlmsg_lock);
> +	spin_lock_init(&nes_mapping_lock);
> +
> +	/* List of submitted requests, searched for completions */
> +	INIT_LIST_HEAD(&nes_nlmsg_request_list);
> +	/* List of iwpm mappings in use */
> +	INIT_LIST_HEAD(&nes_mapping_info_list);
> +
> +	if (ibnl_add_client(RDMA_NL_NES, RDMA_NL_IWPM_NUM_OPS, nes_nl_cb_table))
> +		printk(KERN_ERR PFX "%s[%u]: Failed to add netlink callback\n",
> +			__func__, __LINE__);
> +
>   	INIT_DELAYED_WORK(&nesdev->work, nes_recheck_link_status);
>   
>   	/* Initialize network devices */
> @@ -707,6 +718,7 @@ static int nes_probe(struct pci_dev *pcidev, const struct pci_device_id *ent)
>   
>   	nes_debug(NES_DBG_INIT, "netdev_count=%d, nesadapter->netdev_count=%d\n",
>   			nesdev->netdev_count, nesdev->nesadapter->netdev_count);
> +	ibnl_remove_client(RDMA_NL_NES);
>   
>   	nes_notifiers_registered--;
>   	if (nes_notifiers_registered == 0) {
> @@ -770,6 +782,8 @@ static void nes_remove(struct pci_dev *pcidev)
>   				nesdev->nesadapter->netdev_count--;
>   			}
>   		}
> +	ibnl_remove_client(RDMA_NL_NES);
> +	nes_destroy_mapinfo_list();
>   
>   	nes_notifiers_registered--;
>   	if (nes_notifiers_registered == 0) {
> diff --git a/drivers/infiniband/hw/nes/nes.h b/drivers/infiniband/hw/nes/nes.h
> index 33cc589..21b8a86 100644
> --- a/drivers/infiniband/hw/nes/nes.h
> +++ b/drivers/infiniband/hw/nes/nes.h
> @@ -130,6 +130,7 @@
>   #define NES_DBG_IW_TX       0x00040000
>   #define NES_DBG_SHUTDOWN    0x00080000
>   #define NES_DBG_PAU         0x00100000
> +#define NES_DBG_NLMSG       0x00200000
>   #define NES_DBG_RSVD1       0x10000000
>   #define NES_DBG_RSVD2       0x20000000
>   #define NES_DBG_RSVD3       0x40000000
> @@ -165,6 +166,7 @@ do { \
>   #include "nes_user.h"
>   #include "nes_cm.h"
>   #include "nes_mgt.h"
> +#include "nes_netlink.h"
>   
>   extern int max_mtu;
>   #define max_frame_len (max_mtu+ETH_HLEN)
> diff --git a/drivers/infiniband/hw/nes/nes_cm.c b/drivers/infiniband/hw/nes/nes_cm.c
> index 6b29249..ec14466 100644
> --- a/drivers/infiniband/hw/nes/nes_cm.c
> +++ b/drivers/infiniband/hw/nes/nes_cm.c
> @@ -59,6 +59,7 @@
>   #include <net/route.h>
>   #include <net/ip_fib.h>
>   #include <net/tcp.h>
> +#include <linux/fcntl.h>
>   
>   #include "nes.h"
>   
> @@ -450,11 +451,11 @@ static void form_cm_frame(struct sk_buff *skb,
>   	iph->ttl = 0x40;
>   	iph->protocol = 0x06;   /* IPPROTO_TCP */
>   
> -	iph->saddr = htonl(cm_node->loc_addr);
> -	iph->daddr = htonl(cm_node->rem_addr);
> +	iph->saddr = htonl(cm_node->mapped_loc_addr);
> +	iph->daddr = htonl(cm_node->mapped_rem_addr);
>   
> -	tcph->source = htons(cm_node->loc_port);
> -	tcph->dest = htons(cm_node->rem_port);
> +	tcph->source = htons(cm_node->mapped_loc_port);
> +	tcph->dest = htons(cm_node->mapped_rem_port);
>   	tcph->seq = htonl(cm_node->tcp_cntxt.loc_seq_num);
>   
>   	if (flags & SET_ACK) {
> @@ -1100,8 +1101,11 @@ static struct nes_cm_node *find_node(struct nes_cm_core *cm_core,
>   			  loc_addr, loc_port,
>   			  cm_node->rem_addr, cm_node->rem_port,
>   			  rem_addr, rem_port);
> -		if ((cm_node->loc_addr == loc_addr) && (cm_node->loc_port == loc_port) &&
> -		    (cm_node->rem_addr == rem_addr) && (cm_node->rem_port == rem_port)) {
> +		if ((cm_node->mapped_loc_addr == loc_addr) &&
> +			(cm_node->mapped_loc_port == loc_port) &&
> +			(cm_node->mapped_rem_addr == rem_addr) &&
> +			(cm_node->mapped_rem_port == rem_port)) {
> +
>   			add_ref_cm_node(cm_node);
>   			spin_unlock_irqrestore(&cm_core->ht_lock, flags);
>   			return cm_node;
> @@ -1118,18 +1122,28 @@ static struct nes_cm_node *find_node(struct nes_cm_core *cm_core,
>    * find_listener - find a cm node listening on this addr-port pair
>    */
>   static struct nes_cm_listener *find_listener(struct nes_cm_core *cm_core,
> -					     nes_addr_t dst_addr, u16 dst_port, enum nes_cm_listener_state listener_state)
> +					nes_addr_t dst_addr, u16 dst_port,
> +					enum nes_cm_listener_state listener_state, int local)
>   {
>   	unsigned long flags;
>   	struct nes_cm_listener *listen_node;
> +	nes_addr_t listen_addr;
> +	u16 listen_port;
>   
>   	/* walk list and find cm_node associated with this session ID */
>   	spin_lock_irqsave(&cm_core->listen_list_lock, flags);
>   	list_for_each_entry(listen_node, &cm_core->listen_list.list, list) {
> +		if (local) {
> +			listen_addr = listen_node->loc_addr;
> +			listen_port = listen_node->loc_port;
> +		} else {
> +			listen_addr = listen_node->mapped_loc_addr;
> +			listen_port = listen_node->mapped_loc_port;
> +		}
>   		/* compare node pair, return node handle if a match */
> -		if (((listen_node->loc_addr == dst_addr) ||
> -		     listen_node->loc_addr == 0x00000000) &&
> -		    (listen_node->loc_port == dst_port) &&
> +		if (((listen_addr == dst_addr) ||
> +		     listen_addr == 0x00000000) &&
> +		    (listen_port == dst_port) &&
>   		    (listener_state & listen_node->listener_state)) {
>   			atomic_inc(&listen_node->ref_count);
>   			spin_unlock_irqrestore(&cm_core->listen_list_lock, flags);
> @@ -1142,7 +1156,6 @@ static struct nes_cm_listener *find_listener(struct nes_cm_core *cm_core,
>   	return NULL;
>   }
>   
> -
>   /**
>    * add_hte_node - add a cm node to the hash table
>    */
> @@ -1263,9 +1276,12 @@ static int mini_cm_dec_refcnt_listen(struct nes_cm_core *cm_core,
>   
>   		spin_unlock_irqrestore(&cm_core->listen_list_lock, flags);
>   
> -		if (listener->nesvnic)
> -			nes_manage_apbvt(listener->nesvnic, listener->loc_port,
> +		if (listener->nesvnic) {
> +			nes_manage_apbvt(listener->nesvnic, listener->mapped_loc_port,
>   					 PCI_FUNC(listener->nesvnic->nesdev->pcidev->devfn), NES_MANAGE_APBVT_DEL);
> +			nes_remove_mapping(listener->mapped_loc_addr, listener->mapped_loc_port);
> +			nes_debug(NES_DBG_NLMSG, "Delete APBVT mapped_loc_port = %04X\n", listener->mapped_loc_port);
> +		}
>   
>   		nes_debug(NES_DBG_CM, "destroying listener (%p)\n", listener);
>   
> @@ -1408,6 +1424,11 @@ static struct nes_cm_node *make_cm_node(struct nes_cm_core *cm_core,
>   	cm_node->loc_port = cm_info->loc_port;
>   	cm_node->rem_port = cm_info->rem_port;
>   
> +	cm_node->mapped_loc_addr = cm_info->mapped_loc_addr;
> +	cm_node->mapped_rem_addr = cm_info->mapped_rem_addr;
> +	cm_node->mapped_loc_port = cm_info->mapped_loc_port;
> +	cm_node->mapped_rem_port = cm_info->mapped_rem_port;
> +
>   	cm_node->mpa_frame_rev = mpa_version;
>   	cm_node->send_rdma0_op = SEND_RDMA_READ_ZERO;
>   	cm_node->ird_size = IETF_NO_IRD_ORD;
> @@ -1453,8 +1474,8 @@ static struct nes_cm_node *make_cm_node(struct nes_cm_core *cm_core,
>   	cm_node->loopbackpartner = NULL;
>   
>   	/* get the mac addr for the remote node */
> -	oldarpindex = nes_arp_table(nesdev, cm_node->rem_addr, NULL, NES_ARP_RESOLVE);
> -	arpindex = nes_addr_resolve_neigh(nesvnic, cm_info->rem_addr, oldarpindex);
> +	oldarpindex = nes_arp_table(nesdev, cm_node->mapped_rem_addr, NULL, NES_ARP_RESOLVE);
> +	arpindex = nes_addr_resolve_neigh(nesvnic, cm_node->mapped_rem_addr, oldarpindex);
>   	if (arpindex < 0) {
>   		kfree(cm_node);
>   		return NULL;
> @@ -1516,11 +1537,13 @@ static int rem_ref_cm_node(struct nes_cm_core *cm_core,
>   		mini_cm_dec_refcnt_listen(cm_core, cm_node->listener, 0);
>   	} else {
>   		if (cm_node->apbvt_set && cm_node->nesvnic) {
> -			nes_manage_apbvt(cm_node->nesvnic, cm_node->loc_port,
> -					 PCI_FUNC(
> -						 cm_node->nesvnic->nesdev->pcidev->devfn),
> +			nes_manage_apbvt(cm_node->nesvnic, cm_node->mapped_loc_port,
> +					 PCI_FUNC(cm_node->nesvnic->nesdev->pcidev->devfn),
>   					 NES_MANAGE_APBVT_DEL);
>   		}
> +		nes_debug(NES_DBG_NLMSG, "Delete APBVT mapped_loc_port = %04X\n",
> +					cm_node->mapped_loc_port);
> +		nes_remove_mapping(cm_node->mapped_loc_addr, cm_node->mapped_loc_port);
>   	}
>   
>   	atomic_dec(&cm_core->node_cnt);
> @@ -2192,13 +2215,15 @@ static struct nes_cm_listener *mini_cm_listen(struct nes_cm_core *cm_core,
>   {
>   	struct nes_cm_listener *listener;
>   	unsigned long flags;
> +	int async = 0;
> +	int iwpm_err = 0;
>   
>   	nes_debug(NES_DBG_CM, "Search for 0x%08x : 0x%04x\n",
>   		  cm_info->loc_addr, cm_info->loc_port);
>   
>   	/* cannot have multiple matching listeners */
>   	listener = find_listener(cm_core, htonl(cm_info->loc_addr),
> -				 htons(cm_info->loc_port), NES_CM_LISTENER_EITHER_STATE);
> +				 htons(cm_info->loc_port), NES_CM_LISTENER_EITHER_STATE, 1);
>   	if (listener && listener->listener_state == NES_CM_LISTENER_ACTIVE_STATE) {
>   		/* find automatically incs ref count ??? */
>   		atomic_dec(&listener->ref_count);
> @@ -2207,6 +2232,21 @@ static struct nes_cm_listener *mini_cm_listen(struct nes_cm_core *cm_core,
>   	}
>   
>   	if (!listener) {
> +		if (nes_iwpm_pid == NES_IWPM_PID_UNDEFINED) {
> +			iwpm_err = nes_register_iwpm_pid(nesvnic->netdev->name,
> +						nesvnic->nesibdev->ibdev.name, async, NULL);
> +			if (iwpm_err) {
> +				nes_iwpm_pid = NES_IWPM_PID_ERROR;
> +				nes_debug(NES_DBG_NLMSG, "Port Mapper register pid failure (err = %d).\n", iwpm_err);
> +			}
> +		}
> +		if (nes_iwpm_pid > 0) { /* valid iwpm pid */
> +			iwpm_err = nes_add_mapping(cm_info);
> +			if (iwpm_err)
> +				nes_debug(NES_DBG_NLMSG, "Port Mapper query failure (err = %d).\n", iwpm_err);
> +		}
> +		print_iwpm_available(nes_iwpm_pid);
> +
>   		/* create a CM listen node (1/2 node to compare incoming traffic to) */
>   		listener = kzalloc(sizeof(*listener), GFP_ATOMIC);
>   		if (!listener) {
> @@ -2216,6 +2256,8 @@ static struct nes_cm_listener *mini_cm_listen(struct nes_cm_core *cm_core,
>   
>   		listener->loc_addr = htonl(cm_info->loc_addr);
>   		listener->loc_port = htons(cm_info->loc_port);
> +		listener->mapped_loc_addr = htonl(cm_info->mapped_loc_addr);
> +		listener->mapped_loc_port = htons(cm_info->mapped_loc_port);
>   		listener->reused_node = 0;
>   
>   		atomic_set(&listener->ref_count, 1);
> @@ -2277,14 +2319,16 @@ static struct nes_cm_node *mini_cm_connect(struct nes_cm_core *cm_core,
>   
>   	if (cm_info->loc_addr == cm_info->rem_addr) {
>   		loopbackremotelistener = find_listener(cm_core,
> -						       ntohl(nesvnic->local_ipaddr), cm_node->rem_port,
> -						       NES_CM_LISTENER_ACTIVE_STATE);
> +						cm_node->mapped_loc_addr, cm_node->mapped_rem_port,
> +						NES_CM_LISTENER_ACTIVE_STATE, 0);
>   		if (loopbackremotelistener == NULL) {
>   			create_event(cm_node, NES_CM_EVENT_ABORTED);
>   		} else {
>   			loopback_cm_info = *cm_info;
>   			loopback_cm_info.loc_port = cm_info->rem_port;
>   			loopback_cm_info.rem_port = cm_info->loc_port;
> +			loopback_cm_info.mapped_loc_port = cm_info->mapped_rem_port;
> +			loopback_cm_info.mapped_rem_port = cm_info->mapped_loc_port;
>   			loopback_cm_info.cm_id = loopbackremotelistener->cm_id;
>   			loopbackremotenode = make_cm_node(cm_core, nesvnic,
>   							  &loopback_cm_info, loopbackremotelistener);
> @@ -2513,6 +2557,12 @@ static int mini_cm_recv_pkt(struct nes_cm_core *cm_core,
>   	nfo.rem_addr = ntohl(iph->saddr);
>   	nfo.rem_port = ntohs(tcph->source);
>   
> +	/* If port mapper is available these should be mapped address info */
> +	nfo.mapped_loc_addr = ntohl(iph->daddr);
> +	nfo.mapped_loc_port = ntohs(tcph->dest);
> +	nfo.mapped_rem_addr = ntohl(iph->saddr);
> +	nfo.mapped_rem_port = ntohs(tcph->source);
> +
>   	tmp_daddr = cpu_to_be32(iph->daddr);
>   	tmp_saddr = cpu_to_be32(iph->saddr);
>   
> @@ -2521,8 +2571,8 @@ static int mini_cm_recv_pkt(struct nes_cm_core *cm_core,
>   
>   	do {
>   		cm_node = find_node(cm_core,
> -				    nfo.rem_port, nfo.rem_addr,
> -				    nfo.loc_port, nfo.loc_addr);
> +				    nfo.mapped_rem_port, nfo.mapped_rem_addr,
> +				    nfo.mapped_loc_port, nfo.mapped_loc_addr);
>   
>   		if (!cm_node) {
>   			/* Only type of packet accepted are for */
> @@ -2531,9 +2581,9 @@ static int mini_cm_recv_pkt(struct nes_cm_core *cm_core,
>   				skb_handled = 0;
>   				break;
>   			}
> -			listener = find_listener(cm_core, nfo.loc_addr,
> -						 nfo.loc_port,
> -						 NES_CM_LISTENER_ACTIVE_STATE);
> +			listener = find_listener(cm_core, nfo.mapped_loc_addr,
> +						 nfo.mapped_loc_port,
> +						 NES_CM_LISTENER_ACTIVE_STATE, 0);
>   			if (!listener) {
>   				nfo.cm_id = NULL;
>   				nfo.conn_type = 0;
> @@ -3133,10 +3183,12 @@ int nes_accept(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
>   
>   	nes_cm_init_tsa_conn(nesqp, cm_node);
>   
> -	nesqp->nesqp_context->tcpPorts[0] = cpu_to_le16(ntohs(laddr->sin_port));
> -	nesqp->nesqp_context->tcpPorts[1] = cpu_to_le16(ntohs(raddr->sin_port));
> +	nesqp->nesqp_context->tcpPorts[0] =
> +				cpu_to_le16(cm_node->mapped_loc_port);
> +	nesqp->nesqp_context->tcpPorts[1] =
> +				cpu_to_le16(cm_node->mapped_rem_port);
>   
> -	nesqp->nesqp_context->ip0 = cpu_to_le32(ntohl(raddr->sin_addr.s_addr));
> +	nesqp->nesqp_context->ip0 = cpu_to_le32(cm_node->mapped_rem_addr);
>   
>   	nesqp->nesqp_context->misc2 |= cpu_to_le32(
>   		(u32)PCI_FUNC(nesdev->pcidev->devfn) <<
> @@ -3160,9 +3212,9 @@ int nes_accept(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
>   	memset(&nes_quad, 0, sizeof(nes_quad));
>   	nes_quad.DstIpAdrIndex =
>   		cpu_to_le32((u32)PCI_FUNC(nesdev->pcidev->devfn) << 24);
> -	nes_quad.SrcIpadr = raddr->sin_addr.s_addr;
> -	nes_quad.TcpPorts[0] = raddr->sin_port;
> -	nes_quad.TcpPorts[1] = laddr->sin_port;
> +	nes_quad.SrcIpadr = htonl(cm_node->mapped_rem_addr);
> +	nes_quad.TcpPorts[0] = htons(cm_node->mapped_rem_port);
> +	nes_quad.TcpPorts[1] = htons(cm_node->mapped_loc_port);
>   
>   	/* Produce hash key */
>   	crc_value = get_crc_value(&nes_quad);
> @@ -3261,6 +3313,9 @@ int nes_connect(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
>   	int apbvt_set = 0;
>   	struct sockaddr_in *laddr = (struct sockaddr_in *)&cm_id->local_addr;
>   	struct sockaddr_in *raddr = (struct sockaddr_in *)&cm_id->remote_addr;
> +	struct sockaddr_in local_sockaddr, mapped_sockaddr;
> +	int async = 0;
> +	int iwpm_err = 0;
>   
>   	if (cm_id->remote_addr.ss_family != AF_INET)
>   		return -ENOSYS;
> @@ -3304,13 +3359,6 @@ int nes_connect(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
>   	nes_debug(NES_DBG_CM, "mpa private data len =%u\n",
>   		  conn_param->private_data_len);
>   
> -	if (laddr->sin_addr.s_addr != raddr->sin_addr.s_addr) {
> -		nes_manage_apbvt(nesvnic, ntohs(laddr->sin_port),
> -				 PCI_FUNC(nesdev->pcidev->devfn),
> -				 NES_MANAGE_APBVT_ADD);
> -		apbvt_set = 1;
> -	}
> -
>   	/* set up the connection params for the node */
>   	cm_info.loc_addr = htonl(laddr->sin_addr.s_addr);
>   	cm_info.loc_port = htons(laddr->sin_port);
> @@ -3319,6 +3367,40 @@ int nes_connect(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
>   	cm_info.cm_id = cm_id;
>   	cm_info.conn_type = NES_CM_IWARP_CONN_TYPE;
>   
> +	/* No port mapper available, go with the specified peer information */
> +	cm_info.mapped_loc_addr = cm_info.loc_addr;
> +	cm_info.mapped_loc_port = cm_info.loc_port;
> +	cm_info.mapped_rem_addr = cm_info.rem_addr;
> +	cm_info.mapped_rem_port = cm_info.rem_port;
> +
> +	if (nes_iwpm_pid == NES_IWPM_PID_UNDEFINED) {
> +		iwpm_err = nes_register_iwpm_pid(nesvnic->netdev->name,
> +					nesvnic->nesibdev->ibdev.name, async, NULL);
> +		if (iwpm_err) {
> +			nes_iwpm_pid = NES_IWPM_PID_ERROR;
> +			nes_debug(NES_DBG_NLMSG, "Port Mapper register pid failure (err = %d).\n", iwpm_err);
> +		}
> +	}
> +	if (nes_iwpm_pid > 0) { /* valid iwpm pid */
> +		iwpm_err = nes_add_and_query_mapping(&cm_info);
> +		if (iwpm_err)
> +			nes_debug(NES_DBG_NLMSG, "Port Mapper query failure (err = %d).\n", iwpm_err);
> +	}
> +	print_iwpm_available(nes_iwpm_pid);
> +
> +	if (laddr->sin_addr.s_addr != raddr->sin_addr.s_addr) {
> +		nes_manage_apbvt(nesvnic, cm_info.mapped_loc_port,
> +			PCI_FUNC(nesdev->pcidev->devfn), NES_MANAGE_APBVT_ADD);
> +		apbvt_set = 1;
> +	}
> +
> +	nes_create_sockaddr(htonl(cm_info.loc_addr),
> +				htons(cm_info.loc_port), &local_sockaddr);
> +	nes_create_sockaddr(htonl(cm_info.mapped_loc_addr),
> +				htons(cm_info.mapped_loc_port), &mapped_sockaddr);
> +	if (nes_create_mapinfo(&local_sockaddr, &mapped_sockaddr))
> +		return -ENOMEM;
> +
>   	cm_id->add_ref(cm_id);
>   
>   	/* create a connect CM node connection */
> @@ -3327,10 +3409,13 @@ int nes_connect(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
>   					  &cm_info);
>   	if (!cm_node) {
>   		if (apbvt_set)
> -			nes_manage_apbvt(nesvnic, ntohs(laddr->sin_port),
> +			nes_manage_apbvt(nesvnic, cm_info.mapped_loc_port,
>   					 PCI_FUNC(nesdev->pcidev->devfn),
>   					 NES_MANAGE_APBVT_DEL);
>   
> +		nes_debug(NES_DBG_NLMSG, "Delete mapped_loc_port = %04X\n",
> +				cm_info.mapped_loc_port);
> +		nes_remove_mapping(cm_info.mapped_loc_addr, cm_info.mapped_loc_port);
>   		cm_id->rem_ref(cm_id);
>   		return -ENOMEM;
>   	}
> @@ -3354,6 +3439,7 @@ int nes_create_listen(struct iw_cm_id *cm_id, int backlog)
>   	struct nes_cm_info cm_info;
>   	int err;
>   	struct sockaddr_in *laddr = (struct sockaddr_in *)&cm_id->local_addr;
> +	struct sockaddr_in local_sockaddr, mapped_sockaddr;
>   
>   	nes_debug(NES_DBG_CM, "cm_id = %p, local port = 0x%04X.\n",
>   		  cm_id, ntohs(laddr->sin_port));
> @@ -3378,6 +3464,9 @@ int nes_create_listen(struct iw_cm_id *cm_id, int backlog)
>   
>   	cm_info.conn_type = NES_CM_IWARP_CONN_TYPE;
>   
> +	/* No port mapper available, go with the specified info */
> +	cm_info.mapped_loc_addr = cm_info.loc_addr;
> +	cm_info.mapped_loc_port = cm_info.loc_port;
>   
>   	cm_node = g_cm_core->api->listen(g_cm_core, nesvnic, &cm_info);
>   	if (!cm_node) {
> @@ -3389,7 +3478,13 @@ int nes_create_listen(struct iw_cm_id *cm_id, int backlog)
>   	cm_id->provider_data = cm_node;
>   
>   	if (!cm_node->reused_node) {
> -		err = nes_manage_apbvt(nesvnic, ntohs(laddr->sin_port),
> +		nes_create_sockaddr(cm_info.loc_addr, cm_info.loc_port, &local_sockaddr);
> +		nes_create_sockaddr(cm_info.mapped_loc_addr, cm_info.mapped_loc_port,
> +					&mapped_sockaddr);
> +		if (nes_create_mapinfo(&local_sockaddr, &mapped_sockaddr))
> +			return -ENOMEM;
> +
> +		err = nes_manage_apbvt(nesvnic, cm_node->mapped_loc_port,
>   				       PCI_FUNC(nesvnic->nesdev->pcidev->devfn),
>   				       NES_MANAGE_APBVT_ADD);
>   		if (err) {
> @@ -3514,9 +3609,9 @@ static void cm_event_connected(struct nes_cm_event *event)
>   	nes_cm_init_tsa_conn(nesqp, cm_node);
>   
>   	/* set the QP tsa context */
> -	nesqp->nesqp_context->tcpPorts[0] = cpu_to_le16(ntohs(laddr->sin_port));
> -	nesqp->nesqp_context->tcpPorts[1] = cpu_to_le16(ntohs(raddr->sin_port));
> -	nesqp->nesqp_context->ip0 = cpu_to_le32(ntohl(raddr->sin_addr.s_addr));
> +	nesqp->nesqp_context->tcpPorts[0] = cpu_to_le16(cm_node->mapped_loc_port);
> +	nesqp->nesqp_context->tcpPorts[1] = cpu_to_le16(cm_node->mapped_rem_port);
> +	nesqp->nesqp_context->ip0 = cpu_to_le32(cm_node->mapped_rem_addr);
>   
>   	nesqp->nesqp_context->misc2 |= cpu_to_le32(
>   			(u32)PCI_FUNC(nesdev->pcidev->devfn) <<
> @@ -3544,9 +3639,9 @@ static void cm_event_connected(struct nes_cm_event *event)
>   
>   	nes_quad.DstIpAdrIndex =
>   		cpu_to_le32((u32)PCI_FUNC(nesdev->pcidev->devfn) << 24);
> -	nes_quad.SrcIpadr = raddr->sin_addr.s_addr;
> -	nes_quad.TcpPorts[0] = raddr->sin_port;
> -	nes_quad.TcpPorts[1] = laddr->sin_port;
> +	nes_quad.SrcIpadr = htonl(cm_node->mapped_rem_addr);
> +	nes_quad.TcpPorts[0] = htons(cm_node->mapped_rem_port);
> +	nes_quad.TcpPorts[1] = htons(cm_node->mapped_loc_port);
>   
>   	/* Produce hash key */
>   	crc_value = get_crc_value(&nes_quad);
> diff --git a/drivers/infiniband/hw/nes/nes_cm.h b/drivers/infiniband/hw/nes/nes_cm.h
> index 4646e66..331a573 100644
> --- a/drivers/infiniband/hw/nes/nes_cm.h
> +++ b/drivers/infiniband/hw/nes/nes_cm.h
> @@ -291,8 +291,8 @@ struct nes_cm_listener {
>   	struct list_head           list;
>   	struct nes_cm_core         *cm_core;
>   	u8                         loc_mac[ETH_ALEN];
> -	nes_addr_t                 loc_addr;
> -	u16                        loc_port;
> +	nes_addr_t                 loc_addr, mapped_loc_addr;
> +	u16                        loc_port, mapped_loc_port;
>   	struct iw_cm_id            *cm_id;
>   	enum nes_cm_conn_type      conn_type;
>   	atomic_t                   ref_count;
> @@ -306,7 +306,9 @@ struct nes_cm_listener {
>   /* per connection node and node state information */
>   struct nes_cm_node {
>   	nes_addr_t                loc_addr, rem_addr;
> +	nes_addr_t                mapped_loc_addr, mapped_rem_addr;
>   	u16                       loc_port, rem_port;
> +	u16                       mapped_loc_port, mapped_rem_port;
>   
>   	u8                        loc_mac[ETH_ALEN];
>   	u8                        rem_mac[ETH_ALEN];
> @@ -357,10 +359,8 @@ struct nes_cm_info {
>   		struct net_device *netdev;
>   	};
>   
> -	u16 loc_port;
> -	u16 rem_port;
> -	nes_addr_t loc_addr;
> -	nes_addr_t rem_addr;
> +	u16 loc_port, rem_port, mapped_loc_port, mapped_rem_port;
> +	nes_addr_t loc_addr, rem_addr, mapped_loc_addr, mapped_rem_addr;
>   
>   	enum nes_cm_conn_type  conn_type;
>   	int backlog;
> diff --git a/drivers/infiniband/hw/nes/nes_netlink.c b/drivers/infiniband/hw/nes/nes_netlink.c
> new file mode 100644
> index 0000000..6408089
> --- /dev/null
> +++ b/drivers/infiniband/hw/nes/nes_netlink.c
> @@ -0,0 +1,1223 @@
> +/*
> + * Copyright (c) 2013 Intel Corporation.  All rights reserved.
> + *
> + * This software is available to you under a choice of one of two
> + * licenses.  You may choose to be licensed under the terms of the GNU
> + * General Public License (GPL) Version 2, available from the file
> + * COPYING in the main directory of this source tree, or the
> + * OpenIB.org BSD license below:
> + *
> + *     Redistribution and use in source and binary forms, with or
> + *     without modification, are permitted provided that the following
> + *     conditions are met:
> + *
> + *      - Redistributions of source code must retain the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer.
> + *
> + *      - Redistributions in binary form must reproduce the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer in the documentation and/or other materials
> + *        provided with the distribution.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> + * SOFTWARE.
> + */
> +
> +#define pr_fmt(fmt) "%s: " fmt, KBUILD_MODNAME
> +
> +#include "nes.h"
> +#include "nes_netlink.h"
> +
> +spinlock_t nes_nlmsg_lock;
> +struct list_head nes_nlmsg_request_list;
> +struct list_head nes_mapping_info_list;
> +spinlock_t nes_mapping_lock;
> +atomic_t nes_nlmsg_seq;
> +atomic_t echo_nlmsg_seq;
> +
> +int nes_iwpm_pid = NES_IWPM_PID_UNDEFINED;
> +static const char iwpm_ulib_name[] = "iWarpPortMapperUser";
> +static int iwpm_ulib_version = 3;
> +
> +static struct nes_nlmsg_request *nes_get_nlmsg_request(void);
> +static int nes_send_mapping_info(void);
> +static int nes_send_mapping_count(u32);
> +static int nes_parse_nlmsg(struct netlink_callback *, int, const struct nla_policy *,
> +				struct nlattr *[], const char *);
> +
> +/* nes netlink callbacks */
> +static int nes_register_iwpm_pid_cb(struct sk_buff *, struct netlink_callback *);
> +static int nes_add_mapping_cb(struct sk_buff *, struct netlink_callback *);
> +static int nes_add_and_query_mapping_cb(struct sk_buff *, struct netlink_callback *);
> +static int nes_mapping_error_cb(struct sk_buff *, struct netlink_callback *);
> +static int nes_mapping_info_cb(struct sk_buff *, struct netlink_callback *);
> +static int nes_ack_mapping_info_cb(struct sk_buff *, struct netlink_callback *);
> +
> +/*
> + * nes_get_nlmsg_request - Allocate and initialize a netlink request tracking object
> + */
> +static struct nes_nlmsg_request *nes_get_nlmsg_request(void)
> +{
> +	unsigned long flags;
> +	struct nes_nlmsg_request *nlmsg_request = NULL;
> +
> +	nlmsg_request = kzalloc(sizeof(struct nes_nlmsg_request), GFP_ATOMIC);
> +	if (!nlmsg_request) {
> +		pr_err("%s: Unable to allocate a nlmsg_request\n", __func__);
> +		return NULL;
> +	}
> +	spin_lock_irqsave(&nes_nlmsg_lock, flags);
> +	list_add_tail(&nlmsg_request->inprocess_list, &nes_nlmsg_request_list);
> +	spin_unlock_irqrestore(&nes_nlmsg_lock, flags);
> +

Same comment as for cxgb4:  I think you can use GFP_KERNEL for this 
alloc, and a mutex for this msg lock.

> +	atomic_set(&nlmsg_request->refcount, 1);
> +	nlmsg_request->nlmsg_seq = atomic_inc_return(&nes_nlmsg_seq);
> +	nlmsg_request->request_done = 0;
> +	nlmsg_request->async = 0;
> +	nlmsg_request->err_code = 0;
> +	return nlmsg_request;
> +}
> +
> +/*
> + * free_nlmsg_request - Free netlink request tracking object
> + */
> +static void free_nlmsg_request(struct nes_nlmsg_request *nlmsg_request)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&nes_nlmsg_lock, flags);
> +	list_del_init(&nlmsg_request->inprocess_list);
> +	spin_unlock_irqrestore(&nes_nlmsg_lock, flags);
> +
> +	if (nlmsg_request->async)
> +		del_timer(&nlmsg_request->service_timer);
> +
> +	if (!nlmsg_request->request_done)
> +		nes_debug(NES_DBG_NLMSG, "Freeing incomplete nlmsg request (seq = %u)\n",
> +			nlmsg_request->nlmsg_seq);
> +	kfree(nlmsg_request);
> +}
> +
> +/*
> + * rem_ref_nlmsg_request - Decrement the refcount and free the request
> + *			   object if the refcount is zero
> + */
> +static void rem_ref_nlmsg_request(struct nes_nlmsg_request *nlmsg_request)
> +{
> +	if (atomic_dec_and_test(&nlmsg_request->refcount))
> +		free_nlmsg_request(nlmsg_request);
> +}
> +

Could use krefs here for ref tracking/freeing.

> +/*
> + * nes_nlmsg_req_timer_free - Free expired request object
> + */
> +static void nes_nlmsg_req_timer_free(unsigned long data)
> +{
> +	struct nes_nlmsg_request *nlmsg_request = (struct nes_nlmsg_request *) data;
> +
> +	if (!nlmsg_request->request_done && !nlmsg_request->err_code)
> +		nes_iwpm_pid = NES_IWPM_PID_UNAVAILABLE;
> +
> +	if (nes_iwpm_pid < 0)
> +		nes_debug(NES_DBG_NLMSG, "Port Mapper isn't available (err code = %d)\n",
> +				 nlmsg_request->err_code);
> +	rem_ref_nlmsg_request(nlmsg_request);
> +}
> +
> +/*
> + * nes_mapinfo_timer_send - Send mapping info to the userspace port mapper
> + */
> +static void nes_mapinfo_timer_send(unsigned long data)
> +{
> +	int mapping_num;
> +
> +	nes_nlmsg_req_timer_free(data);
> +	if (nes_iwpm_pid < 0)
> +		return;
> +	mapping_num = nes_send_mapping_info();
> +	if (mapping_num < 0) {
> +		nes_debug(NES_DBG_NLMSG, "Unable to send mapping info\n");
> +		return;
> +	}
> +	nes_debug(NES_DBG_NLMSG, "Sending Mapping count msg (num = %d)\n", mapping_num);
> +	nes_send_mapping_count(mapping_num);
> +}
> +
> +/*
> + * nes_start_nlmsg_req_timer - Start a timer on a netlink request object
> + */
> +static void nes_start_nlmsg_req_timer(struct nes_nlmsg_request *nlmsg_request,
> +					void (*timer_func)(unsigned long), u32 delay)
> +{
> +	init_timer(&nlmsg_request->service_timer);
> +	setup_timer(&nlmsg_request->service_timer, timer_func,
> +			(unsigned long) nlmsg_request);
> +	mod_timer(&nlmsg_request->service_timer, jiffies + delay);
> +}
> +
> +/*
> + * nes_validate_nlmsg_attr - Check for NULL netlink attributes
> + */
> +static int nes_validate_nlmsg_attr(struct nlattr *nltb[], int nla_count)
> +{
> +	int i;
> +	for (i = 1; i < nla_count; i++) {
> +		if (!nltb[i])
> +			return -EINVAL;
> +	}
> +	return 0;
> +}
> +
> +/*
> + * nes_create_nlmsg - Allocate skb and form a netlink message
> + */
> +static struct sk_buff *nes_create_nlmsg(u32 nl_op, struct nlmsghdr **nlh)
> +{
> +	struct sk_buff *skb = NULL;
> +
> +	skb = dev_alloc_skb(NLMSG_GOODSIZE);
> +	if (!skb) {
> +		pr_err("%s: Unable to allocate skb\n", __func__);
> +		goto create_nlmsg_exit;
> +	}
> +	if (!(ibnl_put_msg(skb, nlh, 0, 0, RDMA_NL_NES, nl_op, NLM_F_REQUEST))) {
> +		pr_info("%s: Unable to put the nlmsg header\n", __func__);
> +		dev_kfree_skb(skb);
> +		skb = NULL;
> +	}
> +create_nlmsg_exit:
> +	return skb;
> +}
> +
> +/*
> + * nes_parse_nlmsg - Validate and parse the received netlink message
> + */
> +static int nes_parse_nlmsg(struct netlink_callback *cb, int policy_max,
> +			const struct nla_policy *nlmsg_policy,
> +			struct nlattr *nltb[], const char *msg_type)
> +{
> +	int nlh_len = 0;
> +	int ret;
> +	const char *err_str = "";
> +
> +	ret = nlmsg_validate(cb->nlh, nlh_len, policy_max-1, nlmsg_policy);
> +	if (ret) {
> +		err_str = "Invalid attribute";
> +		goto parse_nlmsg_error;
> +	}
> +	ret = nlmsg_parse(cb->nlh, nlh_len, nltb, policy_max-1, nlmsg_policy);
> +	if (ret) {
> +		err_str = "Unable to parse the nlmsg";
> +		goto parse_nlmsg_error;
> +	}
> +	ret = nes_validate_nlmsg_attr(nltb, policy_max);
> +	if (ret) {
> +		err_str = "Invalid NULL attribute";
> +		goto parse_nlmsg_error;
> +	}
> +	return 0;
> +parse_nlmsg_error:
> +	pr_info("%s: %s (msg type %s ret = %d)\n", __func__, err_str, msg_type, ret);
> +	return ret;
> +}
> +
> +/*
> + * wait_complete_nlmsg_req - Block while servicing the netlink request
> + *
> + * Wake up, after the request is completed or expired
> + */
> +static int wait_complete_nlmsg_req(struct nes_nlmsg_request *nlmsg_request, int iwpm_pid)
> +{
> +	int ret;
> +	init_waitqueue_head(&nlmsg_request->waitq);
> +
> +	ret = wait_event_timeout(nlmsg_request->waitq, (nlmsg_request->request_done != 0),
> +					NES_IWPM_NL_TIMEOUT);
> +	if (!ret) {
> +		nes_iwpm_pid = iwpm_pid;
> +		pr_info("%s: Timeout %d sec for netlink request (seq = %u)\n",
> +			__func__, (NES_IWPM_NL_TIMEOUT/HZ), nlmsg_request->nlmsg_seq);
> +	} else
> +		ret = nlmsg_request->err_code;
> +
> +	rem_ref_nlmsg_request(nlmsg_request);
> +	return ret;
> +}
> +
> +/*
> + * nes_find_nlmsg_request - Find a request object using its sequence number
> + */
> +static struct nes_nlmsg_request *nes_find_nlmsg_request(__u32 echo_seq)
> +{
> +	struct nes_nlmsg_request *nlmsg_request;
> +	struct nes_nlmsg_request *found_request = NULL;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&nes_nlmsg_lock, flags);
> +	list_for_each_entry(nlmsg_request, &nes_nlmsg_request_list, inprocess_list) {
> +		nes_debug(NES_DBG_NLMSG, "Looking at a request with seq = %u\n",
> +				nlmsg_request->nlmsg_seq);
> +		if (nlmsg_request->nlmsg_seq == echo_seq) {
> +			found_request = nlmsg_request;
> +			atomic_inc(&nlmsg_request->refcount);
> +			break;
> +		}
> +	}
> +	spin_unlock_irqrestore(&nes_nlmsg_lock, flags);
> +	return found_request;
> +}
> +
> +/*
> + * nes_create_sockaddr - Record ip addr and tcp port in a sockaddr struct
> + */
> +void nes_create_sockaddr(__be32 s_addr, __be16 s_port, struct sockaddr_in *cm_sockaddr)
> +{
> +	cm_sockaddr->sin_family = AF_INET;
> +	memcpy(&cm_sockaddr->sin_addr.s_addr, &s_addr, sizeof(__be32));
> +	cm_sockaddr->sin_port = s_port;
> +}
> +
> +/*
> + * nes_create_mapinfo - Create mapping info record
> + */
> +int nes_create_mapinfo(struct sockaddr_in *local_sockaddr,
> +				struct sockaddr_in *mapped_sockaddr)
> +{
> +	struct nes_mapping_info *map_info;
> +	unsigned long flags;
> +
> +	map_info = kzalloc(sizeof(struct nes_mapping_info), GFP_KERNEL);
> +	if (!map_info) {
> +		pr_err("%s: Unable to allocate a mapping info\n", __func__);
> +		return -ENOMEM;
> +	}
> +	memcpy(&map_info->local_sockaddr, local_sockaddr, sizeof(struct sockaddr_in));
> +	memcpy(&map_info->mapped_sockaddr, mapped_sockaddr, sizeof(struct sockaddr_in));
> +
> +	spin_lock_irqsave(&nes_mapping_lock, flags);
> +	list_add_tail(&map_info->mapping_list, &nes_mapping_info_list);
> +	spin_unlock_irqrestore(&nes_mapping_lock, flags);
> +	return 0;
> +}
> +
> +/*
> + * nes_remove_mapinfo - Remove mapping info record
> + */
> +int nes_remove_mapinfo(struct sockaddr_in *mapped_sockaddr)
> +{
> +	struct nes_mapping_info *map_info = NULL;
> +	unsigned long flags;
> +	int ret = -EINVAL;
> +
> +	nes_debug(NES_DBG_NLMSG, "Remove mapped addr %pI4 [0x%04X]\n",
> +			&mapped_sockaddr->sin_addr.s_addr, mapped_sockaddr->sin_port);
> +
> +	spin_lock_irqsave(&nes_mapping_lock, flags);
> +	list_for_each_entry(map_info, &nes_mapping_info_list, mapping_list) {
> +		if (!memcmp(&map_info->mapped_sockaddr.sin_addr,
> +			&mapped_sockaddr->sin_addr, sizeof(__be32)) &&
> +			map_info->mapped_sockaddr.sin_port == mapped_sockaddr->sin_port) {
> +
> +			list_del_init(&map_info->mapping_list);
> +			kfree(map_info);
> +			ret = 0;
> +			break;
> +		}
> +	}
> +	spin_unlock_irqrestore(&nes_mapping_lock, flags);
> +	return ret;
> +}
> +
> +/*
> + * nes_destroy_mapinfo_list - Delete all mapping info records
> + */
> +void nes_destroy_mapinfo_list(void)
> +{
> +	struct nes_mapping_info *map_info, *map_info_tmp;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&nes_mapping_lock, flags);
> +	list_for_each_entry_safe(map_info, map_info_tmp,
> +					&nes_mapping_info_list, mapping_list) {
> +
> +		nes_debug(NES_DBG_NLMSG, "Delete mapped addr %pI4 [0x%04X]\n",
> +			&map_info->mapped_sockaddr.sin_addr.s_addr,
> +			map_info->mapped_sockaddr.sin_port);
> +
> +		list_del(&map_info->mapping_list);
> +		kfree(map_info);
> +	}
> +	spin_unlock_irqrestore(&nes_mapping_lock, flags);
> +}
> +
> +/*
> + * print_iwpm_available - Print a message if the port mapper isn't available
> + */
> +void print_iwpm_available(int iwpm_pid)
> +{
> +	static int one_time;
> +
> +	if (iwpm_pid < 0 && !one_time) {
> +		pr_info("iWarp Port Mapper (pid = %d) is not available.\n", nes_iwpm_pid);
> +		one_time++;
> +	}
> +	if (iwpm_pid > 0)
> +		one_time = 0;
> +}
> +
> +/*
> + * nes_register_iwpm_pid - Send a netlink query for the iwarp port mapper pid
> + *				to the userspace
> + * nlmsg attributes:
> + *	[IWPM_NLA_REG_PID_SEQ]
> + *	[IWPM_NLA_REG_IF_NAME]
> + *	[IWPM_NLA_REG_IBDEV_NAME]
> + *	[IWPM_NLA_REG_ULIB_NAME]
> + */
> +int nes_register_iwpm_pid(char *netdev_name, char *dev_name, int async,
> +				void (*req_timer_func)(unsigned long))
> +{
> +	struct sk_buff *skb = NULL;
> +	struct nes_nlmsg_request *nlmsg_request = NULL;
> +	struct nlmsghdr *nlh;
> +	struct nlmsghdr **nlh_next = &nlh;
> +	u32 msg_seq;
> +	const char *err_str = "";
> +	int ret = -ENOMEM;
> +
> +	skb = nes_create_nlmsg(RDMA_NL_IWPM_REG_PID, nlh_next);
> +	if (!skb) {
> +		err_str = "Unable to create a nlmsg";
> +		goto pid_query_error;
> +	}
> +	nlmsg_request = nes_get_nlmsg_request();
> +	if (!nlmsg_request) {
> +		err_str = "Unable to allocate netlink request";
> +		goto pid_query_error;
> +	}
> +	msg_seq = atomic_read(&echo_nlmsg_seq);
> +
> +	/* fill in the pid request message */
> +	nlh->nlmsg_seq = nlmsg_request->nlmsg_seq;
> +	err_str = "Unable to put attribute of the nlmsg";
> +	ret = ibnl_put_attr(skb, nlh, sizeof(u32), &msg_seq, IWPM_NLA_REG_PID_SEQ);
> +	if (ret)
> +		goto pid_query_error;
> +	ret = ibnl_put_attr(skb, nlh, IWPM_IFNAME_SIZE,
> +				netdev_name, IWPM_NLA_REG_IF_NAME);
> +	if (ret)
> +		goto pid_query_error;
> +	ret = ibnl_put_attr(skb, nlh, IWPM_DEVNAME_SIZE,
> +				dev_name, IWPM_NLA_REG_IBDEV_NAME);
> +	if (ret)
> +		goto pid_query_error;
> +	ret = ibnl_put_attr(skb, nlh, IWPM_ULIBNAME_SIZE,
> +				(char *)iwpm_ulib_name, IWPM_NLA_REG_ULIB_NAME);
> +	if (ret)
> +		goto pid_query_error;
> +
> +	nes_debug(NES_DBG_NLMSG, "Multicasting a nlmsg (ibdev = %s ifname = %s iwpm = %s msglen = %d)\n",
> +			dev_name, netdev_name, iwpm_ulib_name, nlh->nlmsg_len);
> +
> +	ret = ibnl_multicast(skb, nlh, RDMA_NL_GROUP_IWPM, GFP_KERNEL);
> +	if (ret) {
> +		/* skb is already freed in the netlink send-op handling */
> +		nes_debug(NES_DBG_NLMSG, "Unable to send a nlmsg\n");
> +		goto pid_query_error_exit;
> +	}
> +	nlmsg_request->async = async;
> +	if (async)
> +		nes_start_nlmsg_req_timer(nlmsg_request, req_timer_func, NES_IWPM_NL_TIMEOUT);
> +	else
> +		ret = wait_complete_nlmsg_req(nlmsg_request, NES_IWPM_PID_UNAVAILABLE);
> +	return ret;
> +pid_query_error:
> +	pr_info("%s: %s\n", __func__, err_str);
> +	if (skb)
> +		dev_kfree_skb(skb);
> +pid_query_error_exit:
> +	if (nlmsg_request)
> +		free_nlmsg_request(nlmsg_request);
> +	return ret;
> +}
> +
> +/*
> + * nes_add_mapping - Send a netlink add mapping message
> + *
> + * Send a message to the userspace port mapper to get the
> + * mapping info for a listener local ip/tcp address
> + *
> + * nlmsg attributes:
> + *	[IWPM_NLA_MANAGE_MAPPING_SEQ]
> + *	[IWPM_NLA_MANAGE_ADDR]
> + */
> +int nes_add_mapping(struct nes_cm_info *cm_info)
> +{
> +	struct sk_buff *skb = NULL;
> +	struct nes_nlmsg_request *nlmsg_request = NULL;
> +	struct nlmsghdr *nlh;
> +	struct nlmsghdr **nlh_next = &nlh;
> +	u32 msg_seq;
> +	struct sockaddr_in local_sockaddr;
> +	__be32 local_addr = cm_info->loc_addr;
> +	const char *err_str = "";
> +	int ret = -ENOMEM;
> +
> +	skb = nes_create_nlmsg(RDMA_NL_IWPM_ADD_MAPPING, nlh_next);
> +	if (!skb) {
> +		err_str = "Unable to create a nlmsg";
> +		goto add_mapping_error;
> +	}
> +	nlmsg_request = nes_get_nlmsg_request();
> +	if (!nlmsg_request) {
> +		err_str = "Unable to allocate netlink request";
> +		goto add_mapping_error;
> +	}
> +	local_sockaddr.sin_family = AF_INET;
> +	memcpy(&local_sockaddr.sin_addr.s_addr, &local_addr, sizeof(__be32));
> +	local_sockaddr.sin_port = cm_info->loc_port;
> +	msg_seq = atomic_read(&echo_nlmsg_seq);
> +
> +	/* fill in the add mapping message */
> +	nlh->nlmsg_seq = nlmsg_request->nlmsg_seq;
> +	err_str = "Unable to put attribute of the nlmsg";
> +	ret = ibnl_put_attr(skb, nlh, sizeof(u32), &msg_seq,
> +				IWPM_NLA_MANAGE_MAPPING_SEQ);
> +	if (ret)
> +		goto add_mapping_error;
> +	ret = ibnl_put_attr(skb, nlh, sizeof(struct sockaddr_storage),
> +				&local_sockaddr, IWPM_NLA_MANAGE_ADDR);
> +	if (ret)
> +		goto add_mapping_error;
> +
> +	nlmsg_request->request_buffer = cm_info;
> +	nes_debug(NES_DBG_NLMSG, "Send a nlmsg (local addr %pI4 [0x%04X])\n",
> +		&local_sockaddr.sin_addr.s_addr, local_sockaddr.sin_port);
> +
> +	ret = ibnl_unicast(skb, nlh, nes_iwpm_pid);
> +	if (ret) {
> +		nes_iwpm_pid = NES_IWPM_PID_UNDEFINED;
> +		/* skb is already freed in the netlink send-op handling */
> +		nes_debug(NES_DBG_NLMSG, "Unable to send a nlmsg\n");
> +		goto add_mapping_error_exit;
> +	}
> +	ret = wait_complete_nlmsg_req(nlmsg_request, NES_IWPM_PID_UNDEFINED);
> +	return ret;
> +add_mapping_error:
> +	pr_info("%s: %s\n", __func__, err_str);
> +	if (skb)
> +		dev_kfree_skb(skb);
> +add_mapping_error_exit:
> +	if (nlmsg_request)
> +		free_nlmsg_request(nlmsg_request);
> +	return ret;
> +}
> +
> +/*
> + * nes_add_and_query_mapping - Send a netlink query mapping message
> + *
> + * Send both a netlink add mapping message to get
> + * the connecting side local ip/tcp address mapping info and
> + * a query for the accepting side mapped (remote)
> + * ip/tcp address to the userspace port mapper
> +
> + * nlmsg attributes:
> + *	[IWPM_NLA_QUERY_MAPPING_SEQ]
> + *	[IWPM_NLA_QUERY_LOCAL_ADDR]
> + *	[IWPM_NLA_QUERY_REMOTE_ADDR]
> + */
> +int nes_add_and_query_mapping(struct nes_cm_info *cm_info)
> +{
> +	struct sk_buff *skb = NULL;
> +	struct nes_nlmsg_request *nlmsg_request = NULL;
> +	struct nlmsghdr *nlh;
> +	struct nlmsghdr **nlh_next = &nlh;
> +	u32 msg_seq;
> +	struct sockaddr_in local_sockaddr;
> +	struct sockaddr_in remote_sockaddr;
> +	__be32 local_addr = htonl(cm_info->loc_addr);
> +	__be32 remote_addr = htonl(cm_info->rem_addr);
> +	const char *err_str = "";
> +	int ret = -ENOMEM;
> +
> +	skb = nes_create_nlmsg(RDMA_NL_IWPM_QUERY_MAPPING, nlh_next);
> +	if (!skb) {
> +		err_str = "Unable to create a nlmsg";
> +		goto query_mapping_error;
> +	}
> +	nlmsg_request = nes_get_nlmsg_request();
> +	if (!nlmsg_request) {
> +		err_str = "Unable to allocate netlink request";
> +		goto query_mapping_error;
> +	}
> +	msg_seq = atomic_read(&echo_nlmsg_seq);
> +	local_sockaddr.sin_family = AF_INET;
> +	memcpy(&local_sockaddr.sin_addr.s_addr, &local_addr, sizeof(__be32));
> +	local_sockaddr.sin_port = htons(cm_info->loc_port);
> +
> +	remote_sockaddr.sin_family = AF_INET;
> +	memcpy(&remote_sockaddr.sin_addr.s_addr, &remote_addr, sizeof(__be32));
> +	remote_sockaddr.sin_port = htons(cm_info->rem_port);
> +
> +	/* fill in the query message */
> +	nlh->nlmsg_seq = nlmsg_request->nlmsg_seq;
> +	err_str = "Unable to put attribute of the nlmsg";
> +	ret = ibnl_put_attr(skb, nlh, sizeof(u32), &msg_seq,
> +				IWPM_NLA_QUERY_MAPPING_SEQ);
> +	if (ret)
> +		goto query_mapping_error;
> +	ret = ibnl_put_attr(skb, nlh, sizeof(struct sockaddr_storage),
> +				&local_sockaddr, IWPM_NLA_QUERY_LOCAL_ADDR);
> +	if (ret)
> +		goto query_mapping_error;
> +	ret = ibnl_put_attr(skb, nlh, sizeof(struct sockaddr_storage),
> +				&remote_sockaddr, IWPM_NLA_QUERY_REMOTE_ADDR);
> +	if (ret)
> +		goto query_mapping_error;
> +
> +	nlmsg_request->request_buffer = cm_info;
> +	nes_debug(NES_DBG_NLMSG, "Send a nlmsg (laddr %pI4 [0x%04X], raddr %pI4 [0x%04X])\n",
> +		&local_sockaddr.sin_addr.s_addr, local_sockaddr.sin_port,
> +		&remote_sockaddr.sin_addr.s_addr, remote_sockaddr.sin_port);
> +
> +	ret = ibnl_unicast(skb, nlh, nes_iwpm_pid);
> +	if (ret) {
> +		nes_iwpm_pid = NES_IWPM_PID_UNDEFINED;
> +		/* skb is already freed in the netlink send-op handling */
> +		nes_debug(NES_DBG_NLMSG, "Unable to send a nlmsg\n");
> +		goto query_mapping_error_exit;
> +	}
> +	ret = wait_complete_nlmsg_req(nlmsg_request, NES_IWPM_PID_UNDEFINED);
> +	return ret;
> +query_mapping_error:
> +	pr_info("%s: %s\n", __func__, err_str);
> +	if (skb)
> +		dev_kfree_skb(skb);
> +query_mapping_error_exit:
> +	if (nlmsg_request)
> +		free_nlmsg_request(nlmsg_request);
> +	return ret;
> +}
> +
> +/*
> + * nes_remove_mapping - Send a netlink remove mapping message
> + *
> + * nlmsg attributes:
> + *	[IWPM_NLA_MANAGE_MAPPING_SEQ]
> + *	[IWPM_NLA_MANAGE_ADDR]
> + */
> +int nes_remove_mapping(nes_addr_t mapped_local_addr, u16 mapped_local_port)
> +{
> +	struct sk_buff *skb;
> +	struct nlmsghdr *nlh;
> +	struct nlmsghdr **nlh_next = &nlh;
> +	u32 msg_seq;
> +	struct sockaddr_in mapped_sockaddr;
> +	__be32 mapped_addr = htonl(mapped_local_addr);
> +	const char *err_str = "";
> +	int ret;
> +
> +	mapped_sockaddr.sin_family = AF_INET;
> +	memcpy(&mapped_sockaddr.sin_addr.s_addr, &mapped_addr, sizeof(__be32));
> +	mapped_sockaddr.sin_port = htons(mapped_local_port);
> +
> +	if (nes_remove_mapinfo(&mapped_sockaddr)) {
> +		pr_info("%s: Fail to remove mapinfo (port = 0x%04X)\n",
> +				__func__, mapped_local_port);
> +		return -EINVAL;
> +	}
> +	/* the routine is always called when terminating a connection,
> +	* if the userspace port mapper isn't available, can't send a msg */
> +	if (nes_iwpm_pid < 0)
> +		return 0;
> +
> +	skb = nes_create_nlmsg(RDMA_NL_IWPM_REMOVE_MAPPING, nlh_next);
> +	if (!skb) {
> +		ret = -ENOMEM;
> +		err_str = "Unable to create a nlmsg";
> +		goto remove_mapping_error;
> +	}
> +	msg_seq = atomic_read(&echo_nlmsg_seq);
> +
> +	nlh->nlmsg_seq = atomic_inc_return(&nes_nlmsg_seq);
> +	err_str = "Unable to put attribute of the nlmsg";
> +	ret = ibnl_put_attr(skb, nlh, sizeof(u32), &msg_seq,
> +				IWPM_NLA_MANAGE_MAPPING_SEQ);
> +	if (ret)
> +		goto remove_mapping_error;
> +	ret = ibnl_put_attr(skb, nlh, sizeof(struct sockaddr_storage),
> +				&mapped_sockaddr, IWPM_NLA_MANAGE_ADDR);
> +	if (ret)
> +		goto remove_mapping_error;
> +
> +	nes_debug(NES_DBG_NLMSG, "Send a nlmsg (mapped laddr %pI4 [0x%04X])\n",
> +		&mapped_sockaddr.sin_addr.s_addr, mapped_sockaddr.sin_port);
> +
> +	ret = ibnl_unicast(skb, nlh, nes_iwpm_pid);
> +	if (ret) {
> +		nes_iwpm_pid = NES_IWPM_PID_UNDEFINED;
> +		/* skb is already freed in the netlink send-op handling */
> +		nes_debug(NES_DBG_NLMSG, "Unable to send a nlmsg\n");
> +	}
> +	return ret;
> +remove_mapping_error:
> +	pr_info("%s: %s\n", __func__, err_str);
> +	if (skb)
> +		dev_kfree_skb(skb);
> +	return ret;
> +}
> +
> +/* registered nes netlink callbacks */
> +struct ibnl_client_cbs nes_nl_cb_table[] = {
> +	[RDMA_NL_IWPM_REG_PID] = {.dump = nes_register_iwpm_pid_cb},
> +	[RDMA_NL_IWPM_ADD_MAPPING] = {.dump = nes_add_mapping_cb},
> +	[RDMA_NL_IWPM_QUERY_MAPPING] = {.dump = nes_add_and_query_mapping_cb},
> +	[RDMA_NL_IWPM_HANDLE_ERR] = {.dump = nes_mapping_error_cb},
> +	[RDMA_NL_IWPM_MAP_INFO] = {.dump = nes_mapping_info_cb},
> +	[RDMA_NL_IWPM_MAP_INFO_NUM] = {.dump = nes_ack_mapping_info_cb}
> +};
> +
> +/* netlink attribute policy for the received response to nes register */
> +static const struct nla_policy resp_reg_policy[IWPM_NLA_RREG_PID_MAX] = {
> +	[IWPM_NLA_RREG_PID_SEQ]     = { .type = NLA_U32 },
> +	[IWPM_NLA_RREG_IBDEV_NAME]  = { .type = NLA_STRING,
> +					.len = IWPM_DEVNAME_SIZE - 1 },
> +	[IWPM_NLA_RREG_ULIB_NAME]   = { .type = NLA_STRING,
> +					.len = IWPM_ULIBNAME_SIZE - 1 },
> +	[IWPM_NLA_RREG_ULIB_VER]    = { .type = NLA_U16 },
> +	[IWPM_NLA_RREG_PID_ERR]     = { .type = NLA_U16 }
> +};
> +
> +/*
> + * nes_register_iwpm_pid_cb - Process response to register_iwpm_pid
> + *
> + * The port mapper pid (part of the response message) is used
> + * in the future communication with the port mapper
> + */
> +static int nes_register_iwpm_pid_cb(struct sk_buff *skb, struct netlink_callback *cb)
> +{
> +	struct nes_nlmsg_request *nlmsg_request = NULL;
> +	struct nlattr *nltb[IWPM_NLA_RREG_PID_MAX];
> +	char *dev_name, *iwpm_name;
> +	u32 msg_seq;
> +	u16 iwpm_version;
> +	const char *msg_type = "Register Pid response";
> +
> +	nes_iwpm_pid = NES_IWPM_PID_ERROR;
> +
> +	if (nes_parse_nlmsg(cb, IWPM_NLA_RREG_PID_MAX,
> +				resp_reg_policy, nltb, msg_type))
> +		return -EINVAL;
> +
> +	msg_seq = nla_get_u32(nltb[IWPM_NLA_RREG_PID_SEQ]);
> +	nlmsg_request = nes_find_nlmsg_request(msg_seq);
> +	if (!nlmsg_request) {
> +		pr_info("%s: Could not find a matching request (seq = %u)\n",
> +				 __func__, msg_seq);
> +		return -EINVAL;
> +	}
> +	dev_name = (char *)nla_data(nltb[IWPM_NLA_RREG_IBDEV_NAME]);
> +	iwpm_name = (char *)nla_data(nltb[IWPM_NLA_RREG_ULIB_NAME]);
> +	iwpm_version = nla_get_u16(nltb[IWPM_NLA_RREG_ULIB_VER]);
> +
> +	/* check device name, ulib name and version */
> +	if (strcmp(nes_ibdev, dev_name) || strcmp(iwpm_ulib_name, iwpm_name) ||
> +			iwpm_version != iwpm_ulib_version) {
> +
> +		pr_info("%s: Incorrect info (dev = %s name = %s version = %d)\n",
> +				__func__, dev_name, iwpm_name, iwpm_version);
> +		nlmsg_request->err_code = IWPM_USER_LIB_INFO_ERR;
> +		goto register_pid_response_exit;
> +	}
> +	nes_debug(NES_DBG_NLMSG, "Received info (dev = %s iwpm = %s version = %d)\n",
> +				dev_name, iwpm_name, iwpm_version);
> +
> +	nes_iwpm_pid = cb->nlh->nlmsg_pid;
> +	atomic_set(&echo_nlmsg_seq, cb->nlh->nlmsg_seq);
> +	pr_info("%s: iWarp Port Mapper (pid = %d) is successfully registered.\n",
> +			__func__, nes_iwpm_pid);
> +register_pid_response_exit:
> +	nlmsg_request->request_done = 1;
> +	rem_ref_nlmsg_request(nlmsg_request); /* always for found nlmsg_request */
> +	barrier();
> +	if (!nlmsg_request->async)
> +		wake_up(&nlmsg_request->waitq);
> +	return 0;
> +}
> +
> +/* netlink attribute policy for the received response to nes add mapping */
> +static const struct nla_policy resp_add_policy[IWPM_NLA_RMANAGE_MAPPING_MAX] = {
> +	[IWPM_NLA_MANAGE_MAPPING_SEQ]     = { .type = NLA_U32 },
> +	[IWPM_NLA_MANAGE_ADDR]            = { .len = sizeof(struct sockaddr_storage) },
> +	[IWPM_NLA_MANAGE_MAPPED_LOC_ADDR] = { .len = sizeof(struct sockaddr_storage) },
> +	[IWPM_NLA_RMANAGE_MAPPING_ERR]	  = { .type = NLA_U16 }
> +};
> +
> +/*
> + * nes_add_mapping_cb - Callback routine when response to add_mapping
> + *			is received from the userspace port mapper
> + *
> + * The response message contains the mapping info for the requested
> + * listener local ip/tcp address
> + */
> +static int nes_add_mapping_cb(struct sk_buff *skb, struct netlink_callback *cb)
> +{
> +	struct nes_cm_info *cm_info;
> +	struct nes_nlmsg_request *nlmsg_request = NULL;
> +	struct nlattr *nltb[IWPM_NLA_RMANAGE_MAPPING_MAX];
> +	u32 msg_seq;
> +	struct sockaddr_in *local_sockaddr, *mapped_sockaddr;
> +	__be32 loc_addr, mapped_addr;
> +	const char *msg_type;
> +
> +	msg_type = "Add Mapping response";
> +	if (nes_parse_nlmsg(cb, IWPM_NLA_RMANAGE_MAPPING_MAX,
> +				resp_add_policy, nltb, msg_type))
> +		return -EINVAL;
> +
> +	msg_seq = nla_get_u32(nltb[IWPM_NLA_MANAGE_MAPPING_SEQ]);
> +	nlmsg_request = nes_find_nlmsg_request(msg_seq);
> +	if (!nlmsg_request) {
> +		pr_info("%s: Could not find a matching request (seq = %u)\n",
> +				 __func__, msg_seq);
> +		return -EINVAL;
> +	}
> +	cm_info = nlmsg_request->request_buffer;
> +	local_sockaddr = (struct sockaddr_in *)nla_data(nltb[IWPM_NLA_MANAGE_ADDR]);
> +	mapped_sockaddr = (struct sockaddr_in *)nla_data(nltb[IWPM_NLA_MANAGE_MAPPED_LOC_ADDR]);
> +
> +	loc_addr = *(__be32 *)&local_sockaddr->sin_addr.s_addr;
> +	if (cm_info->loc_addr != loc_addr ||
> +		cm_info->loc_port != local_sockaddr->sin_port) {
> +
> +		pr_info("%s: Invalid ip/tcp address (Expected %pI4(%04X) Received: %pI4(%04X)\n",
> +			__func__, (char *)&cm_info->loc_addr, cm_info->loc_port,
> +			(char *)&loc_addr, local_sockaddr->sin_port);
> +		nlmsg_request->err_code = IWPM_USER_LIB_INFO_ERR;
> +		goto add_mapping_response_exit;
> +	}
> +	if (mapped_sockaddr->sin_family != AF_INET) {
> +		pr_info("%s: Invalid sockaddr family = %04X\n",
> +				__func__, mapped_sockaddr->sin_family);
> +		nlmsg_request->err_code = IWPM_USER_LIB_INFO_ERR;
> +		goto add_mapping_response_exit;
> +	}
> +
> +	atomic_set(&echo_nlmsg_seq, cb->nlh->nlmsg_seq);
> +	mapped_addr = *(__be32 *)&mapped_sockaddr->sin_addr.s_addr;
> +	cm_info->mapped_loc_addr = mapped_addr;
> +	cm_info->mapped_loc_port = mapped_sockaddr->sin_port;
> +add_mapping_response_exit:
> +	nes_debug(NES_DBG_NLMSG, "Received new mapped laddr %pI4 [0x%04X]\n",
> +		&mapped_sockaddr->sin_addr.s_addr, mapped_sockaddr->sin_port);
> +	nlmsg_request->request_done = 1;
> +	rem_ref_nlmsg_request(nlmsg_request); /* always for found request */
> +	barrier();
> +	wake_up(&nlmsg_request->waitq);
> +	return 0;
> +}
> +
> +/* netlink attribute policy for the add_and_query_mapping response */
> +static const struct nla_policy resp_query_policy[IWPM_NLA_RQUERY_MAPPING_MAX] = {
> +	[IWPM_NLA_QUERY_MAPPING_SEQ]      = { .type = NLA_U32 },
> +	[IWPM_NLA_QUERY_LOCAL_ADDR]       = { .len = sizeof(struct sockaddr_storage) },
> +	[IWPM_NLA_QUERY_REMOTE_ADDR]      = { .len = sizeof(struct sockaddr_storage) },
> +	[IWPM_NLA_RQUERY_MAPPED_LOC_ADDR] = { .len = sizeof(struct sockaddr_storage) },
> +	[IWPM_NLA_RQUERY_MAPPED_REM_ADDR] = { .len = sizeof(struct sockaddr_storage) },
> +	[IWPM_NLA_RQUERY_MAPPING_ERR]	  = { .type = NLA_U16 }
> +};
> +
> +/*
> + * nes_add_and_query_mapping_cb - Process response to add_and_query_mapping
> + *
> + * The response message contains mapping info for the requested
> + * connecting side local ip/tcp address and accepting side (remote) ip/tcp address
> + */
> +static int nes_add_and_query_mapping_cb(struct sk_buff *skb, struct netlink_callback *cb)
> +{
> +	struct nes_cm_info *cm_info;
> +	struct nes_nlmsg_request *nlmsg_request = NULL;
> +	struct nlattr *nltb[IWPM_NLA_RQUERY_MAPPING_MAX];
> +	u32 msg_seq;
> +	struct sockaddr_in *local_sockaddr, *remote_sockaddr;
> +	struct sockaddr_in *mapped_loc_sockaddr, *mapped_rem_sockaddr;
> +	__be32 loc_addr, mapped_loc_addr, rem_addr, mapped_rem_addr;
> +	const char *msg_type;
> +	u16 err_code;
> +
> +	msg_type = "Query Mapping response";
> +	if (nes_parse_nlmsg(cb, IWPM_NLA_RQUERY_MAPPING_MAX,
> +				resp_query_policy, nltb, msg_type))
> +		return -EINVAL;
> +	msg_seq = nla_get_u32(nltb[IWPM_NLA_QUERY_MAPPING_SEQ]);
> +	nlmsg_request = nes_find_nlmsg_request(msg_seq);
> +	if (!nlmsg_request) {
> +		pr_info("%s: Could not find a matching request (seq = %u)\n",
> +				 __func__, msg_seq);
> +			return -EINVAL;
> +	}
> +	cm_info = nlmsg_request->request_buffer;
> +	local_sockaddr =
> +		(struct sockaddr_in *)nla_data(nltb[IWPM_NLA_QUERY_LOCAL_ADDR]);
> +	remote_sockaddr =
> +		(struct sockaddr_in *)nla_data(nltb[IWPM_NLA_QUERY_REMOTE_ADDR]);
> +	mapped_loc_sockaddr =
> +		(struct sockaddr_in *)nla_data(nltb[IWPM_NLA_RQUERY_MAPPED_LOC_ADDR]);
> +	mapped_rem_sockaddr =
> +		(struct sockaddr_in *)nla_data(nltb[IWPM_NLA_RQUERY_MAPPED_REM_ADDR]);
> +
> +	err_code = nla_get_u16(nltb[IWPM_NLA_RQUERY_MAPPING_ERR]);
> +	if (err_code == IWPM_REMOTE_QUERY_REJECT) {
> +		pr_info("%s: Received a Reject nlmsg (pid = %u, echo seq = %u)\n",
> +			__func__, cb->nlh->nlmsg_pid, msg_seq);
> +		nlmsg_request->err_code = IWPM_REMOTE_QUERY_REJECT;
> +	}
> +	loc_addr = *(__be32 *)&local_sockaddr->sin_addr.s_addr;
> +	rem_addr = *(__be32 *)&remote_sockaddr->sin_addr.s_addr;
> +	if (cm_info->loc_addr != ntohl(loc_addr) ||
> +			cm_info->loc_port != ntohs(local_sockaddr->sin_port) ||
> +			cm_info->rem_addr != ntohl(rem_addr) ||
> +			cm_info->rem_port != ntohs(remote_sockaddr->sin_port)) {
> +
> +		pr_info("%s: Expected laddr %pI4 [%04X] Received laddr %pI4 [%04X] "
> +			"Expected raddr %pI4 [%04X] Received raddr %pI4 [%04X]\n", __func__,
> +			(char *)&cm_info->loc_addr, cm_info->loc_port,
> +			(char *)&loc_addr, ntohs(local_sockaddr->sin_port),
> +			(char *)&cm_info->rem_addr, cm_info->rem_port,
> +			(char *)&rem_addr, ntohs(remote_sockaddr->sin_port));
> +		nlmsg_request->err_code = IWPM_USER_LIB_INFO_ERR;
> +		goto query_mapping_response_exit;
> +	}
> +	if (mapped_loc_sockaddr->sin_family != AF_INET ||
> +			mapped_rem_sockaddr->sin_family != AF_INET) {
> +		pr_info("%s: Invalid sockaddr family\n", __func__);
> +		nlmsg_request->err_code = IWPM_USER_LIB_INFO_ERR;
> +		goto query_mapping_response_exit;
> +	}
> +
> +	mapped_loc_addr = *(__be32 *)&mapped_loc_sockaddr->sin_addr.s_addr;
> +	mapped_rem_addr = *(__be32 *)&mapped_rem_sockaddr->sin_addr.s_addr;
> +
> +	atomic_set(&echo_nlmsg_seq, cb->nlh->nlmsg_seq);
> +	cm_info->mapped_loc_addr = ntohl(mapped_loc_addr);
> +	cm_info->mapped_loc_port = ntohs(mapped_loc_sockaddr->sin_port);
> +	cm_info->mapped_rem_addr = ntohl(mapped_rem_addr);
> +	cm_info->mapped_rem_port = ntohs(mapped_rem_sockaddr->sin_port);
> +
> +query_mapping_response_exit:
> +	nes_debug(NES_DBG_NLMSG, "Received mapped laddr %pI4 [0x%04X] raddr %pI4 [0x%04X]\n",
> +		&mapped_loc_sockaddr->sin_addr.s_addr, mapped_loc_sockaddr->sin_port,
> +		&mapped_rem_sockaddr->sin_addr.s_addr, mapped_rem_sockaddr->sin_port);
> +	nlmsg_request->request_done = 1;
> +	rem_ref_nlmsg_request(nlmsg_request); /* always for found request */
> +	barrier();
> +	wake_up(&nlmsg_request->waitq);
> +	return 0;
> +}
> +
> +/* netlink attribute policy for the received request for mapping info */
> +static const struct nla_policy resp_mapinfo_policy[IWPM_NLA_MAPINFO_REQ_MAX] = {
> +	[IWPM_NLA_MAPINFO_ULIB_NAME] = { .type = NLA_STRING,
> +					.len = IWPM_ULIBNAME_SIZE - 1 },
> +	[IWPM_NLA_MAPINFO_ULIB_VER]  = { .type = NLA_U16 }
> +};
> +
> +/*
> + * nes_mapping_info_cb - Callback routine when message from the port mapper
> + *				is received, to notify that the port mapper is available
> + *				and request the nes records of mapping info
> + */
> +static int nes_mapping_info_cb(struct sk_buff *skb, struct netlink_callback *cb)
> +{
> +	struct nlattr *nltb[IWPM_NLA_MAPINFO_REQ_MAX];
> +	char *iwpm_name;
> +	u16 iwpm_version;
> +	const char *msg_type = "Mapping Info response";
> +	void (*req_timer_func)(unsigned long) = NULL;
> +	int async = 1;
> +
> +	if (nes_parse_nlmsg(cb, IWPM_NLA_MAPINFO_REQ_MAX,
> +				resp_mapinfo_policy, nltb, msg_type))
> +		return -EINVAL;
> +
> +	iwpm_name = (char *)nla_data(nltb[IWPM_NLA_MAPINFO_ULIB_NAME]);
> +	iwpm_version = nla_get_u16(nltb[IWPM_NLA_MAPINFO_ULIB_VER]);
> +	if (strcmp(iwpm_ulib_name, iwpm_name) || iwpm_version != iwpm_ulib_version) {
> +		pr_info("%s: Invalid iWarpPortMapper info (name = %s version = %d)\n",
> +				__func__, iwpm_name, iwpm_version);
> +		return -EINVAL;
> +	}
> +	if (list_empty(&nes_mapping_info_list))
> +		req_timer_func = &nes_nlmsg_req_timer_free;
> +	else
> +		req_timer_func = &nes_mapinfo_timer_send;
> +
> +	nes_register_iwpm_pid(nes_ifname, nes_ibdev, async, req_timer_func);
> +	return 0;
> +}
> +
> +/*
> + * nes_send_mapping_count - Send a netlink message with the number of mapping
> + *				info records to the userspace port mapper
> + */
> +static int nes_send_mapping_count(u32 mapping_num)
> +{
> +	struct nes_nlmsg_request *nlmsg_request = NULL;
> +	struct sk_buff *skb = NULL;
> +	struct nlmsghdr *nlh;
> +	struct nlmsghdr **nlh_next = &nlh;
> +	u32 msg_seq;
> +	const char *err_str = "";
> +	int ret = -EINVAL;
> +
> +	skb = nes_create_nlmsg(RDMA_NL_IWPM_MAP_INFO_NUM, nlh_next);
> +	if (!skb) {
> +		err_str = "Unable to create a nlmsg";
> +		goto map_count_error;
> +	}
> +	nlmsg_request = nes_get_nlmsg_request();
> +	if (!nlmsg_request) {
> +		err_str = "Unable to allocate netlink request";
> +		goto map_count_error;
> +	}
> +
> +	/* fill in the pid request message */
> +	msg_seq = atomic_read(&echo_nlmsg_seq);
> +	nlh->nlmsg_seq = nlmsg_request->nlmsg_seq;
> +	err_str = "Unable to put attribute of map count nlmsg";
> +	ret = ibnl_put_attr(skb, nlh, sizeof(u32), &msg_seq, IWPM_NLA_MAPINFO_SEQ);
> +	if (ret)
> +		goto map_count_error;
> +	ret = ibnl_put_attr(skb, nlh, sizeof(u32),
> +				&mapping_num, IWPM_NLA_MAPINFO_NUMBER);
> +	if (ret)
> +		goto map_count_error;
> +
> +	ret = ibnl_unicast(skb, nlh, nes_iwpm_pid);
> +	if (ret) {
> +		nes_iwpm_pid = NES_IWPM_PID_UNDEFINED;
> +		nes_debug(NES_DBG_NLMSG, "Unable to send a nlmsg\n");
> +		goto map_count_error_exit;
> +	}
> +	nlmsg_request->mapcount = mapping_num;
> +	nlmsg_request->async = 1;
> +	nes_start_nlmsg_req_timer(nlmsg_request, nes_nlmsg_req_timer_free,
> +					NES_IWPM_NL_TIMEOUT);
> +	return 0;
> +map_count_error:
> +	pr_info("%s: %s\n", __func__, err_str);
> +	if (skb)
> +		dev_kfree_skb(skb);
> +map_count_error_exit:
> +	if (nlmsg_request)
> +		free_nlmsg_request(nlmsg_request);
> +	return ret;
> +}
> +
> +/*
> + * nes_send_nlmsg_done - Send a mapping info message
> + *
> + * Send to the port mapper an skb containing multi netlink messages,
> + * after appending a NLMSG_DONE message to the skb
> + */
> +static int nes_send_nlmsg_done(struct sk_buff *skb)
> +{
> +	struct nlmsghdr *nlh = NULL;
> +	int ret;
> +	if (!(ibnl_put_msg(skb, &nlh, 0, 0, RDMA_NL_NES,
> +				RDMA_NL_IWPM_MAP_INFO, NLM_F_MULTI))) {
> +		pr_info("%s: Unable to put NLMSG_DONE\n", __func__);
> +		return -ENOMEM;
> +	}
> +	nlh->nlmsg_type = NLMSG_DONE;
> +	ret = ibnl_unicast(skb, (struct nlmsghdr *)skb->data, nes_iwpm_pid);
> +	if (ret) {
> +		nes_iwpm_pid = NES_IWPM_PID_UNDEFINED;
> +		nes_debug(NES_DBG_NLMSG, "Unable to send a nlmsg\n");
> +	}
> +	return ret;
> +}
> +
> +/*
> + * nes_send_mapping_info - Send mapping info records to the iwarp port mapper
> + *
> + * Mapping info message is used for synchronization,
> + * after the port mapper is restarted and doesn't have any mapping info records
> + */
> +static int nes_send_mapping_info(void)
> +{
> +	struct sk_buff *skb = NULL;
> +	struct nes_mapping_info *map_info;
> +	struct nlmsghdr *nlh;
> +	unsigned long flags;
> +	int mapping_num = 0;
> +	int nlmsg_bytes = 0;
> +	int skb_num = 0;
> +	const char *err_str = "";
> +	int ret;
> +
> +	skb = dev_alloc_skb(NLMSG_GOODSIZE);
> +	if (!skb) {
> +		ret = -ENOMEM;
> +		err_str = "Unable to allocate skb";
> +		goto send_mapping_info_exit;
> +	}
> +	skb_num++;
> +	spin_lock_irqsave(&nes_mapping_lock, flags);
> +	list_for_each_entry(map_info, &nes_mapping_info_list, mapping_list) {
> +		nlh = NULL;
> +		if (!(ibnl_put_msg(skb, &nlh, 0, 0, RDMA_NL_NES,
> +				RDMA_NL_IWPM_MAP_INFO, NLM_F_MULTI))) {
> +			ret = -ENOMEM;
> +			err_str = "Unable to put the nlmsg header";
> +			spin_unlock_irqrestore(&nes_mapping_lock, flags);
> +			goto send_mapping_info_exit;
> +		}
> +		err_str = "Unable to put attribute of the nlmsg";
> +		ret = ibnl_put_attr(skb, nlh, sizeof(struct sockaddr_storage),
> +				&map_info->local_sockaddr, IWPM_NLA_MAPINFO_LOCAL_ADDR);
> +		if (ret) {
> +			spin_unlock_irqrestore(&nes_mapping_lock, flags);
> +			goto send_mapping_info_exit;
> +		}
> +		ret = ibnl_put_attr(skb, nlh, sizeof(struct sockaddr_storage),
> +				&map_info->mapped_sockaddr, IWPM_NLA_MAPINFO_MAPPED_ADDR);
> +		if (ret) {
> +			spin_unlock_irqrestore(&nes_mapping_lock, flags);
> +			goto send_mapping_info_exit;
> +		}
> +		mapping_num++;
> +		nlmsg_bytes += nlh->nlmsg_len;
> +
> +		/* check if all mappings can fit in one skb */
> +		/* and leave room for NLMSG_DONE */
> +		if (NLMSG_GOODSIZE - nlmsg_bytes < nlh->nlmsg_len*2) {
> +			nlmsg_bytes = 0;
> +			skb_num++;
> +			nes_debug(NES_DBG_NLMSG, "Allocating skb #%d (mappings = %d nlmsg len = %d)\n",
> +					skb_num, mapping_num, nlh->nlmsg_len);
> +			spin_unlock_irqrestore(&nes_mapping_lock, flags);
> +			/* send the skb */
> +			ret = nes_send_nlmsg_done(skb);
> +			skb = NULL;
> +			if (ret) {
> +				err_str = "Unable to send map info";
> +				goto send_mapping_info_exit;
> +			}
> +			if (skb_num == NES_MAP_INFO_SKB_COUNT) {
> +				ret = -ENOMEM;
> +				err_str = "Insufficient skbs for map info";
> +				goto send_mapping_info_exit;
> +			}
> +			skb = dev_alloc_skb(NLMSG_GOODSIZE);
> +			if (!skb) {
> +				ret = -ENOMEM;
> +				err_str = "Unable to allocate skb";
> +				goto send_mapping_info_exit;
> +			}
> +			spin_lock_irqsave(&nes_mapping_lock, flags);
> +		}
> +	}
> +	spin_unlock_irqrestore(&nes_mapping_lock, flags);
> +	if (skb)
> +		nes_send_nlmsg_done(skb);
> +	return mapping_num;
> +send_mapping_info_exit:
> +	if (skb)
> +		dev_kfree_skb(skb);
> +	if (ret > 0)
> +		ret = -ret;
> +	pr_info("%s: %s (ret = %d)\n", __func__, err_str, ret);
> +	return ret;
> +}
> +
> +/* netlink attribute policy for the received ack of mapping info */
> +static const struct nla_policy ack_mapinfo_policy[IWPM_NLA_MAPINFO_COUNT_MAX] = {
> +	[IWPM_NLA_MAPINFO_SEQ]    = { .type = NLA_U32 },
> +	[IWPM_NLA_MAPINFO_NUMBER] = { .type = NLA_U32 }
> +};
> +
> +/*
> + * nes_ack_mapping_info_cb - Callback routine when acknowledgement is received
> + *			     from the userspace port mapper
> + *
> + * The received netlink message contains the number of mappings the port mapper
> + * has processed
> + */
> +static int nes_ack_mapping_info_cb(struct sk_buff *skb, struct netlink_callback *cb)
> +{
> +	struct nes_nlmsg_request *nlmsg_request = NULL;
> +	struct nlattr *nltb[IWPM_NLA_MAPINFO_COUNT_MAX];
> +	u32 msg_seq, mapping_num;
> +	const char *msg_type = "Mapping Info Ack";
> +
> +	if (nes_parse_nlmsg(cb, IWPM_NLA_MAPINFO_COUNT_MAX,
> +				ack_mapinfo_policy, nltb, msg_type))
> +		return -EINVAL;
> +	msg_seq = nla_get_u32(nltb[IWPM_NLA_MAPINFO_SEQ]);
> +	nlmsg_request = nes_find_nlmsg_request(msg_seq);
> +	if (!nlmsg_request) {
> +		pr_info("%s: Could not find matching request (seq = %u)\n",
> +				 __func__, msg_seq);
> +		return -EINVAL;
> +	}
> +	mapping_num = nla_get_u32(nltb[IWPM_NLA_MAPINFO_NUMBER]);
> +	if (nlmsg_request->mapcount != mapping_num)
> +		pr_info("%s: Invalid mapinfo count (sent = %u ack-ed = %u)\n",
> +				__func__, nlmsg_request->mapcount, mapping_num);
> +
> +	nes_debug(NES_DBG_NLMSG, "Received ack for mapping count = %u\n", mapping_num);
> +	atomic_set(&echo_nlmsg_seq, cb->nlh->nlmsg_seq);
> +	nlmsg_request->request_done = 1;
> +	rem_ref_nlmsg_request(nlmsg_request); /* always for found request */
> +	return 0;
> +}
> +
> +/* netlink attribute policy for the received port mapper error message */
> +static const struct nla_policy map_error_policy[IWPM_NLA_ERR_MAX] = {
> +	[IWPM_NLA_ERR_SEQ]        = { .type = NLA_U32 },
> +	[IWPM_NLA_ERR_CODE]       = { .type = NLA_U16 },
> +};
> +
> +/*
> + * nes_mapping_error_cb - Callback routine when error message is received
> + *			  from the port mapper
> + */
> +static int nes_mapping_error_cb(struct sk_buff *skb, struct netlink_callback *cb)
> +{
> +	struct nes_nlmsg_request *nlmsg_request = NULL;
> +	struct nlattr *nltb[IWPM_NLA_ERR_MAX];
> +	u32 msg_seq;
> +	u16 err_code;
> +	const char *msg_type = "Mapping Error Msg";
> +
> +	if (nes_parse_nlmsg(cb, IWPM_NLA_ERR_MAX,
> +				map_error_policy, nltb, msg_type))
> +		return -EINVAL;
> +
> +	msg_seq = nla_get_u32(nltb[IWPM_NLA_ERR_SEQ]);
> +	err_code = nla_get_u16(nltb[IWPM_NLA_ERR_CODE]);
> +	pr_info("%s: Received msg seq = %u err code = %u\n", __func__, msg_seq, err_code);
> +	/* look for nlmsg_request */
> +	nlmsg_request = nes_find_nlmsg_request(msg_seq);
> +	if (!nlmsg_request) {
> +		/* not all errors have associated requests */
> +		nes_debug(NES_DBG_NLMSG, "Could not find matching request (seq = %u)\n", msg_seq);
> +		return -EINVAL;
> +	}
> +	atomic_set(&echo_nlmsg_seq, cb->nlh->nlmsg_seq);
> +	nlmsg_request->err_code = err_code;
> +	nlmsg_request->request_done = 1;
> +	rem_ref_nlmsg_request(nlmsg_request); /* always for found request */
> +	barrier();
> +	if (!nlmsg_request->async)
> +		wake_up(&nlmsg_request->waitq);
> +	return 0;
> +}
> diff --git a/drivers/infiniband/hw/nes/nes_netlink.h b/drivers/infiniband/hw/nes/nes_netlink.h
> new file mode 100644
> index 0000000..8fde524
> --- /dev/null
> +++ b/drivers/infiniband/hw/nes/nes_netlink.h
> @@ -0,0 +1,108 @@
> +/*
> +* Copyright (c) 2013 Intel Corporation. All rights reserved.
> +*
> +* This software is available to you under a choice of one of two
> +* licenses.  You may choose to be licensed under the terms of the GNU
> +* General Public License (GPL) Version 2, available from the file
> +* COPYING in the main directory of this source tree, or the
> +* OpenIB.org BSD license below:
> +*
> +*     Redistribution and use in source and binary forms, with or
> +*     without modification, are permitted provided that the following
> +*     conditions are met:
> +*
> +*      - Redistributions of source code must retain the above
> +*        copyright notice, this list of conditions and the following
> +*        disclaimer.
> +*
> +*      - Redistributions in binary form must reproduce the above
> +*        copyright notice, this list of conditions and the following
> +*        disclaimer in the documentation and/or other materials
> +*        provided with the distribution.
> +*
> +* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> +* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> +* MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> +* NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
> +* BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
> +* ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
> +* CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> +* SOFTWARE.
> +*/
> +
> +#ifndef __NES_NETLINK_H
> +#define __NES_NETLINK_H
> +
> +#include <rdma/rdma_netlink.h>
> +#include <linux/errno.h>
> +
> +#define NES_IWPM_PID_UNDEFINED    -1
> +#define NES_IWPM_PID_UNAVAILABLE  -2
> +#define NES_IWPM_PID_ERROR        -3
> +
> +#define NES_IWPM_NL_TIMEOUT     (10*HZ)
> +#define NES_MAP_INFO_SKB_COUNT  100
> +
> +#define IWPM_ULIBNAME_SIZE 32
> +#define IWPM_DEVNAME_SIZE  32
> +#define IWPM_IFNAME_SIZE   16
> +
> +extern struct list_head nes_nlmsg_request_list;
> +extern struct list_head nes_mapping_info_list;
> +extern spinlock_t nes_nlmsg_lock;
> +extern spinlock_t nes_mapping_lock;
> +extern atomic_t nes_nlmsg_seq;
> +extern atomic_t echo_nlmsg_seq;
> +extern char nes_ifname[IWPM_IFNAME_SIZE];
> +extern char nes_ibdev[IWPM_DEVNAME_SIZE];
> +
> +extern struct ibnl_client_cbs nes_nl_cb_table[];
> +extern int nes_iwpm_pid;
> +
> +struct nes_nlmsg_request {
> +	struct list_head inprocess_list;
> +	__u32            nlmsg_seq;
> +	void             *request_buffer;
> +	u8               request_done;
> +	u8               async;
> +	union {
> +		wait_queue_head_t  waitq;
> +		struct timer_list  service_timer;
> +	};
> +
> +	atomic_t  refcount;
> +	u16       err_code;
> +	int       mapcount;
> +
> +};
> +
> +struct nes_mapping_info {
> +	struct list_head mapping_list;
> +	struct sockaddr_in local_sockaddr;
> +	struct sockaddr_in mapped_sockaddr;
> +};
> +
> +enum {
> +	IWPM_INVALID_NLMSG_ERR = 10,
> +	IWPM_CREATE_MAPPING_ERR,
> +	IWPM_DUPLICATE_MAPPING_ERR,
> +	IWPM_UNKNOWN_MAPPING_ERR,
> +	IWPM_CLIENT_DEV_INFO_ERR,
> +	IWPM_USER_LIB_INFO_ERR,
> +	IWPM_REMOTE_QUERY_REJECT
> +};
> +
> +struct nes_cm_info;
> +struct nes_vnic;
> +
> +int nes_register_iwpm_pid(char *, char *, int, void (*req_timer_func)(unsigned long));
> +int nes_add_mapping(struct nes_cm_info *);
> +int nes_add_and_query_mapping(struct nes_cm_info *);
> +int nes_remove_mapping(u32, u16);
> +void nes_create_sockaddr(__be32, __be16, struct sockaddr_in *);
> +int nes_create_mapinfo(struct sockaddr_in *, struct sockaddr_in *);
> +int nes_remove_mapinfo(struct sockaddr_in *);
> +void nes_destroy_mapinfo_list(void);
> +void print_iwpm_available(int);
> +
> +#endif /* __NES_NETLINK_H */
> diff --git a/drivers/infiniband/hw/nes/nes_nic.c b/drivers/infiniband/hw/nes/nes_nic.c
> index 49eb511..e140c5b 100644
> --- a/drivers/infiniband/hw/nes/nes_nic.c
> +++ b/drivers/infiniband/hw/nes/nes_nic.c
> @@ -94,6 +94,9 @@ static const u32 default_msg = NETIF_MSG_DRV | NETIF_MSG_PROBE | NETIF_MSG_LINK
>   static int debug = -1;
>   static int nics_per_function = 1;
>   
> +char nes_ifname[IWPM_IFNAME_SIZE];
> +char nes_ibdev[IWPM_DEVNAME_SIZE];
> +
>   /**
>    * nes_netdev_poll
>    */
> @@ -266,6 +269,8 @@ static int nes_netdev_open(struct net_device *netdev)
>   	napi_enable(&nesvnic->napi);
>   	nesvnic->netdev_open = 1;
>   
> +	memcpy(nes_ifname, nesvnic->netdev->name, IWPM_IFNAME_SIZE);
> +	memcpy(nes_ibdev, nesvnic->nesibdev->ibdev.name, IWPM_DEVNAME_SIZE);
>   	return 0;
>   }
>   

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

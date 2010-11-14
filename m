From: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 0/3] IB Netlink Interface and RDMA CM exports
Date: Sun, 14 Nov 2010 18:12:34 +0200
Message-ID: <4CE00A72.30001@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-smomgflXvOZWk0Htik3J/w@public.gmane.org, ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch set provides means for communicating internal data from IB modules
to the userspace.It is composed of three components:
1. Main ib_netlink module which is independent of IB modules.(ib_netlink.ko).
2. "plug-in" modules per client IB module.(only ib_netlink_rdma_cm.ko for now).
   Depends on (1) and (3). Their role is to keep (1) and (3) independent
   as well as choosing callbacks to call, based on the requested op.
   This doesn't actually happen in ib_netlink_rdma_cm.ko because at the moment,
   only one callback is implemented.
3. additional callbacks which are implemented inside existing IB modules.
   (only rdma_cm for now).
   No additional dependencies, and existing flows stay untouched.

At the moment the implementation is basic and generic.
ib_netlink uses the standard netlink module and defines a new netlink unit
(NETLINK_INFINIBAND) in netlink.h.
Upon receiving a request from userspace, it finds the target client using a
registration mechanism, allocates a raw buffer (skbuff) for the client IB module
to write its data on, and then, forwards the result back.
The size of the buffer space to be allocated is returned by the IB module,
which is also responsible to write no more than the given size.
The exact format of the returned data is unknown to ib_netlink itself.
It is shared between the kernel and userspace in the form of common headers.
The current choice of format is for reasons of simplicity.

A quick and dirty userspace demo application output+source is attached for reference.
Sample output:
Type  Device   Port  PID    Net_dev    Src Address          Dst Address          Space  State           QPN      
IB    mthca0   1     27404  ib0        192.168.168.3/7174   N/A                  TCP    LISTEN          0        
IB    mthca0   2     27415  ib1        192.168.2.3/7174     N/A                  TCP    LISTEN          0        
IB    mthca0   1     30     ib0        192.168.168.3/7174   192.168.168.2/57354  TCP    CONNECT         590854   
IB    mthca0   2     15     ib1        192.168.2.3/7174     192.168.2.4/33290    TCP    CONNECT         590855   

Source:
#include <stdlib.h>
#include <stdio.h>
#include <sys/types.h>
#include <unistd.h>
#include <string.h>
#include <errno.h>
#include <arpa/inet.h>

#include <sys/socket.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <linux/netlink.h>
#include "rdma_cma.h"
#include "ib_netlink.h"

#include <sys/ioctl.h>
#include <net/if.h>
#include <net/if_arp.h>

#define MAX_PAYLOAD 1024  

struct sockaddr_nl src_addr, dest_addr;
struct nlmsghdr *nlh = NULL;
struct msghdr msg;
struct iovec iov;
int sock_fd;
struct rdma_cm_stats *stats;
struct rdma_cm_device_stats *cur_device_stats;
struct rdma_cm_id_stats *cur_id_stats;
void *buff_head;
int i, j;

char *get_ifname(int index)
{
	static struct ifreq req;
	int sock = socket(AF_INET, SOCK_DGRAM, 0);
	req.ifr_ifindex = index;
	if (index == 0) {
		return "N/A";
	}
	if (ioctl(sock, SIOCGIFNAME, &req) < 0) {
		fprintf(stderr, "SIOCGIFNAME failed for index %d\n", index);
		return "N/A";
	}
	return req.ifr_name;
}

static const char *format_cma_state(enum cma_state s)
{
	switch (s) {
	case CMA_IDLE:           return "IDLE";
	case CMA_ADDR_QUERY:     return "ADDR_QUERY";
	case CMA_ADDR_RESOLVED:  return "ADDR_RESOLVED";
	case CMA_ROUTE_QUERY:    return "ROUTE_QUERY";
	case CMA_ROUTE_RESOLVED: return "ROUTE_RESOLVED";
	case CMA_CONNECT:        return "CONNECT";
	case CMA_DISCONNECT:     return "DISCONNECT";
	case CMA_ADDR_BOUND:     return "ADDR_BOUND";
	case CMA_LISTEN:         return "LISTEN";
	case CMA_DEVICE_REMOVAL: return "DEVICE_REMOVAL";
	case CMA_DESTROYING:     return "DESTROYING";
	default: 	         return "N/A";
	}
}

static const char *format_port_space(enum rdma_port_space ps)
{
	switch (ps) {
	case RDMA_PS_SDP:       return "SDP";
	case RDMA_PS_IPOIB:     return "IPOIB";
	case RDMA_PS_TCP:       return "TCP";
	case RDMA_PS_UDP:       return "UDP";
	default: 	        return "N/A";
	}
}

static const char *format_node_type(enum rdma_node_type nt)
{
	switch (nt) {
	case ARPHRD_INFINIBAND:	return "IB";
	case ARPHRD_ETHER: 	return "IW";
	default:		return "N/A";
	}
}

static int format_address(struct sockaddr *addr, char *buff)
{
	struct sockaddr_in *addr_in = (struct sockaddr_in *)addr;
	if (addr_in->sin_addr.s_addr) {
		sprintf(buff, "%s/%d", inet_ntoa(addr_in->sin_addr), ntohs(addr_in->sin_port));
	} 
	else
		sprintf(buff, "N/A");
	return 0;
}

int main()
{
	char tmp_buff[64];

	sock_fd = socket(PF_NETLINK, SOCK_RAW, NETLINK_INFINIBAND);
	if (sock_fd < 0) {
		printf("Failed to create socket. Error: %s (%d)\n", strerror(errno), errno);
		return -1;
	}

	memset(&src_addr, 0, sizeof(src_addr));
	src_addr.nl_family = AF_NETLINK;
	src_addr.nl_pid = getpid();  /* self pid */
	src_addr.nl_groups = 0;  /* not in mcast groups */
	bind(sock_fd, (struct sockaddr*)&src_addr, sizeof(src_addr));

	memset(&dest_addr, 0, sizeof(dest_addr));
	dest_addr.nl_family = AF_NETLINK;
	dest_addr.nl_pid = 0;   /* For Linux Kernel */
	dest_addr.nl_groups = 0; /* unicast */

	nlh=(struct nlmsghdr *)malloc(NLMSG_SPACE(MAX_PAYLOAD));
	/* Fill the netlink message header */
	nlh->nlmsg_len = NLMSG_SPACE(MAX_PAYLOAD);
	nlh->nlmsg_pid = getpid();  /* self pid */
	nlh->nlmsg_flags = NLM_F_REQUEST;
	nlh->nlmsg_type = IBNL_GET_TYPE(IBNL_RDMA_CM, IBNL_RDMA_CM_STATS);

	iov.iov_base = (void *)nlh;
	iov.iov_len = nlh->nlmsg_len;
	msg.msg_name = (void *)&dest_addr;
	msg.msg_namelen = sizeof(dest_addr);
	msg.msg_iov = &iov;
	msg.msg_iovlen = 1;

	sendmsg(sock_fd, &msg, 0);

	memset(nlh, 0, NLMSG_SPACE(MAX_PAYLOAD));
	recvmsg(sock_fd, &msg, 0);
	stats = NLMSG_DATA(nlh);
	buff_head = stats + 1;
	for (i = 0; i < stats->num_devices; i++) {
		cur_device_stats = buff_head;
		buff_head = cur_device_stats + 1;
		printf("%-5s %-8s %-5s %-6s %-10s %-20s %-20s %-6s %-15s %-8s \n",
			"Type", "Device", "Port", "PID", "Net_dev", "Src Address",
			"Dst Address", "Space", "State", "QPN");
		for (j = 0; j < cur_device_stats->num_ids; j++) {
			cur_id_stats = buff_head;
			buff_head = cur_id_stats + 1;
			printf("%-5s %-8s %-5d %-6u %-10s ", 
				format_node_type(cur_id_stats->nt), 
				cur_device_stats->name, 
				cur_id_stats->port_num,
				cur_id_stats->pid,
				get_ifname(cur_id_stats->bound_dev_if));
			format_address(&cur_id_stats->local_addr, tmp_buff);
			printf("%-20s ",tmp_buff);
			format_address(&cur_id_stats->remote_addr, tmp_buff);
			printf("%-20s ",tmp_buff);
			printf("%-6s %-15s %-8d \n",
				format_port_space(cur_id_stats->ps),
				format_cma_state(cur_id_stats->cma_state),
				cur_id_stats->qp_num);
		}
	}
	close(sock_fd);
	return 0;
}
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

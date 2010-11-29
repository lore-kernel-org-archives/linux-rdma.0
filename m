From: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V2 0/5] IB Netlink Interface and RDMA CM exports
Date: Mon, 29 Nov 2010 18:16:34 +0200
Message-ID: <1291047399-430-1-git-send-email-nirm@voltaire.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-smomgflXvOZWk0Htik3J/w@public.gmane.org, ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org, nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch set provides means for communicating internal data from
IB modules to the userspace.
It is composed of two components:
1. The main ib_netlink infrastructure which lives and is initialized by ib_core.
2. additional clients which are implemented inside existing IB modules.
   Clients are responsible for adding/removing their modules during init/exit
   to/from the infrastructure.
   They also supply callbacks for the infrastructure to call
   based on the module/operation type.

ib_netlink uses the standard Netlink module and defines a new Netlink unit
(NETLINK_INFINIBAND) in netlink.h.
Upon receiving a request from userspace, it finds the target client
using the add/remove mechanism, and then calls its supplied callback.
The callbacks are responsible for allocating skbuffs and Netlink messages
using an infrastructure function (ibnl_put).
This function actually does the work of skbuff allocations,
fragmentation and sending.
The exact format of the returned data is unknown to ib_netlink itself.
It is shared between the kernel and
userspace in the form of common headers.

Changelog:
1. Patch doesn't define new modules. (See above for new design)
2. Fixed ib_core init function - initialized cache regardless of sysfs.
   (Let me know if that was intentional)
2. Messages are now transported in the format of
   multiple netlink messages per skb and multiple skb's per reply.
3. Several changes by Sean's comments:
   - Exported enum cma_state (now enum rdma_cm_state).
   - Made some type changes.
4. Some other minor fixes

A quick and dirty userspace demo application is attached for reference.
Here's a sample output:
Type  Device   Port  PID    Net_dev    Src Address          Dst Address          Space  State           QPN      
IB    mthca0   1     27404  ib0        192.168.168.3/7174   N/A                  TCP    LISTEN          0        
IB    mthca0   2     27415  ib1        192.168.2.3/7174     N/A                  TCP    LISTEN          0        
IB    mthca0   1     30     ib0        192.168.168.3/7174   192.168.168.2/57354  TCP    CONNECT         590854   
IB    mthca0   2     15     ib1        192.168.2.3/7174     192.168.2.4/33290    TCP    CONNECT         590855   

And here's the source:

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

#define MAX_PAYLOAD 8192 

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

static const char *format_rdma_cm_state(enum rdma_cm_state s)
{
	switch (s) {
	case RDMA_CM_IDLE:           return "IDLE";
	case RDMA_CM_ADDR_QUERY:     return "ADDR_QUERY";
	case RDMA_CM_ADDR_RESOLVED:  return "ADDR_RESOLVED";
	case RDMA_CM_ROUTE_QUERY:    return "ROUTE_QUERY";
	case RDMA_CM_ROUTE_RESOLVED: return "ROUTE_RESOLVED";
	case RDMA_CM_CONNECT:        return "CONNECT";
	case RDMA_CM_DISCONNECT:     return "DISCONNECT";
	case RDMA_CM_ADDR_BOUND:     return "ADDR_BOUND";
	case RDMA_CM_LISTEN:         return "LISTEN";
	case RDMA_CM_DEVICE_REMOVAL: return "DEVICE_REMOVAL";
	case RDMA_CM_DESTROYING:     return "DESTROYING";
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

static int format_address(__be32 addr[4], __be16 port, char *buff)
{
	if (addr[0] && port) {
		sprintf(buff, "%s/%d", inet_ntoa(*(struct in_addr *)(addr)), ntohs(port));
	} 
	else
		sprintf(buff, "N/A");
	return 0;
}

int main()
{
	struct sockaddr_nl src_addr, dest_addr;
	struct msghdr msg;
	struct iovec iov;
	int sock_fd;
	struct rdma_cm_id_stats *cur_id_stats;
	char tmp_buf[64];
	int len;
	char cur_name[64];
	struct nlmsghdr *nlh = NULL;
	int ret;

	sock_fd = socket(PF_NETLINK, SOCK_RAW, NETLINK_INFINIBAND);

	if (sock_fd < 0) {
		printf("Failed to create socket. Error: %s (%d)\n", strerror(errno), errno);
		return -1;
	}

	memset(&src_addr, 0, sizeof(src_addr));
	src_addr.nl_family = AF_NETLINK;
	src_addr.nl_pid = getpid();
	src_addr.nl_groups = 0;  /* not in mcast groups */
	bind(sock_fd, (struct sockaddr*)&src_addr, sizeof(src_addr));

	memset(&dest_addr, 0, sizeof(dest_addr));
	dest_addr.nl_family = AF_NETLINK;
	dest_addr.nl_pid = 0;   /* For Linux Kernel */
	dest_addr.nl_groups = 0; /* unicast */

	nlh=(struct nlmsghdr *)malloc(NLMSG_SPACE(MAX_PAYLOAD));
	nlh->nlmsg_len = NLMSG_SPACE(MAX_PAYLOAD);
	nlh->nlmsg_pid = getpid();
	nlh->nlmsg_flags = NLM_F_REQUEST;
	nlh->nlmsg_type = IBNL_GET_TYPE(IBNL_RDMA_CM, IBNL_RDMA_CM_STATS);

	iov.iov_base = (void *)nlh;
	iov.iov_len = nlh->nlmsg_len;
	msg.msg_name = (void *)&dest_addr;
	msg.msg_namelen = sizeof(dest_addr);
	msg.msg_iov = &iov;
	msg.msg_iovlen = 1;

	sendmsg(sock_fd, &msg, 0);

	printf("%-5s %-8s %-5s %-6s %-10s %-25s %-25s %-6s %-15s %-8s \n",
		"Type", "Device", "Port", "PID", "Net_dev", "Src Address",
		"Dst Address", "Space", "State", "QPN");
	while (1) {
		memset(nlh, 0, NLMSG_SPACE(MAX_PAYLOAD));
		iov.iov_base = (void *)nlh;
		iov.iov_len = NLMSG_SPACE(MAX_PAYLOAD);
		msg.msg_name = (void *)&dest_addr;
		msg.msg_namelen = sizeof(dest_addr);
		msg.msg_iov = &iov;
		msg.msg_iovlen = 1;

		len = recvmsg(sock_fd, &msg, 0);
		if (len <= 0)
			break;
		cur_id_stats = NLMSG_DATA(nlh);
		while ((ret = NLMSG_OK(nlh, len)) != 0) {
			if (nlh->nlmsg_type == NLMSG_DONE) {
				close(sock_fd);
				return 0;
			}
			if (IBNL_GET_OP(nlh->nlmsg_type) == IBNL_RDMA_CM_DEVICE_NAME) {
				strncpy(cur_name, NLMSG_DATA(nlh), 64);
			}
			else {
				cur_id_stats = NLMSG_DATA(nlh);
				
				printf("%-5s %-8s %-5d %-6u %-10s ", 
					format_node_type(cur_id_stats->nt), 
					cur_name, 
					cur_id_stats->port_num,
					cur_id_stats->pid,
					get_ifname(cur_id_stats->bound_dev_if));
				format_address(cur_id_stats->local_addr, cur_id_stats->local_port, tmp_buf);
				printf("%-25s ",tmp_buf);
				format_address(cur_id_stats->remote_addr, cur_id_stats->remote_port, tmp_buf);
				printf("%-25s ",tmp_buf);
				printf("%-6s %-15s 0x%-8x \n",
					format_port_space(cur_id_stats->ps),
					format_rdma_cm_state(cur_id_stats->cm_state),
					cur_id_stats->qp_num);
			}
			nlh = NLMSG_NEXT(nlh, len);
		}
	}
	close(sock_fd);
	return 0;
}

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

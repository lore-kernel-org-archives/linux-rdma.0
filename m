From: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V3 0/6] IB Netlink Interface and RDMA CM exports
Date: Mon, 13 Dec 2010 18:22:44 +0200
Message-ID: <1292257370-24391-1-git-send-email-nirm@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-smomgflXvOZWk0Htik3J/w@public.gmane.org, ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org, nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

IB Netlink infrastructure and module for rdma_cm

This patch set provides means for communicating internal data from
IB modules to the userspace.
It is composed of two components:
1. The main ib_netlink infrastructure which lives and is initialized by ib_core.
2. additional clients which are implemented inside existing IB modules.
   Clients are responsible for adding/removing their modules during init/exit
   to/from the infrastructure.
   They also supply an array of callbacks for the infrastructure to call
   based on the module/operation type. 

ib_netlink uses the standard Netlink module and defines a new Netlink unit
(NETLINK_INFINIBAND) in netlink.h.
Upon receiving a request from userspace, it finds the target client
using the add/remove mechanism, and then uses client's callback table to call
the callback which is associated with the requested op, using the 
netlink_dump_start helper function.
The callbacks must be of the form:
int (*dump)(struct sk_buff *skb, struct netlink_callback *cb)
and must use the netlink_callback context in order to save state when called 
multiple times.
There is no guarantee that the returned data will be consistent as data
structures can change between calls.
The exact format of the returned data is unknown to ib_netlink itself.
It is shared between the kernel and userspace in the form of common headers.

Changelog:
1. Callbacks are now called via netlink_dump_start.
2. Op dependent callbacks are now by the infrastructure itself using
   supplied callback tables.
3. src/dst addresses are now returned as an attribute. (A very large one...)

A quick and dirty userspace demo application is attached for reference.
Here's a sample output:
Type  Port  PID    Net_dev    Src Address          Dst Address          Space  State           QPN      
IB    1     27404  ib0        192.168.168.3/7174   N/A                  TCP    LISTEN          0        
IB    2     27415  ib1        192.168.2.3/7174     N/A                  TCP    LISTEN          0        
IB    1     30     ib0        192.168.168.3/7174   192.168.168.2/57354  TCP    CONNECT         590854   
IB    2     15     ib1        192.168.2.3/7174     192.168.2.4/33290    TCP    CONNECT         590855   

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
#include <dirent.h>

#include <netinet/in.h>
#include <linux/netlink.h>
#include <netlink/attr.h>
#include "rdma_cma.h"
#include "ib_netlink.h"

#include <sys/ioctl.h>
#include <net/if.h>
#include <net/if_arp.h>

#define MAX_PAYLOAD 8192

void get_ifname(int index, char *if_name)
{
	struct ifreq req;
	int sock = socket(AF_INET, SOCK_DGRAM, 0);

	strcpy(if_name, "N/A");
	req.ifr_ifindex = index;
	if (index != 0) {
		
		if (ioctl(sock, SIOCGIFNAME, &req) < 0) {
			fprintf(stderr, "SIOCGIFNAME failed for index %d\n", index);
		}
		else {
			strcpy(if_name, req.ifr_name);
		}
	}
}
/*
void get_devname(const char *if_name, char *dev_name)
{
	char path[128];
	DIR *dir;
	struct dirent *dirent;

	strcpy(dev_name, "N/A");
	sprintf(path, "/sys/class/net/%s/device/infiniband", if_name);
	if ((dir = opendir(path)) == NULL) {
		return;
	}
	while ((dirent = readdir(dir)) != NULL) {
		if (strcmp(dirent->d_name, ".") && 
		    strcmp(dirent->d_name, "..")) {
			strcpy(dev_name, dirent->d_name);
			break;
		}
	}
	//closedir(dir);
}
*/

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

static int format_address(void *addr, char *buff)
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
	struct sockaddr_nl src_addr, dest_addr;
	struct msghdr msg;
	struct iovec iov;
	int sock_fd;
	struct rdma_cm_id_stats *cur_id_stats;
	char tmp_buf[64];
	int len;
	char if_name[64];
	//char dev_name[64];
	struct nlmsghdr *nlh = NULL;
	int ret;
	//u32 ret1=256, ret2=4;
	struct nlattr * tb[10];

	sock_fd = socket(PF_NETLINK, SOCK_RAW, NETLINK_INFINIBAND);
	//setsockopt(sock_fd, SOL_SOCKET, SO_RCVBUF, &ret1, ret2);
	//getsockopt(sock_fd, SOL_SOCKET, SO_RCVBUF, &ret1, &ret2);
	//printf("rcvbuf=%d len=%d\n", ret1, ret2);

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
	printf("%-5s %-5s %-6s %-10s %-25s %-25s %-6s %-15s %-8s \n",
		"Type", "Port", "PID", "Net_dev", "Src Address",
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
			cur_id_stats = NLMSG_DATA(nlh);
			
			get_ifname(cur_id_stats->bound_dev_if, if_name);
			//get_devname(if_name, dev_name);
			printf("%-5s %-5d %-6u %-10s ", 
			       format_node_type(cur_id_stats->nt), 
			       cur_id_stats->port_num,
			       cur_id_stats->pid,
			       if_name);
			nla_parse(tb, IBNL_RDMA_CM_NUM_ATTR, (struct nlattr *)(cur_id_stats+1),
			          nlh->nlmsg_len - NLMSG_LENGTH(sizeof(*cur_id_stats)), NULL);
			format_address(nla_data(tb[IBNL_RDMA_CM_ATTR_SRC_ADDR]), tmp_buf);
			printf("%-25s ",tmp_buf);
			format_address(nla_data(tb[IBNL_RDMA_CM_ATTR_DST_ADDR]), tmp_buf);
			printf("%-25s ",tmp_buf);
			printf("%-6s %-15s 0x%-8x \n",
			       format_port_space(cur_id_stats->ps),
			       format_rdma_cm_state(cur_id_stats->cm_state),
			       cur_id_stats->qp_num);
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

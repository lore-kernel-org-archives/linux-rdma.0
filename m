From: Fabian Holler <fabian.holler-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: First byte of private_data transfered with rdma_connect() is always 0
Date: Tue, 16 Dec 2014 15:32:43 +0100
Message-ID: <20141216143242.GB4401@fholler.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="f+W+jCU1fRNres8c"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--f+W+jCU1fRNres8c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,

we are using the conn_param->private_data field to transfer data with the
rdma_connect() call to the server.
When it's done on a RDMA_PS_IB rdma_cm_id the first Byte of the
private_data, that is received by the server is _always_ 0.
When a RDMA_PS_TCP rdma_cm_id is used, the data is received correctly on the
server.

We are using:
- kernel 3.14.13
- Mellanox Technologies MT26428 HCA
- mlx4_0 driver

I attached a simple client and server module to reproduce the behaviour.
Can somebody have a look? Is there a problem in our modules? Or is it a bug?

----------
Connection establishment via GID (RDMA_PS_IB):
client:
    # insmod client.ko gid_addr=fe80:0000:0000:0000:0002:c903:0010:c0f5
    [ 7328.586773] private_dataffff88022a263c50: 57 48 41 5a 20 55 50 20 53 45 52 56 45 52 3f 00  WHAZ UP SERVER?.
    
server:
    [ 1658.208238] private_dataffff8800b93e3bec: 00 48 41 5a 20 55 50 20 53 45 52 56 45 52 3f 00  .HAZ UP SERVER?.
    [ 1658.208239] private_dataffff8800b93e3bfc: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    [ 1658.208241] private_dataffff8800b93e3c0c: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    [ 1658.208242] private_dataffff8800b93e3c1c: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    [ 1658.208244] private_dataffff8800b93e3c2c: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    [ 1658.208245] private_dataffff8800b93e3c3c: 00 00 00 00 00 00 00 00 00 00 00 00              ............


Connection establishment via IPv4 address (RDMA_PS_TCP):
client:
    # insmod client.ko ip_addr=10.50.100.62
    [ 7179.219773] private_dataffff88022a263c50: 57 48 41 5a 20 55 50 20 53 45 # 52 56 45 52 3f 00  WHAZ UP SERVER?.
    
server:
    [ 1508.840508] private_dataffff8800b8d25b90: 57 48 41 5a 20 55 50 20 53 45 52 56 45 52 3f 00  WHAZ UP SERVER?.
    [ 1508.840509] private_dataffff8800b8d25ba0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    [ 1508.840511] private_dataffff8800b8d25bb0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    [ 1508.840512] private_dataffff8800b8d25bc0: 00 00 00 00 00 00 00 00                          ........
----------


thanks

Fabian

--f+W+jCU1fRNres8c
Content-Type: text/x-csrc; charset=us-ascii
Content-Disposition: attachment; filename="client.c"

#include <linux/module.h>
#include <rdma/rdma_cm.h>
#include <rdma/ib.h>
#include <linux/inet.h>
#include <linux/wait.h>

MODULE_LICENSE("GPL");

static char *ip_addr;
module_param(ip_addr, charp, 0444);

static char *gid_addr;
module_param(gid_addr, charp, 0444);

#define SERVER_PORT 1234

#define my_printk(level, format, arg...) printk(level KBUILD_MODNAME \
		" %s(), %d: " \
		format, __func__, __LINE__, ## arg)
#define LOG(format, arg...) my_printk(KERN_INFO, format, ## arg)

struct con {
	struct rdma_cm_id	*cm_id;
	enum rdma_cm_event_type	ev;
	wait_queue_head_t	wait_q;
};

static struct con con;

#define XX(a) case (a): return #a
static inline const char *rdma_event_str(enum rdma_cm_event_type event)
{
	switch (event) {
	XX(RDMA_CM_EVENT_ADDR_RESOLVED);
	XX(RDMA_CM_EVENT_ADDR_ERROR);
	XX(RDMA_CM_EVENT_ROUTE_RESOLVED);
	XX(RDMA_CM_EVENT_ROUTE_ERROR);
	XX(RDMA_CM_EVENT_CONNECT_REQUEST);
	XX(RDMA_CM_EVENT_CONNECT_RESPONSE);
	XX(RDMA_CM_EVENT_CONNECT_ERROR);
	XX(RDMA_CM_EVENT_UNREACHABLE);
	XX(RDMA_CM_EVENT_REJECTED);
	XX(RDMA_CM_EVENT_ESTABLISHED);
	XX(RDMA_CM_EVENT_DISCONNECTED);
	XX(RDMA_CM_EVENT_DEVICE_REMOVAL);
	XX(RDMA_CM_EVENT_MULTICAST_JOIN);
	XX(RDMA_CM_EVENT_MULTICAST_ERROR);
	XX(RDMA_CM_EVENT_ADDR_CHANGE);
	XX(RDMA_CM_EVENT_TIMEWAIT_EXIT);
	default: return "RDMA_CM_UNKNOWN";
	}
}

static int rdma_cm_ev_handler(struct rdma_cm_id *cm_id,
			      struct rdma_cm_event *event)
{
	struct con *con = cm_id->context;

	LOG("CM event %s, error %d\n", rdma_event_str(event->event),
	     event->status);

	con->ev = event->event;
	wake_up_interruptible(&con->wait_q);
	return 0;
}

static int str_gid_to_sockaddr(const char *gid, struct sockaddr_ib *dst)
{
	int ret;

	ret = in6_pton(gid, strlen(gid),
		       dst->sib_addr.sib_raw, '\n', NULL);
	if (ret == 0)
		return -EINVAL;

	dst->sib_family = AF_IB;
	dst->sib_sid = cpu_to_be64(RDMA_IB_IP_PS_IB | SERVER_PORT);
	dst->sib_sid_mask = cpu_to_be64(0xffffffffffffffffULL);
	dst->sib_pkey = cpu_to_be16(0xffff);
	LOG("Converted %s to binary GID %pI6\n", gid, dst->sib_addr.sib_raw);
	return 0;
}

static int str_ip_to_sockaddr(const char *ipaddr, struct sockaddr_storage *dst)
{
	int ret;
	u8 ip4[4];

	ret = in6_pton(ipaddr, strlen(ipaddr),
		       ((struct sockaddr_in6 *)dst)->sin6_addr.s6_addr,
		       '\n', NULL);
	if (ret == 1) {
		dst->ss_family = AF_INET6;
		((struct sockaddr_in6 *)dst)->sin6_port =
						htons(SERVER_PORT);
		LOG("Converted %s to binary IPv6 %pI6\n", ipaddr,
		    ((struct sockaddr_in6 *)dst)->sin6_addr.s6_addr);
		return 0;
	}

	ret = in4_pton(ipaddr, strlen(ipaddr), ip4, '\n', NULL);
	if (ret == 0)
		return -EINVAL;

	memcpy(&((struct sockaddr_in *)dst)->sin_addr.s_addr, ip4,
	       sizeof(((struct sockaddr_in *)dst)->sin_addr.s_addr));
	dst->ss_family = AF_INET;
	((struct sockaddr_in *)dst)->sin_port = htons(SERVER_PORT);
	LOG("Converted %s to binary IPv4 %pI4\n", ipaddr,
	    &((struct sockaddr_in *)dst)->sin_addr.s_addr);
	return 0;
}

static int fill_sockaddr(struct sockaddr_storage *s)
{
	if (gid_addr != NULL && strlen(gid_addr) > 0)
		return str_gid_to_sockaddr(gid_addr, (struct sockaddr_ib *)s);
	else if (ip_addr != NULL && strlen(ip_addr) > 0)
		return str_ip_to_sockaddr(ip_addr, s);
	return -EINVAL;
}

static int __init in(void)
{
	int ret;
	struct sockaddr_storage addr;
	struct rdma_conn_param conn_param;
	const char msg[] = "WHAZ UP SERVER?";

	con.ev = RDMA_CM_EVENT_DEVICE_REMOVAL;

	init_waitqueue_head(&con.wait_q);
	ret = fill_sockaddr(&addr);
	if (ret)
		return ret;

	if (addr.ss_family == AF_IB)
		con.cm_id = rdma_create_id(rdma_cm_ev_handler, &con, RDMA_PS_IB,
					    IB_QPT_RC);
	else
		con.cm_id = rdma_create_id(rdma_cm_ev_handler, &con,
					   RDMA_PS_TCP, IB_QPT_RC);
	if (IS_ERR(con.cm_id)) {
		ret = PTR_ERR(con.cm_id);
		return ret;
	}

	ret = rdma_resolve_addr(con.cm_id, NULL, (struct sockaddr *)&addr,
				1000);
	if (ret) {
		LOG("resolving addr failed\n");
		goto cm_id;
	}

	ret = wait_event_interruptible(con.wait_q, con.ev ==
				       RDMA_CM_EVENT_ADDR_RESOLVED);
	if (ret < 0)
		goto cm_id;

	ret = rdma_resolve_route(con.cm_id, 1000);
	if (ret) {
		LOG("resolving route failed\n");
		goto cm_id;
	}
	ret = wait_event_interruptible(con.wait_q, con.ev ==
				       RDMA_CM_EVENT_ROUTE_RESOLVED);
	if (ret < 0)
		goto cm_id;

	memset(&conn_param, 0, sizeof(conn_param));
	conn_param.private_data		= &msg;
	conn_param.private_data_len	= sizeof(msg);
	conn_param.retry_count = 7;
	print_hex_dump(KERN_INFO, "private_data", DUMP_PREFIX_ADDRESS, 16, 1,
		       conn_param.private_data, conn_param.private_data_len,
		       true);
	ret = rdma_connect(con.cm_id, &conn_param);
	if (ret) {
		LOG("Connect failed: %d\n", ret);
		goto cm_id;
	}

	rdma_disconnect(con.cm_id);
cm_id:
	rdma_destroy_id(con.cm_id);
	return ret;
}

static void __exit out(void)
{
}
module_init(in);
module_exit(out);

--f+W+jCU1fRNres8c
Content-Type: text/x-csrc; charset=us-ascii
Content-Disposition: attachment; filename="server.c"

#include <linux/module.h>
#include <rdma/rdma_cm.h>
#include <rdma/ib.h>
#include <linux/inet.h>


#define SERVER_PORT 1234

#define my_printk(level, format, arg...) printk(level KBUILD_MODNAME \
		" %s(), %d: " \
		format, __func__, __LINE__, ## arg)
#define LOG(format, arg...) my_printk(KERN_INFO, format, ## arg)

static const char msg[] = "WHAZ UP SERVER?";
static struct rdma_cm_id *cm_ip;
static struct rdma_cm_id *cm_ib;

#define XX(a) case (a): return #a
static inline const char *rdma_event_str(enum rdma_cm_event_type event)
{
	switch (event) {
	XX(RDMA_CM_EVENT_ADDR_RESOLVED);
	XX(RDMA_CM_EVENT_ADDR_ERROR);
	XX(RDMA_CM_EVENT_ROUTE_RESOLVED);
	XX(RDMA_CM_EVENT_ROUTE_ERROR);
	XX(RDMA_CM_EVENT_CONNECT_REQUEST);
	XX(RDMA_CM_EVENT_CONNECT_RESPONSE);
	XX(RDMA_CM_EVENT_CONNECT_ERROR);
	XX(RDMA_CM_EVENT_UNREACHABLE);
	XX(RDMA_CM_EVENT_REJECTED);
	XX(RDMA_CM_EVENT_ESTABLISHED);
	XX(RDMA_CM_EVENT_DISCONNECTED);
	XX(RDMA_CM_EVENT_DEVICE_REMOVAL);
	XX(RDMA_CM_EVENT_MULTICAST_JOIN);
	XX(RDMA_CM_EVENT_MULTICAST_ERROR);
	XX(RDMA_CM_EVENT_ADDR_CHANGE);
	XX(RDMA_CM_EVENT_TIMEWAIT_EXIT);
	default: return "RDMA_CM_UNKNOWN";
	}
}

static int rdma_cm_ev_handler(struct rdma_cm_id *cm_id,
			      struct rdma_cm_event *event)
{
	LOG("CM event %s, error %d\n", rdma_event_str(event->event),
	    event->status);

	switch (event->event) {
	case RDMA_CM_EVENT_CONNECT_REQUEST:
		print_hex_dump(KERN_INFO, "private_data", DUMP_PREFIX_ADDRESS,
			       16, 1, event->param.conn.private_data,
			       event->param.conn.private_data_len, true);
		return rdma_reject(cm_id, NULL, 0);

		return 0;
	default:
		return 0;
	}
}

static int ibtrs_srv_cm_init(struct rdma_cm_id **cm_id, struct sockaddr *addr,
			     enum rdma_port_space ps)
{
	int ret;

	*cm_id = rdma_create_id(rdma_cm_ev_handler, NULL, ps, IB_QPT_RC);
	if (IS_ERR(*cm_id)) {
		ret = PTR_ERR(*cm_id);
		goto err_out;
	}

	ret = rdma_bind_addr(*cm_id, addr);
	if (ret)
		goto err_cm;
	ret = rdma_listen(*cm_id, 64);
	if (ret) {
		LOG("rdma_listen() return %d\n", ret);
		goto err_cm;
	}

	switch (addr->sa_family) {
	case AF_INET:
		LOG("listening on port %u\n",
		    ((struct sockaddr_in *)addr)->sin_port);
		break;
	case AF_INET6:
		LOG("listening on port %u\n",
		    ((struct sockaddr_in6 *)addr)->sin6_port);
		break;
	case AF_IB:
		LOG("listening on service id 0x%016llx\n",
		    be64_to_cpu(rdma_get_service_id(*cm_id, addr)));
		break;
	default:
		LOG("listening on address family %u\n", addr->sa_family);
	}

	return 0;

err_cm:
	rdma_destroy_id(*cm_id);
err_out:
	return ret;
}

static int gogo(void)
{
	int ret;

	struct sockaddr_in6 sin = {
		.sin6_family = AF_INET6,
		.sin6_addr = IN6ADDR_ANY_INIT,
		.sin6_port = htons(SERVER_PORT),
	};
	struct sockaddr_ib sib = {
		.sib_family = AF_IB,
		.sib_addr.sib_subnet_prefix = 0ULL,
		.sib_addr.sib_interface_id = 0ULL,
		.sib_sid = cpu_to_be64(RDMA_IB_IP_PS_IB | SERVER_PORT),
		.sib_sid_mask = cpu_to_be64(0xffffffffffffffffULL),
		.sib_pkey = cpu_to_be16(0xffff),
	};

	ret = ibtrs_srv_cm_init(&cm_ip, (struct sockaddr *)&sin, RDMA_PS_TCP);
	if (ret)
		return ret;

	return ibtrs_srv_cm_init(&cm_ib, (struct sockaddr *)&sib, RDMA_PS_IB);
}

static int __init in(void)
{
	return gogo();
}

static void __exit out(void)
{
	rdma_disconnect(cm_ip);
	rdma_disconnect(cm_ib);
	rdma_destroy_id(cm_ip);
	rdma_destroy_id(cm_ib);
	return;
}
module_init(in);
module_exit(out);

--f+W+jCU1fRNres8c--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

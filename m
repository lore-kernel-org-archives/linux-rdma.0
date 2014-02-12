From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V1 libibverbs 2/3] Use neighbour lookup for RoCE UD QPs
 Eth L2 resolution
Date: Wed, 12 Feb 2014 12:17:33 +0200
Message-ID: <52FB4A3D.1070607@mellanox.com>
References: <1392121864-9672-1-git-send-email-ogerlitz@mellanox.com>	 <1392121864-9672-3-git-send-email-ogerlitz@mellanox.com> <1392131937.11170.79.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1392131937.11170.79.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 11/2/2014 5:18 PM, Yann Droneaud wrote:
> Le mardi 11 f=C3=A9vrier 2014 =C3=A0 14:31 +0200, Or Gerlitz a =C3=A9=
crit :
>> From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>
>> In order to implement RoCE IP based addressing for UD QPs, without i=
ntroducing
>> uverbs changes, we need a way to resolve the L2 Ethernet addresses f=
rom user-space.
>>
>> This is done with netlink through libnl, and in libibverbs such that=
 multiple
>> vendor provider libraries can use the code.
>>
>> The Ethernet L2 params are passed to the provider driver using an ex=
tension
>> verb drv_ibv_create_ah_ex call. This resolution is done only for pro=
viders
>> that support this extension verb, otherwise, there's not real reason=
 to do that.
>>
>> The steps for resolution:
>>
>> 1. get sgid
>>
>> 2. from sgid, get the interface
>>
>> 3. query route from interface to the destination
>>
>> 4. query the neigh table, if the MAC for the destination is already =
known, done.
>>
>> 5. if not, loop until timeout:
>>      a. send a UDP packet to that IP targeted to the "discard" port

Hi Yann,

Thanks for commenting about this code.

>
> What will happen if the system is configured to refuse to send packet=
 to
> this port: eg it exists an netfilter rules that disallow this:
>
>    iptables -t filter -A OUTPUT -p udp --dport 9 -j REJECT --reject-w=
ith
> icmp-admin-prohibited
>
> (not tested)
>
> And why send a packet in the first place, would it be enough to conne=
ct
> to the socket to target address:9 ? It's possible to call connect() o=
n a
> dgram socket to bind the destination address, but I don't know if it'=
s
> trigger a neighbor resolution.
>

The iptables rule indeed blocks the ARP resolution.
I don't think using connect sends a neighbor resolution, so it's not=20
really a solution.
After considering some alternatives, I think that using non-privileged=20
ping:
socket(AF_INET, SOCK_DGRAM, IPPROTO_ICMP)
is our best option. What do you think?

If that's an appropriate solution, we'll need some backports to current=
=20
distributions, as the ICMP6 code was only submitted to the kernel last =
year.

>>      b. listen to events from the neigh table
>>      c. query neigh table in order to know if the neigh has shown up=
 between
>>         query until we started monitoring it
>>
>
> Such userspace ping must be configurable: timeout and number of tries
> should probably be configurable by userspace.
>

How do you suggest configuring those parameters without changing the AP=
I?

>> 6. query vlan id from the interface
>>
>> This solution depends on libnl v1.
>>
>
> According to http://www.infradead.org/~tgr/libnl/
>
> "1.1.x releases
> Support for 1.1.x releases is limited, backports are only done upon
> request. Do not develop new applications based on libnl1 and consider
> porting your applications to libnl3"
>
> Please provide some rational for using "obsolete" version 1.
>

This was done since most current linux distributions (RH 6.x, SLES 11)=20
don't have libnl > 1 in their repositories. We didn't see the obsolete=20
message, thus we'll provide a libnl3 port of this code. This will=20
require supplying backports for libnl1 for these distributions.

>> Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> ---
>>   Makefile.am                |    3 +
>>   configure.ac               |   11 +
>>   include/infiniband/verbs.h |   35 ++-
>>   src/neigh.c                |  866 ++++++++++++++++++++++++++++++++=
++++++++++++
>>   src/neigh.h                |   42 +++
>>   src/verbs.c                |  160 ++++++++-
>>   6 files changed, 1114 insertions(+), 3 deletions(-)
>>   create mode 100644 src/neigh.c
>>   create mode 100644 src/neigh.h
>>
>> diff --git a/Makefile.am b/Makefile.am
>> index a6767de..f21697f 100644
>> --- a/Makefile.am
>> +++ b/Makefile.am
>> @@ -12,6 +12,9 @@ libibverbs_version_script =3D @LIBIBVERBS_VERSION_=
SCRIPT@
>>   src_libibverbs_la_SOURCES =3D src/cmd.c src/compat-1_0.c src/devic=
e.c src/init.c \
>>   			    src/marshall.c src/memory.c src/sysfs.c src/verbs.c \
>>   			    src/enum_strs.c
>> +if ! NO_RESOLVE_NEIGH
>> +src_libibverbs_la_SOURCES +=3D src/neigh.c
>> +endif
>>   src_libibverbs_la_LDFLAGS =3D -version-info 1 -export-dynamic \
>>       $(libibverbs_version_script)
>>   src_libibverbs_la_DEPENDENCIES =3D $(srcdir)/src/libibverbs.map
>> diff --git a/configure.ac b/configure.ac
>> index b8d4cea..ba67b0a 100644
>> --- a/configure.ac
>> +++ b/configure.ac
>> @@ -28,6 +28,17 @@ else
>>       fi
>>   fi
>>
>> +AC_ARG_WITH([resolve-neigh],
>> +    AC_HELP_STRING([--with-resolve-neigh],
>> +        [Enable neighbour resolution in Ethernet (default YES)]))
>> +if  test x$with_resolve_neigh =3D x || test x$with_resolve_neigh =3D=
 xyes; then
>> +	AC_CHECK_LIB(nl, rtnl_link_vlan_get_id, [],
>> +		AC_MSG_ERROR([rtnl_link_vlan_get_id not found.  libibverbs requir=
es libnl.]))
>> +else
>> +    AC_DEFINE([NRESOLVE_NEIGH], 1, [Define to 1 to disable resovle =
neigh annotations.])
>> +fi
>> +AM_CONDITIONAL(NO_RESOLVE_NEIGH, test x$with_resolve_neigh =3D xno)
>> +
>>   dnl Checks for libraries
>>   AC_CHECK_LIB(dl, dlsym, [],
>>       AC_MSG_ERROR([dlsym() not found.  libibverbs requires libdl.])=
)
>> diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
>> index a79a1de..63c4756 100644
>> --- a/include/infiniband/verbs.h
>> +++ b/include/infiniband/verbs.h
>> @@ -458,6 +458,36 @@ struct ibv_ah_attr {
>>   	uint8_t			port_num;
>>   };
>>
>> +enum ibv_ah_attr_ex_attr_mask {
>> +	IBV_AH_ATTR_EX_LL =3D 1UL << 0,
>> +	IBV_AH_ATTR_EX_VID =3D 1UL << 1,
>> +};
>> +
>> +enum ll_address_type {
>> +	LL_ADDRESS_UNKNOWN,
>> +	LL_ADDRESS_IB,
>> +	LL_ADDRESS_ETH,
>> +	LL_ADDRESS_SIZE
>> +};
>> +
>> +struct ibv_ah_attr_ex {
>> +	struct ibv_global_route	grh;
>> +	uint16_t		dlid;
>> +	uint8_t			sl;
>> +	uint8_t			src_path_bits;
>> +	uint8_t			static_rate;
>> +	uint8_t			is_global;
>> +	uint8_t			port_num;
>> +	uint32_t		comp_mask;
>> +	struct {
>> +		enum ll_address_type type;
>> +		uint32_t	len;
>> +		char		*address;
>> +	} ll_address;
>> +	uint16_t		vid;
>> +};
>> +
>> +
>>   enum ibv_srq_attr_mask {
>>   	IBV_SRQ_MAX_WR	=3D 1 << 0,
>>   	IBV_SRQ_LIMIT	=3D 1 << 1
>> @@ -864,11 +894,14 @@ enum verbs_context_mask {
>>   	VERBS_CONTEXT_XRCD	=3D 1 << 0,
>>   	VERBS_CONTEXT_SRQ	=3D 1 << 1,
>>   	VERBS_CONTEXT_QP	=3D 1 << 2,
>> -	VERBS_CONTEXT_RESERVED	=3D 1 << 3
>> +	VERBS_CONTEXT_CREATE_AH =3D 1 << 3,
>> +	VERBS_CONTEXT_RESERVED  =3D 1 << 4
>>   };
>>
>>   struct verbs_context {
>>   	/*  "grows up" - new fields go here */
>> +	struct ibv_ah * (*drv_ibv_create_ah_ex)(struct ibv_pd *pd,
>> +						struct ibv_ah_attr_ex *attr);
>>   	struct ibv_qp *(*open_qp)(struct ibv_context *context,
>>   			struct ibv_qp_open_attr *attr);
>>   	struct ibv_qp *(*create_qp_ex)(struct ibv_context *context,
>> diff --git a/src/neigh.c b/src/neigh.c
>> new file mode 100644
>> index 0000000..dd5d75f
>> --- /dev/null
>> +++ b/src/neigh.c
>> @@ -0,0 +1,866 @@
>> +#include "neigh.h"
>> +
>
> Why is this header included first ? Is it possible to move after syst=
em
> header inclusion ?

Sure, I'll change the order.

>
>> +#include <linux/netlink.h>
>> +#include <stdio.h>
>> +#include <stdlib.h>
>> +#include <netlink/route/rtnl.h>
>> +#include <netlink/route/link.h>
>> +#include <netlink/route/route.h>
>> +#include <netlink/route/neighbour.h>
>> +
>> +#include <sys/types.h>
>> +#include <sys/socket.h>
>> +#include <sys/timerfd.h>
>> +#include <netinet/in.h>
>> +#include <net/if.h>
>> +#include <errno.h>
>> +#include <unistd.h>
>> +#include <ifaddrs.h>
>> +#include <netdb.h>
>> +
>> +/* for PFX */
>> +#include "ibverbs.h"
>> +
>> +#define MAX(a, b) ((a) > (b) ? (a) : (b))
>> +#define print_hdr PFX "resolver: "
>> +#define print_err(...) fprintf(stderr, print_hdr __VA_ARGS__)
>> +#ifdef _DEBUG_
>> +#define print_dbg_s(stream, ...) fprintf((stream), __VA_ARGS__)
>> +#define print_address(stream, msg, addr) \
>> +	{							      \
>> +		char buff[100];					      \
>> +		print_dbg_s((stream), (msg), nl_addr2str((addr), buff,\
>> +			    sizeof(buff)));			      \
>> +	}
>> +#else
>> +#define print_dbg_s(stream, args...)
>> +#define print_address(stream, msg, ...)
>> +#endif
>> +#define print_dbg(...) print_dbg_s(stderr, print_hdr __VA_ARGS__)
>> +
>> +/* Workaround - decleration missing */
>                    ^^^^^^^^^^^^
> typo
>
>> +extern int		rtnl_link_vlan_get_id(struct rtnl_link *);
>> +
>
> Why not adding
>
> AC_CHECK_DECLS([rtnl_link_vlan_get_id], [], [], [[#include
> <netlink/route/rtnl.h>]])
>
> then protect this workaround with:
>
> #if !HAVE_DECL_RTNL_LINK_VLAN_GET_ID
> #endif
>

This implies that users without an appropriate libnl can't use vlans at=
=20
all. Isn't it inappropriate ?
I think it's better to avoid building libibverbs that would give wrong=20
results in some conditions.

>> +static pthread_once_t device_neigh_alloc =3D PTHREAD_ONCE_INIT;
>> +static struct nl_handle *zero_socket;
>> +
>> +union sktaddr {
>> +	struct sockaddr s;
>> +	struct sockaddr_in s4;
>> +	struct sockaddr_in6 s6;
>> +};
>> +
>> +struct skt {
>> +	union sktaddr sktaddr;
>> +	socklen_t len;
>> +};
>> +
>> +
>> +static int set_link_port(union sktaddr *s, int port, int oif)
>> +{
>> +	switch (s->s.sa_family) {
>> +	case AF_INET:
>> +		s->s4.sin_port =3D port;
>> +		break;
>> +	case AF_INET6:
>> +		s->s6.sin6_port =3D port;
>> +		s->s6.sin6_scope_id =3D oif;
>> +		break;
>> +	default:
>> +		return -EINVAL;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int cmp_address(const struct sockaddr *s1,
>> +		       const struct sockaddr *s2) {
>> +	if (s1->sa_family !=3D s2->sa_family)
>> +		return s1->sa_family ^ s2->sa_family;
>> +
>> +	switch (s1->sa_family) {
>> +	case AF_INET:
>> +		return ((struct sockaddr_in *)s1)->sin_addr.s_addr ^
>> +		       ((struct sockaddr_in *)s2)->sin_addr.s_addr;
>> +	case AF_INET6:
>> +		return memcmp(
>> +			((struct sockaddr_in6 *)s1)->sin6_addr.s6_addr,
>> +			((struct sockaddr_in6 *)s2)->sin6_addr.s6_addr,
>> +			sizeof(((struct sockaddr_in6 *)s1)->sin6_addr.s6_addr));
>> +	default:
>> +		return -ENOTSUP;
>> +	}
>> +}
>> +
>> +
>> +static int get_ifindex(const struct sockaddr *s)
>> +{
>> +	struct ifaddrs *ifaddr, *ifa;
>> +	int name2index =3D -ENODEV;
>> +
>> +	if (-1 =3D=3D getifaddrs(&ifaddr))
>> +		return errno;
>> +
>> +	for (ifa =3D ifaddr; ifa !=3D NULL; ifa =3D ifa->ifa_next) {
>> +		if (NULL =3D=3D ifa->ifa_addr)
>> +			continue;
>> +
>> +		if (!cmp_address(ifa->ifa_addr, s)) {
>> +			name2index =3D if_nametoindex(ifa->ifa_name);
>> +			break;
>> +		}
>> +	}
>> +
>> +	freeifaddrs(ifaddr);
>> +
>> +	return name2index;
>> +}
>> +
>> +static struct nl_addr *get_neigh_mac(struct get_neigh_handler *neig=
h_handler)
>> +{
>> +	struct rtnl_neigh *neigh;
>> +	struct nl_addr *ll_addr =3D NULL;
>> +
>> +	/* future optimization - if link local address - parse address and
>> +	 * return mac */
>> +	neigh =3D rtnl_neigh_get(neigh_handler->neigh_cache,
>> +			       neigh_handler->oif,
>> +			       neigh_handler->dst);
>> +	if (NULL =3D=3D neigh) {
>> +		print_dbg("Neigh isn't at cache\n");
>> +		return NULL;
>> +	}
>> +
>> +	ll_addr =3D rtnl_neigh_get_lladdr(neigh);
>> +	if (NULL =3D=3D ll_addr)
>> +		print_err("Failed to get hw address from neighbour\n");
>> +	else
>> +		ll_addr =3D nl_addr_clone(ll_addr);
>> +
>> +	rtnl_neigh_put(neigh);
>> +	return ll_addr;
>> +}
>> +
>> +static void get_neigh_cb_event(struct nl_object *obj, void *arg)
>> +{
>> +	struct get_neigh_handler *neigh_handler =3D
>> +		(struct get_neigh_handler *)arg;
>> +	/* assumed serilized callback (no parallel execution of function) =
*/
>> +	if (nl_object_match_filter(
>> +		obj,
>> +		(struct nl_object *)neigh_handler->filter_neigh)) {
>> +		struct rtnl_neigh *neigh =3D (struct rtnl_neigh *)obj;
>> +		print_dbg("Found a match for neighbour\n");
>> +		/* check that we didn't set it already */
>> +		if (NULL =3D=3D neigh_handler->found_ll_addr) {
>> +			if (NULL =3D=3D rtnl_neigh_get_lladdr(neigh)) {
>> +				print_err("Neighbour doesn't have a hw addr\n");
>> +				return;
>> +			}
>> +			neigh_handler->found_ll_addr =3D
>> +				nl_addr_clone(rtnl_neigh_get_lladdr(neigh));
>> +			if (NULL =3D=3D neigh_handler->found_ll_addr)
>> +				print_err("Couldn't copy neighbour hw addr\n");
>> +		}
>> +	}
>> +}
>> +
>> +static int get_neigh_cb(struct nl_msg *msg, void *arg)
>> +{
>> +	struct get_neigh_handler *neigh_handler =3D
>> +		(struct get_neigh_handler *)arg;
>> +
>> +	if (nl_msg_parse(msg, &get_neigh_cb_event, neigh_handler) < 0)
>> +		print_err("Unknown event\n");
>> +
>> +	return NL_OK;
>> +}
>> +
>> +static void set_neigh_filter(struct get_neigh_handler *neigh_handle=
r,
>> +			     struct rtnl_neigh *filter) {
>> +	neigh_handler->filter_neigh =3D filter;
>> +}
>> +
>> +static struct rtnl_neigh *create_filter_neigh_for_dst(struct nl_add=
r *dst_addr,
>> +						      int oif)
>> +{
>> +	struct rtnl_neigh *filter_neigh;
>> +
>> +	filter_neigh =3D rtnl_neigh_alloc();
>> +	if (NULL =3D=3D filter_neigh) {
>> +		print_err("Couldn't allocate filter neigh\n");
>> +		return NULL;
>> +	}
>> +	rtnl_neigh_set_ifindex(filter_neigh, oif);
>> +	rtnl_neigh_set_dst(filter_neigh, dst_addr);
>> +
>> +
>
> Blank line
>
>> +	return filter_neigh;
>> +}
>> +
>> +#define PORT_DISCARD htons(9)
>> +#define SEND_PAYLOAD "H"
>> +
>> +static int create_socket(struct get_neigh_handler *neigh_handler,
>> +			 struct skt *addr_dst, int *psock_fd)
>> +{
>> +	int err;
>> +	struct skt addr_src;
>> +	int sock_fd;
>> +
>> +	memset(addr_dst, 0, sizeof(*addr_dst));
>> +	memset(&addr_src, 0, sizeof(addr_src));
>> +	addr_src.len =3D sizeof(addr_src.sktaddr);
>> +
>> +	err =3D nl_addr_fill_sockaddr(neigh_handler->src,
>> +				    &addr_src.sktaddr.s,
>> +				    &addr_src.len);
>> +	if (err) {
>> +		print_err("couldn't convert src to sockaddr\n");
>> +		return err;
>> +	}
>> +
>> +	addr_dst->len =3D sizeof(addr_dst->sktaddr);
>> +	err =3D nl_addr_fill_sockaddr(neigh_handler->dst,
>> +				    &addr_dst->sktaddr.s,
>> +				    &addr_dst->len);
>> +	if (err) {
>> +		print_err("couldn't convert dst to sockaddr\n");
>> +		return err;
>> +	}
>> +
>> +	err =3D set_link_port(&addr_dst->sktaddr, PORT_DISCARD,
>> +			    neigh_handler->oif);
>> +	if (err)
>> +		return err;
>> +
>> +	sock_fd =3D socket(addr_dst->sktaddr.s.sa_family, SOCK_DGRAM, 0);
>                              SOCK_DGRAM | SOCK_CLOEXEC
>
> No check for error ?
>
>> +	bind(sock_fd, &addr_src.sktaddr.s, addr_src.len);
>> +
>
> No check for error ?
>

Correct - error handling will be added.

>> +	*psock_fd =3D sock_fd;
>> +
>> +	return 0;
>> +}
>> +
>> +#define NUM_OF_RETRIES 10
>> +#define NUM_OF_TRIES ((NUM_OF_RETRIES) + 1)
>> +#if NUM_OF_TRIES < 1
>> +#error "neigh: invalid value of NUM_OF_RETRIES"
>> +#endif
>> +static int create_timer(struct get_neigh_handler *neigh_handler)
>> +{
>> +	int user_timeout =3D neigh_handler->timeout/NUM_OF_TRIES;
>> +	struct timespec timeout =3D {
>> +		.tv_sec =3D user_timeout / 1000,
>> +		.tv_nsec =3D (user_timeout % 1000) * 1000000
>> +	};
>> +	struct itimerspec timer_time =3D {.it_value =3D timeout};
>> +	int timer_fd;
>> +
>> +	timer_fd =3D timerfd_create(CLOCK_MONOTONIC, TFD_NONBLOCK);
>
> TFD_NONBLOCK | TFD_CLOEXEC
>

Thanks - I'll change that for V2.

>> +	if (-1 =3D=3D timer_fd) {
>> +		print_err("Couldn't create timer\n");
>> +		return timer_fd;
>> +	}
>> +
>> +	if (neigh_handler->timeout) {
>> +		if (NUM_OF_TRIES <=3D 1)
>> +			bzero(&timer_time.it_interval,
>> +			      sizeof(timer_time.it_interval));
>> +		else
>> +			timer_time.it_interval =3D timeout;
>> +		if (timerfd_settime(timer_fd, 0, &timer_time, NULL)) {
>> +			print_err("Couldn't set timer\n");
>> +			return -1;
>> +		}
>> +	}
>> +
>> +	return timer_fd;
>> +}
>> +
>> +#define UDP_SOCKET_MAX_SENDTO 100000ULL
>> +
>> +static struct nl_addr *process_get_neigh_mac(
>> +		struct get_neigh_handler *neigh_handler)
>> +{
>> +	int err;
>> +	struct nl_addr *ll_addr =3D get_neigh_mac(neigh_handler);
>> +	struct rtnl_neigh *neigh_filter;
>> +	fd_set fdset;
>> +	int sock_fd;
>> +	int fd;
>> +	int nfds;
>> +	int timer_fd;
>> +	int ret;
>> +	struct skt addr_dst;
>> +	char buff[sizeof(SEND_PAYLOAD)] =3D SEND_PAYLOAD;
>> +	int retries =3D 0;
>> +	uint64_t max_count =3D UDP_SOCKET_MAX_SENDTO;
>> +
>> +	if (NULL !=3D ll_addr)
>> +		return ll_addr;
>> +
>> +	err =3D nl_socket_add_membership(neigh_handler->sock,
>> +				       RTNLGRP_NEIGH);
>> +	if (err < 0) {
>> +		print_err("%s\n", nl_geterror());
>> +		return NULL;
>> +	}
>> +
>> +	neigh_filter =3D create_filter_neigh_for_dst(neigh_handler->dst,
>> +						   neigh_handler->oif);
>> +	if (NULL =3D=3D neigh_filter)
>> +		return NULL;
>> +
>> +	set_neigh_filter(neigh_handler, neigh_filter);
>> +
>> +	nl_disable_sequence_check(neigh_handler->sock);
>> +	nl_socket_modify_cb(neigh_handler->sock, NL_CB_VALID, NL_CB_CUSTOM=
,
>> +			    &get_neigh_cb, neigh_handler);
>> +
>> +	fd =3D nl_socket_get_fd(neigh_handler->sock);
>
> Can be done later.
>

Sending a pakcet should trigger a netlink event on this fd.
Why do you think it's prefferable to postpone this call?

>> +
>> +	err =3D create_socket(neigh_handler, &addr_dst, &sock_fd);
>> +
>> +	if (err)
>> +		return NULL;
>> +
>> +	do {
>> +		err =3D sendto(sock_fd, buff, sizeof(buff), 0,
>> +				 &addr_dst.sktaddr.s,
>> +				 addr_dst.len);
>> +		if (err > 0)
>> +			err =3D 0;
>> +	} while (-1 =3D=3D err && EADDRNOTAVAIL =3D=3D errno && --max_coun=
t);
>> +
>> +	if (err) {
>> +		print_err("Failed to send packet %d", err);
>> +		goto close_socket;
>> +	}
>> +	timer_fd =3D create_timer(neigh_handler);
>> +	if (timer_fd < 0)
>> +		goto close_socket;
>> +
>> +	nfds =3D MAX(fd, timer_fd) + 1;
>> +
>> +
>
> Blank line
>
>> +	while (1) {
>> +		FD_ZERO(&fdset);
>> +		FD_SET(fd, &fdset);
>> +		FD_SET(timer_fd, &fdset);
>> +
>> +		/* wait for an incoming message on the netlink socket */
>> +		ret =3D select(nfds, &fdset, NULL, NULL, NULL);
>> +
>
> Why not use the timeout feature of select() instead of timerfd ?
>

I would like to use a timeout over the entire process. Using a timeout=20
through the select call implies that every event counts as a retry=20
attempt, which is obviously false.

>> +		if (ret) {
>> +			if (FD_ISSET(fd, &fdset)) {
>> +				nl_recvmsgs_default(neigh_handler->sock);
>> +				if (neigh_handler->found_ll_addr)
>> +					break;
>> +			} else {
>> +				nl_cache_refill(neigh_handler->sock,
>> +						neigh_handler->neigh_cache);
>> +				ll_addr =3D get_neigh_mac(neigh_handler);
>> +				if (NULL !=3D ll_addr) {
>> +					break;
>> +				} else if (FD_ISSET(timer_fd, &fdset) &&
>> +					   retries < NUM_OF_RETRIES) {
>> +					if (sendto(sock_fd, buff, sizeof(buff),
>> +						   0, &addr_dst.sktaddr.s,
>> +						   addr_dst.len) < 0)
>> +						print_err("Failed to send "
>> +							  "packet while waiting"
>> +							  " for events\n");
>> +				}
>> +			}
>> +
>> +			if (FD_ISSET(timer_fd, &fdset)) {
>> +				uint64_t read_val;
>> +				read(timer_fd, &read_val, sizeof(read_val));
>> +				if (++retries >=3D  NUM_OF_TRIES) {
>> +					print_dbg("Timeout while trying to fetch "
>> +						  "neighbours\n");
>> +					break;
>> +				}
>> +			}
>> +		}
>> +	}
>> +	close(timer_fd);
>> +close_socket:
>> +	close(sock_fd);
>> +	return ll_addr ? ll_addr : neigh_handler->found_ll_addr;
>> +}
>> +
>> +
>> +static int get_mcast_mac_ipv4(struct nl_addr *dst, struct nl_addr *=
*ll_addr)
>> +{
>> +	char mac_addr[6] =3D {0x01, 0x00, 0x5E};
>> +	uint32_t addr =3D ntohl(*(uint32_t *)nl_addr_get_binary_addr(dst))=
;
>> +	mac_addr[5] =3D addr & 0xFF;
>> +	addr >>=3D 8;
>> +	mac_addr[4] =3D addr & 0xFF;
>> +	addr >>=3D 8;
>> +	mac_addr[3] =3D addr & 0x7F;
>> +
>> +	*ll_addr =3D nl_addr_build(AF_LLC, mac_addr, sizeof(mac_addr));
>> +
>> +	return ll_addr =3D=3D NULL ? -EINVAL : 0;
>
>
> If ll_addr is NULL, *ll_addr will not do something useful.

Correct, this should be changed into
return *ll_addr =3D=3D NULL ? -EINVAL : 0

I'll fix it for V2.

>
>> +}
>> +
>> +static int get_mcast_mac_ipv6(struct nl_addr *dst, struct nl_addr *=
*ll_addr)
>> +{
>> +	char mac_addr[6] =3D {0x33, 0x33};
>> +	memcpy(mac_addr + 2, (char *)nl_addr_get_binary_addr(dst) + 12, 4)=
;
>> +
>> +	*ll_addr =3D nl_addr_build(AF_LLC, mac_addr, sizeof(mac_addr));
>> +
>> +	return ll_addr =3D=3D NULL ? -EINVAL : 0;
>
> Same here.
>

Thanks.

>> +}
>> +
>
>> +static int get_link_local_mac_ipv6(struct nl_addr *dst,
>> +				   struct nl_addr **ll_addr)
>> +{
>> +	char mac_addr[6];
>> +
>> +	memcpy(mac_addr + 3, (char *)nl_addr_get_binary_addr(dst) + 13, 3)=
;
>> +	memcpy(mac_addr, (char *)nl_addr_get_binary_addr(dst) + 8, 3);
>> +	mac_addr[0] ^=3D 2;
>> +
>> +	*ll_addr =3D nl_addr_build(AF_LLC, mac_addr, sizeof(mac_addr));
>> +	return ll_addr =3D=3D NULL ? -EINVAL : 0;
>> +}
>> +
>> +const struct encoded_l3_addr {
>> +	short family;
>> +	uint8_t prefix_bits;
>> +	const char data[16];
>> +	int (*getter)(struct nl_addr *dst, struct nl_addr **ll_addr);
>> +} encoded_prefixes[] =3D {
>> +	{.family =3D AF_INET,
>> +	 .prefix_bits =3D 4,
>> +	 .data =3D {0xe},
>> +	 .getter =3D &get_mcast_mac_ipv4},
>> +	{.family =3D AF_INET6,
>> +	 .prefix_bits =3D 8,
>> +	 .data =3D {0xff},
>> +	 .getter =3D &get_mcast_mac_ipv6},
>> +	{.family =3D AF_INET6,
>> +	 .prefix_bits =3D 64,
>> +	 .data =3D {0xfe, 0x80},
>> +	 .getter =3D get_link_local_mac_ipv6},
>> +};
>> +
>> +static int handle_encoded_mac(struct nl_addr *dst, struct nl_addr *=
*ll_addr)
>> +{
>> +	uint32_t family =3D nl_addr_get_family(dst);
>> +	struct nl_addr *prefix =3D NULL;
>> +	int i;
>> +	int ret =3D 1;
>> +
>> +	for (i =3D 0;
>> +	     i < sizeof(encoded_prefixes)/sizeof(encoded_prefixes[0]) &&
>> +	     ret; nl_addr_destroy(prefix), prefix =3D NULL, i++) {
>> +		if (encoded_prefixes[i].family !=3D family)
>> +			continue;
>> +
>> +		prefix =3D nl_addr_build(
>> +				family,
>> +				(void *)encoded_prefixes[i].data,
>> +				MAX(encoded_prefixes[i].prefix_bits/8 +
>> +				    !!(encoded_prefixes[i].prefix_bits % 8),
>> +				    sizeof(encoded_prefixes[i].data)));
>> +
>> +		if (NULL =3D=3D prefix)
>> +			return -ENOMEM;
>> +
>> +		nl_addr_set_prefixlen(prefix,
>> +				      encoded_prefixes[i].prefix_bits);
>> +
>> +		if (nl_addr_cmp_prefix(dst, prefix))
>> +			continue;
>> +
>> +		ret =3D encoded_prefixes[i].getter(dst, ll_addr);
>> +	}
>> +
>> +	return ret;
>> +}
>> +
>> +static void get_route_cb_parser(struct nl_object *obj, void *arg)
>> +{
>> +	struct get_neigh_handler *neigh_handler =3D
>> +		(struct get_neigh_handler *)arg;
>> +
>> +	struct rtnl_route *route =3D (struct rtnl_route *)obj;
>> +	struct nl_addr *gateway =3D rtnl_route_get_gateway(route);
>> +	struct nl_addr *src =3D rtnl_route_get_pref_src(route);
>> +	int oif =3D rtnl_route_get_oif(route);
>> +	int type =3D rtnl_route_get_type(route);
>> +	struct rtnl_link *link;
>> +
>> +	if (gateway) {
>> +		nl_addr_destroy(neigh_handler->dst);
>> +		neigh_handler->dst =3D nl_addr_clone(gateway);
>> +		print_dbg("Found gateway\n");
>> +	}
>> +
>> +	if (RTN_BLACKHOLE =3D=3D type ||
>> +	    RTN_UNREACHABLE =3D=3D type ||
>> +	    RTN_PROHIBIT =3D=3D type ||
>> +	    RTN_THROW =3D=3D type) {
>> +		print_err("Destination unrechable (type %d)\n", type);
>> +		goto err;
>> +	}
>> +
>> +	if (!neigh_handler->src && src)
>> +		neigh_handler->src =3D nl_addr_clone(src);
>> +
>> +	if (neigh_handler->oif < 0 && oif > 0)
>> +		neigh_handler->oif =3D oif;
>> +
>> +	/* Link Local */
>> +	if (RTN_LOCAL =3D=3D type) {
>> +		struct nl_addr *lladdr;
>> +
>> +		link =3D rtnl_link_get(neigh_handler->link_cache,
>> +				     neigh_handler->oif);
>> +
>> +		if (NULL =3D=3D link)
>> +			goto err;
>> +
>> +		lladdr =3D rtnl_link_get_addr(link);
>> +
>> +		if (NULL =3D=3D lladdr)
>> +			goto err_link;
>> +
>> +		neigh_handler->found_ll_addr =3D nl_addr_clone(lladdr);
>> +		rtnl_link_put(link);
>> +	} else {
>> +		if (!handle_encoded_mac(
>> +				neigh_handler->dst,
>> +				&neigh_handler->found_ll_addr))
>> +			print_address(stderr, "calculated address %s\n",
>> +				      neigh_handler->found_ll_addr);
>> +	}
>> +
>> +	print_address(stderr, "Current dst %s\n", neigh_handler->dst);
>> +	return;
>> +
>> +err_link:
>> +	rtnl_link_put(link);
>> +err:
>> +	if (neigh_handler->src) {
>> +		nl_addr_destroy(neigh_handler->src);
>> +		neigh_handler->src =3D NULL;
>> +	}
>> +}
>> +
>> +static int get_route_cb(struct nl_msg *msg, void *arg)
>> +{
>> +	struct get_neigh_handler *neigh_handler =3D
>> +		(struct get_neigh_handler *)arg;
>> +	int err;
>> +
>> +	err =3D nl_msg_parse(msg, &get_route_cb_parser, neigh_handler);
>> +	if (err < 0) {
>> +		print_err("Unable to parse object: %s", nl_geterror());
>> +		return err;
>> +	}
>> +
>> +	if (!neigh_handler->dst || !neigh_handler->src ||
>> +	    neigh_handler->oif <=3D 0) {
>> +		print_err("Missing params\n");
>> +		return -1;
>> +	}
>
> Not sure, but why checking the params after parsing the message ?
> Does it make more sense to check the param first ?
>

Sometimes we could get the required information from the message itself=
=2E
=46or example, it's not mandatory to give a source address at the=20
begining, but after parsing the routing message, our source address has=
=20
to be valid;

>> +
>> +	if (NULL !=3D neigh_handler->found_ll_addr)
>> +		goto found;
>> +
>> +	neigh_handler->found_ll_addr =3D
>> +		process_get_neigh_mac(neigh_handler);
>> +	if (neigh_handler->found_ll_addr)
>> +		print_address(stderr, "Neigh is %s\n",
>> +			      neigh_handler->found_ll_addr);
>> +
>> +found:
>> +	return neigh_handler->found_ll_addr ? 0 : -1;
>> +}
>> +
>> +int neigh_get_oif_from_src(struct get_neigh_handler *neigh_handler)
>> +{
>> +	int oif =3D -ENODEV;
>> +	struct addrinfo *src_info;
>> +
>> +	src_info =3D nl_addr_info(neigh_handler->src);
>> +
>> +	if (NULL =3D=3D src_info) {
>> +		print_err("Unable to get address info %s\n",
>> +			  nl_geterror());
>> +		return oif;
>> +	}
>> +
>> +	oif =3D get_ifindex(src_info->ai_addr);
>> +	if (oif <=3D 0)
>> +		goto free;
>> +
>> +	print_dbg("IF index is %d\n", oif);
>> +
>> +free:
>> +	freeaddrinfo(src_info);
>> +	return oif;
>> +}
>> +
>> +static void destroy_zero_based_socket()
>                                          ^
>                                         use void
>
> Without void, the function is taking any parameter,
> disabling prototype check.
>

Ok, thanks. I'll fix that.

>> +{
>> +	if (NULL !=3D zero_socket) {
>> +		print_dbg("destroying zero based socket\n");
>> +		nl_handle_destroy(zero_socket);
>> +	}
>> +}
>> +
>> +static void alloc_zero_based_socket()
>                                        ^
> same here

I'll fix that too.

>
>> +{
>> +	zero_socket =3D nl_handle_alloc();
>
> No check for success ?

If we failed to alloc this socket, we risk using the zero based socket=20
at the same time when other netlink calls are used (this will mostly=20
occur in multi-threaded applications). Do you think it's preferrable to=
=20
report a failure and shutting down the user application because of this=
=20
error?

>
>> +	print_dbg("creating zero based socket\n");
>> +	atexit(&destroy_zero_based_socket);
>> +}
>> +
>> +int neigh_init_resources(struct get_neigh_handler *neigh_handler, i=
nt timeout)
>> +{
>> +	int err;
>> +
>> +	pthread_once(&device_neigh_alloc, &alloc_zero_based_socket);
>> +	neigh_handler->sock =3D nl_handle_alloc();
>> +	if (NULL =3D=3D neigh_handler->sock) {
>> +		print_err("Unable to allocate netlink socket\n");
>> +		return -ENOMEM;
>> +	}
>> +
>> +	err =3D nl_connect(neigh_handler->sock, NETLINK_ROUTE);
>> +	if (err < 0) {
>> +		print_err("Unable to connect netlink socket: %s\n",
>> +			  nl_geterror());
>> +		goto free_socket;
>> +	}
>> +
>> +	neigh_handler->link_cache =3D
>> +		rtnl_link_alloc_cache(neigh_handler->sock);
>> +	if (NULL =3D=3D neigh_handler->link_cache) {
>> +		print_err("Unable to allocate link cache: %s\n", nl_geterror());
>> +		err =3D -ENOMEM;
>> +		goto close_connection;
>> +	}
>> +
>> +	nl_cache_mngt_provide(neigh_handler->link_cache);
>> +
>> +	neigh_handler->route_cache =3D
>> +		rtnl_route_alloc_cache(neigh_handler->sock);
>> +	if (NULL =3D=3D neigh_handler->route_cache) {
>> +		print_err("Unable to allocate route cache: %s\n",
>> +			  nl_geterror());
>> +		err =3D -ENOMEM;
>> +		goto free_link_cache;
>> +	}
>> +
>> +	nl_cache_mngt_provide(neigh_handler->route_cache);
>> +
>> +	neigh_handler->neigh_cache =3D
>> +		rtnl_neigh_alloc_cache(neigh_handler->sock);
>> +	if (NULL =3D=3D neigh_handler->neigh_cache) {
>> +		print_err("Couldn't allocate neigh cache %s\n",
>> +			  nl_geterror());
>> +		err =3D -ENOMEM;
>> +		goto free_route_cache;
>> +	}
>> +
>> +	nl_cache_mngt_provide(neigh_handler->neigh_cache);
>> +
>> +	/* init structure */
>> +	neigh_handler->timeout =3D timeout;
>> +	neigh_handler->oif =3D -1;
>> +	neigh_handler->filter_neigh =3D NULL;
>> +	neigh_handler->found_ll_addr =3D NULL;
>> +	neigh_handler->dst =3D NULL;
>> +	neigh_handler->src =3D NULL;
>> +	neigh_handler->vid =3D -1;
>> +	neigh_handler->neigh_status =3D GET_NEIGH_STATUS_OK;
>> +
>> +	return 0;
>> +
>> +free_route_cache:
>> +	nl_cache_mngt_unprovide(neigh_handler->route_cache);
>> +	nl_cache_free(neigh_handler->route_cache);
>> +	neigh_handler->route_cache =3D NULL;
>> +free_link_cache:
>> +	nl_cache_mngt_unprovide(neigh_handler->link_cache);
>> +	nl_cache_mngt_unprovide(neigh_handler->link_cache);
>> +	neigh_handler->link_cache =3D NULL;
>> +close_connection:
>> +	nl_close(neigh_handler->sock);
>> +free_socket:
>> +	nl_handle_destroy(neigh_handler->sock);
>> +	neigh_handler->sock =3D NULL;
>> +	return err;
>> +}
>> +
>> +
>
> Blank line
>
>> +uint16_t neigh_get_vlan_id_from_dev(struct get_neigh_handler *neigh=
_handler)
>> +{
>> +	struct rtnl_link *link;
>> +	int vid;
>> +
>> +	link =3D rtnl_link_get(neigh_handler->link_cache, neigh_handler->o=
if);
>> +	if (NULL =3D=3D link) {
>> +		print_err("Can't find link in cache\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	vid =3D rtnl_link_vlan_get_id(link);
>> +	rtnl_link_put(link);
>> +	return vid >=3D 0 && vid <=3D 0xfff ? vid : 0xffff;
>> +}
>> +
>> +void neigh_set_vlan_id(struct get_neigh_handler *neigh_handler, uin=
t16_t vid)
>> +{
>> +	if (vid >=3D 0 && vid <=3D 0xfff)
>> +		neigh_handler->vid =3D vid;
>> +}
>> +
>> +int neigh_set_dst(struct get_neigh_handler *neigh_handler,
>> +		  int family, void *buf, size_t size)
>> +{
>> +	neigh_handler->dst =3D nl_addr_build(family, buf, size);
>> +	return NULL =3D=3D neigh_handler->dst;
>> +}
>> +
>> +int neigh_set_src(struct get_neigh_handler *neigh_handler,
>> +		  int family, void *buf, size_t size)
>> +{
>> +	neigh_handler->src =3D nl_addr_build(family, buf, size);
>> +	return NULL =3D=3D neigh_handler->src;
>> +}
>> +
>> +
>
> Blank line
>
>> +void neigh_set_oif(struct get_neigh_handler *neigh_handler, int oif=
)
>> +{
>> +	neigh_handler->oif =3D oif;
>> +}
>> +
>> +int neigh_get_ll(struct get_neigh_handler *neigh_handler, void *add=
r_buff,
>> +		 int addr_size) {
>> +	int neigh_len;
>> +
>> +	if (NULL =3D=3D neigh_handler->found_ll_addr)
>> +		return -EINVAL;
>> +
>> +	 neigh_len =3D nl_addr_get_len(neigh_handler->found_ll_addr);
>> +
>> +	if (neigh_len > addr_size)
>> +		return -EINVAL;
>> +
>> +	memcpy(addr_buff, nl_addr_get_binary_addr(neigh_handler->found_ll_=
addr),
>> +	       neigh_len);
>> +
>> +	return neigh_len;
>> +}
>> +
>> +void neigh_free_resources(struct get_neigh_handler *neigh_handler)
>> +{
>> +	/* Should be released first because it's holding a reference to ds=
t */
>> +	if (NULL !=3D neigh_handler->filter_neigh) {
>> +		rtnl_neigh_put(neigh_handler->filter_neigh);
>> +		neigh_handler->filter_neigh =3D NULL;
>> +	}
>> +
>> +	if (NULL !=3D neigh_handler->src) {
>> +		nl_addr_destroy(neigh_handler->src);
>> +		neigh_handler->src =3D NULL;
>> +	}
>> +
>> +	if (NULL !=3D neigh_handler->dst) {
>> +		nl_addr_destroy(neigh_handler->dst);
>> +		neigh_handler->dst =3D NULL;
>> +	}
>> +
>> +	if (NULL !=3D neigh_handler->found_ll_addr) {
>> +		nl_addr_destroy(neigh_handler->found_ll_addr);
>> +		neigh_handler->found_ll_addr =3D NULL;
>> +	}
>> +
>> +	if (NULL !=3D neigh_handler->neigh_cache) {
>> +		nl_cache_mngt_unprovide(neigh_handler->neigh_cache);
>> +		nl_cache_free(neigh_handler->neigh_cache);
>> +		neigh_handler->neigh_cache =3D NULL;
>> +	}
>> +
>> +	if (NULL !=3D neigh_handler->route_cache) {
>> +		nl_cache_mngt_unprovide(neigh_handler->route_cache);
>> +		nl_cache_free(neigh_handler->route_cache);
>> +		neigh_handler->route_cache =3D NULL;
>> +	}
>> +
>> +	if (NULL !=3D neigh_handler->link_cache) {
>> +		nl_cache_mngt_unprovide(neigh_handler->link_cache);
>> +		nl_cache_free(neigh_handler->link_cache);
>> +		neigh_handler->link_cache =3D NULL;
>> +	}
>> +
>> +	if (NULL !=3D neigh_handler->sock) {
>> +		nl_close(neigh_handler->sock);
>> +		nl_handle_destroy(neigh_handler->sock);
>> +		neigh_handler->sock =3D NULL;
>> +	}
>> +}
>> +
>> +int process_get_neigh(struct get_neigh_handler *neigh_handler)
>> +{
>> +	struct nl_msg *m;
>> +	struct rtmsg rmsg =3D {
>> +		.rtm_family =3D nl_addr_get_family(neigh_handler->dst),
>> +		.rtm_dst_len =3D nl_addr_get_prefixlen(neigh_handler->dst),
>> +	};
>> +	int err;
>> +	int last_status;
>> +
>> +	last_status =3D __sync_fetch_and_or(
>> +			&neigh_handler->neigh_status,
>> +			GET_NEIGH_STATUS_IN_PROCESS);
>> +
>> +	if (last_status !=3D GET_NEIGH_STATUS_OK)
>> +		return -EINPROGRESS;
>> +
>> +	m =3D nlmsg_alloc_simple(RTM_GETROUTE, 0);
>> +
>> +	if (NULL =3D=3D m)
>> +		return -ENOMEM;
>> +
>> +	nlmsg_append(m, &rmsg, sizeof(rmsg), NLMSG_ALIGNTO);
>> +
>> +	nla_put_addr(m, RTA_DST, neigh_handler->dst);
>> +
>> +	if (neigh_handler->oif > 0)
>> +		nla_put_u32(m, RTA_OIF, neigh_handler->oif);
>> +
>> +	err =3D nl_send_auto_complete(neigh_handler->sock, m);
>> +	nlmsg_free(m);
>> +	if (err < 0) {
>> +		print_err("%s", nl_geterror());
>> +		return err;
>> +	}
>> +
>> +	nl_socket_modify_cb(neigh_handler->sock, NL_CB_VALID,
>> +			    NL_CB_CUSTOM, &get_route_cb, neigh_handler);
>> +
>> +	err =3D nl_recvmsgs_default(neigh_handler->sock);
>> +	if (err < 0) {
>> +		print_err("%s", nl_geterror());
>> +		__sync_fetch_and_or(
>> +			&neigh_handler->neigh_status,
>> +			GET_NEIGH_STATUS_ERR);
>> +	}
>> +
>> +	__sync_fetch_and_and(
>> +		&neigh_handler->neigh_status,
>> +		~GET_NEIGH_STATUS_IN_PROCESS);
>> +
>> +	return err;
>> +}
>> diff --git a/src/neigh.h b/src/neigh.h
>> new file mode 100644
>> index 0000000..443b870
>> --- /dev/null
>> +++ b/src/neigh.h
>> @@ -0,0 +1,42 @@
>> +#ifndef _GET_NEIGH_
>> +#define _GET_NEIGH_
>> +
>
> it needs
>
> #include <stddef.h> /* for size_t */
> #include <stdint.h> /* for uint16_t, int32_t, uint64_t */
>

Correct - thanks.

>> +#include <netlink/object.h>
>> +
>> +enum get_neigh_status {
>> +	GET_NEIGH_STATUS_OK =3D 0,
>> +	GET_NEIGH_STATUS_IN_PROCESS =3D 1 << 0,
>> +	GET_NEIGH_STATUS_ERR =3D 1 << 1,
>> +};
>> +
>> +struct get_neigh_handler {
>> +	struct nl_handle *sock;
>> +	struct nl_cache *link_cache;
>> +	struct nl_cache	*neigh_cache;
>> +	struct nl_cache *route_cache;
>> +	int32_t oif;
>> +	int vid;
>> +	struct rtnl_neigh *filter_neigh;
>> +	struct nl_addr *found_ll_addr;
>> +	struct nl_addr *dst;
>> +	struct nl_addr *src;
>> +	enum get_neigh_status neigh_status;
>> +	uint64_t timeout;
>> +};
>> +
>> +int process_get_neigh(struct get_neigh_handler *neigh_handler);
>> +void neigh_free_resources(struct get_neigh_handler *neigh_handler);
>> +void neigh_set_vlan_id(struct get_neigh_handler *neigh_handler, uin=
t16_t vid);
>> +uint16_t neigh_get_vlan_id_from_dev(struct get_neigh_handler *neigh=
_handler);
>> +int neigh_init_resources(struct get_neigh_handler *neigh_handler, i=
nt timeout);
>> +
>> +int neigh_set_src(struct get_neigh_handler *neigh_handler,
>> +		  int family, void *buf, size_t size);
>> +void neigh_set_oif(struct get_neigh_handler *neigh_handler, int oif=
);
>> +int neigh_set_dst(struct get_neigh_handler *neigh_handler,
>> +		  int family, void *buf, size_t size);
>> +int neigh_get_oif_from_src(struct get_neigh_handler *neigh_handler)=
;
>> +int neigh_get_ll(struct get_neigh_handler *neigh_handler, void *add=
r_buf,
>> +		 int addr_size);
>> +
>> +#endif
>> diff --git a/src/verbs.c b/src/verbs.c
>> index a6aae70..219e503 100644
>> --- a/src/verbs.c
>> +++ b/src/verbs.c
>> @@ -43,6 +43,9 @@
>>   #include <string.h>
>>
>>   #include "ibverbs.h"
>> +#ifndef NRESOLVE_NEIGH
>> +#include "neigh.h"
>> +#endif
>>
>>   int ibv_rate_to_mult(enum ibv_rate rate)
>>   {
>> @@ -505,15 +508,168 @@ int __ibv_destroy_qp(struct ibv_qp *qp)
>>   }
>>   default_symver(__ibv_destroy_qp, ibv_destroy_qp);
>>
>> +static inline int ipv6_addr_v4mapped(const struct in6_addr *a)
>> +{
>> +	return ((a->s6_addr32[0] | a->s6_addr32[1]) |
>> +		(a->s6_addr32[2] ^ htonl(0x0000ffff))) =3D=3D 0UL ||
>> +		/* IPv4 encoded multicast addresses */
>> +	       (a->s6_addr32[0]  =3D=3D htonl(0xff0e0000) &&
>> +		((a->s6_addr32[1] |
>> +		  (a->s6_addr32[2] ^ htonl(0x0000ffff))) =3D=3D 0UL));
>> +}
>> +
>> +
>> +struct peer_address {
>> +	void *address;
>> +	uint32_t size;
>> +};
>> +
>> +static inline int create_peer_from_gid(int family, void *raw_gid,
>> +				       struct peer_address *peer_address)
>> +{
>> +	switch (family) {
>> +	case AF_INET:
>> +		peer_address->address =3D raw_gid + 12;
>> +		peer_address->size =3D 4;
>> +		break;
>> +	case AF_INET6:
>> +		peer_address->address =3D raw_gid;
>> +		peer_address->size =3D 16;
>> +		break;
>> +	default:
>> +		return -1;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +#define ETHERNET_LL_SIZE 6
>> +#define NEIGH_GET_DEFAULT_TIMEOUT_MS 3000
>>   struct ibv_ah *__ibv_create_ah(struct ibv_pd *pd, struct ibv_ah_at=
tr *attr)
>>   {
>> -	struct ibv_ah *ah =3D pd->context->ops.create_ah(pd, attr);
>> +	int err;
>> +	struct ibv_ah *ah =3D NULL;
>> +#ifndef NRESOLVE_NEIGH
>> +	struct ibv_port_attr port_attr;
>> +	int dst_family;
>> +	int src_family;
>> +	int oif;
>> +	struct get_neigh_handler neigh_handler;
>> +	union ibv_gid sgid;
>> +	struct ibv_ah_attr_ex attr_ex;
>> +	char ethernet_ll[ETHERNET_LL_SIZE];
>> +	struct verbs_context *vctx =3D verbs_get_ctx_op(pd->context,
>> +						      drv_ibv_create_ah_ex);
>> +	struct peer_address src;
>> +	struct peer_address dst;
>> +
>> +	if (!vctx) {
>> +#endif
>> +		ah =3D pd->context->ops.create_ah(pd, attr);
>> +#ifndef NRESOLVE_NEIGH
>> +		goto return_ah;
>> +	}
>> +
>> +	err =3D ibv_query_port(pd->context, attr->port_num, &port_attr);
>> +
>> +	if (err) {
>> +		fprintf(stderr, PFX "ibv_create_ah failed to query port.\n");
>> +		return NULL;
>> +	}
>> +
>> +	if (IBV_LINK_LAYER_ETHERNET !=3D port_attr.link_layer ||
>> +	    !(port_attr.port_cap_flags & IBV_PORT_IP_BASED_GIDS)) {
>> +		ah =3D pd->context->ops.create_ah(pd, attr);
>> +		goto return_ah;
>> +	}
>> +
>> +	memcpy(&attr_ex, attr, sizeof(*attr));
>> +	memset((void *)&attr_ex + sizeof(*attr), 0,
>> +	       sizeof(attr_ex) - sizeof(*attr));
>> +
>> +	err =3D ibv_query_gid(pd->context, attr->port_num,
>> +			    attr->grh.sgid_index, &sgid);
>> +
>> +	if (err) {
>> +		fprintf(stderr, PFX "ibv_create_ah failed to query sgid.\n");
>> +		return NULL;
>> +	}
>> +
>> +	if (neigh_init_resources(&neigh_handler, NEIGH_GET_DEFAULT_TIMEOUT=
_MS))
>> +		return NULL;
>> +
>> +	dst_family =3D ipv6_addr_v4mapped((struct in6_addr *)attr->grh.dgi=
d.raw) ?
>> +			AF_INET : AF_INET6;
>> +	src_family =3D ipv6_addr_v4mapped((struct in6_addr *)sgid.raw) ?
>> +			AF_INET : AF_INET6;
>> +
>> +	if (create_peer_from_gid(dst_family, attr->grh.dgid.raw, &dst)) {
>> +		fprintf(stderr, PFX
>> +			"ibv_create_ah failed to create dst peer\n");
>> +		goto free_resources;
>> +	}
>> +	if (create_peer_from_gid(src_family, &sgid.raw, &src)) {
>> +		fprintf(stderr, PFX
>> +			"ibv_create_ah failed to create src peer\n");
>> +		goto free_resources;
>> +	}
>> +	if (neigh_set_dst(&neigh_handler, dst_family, dst.address,
>> +			  dst.size)) {
>> +		fprintf(stderr, PFX
>> +			"ibv_create_ah failed to create dst addr\n");
>> +		goto free_resources;
>> +	}
>> +
>> +	if (neigh_set_src(&neigh_handler, src_family, src.address,
>> +			  src.size)) {
>> +		fprintf(stderr, PFX
>> +			"ibv_create_ah failed to create src addr\n");
>> +		goto free_resources;
>> +	}
>> +
>> +	oif =3D neigh_get_oif_from_src(&neigh_handler);
>> +
>> +	if (oif > 0) {
>> +		neigh_set_oif(&neigh_handler, oif);
>> +	} else {
>> +		fprintf(stderr, PFX "ibv_create_ah failed to get output IF\n");
>> +		goto free_resources;
>> +	}
>> +
>> +
>
> Blank line
>
>> +	/* blocking call */
>> +	if (process_get_neigh(&neigh_handler))
>> +		fprintf(stderr, "error in neigh resolution process\n");
>
> Error is reported without prefix, and without consequences: no exit ?
>

Actually, we'll fail when trying to get the MAC address, but you're=20
correct that it's better to fix it here.

>> +
>> +	attr_ex.vid =3D neigh_get_vlan_id_from_dev(&neigh_handler);
>> +
>> +	if (attr_ex.vid <=3D 0xfff) {
>> +		neigh_set_vlan_id(&neigh_handler, attr_ex.vid);
>> +		attr_ex.comp_mask |=3D IBV_AH_ATTR_EX_VID;
>> +	}
>> +	/* We are using only ethernet here */
>> +	attr_ex.ll_address.len =3D neigh_get_ll(&neigh_handler, ethernet_l=
l,
>> +					      sizeof(ethernet_ll));
>>
>> +	if (attr_ex.ll_address.len <=3D 0)
>> +		goto free_resources;
>> +
>> +	attr_ex.comp_mask |=3D IBV_AH_ATTR_EX_LL;
>> +	attr_ex.ll_address.type =3D LL_ADDRESS_ETH;
>> +	attr_ex.ll_address.address =3D ethernet_ll;
>> +
>> +
>> +	ah =3D vctx->drv_ibv_create_ah_ex(pd, &attr_ex);
>> +
>> +free_resources:
>> +	neigh_free_resources(&neigh_handler);
>> +
>> +return_ah:
>> +#endif
>>   	if (ah) {
>>   		ah->context =3D pd->context;
>>   		ah->pd      =3D pd;
>>   	}
>> -
>>   	return ah;
>>   }
>>   default_symver(__ibv_create_ah, ibv_create_ah);
>
> I'm concerned about the resources opened to resolve the neighbor
> address: close-on-exec should set by default on opened socket,
> either in call to socket() and on resources opened by libnl.
>
> I've understand that resources are allocated on call to ibv_create_ah=
()
> and released when the function returns.
> But is there use case where a multithreaded program could call
> ibv_create_ah() in parallel ? And what about a program calling multip=
le
> times ibv_create_ah() ? I think both would benefit from keeping opene=
d
> the netlink socket.
> Should wait for real world usage figure before addressing this issue.
>
> Regards.
>

Caching should mostly improve ibv_create_ah performance. There's no=20
doubt in that. However, keeping libnl resources open after this stage=20
could degrade performance (as we listen to netlink events). I think tha=
t=20
as you suggested, we should wait for real world usage figures and we=20
could provide caching if needed in the future.

Regards.



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

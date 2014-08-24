From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH libibverbs V5 2/2] Use neighbour lookup for RoCE UD QPs
 Eth L2 resolution
Date: Sun, 24 Aug 2014 16:51:09 +0300
Message-ID: <53F9EDCD.9060105@mellanox.com>
References: <1408517381-17523-1-git-send-email-matanb@mellanox.com> <1408517381-17523-3-git-send-email-matanb@mellanox.com> <20140820170142.GC12605@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140820170142.GC12605-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 20/8/2014 8:01 PM, Jason Gunthorpe wrote:
> On Wed, Aug 20, 2014 at 09:49:41AM +0300, Matan Barak wrote:
>
>> +#define MAX(a, b) ((a) > (b) ? (a) : (b))
>> +#define MIN(a, b) ((a) < (b) ? (a) : (b))
>> +#define print_hdr PFX "resolver: "
>> +#define print_err(...) fprintf(stderr, print_hdr __VA_ARGS__)
>
> System libraries should really not be printing things on error
> paths...

Ok, I'll only set the errno value.

>
>> +static int set_link_port(union sktaddr *s, int port, int oif)
>> +{
>> +	switch (s->s.sa_family) {
>> +	case AF_INET:
>> +		s->s4.sin_port = port;
>> +		break;
>> +	case AF_INET6:
>> +		s->s6.sin6_port = port;
>> +		s->s6.sin6_scope_id = oif;
>
> Does flowlabel get initialized someplace?
>

Do you refer to flowinfo?
If so, it isn't initialized, but should be.
0 should be good enough, so I'll memset the whole struct.

>> +static int cmp_address(const struct sockaddr *s1,
>> +		       const struct sockaddr *s2) {
>
> 'cmp' functions that only test equality should return bool for
> clarity. Otherwise people will assume the usual -1,0,1 return style,
> which this does not implement.
>

Ok, will be fixed.

>> +	if (s1->sa_family != s2->sa_family)
>> +		return s1->sa_family ^ s2->sa_family;
>
> Ditch the ^ for compare, pointless.
>

Ok

>> +static struct nl_addr *get_neigh_mac(struct get_neigh_handler *neigh_handler)
>> +{
>> +	struct rtnl_neigh *neigh;
>> +	struct nl_addr *ll_addr = NULL;
>> +
>> +	/* future optimization - if link local address - parse address and
>> +	 * return mac */
>
> What does this comment refer to? MACs should never be parsed out of
> IPv6 addresses.
>

GID0 should always be valid, even if no IPv4 and IPv6 are configured.
IPv6 link-local and multicast addresses should be parsed from the IPv6 
address.

>> +	sock_fd = socket(addr_dst->sktaddr.s.sa_family,
>> +			 SOCK_DGRAM | SOCK_CLOEXEC, 0);
>> +	if (sock_fd == -1)
>> +		return errno ? -errno : -1;
>
> If socket fails then errno is always set, not sure the safety test is
> necessary, if it is, then -1 is not the right result, it should be
> -EINVAL or something.
>
>> +	err = bind(sock_fd, &addr_src.sktaddr.s, addr_src.len);
>> +	if (err) {
>> +		int bind_err = -errno;
>> +		print_err("Couldn't bind socket\n");
>> +		close(sock_fd);
>> +		return bind_err ?: err;
>
> bind does not return an errno code, so it should never be the return
> result.
>

Ok

>> +	timer_fd = timerfd_create(CLOCK_MONOTONIC, TFD_NONBLOCK | TFD_CLOEXEC);
>> +	if (-1 == timer_fd) {
>> +		print_err("Couldn't create timer\n");
>> +		return timer_fd;
>> +	}
>
> The use of timerfd will impact the minimum OS version, have you
> checked this is OK? Does RHEL5 still work?
>

It was added in linux v2.6.25. I think that an API that's more than 6.5 
years old is valid.


>> +	while (1) {
>> +		FD_ZERO(&fdset);
>> +		FD_SET(fd, &fdset);
>> +		FD_SET(timer_fd, &fdset);
>> +
>> +		/* wait for an incoming message on the netlink socket */
>> +		ret = select(nfds, &fdset, NULL, NULL, NULL);
>
> poll is a better choice here, it would also be fairly simple to remove
> timerfd by using the timeout arg.
>

The purpose is to have a timeout on the whole process and not per loop.

>> +					if (sendto(sock_fd, buff, sizeof(buff),
>> +						   0, &addr_dst.sktaddr.s,
>> +						   addr_dst.len) < 0)
>> +						print_err("Failed to send "
>> +							  "packet while waiting"
>> +							  " for
>> events\n");
>
> If the earlier sendto needs to be protected by a loop looking at
> EADDRNOTAVAIL then so does this one.
>

If the sendto failed, we would just retry it in the next loop.

> I'm also not sure all this looping and complexity is needed... Why
> override the kernel timers for ND?
>
> I would think you'd check the ND table, if there is no good entry then
> do the send, and then watch the ND table for a FAILED/REACHABLE
> result. The kernel timers will always transition through INCOMPLETE to
> one of those terminal states.
>
> No need for more timers and retry and things, the kernel already retried.
>

Watching just for the ND event is problematic.
If the user sent a packet just after we looked at the ND and before we 
waited for an event, we would probably just fail without finding any 
neighbor. Regarding the retries, because we use UD and switches could
sometimes take a few seconds to learn the network, I chose to do a few 
reties before giving up.


>> +static int get_mcast_mac_ipv6(struct nl_addr *dst, struct nl_addr **ll_addr)
>> +{
>> +	char mac_addr[6] = {0x33, 0x33};
>> +	memcpy(mac_addr + 2, (char *)nl_addr_get_binary_addr(dst) + 12, 4);
>
> (char *) should be (uint8_t *), you are not working with a string
> here. Similarly for nearly all char casts. Proper use of const
> throughout would be nice too..
>
>> +const struct encoded_l3_addr {
>
> Missing static
>

Ok

>> +int nl_addr_cmp_prefix_msb(void *addr1, int len1, void *addr2, int len2)
>> +{
>
> Missing static
>

Right

>> +	struct rtnl_nexthop *nh = rtnl_route_nexthop_n(route, 0);
>> +	if (!nh)
>> +		print_err("Out of memory\n");
>> +	gateway = rtnl_route_nh_get_gateway(nh);
>
> And then crash?
>

Corret, I'll add a return when an error is detected.

>> +err_link:
>> +	rtnl_link_put(link);
>> +err:
>> +	if (neigh_handler->src) {
>> +#ifdef HAVE_LIBNL1
>> +		nl_addr_put(neigh_handler->src);
>
> Should this be nl_addr_destroy ?
>

Only if it was allocated by this function - should be fixed.

> Can you do a better job with these ifdefs? I think you can get away
> with a nl1_compat.h which has simple wrapper things like this:
>
> static inline void emulate_nl_addr_put(x) {return nl_addr_destroy(x);}
> #define nl_addr_put(x) emulate_nl_addr_put(x)
>

Ok

> And purge the ifdefery from the main source.
>> +
>> +	last_status = __sync_fetch_and_or(
>> +			&neigh_handler->neigh_status,
>> +			GET_NEIGH_STATUS_IN_PROCESS);
>
> Is there a thread running around in here someplace?
>
> Callina raw gcc intrinsic like this should really be avoided,
> especially since this isn't a performance path. Use pthreads.
>

The current implementation is synchronous.
For the usage of the neigh.c entry function, those guards could be deleted.

>> +static inline int ipv6_addr_v4mapped(const struct in6_addr *a)
>> +{
>> +	return ((a->s6_addr32[0] | a->s6_addr32[1]) |
>> +		(a->s6_addr32[2] ^ htonl(0x0000ffff))) == 0UL ||
>> +		/* IPv4 encoded multicast addresses */
>> +	       (a->s6_addr32[0]  == htonl(0xff0e0000) &&
>> +		((a->s6_addr32[1] |
>> +		  (a->s6_addr32[2] ^ htonl(0x0000ffff))) == 0UL));
>> +}
>
> Don't duplicate IN6_IS_ADDR_V4MAPPED
>

I wasn't aware the macro exists, I'll use it.

>> +	if (err) {
>> +		fprintf(stderr, PFX "ibv_create_ah failed to query
>> sgid.\n");
>
> Again, system libraries should not be printing on error, use errno
> properly.
>

I'll remove all prints.

>> +#else
>> +	return -ENOIMPL;
>
> Is that a typo of ENOSYS?
>
> Be sure you have tested compiling with each and every variation of the
> #ifdefs added.
>
> Jason
>

Thanks for the comments and the thorough code review Jason.
I'll send a fixed version.

Matan
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

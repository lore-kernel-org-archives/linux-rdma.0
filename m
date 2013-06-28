From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v2 15/16 ibacm] Add support for preloading IPv4 and IPv6
 ACM caches
Date: Fri, 28 Jun 2013 13:57:06 -0400
Message-ID: <51CDCE72.7030101@dev.mellanox.co.il>
References: <51CC8F18.3000509@dev.mellanox.co.il> <1828884A29C6694DAF28B7E6B8A823736FD378C2@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A823736FD378C2-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 6/28/2013 1:50 PM, Hefty, Sean wrote:
>> +static void acm_parse_hosts_file(struct acm_ep *ep)
>> +{
>> +	FILE *f;
>> +	char s[120];
>> +	char addr[INET6_ADDRSTRLEN], gid[INET6_ADDRSTRLEN];
>> +	uint8_t name[ACM_MAX_ADDRESS];
>> +	struct in6_addr ip_addr, ib_addr;
>> +	struct acm_dest *dest, *new_dest;
>> +	uint8_t addr_type;
>> +
>> +	if (!(f = fopen(hosts_file, "r"))) {
>> +		acm_log(0, "ERROR - couldn't open %s\n", hosts_file);
>> +		return;
>> +        }
>> +
>> +	while (fgets(s, sizeof s, f)) {
>> +		if (s[0] == '#')
>> +			continue;
>> +
>> +		if (sscanf(s, "%46s%46s", addr, gid) != 2)
>> +			continue;
>> +
>> +		acm_log(2, "%s", s);
>> +		if (inet_pton(AF_INET6, gid, &ib_addr) <= 0) {
>> +			acm_log(0, "ERROR - %s is not IB GID\n", gid);
>> +			continue;
>> +		}
>> +		if (inet_pton(AF_INET, addr, &ip_addr) > 0)
>> +			addr_type = ACM_ADDRESS_IP;
>> +		else if (inet_pton(AF_INET6, addr, &ip_addr) > 0)
>> +			addr_type = ACM_ADDRESS_IP6;
>> +		else {
>> +			acm_log(0, "ERROR - %s is not IP address\n", addr);
>> +			continue;
>> +		}
>> +
>> +		memset(name, 0, ACM_MAX_ADDRESS);
>> +		memcpy(name, &ib_addr, sizeof(ib_addr));
>> +		dest = acm_get_dest(ep, ACM_ADDRESS_GID, name);
>> +		if (!dest) {
>> +			acm_log(0, "ERROR - IB GID %s not found in cache\n", gid);
>> +			continue;
>> +		}
> 
> I just noticed that there's no matching acm_put_dest() to this call.  I'll fix this up.
> 
>> +
>> +		memset(name, 0, ACM_MAX_ADDRESS);
>> +		if (addr_type == ACM_ADDRESS_IP)
>> +			memcpy(name, &ip_addr, 4);
>> +		else
>> +			memcpy(name, &ip_addr, sizeof(ip_addr));
>> +		new_dest = acm_acquire_dest(ep, addr_type, name);
>> +		if (!new_dest) {
>> +			acm_log(0, "ERROR - unable to create dest %s\n", addr);
>> +			continue;
>> +		}
>> +		new_dest->path = dest->path;
>> +		new_dest->remote_qpn = dest->remote_qpn;
>> +		new_dest->addr_timeout = dest->addr_timeout;
>> +		new_dest->route_timeout = dest->route_timeout;
>> +		new_dest->state = dest->state;
> 
> Rather than skipping addresses that we can't lookup the GID for, I *think* it would work to simply add new_dest, but set the state to ACM_ADDR_RESOLVED.
> 
> I can quickly throw a patch together to this effect, but won't be able to test it immediately.

I can test it too.

-- Hal

> 
> - Sean
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

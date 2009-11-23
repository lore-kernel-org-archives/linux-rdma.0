From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 9/9] ib/addr: fix ipv6 routing lookup
Date: Mon, 23 Nov 2009 14:07:09 -0800
Message-ID: <913F7AE25239487A9AF368E608F30A34@amr.corp.intel.com>
References: <2449CF17D7E94FCBA643A743473246A5@amr.corp.intel.com> <20091123194847.GL6188@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091123194847.GL6188-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

>> +static int cma_check_linklocal(struct rdma_dev_addr *dev_addr,
>> +			       struct sockaddr *addr)
>> +{
>> +	struct sockaddr_in6 *sin6;
>> +
>> +	if (addr->sa_family != AF_INET6)
>> +		return 0;
>> +
>> +	sin6 = (struct sockaddr_in6 *) addr;
>> +	if ((ipv6_addr_type(&sin6->sin6_addr) & IPV6_ADDR_LINKLOCAL) &&
>> +	    !sin6->sin6_scope_id)
>> +			return -EINVAL;
>> +
>> +	dev_addr->bound_dev_if = sin6->sin6_scope_id;
>> +	return 0;
>> +}
>
>There is something missing here to match the TCP sin6_scope_id
>semantics..
>
>I think what you have is OK for the non-error cases, but the
>rdma_resolve_addr path does need to check that an input sin6_scope_id
>is either 0 or matches bound_dev_if and return EINVAL.

cma_check_linklocal() is only called from rdma_bind_addr(), and is the only
place where bound_dev_if is set in cma.c.  So this if statement:

>                if (dev_addr->bound_dev_if &&
>                    dev_addr->bound_dev_if != addr6->sin6_scope_id)
>                        return -EINVAL;

would always be false.  bound_dev_if should be 0.

>The main missing test from the new version is:
>                if (dev_addr->bound_dev_if &&
>                    dev_addr->bound_dev_if != addr6->sin6_scope_id)
>                        return -EINVAL;
>
>Done on the 2nd src and dest address.
>
>Any thoughts on how to fit that in?

A separate check can be added to rdma_resolve_addr if it's really needed, but
I'm not sure that we need to require that the source and destination use the
same device or RDMA port.

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

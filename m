From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Are there are problems using the CMA with IPv6?
Date: Wed, 26 Oct 2011 14:04:47 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E82E4D@ORSMSX101.amr.corp.intel.com>
References: <CALvMawp6xMcBF2Nxswq9WG-w=wXdTsM9Yk2PcWdL=e-s450YkA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALvMawp6xMcBF2Nxswq9WG-w=wXdTsM9Yk2PcWdL=e-s450YkA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Subject: Are there are problems using the CMA with IPv6?

IPv6 should work fine.

> I noticed the following code in the cmatose/rping examples:

but, I can't say whether all of the examples support ipv6.  I believe that they do.

> <snip start>
> static int get_addr(char *dst, struct sockaddr *addr)
> {
>         struct addrinfo *res;
>         int ret;
> 
>         ret = getaddrinfo(dst, NULL, NULL, &res);
>         if (ret) {
>                 printf("getaddrinfo failed - invalid hostname or IP
> address\n");
>                 return ret;
>         }
> 
>         if (res->ai_family == PF_INET)
>                 memcpy(addr, res->ai_addr, sizeof(struct sockaddr_in));
>         else if (res->ai_family == PF_INET6)
>                 memcpy(addr, res->ai_addr, sizeof(struct sockaddr_in6));
>         else
>                 ret = -1;
> 
>         freeaddrinfo(res);
>         return ret;
> }
> <snip end>
> And it noticed that in case of IPv6 there might be overrun on the variable
> addr,
> since sizeof(struct sockaddr) is 16, and in case of IPv6 sizeof (struct
> sockaddr_in6) is 28.

It might overrun, but then the user shouldn't have set ai_family to AF_INET6.  struct sockaddr * should always point to a struct sockaddr_X of the correct size.  If ai_family is AF_INET6, then struct sockaddr * should point to struct sockaddr_in6.  struct sockaddr itself is never used beyond accessing the address family.  Btw, in theory, there's no guarantee that struct sockaddr and struct sockaddr_in are the same size.

>  int rdma_bind_addr(struct rdma_cm_id *id, struct sockaddr *addr);
> 
> which seems to only support IPv4.
> 
> Am i missing something?

It may help to reference the man page for the socket bind call for the use of sockaddr.

- Sean


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

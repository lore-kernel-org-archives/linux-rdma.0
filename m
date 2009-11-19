From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 5/9 v2] ib/addr: verify source and destination address families match
Date: Wed, 18 Nov 2009 17:27:37 -0800
Message-ID: <7F0D72D35EF140058670BF8E228966B8@amr.corp.intel.com>
References: <4329E49DC571489C9F9498770613E42D@amr.corp.intel.com>	<75A0BA738B5E4574AC17BB674109FBB2@amr.corp.intel.com> <adaws1n8h3e.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adaws1n8h3e.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Roland Dreier' <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> > -	if (src_addr)
> > -		memcpy(&req->src_addr, src_addr, ip_addr_size(src_addr));
> > +	if (src_addr->sa_family != dst_addr->sa_family)
> > +		return -EINVAL;
>
>The old code seemed to allow for the possibility of src_addr being
>NULL.  There only seems to be one in-tree caller of rdma_resolve_ip,
>which does pass in a src_addr, but the API definition in the header says
>
> * @src_addr: An optional source address to use in the resolution.  If a
>
>so it seems passing in NULL would be allowed?

I forgot about the header file comments.  (I only though about rdma_resolve_addr
supporting a NULL src_addr.)  I took the check out when I noticed that src_addr
was always coming in non-NULL.  The address itself doesn't need to be set beyond
the address family, so it's still optional in that regard.  (A pretty weak
argument, but it's all I have. :)

I can go either way here - either update the comments in the header file, or
allow passing in NULL.  Do you or does anyone else have a preference?

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

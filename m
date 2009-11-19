From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 5/9 v2] ib/addr: verify source and destination address families match
Date: Wed, 18 Nov 2009 16:59:33 -0800
Message-ID: <adaws1n8h3e.fsf@roland-alpha.cisco.com>
References: <4329E49DC571489C9F9498770613E42D@amr.corp.intel.com>
	<75A0BA738B5E4574AC17BB674109FBB2@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <75A0BA738B5E4574AC17BB674109FBB2-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org> (Sean
	Hefty's message of "Wed, 18 Nov 2009 08:50:09 -0800")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


 > -	if (src_addr)
 > -		memcpy(&req->src_addr, src_addr, ip_addr_size(src_addr));
 > +	if (src_addr->sa_family != dst_addr->sa_family)
 > +		return -EINVAL;
 
The old code seemed to allow for the possibility of src_addr being
NULL.  There only seems to be one in-tree caller of rdma_resolve_ip,
which does pass in a src_addr, but the API definition in the header says

 * @src_addr: An optional source address to use in the resolution.  If a

so it seems passing in NULL would be allowed?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

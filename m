From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-core] librdmacm: Store error code from getaddrinfo
 in errno
Date: Tue, 7 Nov 2017 08:56:02 -0700
Message-ID: <20171107155602.GD21466@ziepe.ca>
References: <20171107095038.7348-1-yuval.shaia@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171107095038.7348-1-yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 07, 2017 at 11:50:38AM +0200, Yuval Shaia wrote:
> +++ b/librdmacm/addrinfo.c
> @@ -227,7 +227,7 @@ static int ucma_getaddrinfo(const char *node, const char *service,
>  		ret = getaddrinfo(node, service, NULL, &ai);
>  	}
>  	if (ret)
> -		return ret;
> +		return ERR(ret);

No, you cannot assign the return value from getaddrinfo directly errno, they
are not the same number space.

> diff --git a/librdmacm/examples/cmatose.c b/librdmacm/examples/cmatose.c
> index b1c9dd13..625849ce 100644
> +++ b/librdmacm/examples/cmatose.c
> @@ -507,7 +507,7 @@ static int run_server(void)
>  
>  	ret = get_rdma_addr(src_addr, dst_addr, port, &hints, &test.rai);
>  	if (ret) {
> -		printf("cmatose: getrdmaaddr error: %s\n", gai_strerror(ret));
> +		printf("cmatose: getrdmaaddr error: %s\n", gai_strerror(errno));

Also nope, gai_strerror does not process errnos.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

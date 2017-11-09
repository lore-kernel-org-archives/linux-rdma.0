From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-core] librdmacm: Print correct error message from
 rdma_getaddrinfo
Date: Thu, 9 Nov 2017 09:02:02 -0700
Message-ID: <20171109160202.GH7063@ziepe.ca>
References: <20171109080424.4900-1-yuval.shaia@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171109080424.4900-1-yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 09, 2017 at 10:04:24AM +0200, Yuval Shaia wrote:

>  	ret = get_rdma_addr(src_addr, dst_addr, port, &hints, &test.rai);
>  	if (ret) {
> -		printf("cmatose: getrdmaaddr error: %s\n", gai_strerror(ret));
> +		printf("cmatose: getrdmaaddr error: %s\n", errno ?
> +		       strerror(errno) : gai_strerror(ret));

No, you have to check for errno == EAI_SYSTEM

You probably also need to patch librdmacm to return EAI_SYSTEM when required.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

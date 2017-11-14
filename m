From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH 1/2] librdmacm: Add support for extended join multicast
 API V2
Date: Tue, 14 Nov 2017 12:25:58 -0700
Message-ID: <20171114192558.GL4263@ziepe.ca>
References: <20171114185720.609975150@linux.com>
 <20171114185739.838757957@linux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171114185739.838757957-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 14, 2017 at 12:57:21PM -0600, Christoph Lameter wrote:
> diff --git a/debian/librdmacm1.symbols b/debian/librdmacm1.symbols
> index 7cec5c6..a7d8085 100644
> +++ b/debian/librdmacm1.symbols
> @@ -31,6 +31,7 @@ librdmacm.so.1 librdmacm1 #MINVER#
>   rdma_get_src_port@RDMACM_1.0 1.0.19
>   rdma_getaddrinfo@RDMACM_1.0 1.0.15
>   rdma_join_multicast@RDMACM_1.0 1.0.15
> + rdma_join_multicast_ex@RDMACM_1.1 1.0.15
>   rdma_leave_multicast@RDMACM_1.0 1.0.15

I'm sorry I missed this in the first look.. Needs to be

 rdma_join_multicast_ex@RDMACM_1.1 16

Ie package version 16, not the really old 1.0.15

Everything else looks fine to me:

Reviewed-by: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH 1/2] librdmacm: Add support for extended join multicast
 API
Date: Mon, 13 Nov 2017 12:23:02 -0700
Message-ID: <20171113192302.GK6918@ziepe.ca>
References: <20171109171609.169281977@linux.com>
 <20171109171618.882248508@linux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171109171618.882248508-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 09, 2017 at 11:16:10AM -0600, Christoph Lameter wrote:

> Index: rdma-core/librdmacm/librdmacm.map
> ===================================================================
> +++ rdma-core/librdmacm/librdmacm.map
> @@ -21,6 +21,7 @@ RDMACM_1.0 {
>  		rdma_get_src_port;
>  		rdma_get_dst_port;
>  		rdma_join_multicast;
> +		rdma_join_multicast_ex;

This is a mistake. Each symbol should appear exactly once in the map
file, the correct location is below.

>  		rdma_leave_multicast;
>  		rdma_get_devices;
>  		rdma_free_devices;
> @@ -71,3 +72,9 @@ RDMACM_1.0 {
>  		rdma_create_qp_ex;
>  	local: *;
>  };
> +
> +RDMACM_1.1 {
> +	global:
> +		rdma_join_multicast_ex;
> +	local: *;

Same commment for local: *; that should appear only once, above.

> +} RDMACM_1.0;

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

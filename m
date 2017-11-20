From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-core 1/2] libhns: Make the provider sparse clean
Date: Mon, 20 Nov 2017 11:52:32 -0700
Message-ID: <20171120185232.GF29075@ziepe.ca>
References: <1511000496-181604-1-git-send-email-oulijun@huawei.com>
 <1511000496-181604-2-git-send-email-oulijun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1511000496-181604-2-git-send-email-oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sat, Nov 18, 2017 at 06:21:35PM +0800, Lijun Ou wrote:

>  struct hns_roce_v2_cqe {
> -	unsigned int	byte_4;
> -	unsigned int	rkey_immtdata;
> -	unsigned int	byte_12;
> -	unsigned int	byte_16;
> -	unsigned int	byte_cnt;
> -	unsigned int	smac;
> -	unsigned int	byte_28;
> -	unsigned int	byte_32;
> +	__le32	byte_4;
> +	union {
> +		__le32	rkey;
> +		__be32	immtdata;
> +	};

Yes, that looks exactly right.

Reviewed-by: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

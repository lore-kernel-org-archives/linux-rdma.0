From: Santosh Shilimkar <santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] RDS: null pointer dereference in rds_atomic_free_op
Date: Wed, 3 Jan 2018 13:19:27 -0800
Message-ID: <0a3272a7-035b-edc8-c01d-79bffefb70a3@oracle.com>
References: <5a4d45ce.8b8a1c0a.1d072.e5e1@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5a4d45ce.8b8a1c0a.1d072.e5e1-ATjtLOhZ0NVl57MIdRCFDg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: simo.ghannam-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, rds-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 1/3/2018 1:06 PM, simo.ghannam-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> From: Mohamed Ghannam <simo.ghannam-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> set rm->atomic.op_active to 0 when rds_pin_pages() fails
> or the user supplied address is invalid,
> this prevents a NULL pointer usage in rds_atomic_free_op()
> 
> Signed-off-by: Mohamed Ghannam <simo.ghannam-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
Good catch !!

Acked-by: Santosh Shilimkar <santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

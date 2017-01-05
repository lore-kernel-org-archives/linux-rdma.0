From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH rdma-next] IB/cma: Allow port reuse for rdma_id
Date: Thu, 5 Jan 2017 18:40:04 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB0D7F68@ORSMSX109.amr.corp.intel.com>
References: <20170105141636.23284-1-leon@kernel.org>
 <20170105141636.23284-2-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170105141636.23284-2-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> When allocating a port number for binding to a rdma_id, assuming the
> allocation is not for a specific port, the rule is to allow only ports
> that were not in use before by any other rdma_id.
> 
> This condition is too strong to achieve the goal of a unique 5 tuple
> rdma_id. Instead, we can compare current rdma_id with other rdma_id for
> difference in one of destination port, source address and destination
> address to allow port reuse.
> 
> Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Acked-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

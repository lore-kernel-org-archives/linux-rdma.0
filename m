From: "Weiny, Ira K." <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH] Return EPROTONOSUPPORT when an RDMA device lacks QP0
Date: Fri, 20 May 2011 16:41:13 -0700
Message-ID: <16703214-FB50-41F5-BF8D-E6AF18875D20@llnl.gov>
References: <E280C3CC-BD50-4383-BE33-FCC31C72D3F0@llnl.gov> <1828884A29C6694DAF28B7E6B8A82373010745@ORSMSX101.amr.corp.intel.com> <8D19CC19-B4FD-4338-9267-9C1BC32A6BAE@llnl.gov> <1828884A29C6694DAF28B7E6B8A8237301085B@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237301085B-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On May 20, 2011, at 4:23 PM, Hefty, Sean wrote:

>>> 	mad_agent_priv->agent.mr = ib_get_dma_mr(port_priv->qp_info[qpn].qp-
>>> pd,
>>> 						 IB_ACCESS_LOCAL_WRITE);
>>> 
>>> in which case it may be safer to check for the NULL pointer.  Can you
>> confirm if this was the spot?
>> 
>> Yes it was that spot.  I did think of that today after I sent the patch.
>> 
>> Do you think it would be safer just to check for both pointers QP0 and 1
>> (depending on the registration)?
> 
> Yes, it seems safer and easier to maintain if we just validated the pointer.

I will rework the patch.

Thanks,
Ira

> 
> - Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

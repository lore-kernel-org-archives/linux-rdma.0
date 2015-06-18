From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH RFC] IB: Add rdma_cap_ib_switch helper and use where appropriate
Date: Thu, 18 Jun 2015 16:40:15 -0400
Message-ID: <55832CAF.4000201@dev.mellanox.co.il>
References: <55832793.1080105@dev.mellanox.co.il> <1828884A29C6694DAF28B7E6B8A82373A8FF6FAD@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A8FF6FAD-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 6/18/2015 4:32 PM, Hefty, Sean wrote:
>> In an effort to reform the RDMA core and ULPs to minimize use of
>> node_type in struct ib_device, an additional bit is added to
>> struct ib_device for is_switch (IB switch). This is needed
>> to be initialized by any IB switch device driver. This is a
>> NEW requirement on such device drivers which are all
>> "out of tree".
> 
> I agree with Jason, only I would add we need to decide if we want to continue supporting the out of tree devices.  
> We have for so long that it seems reasonable to do so.  

Yes, it seems reasonable to me to continue supporting them.

> At the same time, I think we'd reject these changes now without a lower level user of them.

Although this is the usual kernel standard, the RDMA code broke this
precedent from day one where switches were supported so I, for one,
don't think it's appropriate to reverse that decision now.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

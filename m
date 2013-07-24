From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: Dual star topology
Date: Wed, 24 Jul 2013 17:18:40 -0400
Message-ID: <51F044B0.305@dev.mellanox.co.il>
References: <CAJH6TXipMaLMcwuBbR+Jvb3KueZ1gBW7ohcb5Ke8ixO1bCEWAw@mail.gmail.com> <51F01724.7010504@dev.mellanox.co.il> <CAJH6TXgJGALyCcyPo+GvAninXQkZ+Md8c0NPmi_PUoU4XKDUHA@mail.gmail.com> <CAJH6TXjYW8w=RafoXgFiYNcFHc8ub+o-2v0_NsD8efoB0vyHpA@mail.gmail.com> <CAJH6TXg3+ZzQAK1Wbf2HtfymrToHY7bSVWTpxP3_Ddi6CL0BbQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJH6TXg3+ZzQAK1Wbf2HtfymrToHY7bSVWTpxP3_Ddi6CL0BbQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gandalf Corvotempesta <gandalf.corvotempesta-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 7/24/2013 4:56 PM, Gandalf Corvotempesta wrote:
> 2013/7/24 Gandalf Corvotempesta <gandalf.corvotempesta-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
>> I have to configure ceph on these subnets and ceph doesn't allow to
>> set multiple addresses for each service.
> 
> Let me try to explain in a better way.
> I would like to create a ceph cluster over an infiniband network.
> Each server has a signle dual-port HBA.
> Ceph is running with a *single* IP address on each server.
> 
> In a standard IP network, I have to interconnect both switches or i'll
> loose some traffic in case of a single port failure:
> 
> server1.port1      ib switch 1 <--> server2.port1
> server1.port2 <-> ib switch 2
> 
> 
> in this case, server1 will not be able to reach server2, because of split brain.
> An interconnection between both switches will solve this in a standard
> IP network.

So does ceph run on top of IP ? If so, could you use IPoIB bonding (and
interconnect the switches with some number of links) ?

-- Hal

> How can I archieve this in an infiniband network?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

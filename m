From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: Dual star topology
Date: Fri, 26 Jul 2013 08:54:39 -0400
Message-ID: <51F2718F.6060907@dev.mellanox.co.il>
References: <CAJH6TXipMaLMcwuBbR+Jvb3KueZ1gBW7ohcb5Ke8ixO1bCEWAw@mail.gmail.com> <51F01724.7010504@dev.mellanox.co.il> <CAJH6TXgJGALyCcyPo+GvAninXQkZ+Md8c0NPmi_PUoU4XKDUHA@mail.gmail.com> <CAJH6TXjYW8w=RafoXgFiYNcFHc8ub+o-2v0_NsD8efoB0vyHpA@mail.gmail.com> <CAJH6TXg3+ZzQAK1Wbf2HtfymrToHY7bSVWTpxP3_Ddi6CL0BbQ@mail.gmail.com> <51F044B0.305@dev.mellanox.co.il> <CAJH6TXiQNc_y8KHO79aOY0A9-PJ7bm54URyhNhVFkd18ZmyM5Q@mail.gmail.com> <CAJH6TXgOTbfBqqatMQOxtgnUUt=p9c4mkqaq3s-ujh5hLZJ5Zw@mail.gmail.com> <1828884A29C6694DAF28B7E6B8A8237384567F02@ORSMSX109.amr.corp.intel.com> <CAJH6TXjnZ=c5X5JzKynuUf4niiAs=A0oQZ9erEMh570L06eZ-g@mail.gmail.com> <51F25A01.80002@dev.mellanox.co.il> <CAJH6TXjdXUiGJ89b6VDVCcCJ283pv0LziQ5xi4xsO72j4iouGA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJH6TXjdXUiGJ89b6VDVCcCJ283pv0LziQ5xi4xsO72j4iouGA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gandalf Corvotempesta <gandalf.corvotempesta-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/26/2013 8:20 AM, Gandalf Corvotempesta wrote:
> 2013/7/26 Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>:
>> There is support for IPoIB bonding.
> 
> I'm talking about switch interconnection. How can I create bonding on switches?

The SM reroutes based on links coming and going so if there are multiple
links between switches, this addresses the internal link failover scenario.

-- Hal

> Any recent benchmark about IPoIB ?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: Dual star topology
Date: Wed, 24 Jul 2013 14:04:20 -0400
Message-ID: <51F01724.7010504@dev.mellanox.co.il>
References: <CAJH6TXipMaLMcwuBbR+Jvb3KueZ1gBW7ohcb5Ke8ixO1bCEWAw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJH6TXipMaLMcwuBbR+Jvb3KueZ1gBW7ohcb5Ke8ixO1bCEWAw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gandalf Corvotempesta <gandalf.corvotempesta-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Gandalf,

On 7/24/2013 11:20 AM, Gandalf Corvotempesta wrote:
> Hi to all
> i'm probably OT but I don't know where to ask
> I'm searching for some advice creating a dual-star topology to get
> full path redundancy.
> I have one dual-port DDR card on each server and two switches.
> I'll connect one port to each switch, but should I also interconnect
> both switches like in a standard ethernet network ?

The most fully redundant model would be to _not_ interconnect the 2
switches so it's 2 IB subnets rather than a single subnet. This means
you need at least 1 SM on each subnet (with different subnet prefix) but
you might want more if you're worried about some SM failing and not
having an SM on that subnet.

-- Hal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

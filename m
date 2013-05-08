From: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: Infiniband HA
Date: Wed, 08 May 2013 12:24:28 +0200
Message-ID: <518A27DC.5070303@profitbricks.com>
References: <CAJH6TXgC8jGHiRxL5gRnYud8V6fSrDRvEd+w8nazCcmt92-bCA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJH6TXgC8jGHiRxL5gRnYud8V6fSrDRvEd+w8nazCcmt92-bCA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gandalf Corvotempesta <gandalf.corvotempesta-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Gandalf,

just build up two separate fabrics. This means that you don't
interconnect both switches.
Otherwise, issues on one port also affect the other port.

What do you use for storage? SRP?
This requires dm-multipath and fast IO failing + automatic reconnect
patches from Bart or from me.

All other traffic like IPoIB for example also has to be able to switch
the port.

Cheers,
Sebastian


On 08.05.2013 12:06, Gandalf Corvotempesta wrote:
> Hi to all
> I'm new to Infiniband/RMDA and probabily this is not the right place to ask.
> I'm planning a new infiniband infrastructure with dual port HBA and I
> have a question:
> 
> How can I archieve fault tollerance with multiple switches? Should I
> connect all like a standard ethernet infrastructure ? (port1 to
> switch1, port2 to switch2, and both switches interconnected with a
> cable?)
> 
> Thank you.



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

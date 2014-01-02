From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: Fwd: IPoIB and STP
Date: Thu, 02 Jan 2014 11:23:46 -0500
Message-ID: <52C59292.8030903@dev.mellanox.co.il>
References: <CAJH6TXgBySmP9JG=dt1Gp8_oYPBK+g=O84DOjpUu-sZZJ9p-6g@mail.gmail.com> <CAJH6TXibJknwQJz-zB4KC=Lf-ewCaRaRZTGiMu9VHJV_Vr8OjQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJH6TXibJknwQJz-zB4KC=Lf-ewCaRaRZTGiMu9VHJV_Vr8OjQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gandalf Corvotempesta <gandalf.corvotempesta-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/28/2013 6:08 AM, Gandalf Corvotempesta wrote:
> Hi,
> i'm trying to configure a redundant IPoIB network.
> Obviously, IB switches doesn't talk IP and so doesn't have STP support.
> 
> How can I interconnect two different switches with multiple cables and
> avoid loops?
> 
> For example:
> http://pastebin.com/raw.php?i=w8ySRibG
> 
> To have a fully redundant network, I have to interconnect switch1 and
> switch2 at least with 2 cables and enable STP to avoit loops
> 
> Is OpenSM smart enough to detect a multiple link and shutdown one port
> automatically (doing the same as STP) ?

SM doesn't need to shut down redundant links. It can use multiple links
as long as it is required to ensure that there are no cyclic flow
control dependencies. The SM configures this via the switch forwarding
tables and the SL to VL mapping on the ports in the subnet.

-- Hal

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

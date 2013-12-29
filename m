From: Gandalf Corvotempesta <gandalf.corvotempesta-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: IPoIB and STP
Date: Sun, 29 Dec 2013 11:43:57 +0100
Message-ID: <CAJH6TXgXtHrtv5KQQvF1X-qLa4R7iC8cAJC0LJkJRj_JUKp1ag@mail.gmail.com>
References: <CAJH6TXgBySmP9JG=dt1Gp8_oYPBK+g=O84DOjpUu-sZZJ9p-6g@mail.gmail.com>
	<CAJH6TXibJknwQJz-zB4KC=Lf-ewCaRaRZTGiMu9VHJV_Vr8OjQ@mail.gmail.com>
	<CA+Ekn_c=LVNAhqpZqbnjFSV-WW3TZNTyHDjb74S1_x1nSV8iXQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+Ekn_c=LVNAhqpZqbnjFSV-WW3TZNTyHDjb74S1_x1nSV8iXQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gennadiy Nerubayev <parakie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

OpenSM will be running on both nodes and both node ports will be
bonded together in active-failover (or active-active, if possible). My
issue is with interconnection links between switches.
Last time that i've tried I had issue due to the interface bonding in
active-active.
When using active-active i've seen IPoIB running and just a couple of
KBytes/s and in active-failover was running at 10-11Gbps/s

So, are you suggesting:
OpenSM running on both, node1 and node2
Both nodes connected to both switches (1 port per switch)
Both switches interconnected with 2 or more links to have aggregated bandwidth

This would'nt require any special configuration? How can I ensure the
both link on switches are used together? Any command to run with
OpenSM ?

2013/12/29 Gennadiy Nerubayev <parakie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> On Sat, Dec 28, 2013 at 6:08 AM, Gandalf Corvotempesta
> <gandalf.corvotempesta-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>
>> Hi,
>> i'm trying to configure a redundant IPoIB network.
>> Obviously, IB switches doesn't talk IP and so doesn't have STP support.
>>
>> How can I interconnect two different switches with multiple cables and
>> avoid loops?
>>
>> For example:
>> http://pastebin.com/raw.php?i=w8ySRibG
>>
>> To have a fully redundant network, I have to interconnect switch1 and
>> switch2 at least with 2 cables and enable STP to avoit loops
>>
>> Is OpenSM smart enough to detect a multiple link and shutdown one port
>> automatically (doing the same as STP) ?
>
> Infiniband uses a switched fabric topology, so regular Ethernet STP
> topology rules do not apply. In this scenario here each link, direct
> or via the interconnects to the other switch, would just be an
> alternate path to the target. If I recall correctly, running OpenSM
> only binds to one port, so this is why you'd technically want those
> links between the switches to have a single fabric. Of course, losing
> the link to that port also means you will have no subnet manager, so
> you might want to consider having it running on one more host as
> well..
>
> -Gennadiy
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

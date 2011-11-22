From: dev-x2spCj9RiN0z5UmgcLIfJQ@public.gmane.org
Subject: Re: Independent server management of Multicasting connections
Date: Tue, 22 Nov 2011 07:17:00 -0700
Message-ID: <20111122071700.10712l3tf30i64m4@peddycoart.com>
References: <20111121071551.14306gf6ogr9z8yf@celticblues.com>
 <1828884A29C6694DAF28B7E6B8A8237316E9B9E9@ORSMSX101.amr.corp.intel.com>
 <20111121110529.5090464a.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111121110529.5090464a.weiny2-i2BcT+NCU+M@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Where can I find out more on how to do this, i.e. use opensm to create  
mc groups at startup?


Quoting Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>:

> On Mon, 21 Nov 2011 09:05:22 -0800
> "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>
>> >  From what I understand, and I may not understand correctly, to
>> > perform IB Multicast, betweeen two nodes, I need to swap addresses and
>> > remote keys for the two nodes.  In the examples I have seen this has
>>
>> You only need to do this for unicast UD.  Multicast doesn't require  
>> exchanging addresses and qkeys, but see below.
>>
>> > been done via RDMA CM directly between the two nodes.  Does it matter
>> > how this information is exchanged?  In my application I will have
>>
>> For multicast, you need to 1. have the SA create the multicast  
>> group and 2. join the group.  To create the group, you need to  
>> either have the SA automatically create the group (if this is  
>> possible) or create it dynamically.  To create the group  
>> dynamically from user space, you should use the rdma_cm or ib_umad  
>> interfaces.  The rdma_cm is easier.
>>
>
> FWIW, OpenSM (current master branch) now has the ability to create  
> multicast groups at startup, so 1 is possible.
>
> See: http://www.spinics.net/lists/linux-rdma/msg10021.html
>
> Ira
>
>> To join the group, you need to let the SA know that the node should  
>> receive multicast traffic, so that it can program the switches.   
>> This is done through the rdma_cm (easy way) or using ib_umad (hard  
>> way that gets harder if you want to support multiple applications  
>> joining the same group from the same system).
>>
>> > several nodes multicasting to several other nodes and I want to manage
>> > the connections from a independent application.  What I would like to
>> > do is write this application, server, etc. so that each node would
>> > request connection with another node and then be provied with the
>> > information it needs to multicast.  For example... Node 1 would
>> > request a connection (from the server app) Node 2 and Node 2 would
>> > request a connection (again, from the server app) to Node 1.  The
>> > Server app would provide Node 2's "credentials" to Node 1 and likewise
>> > to Node 2.  Is this even possible?
>>
>> The SA basically does the work that you're describing for your  
>> server app.  Node 1 can ask the SA to create a multicast group.   
>> Node 2 can ask to join that group.  Somehow node 2 needs to know  
>> what group node 1 created.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
> --
> Ira Weiny
> Member of Technical Staff
> Lawrence Livermore National Lab
> 925-423-8008
> weiny2-i2BcT+NCU+M@public.gmane.org
>



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

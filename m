From: Dotan Barak <dotanba-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: P
Date: Sat, 19 Jun 2010 12:42:04 +0200
Message-ID: <4C1C9EFC.4020304@gmail.com>
References: <AANLkTiml1Q7sD9MFsg_q1nQx5091rNnzhK8oh1aUnxwT@mail.gmail.com>	<4C125697.1000508@gmail.com>	<AANLkTilhV8JJTKxc4OpudTUgKqMyJ5mzcxt6XdSMurDS@mail.gmail.com>	<4C134EFC.5010207@gmail.com> <AANLkTimdeZwZI3FlTncXY_d3QY8jFfNhHERTxl3BD3Bd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTimdeZwZI3FlTncXY_d3QY8jFfNhHERTxl3BD3Bd-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ding Dinghua <dingdinghua85-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


> I call rdma_create_id to create an ib id, then do resolve remote addr,
> resolve route work, then
> setup qp and call rdma_connect to setup connection, before ack or
> error replies, the thread will
> wait on a wait queue. The listening ib id of remote node will catch
> the connect request,
> setup qp, allocate and map pages to construct the RDMA-WRITE space,
> and call rdma_accept to reply
> the request.
>
> Some other information which may be useful:
> 1.All the "RETRY EXCEEDED" problems happened when there were two
> connections which use RDMA-WRITE to transfer things.
> And the latter connection had a high possibility to get into this problem.
> 2. All the "RETRY EXCEEDED" problems happened when the RMDA-WRITE
> space is 256MB each(that is, for two connections, consumes 512MB mem),
> when the RDMA-WRITE  space is 64MB, this problem never happened in our
> test. Remote node's total memory is 2GB.
>
> Thanks a lot.
>    
Some more questions:
* Is the WR that "produces" the RETRY EXCEEDED is the first one/last 
one/in the middle?
* Which values are you using in the QP context for retry exceeded 
counter + retry timeout?
* Did you try to increase those values?
* How many more QPs do you have between those nodes and which operations 
do they use
    (only RDMA-WRITEs?)

Thanks
Dotan
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

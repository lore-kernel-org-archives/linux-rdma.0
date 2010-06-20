From: Ding Dinghua <dingdinghua85-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: P
Date: Sun, 20 Jun 2010 13:51:23 +0800
Message-ID: <AANLkTinah43AD5N0ZryDsrGprkeVf9-BdLCyr125PQ3p@mail.gmail.com>
References: <AANLkTiml1Q7sD9MFsg_q1nQx5091rNnzhK8oh1aUnxwT@mail.gmail.com>
	<4C125697.1000508@gmail.com>
	<AANLkTilhV8JJTKxc4OpudTUgKqMyJ5mzcxt6XdSMurDS@mail.gmail.com>
	<4C134EFC.5010207@gmail.com>
	<AANLkTimdeZwZI3FlTncXY_d3QY8jFfNhHERTxl3BD3Bd@mail.gmail.com>
	<4C1C9EFC.4020304@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C1C9EFC.4020304-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dotan Barak <dotanba-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

hello,

2010/6/19 Dotan Barak <dotanba-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
>
>> I call rdma_create_id to create an ib id, then do resolve remote add=
r,
>> resolve route work, then
>> setup qp and call rdma_connect to setup connection, before ack or
>> error replies, the thread will
>> wait on a wait queue. The listening ib id of remote node will catch
>> the connect request,
>> setup qp, allocate and map pages to construct the RDMA-WRITE space,
>> and call rdma_accept to reply
>> the request.
>>
>> Some other information which may be useful:
>> 1.All the "RETRY EXCEEDED" problems happened when there were two
>> connections which use RDMA-WRITE to transfer things.
>> And the latter connection had a high possibility to get into this pr=
oblem.
>> 2. All the "RETRY EXCEEDED" problems happened when the RMDA-WRITE
>> space is 256MB each(that is, for two connections, consumes 512MB mem=
),
>> when the RDMA-WRITE =A0space is 64MB, this problem never happened in=
 our
>> test. Remote node's total memory is 2GB.
>>
>> Thanks a lot.
>>
>
> Some more questions:
> * Is the WR that "produces" the RETRY EXCEEDED is the first one/last =
one/in
> the middle?

it's the first one

> * Which values are you using in the QP context for retry exceeded cou=
nter +
> retry timeout?
> * Did you try to increase those values?

I haven't set these values(actually  I don't know where to set these
values), i just set max_send_wr and max_send_sge
fields of struct ib_qp_cap when creating qp.

> * How many more QPs do you have between those nodes and which operati=
ons do
> they use
> =A0 (only RDMA-WRITEs?)
>

4096 QPs for each connection,  only do RDMA-WRITES.

> Thanks
> Dotan
>



--=20
Ding Dinghua
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

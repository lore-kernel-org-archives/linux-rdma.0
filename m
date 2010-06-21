From: Ding Dinghua <dingdinghua85-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: P
Date: Mon, 21 Jun 2010 10:30:50 +0800
Message-ID: <AANLkTimAVJuUQfU5uRku-pVqquj3zr7Rt0NZlkhwXO0V@mail.gmail.com>
References: <AANLkTiml1Q7sD9MFsg_q1nQx5091rNnzhK8oh1aUnxwT@mail.gmail.com>
	<4C125697.1000508@gmail.com>
	<AANLkTilhV8JJTKxc4OpudTUgKqMyJ5mzcxt6XdSMurDS@mail.gmail.com>
	<4C134EFC.5010207@gmail.com>
	<AANLkTimdeZwZI3FlTncXY_d3QY8jFfNhHERTxl3BD3Bd@mail.gmail.com>
	<4C1C9EFC.4020304@gmail.com>
	<AANLkTinah43AD5N0ZryDsrGprkeVf9-BdLCyr125PQ3p@mail.gmail.com>
	<4C1E6134.6070304@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C1E6134.6070304-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dotan Barak <dotanba-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

2010/6/21 Dotan Barak <dotanba-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> On 20/06/2010 07:51, Ding Dinghua wrote:
>>
>> hello,
>>
>> 2010/6/19 Dotan Barak<dotanba-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
>>
>>>
>>>
>>>>
>>>> I call rdma_create_id to create an ib id, then do resolve remote a=
ddr,
>>>> resolve route work, then
>>>> setup qp and call rdma_connect to setup connection, before ack or
>>>> error replies, the thread will
>>>> wait on a wait queue. The listening ib id of remote node will catc=
h
>>>> the connect request,
>>>> setup qp, allocate and map pages to construct the RDMA-WRITE space=
,
>>>> and call rdma_accept to reply
>>>> the request.
>>>>
>>>> Some other information which may be useful:
>>>> 1.All the "RETRY EXCEEDED" problems happened when there were two
>>>> connections which use RDMA-WRITE to transfer things.
>>>> And the latter connection had a high possibility to get into this
>>>> problem.
>>>> 2. All the "RETRY EXCEEDED" problems happened when the RMDA-WRITE
>>>> space is 256MB each(that is, for two connections, consumes 512MB m=
em),
>>>> when the RDMA-WRITE =A0space is 64MB, this problem never happened =
in our
>>>> test. Remote node's total memory is 2GB.
>>>>
>>>> Thanks a lot.
>>>>
>>>>
>>>
>>> Some more questions:
>>> * Is the WR that "produces" the RETRY EXCEEDED is the first one/las=
t
>>> one/in
>>> the middle?
>>>
>>
>> it's the first one
>>
>>
>>>
>>> * Which values are you using in the QP context for retry exceeded c=
ounter
>>> +
>>> retry timeout?
>>> * Did you try to increase those values?
>>>
>>
>> I haven't set these values(actually =A0I don't know where to set the=
se
>> values), i just set max_send_wr and max_send_sge
>> fields of struct ib_qp_cap when creating qp.
>>
>>
>
> Can you perform query QP after establishing a connection between the =
QPs and
> check those values?
>

All the QPs (local and remote, 2 connections) :
3 qp_state, 19 retry_cnt, 7 timeout, that's, all QPs' qp_state is
IB_QPS_RTS(Should remote QP's state be this, or IB_QPS_RTR?
But QP's state of first connection is the same and it can work...).

>>> * How many more QPs do you have between those nodes and which opera=
tions
>>> do
>>> they use
>>> =A0 (only RDMA-WRITEs?)
>>>
>>>
>>
>> 4096 QPs for each connection, =A0only do RDMA-WRITES.
>>
>
> So, you send in parallel total of 4K (QPs) * 64M (Bytes) =A0=3D 256 G=
B
> (am i missing something, or this is the amount of data that will be s=
ent
> between two nodes?)
>
if  RDMA-WRITE space is 64M(Bytes),  this means upper level application=
s send
at most 64M(Bytes)  to remote node one time. These QPs may send to diff=
erent
piece of the 64M space in parallel.

> Dotan
>



--=20
Ding Dinghua
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

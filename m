From: Ding Dinghua <dingdinghua85-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: P
Date: Thu, 17 Jun 2010 15:07:55 +0800
Message-ID: <AANLkTimdeZwZI3FlTncXY_d3QY8jFfNhHERTxl3BD3Bd@mail.gmail.com>
References: <AANLkTiml1Q7sD9MFsg_q1nQx5091rNnzhK8oh1aUnxwT@mail.gmail.com>
	<4C125697.1000508@gmail.com>
	<AANLkTilhV8JJTKxc4OpudTUgKqMyJ5mzcxt6XdSMurDS@mail.gmail.com>
	<4C134EFC.5010207@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C134EFC.5010207-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dotan Barak <dotanba-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Sorry for late reply.

2010/6/12 Dotan Barak <dotanba-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> On 12/06/2010 03:22, Ding Dinghua wrote:
>>
>> 2010/6/11 Dotan Barak<dotanba-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
>>
>>>
>>> Hi.
>>>
>>> On 11/06/2010 10:51, Ding Dinghua wrote:
>>>
>>>>
>>>> Hi all:
>>>> =A0 =A0 =A0 =A0 =A0I'm using RDMA to do fs-metadata mirror between=
 nodes. I
>>>> encountered a strange problem when the program was running:
>>>> Complete queue handler reported that the =A0RDMA-Write operation f=
ailed,
>>>> =A0the status of =A0corresponding "struct ib_wc" is "IB_WC_RETRY_E=
XC_ERR".
>>>> The problem is encountered randomly. I don't know the meaning of t=
his
>>>> error code as well as what to do next. Would anyone give me some t=
ips?
>>>> thanks a lot.
>>>>
>>>>
>>>
>>> Do you sync between the sides before closing the QPs?
>>>
>>
>> Can you say it more detail? thanks.
>>
>
> If you try to send a message from local QP to a remote QP before the =
remote
> QP is in RTR state (or after it was closed/transferred to the ERROR s=
tate),
> you may get RETRY EXCEEDED, because there isn't any QP in the remote =
side
> that can accept your message (and send a response).
>
> How do you connect the QPs? (And how do you close the connection betw=
een
> them)
>
I call rdma_create_id to create an ib id, then do resolve remote addr,
resolve route work, then
setup qp and call rdma_connect to setup connection, before ack or
error replies, the thread will
wait on a wait queue. The listening ib id of remote node will catch
the connect request,
setup qp, allocate and map pages to construct the RDMA-WRITE space,
and call rdma_accept to reply
the request.

Some other information which may be useful:
1.All the "RETRY EXCEEDED" problems happened when there were two
connections which use RDMA-WRITE to transfer things.
And the latter connection had a high possibility to get into this probl=
em.
2. All the "RETRY EXCEEDED" problems happened when the RMDA-WRITE
space is 256MB each(that is, for two connections, consumes 512MB mem),
when the RDMA-WRITE  space is 64MB, this problem never happened in our
test. Remote node's total memory is 2GB.

Thanks a lot.


> Dotan
>



--=20
Ding Dinghua
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

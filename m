From: Ding Dinghua <dingdinghua85-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: two questions about RDMA-WRITE
Date: Wed, 14 Apr 2010 10:15:13 +0800
Message-ID: <g2s7bb361261004131915r5c88ba9bo1fa8980dee68174@mail.gmail.com>
References: <q2v7bb361261004130308za7b4d6ccj6fdb657b7c7cc7e9@mail.gmail.com>
	 <4BC484AC.80804@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4BC484AC.80804-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

=D4=DA 2010=C4=EA4=D4=C213=C8=D5 =CF=C2=CE=E710:50=A3=ACSteve Wise <swi=
se-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> =D0=B4=B5=C0=A3=BA
> =B6=A1=B6=A8=BB=AA wrote:
>> Hi guys:
>> I'm doing a project using RDMA to transfer data between servers.  I'=
m
>> using RDMA_PS_TCP type and do RDMA_WRITE operations from client node
>> to server node. While the program succeed in setting up connection a=
nd
>> transferring data, I 'm still very confused about two problems:
>> (1)  After transfer the data using IB_WR_RDMA_WRITE , the complete
>> queue entry found that the opcode turned from IB_WR_RDMA_WRITE to
>> IB_WR_RDMA_WRITE_WITH_IMM, I don't know the meaning of this opcode a=
nd
>> the reason of the change.
>>
>
> The opcode in the completion is of type enum ib_wc_opcode, not enum
> ib_wr_opcode. You are mis-interpreting the opcode in the completion.
>
Oh, yes, I think I made a mistake, thanks.

>> (2)  It takes a long time to finish rdma_disconnect work (about 10
>> seconds), so is it a reasonable time?
>>
>
> What device are you using?
I'm using "Mellanox Technologies MT25204"

>
>
> Steve.
>



--=20
Ding Dinghua
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

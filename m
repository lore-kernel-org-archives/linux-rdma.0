From: Ilya Kalistru <stebanoid-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Native IB connection setup.
Date: Wed, 15 Jan 2014 20:57:06 +0400
Message-ID: <CAKxz9HD3Gr3xyKh0CSM=SjLJLuGezDyrQUGAz-6jHDRVh_gPdw@mail.gmail.com>
References: <CAKxz9HDpu6-R8HbP6kFw1TU-Px-vrGOB7JVOTdRAFyXiDTdKjg@mail.gmail.com>
	<52C54937.7020003@mellanox.com>
	<52C56FB8.1080509@dev.mellanox.co.il>
	<CAKxz9HAoCxEZA=DPaJc2TmwotBFsXLdWogr6c379zr4M6-A0Fg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKxz9HAoCxEZA=DPaJc2TmwotBFsXLdWogr6c379zr4M6-A0Fg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Ok, I know that here is Linux mail-list, but may be somebody
know is it able to implement approach with AF_IB for Windows?

I don't know where I can ask this somewere else.

2014/1/3 Ilya Kalistru <stebanoid-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> Thank you very much!
> I'm going to study this examples.
> In SRP code I've found process of connection establishment with
> REQ/REP/RTU messages.
> Moreover, I've found that SAQUERY tool in infiniband-diags package
> contains functions of NAME -> LID resolution and I think I can use it
> to learn how do they do such things.
>
> I don't know what is AF_IB and how I can use it, but I'll study
> rstream and ucmatose sources too.
>
> 2014/1/2 Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>:
>> On 1/2/2014 6:10 AM, Sagi Grimberg wrote:
>>> On 1/2/2014 10:11 AM, Ilya Kalistru wrote:
>>>> Happy New Year, ladies and gentlemen!
>>>>
>>>> I'm developing some sort of "hardware InfiniBand server" runing on
>>>> FPGA and delivering some data to PC using RDMA_WRITE operation.
>>>> I've already had Physical Link Up and Logical Link Up between my
>>>> device and PC with Mellanox HCA.
>>>> I see GUID and LID of my device when I runing ibstatus or
>>>> ibnetdiscover command on PC and therefore I think subnet configura=
tion
>>>> is ok.
>>>>
>>>> Now I have a problem with connection setup. Because I'm only who i=
s
>>>> developing this device and it's a problem to add extra protocols i=
n
>>>> FPGA firmware I don't want to use any something like getaddrinfo()
>>>> (they use IPoIB)...
>>>> I'm going to use native IB CM REQ/REP/RTU MADs for connection setu=
p,
>>>> but I don't know how.
>>>>
>>>> I think that I should request GUID to LID resolution at first. Lik=
e
>>>> rdma_resolve_addr()/rdma_resolve_route() but from GUID not from IP=
=2E
>>>> Second (I think) I should use ib_send_cm_req() and ib_send_cm_rtu(=
)
>>>> with well known ServiceID (I select it) to establish connection.
>>>>
>>>> I'm not a programmer and have no experience with programming of
>>>> network based applications and therefore I will be thankful very m=
uch
>>>> if you help me with example of programm code using native IB
>>>> connection setup technics or any other help.
>>>
>>> You can  have a look in SRP (SCSI RDMA Protocol under
>>> drivers/infiniband/ulp/srp) as a reference for native IB connection
>>> establishment.
>>
>> There are 2 basic approaches for this:
>>
>> As Sagi wrote, first approach is IB CM/UCM which is the approach use=
d by
>> SRP and IPoIB-CM.
>>
>> Also, RDMA CM now supports AF_IB. A "recent" kernel (and "recent"
>> librdmacm if user space app) are needed for this approach. There are=
 2
>> example user space applications which show how to use this (rstream =
and
>> ucmatose).
>>
>> Both require some information from SA PathRecord on the active (clie=
nt)
>> side of the connection.
>>
>> -- Hal
>>
>>>> P.S. It's my first time I'm using mailing list. I'm sorry, if I'm
>>>> doing something wrong.
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-rd=
ma" in
>>>> the body of a message tomajordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>>> More majordomo info athttp://vger.kernel.org/majordomo-info.html
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-rdm=
a" in
>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>



--=20

=F3 =D5=D7=C1=D6=C5=CE=C9=C5=CD, =E9=CC=D8=D1 =EB=C1=CC=C9=D3=D4=D2=D5.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

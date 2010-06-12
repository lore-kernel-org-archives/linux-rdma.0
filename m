From: Ding Dinghua <dingdinghua85-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: A strange problem when using IB to transfer things
Date: Sat, 12 Jun 2010 09:22:31 +0800
Message-ID: <AANLkTilhV8JJTKxc4OpudTUgKqMyJ5mzcxt6XdSMurDS@mail.gmail.com>
References: <AANLkTiml1Q7sD9MFsg_q1nQx5091rNnzhK8oh1aUnxwT@mail.gmail.com>
	<4C125697.1000508@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C125697.1000508-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dotan Barak <dotanba-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

2010/6/11 Dotan Barak <dotanba-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> Hi.
>
> On 11/06/2010 10:51, Ding Dinghua wrote:
>>
>> Hi all:
>> =A0 =A0 =A0 =A0 =A0I'm using RDMA to do fs-metadata mirror between n=
odes. I
>> encountered a strange problem when the program was running:
>> Complete queue handler reported that the =A0RDMA-Write operation fai=
led,
>> =A0the status of =A0corresponding "struct ib_wc" is "IB_WC_RETRY_EXC=
_ERR".
>> The problem is encountered randomly. I don't know the meaning of thi=
s
>> error code as well as what to do next. Would anyone give me some tip=
s?
>> thanks a lot.
>>
>
> Do you sync between the sides before closing the QPs?

Can you say it more detail? thanks.

>
> Retry exceeded mans that a message was sent without a response
> (maybe you need to increase the timeout in the QP attributes: =A0time=
out or
> retry_cnt).
>
> I hope this helped you ..
>
> Dotan
>



--=20
Ding Dinghua
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

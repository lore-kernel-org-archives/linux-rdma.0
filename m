From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: Is there a way to transfer a rdma connection between userspace
 processes?
Date: Mon, 15 Oct 2012 10:31:58 -0500
Message-ID: <507C2C6E.7010507@opengridcomputing.com>
References: <507BC8EE.2020908@samba.org> <1350292042.2750.11.camel@dworkin.quest-ce.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1350292042.2750.11.camel-vNW8ozRvgWupuGC+iAP0z+TW4wlIGRCZ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: "Stefan (metze) Metzmacher" <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 10/15/2012 4:07 AM, Yann Droneaud wrote:
> Le lundi 15 octobre 2012 =C3=A0 10:27 +0200, Stefan (metze) Metzmache=
r a
> =C3=A9crit :
>> Hi,
>>
>> I'm currently researching how to implement SMBDirect [MS-SMBD]
>> together with the multi channel feature of SMB 3.0 in Samba.
>>
>> As Samba currently uses one process per tcp connection
>> and maintains a lot of in memory state within the process
>> (e.g. for the SMB_VFS modules) it would require a lot of work
>> to change Samba to coordinate two (or more) processes for one logica=
l
>> multi channel connection.
>>
>> My current plan tries to pass the socket fd of new connections
>> (which join an existing multi channel session) via fd-passing to
>> the existing process.
>>
>> Now I'm wondering if this would also be possible with
>> a rdma connection (struct rdma_cm_i ).
>>
> RDMA / verbs ressources are tied to a process (especially Memory
> Registration), but it's ending up in the HCA, which is probably unawa=
re
> of processes.
>
> Additionally, an RDMA_CM connection is not identified by a FD, so thi=
s
> kind of Unix trick (FD passing through Unix socket: SCM_RIGHTS) is no=
t
> going to work.
>
> Forking might already be a challenge for a RDMA/verbs application, so=
 I
> don't think that sharing/moving an RDMA_CM connection across differen=
t
> processes is supported.
>
> But other people on this list (especially Roland Dreier and Sean Heft=
y)
> could find a solution.
>
> Regards.
>

fork() support like you need is not there in Linux RDMA verbs. Another=20
alternative is to fork() before you setup the RDMA connection.  IE if a=
=20
regular TCP socket is first used to negotiate RDMA mode, then maybe you=
=20
could fork() after negotiation but before setting up the RDMA connectio=
n=20
and other resources?


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

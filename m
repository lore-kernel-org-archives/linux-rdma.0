From: Benoit Hudzia <benoit.hudzia-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: kernel space rdma client, reg_mr issue
Date: Thu, 30 Jun 2011 19:19:17 +0100
Message-ID: <BANLkTineVra954AL+TvYo1H_rPVTHiJb6Q@mail.gmail.com>
References: <BANLkTi=+mFMHzoS9A=M1mW5pSjy8qdoV7Q@mail.gmail.com>
	<OF20DF8848.8939F082-ONC12578BF.005A6103-C12578BF.005B04E0@ch.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <OF20DF8848.8939F082-ONC12578BF.005A6103-C12578BF.005B04E0-Xeyd2O9EBijQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bernard Metzler <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Cc: jean-noel.gonzalez.de.linares-y6kNeMnOB+c@public.gmane.org, john stewart <john.stewart.kz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

Thanks for the reply , i will look into the get_dma_mr() path for
registering memory.
And probably get back to all of you for some clarification if i get stu=
ck.

On the same note, 2 things i noticed while using softiwarp:
1. the current version of softiwarp ( from the master git ) doesn't
support the latest kernel version (3.0.0 rc4) as it still using the
IW_CM_EVENT_STATUS_xxx values  that have been removed
(https://patchwork.kernel.org/patch/772712/) in the latest kernel
iteration. Would you like me to submit a patch as we had to change the
code already ?

2: i noticed that sofiwarp crash the kernel when you post a work
request with an invalid rkey from userspace . I will try to  reproduce
the crash and send you some code. Maybe if i have time a patch

Regards
Benoit

On 30 June 2011 17:34, Bernard Metzler <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org> wrote:
>
>
> linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org wrote on 06/30/2011 04:19:01 PM:
>
>> Hi,
>>
>
> maybe i misread your last email - are you trying to use reg_user_mr()
> as a kernel client? If yes - that will not work. You should use the
> interface as
> described by Wendy (get_dma_mr() etc.), since you are dealing with ke=
rnel
> memory. I can add a check to siw to prevent that call into
> siw_reg_user_mr() to be executed for kernel clients.
>
> thanks,
> Bernard.
>
>
>> We are working to create a RDMA client within the kernel which will
>> connect to a working RDMA userspace server.
>> We are using the userspace code =A0for testing purpose , in the fina=
l
>> version all the communication will be done within the kernel space.
>>
>
> <snip>
>
>



--=20
" The production of too many useful things results in too many useless =
people"
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

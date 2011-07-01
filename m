From: Bernard Metzler <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Subject: Re: kernel space rdma client, reg_mr issue
Date: Fri, 1 Jul 2011 10:19:44 +0200
Message-ID: <OFB90E32C5.77644DA4-ONC12578C0.002CC24C-C12578C0.002DC0FE@ch.ibm.com>
References: <BANLkTineVra954AL+TvYo1H_rPVTHiJb6Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTineVra954AL+TvYo1H_rPVTHiJb6Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Benoit Hudzia <benoit.hudzia-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: jean-noel.gonzalez.de.linares-y6kNeMnOB+c@public.gmane.org, john stewart <john.stewart.kz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



Benoit Hudzia <benoit.hudzia-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote on 06/30/2011 08:19:17 PM:

> Hi,
>
> Thanks for the reply , i will look into the get_dma_mr() path for
> registering memory.
> And probably get back to all of you for some clarification if i get
stuck.
>
> On the same note, 2 things i noticed while using softiwarp:
> 1. the current version of softiwarp ( from the master git ) doesn't
> support the latest kernel version (3.0.0 rc4) as it still using the
> IW_CM_EVENT_STATUS_xxx values  that have been removed
> (https://patchwork.kernel.org/patch/772712/) in the latest kernel
> iteration. Would you like me to submit a patch as we had to change the
> code already ?
>
i posted a new siw version to linux-rdma and netdev about 2 weeks ago.
that patch set already changes to errno values for IWCM status.
i will update gitorious.org in a few days. in the long run i hope
quality and completeness of siw will make it acceptable for
mainline integration, which would likely make gitorious.org/softiwarp
superfluous.

> 2: i noticed that sofiwarp crash the kernel when you post a work
> request with an invalid rkey from userspace . I will try to  reproduce
> the crash and send you some code. Maybe if i have time a patch
>

<snip>

any crash reports are highly appreciated (well... ;-)

many thanks!

Bernard.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

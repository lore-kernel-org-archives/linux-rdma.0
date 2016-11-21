From: Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] infiniband: remove WARN that is not kernel bug
Date: Mon, 21 Nov 2016 11:19:33 +0100
Message-ID: <CACT4Y+Yzv-wiN4JwEm_fjN0XVoq_QfnsskJ2Mks9+7s11KnyGQ@mail.gmail.com>
References: <1479468277-50798-1-git-send-email-dvyukov@google.com>
 <164538.1479522162@turing-police.cc.vt.edu> <20161119185732.GF22775@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161119185732.GF22775-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Valdis.Kletnieks-PjAqaU27lzQ@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, syzkaller <syzkaller-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, Nov 19, 2016 at 7:57 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Fri, Nov 18, 2016 at 09:22:42PM -0500, Valdis.Kletnieks-PjAqaU27lzQ@public.gmane.org wrote:
>> On Fri, 18 Nov 2016 12:24:37 +0100, Dmitry Vyukov said:
>> > WARNINGs mean kernel bugs.
>> > The one in ucma_write() points to user programming error
>> > or a malicious attempt. This is not a kernel bug, remove it.
>>
>> > -   if (WARN_ON_ONCE(!ib_safe_file_access(filp)))
>> > +   if (!ib_safe_file_access(filp))
>> >             return -EACCES;
>>
>> In that case, wouldn't this be better?
>>
>>       if (!ib_safe_file_access(filp)) {
>>               printk_once("Process %d (%s) tried to do something hinky", pid, comm);
>>               return _EACCESS;
>>       }
>>
>> so the sysadmin becomes aware of the malicious attempt?
>
> Yes please

Mailed v2
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] infiniband: remove WARN that is not kernel bug
Date: Mon, 21 Nov 2016 11:30:21 +0100
Message-ID: <CACT4Y+ZO9sTbBGwNUUMkAQ5m0N-4aT0S9xypCRbBUch1pQNw9g@mail.gmail.com>
References: <1479723531-17940-1-git-send-email-dvyukov@google.com> <alpine.LNX.2.00.1611211123450.22752@pobox.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LNX.2.00.1611211123450.22752-ztGlSCb7Y1iN3ZZ/Hiejyg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: syzkaller <syzkaller-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Valdis.Kletnieks-PjAqaU27lzQ@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 21, 2016 at 11:25 AM, Miroslav Benes <mbenes-AlSwsSmVLrQ@public.gmane.org> wrote:
> On Mon, 21 Nov 2016, Dmitry Vyukov wrote:
>
>> WARNINGs mean kernel bugs.
>> The one in ucma_write() points to user programming error
>> or a malicious attempt. This is not a kernel bug, remove it.
>>
>> BUG/WARNs that are not kernel bugs hinder automated testing effots.
>>
>> Signed-off-by: Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>> Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> Cc: syzkaller-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
>>
>> ---
>> Changes since v1:
>>  - added printk_once
>> ---
>>  drivers/infiniband/core/ucma.c | 5 ++++-
>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
>> index 9520154..405d0ce 100644
>> --- a/drivers/infiniband/core/ucma.c
>> +++ b/drivers/infiniband/core/ucma.c
>> @@ -1584,8 +1584,11 @@ static ssize_t ucma_write(struct file *filp, const char __user *buf,
>>       struct rdma_ucm_cmd_hdr hdr;
>>       ssize_t ret;
>>
>> -     if (WARN_ON_ONCE(!ib_safe_file_access(filp)))
>> +     if (!ib_safe_file_access(filp)) {
>> +             printk_once("ucma_write: process %d (%s) tried to do something hinky\n",
>> +                     task_tgid_vnr(current), current->comm);
>>               return -EACCES;
>> +     }
>>
>>       if (len < sizeof(hdr))
>>               return -EINVAL;
>
> FWIW, WARN_ON_ONCE came with commit e6bd18f57aad ("IB/security: Restrict
> use of the write() interface"). Would it make sense to change the other
> places as well?


I guess so.
Can I ask somebody of infiniband maintainers to take care of this?
I just hit the warning in my automated testing environment when a
thread executed key_add in between open and write, then spent some
time debugging to figure out that this is an "invalid user input"
rather than a kernel bug.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

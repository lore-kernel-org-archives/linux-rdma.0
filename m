From: "santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: BUG: spinlock bad magic (2)
Date: Tue, 30 Jan 2018 19:49:51 -0800
Message-ID: <24ea899d-d541-0274-c5bf-8a6e35473ca5@oracle.com>
References: <001a113fae28c2fd6605609c97a2@google.com>
 <6dbd4f85-f3f2-97f3-5b82-451276fbf877@oracle.com>
 <CACT4Y+Zoat=3j7B--D=pLK=SU0zhNA2yw0O0cEwj_p6vSBfM7g@mail.gmail.com>
 <20180130222811.yxfiqnlx3la3vyyw@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180130222811.yxfiqnlx3la3vyyw-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eric Biggers <ebiggers3-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: syzbot <bot+d3f5d339869eb8cd834d2c9f0a88bf4f05c29781-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, rds-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org, syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 1/30/18 2:28 PM, Eric Biggers wrote:
> On Mon, Dec 18, 2017 at 06:01:30PM +0100, 'Dmitry Vyukov' via syzkaller-bugs wrote:
>> On Mon, Dec 18, 2017 at 5:46 PM, Santosh Shilimkar
>> <santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
>>> On 12/18/2017 4:36 AM, syzbot wrote:
>>>>
>>>> Hello,
>>>>
>>>> syzkaller hit the following crash on
>>>> 6084b576dca2e898f5c101baef151f7bfdbb606d
>>>> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/master
>>>> compiler: gcc (GCC) 7.1.1 20170620
>>>> .config is attached
>>>> Raw console output is attached.
>>>>
>>>> Unfortunately, I don't have any reproducer for this bug yet.
>>>>
>>> [...]
>>>
>>>> BUG: unable to handle kernel NULL pointer dereference at 0000000000000028
>>>> IP: rds_send_xmit+0x80/0x930 net/rds/send.c:186
>>>
>>>
>>> This one seems to be same bug as reported as below.
>>>
>>> BUG: unable to handle kernel NULL pointer dereference in rds_send_xmit
>>
>> Hi Santosh,
>>
>> The proper syntax to tell syzbot about dups is this (from email footer):
>>
>>> See https://goo.gl/tpsmEJ for details.
>>> Please credit me with: Reported-by: syzbot <syzkaller-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
>>> syzbot will keep track of this bug report.
>>> To mark this as a duplicate of another syzbot report, please reply with:
>>> #syz dup: exact-subject-of-another-report
>>> Note: all commands must start from beginning of the line in the email body.
> 
> #syz dup: BUG: unable to handle kernel NULL pointer dereference in rds_send_xmit

Ok. Noted.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

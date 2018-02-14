From: Santosh Shilimkar <santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: KASAN: use-after-free Read in rds_find_bound
Date: Wed, 14 Feb 2018 09:35:49 -0800
Message-ID: <52478830-f0b5-e400-8101-b329ba35bcef@oracle.com>
References: <089e08231920353a4805618b365c@google.com>
 <d91da249-5a0f-7a1f-cfd5-68f10f0a2fc1@oracle.com>
 <CACT4Y+bd6Tyq672JC3GNSHPX2CEHacVKkcbKOAgpi8o-=T8DRg@mail.gmail.com>
 <491a26b8-7abb-0d36-0a2e-e1c7bfcde79d@oracle.com>
 <CACT4Y+YxrNiP==ty-KBjkDewnuS378GmG314-=ytWskZXQx3zw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACT4Y+YxrNiP==ty-KBjkDewnuS378GmG314-=ytWskZXQx3zw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: syzbot <syzbot+93a5839deb355537440f-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, netdev <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, rds-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 2/14/2018 9:14 AM, Dmitry Vyukov wrote:
> On Wed, Feb 14, 2018 at 5:53 PM, Santosh Shilimkar
> <santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:

[...]

>>> Hi Santosh,
>>>
>>> What is that fix? You forgot to provide any link/reference. I also
>>> don't see any patches from you at around that date...
>>>
>> Fix [1] was later not added since there was a still a race. Wanted to
>> see if the issue re-appears after recent netns fix [2].
> 
> 
> We will not see if the bug re-appears or not until this bug is closed.
> Please see this recent discussion about another rds bug:
> https://groups.google.com/d/msg/syzkaller-bugs/3XjmOzr5jRU/g7pXIsY1BgAJ
> In the current state syzbot will never report bugs in these functions again.
> 
OK. Can you close that one then in that case ?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

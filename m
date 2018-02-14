From: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Subject: Re: KASAN: use-after-free Read in rds_find_bound
Date: Wed, 14 Feb 2018 09:58:53 -0800
Message-ID: <1088199a-9e37-e879-5b9d-31ab99f552d4@oracle.com>
References: <089e08231920353a4805618b365c@google.com>
 <d91da249-5a0f-7a1f-cfd5-68f10f0a2fc1@oracle.com>
 <CACT4Y+bd6Tyq672JC3GNSHPX2CEHacVKkcbKOAgpi8o-=T8DRg@mail.gmail.com>
 <491a26b8-7abb-0d36-0a2e-e1c7bfcde79d@oracle.com>
 <CACT4Y+YxrNiP==ty-KBjkDewnuS378GmG314-=ytWskZXQx3zw@mail.gmail.com>
 <52478830-f0b5-e400-8101-b329ba35bcef@oracle.com>
 <CACT4Y+aWVFEvVMihw2MBiMgYKMzup4O78c_HrByhRyF8-zfzpw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <CACT4Y+aWVFEvVMihw2MBiMgYKMzup4O78c_HrByhRyF8-zfzpw@mail.gmail.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Dmitry Vyukov <dvyukov@google.com>
Cc: syzbot <syzbot+93a5839deb355537440f@syzkaller.appspotmail.com>, linux-rdma@vger.kernel.org, syzkaller-bugs@googlegroups.com, David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>, rds-devel@oss.oracle.com
List-Id: linux-rdma@vger.kernel.org

On 2/14/2018 9:52 AM, Dmitry Vyukov wrote:
> On Wed, Feb 14, 2018 at 6:35 PM, Santosh Shilimkar
> <santosh.shilimkar@oracle.com> wrote:
>>>>> Hi Santosh,
>>>>>
>>>>> What is that fix? You forgot to provide any link/reference. I also
>>>>> don't see any patches from you at around that date...
>>>>>
>>>> Fix [1] was later not added since there was a still a race. Wanted to
>>>> see if the issue re-appears after recent netns fix [2].
>>>
>>>
>>>
>>> We will not see if the bug re-appears or not until this bug is closed.
>>> Please see this recent discussion about another rds bug:
>>> https://groups.google.com/d/msg/syzkaller-bugs/3XjmOzr5jRU/g7pXIsY1BgAJ
>>> In the current state syzbot will never report bugs in these functions
>>> again.
>>>
>> OK. Can you close that one then in that case ?
> 
> Anybody can do this:
>
I see.

> #syz fix: rds: tcp: use rds_destroy_pending() to synchronize
> netns/module teardown and rds connection/workq management
> 
> syzbot provides full self-service, see first email and in particular this:
> https://github.com/google/syzkaller/blob/master/docs/syzbot.md#communication-with-syzbot
> 
ok will have a look.

Regards,
Santosh

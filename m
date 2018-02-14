From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: KASAN: use-after-free Read in rds_find_bound
Date: Wed, 14 Feb 2018 18:14:23 +0100
Message-ID: <CACT4Y+YxrNiP==ty-KBjkDewnuS378GmG314-=ytWskZXQx3zw@mail.gmail.com>
References: <089e08231920353a4805618b365c@google.com> <d91da249-5a0f-7a1f-cfd5-68f10f0a2fc1@oracle.com>
 <CACT4Y+bd6Tyq672JC3GNSHPX2CEHacVKkcbKOAgpi8o-=T8DRg@mail.gmail.com> <491a26b8-7abb-0d36-0a2e-e1c7bfcde79d@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <491a26b8-7abb-0d36-0a2e-e1c7bfcde79d@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Cc: syzbot <syzbot+93a5839deb355537440f@syzkaller.appspotmail.com>, linux-rdma@vger.kernel.org, syzkaller-bugs@googlegroups.com, David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>, rds-devel@oss.oracle.com
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 14, 2018 at 5:53 PM, Santosh Shilimkar
<santosh.shilimkar@oracle.com> wrote:
>>> On 12/30/17 1:17 AM, syzbot wrote:
>>>>
>>>>
>>>> Hello,
>>>>
>>>> syzkaller hit the following crash on
>>>> fba961ab29e5ffb055592442808bb0f7962e05da
>>>> git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/master
>>>> compiler: gcc (GCC) 7.1.1 20170620
>>>> .config is attached
>>>> Raw console output is attached.
>>>> Unfortunately, I don't have any reproducer for this bug yet.
>>>>
>>>>
>>>> IMPORTANT: if you fix the bug, please add the following tag to the
>>>> commit:
>>>> Reported-by: syzbot+93a5839deb355537440f@syzkaller.appspotmail.com
>>>
>>>
>>>
>>> Posted a fix[1] for above issue. Didn't test it but looks straight
>>> forward.
>>
>>
>>
>> Hi Santosh,
>>
>> What is that fix? You forgot to provide any link/reference. I also
>> don't see any patches from you at around that date...
>>
> Fix [1] was later not added since there was a still a race. Wanted to
> see if the issue re-appears after recent netns fix [2].


We will not see if the bug re-appears or not until this bug is closed.
Please see this recent discussion about another rds bug:
https://groups.google.com/d/msg/syzkaller-bugs/3XjmOzr5jRU/g7pXIsY1BgAJ
In the current state syzbot will never report bugs in these functions again.

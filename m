From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: KMSAN: uninit-value in rds_bind
Date: Thu, 30 Aug 2018 14:05:33 -0700
Message-ID: <CACT4Y+YLLqmq5Qp0N6bDviqC_X5ODmAwjYsRaMAvufzOLg4mFQ@mail.gmail.com>
References: <000000000000010a4d0574ab4743@google.com> <355351e8-71fa-6db9-ad2a-43115cc2e80e@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <355351e8-71fa-6db9-ad2a-43115cc2e80e@oracle.com>
Sender: netdev-owner@vger.kernel.org
To: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Cc: syzbot <syzbot+915c9f99f3dbc4bd6cd1@syzkaller.appspotmail.com>, linux-rdma@vger.kernel.org, netdev <netdev@vger.kernel.org>, syzkaller-bugs <syzkaller-bugs@googlegroups.com>, David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Aug 30, 2018 at 1:56 PM, Santosh Shilimkar
<santosh.shilimkar@oracle.com> wrote:
> On 8/30/2018 11:31 AM, syzbot wrote:
>>
>> Hello,
>>
>> syzbot found the following crash on:
>>
>> HEAD commit:    2dca2cbde67a kmsan: fix build warnings with CONFIG_KMSAN=n
>> git tree:       https://github.com/google/kmsan.git/master
>
>
> BTW, can you please fix your git url since this one doesn't work.

I will fix this. Thanks.

But just to unblock you, it's git repo/branch, i.e.
https://github.com/google/kmsan.git is repo, and branch is master.


> This tree is not vanila kernel.org tree(4.19.0-rc1+ #36), so would be
> good to get the line numbers correct for sources.
>
> Regards,
> Snatosh
>
> --
> You received this message because you are subscribed to the Google Groups
> "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an
> email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit
> https://groups.google.com/d/msgid/syzkaller-bugs/355351e8-71fa-6db9-ad2a-43115cc2e80e%40oracle.com.
>
> For more options, visit https://groups.google.com/d/optout.

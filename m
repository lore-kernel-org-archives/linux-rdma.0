From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: Re: KASAN: use-after-free Read in __rhashtable_lookup (2)
Date: Fri, 24 Aug 2018 16:10:58 -0700
Message-ID: <CACT4Y+a6P+q8jtRrd=cAf5hWbqQO4CQdWUaCCX-ygRbGsWHnGQ@mail.gmail.com>
References: <20180824230446.GA16891@oracle.com> <000000000000d8879a05743667a2@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <000000000000d8879a05743667a2@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: syzbot <syzbot+8967084bcac563795dc6@syzkaller.appspotmail.com>
Cc: Sowmini Varadhan <sowmini.varadhan@oracle.com>, David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org, netdev <netdev@vger.kernel.org>, rds-devel@oss.oracle.com, Santosh Shilimkar <santosh.shilimkar@oracle.com>, syzkaller-bugs <syzkaller-bugs@googlegroups.com>
List-Id: linux-rdma@vger.kernel.org

On Fri, Aug 24, 2018 at 4:05 PM, syzbot
<syzbot+8967084bcac563795dc6@syzkaller.appspotmail.com> wrote:
>
>
>> #syz dup KASAN: use-after-free Read in rds_find_bound
>
>
> unknown command "dup"


You need a colon after dup.

But this can't possibly be a dup of that bug. That bug was fixed in February:
https://syzkaller.appspot.com/bug?extid=93a5839deb355537440f

And this crash happened a day ago. This is a different bug. If you dup
it to a closed one, this one will also be considered closed, and then
a new crash will immediately create a new bug.



>> The problem is a missing synchronize_net() in rds_release.
>> References:
>>    https://www.spinics.net/lists/netdev/msg475074.html
>>    https://www.spinics.net/lists/netdev/msg507908.html
>
>
>> --
>> You received this message because you are subscribed to the Google Groups
>> "syzkaller-bugs" group.
>> To unsubscribe from this group and stop receiving emails from it, send an
>> email to syzkaller-bugs+unsubscribe@googlegroups.com.
>> To view this discussion on the web visit
>> https://groups.google.com/d/msgid/syzkaller-bugs/20180824230446.GA16891%40oracle.com.
>> For more options, visit https://groups.google.com/d/optout.
>
>
> --
> You received this message because you are subscribed to the Google Groups
> "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an
> email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit
> https://groups.google.com/d/msgid/syzkaller-bugs/000000000000d8879a05743667a2%40google.com.
>
> For more options, visit https://groups.google.com/d/optout.

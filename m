From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: KASAN: use-after-free Read in __rhashtable_lookup (2)
Date: Fri, 24 Aug 2018 16:50:48 -0700
Message-ID: <CACT4Y+Y=d_AKpPQ494kVv4vmFMizwzgKFo6Lvit+Zw7TFU_+ng@mail.gmail.com>
References: <20180824230446.GA16891@oracle.com> <000000000000d8879a05743667a2@google.com>
 <CACT4Y+a6P+q8jtRrd=cAf5hWbqQO4CQdWUaCCX-ygRbGsWHnGQ@mail.gmail.com> <20180824233700.GC31961@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180824233700.GC31961@oracle.com>
Sender: netdev-owner@vger.kernel.org
To: Sowmini Varadhan <sowmini.varadhan@oracle.com>
Cc: syzbot <syzbot+8967084bcac563795dc6@syzkaller.appspotmail.com>, David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org, netdev <netdev@vger.kernel.org>, rds-devel@oss.oracle.com, Santosh Shilimkar <santosh.shilimkar@oracle.com>, syzkaller-bugs <syzkaller-bugs@googlegroups.com>
List-Id: linux-rdma@vger.kernel.org

On Fri, Aug 24, 2018 at 4:37 PM, Sowmini Varadhan
<sowmini.varadhan@oracle.com> wrote:
> On (08/24/18 16:10), Dmitry Vyukov wrote:
>> You need a colon after dup.
>
> I see.
>
>> But this can't possibly be a dup of that bug. That bug was fixed in February:
>
> Apologies, I unknowingly made a mistake in my
> syzbot-tiquette in that case,
>
> I did not intend to *close* the bug as a dup, I was
> merely trying to indicate that this is yet another
> manifestation of the original report with subject
> "KASAN: use-after-free Read in rds_find_bound"
>
> All of these problems are happening because we are missing
> a synchronize_net() in rds_release.
>
> A full description of the race conditon can be found in
> https://www.spinics.net/lists/netdev/msg475074.html
>
> If rds_release is going to nuke the rds_socket
> it needs to sychronize_net() with other threads that may be
> looking up the bind_hash_table. If we dont do that,
> all of these "use-after-free" races can happen.
> As long as we dont have the synchronize_net() we are
> missing a big (and standard) bit of RCU synchronization.


If it's a note for humans, then just a plain English comment will do.

From: Sowmini Varadhan <sowmini.varadhan@oracle.com>
Subject: Re: KASAN: use-after-free Read in __rhashtable_lookup (2)
Date: Fri, 24 Aug 2018 19:37:00 -0400
Message-ID: <20180824233700.GC31961@oracle.com>
References: <20180824230446.GA16891@oracle.com>
 <000000000000d8879a05743667a2@google.com>
 <CACT4Y+a6P+q8jtRrd=cAf5hWbqQO4CQdWUaCCX-ygRbGsWHnGQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACT4Y+a6P+q8jtRrd=cAf5hWbqQO4CQdWUaCCX-ygRbGsWHnGQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dmitry Vyukov <dvyukov@google.com>
Cc: syzbot <syzbot+8967084bcac563795dc6@syzkaller.appspotmail.com>, David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org, netdev <netdev@vger.kernel.org>, rds-devel@oss.oracle.com, Santosh Shilimkar <santosh.shilimkar@oracle.com>, syzkaller-bugs <syzkaller-bugs@googlegroups.com>
List-Id: linux-rdma@vger.kernel.org

On (08/24/18 16:10), Dmitry Vyukov wrote:
> You need a colon after dup.

I see.

> But this can't possibly be a dup of that bug. That bug was fixed in February:

Apologies, I unknowingly made a mistake in my 
syzbot-tiquette in that case,

I did not intend to *close* the bug as a dup, I was
merely trying to indicate that this is yet another 
manifestation of the original report with subject
"KASAN: use-after-free Read in rds_find_bound"

All of these problems are happening because we are missing
a synchronize_net() in rds_release.

A full description of the race conditon can be found in
https://www.spinics.net/lists/netdev/msg475074.html

If rds_release is going to nuke the rds_socket
it needs to sychronize_net() with other threads that may be
looking up the bind_hash_table. If we dont do that,
all of these "use-after-free" races can happen.
As long as we dont have the synchronize_net() we are
missing a big (and standard) bit of RCU synchronization.

--Sowmini

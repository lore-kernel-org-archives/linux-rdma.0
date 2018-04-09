From: Sowmini Varadhan <sowmini.varadhan@oracle.com>
Subject: Re: KASAN: use-after-free Read in inet_create
Date: Sun, 8 Apr 2018 21:04:31 -0400
Message-ID: <20180409010431.GA32646@oracle.com>
References: <001a1144d1c8e819f6055fee7118@google.com>
 <20180408231756.GI685@sol.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180408231756.GI685@sol.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Biggers <ebiggers3@gmail.com>
Cc: linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com, Santosh Shilimkar <santosh.shilimkar@oracle.com>, syzbot <bot+db99bd25cd19d3347dbf8c05d7dd3ca9bab2d7ad@syzkaller.appspotmail.com>, davem@davemloft.net, kuznet@ms2.inr.ac.ru, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
List-Id: linux-rdma@vger.kernel.org


#syz dup: KASAN: use-after-free Read in rds_cong_queue_updates

There  are a number of manifestations of this bug, basically
all suggest that the connect/reconnect etc workqs are somehow
being scheduled after the netns is deleted, despite the
code refactoring in Commit  3db6e0d172c (and looks like
the WARN_ONs in that commit are not even being triggered).
We've not been able to reproduce this issues, and without
a crash dump (or some hint of other threads that were running
at the time of the problem) are working on figuring out
the root-cause by code-inspection.

--Sowmini

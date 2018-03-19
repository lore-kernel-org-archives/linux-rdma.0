From: Sowmini Varadhan <sowmini.varadhan@oracle.com>
Subject: Re: KASAN: slab-out-of-bounds Read in rds_cong_queue_updates
Date: Mon, 19 Mar 2018 02:37:08 -0400
Message-ID: <20180319063708.GB20345@oracle.com>
References: <001a114aacf82781120565c9f4fe@google.com>
 <CACT4Y+Y_K_GQq0ZgwMNEWuHx6k3BWQZKCoNT8BOWsB-mxL2Szw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACT4Y+Y_K_GQq0ZgwMNEWuHx6k3BWQZKCoNT8BOWsB-mxL2Szw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dmitry Vyukov <dvyukov@google.com>
Cc: syzbot <syzbot+80c06fb3aabfa386bc06@syzkaller.appspotmail.com>, David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org, netdev <netdev@vger.kernel.org>, rds-devel@oss.oracle.com, Santosh Shilimkar <santosh.shilimkar@oracle.com>, syzkaller-bugs@googlegroups.com
List-Id: linux-rdma@vger.kernel.org

On (03/19/18 09:29), Dmitry Vyukov wrote:
> 
> This looks the same as:
> 
> #syz dup: KASAN: use-after-free Read in rds_cong_queue_updates

correct, seems like the rds_destroy_pending() fixes did not seal
this race condition. I need to look at this more carefully to see
what race I missed.. no easy answer here, I am afraid.

--Sowmini

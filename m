From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] IB/srpt: Revert "Convert to percpu_ida tag allocation"
Date: Thu, 07 Apr 2016 16:37:04 -0700
Message-ID: <1460072224.18732.67.camel@haakon3.risingtidesystems.com>
References: <57055BC6.7070402@sandisk.com> <5706E548.3080002@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <5706E548.3080002@sandisk.com>
Sender: target-devel-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Doug Ledford <dledford@redhat.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2016-04-07 at 15:55 -0700, Bart Van Assche wrote:
> That patch causes the ib_srpt driver to crash as soon as the first
> SCSI command is received. This means that that patch was untested.
> Hence revert it. The shortcomings of that patch are as follows:
> - It makes the ib_srpt driver use I/O contexts allocated by
>   transport_alloc_session_tags() but it does not initialize these
>   I/O contexts properly. All the initializations performed by
>   srpt_alloc_ioctx() are skipped.
> - It swaps the order of the send ioctx allocation and the transition
>   to RTR mode which is wrong.
> - The amount of memory that is needed for I/O contexts is doubled.
> - srpt_rdma_ch.free_list is no longer used but is not removed.
> 
> Revert commit 0fd10721fe36 and thereby fix the following kernel crash:
> 
> kernel BUG at drivers/infiniband/ulp/srpt/ib_srpt.c:1439!
> invalid opcode: 0000 [#1] SMP
> Workqueue: target_completion target_complete_ok_work [target_core_mod]
> RIP: 0010:[<ffffffffa052ef37>]  [<ffffffffa052ef37>] srpt_queue_response+0x437/0x4a0 [ib_srpt]
> Call Trace:
>  [<ffffffffa052f009>] srpt_queue_data_in+0x9/0x10 [ib_srpt]
>  [<ffffffffa04f1ee2>] target_complete_ok_work+0x152/0x2b0 [target_core_mod]
>  [<ffffffff81071ea7>] process_one_work+0x197/0x480
>  [<ffffffff810721d9>] worker_thread+0x49/0x490
>  [<ffffffff8107878a>] kthread+0xea/0x100
>  [<ffffffff8159b172>] ret_from_fork+0x22/0x40
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Nicholas Bellinger <nab@linux-iscsi.org>

Please stop trying to bypass target-pending for your target related
patches.

I've already asked you not to revert the patch, because I'm working on a
patch to address the v4.6-rc regression here:

http://www.spinics.net/lists/target-devel/msg12535.html

If you've found a bug in that patch, please comment in that thread, or
even better send an incremental diff for what you've found.

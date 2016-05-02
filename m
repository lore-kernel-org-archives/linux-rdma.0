From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: generic RDMA READ/WRITE API V6
Date: Mon, 2 May 2016 12:08:55 -0700
Message-ID: <5727A5C7.1090009@sandisk.com>
References: <1460410360-13104-1-git-send-email-hch@lst.de>
 <571AA5C8.4080502@sandisk.com> <20160502151535.GA520@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160502151535.GA520-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 05/02/2016 08:15 AM, Christoph Hellwig wrote:
> On Fri, Apr 22, 2016 at 03:29:28PM -0700, Bart Van Assche wrote:
>> On 04/11/2016 02:32 PM, Christoph Hellwig wrote:
>>> 	git://git.infradead.org/users/hch/rdma.git rdma-rw-api
>>
>> Hello Christoph,
>>
>> Is the version that has been pushed on April 18 the latest and greatest
>> version of this patch series ?
>
> Should be.  I've pushed out a new version, but the only changes are
> in response to your small review comments, and a no-op rebase to Doug's
> latest tree.
>
>> I'm asking because with that version I see
>> error messages appearing that I hadn't seen with the previous version:
>>
>> ib_srpt:srpt_qp_event: ib_srpt QP event 16 on cm_id=ffff8801713d5628
>> sess_name=0x0000000000000000e41d2d03000a85b1 state=1
>> ib_srpt:srpt_qp_event: ib_srpt 0x0000000000000000e41d2d03000a85b1-522,
>> state live: received Last WQE event.
>> ib_srpt RDMA_READ for ioctx 0xffff8804593092a8 failed with status 4
>>
>> This test was run with the force_mr=Y:
>>
>> $ cat /etc/modprobe.d/ib_core.conf
>> options ib_core force_mr=Y
>
> I haven't been able to reproduce this with my usual xfstests run
> on mlx4 hardware.  What did you do to reproduce the issue, and what
> hardware were you using?

After having disabled CONFIG_SLUB_DEBUG_ON I don't see the "QP event" 
message anymore. But running xfstests triggered the following (mlx4 
hardware; SRP initiator and LIO target running on the same server and 
communicating over loopback):

WARNING: CPU: 11 PID: 9224 at drivers/infiniband/ulp/srpt/ib_srpt.c:1209 
srpt_rdma_read_done+0xc7/0x110 [ib_srpt]
Call Trace:
  [<ffffffff812c0bf5>] dump_stack+0x67/0x92
  [<ffffffff81058011>] __warn+0xc1/0xe0
  [<ffffffff810580e8>] warn_slowpath_null+0x18/0x20
  [<ffffffffa05db7c7>] srpt_rdma_read_done+0xc7/0x110 [ib_srpt]
  [<ffffffffa045c73b>] __ib_process_cq+0x4b/0xd0 [ib_core]
  [<ffffffffa045c82b>] ib_cq_poll_work+0x1b/0x60 [ib_core]
  [<ffffffff81071fea>] process_one_work+0x19a/0x490
  [<ffffffff81071f8a>] ? process_one_work+0x13a/0x490
  [<ffffffff81072329>] worker_thread+0x49/0x490
  [<ffffffff810722e0>] ? process_one_work+0x490/0x490
  [<ffffffff810788da>] kthread+0xea/0x100
  [<ffffffff8159e632>] ret_from_fork+0x22/0x40

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

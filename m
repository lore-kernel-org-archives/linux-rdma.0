From: Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org>
Subject: Re: [Scst-devel] [ofa-general] WinOF_2_0_5/SRP initiator: slow	reads
 and eventually hangs
Date: Wed, 16 Sep 2009 22:15:28 +0400
Message-ID: <4AB12B40.9050902@vlnb.net>
References: <f3177b9e0908091009x23813cbdq4fbd9ebe6d8e174f@mail.gmail.com>	<4AAE909F.6030202@vlnb.net>	<f3177b9e0909141603j2dc61663j4c6bbcc0dda631d4@mail.gmail.com>	<e2e108260909142310vb353718uea99d50ab638a865@mail.gmail.com>	<f3177b9e0909150850r2d0f5e15id7f4e14b015f68ed@mail.gmail.com>	<4AAFC42D.4030708@vlnb.net>	<f3177b9e0909150953x11d19210mf07cbdcc57928d42@mail.gmail.com>	<4AAFC794.7090205@vlnb.net>	<f3177b9e0909151001i61027dd9y282e2f98a8f05b03@mail.gmail.com>	<4AAFCA77.6050305@vlnb.net> <f3177b9e0909151351p12173c78oe01cc8bcca957550@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <f3177b9e0909151351p12173c78oe01cc8bcca957550-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, scst-devel <scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, OpenIB <general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Chris Worley, on 09/16/2009 12:51 AM wrote:
> On Tue, Sep 15, 2009 at 11:10 AM, Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org> wrote:
>> Chris Worley, on 09/15/2009 09:01 PM wrote:
>>> On Tue, Sep 15, 2009 at 10:57 AM, Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org>
>>> wrote:
>>>> Chris Worley, on 09/15/2009 08:53 PM wrote:
>>>>> On Tue, Sep 15, 2009 at 10:43 AM, Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org>
>>>>> wrote:
>>>>>> Chris Worley, on 09/15/2009 07:50 PM wrote:
>>>>>>> On Tue, Sep 15, 2009 at 12:10 AM, Bart Van Assche
>>>>>>> <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>>>>>>> On Tue, Sep 15, 2009 at 1:03 AM, Chris Worley <worleys-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>>>>>>> wrote:
>>>>>>>>> On Mon, Sep 14, 2009 at 12:51 PM, Vladislav Bolkhovitin
>>>>>>>>> <vst-d+Crzxg7Rs0@public.gmane.org>
>>>>>>>>> wrote:
>>>>>>>>>> Chris Worley, on 09/11/2009 11:50 PM wrote:
>>>>>>>>>>> I've definitely removed the switch/firmware from being the cause.
>>>>>>>>>>>
>>>>>>>>>>> I'm thinking the reason you can't repeat the test may be latency
>>>>>>>>>>> related.  We get ~50usecs average latency (on small block sizes),
>>>>>>>>>>> which can't be achieved using regular SSD's (and rotating drives
>>>>>>>>>>> are
>>>>>>>>>>> nowhere close).  Maybe a ramdisk would help repeat the issue.
>>>>>>>>>> I think you should try to reproduce the problem with ramdisk or
>>>>>>>>>> nullio.
>>>>>>>>>> By
>>>>>>>>>> so you will eliminate possible influence of the SSD backend.
>>>>>>>>> W/ 12GB RAM in the target, I created a 7GB ramdisk:
>>>>>>>>>
>>>>>>>>> mount -t ramfs -o size=7g ramfs /mnt/
>>>>>>>>> dd if=/dev/zero of=/mnt/foo bs=1024k count=7000
>>>>>>>>> echo "open ramdisk /mnt/foo" > /proc/scsi_tgt/vdisk/vdisk
>>>>>>>>> echo "add ramdisk 2" >/proc/scsi_tgt/groups/Default/devices
>>>>>>>>>
>>>>>>>>> Then, on the initiator, I tested it... and it hung during sequential
>>>>>>>>> 8KB block reads:
>>>>>>>>>
>>>>>>>>> fio --rw=read --bs=8k --numjobs=64 --iodepth=64 --sync=0 --direct=1
>>>>>>>>> --randrepeat=0 \
>>>>>>>>>  --group_reporting --ioengine=libaio --filename=/dev/sde --name=test
>>>>>>>>> --loops=10000 --runtime=600
>>>>>>>>>
>>>>>>>>> Note that I was running the SM on the target this time too.
>>>>>>>> Which Linux distro was installed on the inititiator and on the target
>>>>>>>> ? And if applicable, which OFED version ? Which kernel messages were
>>>>>>>> logged by SRPT around the time the issue occurred (after having
>>>>>>>> enabled SRPT logging first) ?
>>>>>>> As logging hadn't helped this issue previously, I've not been enabling
>>>>>>> it.  That plus the kernel hacks needed to invoke logging, it's not
>>>>>>> worth enabling.
>>>>>>>
>>>>>>> This was with Ubuntu 8.10, built-in IB on the 2.6.27-14-server kernel.
>>>>>>>
>>>>>>> I couldn't get ramdisks working w/ SCST in RHEL5.2.  When running:
>>>>>>>
>>>>>>> echo "open ramdisk /mnt/foo" > /proc/scsi_tgt/vdisk/vdisk
>>>>>>>
>>>>>>> I get the error:
>>>>>>>
>>>>>>> dev_vdisk: ***ERROR***: Wrong f_op or FS doesn't have required
>>>>>>> capabilities
>>>>>>>
>>>>>>> ... which doesn't occur in the Ubuntu kernel, so I've been unable to
>>>>>>> test RHEL kernels w/ ramdisks.  In general, this problem occurs w/ 8KB
>>>>>>> and smaller blocks w/ the Ubuntu kernels, and 2KB and smaller blocks
>>>>>>> w/ RHEL kernels.
>>>>>> Use ramfs instead.
>>>>> Do you mean:
>>>>>
>>>>> mount -t ramfs -o size=7g ramfs /mnt/
>>>> You should then create a file on it and use it.
>>> That's what I'm doing, I believe.  From above:
>>>
>>>>>>>>> mount -t ramfs -o size=7g ramfs /mnt/
>>>>>>>>> dd if=/dev/zero of=/mnt/foo bs=1024k count=7000
>>>>>>>>> echo "open ramdisk /mnt/foo" > /proc/scsi_tgt/vdisk/vdisk
>>>>>>>>> echo "add ramdisk 2" >/proc/scsi_tgt/groups/Default/devices
>>> ... but the "open", on RHEL5.2 kernel 2.6.18-92.el5, generates the
>>> following kernel messages:
>>>
>>> dev_vdisk: Registering virtual FILEIO device ramdisk
>>> scst: Processing thread started, PID 9629
>>> scst: Processing thread started, PID 9630
>>> scst: Processing thread started, PID 9631
>>> scst: Processing thread started, PID 9632
>>> scst: Processing thread started, PID 9633
>>> dev_vdisk: ***ERROR***: Wrong f_op or FS doesn't have required
>>> capabilities
>>> scst: ***ERROR***: New device handler's vdisk attach() failed: -22
>>> scst: Processing thread PID 9629 finished
>>> scst: Processing thread PID 9630 finished
>>> scst: Processing thread PID 9631 finished
>>> scst: Processing thread PID 9632 finished
>>> scst: Processing thread PID 9633 finished
>>> scst: Failed to attach to virtual device ramdisk
>>>
>>> Chris
>>>>> ?
>>>>>
>>>>> That's what I'm doing.
>> That's strange. I'm doing it all the time, although with not so old kernels
>> as 2.6.18.
> 
> In lots of testing today, I've seen this panic twice on the Ubuntu 8.10 targets:
> 
> [  330.155992] ib_srpt: disconnected session
> 0x00247100000000460024710000000046 because a new SRP_LOGIN_REQ has
> been received.
> [  357.207046] ib_srpt: srpt_xmit_response: tag= 17 channel in bad state 2
> [  357.207052] ib_srpt: disconnected session
> 0x00247100000000460024710000000046 because a new SRP_LOGIN_REQ has
> been received.
> [  357.207100] ib_srpt: srpt_xmit_response: tag= 47 channel in bad state 2
> [  357.207104] scst: ***ERROR***: Target driver ib_srpt
> xmit_response() returned fatal error
> [  357.241429] scst: ***ERROR***: Target driver ib_srpt
> xmit_response() returned fatal error
> [  357.250234] ------------[ cut here ]------------
> [  357.250537] ib_srpt: srpt_xmit_response: tag= 26 channel in bad state 2
> [  357.250539] scst: ***ERROR***: Target driver ib_srpt
> xmit_response() returned fatal error
> [  357.250550] ib_srpt: srpt_xmit_response: tag= 38 channel in bad state 2
> [  357.250553] scst: ***ERROR***: Target driver ib_srpt
> xmit_response() returned fatal error
> [  357.250560] ib_srpt: srpt_xmit_response: tag= 27 channel in bad state 2
> <repeated many times>
> [  357.301253] kernel BUG at /root/scst/scst/src/scst_targ.c:3089!
> [  357.301253] invalid opcode: 0000 [1] SMP
> [  357.301253] CPU 0
> ...
> [  357.301253] RIP: 0010:[<ffffffffa04759f6>]  [<ffffffffa04759f6>]
> scst_tgt_cmd_done+0x26/0x30 [scst]
> [  357.301253] RSP: 0018:ffff88039ad27b50  EFLAGS: 00010297
> [  357.301253] RAX: 0000000000000200 RBX: ffff8803ad9c68f8 RCX: 0000000000000000
> [  357.301253] RDX: 00000000ffffffff RSI: 0000000000000000 RDI: ffff8803ad9c68f8
> [  357.301253] RBP: ffff88039ad27b50 R08: 0000000000000000 R09: 0000000000000000
> [  357.301253] R10: ffff88039ad277c0 R11: ffff88041ad278cf R12: ffff8803c2972180
> [  357.301253] R13: ffff88039ada0000 R14: 0000000000000001 R15: ffff8803fb00c2b0
> [  357.301253] FS:  0000000000000000(0000) GS:ffffffff807dd000(0000)
> knlGS:0000000000000000
> [  357.301253] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> [  357.301253] CR2: 00007f9281e64000 CR3: 0000000000201000 CR4: 00000000000006e0
> [  357.301253] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  357.301253] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [  357.301253] Process ib_cm/0 (pid: 8299, threadinfo
> ffff88039ad26000, task ffff88039ad40000)
> [  357.301253] Stack:  ffff88039ad27b80 ffffffffa04c0c47
> ffff88039a8db900 ffff8803c2972180
> [  357.301253]  ffff8803fb00c240 ffff8803fb00c284 ffff88039ad27bc0
> ffffffffa04c0d93
> [  357.301253]  ffff88042a4959c0 ffff88042a9d7800 ffff88042544da00
> ffff88042a9d7898
> [  357.301253] Call Trace:
> [  357.301253]  [<ffffffffa04c0c47>] srpt_abort_scst_cmd+0xd7/0x160 [ib_srpt]
> [  357.301253]  [<ffffffffa04c0d93>] srpt_release_channel+0xc3/0x190 [ib_srpt]
> [  357.301253]  [<ffffffffa04c0e82>]
> srpt_find_and_release_channel+0x22/0x30 [ib_srpt]
> [  357.301253]  [<ffffffffa04c227d>] srpt_cm_handler+0x6d/0xbb8 [ib_srpt]

It's because srpt called scst_tgt_cmd_done() when the corresponding 
command hasn't yet been sent to xmit_response() callback, so srpt should 
use another function to abort commands in this state.

Vlad

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

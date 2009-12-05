From: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [ofa-general] [Bug 14235] New: SRP initiator lockup
Date: Sat, 5 Dec 2009 18:44:22 +0100
Message-ID: <e2e108260912050944k1228e964ta7a70dde493ba010@mail.gmail.com>
References: <bug-14235-11804@http.bugzilla.kernel.org/>
	 <ada63b3xcdt.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ada63b3xcdt.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Sep 28, 2009 at 5:27 PM, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> wrot=
e:
>
> =A0> If an SRP target processes SRP I/O slow enough, the SRP initiato=
r locks up.
>
> =A0> INFO: task fio:6389 blocked for more than 120 seconds.
> =A0> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this=
 message.
> =A0> fio =A0 =A0 =A0 =A0 =A0 D 0000000000000000 =A0 =A0 0 =A06389 =A0=
 6388 0x00000000
> =A0> =A0ffff880071dc5bd8 0000000000000046 ffff880071dc5b08 0000000181=
07764d
> =A0> =A00000000000012cc0 000000000000de20 0000000000000001 ffff880070=
cd8000
> =A0> =A0ffff880070cd83b0 0000000100000000 000000010001193e ffff88007f=
b99050
> =A0> Call Trace:
> =A0> =A0[<ffffffff812ec5e5>] ? _spin_unlock_irqrestore+0x65/0x80
> =A0> =A0[<ffffffff812e9b37>] io_schedule+0x37/0x50
> =A0> =A0[<ffffffff8110cff2>] __blockdev_direct_IO+0x692/0xd80
> =A0> =A0[<ffffffff810e0357>] ? get_super+0x27/0xc0
> =A0> =A0[<ffffffff8110b169>] blkdev_direct_IO+0x49/0x50
> =A0> =A0[<ffffffff8110a1f0>] ? blkdev_get_blocks+0x0/0xc0
> =A0> =A0[<ffffffff810a1799>] generic_file_aio_read+0x679/0x690
> =A0> =A0[<ffffffff810dc35a>] ? __dentry_open+0x13a/0x340
> =A0> =A0[<ffffffff810de091>] do_sync_read+0xf1/0x140
> =A0> =A0[<ffffffff810775ed>] ? trace_hardirqs_on_caller+0x14d/0x1a0
> =A0> =A0[<ffffffff810662f0>] ? autoremove_wake_function+0x0/0x40
> =A0> =A0[<ffffffff810775ed>] ? trace_hardirqs_on_caller+0x14d/0x1a0
> =A0> =A0[<ffffffff8107764d>] ? trace_hardirqs_on+0xd/0x10
> =A0> =A0[<ffffffff810ded28>] vfs_read+0xc8/0x180
> =A0> =A0[<ffffffff810deed0>] sys_read+0x50/0x90
> =A0> =A0[<ffffffff8100be6b>] system_call_fastpath+0x16/0x1b
> =A0> no locks held by fio/6389.
>
> It will probably be a while until I can get the time to build an scst
> test set up to reproduce this unfortunately. =A0So we'll have to debu=
g
> this with your set up for the moment.
>
> I don't have a good idea of where in the SRP initiator the problem co=
uld
> be... the non-error path for ordinary SCSI commands is pretty trivial=
=2E
> Presumably slowing down the target means that the queue of outstandin=
g
> commands fills up, but they should complete and let things make
> progress. =A0I guess the possibilities are a bug higher up in the blo=
ck or
> SCSI stack, or some accounting problem in SRP.
>
> You could try adding printks to srp_queuecommand() to see that all SC=
SI
> commands are sent on the SRP connection and also add tracing to
> srp_process_rsp() to make sure there's a matching call to ->scsi_done
> for each SCSI command. =A0And also we should make sure there's no
> disconnections or task management commands or anything like that
> confusing things ... there is definitely more room for bugs in the pa=
rts
> of the SRP driver that handle exceptions.

(replying to an e-mail of two months ago -- finally got the time to
have a closer look at the SRP initiator source code)

I'm not sure that the non-error path for ordinary SCSI commands is
that trivial. If my interpretation of the SRP initiator source code is
correct, the statements complete(&target->done) and
init_completion(&target->done) can be executed concurrently. Although
I do not know what the exact consequences are, and although I do not
know whether this is related to the issue I reported, this is a race
condition. I'm not sure that allowing such races is good kernel
programming practice.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

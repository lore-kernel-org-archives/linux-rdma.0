From: Roland Dreier <rdreier@cisco.com>
Subject: Re: [ofa-general] [Bug 14235] New: SRP initiator lockup
Date: Mon, 28 Sep 2009 09:27:58 -0700
Message-ID: <ada63b3xcdt.fsf@cisco.com>
References: <bug-14235-11804@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <general-bounces@lists.openfabrics.org>
In-Reply-To: <bug-14235-11804@http.bugzilla.kernel.org/>
	(bugzilla-daemon@bugzilla.kernel.org's message of "Sat, 26 Sep 2009
	14:54:37 GMT")
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general>,
	<mailto:general-request@lists.openfabrics.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/general>
List-Post: <mailto:general@lists.openfabrics.org>
List-Help: <mailto:general-request@lists.openfabrics.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/general>,
	<mailto:general-request@lists.openfabrics.org?subject=subscribe>
Sender: general-bounces@lists.openfabrics.org
Errors-To: general-bounces@lists.openfabrics.org
To: bart.vanassche@gmail.com
Cc: linux-rdma@vger.kernel.org, general@lists.openfabrics.org
List-Id: linux-rdma@vger.kernel.org


 > If an SRP target processes SRP I/O slow enough, the SRP initiator locks up.

 > INFO: task fio:6389 blocked for more than 120 seconds.
 > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
 > fio           D 0000000000000000     0  6389   6388 0x00000000
 >  ffff880071dc5bd8 0000000000000046 ffff880071dc5b08 000000018107764d
 >  0000000000012cc0 000000000000de20 0000000000000001 ffff880070cd8000
 >  ffff880070cd83b0 0000000100000000 000000010001193e ffff88007fb99050
 > Call Trace:
 >  [<ffffffff812ec5e5>] ? _spin_unlock_irqrestore+0x65/0x80
 >  [<ffffffff812e9b37>] io_schedule+0x37/0x50
 >  [<ffffffff8110cff2>] __blockdev_direct_IO+0x692/0xd80
 >  [<ffffffff810e0357>] ? get_super+0x27/0xc0
 >  [<ffffffff8110b169>] blkdev_direct_IO+0x49/0x50
 >  [<ffffffff8110a1f0>] ? blkdev_get_blocks+0x0/0xc0
 >  [<ffffffff810a1799>] generic_file_aio_read+0x679/0x690
 >  [<ffffffff810dc35a>] ? __dentry_open+0x13a/0x340
 >  [<ffffffff810de091>] do_sync_read+0xf1/0x140
 >  [<ffffffff810775ed>] ? trace_hardirqs_on_caller+0x14d/0x1a0
 >  [<ffffffff810662f0>] ? autoremove_wake_function+0x0/0x40
 >  [<ffffffff810775ed>] ? trace_hardirqs_on_caller+0x14d/0x1a0
 >  [<ffffffff8107764d>] ? trace_hardirqs_on+0xd/0x10
 >  [<ffffffff810ded28>] vfs_read+0xc8/0x180
 >  [<ffffffff810deed0>] sys_read+0x50/0x90
 >  [<ffffffff8100be6b>] system_call_fastpath+0x16/0x1b
 > no locks held by fio/6389.

It will probably be a while until I can get the time to build an scst
test set up to reproduce this unfortunately.  So we'll have to debug
this with your set up for the moment.

I don't have a good idea of where in the SRP initiator the problem could
be... the non-error path for ordinary SCSI commands is pretty trivial.
Presumably slowing down the target means that the queue of outstanding
commands fills up, but they should complete and let things make
progress.  I guess the possibilities are a bug higher up in the block or
SCSI stack, or some accounting problem in SRP.

You could try adding printks to srp_queuecommand() to see that all SCSI
commands are sent on the SRP connection and also add tracing to
srp_process_rsp() to make sure there's a matching call to ->scsi_done
for each SCSI command.  And also we should make sure there's no
disconnections or task management commands or anything like that
confusing things ... there is definitely more room for bugs in the parts
of the SRP driver that handle exceptions.

 - R.

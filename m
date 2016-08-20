From: james harvey <jamespharvey20-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: 4.7.0 ib_srpt Regression - 4.6.4 Got failed path rec status -22 got
 worse on 4.7.0
Date: Sat, 20 Aug 2016 01:21:14 -0400
Message-ID: <CA+X5Wn46GGnqijVS54A_45_D8g_0cvcZ3iAYbt2J6syiKwqNGA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

I have booting over SRP working.

iPXE makes a SRP connection, creates an ACPI-based sBFT table leaving
behind the connection information.  The bootloader (I'm using
syslinux) successfully loads the kernel and initrd, a new ib_sbft
kernel module creates a sysfs interface to the sBFT table, and a new
srp-boot script connects to the SRP devices.

I needed to write about a problem with "ib_srp: Got failed path rec
status -22" causing a 10-30 second connection delay on linux's SRP
connection, which is the second one after iPXE's , but with
interesting timing, 4.7.0 has a regression that turns the 10-30 second
delay into a permanent failure.

So, the SRP booting only works if the target is on kernel < 4.7.0
(4.6.4.)  Initiator works on 4.7.1.

For those interested:
* ib_sbft kernel module, and patch to iPXE, see
https://github.com/jamespharvey20/ib_sbft
* script to mount SRP devices in initramfs, see
https://github.com/jamespharvey20/srp-boot

Ultimately, the cause issue is that iPXE never performs an initiator
logout.  I'm working on seeing if that can be added.

Through ib_srpt 4.6.4, linux's SRP connection initially errors with:
=====
scsi host7: ib_srp: Got failed path rec status -22
scsi host7: ib_srp: Path record query failed
scsi host7: ib_srp: Connection 0/4 failed
scsi host7: ib_srp: Sending CM DREQ failed
=====

I believe this error is coming from
linux/drivers/infiniband/ulp/srp/ib_srp.c::srp_path_rec_completion()

The only reference I can find to status -22 is an Oracle document,
saying this can happen if the I/O path to the active target is
interrupted via a link failure or cluster takeover.  Sounds similar to
what's going on here, with the original iPXE SRP connection being
hijacked by the (second) linux connection.

But within 10-30 seconds, attempting again succeeds.  So, I
implemented a 100-times retry with 1 second delay in my srp-boot
script.  It works, with the delay.  The 4.6.4 target logs show:

=====
[   91.870131] ib_srpt Received SRP_LOGIN_REQ with i_port_id
0x1d534b0003c90200:0x2c903004b5275, t_port_id
0x2c903004b531c:0x2c903004b531c and it_iu_len 80 on port 1
(guid=0xfe80000000000000:0x2c903004b531d)
[   91.877392] ib_srpt truncated sense data from 96 to 44 bytes
[  115.941400] ib_srpt Received SRP_LOGIN_REQ with i_port_id
0x1d534b0003c90200:0x2c903004b5275, t_port_id
0x2c903004b531c:0x2c903004b531c and it_iu_len 260 on port 1
(guid=0xfe80000000000000:0x2c903004b531d)
[  115.941418] ib_srpt Relogin - closed existing channel
0x1d534b0003c902000002c903004b5275
[  115.941470] ib_srpt Received CM DREP message for ch
0x1d534b0003c902000002c903004b5275-522.
[  115.952702] ib_srpt Received SRP_LOGIN_REQ with i_port_id
0x1d534b0003c90200:0x2c903004b5275, t_port_id
0x2c903004b531c:0x2c903004b531c and it_iu_len 260 on port 1
(guid=0xfe80000000000000:0x2c903004b531d)
[  115.964149] ib_srpt Received SRP_LOGIN_REQ with i_port_id
0x1d534b0003c90200:0x2c903004b5275, t_port_id
0x2c903004b531c:0x2c903004b531c and it_iu_len 260 on port 1
(guid=0xfe80000000000000:0x2c903004b531d)
[  115.975708] ib_srpt Received SRP_LOGIN_REQ with i_port_id
0x1d534b0003c90200:0x2c903004b5275, t_port_id
0x2c903004b531c:0x2c903004b531c and it_iu_len 260 on port 1
(guid=0xfe80000000000000:0x2c903004b531d)
[  116.022420] srpt/0x1d534b0003c902000002c903004b5275: Unsupported
SCSI Opcode 0xa3, sending CHECK_CONDITION.
[  116.059152] srpt/0x1d534b0003c902000002c903004b5275: Unsupported
SCSI Opcode 0xa3, sending CHECK_CONDITION.
[  116.095754] srpt/0x1d534b0003c902000002c903004b5275: Unsupported
SCSI Opcode 0xa3, sending CHECK_CONDITION.
[  116.135728] srpt/0x1d534b0003c902000002c903004b5275: Unsupported
SCSI Opcode 0xa3, sending CHECK_CONDITION.
=====

The initial SRP_LOGIN_REQ around 91.8 is iPXE.  The others around
115.9 are linux.  Although add_target attempts are run on the
initiator, showing the "path rec status -22" error, no messages are
logged on the target for those.

As of ib_srpt 4.7.0, linux's SRP connection errors forever.  Whatever
allowed ib_srpt to realize to close the existing channel and reconnect
no longer functions.  The 4.7.1 target logs show:

=====
[   66.312149] ib_srpt Received SRP_LOGIN_REQ with i_port_id
0x1d534b0003c90200:0x2c903004b5275, t_port_id
0x2c903004b531c:0x2c903004b531c and it_iu_len 80 on port 1
(guid=0xfe80000000000000:0x2c903004b531d)
[   66.319699] ib_srpt truncated sense data from 96 to 44 bytes
[   95.537151] ib_srpt Received SRP_LOGIN_REQ with i_port_id
0x1d534b0003c90200:0x2c903004b5275, t_port_id
0x2c903004b531c:0x2c903004b531c and it_iu_len 260 on port 1
(guid=0xfe80000000000000:0x2c903004b531d)
[   95.537170] ib_srpt Relogin - closed existing channel
0x1d534b0003c902000002c903004b5275
[   95.537208] ib_srpt Received CM DREP message for ch
0x1d534b0003c902000002c903004b5275-523.
[   95.547887] ib_srpt Received SRP_LOGIN_REQ with i_port_id
0x1d534b0003c90200:0x2c903004b5275, t_port_id
0x2c903004b531c:0x2c903004b531c and it_iu_len 260 on port 1
(guid=0xfe80000000000000:0x2c903004b531d)
[   95.559176] ib_srpt Received SRP_LOGIN_REQ with i_port_id
0x1d534b0003c90200:0x2c903004b5275, t_port_id
0x2c903004b531c:0x2c903004b531c and it_iu_len 260 on port 1
(guid=0xfe80000000000000:0x2c903004b531d)
[   95.570267] ib_srpt Received SRP_LOGIN_REQ with i_port_id
0x1d534b0003c90200:0x2c903004b5275, t_port_id
0x2c903004b531c:0x2c903004b531c and it_iu_len 260 on port 1
(guid=0xfe80000000000000:0x2c903004b531d)
[   95.603721] srpt/0x1d534b0003c902000002c903004b5275: Unsupported
SCSI Opcode 0xa3, sending CHECK_CONDITION.
[   95.637072] srpt/0x1d534b0003c902000002c903004b5275: Unsupported
SCSI Opcode 0xa3, sending CHECK_CONDITION.
[   95.673745] srpt/0x1d534b0003c902000002c903004b5275: Unsupported
SCSI Opcode 0xa3, sending CHECK_CONDITION.
[   95.710313] srpt/0x1d534b0003c902000002c903004b5275: Unsupported
SCSI Opcode 0xa3, sending CHECK_CONDITION.
[   95.757202] ib_srpt srpt_queue_response: sending cmd response
failed for tag 0 (-22)
[  157.844561] ABORT_TASK: Sending TMR_TASK_DOES_NOT_EXIST for ref_tag: 0
[  157.851231] ib_srpt srpt_queue_response: sending cmd response
failed for tag 0 (-22)
[  157.852622] ib_srpt srpt_queue_response: sending cmd response
failed for tag 1 (-22)
[  219.692597] ABORT_TASK: Sending TMR_TASK_DOES_NOT_EXIST for ref_tag: 0
[  219.692743] ABORT_TASK: Sending TMR_TASK_DOES_NOT_EXIST for ref_tag: 1
=====

The initial SRP_LOGIN_REQ around 66.3 is iPXE.  The others around 95.5
are linux.  As before, add_target attempts are run on the initiator
between these, showing the "path rec status -22" error, but no
messages are logged on the target for those.

But, starting with ib_srpt 4.7.0, immediately after the linux SRP
connection starts the "sending cmd response failed" messages.

Then, without the user doing anything else on the target or initiator,
the ABORT_TASK and "cmd response failed" messages repeat about every
62 seconds forever.

The last commit in 4.6.4 is: 3c96888 (Apr 7, Bart Van Assche)  After
that, to 4.7, there's:
* +c0cf4512 (Jun 23, Bart Van Assche, Reduce QP buffer size)
* +9ba55cf7 (May 28, Linus Torvalds, Merge branch 'for-next')
* +507f6afa (May 25, Erez Shitrit, srpt: Adjust the use of ib_class_port_info)
* +b99f8e4d (May 3, Christoph Hellwig, convert to the generic RDMA
READ/WRITE API)
* +22d11759 (May 2, Christoph Hellwig, make ->shutdown_session optional)

These aren't in tags/v4.7:
* 10fce586 (Jul 21, Bart Van Assche, Simplify srpt_queue_response)
* 30c6d877 (Jul 21, Bart Van Assche, Limit the number of SG elements
per work request)

If requested, I can narrow it down to which commit.  Hoping it jumps
out to you guys.  I'm thinking it has to be the optional
shutdown_session change, or the conversion to the generic RDMA
READ/WRITE API.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

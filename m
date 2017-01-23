From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: Target core task management function handling rework
Date: Mon, 23 Jan 2017 22:32:39 +0000
Message-ID: <1485210745.2825.15.camel@sandisk.com>
References: <CAANLjFpi2E-2UxS3YSgjN=GzyZdLBhqJa4LN++52HTw6_3DKJA@mail.gmail.com>
         <07f540b9-f57b-6110-d94c-9ab0e9766b1b@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <07f540b9-f57b-6110-d94c-9ab0e9766b1b@grimberg.me>
Content-Language: en-US
Content-ID: <66359AB2AC621740AE8D0D02E6744A95@sandisk.com>
Sender: target-devel-owner@vger.kernel.org
To: "robert@leblancnet.us" <robert@leblancnet.us>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "sagi@grimberg.me" <sagi@grimberg.me>
Cc: "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2017-01-24 at 00:20 +0200, Sagi Grimberg wrote:
> Bart, I recall you had a patch at some point to periodically print
> out the hanging session commands in target_wait_for_sess_cmds(), do we
> want to get it in? I think we can all benefit from it.

(+target-devel)

Hello Sagi,

I have pushed the current state of these patches to the
scsi-target-for-v4.11 branch of
https://git.kernel.org/cgit/linux/kernel/git/bvanassche/linux.git/

So far these patches have been tested with iSCSI/TCP, ib_srpt and
qla2xxx drivers. The patches that are present on this branch are:

Bart Van Assche (36):
=A0=A0=A0=A0=A0=A0qla2xxx: Avoid using variable-length arrays
=A0=A0=A0=A0=A0=A0target/iscsi: Fix indentation in iscsi_target_start_negot=
iation()
=A0=A0=A0=A0=A0=A0target/iscsi: Fix spelling of "perform"
=A0=A0=A0=A0=A0=A0target/iscsi: Fix spelling of "reallegiance"
=A0=A0=A0=A0=A0=A0target/iscsi: Introduce a helper function for TMF transla=
tion
=A0=A0=A0=A0=A0=A0target/iscsi: Fix iSCSI task reassignment handling
=A0=A0=A0=A0=A0=A0target/iscsi: Fix solicited data sequence offset calculat=
ions
=A0=A0=A0=A0=A0=A0cxgbit: Fix endianness annotations
=A0=A0=A0=A0=A0=A0target/tcm_fc: Remove a set-but-not-used variable
=A0=A0=A0=A0=A0=A0target: Remove se_tmr_req.tmr_lun
=A0=A0=A0=A0=A0=A0target: Make core_tmr_abort_task() consider all commands
=A0=A0=A0=A0=A0=A0target: Make it possible to specify I_T nexus for SCSI ab=
ort
=A0=A0=A0=A0=A0=A0tcm_qla2xxx: Let the target core look up the LUN of the a=
borted cmd
=A0=A0=A0=A0=A0=A0target: Fix transport_wait_for_tasks() documentation
=A0=A0=A0=A0=A0=A0target: Remove an overly chatty debug message
=A0=A0=A0=A0=A0=A0target: Add a missing target_put_nacl() call
=A0=A0=A0=A0=A0=A0target: Stop execution if CMD_T_STOP has been set
=A0=A0=A0=A0=A0=A0target: Fix a reference leak in transport_cmd_check_stop_=
to_fabric()
=A0=A0=A0=A0=A0=A0target: Inline transport_cmd_check_stop()
=A0=A0=A0=A0=A0=A0target: Make ABORT and LUN RESET handling synchronous
=A0=A0=A0=A0=A0=A0target: Simplify session shutdown code
=A0=A0=A0=A0=A0=A0target: Remove the SCF_SEND_DELAYED_TAS command flag
=A0=A0=A0=A0=A0=A0target: Inline transport_check_aborted_status()
=A0=A0=A0=A0=A0=A0target: Remove the write_pending_status() callback functi=
on
=A0=A0=A0=A0=A0=A0target: Remove several state tests from TMF code
=A0=A0=A0=A0=A0=A0target: Remove command flag CMD_T_BUSY
=A0=A0=A0=A0=A0=A0target: Simplify LUN RESET implementation
=A0=A0=A0=A0=A0=A0target: Remove command flag CMD_T_DEV_ACTIVE
=A0=A0=A0=A0=A0=A0target: Reduce number of __transport_wait_for_tasks() arg=
uments
=A0=A0=A0=A0=A0=A0target: Remove command flag CMD_T_TAS
=A0=A0=A0=A0=A0=A0target: Remove unused arguments from __target_check_io_st=
ate()
=A0=A0=A0=A0=A0=A0target: Change return type of transport_wait_for_tasks() =
into void
=A0=A0=A0=A0=A0=A0target: Inline transport_put_cmd()
=A0=A0=A0=A0=A0=A0target: Reduce the number of transport_lun_remove_cmd() c=
allers
=A0=A0=A0=A0=A0=A0target: Move target_remove_from_state_list() into target_=
release_cmd_kref()
=A0=A0=A0=A0=A0=A0target: Avoid that XCOPY commands trigger a deadlock

Himanshu Madhani (2):
=A0=A0=A0=A0=A0=A0qla2xxx: Remove SRR code
=A0=A0=A0=A0=A0=A0qla2xxx: Remove unused reverse_ini_mode

Joe Carnuccio (1):
=A0=A0=A0=A0=A0=A0qla2xxx: Simplify usage of SRB structure in driver

Quinn Tran (9):
=A0=A0=A0=A0=A0=A0qla2xxx: Remove direct access of scsi_status field in se_=
cmd
=A0=A0=A0=A0=A0=A0qla2xxx: Cleanup TMF code translation from qla_target
=A0=A0=A0=A0=A0=A0qla2xxx: Make trace flags more readable
=A0=A0=A0=A0=A0=A0qla2xxx: Fix wrong argument in sp done callback
=A0=A0=A0=A0=A0=A0qla2xxx: Use d_id instead of s_id for more clarity
=A0=A0=A0=A0=A0=A0qla2xxx: Track I-T nexus as single fc_port struct
=A0=A0=A0=A0=A0=A0qla2xxx: Add framework for Async fabric discovery
=A0=A0=A0=A0=A0=A0qla2xxx: Add Dual mode support in the driver
=A0=A0=A0=A0=A0=A0qla2xxx: Improve RSCN handling in driver

Varun Prakash (1):
=A0=A0=A0=A0=A0=A0target/iscsi: Fix unsolicited data seq_end_offset calcula=
tion

Bart.=

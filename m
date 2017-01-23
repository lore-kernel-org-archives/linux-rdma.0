From: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Subject: [RFC] Clear out stuck ops to prevent iSER from going init D state
Date: Mon, 23 Jan 2017 12:01:40 -0700
Message-ID: <CAANLjFpi2E-2UxS3YSgjN=GzyZdLBhqJa4LN++52HTw6_3DKJA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In certain circumstances the RDMA connection can be abruptly
terminated, but something is getting stuck preventing the iSCSI clean
up commands from being completed. Just removing the isert_wait4*
commands isn't enough. Just resetting the queue pair isn't enough
either. This patch allows the session to be renegotiated and the iSCSI
process never goes into D state. I usually get iSCSI session errors
because they are not being cleaned up properly (obviously). I need
some help getting this patch fixed right as resetting the queue pair
is probably not the right approach and overkill to solving the
problem. I think it at least shows where the problem is occurring and
how I can get around it.

The problem easily shows up with two ConnectX-4-LX card connected to a
10 Gb switch. The target is a RAM disk and the initiator just mounts
it as ext4 and runs fio. During the lay down of the files, the
connection disruption causes the indefinite D state usually within the
first 4 GB. We have also experienced a very similar backtrace of the D
state processes on our Infiniband hardware following abrupt connection
losses (power loss to target) and a reinstatement of sessions where
the session information is not the same (we did not use targetcli to
save/restore exports, instead using a script to export causing an out
of order problem). We are now using targetcli to save/restore now and
the D state problem doesn't occur nearly as often, but we are
concerned that something like this could put the target in D state
requiring a reboot. Since we want to move to RoCE and the problem is
much easier to trigger there, we really need a fix.

I hope someone can provide some direction in this regard.

Here is a sample of the iSCSI errors with this patch.
----

[ 292.444044] ------------[ cut here ]------------
[ 292.444045] WARNING: CPU: 26 PID: 12705 at lib/list_debug.c:59
__list_del_entry+0xa1/0xd0
[ 292.444046] list_del corruption. prev->next should be
ffff8865628c27c0, but was dead000000000100
[ 292.444057] Modules linked in: ib_isert rdma_cm iw_cm ib_cm
target_core_user target_core_pscsi target_core_file target_core_iblock
mlx5_ib ib_core dm_mod 8021q garp mrp iptable_filter sb_edac edac_core
x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm ext4
ipmi_devintf irqbypass crct10dif_pclmul crc32_pclmul
ghash_clmulni_intel aesni_intel lrw jbd2 gf128mul mbcache mei_me
glue_helper iTCO_wdt ablk_helper cryptd iTCO_vendor_support mei joydev
sg ioatdma shpchp pcspkr i2c_i801 lpc_ich mfd_core i2c_smbus acpi_pad
wmi ipmi_si ipmi_msghandler acpi_power_meter ip_tables xfs libcrc32c
raid1 sd_mod ast drm_kms_helper syscopyarea sysfillrect sysimgblt
fb_sys_fops ttm mlx5_core igb ahci ptp drm libahci pps_core mlx4_core
libata dca i2c_algo_bit be2iscsi bnx2i cnic uio qla4xxx
iscsi_boot_sysfs
[ 292.444058] CPU: 26 PID: 12705 Comm: kworker/26:2 Tainted: G W 4.9.0+ #14
[ 292.444058] Hardware name: Supermicro SYS-6028TP-HTFR/X10DRT-PIBF,
BIOS 1.1 08/03/2015
[ 292.444059] Workqueue: target_completion target_complete_ok_work
[ 292.444060] ffffc90035533ca0 ffffffff8134d45f ffffc90035533cf0
0000000000000000
[ 292.444061] ffffc90035533ce0 ffffffff81083371 0000003b00000202
ffff8865628c27c0
[ 292.444062] ffff887f25f48064 0000000000000001 0000000000000000
0000000000000680
[ 292.444062] Call Trace:
[ 292.444063] [<ffffffff8134d45f>] dump_stack+0x63/0x84
[ 292.444065] [<ffffffff81083371>] __warn+0xd1/0xf0
[ 292.444066] [<ffffffff810833ef>] warn_slowpath_fmt+0x5f/0x80
[ 292.444067] [<ffffffff8136cce1>] __list_del_entry+0xa1/0xd0
[ 292.444067] [<ffffffff8136cd1d>] list_del+0xd/0x30
[ 292.444069] [<ffffffff8150a724>] target_remove_from_state_list+0x64/0x70
[ 292.444070] [<ffffffff8150a829>] transport_cmd_check_stop+0xf9/0x110
[ 292.444071] [<ffffffff8150e6c9>] target_complete_ok_work+0x169/0x360
[ 292.444072] [<ffffffff8109cc02>] process_one_work+0x152/0x400
[ 292.444072] [<ffffffff8109d4f5>] worker_thread+0x125/0x4b0
[ 292.444073] [<ffffffff8109d3d0>] ? rescuer_thread+0x380/0x380
[ 292.444075] [<ffffffff810a3059>] kthread+0xd9/0xf0
[ 292.444076] [<ffffffff810a2f80>] ? kthread_park+0x60/0x60
[ 292.444077] [<ffffffff817732d5>] ret_from_fork+0x25/0x30
[ 292.444078] ---[ end trace 721cfe26853c53b7 ]---


diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 8368764..ed36748 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -2089,3 +2089,19 @@ void ib_drain_qp(struct ib_qp *qp)
               ib_drain_rq(qp);
}
EXPORT_SYMBOL(ib_drain_qp);
+
+void ib_reset_sq(struct ib_qp *qp)
+{
+       struct ib_qp_attr attr = { .qp_state = IB_QPS_RESET};
+       int ret;
+
+       ret = ib_modify_qp(qp, &attr, IB_QP_STATE);
+}
+EXPORT_SYMBOL(ib_reset_sq);
+
+void ib_reset_qp(struct ib_qp *qp)
+{
+       printk("ib_reset_qp calling ib_reset_sq.\n");
+       ib_reset_sq(qp);
+}
+EXPORT_SYMBOL(ib_reset_qp);
diff --git a/drivers/infiniband/ulp/isert/ib_isert.c
b/drivers/infiniband/ulp/isert/ib_isert.c
index 6dd43f6..619dbc7 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -2595,10 +2595,9 @@ static void isert_wait_conn(struct iscsi_conn *conn)
       isert_conn_terminate(isert_conn);
       mutex_unlock(&isert_conn->mutex);

-       ib_drain_qp(isert_conn->qp);
+       ib_reset_qp(isert_conn->qp);
       isert_put_unsol_pending_cmds(conn);
-       isert_wait4cmds(conn);
-       isert_wait4logout(isert_conn);
+       cancel_work_sync(&isert_conn->release_work);

       queue_work(isert_release_wq, &isert_conn->release_work);
}
@@ -2607,7 +2606,7 @@ static void isert_free_conn(struct iscsi_conn *conn)
{
       struct isert_conn *isert_conn = conn->context;

-       ib_drain_qp(isert_conn->qp);
+       ib_close_qp(isert_conn->qp);
       isert_put_conn(isert_conn);
}

diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 5ad43a4..3310c37 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -3357,4 +3357,6 @@ int ib_sg_to_pages(struct ib_mr *mr, struct
scatterlist *sgl, int sg_nents,
void ib_drain_rq(struct ib_qp *qp);
void ib_drain_sq(struct ib_qp *qp);
void ib_drain_qp(struct ib_qp *qp);
+void ib_reset_sq(struct ib_qp *qp);
+void ib_reset_qp(struct ib_qp *qp);
#endif /* IB_VERBS_H */

Thank you,
----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

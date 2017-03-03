From: Yi Zhang <yizhan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: mlx4_core 0000:07:00.0: swiotlb buffer is full and OOM observed
 during stress test on reset_controller
Date: Fri, 3 Mar 2017 06:55:11 -0500 (EST)
Message-ID: <2013049462.31187009.1488542111040.JavaMail.zimbra@redhat.com>
References: <1908657724.31179983.1488539944957.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1908657724.31179983.1488539944957.JavaMail.zimbra-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi experts

I reproduced this issue during stress test on reset_controller, could you help check it, thanks.

Reproduce steps on initiator side:
num=0
while [ 1 ]
do
	echo "-------------------------------$num"
	echo 1 >/sys/block/nvme0n1/device/reset_controller || exit 1
	((num++))
done

Here is the full log: 
http://pastebin.com/mek9fb0b

Target side log:
[  326.411481] nvmet: creating controller 1061 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:32413b2b-89cc-4939-b816-399ff293800d.
[  326.516226] nvmet: adding queue 1 to ctrl 1061.
[  326.516428] nvmet: adding queue 2 to ctrl 1061.
[  326.516616] nvmet: adding queue 3 to ctrl 1061.
[  326.5361ing queue 4 to ctrl 1061.
[  326.556148] nvmet: adding queue 5 to ctrl 1061.
[  326.556499] nvmet: adding queue 6 to ctrl 1061.
[  326.556779] nvmet: adding queue 7 to ctrl 1061.
[  326.557093] nvmet: adding queue 8 to ctrl 1061.
[  326.576166] nvmet: adding queue 9 to ctrl 1061.
[  326.576420] nvmet: adding queue 10 to ctrl 1061.
[  326.576674] nvmet: adding queue 11 to ctrl 1061.
[  326.576922] nvmet: adding queue 12 to ctrl 1061.
[  326.577274] nvmet: adding queue 13 to ctrl 1061.
[  326.577595] nvmet: adding queue 14 to ctrl 1061.
[  326.596656] nvmet: adding queue 15 to ctrl 1061.
[  326.596936] nvmet: adding queue 16 to ctrl 1061.
[  326.662587] nvmet: creating controller 1062 for NQN nqn.2014-08.org.nvmexpress:NVMf:uuid:32413b2b-89cc-4939-b816-399ff293800d.
[  326.686765] mlx4_core 0000:07:00.0: swiotlb buffer is full (sz: 532480 bytes)
[  326.686766] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[  326.686768] CPU: 6 PID: 3931 Comm: kworker/6:256 Not tainted 4.10.0 #2
[  326.686768] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[  326.686775] Workqueue: ib_cm cm_work_handler [ib_cm]
[  326.686776] Call Trace:
[  326.686781]  dump_stack+0x63/0x87
[  326.686783]herent+0x14a/0x160
[  326.686786]  x86_swiotlb_alloc_coherent+0x43/0x50
[  326.686795]  mlx4_buf_direct_alloc.isra.4+0xb1/0x150 [mlx4_core]
[  326.686798]  mlx4_buf_alloc+0x172/0x1c0 [mlx4_core]
[  326.686802]  create_qp_common.isra.33+0x633/0x1010 [mlx4_ib]
[  326.686805]  ? mlx4_ib_create_qp+0xf7/0x450 [mlx4_ib]
[  326.686807]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[  326.686816]  ib_create_qp+0x70/0x2b0 [ib_core]
[  326.686819]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[  326.686823]  nvmet_rdma_alloc_queue+0x692/0x900 [nvmet_rdma]
[  326.686824]  ? nvmet_rdma_execute_command+0x100/0x100 [nvmet_rdma]
[  326.686826]  nvmet_rdma_cm_handler+0x1e6/0x708 [nvmet_rdma]
[  326.686827]  ? cma_acquire_dev+0x1e7/0x4b0 [rdma_cm]
[  326.686829]  ? cma_new_conn_id+0xb2/0x4b0 [rdma_cm]
[  326.686830]  ? cma_new_conn_id+0x153/0x4b0 [rdma_cm]
[  326.686832]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[  326.686834]  cm_process_work+0x25/0x120 [ib_cm]
[  326.686835]  cm_req_handler+0x994/0xcd0 [ib_cm]
[  326.686837]  cm_work_handler+0x1ce/0x1753 [ib_cm]
[  326.686839]  process_one_work+0x165/0x410
[  326.686840]  worker_thread+0x137/0x4c0
[  326.686841]  kthread+0x101/0x140
[  326.686842]  ? rescuer_thread+0x3b0/0x3b0
[  326.686843]  ? kthread_park+0x90/0x90
[  326.686845]  ret_from_fork+0x2c/0x40
[  326.691158] mlx4_core 0000:07:00.0: swiotlb buffer is full (sz: 532480 bytes)
[  326.691158] swiotlb: coherent allocevice 0000:07:00.0 size=532480
[  326.691160] CPU: 6 PID: 3931 Comm: kworker/6:256 Not tainted 4.10.0 #2
[  326.691160] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[  326.691163] Workqueue: ib_cm cm_work_handler [ib_cm]
[  326.691163] Call Trace:
[  326.691165]  dump_stack+0x63/0x87
[  326.691167]  swiotlb_alloc_coherent+0x14a/0x160
[  326.691168]  x86_swiotlb_alloc_coherent+0x43/0x50
[  326.691173]  mlx4_buf_direct_alloc.isra.4+0xb1/0x150 [mlx4_core]
[  326.691176]  mlx4_buf_alloc+0x172/0x1c0 [mlx4_core]
[  326.691179]  create_qp_common.isra.33+0x633/0x1010 [mlx4_ib]
[  326.691181]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[  326.691186]  ib_create_qp+0x70/0x2b0 [ib_core]
[  326.691188]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[  326.691190]  nvmet_rdma_alloc_queue+0x692/0x900 [nvmet_rdma]
[  326.691191]  ? nvmet_rdma_execute_command+0x100/0x100 [nvmet_rdma]
[  326.691193]  nvmet_rdma_cm_handler+0x1e6/0x708 [nvmet_rdma]
[  326.691194]  ? cma_acquire_dev+0x1e7/0x4b0 [rdma_cm]
[  326.691196]  ? cma_new_conn_id+0xb2/0x4b0 [rdma_cm]
[  326.691197]  ? cma_new_conn_id+0x153/0x4b0 [rdma_cm]
[  326.691199]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[  326.691201]  cm_process_work+0x25/0x120 [ib_cm]
[  326.691202]  cm_req_handler+0x994/0xcd0 [ib_cm]
[  326.691204]  cm_work_handler+0x1ce/0x1753 [ib_cm]
[  326.691205]  process_one_work+0x165/0x410
[  326.691206]  worker_thread+0x137/0x4c0
[  326.691207]  kthread+0x101/0x140
[  326.691209]  ? rescuer_thread+0x3b0/0x3b0
[  326.691209]  ? kthread_park+0x90/0x90
[  326.691211]  ret_from_fork+0x2c/0x40
[  326.695215] mlx4_core 0000:07:00.0: swiotlb buffer is full (sz: 532480 bytes)
[  326.695216] swiotlb: coherent allocation failed for device 0000:07:00.0 size=532480
[  326.695217] CPU: 6 PID: 3931 Comm: kworker/6:256 Not tainted 4.10.0 #2
[  326.695217] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[  326.695219] Workqueue: ib_cm cm_work_handler [ib_cm]
[  326.695220] Call Trace:
[  326.695222]  dump_stack+0x63/0x87
[  .695223]  swiotlb_alloc_coherent+0x14a/0x160
[  326.695224]  x86_swiotlb_alloc_coherent+0x43/0x50
[  326.695228]  mlx4_buf_direct_alloc.isra.4+0xb1/0x150 [mlx4_core]
[  326.695232]  mlx4_buf_alloc+0x172/0x1c0 [mlx4_core]
[  326.695234]  create_qp_common.isra.33+0x633/0x1010 [mlx4_ib]
[  326.695237]  mlx4_ib_create_qp+0x149/0x450 [mlx4_ib]
[  326.695241]  ib_create_qp+0x70/0x2b0 [ib_core]
[  326.695243]  rdma_create_qp+0x34/0xa0 [rdma_cm]
[  326.695245]  nvmet_rdma_alloc_queue+0x692/0x900 [nvmet_rdma]
[  326.695246]  ? nvmet_rdma_execute_command+0x100/0x100 [nvmet_rdma]
[  326.695247]  nvmet_rdma_cm_handler+0x1e6/0x708 [nvmet_rdma]
[  326.695249]  ? cma_acquire_dev+0x1e7/0x4b0 [rdma_cm]
[  326.695251]  ? cma_new_conn_id+0xb2/0x4b0 [rdma_cm]
[  326.695252]  ? cma_new_conn_id+0x153/0x4b0 [rdma_cm]
[  326.695254]  cma_req_handler+0x1f5/0x4c0 [rdma_cm]
[  326.695256]  cm_process_work+0x25/0x120 [ib_cm]
[  326.695257]  cm_req_handler+0x994/0xcd0 [ib_cm]
[  326.695259]  cm_work_handler+0x1ce/0x1753 [ib_cm]
[  326.695260]  process_one_work+0x165/0x410
[  326.695261]  worker_thread+0x137/0x4c0
[  326.695262]  kthread+0x101/0x140
[  326.695263]  ? rescuer_thread+0x3b0/0x3b0
[  326.695264]  ? kthread_park+0x90/0x90
[  3t_from_fork+0x2c/0x40

Initiator side log:
[  532.880043] nvme nvme0: new ctrl: NQN "nqn.2014-08.org.nvmexpress.discovery", addr 172.31.2.3:1023
[  533.002002] nvme nvme0: creating 16 I/O queues.
[  533.446540] nvme nvme0: new ctrl: NQN "nvme-subsystem-name", addr 172.31.2.3:1023
[  691.641201] nvme nvme0: rdma_resolve_addr wait failed (-110).
[  691.672089] nvme nvme0: failed to initialize i/o queue: -110
[  691.721031] nvme nvme0: Removing after reset failure


Best Regards,
  Yi Zhang


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

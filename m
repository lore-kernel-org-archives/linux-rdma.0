From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 15/15] RDMA/uverbs: Protect from command mask overflow
Date: Tue, 13 Feb 2018 12:18:41 +0200
Message-ID: <20180213101841.20101-16-leon@kernel.org>
References: <20180213101841.20101-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180213101841.20101-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The number of commands supported by the uverbs is less than 64, so let's
check it in advance that the supplied command is below that limit.

================================================================================
UBSAN: Undefined behaviour in
drivers/infiniband/core/uverbs_main.c:647:21
shift exponent 207 is too large for 64-bit type 'long long unsigned int'
CPU: 0 PID: 446 Comm: syz-executor3 Not tainted 4.15.0-rc2+ #61
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.7.5-0-ge51488c-20140602_164612-nilsson.home.kraxel.org 04/01/2014
Call Trace:
dump_stack+0xde/0x164
? dma_virt_map_sg+0x22c/0x22c
ubsan_epilogue+0xe/0x81
__ubsan_handle_shift_out_of_bounds+0x293/0x2f7
? debug_check_no_locks_freed+0x340/0x340
? __ubsan_handle_load_invalid_value+0x19b/0x19b
? lock_acquire+0x440/0x440
? lock_acquire+0x19d/0x440
? __might_fault+0xf4/0x240
? ib_uverbs_write+0x68d/0xe20
ib_uverbs_write+0x68d/0xe20
? __lock_acquire+0xcf7/0x3940
? uverbs_devnode+0x110/0x110
? cyc2ns_read_end+0x10/0x10
? sched_clock_cpu+0x18/0x200
? sched_clock_cpu+0x18/0x200
__vfs_write+0x10d/0x700
? uverbs_devnode+0x110/0x110
? kernel_read+0x170/0x170
? __fget+0x35b/0x5d0
? security_file_permission+0x93/0x260
vfs_write+0x1b0/0x550
SyS_write+0xc7/0x1a0
? SyS_read+0x1a0/0x1a0
? trace_hardirqs_on_thunk+0x1a/0x1c
entry_SYSCALL_64_fastpath+0x18/0x85
RIP: 0033:0x448e29
RSP: 002b:00007f033f567c58 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00007f033f5686bc RCX: 0000000000448e29
RDX: 0000000000000060 RSI: 0000000020001000 RDI: 0000000000000012
RBP: 000000000070bea0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 00000000000056a0 R14: 00000000006e8740 R15: 0000000000000000
================================================================================

Cc: syzkaller <syzkaller-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # 4.5
Fixes: 2dbd5186a39c ("IB/core: IB/core: Allow legacy verbs through extended interfaces")
Reported-by: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_main.c | 27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index cd72555ad457..b36cb12b3f38 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -650,12 +650,21 @@ static int verify_command_mask(struct ib_device *ib_dev, __u32 command)
 	return -1;
 }
 
+static bool verify_command_idx(__u32 command, bool extended)
+{
+	if (extended)
+		return command < ARRAY_SIZE(uverbs_ex_cmd_table);
+
+	return command < ARRAY_SIZE(uverbs_cmd_table);
+}
+
 static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
 			     size_t count, loff_t *pos)
 {
 	struct ib_uverbs_file *file = filp->private_data;
 	struct ib_device *ib_dev;
 	struct ib_uverbs_cmd_hdr hdr;
+	bool extended_command;
 	__u32 command;
 	__u32 flags;
 	int srcu_key;
@@ -688,6 +697,15 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
 	}
 
 	command = hdr.command & IB_USER_VERBS_CMD_COMMAND_MASK;
+	flags = (hdr.command &
+		 IB_USER_VERBS_CMD_FLAGS_MASK) >> IB_USER_VERBS_CMD_FLAGS_SHIFT;
+
+	extended_command = flags & IB_USER_VERBS_CMD_FLAG_EXTENDED;
+	if (!verify_command_idx(command, extended_command)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
 	if (verify_command_mask(ib_dev, command)) {
 		ret = -EOPNOTSUPP;
 		goto out;
@@ -699,12 +717,8 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
 		goto out;
 	}
 
-	flags = (hdr.command &
-		 IB_USER_VERBS_CMD_FLAGS_MASK) >> IB_USER_VERBS_CMD_FLAGS_SHIFT;
-
 	if (!flags) {
-		if (command >= ARRAY_SIZE(uverbs_cmd_table) ||
-		    !uverbs_cmd_table[command]) {
+		if (!uverbs_cmd_table[command]) {
 			ret = -EINVAL;
 			goto out;
 		}
@@ -725,8 +739,7 @@ static ssize_t ib_uverbs_write(struct file *filp, const char __user *buf,
 		struct ib_udata uhw;
 		size_t written_count = count;
 
-		if (command >= ARRAY_SIZE(uverbs_ex_cmd_table) ||
-		    !uverbs_ex_cmd_table[command]) {
+		if (!uverbs_ex_cmd_table[command]) {
 			ret = -ENOSYS;
 			goto out;
 		}
-- 
2.16.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

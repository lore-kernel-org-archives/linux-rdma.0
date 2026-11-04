Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793765022;
	b=0PSQGy1w8OVl4pP3+SbqXjsVWy6NYvfhDJcu87Tt03FIF59vCQ7jaE0N0rITxQVv/0Tm
	 UEs/A2FHO6Zl3iXvbeAUDgv1aF7lZt2jySrRTYJVsqcwhfJarPeqjcnonOLdD8hxZxvEh
	 tPAty9pS0pKWbTXg9cvyCfUJYuqnI8q7UFgc2G5moZTptVHdx+0i4k18NUgq0YdXjvgpY
	 AOsj081cR9WBSG5tiHODDcjXhNkiX4SNToDjQ3gTnv7qyc1vQrU0YoLqehmEGOeMV8ZBP
	 CSE3SbjINiHgSPPTKLvfjGXKU6u8hzfTZumntn8ZvXiIi8pzB7gXi3Of+GPwVSb0Q3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793765022;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KG+lk8t5iLyrUOS2NbtRJT3WvLogNx7an1uTy/LT6Vg=;
	b=H809syThhg2OM4WisV76L9DjojJ1reV8BhcQQWdkssKbYJ1Rtc5Is8WarPQ7T5Qwh0a3
	 axWPUrwnC3fhYEnj0DgPtWeqiVjzUKTDXY++2MaKA4PC/i5QxKfjAC4vWm4TXCXXgpycC
	 /6Lz1sJ7o/nmbD1FUW2HbxUvkcM7Apc60/pv/Va8mJOylfqpW2ohbornjGfpbRbhCB1Jj
	 NChbHs9g1ZpLlPwsjeDvmW4hW2yOzPbECjmTzR8v7l7aFt5zAfcpjnkorAYs9o5YgCWI8
	 ybxCKNqG6ZachPs8NHdIc3z1YyjDVPdtNinjLWt40uWXteubz0Dw9Yk0YX7S+AQaT/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=Z9924VGY;
	arc=none smtp.remote-ip=209.85.215.169
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1C44606A331
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 04:03:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A1C44606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=Z9924VGY
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-cc4c02ddd62so172734a12.0
        for <linux-rdma@vger.kernel.org>; Tue, 03 Nov 2026 20:03:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1793765021; x=1794369821; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KG+lk8t5iLyrUOS2NbtRJT3WvLogNx7an1uTy/LT6Vg=;
        b=Z9924VGYS1vYXjIV6i2714j16pkASODCYNph7xYLqcBuCRXNpXR9vl/+UvcknutWLD
         JFKIICjAthh6vcwZupqzGjODlsbNK5BjnakCZWtMauLbx5LVlwH2xn4DZPzTpmpqIW8Y
         bcDZsz2HvcVfSEfsL242IGzMljZpbmL0XOnTfZga/o4gnPgojFi8RTHCgYaYJ6g5gypF
         3x4T2X8ncjdzdRQNIHOO+h/bgMkbUvqDQgjCWRFrXp3FFYkVT9O+l7vVOWIx1rq1TzLD
         LDy7r+q4pTs2UIuPdA0O+yGwbv5ujrw6aywtLAa7YSTNzcBLMxkz98cy+l9VDwYn2c4J
         KkUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793765021; x=1794369821;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=KG+lk8t5iLyrUOS2NbtRJT3WvLogNx7an1uTy/LT6Vg=;
        b=07CS9+1BJsrkzWbdxZ7Saj/bmUt4bjNzCRMiaDozmdtip8e7ENcUVWUjdJ5y9fNZN/
         l1fV0wvmkWRJart0dmrC8V0uvX8/k4jcwTS/UBZQyefUtI/3IBPc8C3T5gsxZ/aDM8hP
         Ji1IV8xWkEWGF6eSx9z/4IcbfCUDELmvDXaqfCMeTT69I0krLLv1++c1gWe30S16oqko
         YeYmHfp6k7AnuhcKqmyCpwBRPUz//OdOk5fXTS2wOZ/rEgQ/u1J8xzh4HG1r3DM4/IRv
         x1d7L2A2sF8p/mzSJ9TGFV8atAPiifW29ro5tFbcJNNPLM0UPLrV3l/cOUDEvheMo1rC
         Ua5Q==
X-Forwarded-Encrypted: i=1; AKwUvBwLBEuxfStLbAQtQ9BH0RyuDjDMa0/gPBzSFj/LQK7r3kqMxNl43594HtezbNU6VF2iqu082afe6Kfm@vger.kernel.org
X-Gm-Message-State: APuU4Z+JlJyWWH1RO6ldR6/egz1i4G3AaHM9jOWp3MMZxagZFK3CeVBP
	2SqCj9iTwvx+v/hIsSUwxc5K+XRlrDVMrJJhA/F7TBfH2OFvX7+2eYD59PaJ1zlprKU=
X-Gm-Gg: AYBFou3NJ+f8XOcr7iK4IaaL6419+FN6UyzPr8yGE3+BfWNPY0doXfto22E1tvoeC1+
	PEqmDnIGk0aOGwLwoHG7LlXFS753E7LxhJXSFQEe8xUwzsj0eAaxD2BwwZ0Vj9qY8pTFiDYvu2d
	kmpODxgbzBGZf/x01Ts9GRkvpUpKTvqQmwEviz00eGJKhWRdrJn89a8gP0w87/iItzg8Pj22sQt
	F2zV7qFXzf8jPQHJl5O07rzssS67oQPzSdfMiHq7mPVNlKA5BxYV45IwK8KVXFQMUPb8Oz3thSP
	+x2HYE2t+lgZG/2+BZ5SeW+mYPb82UOGljkPTQGRc2k6HXj2ios9P72e6QcSc/iyDn5cp4Icaxm
	xlt31coVADpCZKJf161NifbxPP4J+pB+Zlm6kzmpHDgC/xaDpiy+1eYIESzsKKIcLGvUvf81JkY
	N6GZDbc2XyKF6AcWfloMgUB+MsDdkDQzVkQB8XcYjtY03yGqTkGPb5+WxmCOY2XULnpaXjgDqQd
	AOZ2/5MAxDjyRP0LSuIpC6wmp3F7VOZ5ZaMCz/8rGVXd2cHq8STrLQC8gnleYmlYXIV2S0smKWo
	djJKUULLP5DjS0wVgSFppY6TQUmaYPS7lw/UJsuDBJ8ganT+SJ/LjqDZcEH/c8Bj8l7FRJ9+hPX
	lLYL9Ur/9s92BEgC5z03fOViw5RoMpZF+hfOr
X-Received: by 2002:a17:90b:5870:b0:3ad:6090:a189 with SMTP id 98e67ed59e1d1-3ae8983e2f3mr11360606a91.45.1793765020090;
        Tue, 03 Nov 2026 20:03:40 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:744:cf40:a7b2:e78f])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b093d481a3sm1817053a91.1.2026.11.03.20.03.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 20:03:39 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Sagi Grimberg <sagi@grimberg.me>,
	Max Gurtovoy <mgurtovoy@nvidia.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	Mike Christie <michael.christie@oracle.com>,
	linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	stable@vger.kernel.org
Subject: [PATCH v8 4/6] IB/isert: drop the promotion reference when a connection errors out
Date: Wed,  4 Nov 2026 13:03:15 +0900
Message-ID: <20261104040318.1844865-5-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261104040318.1844865-1-yhlee@isslab.korea.ac.kr>
References: <20261104040318.1844865-1-yhlee@isslab.korea.ac.kr>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

isert_connected_handler() takes a reference when it moves a connection to
ISER_CONN_UP, and the paths that give a promoted connection up drop it
again.  isert_connect_error() does not: it drops one reference for any
state.  A promoted connection that then gets an error event keeps one
reference for ever, so isert_connect_release() never runs and the
isert_device reference it holds is never returned.  isert_remove_one()
waits for that in wait_for_completion(&removal_comp).

A REJ after the RTU reaches this path.  cm_rej_handler() accepts
IB_CM_ESTABLISHED while lap_state is IB_CM_LAP_UNINIT, and a passive id
stays in RDMA_CM_CONNECT after ESTABLISHED, so cma_ib_handler() passes the
event on as RDMA_CM_EVENT_REJECTED.

Drop the promotion reference too when the connection being given up was
promoted.  A test-only knob delivered that event to eight promoted
connections.  On patches 1 to 3 of this series the device delete did not
return within 240 seconds in any of three runs, each printed ten hung task
warnings, and isert_device_put() ran once, twice and twice, the first of
those being the one isert_remove_one() does itself.  Three runs with this
patch ran it nine times and the delete returned in 15 seconds.

  INFO: task rdma:206 blocked for more than 10 seconds.
        Not tainted 7.4.0-rc1-NR3-00004-g11e5479fd20e #123
  "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
  task:rdma            state:D stack:26592 pid:206   tgid:206   ppid:1      task_flags:0x400100 flags:0x00080800
  Call Trace:
   <TASK>
   __schedule+0x180f/0x4bb0
   ? filter_irq_stacks+0x71/0x90
   ? __pfx___schedule+0x10/0x10
   ? kasan_save_track+0x14/0x30
   schedule+0x70/0x1f0
   schedule_timeout+0x1cd/0x200
   ? __pfx_schedule_timeout+0x10/0x10
   ? vprintk_emit+0x200/0x2f0
   ? __pfx__raw_spin_lock_irq+0x10/0x10
   __wait_for_common+0x29e/0x420
   ? __pfx_schedule_timeout+0x10/0x10
   ? __pfx___wait_for_common+0x10/0x10
   ? mutex_lock+0x79/0xd0
   ? mutex_unlock+0x7b/0xd0
   ? __pfx_mutex_unlock+0x10/0x10
   isert_remove_one+0x529/0x710
   ? xas_load+0x1a/0x250
   ? __pfx_isert_remove_one+0x10/0x10
   ? xa_load+0xbf/0x120
   ? __pfx_xa_load+0x10/0x10
   ? __pfx_up_read+0x10/0x10
   remove_client_context+0xa4/0xf0
   disable_device+0x128/0x240
   ? __pfx_disable_device+0x10/0x10
   ? __pfx_mutex_lock+0x10/0x10
   __ib_unregister_device+0x226/0x3f0
   ? __pfx_mutex_unlock+0x10/0x10
   ib_unregister_device_and_put+0x50/0x70
   nldev_dellink+0x28e/0x3d0
   ? kernel_text_address+0xa7/0x130
   ? __pfx_nldev_dellink+0x10/0x10
   ? __pfx_down_read+0x10/0x10
   rdma_nl_rcv_msg+0x29c/0x4e0
   ? __pfx_rdma_nl_rcv_msg+0x10/0x10
   rdma_nl_rcv_skb.constprop.0.isra.0+0x21d/0x370
   ? __pfx_rdma_nl_rcv_skb.constprop.0.isra.0+0x10/0x10
   netlink_unicast+0x68f/0x940
   ? __pfx_selinux_socket_getpeersec_dgram+0x10/0x10
   ? __pfx_netlink_unicast+0x10/0x10
   netlink_sendmsg+0x810/0xf20
   ? __pfx_netlink_sendmsg+0x10/0x10
   ? __pfx__raw_spin_lock_irqsave+0x10/0x10
   ? selinux_socket_sendmsg+0x8c/0x270
   ? __sys_sendto+0x337/0x390
   __sys_sendto+0x337/0x390
   ? __pfx___sys_sendto+0x10/0x10
   ? fdget+0x53/0x3b0
   __x64_sys_sendto+0xdb/0x1b0
   ? fpregs_assert_state_consistent+0x56/0xe0
   do_syscall_64+0xdd/0x4a0
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
  RIP: 0033:0x7fe0ecec20d7
  RSP: 002b:00007fffe9d34978 EFLAGS: 00000202 ORIG_RAX: 000000000000002c
  RAX: ffffffffffffffda RBX: 00005621db1ab390 RCX: 00007fe0ecec20d7
  RDX: 0000000000000018 RSI: 00005621db1aa2a0 RDI: 0000000000000004
  RBP: 00007fffe9d349b0 R08: 00007fe0ecfb9200 R09: 000000000000000c
  R10: 0000000000000000 R11: 0000000000000202 R12: 00007fffe9d34ba0
  R13: 00007fffe9d34984 R14: 00007fffe9d34bc0 R15: 00007fffe9d34ba0
   </TASK>

Fixes: 954f23722b57 ("iscsi,iser-target: Initiate termination only once")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 187759ae644733..980bcc0fb23183 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -721,7 +721,7 @@ isert_connect_error(struct rdma_cm_id *cma_id)
 {
 	struct isert_conn *isert_conn = cma_id->qp->qp_context;
 	struct isert_np *isert_np = cma_id->context;
-	bool owned = false, bound = false;
+	bool owned = false, bound = false, promoted = false;
 
 	mutex_lock(&isert_conn->mutex);
 	mutex_lock(&isert_np->mutex);
@@ -730,6 +730,7 @@ isert_connect_error(struct rdma_cm_id *cma_id)
 			isert_conn->state == ISER_CONN_FULL_FEATURE;
 	} else {
 		owned = true;
+		promoted = isert_conn->promoted;
 		list_del_init(&isert_conn->node);
 	}
 	mutex_unlock(&isert_np->mutex);
@@ -747,6 +748,8 @@ isert_connect_error(struct rdma_cm_id *cma_id)
 
 	ib_drain_qp(isert_conn->qp);
 	isert_conn->cm_id = NULL;
+	if (promoted)
+		isert_put_conn(isert_conn);
 	isert_put_conn(isert_conn);
 
 	return -1;
-- 
2.43.0


Received: from bg5.exmail.qq.com (bg5.exmail.qq.com [43.154.197.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 397FC3B1EC8;
	Thu, 30 Jul 2026 08:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=43.154.197.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785400916; cv=none; b=YERGHZNPvDlGLkId0I8zhS2XNPlto4zYt/HWrt52dl609DF4e+qnTQWQypqdcdFc8KhDa9fDINEyN8+IBkRav8G+E7h+qq6cQZw1D1yUDVCMsaG6bqODo6JXz8R9un1IvO/fxkzZiJ52wXQYZQJNmj2vQxW3111iHh1FbiN3xT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785400916; c=relaxed/simple;
	bh=apjhd9r5UvB7eHFNTFhR4E4YEaHbrTTXlPeMenFgZPI=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:Content-Type; b=WhDAqeRu0f+aMGvsT09iGbhxuUV0R3nBuxLcRh+XR1qDRx7pSCTsol1nQOjTusDGtaohrh+15WU/l8urmElBmzyyxJYyi6XSDgtaGVAtgvAcA5Lg3kNeSRG/3NCYKAs50JTWXQAVV6bF0SZ0z8uv0+hno6krxjasu1R5JhVWYYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=smail.nju.edu.cn; spf=pass smtp.mailfrom=smail.nju.edu.cn; dkim=pass (1024-bit key) header.d=smail.nju.edu.cn header.i=@smail.nju.edu.cn header.b=w37upvcU; arc=none smtp.client-ip=43.154.197.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=smail.nju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=smail.nju.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=smail.nju.edu.cn header.i=@smail.nju.edu.cn header.b="w37upvcU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=smail.nju.edu.cn;
	s=iohv2404; t=1785400861;
	bh=GAHjhCBLNuGvAh8q0u/dFOpGqYQA5X4ZySIOtS+l+7A=;
	h=Message-ID:Date:MIME-Version:From:Subject:To;
	b=w37upvcUM6o8LIBU+ybiukDDwWGWhgqjKFSeQsdi33JsxM/zJSc+g7OB4guH0qE5i
	 um1BjRhrtxUKrunOyOhEa2ZuKoWEKqRPlrCeOQS0n1uS0mRPIThTPYHTMBb+rlaHqk
	 I3JBKLTt7xAT4NWBqtloWzt8T2F8rNNS4rqrADCw=
X-QQ-mid: zesmtpgz9t1785400855tf7babf9d
X-QQ-Originating-IP: oMc/JOueqwKVTVYxJrn96jiZuDv05Lmm197nDx/zw9U=
Received: from [127.0.0.1] ( [36.152.24.129])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 30 Jul 2026 16:40:54 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 11374830614792658596
Message-ID: <357830C4A3236804+c7b5ccba-01ba-468f-97c8-cb6053a8b771@smail.nju.edu.cn>
Date: Thu, 30 Jul 2026 16:40:54 +0800
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
From: Peiyang He <peiyang_he@smail.nju.edu.cn>
Subject: [BUG] RDMA/rxe: memory leak in rxe_qp_from_attr
To: jgg@ziepe.ca, yanjun.zhu@linux.dev, leon@kernel.org
Cc: "syzkaller@googlegroups.com" <syzkaller@googlegroups.com>,
 linux-rdma@vger.kernel.org,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:smail.nju.edu.cn:qybglogicsvrsz:qybglogicsvrsz4b-0
X-QQ-XMAILINFO: OBDSLDo3By90XWuD1oHwsLc4jtI7y+FgdSK4e1mCBmb4uftx+7DeJSWv
	smWP/otho6IuH8vBwM4IgWN/sHgqMCaGp+2CQTMW5eDRnSz4rEqOCYgXeZ8tqNU2wC4jUGU
	DJkAXA0ciB9c8CfwLeUF2EgNDFx85P0kVfmUIJFK3M9P+49qVgprw9t8M+LEAet+cV9QM71
	JyQwc5JkYkd4/SdxDEtYlxjxVdXk5MMED6I6WYgMj5FIDvPx8KzmRfHsw9akYJal6JkFh7B
	kPFwvILL0DtzXNXmDufiQ78ktXshas05droYim3bYnzEFDBahyONq3S4R9IjBJNEdj3woL/
	6JAAIA4XvBGRUm6tb9PpQk+BA6s2qP5rPFqoOyaO/FBEsNxmYTomg7bmn+Mk/zURGfAHPk+
	r2Yh9A1znKaj9Jr9TDy9vV3sCssCPg+X78NBmU4Ep1498IRehsHwTC17CvGNp8V1daDW3sR
	G+DRkUcx2AqwjVSifYZVdxJ5i6pqq05ye5RUfJVG8zsQ+ZJwPdwS9BZTACIlFPyec9ndHB7
	FryR+mGE2GSHWuC+A76S6RzSUq4YJ1X6HFjST5Ozi2m+GH6udXvndOzVDPVLzqMLW7oFeW7
	/fAUU+669T2X7bMJY2lx7i47LWIl/OxozPSeknpGJVAhCGvge4Y0WsQuq1B/FtxYH3rTyFA
	tOBfNZgXl9x5G5wJJiNnNMSfykI3sMI1AR7yBzHivnwQ3tFAOh0CjBq7ZJYdu/XCbDyhyt2
	zYyIsrv36WY0UFYjFThyxdNF9K5H4THwg7ftqeHJutBe1NeSEyp7oJkTZhOZZhu1Baa9s/i
	85rTfy8g6w0rWkOsK8EdqIfieI/2/4jDmUBdtI0fhH7U4zd9MD/Mc7FOSAydYQYVw8Yp+ir
	jQmUAi2RmA/+gAG00ktvCwOk488INqFEnF06MDaFtjI9c2UaANpqVpjU2FnZ5zYRqxWtX8Y
	WpGFbnO+dzQ+Q42bEDhIAXBC6H2lddmJ1HDRKTnM0pmKcrEb/i8Ke/3WwRMFoKmIn3oIHRi
	v4Br2Wn9BqJYGqJ+8xSowZCvefj+dnxX6Qyg3EUw==
X-QQ-XMRINFO: M/715EihBoGS47X28/vv4NpnfpeBLnr4Qg==
X-QQ-RECHKSPAM: 0

Hello Linux kernel developers and maintainers,

We hit a memory leak in rxe_qp_from_attr when fuzzing RDMA/RXE with Syzkaller.

The leak is caused by two concurrent MODIFY_QP commands which both modify
IB_QP_MAX_DEST_RD_ATOMIC on the same RXE QP. They are not serialized by a
QP-wide lock. The uverbs layer only holds shared UVERBS_LOOKUP_READ access
to the QP, so two threads may enter rxe_modify_qp() and then rxe_qp_from_attr()
for the same object at the same time.
It can leak a whole qp->resp.resources array each time triggered.

The version of the kernel under test is commit 8cd9520d35a6c38db6567e97dd93b1f11f185dc6 (tag v7.1).
We believe this OOB bug is still possible in the latest kernel.

The relevant kernel config is:

CONFIG_NET=y
CONFIG_INET=y
CONFIG_INFINIBAND=y
CONFIG_INFINIBAND_USER_ACCESS=y
CONFIG_INFINIBAND_ADDR_TRANS=y
CONFIG_RDMA_RXE=y
CONFIG_DEBUG_FS=y
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_KMEMLEAK=y
CONFIG_DEBUG_KMEMLEAK_AUTO_SCAN=y

=========================
Original Syzkaller report
=========================

BUG: memory leak
unreferenced object 0xffff8880120ef800 (size 1024):
  comm "syz.0.1478", pid 15130, jiffies 4295203468
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace (crc 0):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4575 [inline]
    slab_alloc_node mm/slub.c:4899 [inline]
    __do_kmalloc_node mm/slub.c:5295 [inline]
    __kmalloc_noprof+0x552/0x850 mm/slub.c:5308
    kmalloc_noprof include/linux/slab.h:954 [inline]
    kzalloc_noprof include/linux/slab.h:1188 [inline]
    alloc_rd_atomic_resources drivers/infiniband/sw/rxe/rxe_qp.c:155 [inline]
    rxe_qp_from_attr+0x3f8/0x2150 drivers/infiniband/sw/rxe/rxe_qp.c:714
    rxe_modify_qp+0x1e2/0x530 drivers/infiniband/sw/rxe/rxe_verbs.c:623
    ib_security_modify_qp+0x223/0xfa0 drivers/infiniband/core/security.c:625
    _ib_modify_qp+0x333/0xec0 drivers/infiniband/core/verbs.c:1915
    modify_qp+0x13ca/0x1940 drivers/infiniband/core/uverbs_cmd.c:1932
    ib_uverbs_modify_qp+0xcb/0x120 drivers/infiniband/core/uverbs_cmd.c:1958
    ib_uverbs_write+0xb86/0x1030 drivers/infiniband/core/uverbs_main.c:680
    vfs_write+0x2aa/0x1070 fs/read_write.c:686
    ksys_write+0x1f8/0x250 fs/read_write.c:740
    do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
    do_syscall_64+0x116/0x800 arch/x86/entry/syscall_64.c:94
    entry_SYSCALL_64_after_hwframe+0x77/0x7f

==========
Root cause
==========

modify_qp() obtains the QP through uobj_get_obj_read() and retains the
UVERBS_LOOKUP_READ access. This is a shared lookup, since UVERBS_LOOKUP_READ
increments a positive use count and only rejects an object whose count is -1,
whereas UVERBS_LOOKUP_WRITE is exclusive. Therefore, the two MODIFY_QP commands
may execute rxe_modify_qp() concurrently. rxe_modify_qp() directly calls
rxe_qp_from_attr() without a QP-wide lock.

For IB_QP_MAX_DEST_RD_ATOMIC, rxe_qp_from_attr() updates qp->attr.max_dest_rd_atomic,
frees the current qp->resp.resources pointer and calls alloc_rd_atomic_resources().
The allocator initializes the responder indices and assigns the result of kzalloc_objs()
to qp->resp.resources. Neither the resource replacement sequence nor the pointer assignment
is serialized.

The relevant QP starts with qp->resp.resources == NULL. Let P0 and P1 be the
two resp_res arrays allocated by the concurrent commands. The following
race interleaving leaks P1:

CPU0                                           CPU1
====                                           ====

MODIFY_QP()
-> rxe_qp_from_attr()
   -> alloc_rd_atomic_resources()
      -> P0 = kzalloc_objs()
      /* preempted after kzalloc_objs() returns P0,
         before the assignment to qp->resp.resources */

                                               MODIFY_QP()
                                               -> rxe_qp_from_attr()
                                                -> alloc_rd_atomic_resources()
                                                   -> P1 = kzalloc_objs()
                                                   -> qp->resp.resources = P1

      -> qp->resp.resources = P0
      /* overwrites the only reference to P1 */

When the QP is later cleaned up, rxe_qp_do_cleanup() calls free_rd_atomic_resources()
and can only free the pointer currently stored in qp->resp.resources, namely P0.
P1 has no remaining reference to it and is reported by kmemleak.

=============
Suggested fix
=============

First of all, I wonder is concurrent modify_qp() on the same QP supposed
to be supported by design? If yes, then the rd_atomic resource replacement
path needs explicit serialization. We could add a rd_atomic_mutex in
struct rxe_qp, init it in rxe_qp_init_misc(). Then, the IB_QP_MAX_DEST_RD_ATOMIC
branch in rxe_qp_from_attr() and rxe_qp_reset() should be protected by this lock.

I am happy to send a patch if this fix is needed and reasonable.

Thanks,
Peiyang


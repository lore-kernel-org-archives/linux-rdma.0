Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.116
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795289663;
	b=bsst3Dyi2K8wfHcBrs5/qmciDdPJde/RtdyLP4PsfVAjM4VthHqloezUXxb9KF4r2tv7
	 CedPfKW/zsUWTic87CxMLrUawIQJuJMDyIreUPv4xmZb6aQ+g3OuTcd8+qL9GTWn+fHeZ
	 gTzcFQSiYfh4i0jGgsmfLHsCMLA+doYBSwxG/G1vgEVMTnvB453miTVBArhKj5HRrlRz4
	 cLICbmFzIPnEVrFC8osTMPSx900DxUzoioI2jRyxV66Cf/VWE9KXugdEo3O1gOoVkgLL1
	 65kp4WaxUK4ea1l1vjRhyD526q0XFHGG6REeUgAPEiRiRmB2SFIj5KBR2Nnssz4mRLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795289663;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=ORTW/L5hh1DC9F6jjZky2W0T49vigeZuL6otjngyggU=;
	b=H8Gu3EZZApWkrtkqAtNSSGQ1t15gfek+7C0JOv43HKbdGGYvkTEzb7LljS1guur60qc4
	 Fnc+dXXWHVohlGeriuPWCEnQa3vTnU/R+hRguAUSA1vY4/3wr75i+LIDQOZWA6Xe2bh/F
	 ffKfe3MEIYQL6v3xjW1l358TVw82rTx7+9SI4NJGZlYIuylo83rltCIlxy3fZiQuXYr7J
	 WuJ0JZLu9t1ChaOXXtC7h5rTgTzTSerjqua0w9iKuPaiLPalOClperoBbAthqGMEHhZkJ
	 1lDLSiqMwv/FsdDMI4nVWZEAPPloGRWKPdH7afmQO0E/rDPlIL1QkEZWN3HljkRGgdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=DBB7aNQg;
	arc=none smtp.remote-ip=95.215.58.116
Received: from mta1.migadu.com (out-116.mta1.migadu.com [95.215.58.116])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19C69606A320
	for <linux-rdma@vger.kernel.org>; Sat, 21 Nov 2026 19:34:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 19C69606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=DBB7aNQg
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=I9C/bgiJfXHgW926J6D3HYkewXOwJxbleb9jrP9kCpY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795289660; v=1; x=1795894460;
 b=DBB7aNQgauNKvIny4sl0fzklqH8l1slINVYmwr4Dvt7SIpQVqC7N3fR9hj8RwL+Or0EcXEW2
 bRX3vKqgJ4HCaHdlj7PhB7H8WKtY8x/j+g8tnWL/+TlSnLvTNUeBnXsLb/hls7uhRk3WJoRXa4J
 pOIKgax3y+odp8A9btAkFVsQ=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 0be58bc518feca3e;
	Sat, 21 Nov 2026 19:34:20 +0000
X-Mizu-Trace-ID: 0be58bc518feca3e
X-Migadu-Flow: FLOW_OUT
Message-ID: <3a58ba4f-fd64-4144-8635-4b99983f7640@linux.dev>
Date: Sat, 21 Nov 2026 11:34:12 -0800
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH rdma-next v2] RDMA/rxe: Mask the SQ producer index read
 from user space
To: Shuai Liu <847807867@qq.com>, linux-rdma@vger.kernel.org
Cc: zyjzyj2000@gmail.com, jgg@ziepe.ca, leon@kernel.org,
 rpearsonhpe@gmail.com,
 syzbot+fef38133c495aeb48297@syzkaller.appspotmail.com,
 syzkaller-bugs@googlegroups.com, linux-kernel@vger.kernel.org,
 sashiko-reviews@lists.linux.dev, "yanjun.zhu@linux.dev"
 <yanjun.zhu@linux.dev>
References: <tencent_5B9FB1BCC8EF36C5E2128B7D4D54B867480A@qq.com>
 <tencent_BEE58D9BBE7109C47C2796DDF5A4B958F609@qq.com>
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <tencent_BEE58D9BBE7109C47C2796DDF5A4B958F609@qq.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

在 2026/11/20 19:46, Shuai Liu 写道:
> The send queue producer index of a user space QP is stored in the
> queue buffer which is shared with and written by user space. The
> requester reads it without any validation in req_retry() and
> __req_next_wqe() and compares it against its own local index which
> is always masked.
> 
> The requester stops processing WQEs when its local WQE index equals
> the producer index. If user space writes an out of range producer
> index into the queue buffer, that comparison can never become true.
> Once the QP is put into the error state, rxe_requester() then keeps
> flushing WQEs forever: the flush path advances the WQE index with the
> masked queue_next_index() but the producer index stays out of range,
> and each pass calls rxe_qp_error() which reschedules the send task,
> so the loop never converges. The send task holds a reference to the
> QP for as long as this lasts, so ib_destroy_qp() waits for the QP
> reference to drop until it times out after 50 seconds and the
> WARN_ON(!ret) fires in __rxe_cleanup():
> 
>    WARNING: drivers/infiniband/sw/rxe/rxe_pool.c:212 at __rxe_cleanup
>    Call Trace:
>     __rxe_cleanup
>     rxe_destroy_qp
>     ...
>    rxe0: qp#17 rxe_destroy_qp: cleanup failed, err = -110
> 
> Fix this by masking the producer index with q->index_mask when reading
> it in queue_get_producer() for QUEUE_TYPE_FROM_CLIENT. This restores
> what producer_index() did before commit ae6e843fe08d ("RDMA/rxe: Add memory
> barriers to kernel queues") replaced it with queue_get_producer() and
> dropped the mask, and keeps the requester, the completer and the queue
> helpers, which all compare the difference of the two indices modulo
> index_mask, consistent. rxe_qp_init_req() also initializes
> qp->req.wqe_index from this value so it gets validated as well.
> 
> Masking the index in queue_get_producer() instead of checking it at
> the two requester call sites was suggested by the Sashiko AI review of
> v1 of this patch.
> 
> Verified with the syzbot reproducer in QEMU: without this patch every
> destroy_qp hangs for 50 seconds and hits the WARNING above; with this
> patch the reproducer runs cleanly.

Thanks for the patch. A couple of questions/comments on this:

The commit message mentions that this fix was verified with the syzbot 
reproducer in QEMU, but I didn't see any corresponding verification 
email or test report thread on the list. Could you please share the 
link/reference to that email or provide a bit more detail on the test 
setup and baseline kernel used for verification?

In queue_get_producer(), there are also other queue types such as 
QUEUE_TYPE_TO_CLIENT, QUEUE_TYPE_FROM_ULP, and QUEUE_TYPE_TO_ULP. Have 
you checked whether any of those types could suffer from a similar 
out-of-range producer index issue? If so, please let us know and include 
any necessary fixes (either here or in a follow-up patch, as appropriate).

Thanks a lot.
Yanjun Zhu

> 
> Reported-by: syzbot+fef38133c495aeb48297@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=fef38133c495aeb48297
> Fixes: ae6e843fe08d ("RDMA/rxe: Add memory barriers to kernel queues")
> Signed-off-by: Shuai Liu <847807867@qq.com>
> ---
> Changes since v1:
> - Mask the producer index in queue_get_producer() for
>    QUEUE_TYPE_FROM_CLIENT instead of checking it at the two requester
>    call sites, as suggested by the Sashiko AI review of v1. This also
>    covers rxe_qp_init_req(), which initializes qp->req.wqe_index from
>    the same value, and keeps the requester, the completer and the queue
>    helpers consistent with each other.
> - Point Fixes at commit ae6e843fe08d, which dropped the mask that
>    producer_index() had, instead of commit 5bcf5a59c41e.
> - Reword the commit message: the flush loop never converges because
>    the WQE index is advanced with the masked queue_next_index() while
>    the producer index stays out of range; the req_retry() reset detail
>    in the v1 description was inaccurate.
> - Update the subject to describe the actual mechanism.
> 
>   drivers/infiniband/sw/rxe/rxe_queue.h | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/infiniband/sw/rxe/rxe_queue.h b/drivers/infiniband/sw/rxe/rxe_queue.h
> index c711cb98b9496..fe65aecc60464 100644
> --- a/drivers/infiniband/sw/rxe/rxe_queue.h
> +++ b/drivers/infiniband/sw/rxe/rxe_queue.h
> @@ -106,6 +106,7 @@ static inline u32 queue_get_producer(const struct rxe_queue *q,
>   	case QUEUE_TYPE_FROM_CLIENT:
>   		/* used by rxe, client owns the index */
>   		prod = smp_load_acquire(&q->buf->producer_index);
> +		prod &= q->index_mask;
>   		break;
>   	case QUEUE_TYPE_TO_CLIENT:
>   		/* used by rxe which owns the index */


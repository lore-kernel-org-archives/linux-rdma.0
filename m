Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.215
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793965241;
	b=dGY72HBe2rsdMECExtNA+Z6sPJcDZGk7+cl2kARDF0pWCY3EMth9dDNUxHWFNix2WMVg
	 jIpb68WP+rmCXf9JyhDmO7rwOAbOyp/eyzFiNaccWBGqMm/dbzoa9eSci3HDYz+UjqUPK
	 9FSQmM4fEzRUxaMcbiJEapgxY7vyHU+Np1+yzCFjf+XNlyJcO9mQhDUqiVRzLEiFFMRp/
	 FZSZQNVxRrRgmnBxDbDVM6js2dWrrF7jigC+0X4p5UnQs4pxUsEWhMTvTah2Iv3kuQCDa
	 M79SYW3mROFeMdCc+Ihuca1tKPGEDC2m6tdn8XvPyGl7yucFT1DJVJ5xl22O5gFnpkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793965241;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=B+rXA+LG0Nr4Rov1TlcYamFjy6WxxoNhz5HuSoYobUY=;
	b=3+kO/heHPatbsctc73NSGkgH+U2n63BE0u6gwM4OqdqDhUeh2GEAqhPbO+DJ0tPDbn5L
	 Z51szpWyVeVhCTiOnFDHsCoXXwPQhOzPu81Noife1JUJfPUckuCZlCs3/id8xSft3YmP/
	 +R2inEeZ7LIZz7jTeEMAxc2Qija2VpZa29PGqAfDIaq9j0kUukHfDNJFbla2dZtTwiS2D
	 6m4gouqlp1Op+gu69t9YLqYudu+Y8N4LzAUJ/l3uccTML3HXWAjgDhnkeVUA7z5JsvkN6
	 dLjSrJjDm1n//mIgdJ5qc1pWuyWb3fXnRgUDRRY02ME8d8v7AwOE8JbpUaYR8sVMIdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=UxqFOB8J;
	arc=none smtp.remote-ip=91.218.175.215
Received: from mta0.migadu.com (out-215.mta0.migadu.com [91.218.175.215])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0567A606BD4E
	for <linux-rdma@vger.kernel.org>; Fri,  6 Nov 2026 11:40:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0567A606BD4E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=UxqFOB8J
X-Envelope-To: linux-rdma@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=n/VbboCzefOB4w9vQ5BrdPfsWaF38INAGCXHBm5L/o0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793965239; v=1; x=1794570039;
 b=UxqFOB8JQGG7F49kF92x+CGnLLUWLwCAW1AQJ3CnNa6nn3JUGvoblA58nO/XU0PD3u+y4n3o
 JC1jp3hQzWrqFLEoFnm7SDeaECcb7fe2qNlwGB40dDep0GAe8pBOUAGjAY5v5qbsCL91T4Gg8rp
 ClyfyxL3aZncrU0qWlUuTytU=
X-Envelope-To: linux-rdma@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id a9641b311cb11270;
	Fri, 06 Nov 2026 11:40:18 +0000
X-Mizu-Trace-ID: a9641b311cb11270
X-Migadu-Flow: FLOW_OUT
Message-ID: <2a6c5985-6767-4eb4-88a6-3d53196ec5bd@linux.dev>
Date: Fri, 6 Nov 2026 12:40:12 +0100
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
Subject: Re: [PATCH v3] RDMA/siw: Fix early peer close handling on listeners
To: Jaeyeong Lee <lee@jaeyeong.cc>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261105022253.368316-1-lee@jaeyeong.cc>
From: Bernard Metzler <bernard.metzler@linux.dev>
In-Reply-To: <20261105022253.368316-1-lee@jaeyeong.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 05.11.2026 03:22, Jaeyeong Lee wrote:
> A TCP child socket inherits the listener callbacks and sk_user_data before
> kernel_accept() associates it with a new connection endpoint. If the peer
> closes during this window, siw_cm_llp_state_change() queues a PEER_CLOSE
> work item against the listening endpoint.
> 
> The worker releases that endpoint without removing it from the listener
> list. A later listener teardown then walks the dangling entry, causing a
> use-after-free in siw_destroy_listen(). KASAN reports:
> 
>    ==================================================================
>    BUG: KASAN: slab-use-after-free in __list_del_entry_valid_or_report+0x32/0x1a0
>    Read of size 8 at addr ffff888008f502c8 by task rping/59
> 
>    CPU: 0 UID: 0 PID: 59 Comm: rping Tainted: G    B               7.4.0-rc1-g6628e7d4c6b2 #1 PREEMPT(lazy)
>    Tainted: [B]=BAD_PAGE
>    Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
>    Call Trace:
>     <TASK>
>     dump_stack_lvl+0x54/0x70
>     print_address_description+0x73/0x1f0
>     ? __list_del_entry_valid_or_report+0x32/0x1a0
>     print_report+0x58/0x70
>     kasan_report+0x117/0x150
>     ? add_taint+0x43/0x90
>     ? __list_del_entry_valid_or_report+0x32/0x1a0
>     __list_del_entry_valid_or_report+0x32/0x1a0
>     siw_destroy_listen+0xe1/0x630
>     destroy_cm_id+0x25c/0x480
>     ? srso_return_thunk+0x5/0x5f
>     ? srso_return_thunk+0x5/0x5f
>     ? lock_acquire+0xf7/0x220
>     ? _destroy_id+0x2d1/0xe30
>     iw_destroy_cm_id+0xf/0x80
>     _destroy_id+0x6cc/0xe30
>     _cma_cancel_listens+0x2ee/0x360
>     _destroy_id+0x2ad/0xe30
>     ucma_destroy_private_ctx+0xb7/0x9d0
>     ? srso_return_thunk+0x5/0x5f
>     ? do_raw_spin_unlock+0x4d/0x230
>     ucma_close+0xd5/0x130
>     __fput+0x31a/0x720
>     fput_close_sync+0x91/0x110
>     filp_close_sync+0x18/0x30
>     put_files_struct+0x25a/0x280
>     do_exit+0x70e/0x1d00
>     ? lock_acquire+0xf7/0x220
>     ? get_signal+0x21c/0xf60
>     do_group_exit+0x19e/0x250
>     get_signal+0xf20/0xf60
>     ? futex_wait+0x99/0x230
>     arch_do_signal_or_restart+0x46/0x420
>     exit_to_user_mode_loop+0xbd/0x510
>     do_syscall_64+0x2ed/0x3b0
>     ? entry_SYSCALL_64_after_hwframe+0x76/0x7e
>     ? srso_return_thunk+0x5/0x5f
>     ? trace_hardirqs_off+0x65/0x90
>     entry_SYSCALL_64_after_hwframe+0x76/0x7e
>    RIP: 0033:0x7f92984c6e51
>    Code: Unable to access opcode bytes at 0x7f92984c6e27.
>    RSP: 002b:00007ffeae782d10 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
>    RAX: fffffffffffffe00 RBX: 000055fb4e9819b8 RCX: 00007f92984c6e51
>    RDX: 0000000000000000 RSI: 0000000000000189 RDI: 000055fb4e9819b8
>    RBP: 00007ffeae782d50 R08: 0000000000000000 R09: 00000000ffffffff
>    R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
>    R13: 0000000000000000 R14: 000055fb4e9819b8 R15: 000055fb4e97da25
>     </TASK>
> 
>    Allocated by task 59:
>     kasan_save_track+0x3e/0x80
>     __kasan_kmalloc+0x72/0x90
>     __kmalloc_cache_noprof+0x245/0x3c0
>     siw_cep_alloc+0x4f/0x390
>     siw_create_listen+0x39e/0xd60
>     iw_cm_listen+0xfc/0x1d0
>     rdma_listen+0x749/0xa90
>     cma_listen_on_dev+0x404/0x760
>     rdma_listen+0x3dc/0xa90
>     ucma_listen+0xe2/0x180
>     ucma_write+0x1bd/0x1e0
>     vfs_write+0x1a9/0x8e0
>     ksys_write+0xba/0x180
>     do_syscall_64+0xee/0x3b0
>     entry_SYSCALL_64_after_hwframe+0x76/0x7e
> 
>    Freed by task 30:
>     kasan_save_track+0x3e/0x80
>     kasan_save_free_info+0x40/0x50
>     __kasan_slab_free+0x3a/0x60
>     kfree+0x155/0x470
>     siw_cm_work_handler+0x7af/0x2d40
>     process_scheduled_works+0x970/0x12d0
>     worker_thread+0x894/0xd20
>     kthread+0x2db/0x3b0
>     ret_from_fork+0x266/0x570
>     ret_from_fork_asm+0x1a/0x30
> 
>    The buggy address belongs to the object at ffff888008f50200
>     which belongs to the cache kmalloc-512 of size 512
>    The buggy address is located 200 bytes inside of
>     freed 512-byte region [ffff888008f50200, ffff888008f50400)
> 
>    The buggy address belongs to the physical page:
>    page: refcount:0 mapcount:0 mapping:0000000000000000
>    index:0xffff888008f51400 pfn:0x8f50
>    head: order:2 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
>    flags: 0x4000000000000240(workingset|head|zone=1)
>    page_type: f5(slab)
>    raw: 4000000000000240 ffff888005842040 ffff888005840d08 ffff888005840d08
>    raw: ffff888008f51400 00000000000a0003 00000000f5000000 0000000000000000
>    head: 4000000000000240 ffff888005842040 ffff888005840d08 ffff888005840d08
>    head: ffff888008f51400 00000000000a0003 00000000f5000000 0000000000000000
>    head: 4000000000000002 ffffea000023d401 00000000ffffffff 00000000ffffffff
>    head: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
>    page dumped because: kasan: bad access detected
> 
>    Memory state around the buggy address:
>     ffff888008f50180: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>     ffff888008f50200: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>    >ffff888008f50280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                                                  ^
>     ffff888008f50300: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>     ffff888008f50380: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>    ==================================================================
> 
> There is a second race while creating a listener. listen() starts
> accepting connections before the endpoint is linked to the CM ID and
> changed from IDLE to LISTENING. ACCEPT work queued in this interval can
> run immediately, see the IDLE state, and return without accepting the
> first child.
> 
> Keep the listener endpoint in use from allocation until its CM ID, listener
> list entry, and LISTENING state have all been published. This makes early
> ACCEPT work wait for listener setup to complete.
> 
> During accept, serialize the endpoint handoff with socket state changes and
> reject a child that has already reached TCP_CLOSE or TCP_CLOSE_WAIT. Ignore
> close notifications inherited from the listener before that handoff. Live
> accepted sockets continue through the normal close path.
> 
> The issue was found by static analysis.
> 
> The unpatched kernel reproduced the KASAN report above in an x86_64 QEMU
> guest. With a temporary 500 ms delay after listen(), the previous version
> lost the first child and timed out waiting for an MPA response; this
> version accepted the same child and returned an MPA response.
> RST-before-accept and MPA-request-followed-by-FIN tests also completed
> without KASAN or lockdep reports. The final SIW object was built with
> LLVM 22.1.8 and W=1.
> 
> Fixes: 6c52fdc244b5 ("rdma/siw: connection management")
> Suggested-by: Stefan Metzmacher <metze@samba.org>
> Link: https://lore.kernel.org/r/33abff2233b36a51e468d691cb4327d0294d2734.1620343860.git.metze@samba.org
> Cc: stable@vger.kernel.org
> Signed-off-by: Jaeyeong Lee <lee@jaeyeong.cc>
> ---
> Changes in v3:
> - Serialize listener setup so early ACCEPT work cannot be consumed in IDLE.
> - Include the complete KASAN report requested by Leon.
> 
> Changes in v2:
> - Cover the IDLE interval between listen() and the LISTENING transition.
> - Serialize accepted-socket handoff and reject an already closed child.
> 
>   drivers/infiniband/sw/siw/siw_cm.c | 23 ++++++++++++++++++++---
>   1 file changed, 20 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/infiniband/sw/siw/siw_cm.c b/drivers/infiniband/sw/siw/siw_cm.c
> index ed49818793dde..90adb9543d9d0 100644
> --- a/drivers/infiniband/sw/siw/siw_cm.c
> +++ b/drivers/infiniband/sw/siw/siw_cm.c
> @@ -973,6 +973,7 @@ static void siw_accept_newconn(struct siw_cep *cep)
>   	struct socket *s = cep->sock;
>   	struct socket *new_s = NULL;
>   	struct siw_cep *new_cep = NULL;
> +	bool peer_closed;
>   	int rv = 0; /* debug only. should disappear */
>   
>   	if (cep->state != SIW_EPSTATE_LISTENING)
> @@ -1009,11 +1010,23 @@ static void siw_accept_newconn(struct siw_cep *cep)
>   	}
>   	new_cep->sock = new_s;
>   	siw_cep_get(new_cep);
> -	new_s->sk->sk_user_data = new_cep;
>   
>   	if (siw_tcp_nagle == false)
>   		tcp_sock_set_nodelay(new_s->sk);
> +
> +	lock_sock(new_s->sk);
> +	write_lock_bh(&new_s->sk->sk_callback_lock);
>   	new_cep->state = SIW_EPSTATE_AWAIT_MPAREQ;
> +	new_s->sk->sk_user_data = new_cep;
> +	peer_closed = new_s->sk->sk_state == TCP_CLOSE ||
> +		      new_s->sk->sk_state == TCP_CLOSE_WAIT;
> +	write_unlock_bh(&new_s->sk->sk_callback_lock);
> +	release_sock(new_s->sk);
> +
> +	if (peer_closed) {
> +		rv = -ECONNRESET;
> +		goto error;
> +	}
>   
>   	rv = siw_cm_queue_work(new_cep, SIW_CM_WORK_MPATIMEOUT);
>   	if (rv)
> @@ -1361,6 +1374,10 @@ static void siw_cm_llp_state_change(struct sock *sk)
>   
>   	case TCP_CLOSE:
>   	case TCP_CLOSE_WAIT:
> +		if (cep->state == SIW_EPSTATE_LISTENING ||
> +		    (cep->state == SIW_EPSTATE_IDLE &&
> +		     !READ_ONCE(sk->sk_socket)))
> +			break;
>   		if (cep->qp)
>   			cep->qp->tx_ctx.tx_suspend = 1;
>   		siw_cm_queue_work(cep, SIW_CM_WORK_PEER_CLOSE);
> @@ -1880,6 +1897,7 @@ int siw_create_listen(struct iw_cm_id *id, int backlog)
>   		rv = -ENOMEM;
>   		goto error;
>   	}
> +	siw_cep_set_inuse(cep);
>   	siw_cep_socket_assoc(cep, s);
>   
>   	rv = siw_cm_alloc_work(cep, backlog);
> @@ -1932,14 +1950,13 @@ int siw_create_listen(struct iw_cm_id *id, int backlog)
>   
>   	siw_dbg(id->device, "Listen at laddr %pISp\n", &id->local_addr);
>   
> +	siw_cep_set_free(cep);
>   	return 0;
>   
>   error:
>   	siw_dbg(id->device, "failed: %d\n", rv);
>   
>   	if (cep) {
> -		siw_cep_set_inuse(cep);
> -
>   		siw_free_cm_id(cep);
>   		siw_socket_disassoc(s);
>   		cep->state = SIW_EPSTATE_CLOSED;

Thank you Jaeyeong. While it seems sound, I have to look
closer. I'll reply soon.

Thanks,
Bernard.

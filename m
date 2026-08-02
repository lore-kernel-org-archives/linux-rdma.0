Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07310242D6C
	for <linux-rdma@vger.kernel.org>; Sun,  2 Aug 2026 22:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785709300; cv=none; b=eh9lsdWbedPBW9OZvmWYYlzWC2yqG8VXEgmKUbyXc7w0XWe/TPG5cPUKmngI25NuzviYzVOR73fweCJiwFIAo4w7L3Kn1/VpskezTsUqGEL5V+eG8b8lzzDiYw2VcQJKlo60cBoomv+h44ejNGfQYtKkxzvRYIm8I2gBSbqyjHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785709300; c=relaxed/simple;
	bh=lkE2p0q6618hioSKAI2VKQHQESNvLH5EfEY8p2a3Bhs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Mhea+5Lc3mU8fkw7WDcdL3OaumSG3/M5T/yS6+YbAmjuMvi/JJOeWegpRcOb9xia4I1gr0BpxMdp0KhJdWdhQotiDBPWxx8qrSe2CjSjLrDzQ52qkqB6THJ6Bhp0nRpbEq9IJ51EmB7dEEl5waet3RopC83zIWcLjczE1xaLnrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xqxpejM4; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xqxpejM4"
Message-ID: <51ab440e-4fc5-4e7d-b963-2c892b9bd517@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785709295;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Asebtw9cKyPUXfgzH9YKYzjPC2pPPCObmEuT7Lloq7Q=;
	b=xqxpejM42tqXXnacKYBIvhklhAjmcAL/zuT8WVczIVzYzIEgNQeKttrjErUAFaqaUYQX3p
	qvr9En0lYAj9DM1Y9Qw099zTIjpMhAUaEdeP/oQQM8PdkshTWnvWLciCm1A7eiwmP+g5Xi
	kvNhxeXQaGRcmLJwHE30C96ESGFnDUI=
Date: Sun, 2 Aug 2026 15:21:28 -0700
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH net 0/2] RDMA/rxe: fix mr_check_range() iova overflow
 (OOB)
To: gang.yan@linux.dev, zyjzyj2000@gmail.com,
 "yanjun.zhu@linux.dev" <yanjun.zhu@linux.dev>
Cc: linux-rdma@vger.kernel.org, Gang Yan <yangang@kylinos.cn>
References: <20260728091128.9116-1-gang.yan@linux.dev>
 <f60cfa62-8fe3-410d-a12d-24ebd22a79fd@linux.dev>
 <f83663d533bec05c77d12b234dd10fde851bf81a@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <f83663d533bec05c77d12b234dd10fde851bf81a@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

在 2026/8/1 2:27, gang.yan@linux.dev 写道:
> July 30, 2026 at 1:15 PM, "Zhu Yanjun" <yanjun.zhu@linux.dev mailto:yanjun.zhu@linux.dev?to=%22Zhu%20Yanjun%22%20%3Cyanjun.zhu%40linux.dev%3E > wrote:
> 
> 
>>
>> 在 2026/7/28 2:11, Gang Yan 写道:
>>
>>>
>>> From: Gang Yan <yangang@kylinos.cn>
>>>
>>>   Hi, Maintainers
>>>
>>>   I've recently started learning RDMA, using soft-RoCE (rxe) as my study
>>>   platform. While pair-programming with an AI assistant during this learning,
>>>   it flagged an integer overflow in mr_check_range(). I dug in, stood up a
>>>   small reproducer, and -- believing the issue is real and worth fixing --
>>>   put together this small series.
>>>
>> Do you have a small reproducer for this issue? If so, could you please share it on the RDMA mailing list?
> 
> Hi,
> 
> Thanks for your review. Here is a small reproducer (attached rxe_overflow_repro.c). I put it together
> quickly with the help of an Claude Code, as I'm still quite new to RDMA.
> 
> Idea: the client posts
> the client posts one RDMA-Write whose remote_addr
>    (0xfffffffffffffff8, len 8) makes iova + length wrap to 0, bypassing the
>    old mr_check_range() comparison; the responder then derives an
>    out-of-bounds page index in rxe_mr_iova_to_index() (the WARN_ON) and
>    reaches mr->page_info[] OOB.
> 
> Build & run (as root):
> 
>   sudo yum install -y libibverbs-devel librdmacm-devel
>   gcc -O2 -o repro rxe_overflow_repro.c -libverbs -lrdmacm
>   sudo modprobe rdma_rxe
>   sudo ip link add dummy0 type dummy
>   sudo ip addr add 192.168.172.1/24 dev dummy0 && sudo ip link set dummy0 up
>   sudo ip link set dummy0 up
>   sudo rdma link add rxe0 type rxe netdev dummy0
>   sudo ./repro 192.168.172.1
> 
> and then check the dmesg:
> [  136.830844] ------------[ cut here ]------------
> [  136.830848] WARNING: drivers/infiniband/sw/rxe/rxe_mr.c:99 at rxe_mr_iova_to_index+0x78/0x90 [rdma_rxe], CPU#188: kworker/u957:0/1368
> [  136.830870] Modules linked in: rdma_ucm ib_uverbs ib_uverbs_support rdma_cm iw_cm ib_cm dummy rdma_rxe ib_core ip6_udp_tunnel udp_tunnel joydev uinput snd_seq_dummy snd_hrtimer rfkill nf_conntrack_netbios_ns nf_conntrack_broadcast nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nf_tables sunrpc qrtr snd_hda_codec_generic snd_hda_intel snd_hda_codec snd_hda_core snd_intel_dspcfg snd_intel_sdw_acpi snd_hwdep intel_rapl_msr snd_seq intel_rapl_common snd_seq_device snd_pcm virtio_balloon snd_timer snd i2c_piix4 soundcore pcspkr i2c_smbus zram lz4hc_compress vmw_vsock_virtio_transport vmw_vsock_virtio_transport_common vsock qxl serio_raw drm_exec drm_ttm_helper e1000 ttm ata_generic pata_acpi i2c_dev qemu_fw_cfg virtiofs fuse
> [  136.830928] CPU: 188 UID: 0 PID: 1368 Comm: kworker/u957:0 Not tainted 7.2.0-rc5+ #1 PREEMPT(lazy)
> [  136.830931] Hardware name: Red Hat KVM, BIOS rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
> [  136.830935] Workqueue: rxe_wq do_work [rdma_rxe]
> [  136.830944] RIP: 0010:rxe_mr_iova_to_index+0x78/0x90 [rdma_rxe]
> [  136.830953] Code: 48 83 c4 28 e9 f9 1d 79 d2 48 8b 4f 68 48 23 8f 48 01 00 00 48 29 c8 48 89 c2 48 c1 ea 0c 48 63 c2 41 3b 90 58 01 00 00 72 d6 <0f> 0b 48 83 c4 28 e9 cd 1d 79 d2 66 90 66 66 2e 0f 1f 84 00 00 00
> [  136.830954] RSP: 0018:ffffd0c5833c7d38 EFLAGS: 00010286
> [  136.830957] RAX: ffffffffffff332d RBX: 0000000000000008 RCX: 000000000000000c
> [  136.830958] RDX: 00000000ffff332d RSI: 000000000000ccd2 RDI: ffff8d8ddc8b7e00
> [  136.830960] RBP: fffffffffffffff8 R08: ffff8d8ddc8b7e00 R09: 000000000000000c
> [  136.830961] R10: 0000000000000008 R11: ffff8d8d0ab96e56 R12: ffff8d8ddc8b7e00
> [  136.830962] R13: ffff8d8d0ab96e56 R14: 0000000000000286 R15: ffff8d8cd1a80428
> [  136.830966] FS:  0000000000000000(0000) GS:ffff8d9bcc89a000(0000) knlGS:0000000000000000
> [  136.830968] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  136.830969] CR2: 000000000ccd39b8 CR3: 00000001061fe000 CR4: 0000000000350ef0
> [  136.830973] Call Trace:
> [  136.830975]  <TASK>
> [  136.830978]  ? rxe_pool_get_index+0x4b/0x70 [rdma_rxe]
> [  136.830986]  rxe_mr_copy_xarray+0xb4/0x170 [rdma_rxe]
> [  136.830994]  execute+0x27e/0x320 [rdma_rxe]
> [  136.831002]  rxe_receiver+0x4f9/0xce0 [rdma_rxe]
> [  136.831009]  ? __pfx_rxe_receiver+0x10/0x10 [rdma_rxe]
> [  136.831015]  do_task+0x70/0x220 [rdma_rxe]
> [  136.831023]  process_one_work+0x19e/0x370
> [  136.831028]  worker_thread+0x1a6/0x310
> [  136.831030]  ? __pfx_worker_thread+0x10/0x10
> [  136.831032]  kthread+0xe4/0x120
> [  136.831035]  ? __pfx_kthread+0x10/0x10
> [  136.831038]  ret_from_fork+0x1a1/0x270
> [  136.831058]  ? __pfx_kthread+0x10/0x10
> [  136.831060]  ret_from_fork_asm+0x1a/0x30
> [  136.831066]  </TASK>
> [  136.831067] ---[ end trace 0000000000000000 ]---
> [  136.831077] rxe0: qp#17 make_send_cqe: non-flush error status = 10
> [  207.516233] dummy0 speed is unknown, defaulting to 1000
> 
> I tried it on a Fedora guest running 7.2.0-rc5: it reliably reproduces the WARNING
> at rxe_mr_iova_to_index() (i.e. the responder accepting an out-of-bounds index).
> 
> I'm still learning the RDMA stack, so my understanding of some of the details may not
> be fully thorough — apologies if anything above is unclear, and I'm happy to correct
> or expand on whatever is needed.

Thanks a lot. I have made tests with this commit and the test program in 
the attachment. In my test environment, I can verify this commit can fix 
the mentioned problem.

Thanks a lot.
Zhu Yanjun

> 
> Thanks
> Gang
> 
>>
>> I’d like to use it to reproduce the problem and confirm that this commit fixes the reported issue.
>>
>> Thanks a lot.
>>
>> Zhu Yanjun
>>
>>>
>>> Thanks
>>>   Gang
>>>
>>>   Gang Yan (2):
>>>   RDMA/rxe: Fix integer overflow in mr_check_range() leading to OOB
>>>   access
>>>   DO-NOT-MERGE: selftest: add rxe mr_check_range() overflow reproducer
>>>
>>>   drivers/infiniband/sw/rxe/rxe_mr.c | 3 +-
>>>   tools/testing/selftests/rdma/Makefile | 8 +-
>>>   tools/testing/selftests/rdma/config | 2 +
>>>   .../testing/selftests/rdma/rxe_mr_overflow.c | 187 ++++++++++++++++++
>>>   .../testing/selftests/rdma/rxe_mr_overflow.sh | 132 +++++++++++++
>>>   5 files changed, 330 insertions(+), 2 deletions(-)
>>>   create mode 100644 tools/testing/selftests/rdma/rxe_mr_overflow.c
>>>   create mode 100644 tools/testing/selftests/rdma/rxe_mr_overflow.sh
>>>
>> -- Best Regards,
>> Yanjun.Zhu
>>


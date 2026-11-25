Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795612371;
	b=2CTcSzruLD5uII+BVd67OMabIzqB8eL3dOtw7VJBbvDzWDOPBmy7T0gLrQP/4ON1iXOs
	 fxvaBiTCHjT2vL2GS8v7aOzSPPy8/cEFmPWt/4AdxGCOUp0jH3IaXbIG+LY6Jix7rS4DL
	 0ESrQwKzdr7Knh3hYKUFyHBVLhCotgnMbEQB6E4vCppTKpbY5FMSzEwHUTg7RWEp8ygoL
	 VurPBh+4hI4E//2xdDyIFRZ/DJG2omcmMxUFxDyCVQgcLqvAbvsyUlqivU//j2xGKZd/A
	 zVlVUuuF+5Md2lfaxAwMLbDCRK1z2tndffm01CVPopIajrKHf3mwh85egbDT1JUa9Gw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795612371;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=wcbvdTQgKNRV77o0UrLZp+UcEw64o/rMcwGqXSguFV0=;
	b=p/5nW77/3k6iHQLxb7OTMC3aRvjM6WC9n7gKYqqe2P5l6f1joCePLhVXp3SWzrDsr+rt
	 GB6CEM8ups/Bg451wgowqpdMza7Nn2mJPPDBBG2i/bZ9BaPRswWQaK8b9V0CLyOsu7Lb6
	 uJ7LMdAS4/O2wzq7KdNWZ56njoZgQlYuI/g5XbWTDANBPP+TFpdB9ubJ783Ytdc8nbLSI
	 Ruf6NqGYHEdh576j4HVkTIIHLg5uaF9+Q3nB6SVuo/9B4cAhQcOx0z518EaSVncYXK8OZ
	 q4TgdYY4CWlkoq5c6aEjcz2Mdqzq7cuB9LOe0HzmmO3adYINRmgi91sGiFcQRb6IE0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Pn1L3wCC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2C69606A31E;
	Wed, 25 Nov 2026 13:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Pn1L3wCC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E0101F000D1;
	Wed, 25 Nov 2026 13:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795612370;
	bh=wcbvdTQgKNRV77o0UrLZp+UcEw64o/rMcwGqXSguFV0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Pn1L3wCCeAWZYlxGp+QQ/7KKCHt3JipOAsHuk30UjiBQpTQ9GHs+rb8dwfl9aOHbk
	 jiNCY6PpE69puHdcKbtsqp6fReszH5DadfyA6RUEFyphy3fhyaTbxZ5K2CUCqQIMbX
	 FwJjRx7gF3b4OFDSxMQ51NWZw+tnog4Tla35IuvxggUPKFidV6uB4qfeHgK9quIhSN
	 ba/ZV7GQaKIFOqa0ks6KCFlOmPG74DCQ0/F6QSzvxr83i2nzwohw6udjRhEv8ZlHO6
	 2OQGyLkz3z7RZWRcMg/wK2eylSR6mMOctzJNu0LzqrRRJFyD1ARWET5BVY+GcceHFR
	 /A4rgqjGG/DMA==
Date: Wed, 25 Nov 2026 15:12:44 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Jaeyeong Lee <lee@jaeyeong.cc>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Artemy Kovalyov <artemyko@mellanox.com>,
	Yishai Hadas <yishaih@mellanox.com>, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] RDMA/mlx5: Preserve DEVX objects after failed output
 copy
Message-ID: <20261125131244.GB14811@unreal>
References: <20261111105346.3220427-1-lee@jaeyeong.cc>
 <20261115135123.GD42525@unreal>
 <20261122103715.51731-1-lee@jaeyeong.cc>
 <20261122103855.51859-1-lee@jaeyeong.cc>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261122103855.51859-1-lee@jaeyeong.cc>

On Sun, Nov 22, 2026 at 10:39:01AM +0000, Jaeyeong Lee wrote:
> As requested, below is the full dmesg from the reproducer run.

<...>

> [   13.847526] mlx5_dct_repro: loading out-of-tree module taints kernel.

What value does this change provide if it is based on an AI-generated sequence?

Thanks

> [   13.915884] MLX5-DCT-REPRO: forcing DRAIN_DCT to fail with command interface down
> [   13.916736] MLX5-DCT-REPRO: destroy failed as required: -67
> [   13.916817] MLX5-DCT-REPRO: failed destroy retained DCT ffff88800b112c58 in dct_xa
> [   13.916862] MLX5-DCT-REPRO: mimicking DEVX create unwind kfree(ffff88800b112c00)
> [   13.916924] MLX5-DCT-REPRO: delivering DCT_DRAINED event through actual notifier
> [   13.917219] ==================================================================
> [   13.917427] BUG: KASAN: slab-use-after-free in _raw_spin_lock_irqsave+0x38/0x90
> [   13.917427] Write of size 4 at addr ffff88800b112cb0 by task insmod/77
> [   13.917427] 
> [   13.917427] CPU: 0 UID: 0 PID: 77 Comm: insmod Tainted: G           O        7.4.0-rc1-g05441d697f7f #2 PREEMPT(lazy) 
> [   13.917427] Tainted: [O]=OOT_MODULE
> [   13.917427] Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> [   13.917427] Call Trace:
> [   13.917427]  <TASK>
> [   13.917427]  dump_stack_lvl+0x43/0x60
> [   13.917427]  print_address_description+0x77/0x200
> [   13.917427]  ? _raw_spin_lock_irqsave+0x38/0x90
> [   13.917427]  print_report+0x58/0x70
> [   13.917427]  kasan_report+0x117/0x150
> [   13.917427]  ? _raw_spin_lock_irqsave+0x38/0x90
> [   13.917427]  kasan_check_range+0x264/0x2c0
> [   13.917427]  _raw_spin_lock_irqsave+0x38/0x90
> [   13.917427]  complete+0x28/0x1b0
> [   13.917427]  rsc_event_notifier+0x1fc/0x410
> [   13.917427]  init_module+0x454/0xff0 [mlx5_dct_repro]
> [   13.917427]  ? rsc_event_notifier+0x4/0x410
> [   13.917427]  ? mlx5_core_destroy_dct+0x4/0x410
> [   13.917427]  ? rsc_event_notifier+0x4/0x410
> [   13.917427]  do_one_initcall+0x100/0x380
> [   13.917427]  ? __pfx_init_module+0x10/0x10 [mlx5_dct_repro]
> [   13.917427]  ? kasan_save_track+0x4f/0x80
> [   13.917427]  ? kasan_save_track+0x3e/0x80
> [   13.917427]  ? __kasan_kmalloc+0x72/0x90
> [   13.917427]  ? __kmalloc_cache_noprof+0x162/0x390
> [   13.917427]  ? do_init_module+0x5c/0x670
> [   13.917427]  ? __se_sys_finit_module+0x34e/0x540
> [   13.917427]  ? do_syscall_64+0x109/0x330
> [   13.917427]  ? entry_SYSCALL_64_after_hwframe+0x77/0x7f
> [   13.917427]  ? read_hpet+0xd6/0x150
> [   13.917427]  ? ktime_get+0x103/0x140
> [   13.917427]  ? lapic_next_event+0x11/0x20
> [   13.917427]  ? clockevents_program_event+0x1e3/0x440
> [   13.917427]  ? __hrtimer_rearm_deferred+0x1fb/0x380
> [   13.917427]  ? irqentry_exit+0x574/0x600
> [   13.917427]  ? resolve_function+0xb0/0xb0 [mlx5_dct_repro]

Thanks

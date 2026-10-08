Received: from mail-106121.protonmail.ch (mail-106121.protonmail.ch [79.135.106.121])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36CF2488D95;
	Thu,  8 Oct 2026 09:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=79.135.106.121
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791453054; cv=none; b=dMI0bnuyhxkxRzr/+1tunNCHF6mheWp0R6mmD2vmNSissQuRREJTM2p1PsWk6wcznG3j6cnYBtq2dnmWOpMWrrStPRQLvNp4SaqhiBlwv/j+JnDr4Hcj/dhM0JUPLfSZjqH2tXWtncCqoM/dtYqxOQaV0P1wIn41GT9U/v9TsJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791453054; c=relaxed/simple;
	bh=RkqGAR14G1OtyAFgFM5jnSLYgzOduqU58jb5n3uYyS0=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EgOd+FK+qN3KbfWNOUM8ORbOExjDAUmRtBbmn3YUoY2ZREV4srn5rUFKoD0iDWAQWGJYTpVyBiyqcMYRJe1ZWGhnMCk5eQOD7SVg7gFtSKP1oJ4dH6mB9VFow392QMRYYPyy0yvMpGd/9b6nNAbtUQAVfT7LrCW6kkPtxtRTsCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=LAuRBOEo; arc=none smtp.client-ip=79.135.106.121
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="LAuRBOEo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail2; t=1791453046; x=1791712246;
	bh=B12ERDkm0RUyoC16X3Dd24W8xlHWTs5vNfBL0yUlN0M=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=LAuRBOEo/M/qa8vnKr5OLlGmYsvZPs5ztkjqzDVF/tLdZw6wag6zk/aNhdSXEj+iy
	 ddM8tSmZXUZTW4Yx0X3ar9EyQxF2C+2GwOo1rNYJAHCkh3AG8At+kjJQEzk3ka5S4N
	 Ow9egVRCltqnrjdCRtu2VSDPU7lcbHcQHax8qkd+JKVokr49aoLRIkVbdgt1DRekRA
	 N4fnldgJG5RsPg+FHs6SjC56reIq/MnoyeFwWPHe+LyYZLvdwPI7WIxaNtA/spIXLv
	 GVOtbYmi3q+CRgRpHmzFZ2KP6CZaXDvp9DlVwCY5ML1IT8FZHmqTvJBr8N7kcLUzBm
	 UKrRLN5BzsXqw==
Date: Thu, 08 Oct 2026 09:50:41 +0000
To: Hidayath Khan <hidayath@linux.ibm.com>
From: Bryam Vargas <hexlabsecurity@proton.me>
Cc: Simon Horman <horms@kernel.org>, Wenjia Zhang <wenjia@linux.ibm.com>, "D . Wythe" <alibuda@linux.alibaba.com>, Dust Li <dust.li@linux.alibaba.com>, Sidraya Jayagond <sidraya@linux.ibm.com>, Mahanta Jambigi <mjambigi@linux.ibm.com>, Wen Gu <guwen@linux.alibaba.com>, Tony Lu <tonylu@linux.alibaba.com>, Paolo Abeni <pabeni@redhat.com>, Ibrahim Hashimov <security@auditcode.ai>, netdev@vger.kernel.org, linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net/smc: abort the connection when the peer overruns the RMB
Message-ID: <20261008095036.269598-1-hexlabsecurity@proton.me>
In-Reply-To: <dbb06d1d-17cc-4316-8efc-8e27c9bbef2e@linux.ibm.com>
References: <20260808081242.409253-1-hexlabsecurity@proton.me> <dbb06d1d-17cc-4316-8efc-8e27c9bbef2e@linux.ibm.com>
Feedback-ID: 199661219:user:proton
X-Pm-Message-ID: 3d8033bd71657ca3228f572195a0396d242ae5a2
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hidayath,

Sorry this sat for two months -- a major earthquake here, then
wrapping up my postgrad program.

> Yes, please send the logs.

Log below, from today's re-run on v7.3-rc6. One note on the label
first: it isn't stable across runs. My Aug 8 mail said
slab-out-of-bounds, which is what the Jul 23 run printed; the Jul 11
run said slab-use-after-free and today's says use-after-free, all on
the same 327520-byte read (5 * len). The second chunk is read from ring
offset 0, so its first 65504 bytes are still inside the RMB and the
remaining 262016 run past it, and KASAN names it after whatever sits
past the RMB. If the commit message names the bug type, take it from
the log you paste.

Repro: two AF_SMC sockets over SMC-D loopback, v7.3-rc6 with KASAN,
rmb_desc->len 65504. The sender puts its producer cursor on the wire
as wrap++ with count 0, six times. Each CDC passes every per-cursor
bound and smc_curs_diff() returns len for each, so bytes_to_rcv
reaches 393024 (6 * len). recv() returns 393024 and the second chunk
is a 327520-byte read:

  BUG: KASAN: use-after-free in _copy_to_iter+0x183/0x1390
  Read of size 327520 at addr ffff88814a0f0020 by task smc_forge_test/1695
  Call Trace:
   _copy_to_iter+0x183/0x1390
   smc_rx_recvmsg+0xbe0/0x27a0 [smc]
   smc_recvmsg+0x1c9/0x3a0 [smc]
   sock_recvmsg+0x14b/0x190
   __sys_recvfrom+0x190/0x2a0
   __x64_sys_recvfrom+0xdb/0x1b0
   do_syscall_64+0xdd/0x4a0
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
  The buggy address belongs to the physical page:
  head: order:4 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
  Memory state around the buggy address:
   ffff88814a0fff80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  >ffff88814a100000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff

Trimmed: KASAN's own frames, the "?" frames, registers and the page
dump; full log on request. With our v6 cursor series applied (2/3
bounds the receive length) the same run returns 65504 and KASAN stays
quiet, and an unforged transfer is clean. I haven't run it against
your patch. FWIW the forging is a test knob on the sender; on the rx
side the test module only adds a read-only readback of bytes_to_rcv,
which the test polls instead of sleeping, and a clamp toggle that
stays off in this run.

Ibrahim Hashimov raised the same accumulator gap on his "validate peer
CDC cursor" thread in July and accepted the Suggested-by I offered him
for the follow-up I had planned then. Your patch covers that
follow-up, so I'm passing it on; your call:

https://lore.kernel.org/all/20260724072117.73038-1-security@auditcode.ai/

Of the two changes of mine you planned to rebase on, "net/smc:
unregister the connection before draining the rx tasklet" is in
mainline (36cdf5d48ca1), and "net/smc: order the CDC receive path
against buffer publication" is not merged; its last posting is v4:

https://lore.kernel.org/all/20260728-b4-disp-52ee4e7d-v4-1-0dda94b0f397@pro=
ton.me/

Thanks,
Bryam


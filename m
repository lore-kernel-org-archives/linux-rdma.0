Received: from mail-4316.protonmail.ch (mail-4316.protonmail.ch [185.70.43.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0C3733B6F9;
	Sat, 11 Jul 2026 10:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783766623; cv=none; b=fDICSMjKDLV3bsO0wVnsBVowOVl8CdyLr+u8uL2ii9Tomx4PFaGfwuFINz37vK2Ca45pn4Q4B4QoNc7uuera9Dstfp8VGgLEQfGYBa8WW9+tMCT9iV2hop5wPe4xzm1Z3AKFPDAiGBculWMZJTe59A9rmVF4EnWWYlOV8QQwJEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783766623; c=relaxed/simple;
	bh=wMESLLx2bBOpenDSD5/Jp55qgZ2QSMmUYynjIj2Jx3o=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eJCUBikryALzN9ctdOUBzjjQZPKLgziBbSPhTVWKAqZElx4gxDAElo30Lg6of4/wv3bG4XEpWdW+aOcQHtfaz0f2mweqFXpMyw1Bnsyipv9jTsaS6EkRhPX4/4+CE95xV8c/AZlcy2jWwpEQTOYRZnIYVl32Q5Ad6Sg7IIadw+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=eTuZKyr6; arc=none smtp.client-ip=185.70.43.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="eTuZKyr6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail; t=1783766613; x=1784025813;
	bh=jkcAeCtdaIBL453JvBHZ7QHpOsA9URVgLRmr4A57c9A=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=eTuZKyr6YNHQ1zYN694Z5bwUCIuqrTw40KOw1Bf5QDHCL77pCIegCFoZKz5iwJqkF
	 7u9U/sDCCp/949JQAg+8dJmN9j0PeifBFrUoBqh9hrDpzMngBhX7pMhi9g1hi7NUFU
	 YSNtH9fwZnd6VtG3fGO08ClKwQBqFFNhiTf67BFMKGHLn7ittgqNJNA2dckOQ1kTuw
	 9nMA/iAOvwaqBayfdpRtJTTiE/OSFAxWzOdvznsNfD9bJ+QlGiegj30h/rK13kZxuO
	 taJQrF71DTxbjSDVLB9wbVJPypiweOu/+ClDKtCz6pY7pCZgrq7PWoo9bOtRoTHWjD
	 DpTzzitAY+uDA==
Date: Sat, 11 Jul 2026 10:43:26 +0000
To: Dust Li <dust.li@linux.alibaba.com>
From: Bryam Vargas <hexlabsecurity@proton.me>
Cc: Wenjia Zhang <wenjia@linux.ibm.com>, "D . Wythe" <alibuda@linux.alibaba.com>, Sidraya Jayagond <sidraya@linux.ibm.com>, Eric Dumazet <edumazet@google.com>, "David S . Miller" <davem@davemloft.net>, Mahanta Jambigi <mjambigi@linux.ibm.com>, Wen Gu <guwen@linux.alibaba.com>, Simon Horman <horms@kernel.org>, Ursula Braun <ubraun@linux.ibm.com>, Stefan Raspl <raspl@linux.ibm.com>, Tony Lu <tonylu@linux.alibaba.com>, Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org, linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v4 0/3] net/smc: bound wire-controlled CDC cursors against the local buffers
Message-ID: <20260711104315.82912-1-hexlabsecurity@proton.me>
In-Reply-To: <akzG4Hfeom6fNzFX@linux.alibaba.com>
References: <20260705-b4-disp-28a1bbca-v4-0-be089b98acc6@proton.me> <akzG4Hfeom6fNzFX@linux.alibaba.com>
Feedback-ID: 199661219:user:proton
X-Pm-Message-ID: b5d2950248f52f23efe53d3fa9731dba1629dc0c
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Tue, 7 Jul 2026 17:29:04 +0800, Dust Li wrote:
> Are you planning to land these clamps first, and then follow up with a
> separate validate/abort series?

Yes -- clamp series to net (Cc: stable), then the wire-boundary validate/ab=
ort to
net-next, which is the split from your v3 review. If you'd rather have the
validate/abort as the primary fix, or both in one series, say so and I'll
restructure it.

> Looking at your earlier A/B test, it simulates this logic in userspace to
> demonstrate the bug, but it doesn't actually trigger the bug in our
> current kernel.

Right -- the earlier one replayed the smc_curs_diff/copy arithmetic over a =
kmalloc
buffer. I built the end-to-end version: two AF_SMC sockets over the SMC-D l=
oopback
(dibs), CONFIG_SMC=3Dm with KASAN, receive path unmodified. Only the sender=
's on-wire
producer cursor is forged, modelling what a misbehaving peer sends:

  cdc.prod.wrap =3D curs.wrap;
  cdc.prod.count =3D curs.count;
+ if (forge) {                 /* peer just bumps the wrap, count stays 0 *=
/
+     static u16 w;
+     cdc.prod.wrap =3D ++w;
+     cdc.prod.count =3D 0;
+ }

The client sends six 1-byte messages, the server recvs into a 2 MB buffer.
rmb_desc->len =3D 65504; the three arms on 7.2-rc1:

  honest (no forge)            recv 6        clean
  forged, patch 2/3 clamp on   recv 65504    clean   (=3D=3D rmb_desc->len)
  forged, no clamp             recv 393024   KASAN

In the last arm bytes_to_rcv reaches 6*len, so smc_rx_recvmsg()'s second wr=
ap-around
chunk (copylen - first_chunk =3D 393024 - 65504) is read from ring offset 0=
, past the
RMB page:

  BUG: KASAN: slab-use-after-free in _copy_to_iter
  Read of size 327520 ... smc_rx_recvmsg <- smc_recvmsg <- __sys_recvfrom

(use-after-free rather than out-of-bounds only because the over-read lands =
in a freed
adjacent slab.) Happy to send the driver.

> the security risk here doesn't seem high to me, since SMC is only meant t=
o
> be deployed in trusted environments.

Agreed it's low urgency there. The reason I'd still keep the bound in stabl=
e: it's a
peer-driven out-of-bounds read of kernel memory that a buggy, not only mali=
cious,
peer can hit, and the clamp never resets an honest connection. The stable t=
ag is
your call.

> once this is actually triggered, it means the data we've been handing to
> userspace is already wrong ... the connection should be terminated. So I
> don't really see much value in merging the bound-clamp patches first.

I'm not arguing against the abort -- a bad CDC means the connection can't b=
e trusted
and should go down, and that's the net-next work. Two points on it.

The predicate has to test the accumulator, not the cursor. Every forged CDC=
 here
carries count =3D=3D 0, which is in [0, rmb_desc->len), so it passes any pe=
r-cursor
input check, including patch 1/3; only bytes_to_rcv goes out of range. A
cursor-boundary abort wouldn't catch this vector.

And placement: if the abort is queued (queue_work -> smc_conn_kill) after t=
he
atomic_add, a recvmsg() under lock_sock can still read the inflated accumul=
ator in
the window before teardown runs. A synchronous check that bails before the
atomic_add avoids that, and so does the consumer clamp.

If you'd prefer a single accumulator-abort in place of the -stable clamp, I=
'll
respin it that way and run the same A/B.

Bryam


Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795442028;
	b=eiMJHMHpPl9PX+THP+gJIZLpdhBG1bPrd+c/hGu1kbT1zv9NefdNHHRFfXAojKoJkUox
	 uH7kgiiwHlAGlF291HYZXu76XyJn3Ih5iMYVcXUhXR87cb45ikpCCZRPjTXgyzUc9dj5v
	 KifG6bqCNHLbi9+TecgWrbOFF+fdGuZEGd7N5Xuj2exzUF0IWuaCMXFeIup8DJW5uwghI
	 wZQz+Z4EWT1/WjUdCEx1N9ZiX8Bg08HWw/Vd1Vg1ddE8ZpPr9LQmvMo+J4xHpL5R9h79d
	 jGrpqzLnP0Ot8oDuqKj3f1CqerJOSyWNmd4vuL0qCG950k5bK1fIQJLXygSvF63uGGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795442028;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=con+4s5eqPAHcwSIYZ+D7+kd3aSyVqDuEASnC77AyI0=;
	b=ppDArCAJ8AOP8I1TQ9rYKSBam7csk0tC70icj4bM86sclipH64471olPLVNohYqIoAj1
	 00cvSyGC2mwtBGnHdMxNeSunSiz7wIabfSfVLqW+qFqcSEix8XwfSjJ7gOAvAdPdkA5XD
	 2QBokwHHBTZcKSyVeSgOa7BCceydfaEhBfO7AJVkfoiBfUBGk90rVlzxyqPUrA+sb0Ub7
	 4bQ0jrOG3Xyzkee1ZwDl8UviV87Zm72NRZsiRZ0WC/K2xBtXHGumODUYOsL6aDxSPlTUR
	 uMjIVNFjcDDOUjMvXwSA6YQRyg1Rqd+mzmrPScnA2/ylgUUq8PUERkJCPyMAcAAfXxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=iiitd.ac.in;
	spf=pass smtp.mailfrom=iiitd.ac.in;
	dkim=pass header.d=iiitd.ac.in header.i=@iiitd.ac.in header.a=rsa-sha256 header.s=google header.b="E0tbBx/j";
	arc=none smtp.remote-ip=209.85.215.176
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A882F606A33D
	for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 13:53:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A882F606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iiitd.ac.in
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iiitd.ac.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=iiitd.ac.in header.i=@iiitd.ac.in header.a=rsa-sha256 header.s=google header.b=E0tbBx/j
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-cddac941ed1so1322491a12.2
        for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 05:53:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=iiitd.ac.in; s=google; t=1795442027; x=1796046827; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=con+4s5eqPAHcwSIYZ+D7+kd3aSyVqDuEASnC77AyI0=;
        b=E0tbBx/j6F88fnWqPg4fVEojZS0kaVT3X/gsup2NQDZyymSxfVzKnj2s+dRGvF3zqH
         2JWIgow8bft334YEX5pI/ZmaDyO6DYyE95uzqqmQJ6odcPsG00nNIeIgaqv3FvPDapv4
         psxLgEEKuQT4WKRIRlmabHauPdGXaMZdG1gIc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795442027; x=1796046827;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=con+4s5eqPAHcwSIYZ+D7+kd3aSyVqDuEASnC77AyI0=;
        b=nVN5PVokJJ+85mbBIRQt9tc91FlBP71P60YB9ePT0OPDWP2C7CnPr9ZPCVnJU1a1se
         Y45CxOcH+2ONR8v0bB2hjzWKRExrqI+ioCFStm8Vkejswdg1lfwfhF3nBXoVOFx1JJTR
         tOJAYCJZnbVAhW2Jo+BqOMMIWaLfiO7eD/MFx1j07y3b9NnhyzsKgmqL0DZorOoA6G8M
         HgbO7svheq7J1rxDwIT9PS5/j/cDRLzkN3DcaDHZHJ9IMrM182pT5HjnGYergiIZdtvb
         p34A1BG9haItFw6ECp2QOnlc6eTBUz1xrPNVxC2XWHk8q8dAWe5wz1fN0o+R0549UtR4
         1yIw==
X-Forwarded-Encrypted: i=1; AL+hErFhxQgkrMBmIueciEX6xF+SLc+95zhA2IgW6UBGiy7vCGBmn77nUq8orqv1w9s0yPpn6NfERimelBHc@vger.kernel.org
X-Gm-Message-State: APuU4Z8hJiywAMfWqENDCnAwhrV48haVKm27jh46v0AXwsnEuIO2aaTz
	9JxcuVPRm1f5ulIMZIuqh8/Pd4ZTcjoEIhMPaVWK+Oj7DbhSaVAccWS+M9J8SAaOLFQ=
X-Gm-Gg: AZFdTZeXp32v9oDM3bJ7RSLLtx2+obca1xWGpGuPGlaqlMhgwxCMoEfQriQmwTs6OUz
	JtzxzsDOcJTd8qiSqewPqklSzJgecwTxfebhFQsvHBt171cfkfGyhzTcKdpCufDnmx2ZrDaG78x
	hKUmyFWrNpnCKy8ZHkfx77rsTFi43muvQZI/Un35a6cQTGJiYQoUytU2d5PqtV1Z7pfF+HtDAwq
	9ibH6S/AS9JLxyq9+uvfHVWfu6SavIMPK4El7yzRZQD2hZnS9+H3p4XB3GT7U9x8PQfsXDu2hsv
	FOGqp0EF+H+rbPH8INX3v7KYyO5vt0dsAqcClS9C9DJA6d1aJs2SvCgqAsQSsMT+EKk01Xu3+Qm
	VDDmh+NTKRwwBWu85E6tsEtP8fKx03I3/4Z19bj+DIdYY8IMJsX8w3pYeSTu1of03l9yrw6HO4+
	GV38CaxOo+h+aJTVbwIaO5wEImsFsWnbJJ9RQFK2GfchhrYD8rvISsvdpbmScQiAnLOBTGKOnwG
	ZWJQBrl3q7/wyUM38cgvMJ++embz0RaTZsbG/Ei1zfk2ygCfOCCdNOXbErSL5Jki1RhgTIbXeic
	FUedQKQOCP7wSa/NKqCrOuC9Xhl4qcVTgq54fJZDEx7EqmNyztY68gAGtKQDcrWDEqlLba1D+KZ
	RC3I23PzGTW3IZYg1GUPmRWoUQRbY5c/2oBE1njyVWIH2HrXczgukfUCkKod0cgBc
X-Received: by 2002:a05:6a21:511:b0:3f9:bcb9:30dc with SMTP id adf61e73a8af0-4014d14d4f5mr9922026637.38.1795442026980;
        Mon, 23 Nov 2026 05:53:46 -0800 (PST)
Received: from iiitd-S2600STB.iiitd.edu.in ([103.25.231.160])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cde6cff4c1asm5240220a12.15.2026.11.23.05.53.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 05:53:46 -0800 (PST)
From: Piyus Kedia <piyus@iiitd.ac.in>
To: alibuda@linux.alibaba.com,
	Dust Li <dust.li@linux.alibaba.com>,
	Sidraya Jayagond <sidraya@linux.ibm.com>,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	netdev@vger.kernel.org
Cc: Tony Lu <tonylu@linux.alibaba.com>,
	Wen Gu <guwen@linux.alibaba.com>,
	Jakub Kicinski <kuba@kernel.org>,
	linux-rdma@vger.kernel.org,
	linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Kapil Vaswani <kapil@presceralabs.ai>
Subject: Re: [PATCH net] net/smc: bound a send by the send buffer, not by the peer's credit
Date: Mon, 23 Nov 2026 19:23:40 +0530
Message-Id: <20261123135340.3953882-1-piyus@iiitd.ac.in>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <179541361172.3135.1077986856171763823@kernel.org>
References: <179541361172.3135.1077986856171763823@kernel.org>
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

Thank you for the review.  Every point was checked against net.git main at
af6737b90668 before answering, and three of them changed the patch rather
than its description, so v2 is a two-patch series rather than a reworded
version of this one.  It is posted as a separate thread:

  [PATCH net v2 1/2] net/smc: bound the failover cursor catch-up by what is
                     outstanding
  [PATCH net v2 2/2] net/smc: bound the DMB-nocopy send-buffer credit as well

There is no cover letter; the v2 changelog is under the --- line of 1/2,
with a Link: back to this thread.

Point by point.


1. The threat model in this patch is wrong

> Is this threat model accurate for the path named here?
> With real ISM hardware this credit branch never runs. With loopback-ism,
> both ends are the same kernel, so in-kernel SMC code writes the consumer
> cursor, not a remote party.
> Would it be more accurate to describe the nocopy part as hardening?

You are right, and this is the part of the review I am most grateful for.
smc_ism_support_dmb_nocopy() needs a dibs device providing
support_mmapped_rdmb(), and the only provider in the tree is
drivers/dibs/dibs_loopback.c, where both ends of the connection are the same
kernel.  The subject of my bug report naming "SMC-D DMB-nocopy" as the attack
was therefore wrong.  In v2 that path is patch 2/2 and is described as
hardening.


2. smc_switch_cursor() is the writer a peer can actually reach

> Is the nocopy path the only place that credits sndbuf_space from a peer
> cursor? smc_switch_cursor() in net/smc/smc_core.c runs on SMC-R link
> failover [...] Nothing bounds diff from above.

No, it is not the only place, and smc_switch_cursor() is the one that matters.
diff comes from conn->local_rx_ctrl.cons, smc_cdc_cursor_to_host() rejects
only a cursor that moves backward inside one wrap, and the chain you name is
in the tree as described:

  smc_llc_rx_delete_link()
    smc_llc_process_cli_delete_link()      net/smc/smc_llc.c:1620
      smc_switch_conns()                   net/smc/smc_llc.c:1657
        smc_switch_cursor()                net/smc/smc_core.c:1053

That is patch 1/2 of v2, and it carries Cc: stable.

Being straight about the evidence: we have no multi-link SMC-R group with two
RDMA devices here, so this route is from reading the code, not from a run.
The overflow itself was reproduced through the other writer, on loopback-ism
with the consumer cursor forged by a debug patch.  If a link group that
reaches smc_switch_cursor() cannot in practice carry a forged cursor, I would
be glad to be told.


3. The clamp did not restore the invariant, so it is gone

> Does this clamp bound the send by the send buffer, as the subject says?
> Each memcpy_from_msg() now stays inside the buffer, but sndbuf_space itself
> is still uncapped.
> Would the credit need to be capped where it is added [...] Without that, the
> invariant isn't restored.

Agreed on all of it.  With copylen clamped and the credit still inflated, the
producer never reaches smc_tx_wait(), later writes can overwrite data that has
not been sent while sendmsg() reports success, smc_tx_prepared_sends() and
to_send in smc_tx_rdma_writes() misreport pending data, and SIOCOUTQ returns a
negative queue length.

v2 bounds the credit at both sites where it is added and does not touch
smc_tx.c at all.  The bound is what this side has outstanding,
sndbuf_desc->len minus the current sndbuf_space: a peer cannot have consumed
more than that, so it is a no-op for a correct peer rather than a cap chosen
by guesswork.  With it, 0 <= sndbuf_space <= sndbuf_desc->len holds again, so
the two comments you noted as becoming false are true once more and need no
change.


4. smc_curs_add() subtracting the size only once

> smc_curs_add() subtracts the size only once. For a large enough diff, could
> tx_curs_sent.count therefore stay at or above sndbuf_desc->len?

It could, and smc_tx_rdma_writes() then uses that count as a source offset -
a second fault, which the clamp in this patch did nothing about.  Bounding the
difference fixes it as well: value < sndbuf_desc->len always, so one
subtraction is enough.  Patch 1/2 says so in its commit message.

In 2/2 the related assignment

	smc_curs_copy(&conn->tx_curs_fin, &conn->local_rx_ctrl.cons, conn);

is replaced by advancing tx_curs_fin by the bounded difference, so a reported
cursor is never installed as a send-buffer cursor.  For a cursor that reflects
real consumption the two are the same value.


5. Fixes: tags and Cc: stable

> Should this carry Fixes: tags and Cc: stable?

Yes.  Both are in v2, each confirmed by blaming the atomic_add() in question:

  1/2  Fixes: c6f02ebeea3a ("net/smc: switch connections to alternate link")
  2/2  Fixes: cc0ab806fc52 ("net/smc: adapt cursor update when sndbuf and peer
       DMB are merged")

Cc: stable is on 1/2 only.  2/2 is unreachable on any device in the tree, so
by stable-kernel-rules it is not a bug that bothers anyone; say the word if you
would rather have it there too.


6. The receive side

> This isn't a bug introduced by this patch, but the receive side appears to
> have the same unclamped second chunk. [...] The commit message points to
> "net/smc: validate the peer's CDC cursors against our own buffers" for the
> receive side. That validation isn't in this tree.

Correct, and my commit message implied it was applied, which it is not - it is
a separate patch posted on its own.  The two are independent and either can go
in first.  Worth being precise about why both are needed: that patch bounds the
peer's cons by conn->peer_rmbe_size, which keeps the cursor inside the peer's
RMBE but still permits "I consumed more than you sent", so it does not bound
the credit this series bounds; and this series does nothing for the receive
path.

Found by AI-driven fuzzing built on top of syzkaller, with the analysis checked
by hand against the code; the v2 cover letter says which parts were reproduced
and which were only read.

Thanks again - points 3 and 4 changed the shape of the fix, not just its
wording.

Kapil Vaswani
Piyus Kedia

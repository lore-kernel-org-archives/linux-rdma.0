Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795321282;
	b=Wb0ZwXiuxFD/trx3p6V/5f+O3SM9ActfF67JO5kLcLjAj0WMbrbqe/6/5qyb9SoLClwl
	 XTQB71nGpwJ0LZRqqHHnFQo686jwKVV7B/+wN9PYUZyk/YWWMM+RKuxntoU9twBVjxC10
	 7XnN0E/E+mUOybERwnk/y2rh0O6VDHq1SHOvfQkVafq3mzixS+CFpZxWXAHMWZNTokdO1
	 HT5RSzQikCbQe5bFxyyMBeb2Q2qWkqbsMR/GAVBRWBT90QQzhy2jtbdcv13zn7ozzJNFV
	 zqszKTMHx5ZFyoyB3VwslgIguRAys8qpj3Nk/saaqfyH18BXoNtsBpTX6cVITF2iNSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795321282;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5ZGfxFm22MqdeOsOLhYKxi18iGVL17970v+rtqXfBak=;
	b=ng0bRVJnHfM4CSWeSRq4p7OODBhsSFQbmG6R3h52IXcO9MeIQCCPh1PpqKkJxnbD6rHy
	 GXky/vr7t/MioYonjhRo+PKhpd2KRqhb91gtqwPGdlYWC/7rWT+YdPMWOGaaJ++wHoxw9
	 4EYi7LoYnSo4aPBCfjRvRuBsDg+IMubZ+sDBSqMFbfDfITlLM2vyyqPeT2VyVQb1yjHq6
	 O0rxY7ZxuOhKpecIAxKqAfJ/cfxt764hguvRkxp+Woq7mrzsdKsf07sFdQXs/03yyZGTi
	 QWwz54wOkgJPH2ebxPeuHXFiNZkVMIc9xamtkoy2AHehlk2N6Xd3DMjJ9XabLghizEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=iiitd.ac.in;
	spf=pass smtp.mailfrom=iiitd.ac.in;
	dkim=pass header.d=iiitd.ac.in header.i=@iiitd.ac.in header.a=rsa-sha256 header.s=google header.b=TlXDXhE1;
	arc=none smtp.remote-ip=209.85.216.42
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DD62606A32C
	for <linux-rdma@vger.kernel.org>; Sun, 22 Nov 2026 04:21:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5DD62606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iiitd.ac.in
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iiitd.ac.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=iiitd.ac.in header.i=@iiitd.ac.in header.a=rsa-sha256 header.s=google header.b=TlXDXhE1
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-3ae2b7e1e17so1336030a91.3
        for <linux-rdma@vger.kernel.org>; Sat, 21 Nov 2026 20:21:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=iiitd.ac.in; s=google; t=1795321280; x=1795926080; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5ZGfxFm22MqdeOsOLhYKxi18iGVL17970v+rtqXfBak=;
        b=TlXDXhE1vFamfVLeUXgS0rBDmWhARPSEQdZqgYb1TiKcGrKVl7fXBKPP6/JGfUDqYR
         OdJPTJdan2Hz8or3R3YtQFDsX8zxOZjjxoFH7usjuiOak/CkNBFXsz4OCOpUfpGXpdsQ
         TacQFdsnM9SmOIBkRkFLEBxIpkHt5UCcCb9w4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795321280; x=1795926080;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=5ZGfxFm22MqdeOsOLhYKxi18iGVL17970v+rtqXfBak=;
        b=L5rNEIwyPwHlLfKHsfVtI0Puh4vl/yjmDCZrhS0CAzrQvQvfBv8moyp9ZQ78tOTGTu
         LoTzhfWq8BJxA8BCRzoDH4XABUR4BOSvTN+cL4O06sfO143kLW5SaCijR4x7YBhe0Pyv
         uxdm/01nkxnPkNfBr7/B3a4YjIvM0mGdCBCUlsh3tgzrgc7amA8rxpupAde1ECYxxmrh
         fYL8qVF9/5RvyiYLorIcfhUds9edSYcyoCp+7oOlG2mMZHe7nVvd2eHhBU+g9VNlgxt1
         llFT2nAkXClb9Z2FrgodisbInIQZ+J9nHhXj+IR6QTPtykAjqik628SsOQXE4Vl61cGO
         fd0A==
X-Forwarded-Encrypted: i=1; AL+hErE0wVg6f/K5qHtZG/RUfeyhPNHgAr/sFhR6wGmpBvUF8TDLW3UnRaH5vlrUc28WsZUOqJrxt5GebmVk@vger.kernel.org
X-Gm-Message-State: APuU4Z+p27ldquk9yjdihaH+zFx12OzJJWY5uBivFTVeGTUA1iopBIM5
	E6FgVW+rrYU7XdA1AXoNyCTZY0Z4CRO2b/sqmccC2czyZGYeRonvfkBl/g4Pi/3Muik=
X-Gm-Gg: AZFdTZd5to2/fD+TVcMxbzV8W0Vv8sky9FRC/lsiwVuPG1c/I2B2+n+bVtbAIkHpC8h
	5ft7dwgus0YsMwz/PSr/i0gbAbWXb2xd5gGcQnB8ze/3MQ976daCMQA/jX1h7tLuTQl0YVSh84e
	UpHjhVjede8rNiqZCzHUwTeL6BGpP8yeCD9xdvV7x82cdLXyJZ8vWGCE6HbxFYKekOVsiWDazax
	zicmuiput2XTypag8u3cp5Wqru830Tu6jK/KpYjOA6lTpVBvOQSFJMg1HVIynkJT8TL2hH2Rz5S
	bWkA9oYsgiV2NPaKkN8rRRaAZ1Y5RWHo4UKxID+VKHea6hH0Qh5z1BSr1cAZ9NhzYk6sSM0kIo6
	rB0lV6WJuoFJzqQeME6vIspPlgIyFc4Ai9J6Kogl4QEoZ6usZjf5swqEwNNAe1oGmU9C6qOCepa
	RE9zO6kirIzMHyopCtxkRGq/BsDnhX/DFkcQQN6eDz86K69ZBn1s1yvem0QueodBoPcB78BP2Wc
	fzvx0F4kGdk0tt6hZuSri/71KBkRSycIfbbx13jby1GCpLz1ojBLK79yC7ff412pyoqCZ1XKc+l
	XIwSlOZbaP7eHFGdSxL5o/eYvmD2ZEJVzc41DGy9UsLiL7hFtrGX5ATJ50YpjqUWzC8WjaUdxK7
	kaZfuq1IwCQ5zhzmV0DpuNt5+Wv5WtuwIsBh1ZzjhLvd4MzzR55uDyq3gIusWiwqA
X-Received: by 2002:a17:90a:d2c7:b0:3b4:a90:7f3a with SMTP id 98e67ed59e1d1-3b41c95da5bmr6806828a91.55.1795321279640;
        Sat, 21 Nov 2026 20:21:19 -0800 (PST)
Received: from iiitd-S2600STB.iiitd.edu.in ([103.25.231.160])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b405d97356sm13717803a91.13.2026.11.21.20.21.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Nov 2026 20:21:19 -0800 (PST)
From: Piyus Kedia <piyus@iiitd.ac.in>
To: alibuda@linux.alibaba.com,
	Dust Li <dust.li@linux.alibaba.com>,
	Sidraya Jayagond <sidraya@linux.ibm.com>,
	Mahanta Jambigi <mjambigi@linux.ibm.com>,
	netdev@vger.kernel.org
Cc: Tony Lu <tonylu@linux.alibaba.com>,
	Wen Gu <guwen@linux.alibaba.com>,
	linux-rdma@vger.kernel.org,
	linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Kapil Vaswani <kapil@presceralabs.ai>
Subject: Re: [PATCH net] net/smc: validate the peer's CDC cursors against our own buffers
Date: Sun, 22 Nov 2026 09:51:13 +0530
Message-Id: <20261122042113.2430308-1-piyus@iiitd.ac.in>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <179528990895.3294.1614564040906254045@kernel.org>
References: <179528990895.3294.1614564040906254045@kernel.org>
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

> This is an automated message. This series looks like a fix, but its
> commit messages seem to be missing some information:
>
>  - How the issue was discovered, e.g. hit in production, hit during
>    development, syzbot report, manual code inspection, LLM or static
>    analysis tool scan.

Sorry for the omission.

How it was found
================

By AI-driven fuzzing built on top of syzkaller.

Its analysis was checked by hand against the code before we wrote anything,
and every claim in the report was reproduced on net.git main at d5b89d55a322
under KASAN:

  - a 131072-byte read past a 65536-byte RMB in smc_rx_recvmsg(), reaching
    userspace through _copy_to_iter();
  - a 1-byte read at an attacker-chosen offset in
    smc_cdc_handle_urg_data_arrival(), from the CDC tasklet;
  - a NULL dereference and oops in smc_rx_splice(), where vmalloc_to_page()
    returns NULL past the end of the RMB and get_page() dereferences it.

Each was run on an unpatched and a patched kernel built from the same tree in
the same scripted run: unpatched reports on all three, patched clean on all
three, with SMC_DIAG confirming SMC-R came up (mode=0, fb_reason=0x0) in
every run so that a clean result cannot be a setup failure.

What changed in v2
==================

Sending v2 separately, because it is a code change rather than only the
information above: v1 validated the SMC-R path only, while the report
acknowledged that SMC-D shares all three consumers.  smcd_cdc_rx_tsklet()
reads the cursors straight out of the DMB the peer writes into, in host byte
order, with no validation of any kind - not even the length and seqno tests
the SMC-R handler applies - so v1 left the same exposure open there.  v2 adds
the equivalent check on that path.  The SMC-R check itself is unchanged.

We have no ISM device, so the SMC-D half is reasoned from the code and from
the shared consumers rather than reproduced; what we did verify at runtime is
that ordinary SMC-D traffic over the loopback-ISM device still works with the
check in place, so it does not reject a correct peer.

The interdiff from the posted v1:

  diff --git a/net/smc/smc_cdc.c b/net/smc/smc_cdc.c
  index 03ff10fef..8d24e0c83 100644
  --- a/net/smc/smc_cdc.c
  +++ b/net/smc/smc_cdc.c
  @@ -433,6 +433,18 @@ static void smc_cdc_msg_recv(struct smc_sock *smc, struct smc_cdc_msg *cdc)
   	sock_put(&smc->sk); /* no free sk in softirq-context */
   }
   
  +static bool smcd_cdc_cursors_invalid(struct smc_connection *conn,
  +				     struct smcd_cdc_msg *cdc)
  +{
  +	if (!conn->rmb_desc)
  +		return true;
  +	if (cdc->prod.count > (u32)conn->rmb_desc->len)
  +		return true;
  +	if (cdc->cons.count > (u32)conn->peer_rmbe_size)
  +		return true;
  +	return false;
  +}
  +
   /* Schedule a tasklet for this connection. Triggered from the ISM device IRQ
    * handler to indicate update in the DMBE.
    *
  @@ -452,6 +464,15 @@ static void smcd_cdc_rx_tsklet(struct tasklet_struct *t)
   	data_cdc = (struct smcd_cdc_msg *)conn->rmb_desc->cpu_addr;
   	smcd_curs_copy(&cdc.prod, &data_cdc->prod, conn);
   	smcd_curs_copy(&cdc.cons, &data_cdc->cons, conn);
  +	/* This CDC was written by the peer into the DMB we published to it, so
  +	 * both cursors are peer-supplied and index buffers described on this
  +	 * side.  Nothing else checks them, and smc_cdc_msg_recv_action() uses
  +	 * the producer cursor as a receive length and the consumer cursor to
  +	 * credit sndbuf_space - which under DMB-nocopy is the memory the peer
  +	 * itself owns.  Unlike the SMC-R path these values are host order.
  +	 */
  +	if (smcd_cdc_cursors_invalid(conn, &cdc))
  +		return;
   	smc = container_of(conn, struct smc_sock, conn);
   	smc_cdc_msg_recv(smc, (struct smc_cdc_msg *)&cdc);
   }

Thanks,
Piyus Kedia

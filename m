Received: from mail-wm2-f9.google.com (mail-wm2-f9.google.com [74.125.225.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 655813BBFCD
	for <linux-rdma@vger.kernel.org>; Tue, 28 Jul 2026 17:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.137
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785259735; cv=none; b=lmO3naN+Tb1ydydmQ+oIoF22BfS9dPum+PNJrH6SrsCvFZ2KlyLjUnAnd2Xy6bscV+41PUofwWmzSzkFI8MacCE/C2kup4V5zTBHTie2A4nbPXztvpDeGNM2YVRSdmayCHc1ilQmbZt/U2tIllOy2Qon005HYrtQ6i5oBU9sACg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785259735; c=relaxed/simple;
	bh=kwCGjZwRfWG+1hIQMc0ddiJCm3ytqoes5YMMF/1Scng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GWoQZh1l8daO1iFaOjFhG9akEvWHPJtYT5Cdy6VmQxf/QjxW5LcQdUjJoFgfv6kgEGjbxCgC+6zLeAKtzWqDt6sHoXmu5RmIVibdeRqW/U4gRBfjgZ5XVWKUcpbqbQSJd9qJJAEKt9Sf3RSrcOHOADz7qB6UZaA5G+INACkYzbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lMjKV/r2; arc=none smtp.client-ip=74.125.225.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lMjKV/r2"
Received: by mail-wm2-f9.google.com with SMTP id 5b1f17b1804b1-493e55619a2so129455e9.1
        for <linux-rdma@vger.kernel.org>; Tue, 28 Jul 2026 10:28:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785259732; x=1785864532; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=89i5Xg4svJgXBxa+VECmORIi//zfBDN4JU0w7A03jnw=;
        b=lMjKV/r2Kxcpwlwym84hbydHeevywwzNxiij9E+sTBaCmhXYDcQcEPZB1fKmIxGAG4
         8MYYBq2K2eFOr6Rvtwkt9eUIjVFXcBut46ACXtO34SucyXVVDmGRn5LXtrldtx1QUCUs
         uzf+8DGlTKuHYiz0e7IeAM54cvArjILqHvjl9ni5/qGdDnuyLj5rV5ryALmAMxUUyOVu
         WcpZu5MDtG00NqETaowzdVf0Ew09ykLcIPOSPLuOXZlGPo0mFAmEVnzjGt48EPXEvQgw
         19PHMdOb7atD3yNAEZARn2Lfx1sya0DnFURy8m5ezuj2WrXQ8nO6u7O7NzsnanYndo3B
         PKCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785259732; x=1785864532;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=89i5Xg4svJgXBxa+VECmORIi//zfBDN4JU0w7A03jnw=;
        b=sAp8yz62DFm3Cn4vaiJhT/rVVfUqssKfzNACXFxcKVPiaaONV0Q1s8Q5FeNak2WsDM
         zvotxdQL43ovOY0P07IkJf/Td1IV2+W+EjpFrg0pp4j90w7zC9YtzB3UcJTgp8oMWIq1
         l8MYTJyirT/fTFeUSRELn+In5qsD7075+L7N15a4dm7vXTSg1lSNOoU7Hhg/bKVfrfXe
         G4FNIsq/szZiHnqMoGm3OFEbEsny7VTQOqT908e7cUqQ8w7t1nYnEboXSF6NNhxm8k2W
         lJ9MiK2dHWbXBDBFAGAKiHfQ7mrjU8IrDaCkuFPe68FjHkrxizubT/pb6yUxoriQgDF1
         n4ag==
X-Forwarded-Encrypted: i=1; AHgh+Rp1vPyyqTuFJT+McV3paULK+D2JyHogaArh3xcnadCNSMv8lPJgj1i/pdLudTusDBpk0vZMWbgAD2Zv@vger.kernel.org
X-Gm-Message-State: AOJu0YwBE1iUR4QcAHUtEaI5wZyW5F/j4n+bMWoBrnSouid+eG6EVm/O
	DLewSTbU7chVPLF0IBi8xjxXDo8YhQPwuWb94VUu47WCfX5cTmtmo6em
X-Gm-Gg: AR+sD13h8L63AR8mxmAiHrr+zUrpI13HNzolSQ2JBV2cOfbQQBZxtTOEhjjJumSO1BS
	LoP6+oj9aJj/XoikNKKEEX+OCZ0bIeM3QdpVv8SHguV7xhHP/W8uF1z2Di5b0NNh7mnEZUlikpY
	2ozXkvVNB/3O2jdmeJVxmCHyOcxHAHXejke6kfx8js12tLrPF/fk/kJEAf0sTB079PFx3OgtOnj
	uw/4MW7akQXuqjsECFK4UiOJYqYCYK/x1tQzcjDLfoZshVKwrpqnRb9ytXh9Ii6/pFZqVT4XGNb
	AMI5Aju/TzS4AVRC+0EPB3JdR+MP26VfR6uc4PoBYnx9bRd+rJW2rOzf59RG1LtQ2LWWaqkzjqc
	ZLLX8MbgfywGVZ+e8YyXRcRh5kSOKwogHOXupS+1qR0sn6LAgnjP8uPm+/4oc2YU45E+SKedgbL
	m8mQ==
X-Received: by 2002:a05:600c:1c1c:b0:493:dcad:84da with SMTP id 5b1f17b1804b1-496c640fc12mr34326075e9.1.1785259731393;
        Tue, 28 Jul 2026 10:28:51 -0700 (PDT)
Received: from fedora ([212.253.220.176])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-496c44af19bsm89418735e9.3.2026.07.28.10.28.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 10:28:50 -0700 (PDT)
From: Serhat Kumral <serhatkumral1@gmail.com>
To: yanjun.zhu@linux.dev
Cc: mounter625@163.com,
	zyjzyj2000@gmail.com,
	xiongwm2026@163.com,
	jgg@ziepe.ca,
	leon@kernel.org,
	dsahern@kernel.org,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	serhatkumral1@gmail.com,
	syzbot+8c9eede336e3a843750e@syzkaller.appspotmail.com
Subject: Re: [RFC PATCH 1/2] RDMA/rxe: drive UDP tunnel socket lifetime from the GID table
Date: Tue, 28 Jul 2026 20:28:25 +0300
Message-ID: <20260728172825.43978-1-serhatkumral1@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <c225c004-1fa9-4010-a843-8be033003e93@163.com>
References: <c225c004-1fa9-4010-a843-8be033003e93@163.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The crash reproduces here now, and it does not come from this series.

The tree in that git diff carries v2 of "RDMA/rxe: Hold netdev reference
for transmit skbs", not the v3 I was pointed at. The pre-image blob of
rxe_net.c in the diff is 44a16cb1601a, and on f2ec6312bf71:

  v2 applied -> rxe_net.c 44a16cb1601a
  v3 applied -> rxe_net.c 86c9b19f65e1

v2 alone, without this series, crashes on the first run of
rxe_rping_between_netns.sh:

  [   67.227061] Oops: general protection fault, probably for
    non-canonical address 0xdffffc0000000000: 0000 [#1] SMP KASAN NOPTI
  [   67.231014] KASAN: null-ptr-deref in range
    [0x0000000000000000-0x0000000000000007]
  [   67.240200] Workqueue: rxe_wq do_work [rdma_rxe]
  [   67.241906] RIP: 0010:ip_rcv+0xeb/0x570

Same fault, same RIP, same Code bytes and same call trace as the oops
reported in this thread, down to process_backlog+0x341/0x1110 and
net_rx_action+0x87e/0xe00.

Runs of rxe_rping_between_netns.sh on f2ec6312bf71:

  f2ec6312bf71                 120/120
  + this series                120/120
  + v3                         120/120
  + v3 + this series           220/220
  + v2                         crash on run 1
  + v2 + this series           crash on run 1

The mechanism is the one the v3 changelog describes. v2 releases the
netdev through the live skb->dev and then clears it,

  if (skb->dev) {
    dev_put(skb->dev);
    skb->dev = NULL;
  }

but skb->dev has already been rewritten by the transmit path, so the put
lands on the wrong device and the receive side can find skb->dev == NULL.
v3 keeps the held netdev in skb_shinfo(skb)->destructor_arg and never
touches skb->dev.

So v3 is the one to carry. Nothing here points at the socket lifetime
change.

thanks,
serhat

Received: from mail-wm2-f9.google.com (mail-wm2-f9.google.com [74.125.225.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C8FD3D5648
	for <linux-rdma@vger.kernel.org>; Mon, 27 Jul 2026 19:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.137
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785182143; cv=none; b=Bk7gJLs1H9OUd+bGUCBkrR5bzXPd04hevPLT4NYiwJtdHymjtl71aHFg77ZGLFBjTFo4R/4tuOIGLhcF38cWnGW+NTpxoL8TuyilnIcYdVp0NWWkPr/4ephzunbBUYZAdEnaprunYfygoUzUqphdPdGmOoZJ95knU5/pXwO1oxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785182143; c=relaxed/simple;
	bh=0+0FpgxhXZSynqK5ywpRiZWr3OxJv70PrMuQH3NxVZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZOTv0Jz8hCxDWdvC/EIcw6FL7w7nPxakGSoTWx8++/tF4t6GP1wh67EtfKpG/yLF2Gzu6IcbR631KDgR5Dfj4F2AX5Wpo+KIXyTPEeC/4qYmnrM3GHJSSJNf1LUZIYZOzn22wadeKLVBXdafeq7X2niAiNk0GEFSpw4U1n3X9L0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=REbrc+Qd; arc=none smtp.client-ip=74.125.225.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="REbrc+Qd"
Received: by mail-wm2-f9.google.com with SMTP id 5b1f17b1804b1-49553b57612so6552895e9.1
        for <linux-rdma@vger.kernel.org>; Mon, 27 Jul 2026 12:55:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785182138; x=1785786938; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Bp4UVMPxYCZ+qb6SwwXK0ZWZ7JZACFBpdebUt9KFjBc=;
        b=REbrc+QdYq93ELpwMQiMaX6aEsk/T5EUJcSqOjHvluTVu7SfPNGrdqiPZXTWEdZXFc
         K8ccZqVhHUNSrV4iYdqDIjpZLFqZkbEcsRxuWWLeGM/qpbM1wSeG143uyIFNh8eSHOYJ
         a/mszXV1GJF5KvyHSscKaZYMvgyViH3iGqgEh456pMZcLTWURRrf/TMWAq1Olo5sETH7
         S5d+9BB//AX00Q2rmJ4IgksZXBVcyX4igV98dzf6h52XZGAde1S85E6hPoLMRGcpHUFt
         sN1lNmu+29CnHjPXxLtFgdZSSs/PmTVRLGtgx7+YHOJ6ZeYDO7oQMSLk8HVPsibPuhgp
         rR1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785182138; x=1785786938;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Bp4UVMPxYCZ+qb6SwwXK0ZWZ7JZACFBpdebUt9KFjBc=;
        b=dka+ztFNMV1Sv25mC3PtyWHF0JtrRhgCwH7FFSfRRap2QKklOaG4+EzEscG6F6m5AQ
         rHfNvOGVstQc0tXIJE++LATtkxp6N10TQjGR3HLwOugAfiABkw0d9ILB+OeYgiyeraf5
         HHMxoSJ3u/N6G53lIhDUeNI8lDmGsSpyyB8w/HvY3X3on3UpJ3gvYtMJvl7UK27rfhv8
         Tufiz9OhpbucDmhDGO9fgvFaIl2q9jb7RWKqpyCspvgnmHZFkybUKTtF3vfryqidcbkV
         V+9nvcW1Op8Tf7qdwCodw2C30h8VbarewdzrhqjnA0V3925vgW6oED2sNKpCyCMwmJ3Z
         syvw==
X-Forwarded-Encrypted: i=1; AHgh+RojpOuGTHhAYr2SWa5d9YdRttEhTX+0ZO5LSyxB9ty3IPzvY+gDRAI3+0XEiKyoRJp4e/j8cefmVBGQ@vger.kernel.org
X-Gm-Message-State: AOJu0YynTMY8qubOHrE+rHJ4fn4krwnxn0sMdF6C/IESGDnylM4i0dz0
	pXdj6XtZfb3NFf2UyMFlc9jK9E6qo4xaCnxhRU5xy9eSh1dQDI/ERdzO
X-Gm-Gg: AR+sD12K99ZvMbd/Akt/pSB9tPWSedRbk9kCIda3D2ftIOvOjh0f31JZLOaQEiCtHN7
	gCsAAagxHwAON3yIlMOjjtrBaJ8Y4MvdE/vlJz0Jyuax51xUdUcR/hL1UZoiSAE7/tP8/ZmetPw
	Nl2wAlyVy9JbCE8ZSXTmAC9Ax146V6mGguWOArxbBPX4uJt/K5u/LXTt1KyDifF4zAhgvpIWNKi
	oCzCz6yD0HcOwU6RoZ55RYdZlcysrkCEPUUrkYzK/AILRGghik7lW4C7N7XelVruTCVlbsnDA6q
	mpZTDXq8yVdIwTRBnV6R3AVdlyYuuOUUjg8/OVmT7R6KBRg2S+k751PTgujWH6jdWYcpUXM0piP
	OgvSuNwcv9EVQ7262tFatbK0PGBYg/FrRs27jLWGnY+0jSUvr/rhojmVvBDRhEmMsJZEb8sZrXy
	x3vQ==
X-Received: by 2002:a05:600c:45d5:b0:495:4cb6:71cc with SMTP id 5b1f17b1804b1-496b570fc0cmr113216675e9.5.1785182137386;
        Mon, 27 Jul 2026 12:55:37 -0700 (PDT)
Received: from fedora ([212.253.194.180])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-496c4625161sm16097365e9.14.2026.07.27.12.55.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 12:55:36 -0700 (PDT)
From: Serhat Kumral <serhatkumral1@gmail.com>
To: yanjun.zhu@linux.dev
Cc: zyjzyj2000@gmail.com,
	xiongwm2026@163.com,
	jgg@ziepe.ca,
	leon@kernel.org,
	dsahern@kernel.org,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	serhatkumral1@gmail.com,
	syzbot+8c9eede336e3a843750e@syzkaller.appspotmail.com
Subject: Re: [RFC PATCH 1/2] RDMA/rxe: drive UDP tunnel socket lifetime from the GID table
Date: Mon, 27 Jul 2026 22:55:21 +0300
Message-ID: <20260727195521.34907-1-serhatkumral1@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260726140253.26870-1-serhatkumral1@gmail.com>
References: <20260726140253.26870-1-serhatkumral1@gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

I was pointed at Weimin Xiong's "RDMA/rxe: Hold netdev reference for
transmit skbs" (v3, 20260716055255.157674-1-xiongwm2026@163.com) and
tested with it applied.

That patch and this series conflict in rxe_notify(). Its hunk carries
"rxe_net_del(&rxe->ib_dev);" as a context line, and this series removes
that call together with the function, so neither order applies with a
plain git apply. I resolved it by keeping both rxe_flush_qps() calls and
dropping the rxe_net_del() line:

	case NETDEV_GOING_DOWN:
		/* Start draining TX queues before the netdev disappears. */
		rxe_flush_qps(rxe);
		break;
	case NETDEV_UNREGISTER:
		rxe_flush_qps(rxe);
		ib_unregister_device_queued(&rxe->ib_dev);
		break;

If the tree where the crash appears resolves it differently, that
difference is worth seeing.

Four kernels on f2ec6312bf71, same config and toolchain as before, 120
runs of rxe_rping_between_netns.sh each:

  f2ec6312bf71                            120/120
  + this series                           120/120
  + the netdev reference patch            120/120
  + the netdev reference patch + series   120/120

No KASAN report, GPF, Oops, refcount warning, lockdep splat, hung task or
RCU stall in any of them. The module symbol tables confirm each kernel
carries what it should: rxe_flush_qps only in the two with the netdev
reference patch, rxe_add_gid and rxe_del_gid only in the two with this
series.

Four kernels reporting nothing made me doubt the setup rather than the
result, so I checked that it reports faults at all: a deliberate NULL
pointer dereference injected into the rxe transmit path, during the same
selftest, gives

  [   69.131350] Oops: general protection fault, kernel NULL pointer
    dereference 0x39: 0000 [#1] SMP KASAN NOPTI
  [   69.141660] Workqueue: rxe_wq do_work [rdma_rxe]

It reaches the console I capture, my filters count it, and the iteration
is recorded as failed. From userspace the selftest just hangs.

So it still does not reproduce here.

thanks,
serhat

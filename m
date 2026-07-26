Received: from mail-wr2-f0.google.com (mail-wr2-f0.google.com [74.125.225.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1D214908D1
	for <linux-rdma@vger.kernel.org>; Sun, 26 Jul 2026 14:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.64
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785074590; cv=none; b=OoX86jkk48Y24XlnwfsT/Q88S6HYUtmeaPf/zn4zU34IAeocE9S72YaEHXjUUONbLmlo9IKWx+Ya23ovjUprL1MuxFwO4MuzNxC99Qy9Pwr3HhpsJqXurVtovAdYx4WYbEXYLGdk3sPvHLkpIcCLR2EPL0gWIc5wgxzPuJ7ipFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785074590; c=relaxed/simple;
	bh=XpKwwfFbDSL3QpoUQXGKuf456OAUxDN1RPIl/Ciibgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ojg5wscpcrlhqQRskIgrKHgYclf5Fvq5lv3/cuAFctq5EnKcZ+mEDP7KA2qq+nLE/vf9e6TngpkxTl64pS8e6wZMu/Zh9FbznYb941VOX0UkxyJCQi5RtLbe6B74q23Hc4q7rdHCfawULJhgeP7Sor4aQdfyvuFnxpgTHmJQdgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OCAs1OpC; arc=none smtp.client-ip=74.125.225.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OCAs1OpC"
Received: by mail-wr2-f0.google.com with SMTP id ffacd0b85a97d-46cbf263216so1038592f8f.1
        for <linux-rdma@vger.kernel.org>; Sun, 26 Jul 2026 07:03:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785074587; x=1785679387; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5kvX1jnfnAWUHZyfST0uFEFJslh2Np5BzOfQst8CwGU=;
        b=OCAs1OpCDTJksnXjSQ4rNrJCfXOA/La7dEDfpArgsGMwjw4PRR79ktnUiPAR+zuvgq
         uOP1TmiPOCbW03i9OFocYQC7ejO1F7RBcVREnfG9Q25hH2x5EyFfBjreaX3cnSVSBzS6
         zMV3FPYJ1cbMylGSzWk20GfcwBCM1UuDbmSpl9s8HVahLPxCevi00UKdtNM62zbfK28q
         lF82oklnVoldl3FaiFhz+muJOOol2tUgpyftC0oFVCk3IRYMpcpXPIlIrIfEIcCtROyy
         CzHsWs8FAPS9Ca1qd5MRxi/Frj6fO8U3NzkxCzslQfTyJnXqP47GoQQj9jDLG6/rBcP2
         txGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785074587; x=1785679387;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=5kvX1jnfnAWUHZyfST0uFEFJslh2Np5BzOfQst8CwGU=;
        b=siX4G3RfSji3JSB8g5GXdIT7SOCItZO8vXlD/eB0dZzhYBLcaKBdX4u2okFXn1QDkz
         4XPMqWWSieLNvlIWfFbDo8hyiYMKtdUYbasQLqlMGtGaITAFOfi0yFV44jOzQT5RcVhz
         SQ2X0dBUFsOeMh9dUVwVFPy7EhIPn2KehPBh8/Y8gLoRqclzSC6GxLjsE+DxXu9/gh6q
         QN+FScHUihtXeZK5dgs5zdn9ja8kynoXQzoNciPLJYXV242kG3rOd4m/14TaAId0zaoG
         ahtaF1jJgeKgZWu+3tQpMprwvZPHruEyNjcIvOLHj3S/9+WMzp6vvpr+Lopve7rHq2UV
         FCrg==
X-Forwarded-Encrypted: i=1; AHgh+Rqrq4CLWTGVofd8f5nvtG5VDtOiSBESvZktXKOU11PZWPqax8rw7pg3SgAlVXWeK9pD756M6T3EC7i+@vger.kernel.org
X-Gm-Message-State: AOJu0YwbE2G2/vkm+9THwzVuZXSPE5/n8VUzxTsqsfElkw4TwNgBKwjj
	RWic0gSERJcEYfCfalTiAxdj2aUv70PaeVSJxg9mGjOwLOXyguop/6sFkYPN41rr
X-Gm-Gg: AR+sD12HG6caYhB1Dmwyvl1diR8Zwhn71dEFxLxTZYqd/fm49EhVKQwlc3mkwo5AlGl
	fTOb+trsj5SOWZ53QjBhYBPMwU3dyQWNpWOgMvNWpiEeI0IRvHSZCN55A2uPbs8RUO4kOrekUCa
	ejF7BJRyMjxYG400ERZruvZKvNnihN63tkFhkxzQ0nvb4sNfPmtjYAksh3t9Qup1tjeXVpPLwII
	Gb0biIb5vbB7VbfI6tTYVsesGaXCv+tTkgFp+6lNtzXfyfSXonHh+VqsogaRI/1bxJbZuEqScEr
	4tInvnByGtYh5N9RvA/uKN6kPjyfOZ6SyCmseUvVf3Adylod6zdS5nM1PdzMNPXV3dsxcSBIAJa
	11yrdEdNdYc7nV2Jp7C1xtCMx9M7Ueem8QPAs07ROcjv0YCFnlQDU97vzn8xfybhr+B2xUa8dVp
	W2SA==
X-Received: by 2002:a05:600c:4709:b0:495:71fc:3a64 with SMTP id 5b1f17b1804b1-496b56ff1fcmr64627235e9.25.1785074586730;
        Sun, 26 Jul 2026 07:03:06 -0700 (PDT)
Received: from fedora ([212.253.194.180])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85c6e9a2sm41825561f8f.35.2026.07.26.07.03.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jul 2026 07:03:06 -0700 (PDT)
From: Serhat Kumral <serhatkumral1@gmail.com>
To: yanjun.zhu@linux.dev
Cc: zyjzyj2000@gmail.com,
	jgg@ziepe.ca,
	leon@kernel.org,
	dsahern@kernel.org,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	serhatkumral1@gmail.com,
	syzbot+8c9eede336e3a843750e@syzkaller.appspotmail.com
Subject: Re: [RFC PATCH 1/2] RDMA/rxe: drive UDP tunnel socket lifetime from the GID table
Date: Sun, 26 Jul 2026 17:02:53 +0300
Message-ID: <20260726140253.26870-1-serhatkumral1@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <9f89e398-9848-40bb-a674-9719d94a6151@linux.dev>
References: <9f89e398-9848-40bb-a674-9719d94a6151@linux.dev>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> I suggest reproducing the problem locally first, which would help avoid
> a lengthy back-and-forth discussion.

I rebuilt your environment as closely as I could and could not
reproduce the failure.

  base commit  f2ec6312bf71 + this series
  config       your config_linux; "make olddefconfig" changed 15 lines
               (rustc detection and openssl key types; Rust is not
               enabled)
  guest        Fedora 43, rdma-core-58.0-4.fc43, 16 vCPUs, 16 GB
  qemu         q35, virtio-net on a PCIe root port, so the NIC is enp1s0

  [    0.000000] Linux version 7.2.0-rc3-rxe-l2+ (root@210da8ac5887)
    (gcc (GCC) 15.2.1 20260123 (Red Hat 15.2.1-7), GNU ld version
    2.45.1-5.fc43) #2 SMP PREEMPT_DYNAMIC Sat Jul 25 15:08:57 UTC 2026
  [    0.000000] DMI: QEMU Standard PC (Q35 + ICH9, 2009),
    BIOS 1.16.3-debian-1.16.3-2 04/01/2014

Same kernel release string and same DMI line as your Oops, and since
the config is yours, KASAN, lockdep, PROVE_RCU, DEBUG_LIST, KFENCE and
kmemleak are all active. One deliberate difference: the guest runs
SELinux permissive.

What I ran:

  rxe_rping_between_netns.sh from the tree                  120 runs
  the same script with its "exec > /dev/null" removed         3 runs
  make -C tools/testing/selftests TARGETS=rdma run_tests      2 runs

All passed, with no KASAN report, GPF, Oops, refcount warning or
lockdep splat in any of them. The result lines of the suite run:

  ok 1 selftests: rdma: rxe_rping_between_netns.sh
  ok 2 selftests: rdma: rxe_ipv6.sh
  ok 3 selftests: rdma: rxe_socket_with_netns.sh
  ok 4 selftests: rdma: rxe_test_NETDEV_UNREGISTER.sh
  ok 5 selftests: rdma: rxe_sent_rcvd_bytes.sh

To confirm the setup would actually show a memory error, I loaded the
KASAN test module from your own config ("modprobe kunit enable=1;
modprobe kasan_test") in the same guest, and the reports do reach the
console I capture:

  [   66.611585] BUG: KASAN: slab-out-of-bounds in
    kmalloc_oob_right+0x72e/0x7f0 [kasan_test]

The same 120 runs on plain f2ec6312 without the series also pass, so
here neither kernel fails.

Whether what you see is a regression or a pre-existing bug can only be
decided on your VM, since here it does not fail either way. Short of
that run, two things are cheap to produce and would help:

  git log --oneline f2ec6312bf71..HEAD
  cat /proc/cmdline

On the port 4791 question you raised earlier, I measured both sides.
A script binds UDP 4791, then runs "rdma link add rxeC type rxe netdev
v0" on a veth with 10.9.1.1 and prints the exit status, the GID table
and "rdma link". Without this series:

  link add with busy port rc=1
  error: Operation not permitted
  /sys/class/infiniband/rxeC/ports/1/gids/*
  [   99.810196] rdma_rxe: Failed to create IPv4 UDP tunnel

The glob is unexpanded because no device was created. With this
series:

  link add with busy port rc=0
  /sys/class/infiniband/rxeC/ports/1/gids/0 fe80:0000:0000:0000:288a:0cff:fe1c:042d
  /sys/class/infiniband/rxeC/ports/1/gids/1 fe80:0000:0000:0000:8435:54ff:fe3e:1578
  [  100.525123] infiniband rxeC: add_roce_gid GID add failed port=1 index=1
  [  100.529972] __ib_cache_gid_add: unable to add gid
    0000:0000:0000:0000:0000:ffff:0a09:0101 error=-98
  link rxeC/1 state ACTIVE physical_state LINK_UP netdev v0

The GID for 10.9.1.1 is absent, only the link local ones are there.
This is the trade-off the commit message describes, measured on both
sides.

Thanks,
Serhat

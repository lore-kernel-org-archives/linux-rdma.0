Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793713789;
	b=c5nfkIamIBa2y2TpII5OpD5RMt9Lgr1BG/TF+INEXg5mFKEGXzX9GJfiFexrMOn4DEJP
	 xOTi1AgC+CiUeg3A/NirusqGQwGlQNAv8d9IPP61nGMW7SI/yi0U6ZasgD2SQ84392spC
	 lmuYygDBz4vZD1l9Crdbdsr9t6/ADmUcEdyXXGuhXh0MPQXtu7Fsii7C1CkZsj2nHisFd
	 TBHRh9H1KEy4vEgaVlC7IKlj15aepYYLJ6J9BFIXjoxNUuCIuRM0ZqX4sDin5ToXvfh2H
	 C4xQecLs9VpJmPZAxCp0nvtc3EtTJW2nKRlw6NZLYvs0pltcgg03AreFZCL34/Vm/OQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793713789;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NiTHky/qrLqHb3kl55Ue+tJp0FqEUYQu+BGLrGjyymA=;
	b=Czx+rM8KANIE/MaYIutrqOC2cNAyI2vdWs/12riQ8veFry9i+ylgWSC/i2i6fbczRVgb
	 cG1iiU8aPbVsMsdbcW1nyyRsxySDRxuY23b6cNEYZ8E8u2GbPK5L0h54Lz3Yk0psl6EBt
	 nNMMwIIrw7jXkxn5pLjzlnLWH/UTQfO1zgPXY4we07W9jQ9TbJ88h638kEYoibv+v+pjy
	 gG7p6HLvY24LATRrSjS3IQBnnCAuTFJevyOEDasld1ns0FhDM7UbWWbtSCkxY5zwsWyEW
	 ligbwmA0frHSBfv8EGFAH708OpKsIAmMzL4AXnNKz8htMUx/TaqShB8R9xFb9KAraQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=S4yaRCoY;
	arc=none smtp.remote-ip=209.85.215.181
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 985E1606A327
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 13:49:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 985E1606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=S4yaRCoY
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-cc502d509c0so1699720a12.2
        for <linux-rdma@vger.kernel.org>; Tue, 03 Nov 2026 05:49:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793713788; x=1794318588; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NiTHky/qrLqHb3kl55Ue+tJp0FqEUYQu+BGLrGjyymA=;
        b=S4yaRCoYEDIdQx9nd6MUMVyTgQ3qjcEUxTHHScdNekTUOEs49FJUebRnufc4CA0UfB
         i7VitCm15MSdNwcMNksQK0QvjqUYVkkYlVncknLcA07egs+zeTVEfXE1NtRR8C4Rmwe/
         59e38cdM5NFOiGuDV80fmbH2/2EcpFpNNYCnNsD8RlFpvSi9QEqn/BNMOG25RZbdiKzL
         nwgZBDetxUxC+AGwv/eMcJTCjKXZxosq4tRZkao88Q0YR5PIIrcjyTxKOYIp9G8Yg7Lr
         ichja6cJTKLXLq+hstuadyHfGXBIFc2bnYzaPc5K4FMhCQqDTfAe8HhC5gFbMTWcqqBO
         W3+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793713788; x=1794318588;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NiTHky/qrLqHb3kl55Ue+tJp0FqEUYQu+BGLrGjyymA=;
        b=d4ePWuYFe271Tjvky0hPKhtNaU2esfuA3qcGoraNisBojyQ+spdR9ElsisZAG5ubID
         dTSpwgA3nTsG/Pk7nxxm2opcnDs0EoptXv2I/ea69HLwsGSdALTqOiXTPzm0fKZ6xbBa
         yjsekuPbwENGCdMYe/VAqFMY6EPr8889n+VA/8mQ6wDtBhQY9l3kmFm1wynT3Su+HYaO
         VNS4ONnWXdgBCskMkRWASHWfFQDURqS58jRKy0yY2cjwoUc/fGbYrvkWJNB3JF69KgwC
         LHUTI4a6Vvakb7cVcANNDPOd+ipVIS+mv/eCjq3CtdheMJwdnECTTTxiDfIdcwGrfjUJ
         uocw==
X-Forwarded-Encrypted: i=1; AKwUvBwaOngp4EJrjsu3RpW93zKZHkcjodRinALsrOX/f80QBwuZvhLNd5yS2tKPJTf1+04G1HNu+PuH6YBm@vger.kernel.org
X-Gm-Message-State: APuU4Z/gfH3XfK+55NNAMVrItC2z+hfqkhojN8vt7uioGbUgnzLuVjMe
	L36nLew//3b1nePZ1lP+f6NOfql564XQk6wr6B5z73aZeazM4v+mA5EJwrKsvyqSCwo=
X-Gm-Gg: AYBFou3MVgLX97UwIMLuSRt48QmACeE3vHyZdIonfb7mBgYIYSqhrCGwtFMTA8YbdeE
	R6masTLDMVvCQ6QGHJe7iigVsxNO2D/MKYN3XI2zvrHFhG9ue6hvRGHFn9AAYkwy0NNutldf69T
	2a571mESbxJKs3nPRzeqFLVb9JtQneHSt0uU6FmtnRmaH1PXcmQlD6dR2V2lr32jhFPRIFAEyEP
	EiaCsM4bLODFnxxA9ooYiIfeFi6XgA93CzEQap7b53K69Ns7H0lVbX/LoVeTW0zE2HDAmHf111Q
	l9VORd7Xk8z3o87EFir1mShJL0V0am0Ej2Ff0msRUKgTWj759yYBCq+kweJGrilULI+ylbf0p1e
	qP+5EHngP2IOSwj2ewP4+vipjhPvk0IK5EjAAYGKBlfcsiAn5sOUlVHW9wz3VwqspggpxyAlqOB
	nd1UeUHhb7L8VNfglwngw1Anm5QOAtTd/gvJ0KgrLjXglKvWYXhtyx+az4Ta+BoJqpW0IoZh6h0
	2tDmPMeZ9hU9//L7DlMaWllma8BK0E1r3Q5LxGuHPXVs4abmoFN3RM1FWmTkT+y2gRiVU3eRLJg
	eyt4H5W9qoP0p/ValOs0C3BrfEnIu2m06ZamCdeH0bYVBrncGDpzdhrVZevjeJAo
X-Received: by 2002:a05:6a21:b88:b0:3e1:c6e6:d101 with SMTP id adf61e73a8af0-3e928da40d0mr11428618637.29.1793713787841;
        Tue, 03 Nov 2026 05:49:47 -0800 (PST)
Received: from localhost.localdomain ([2400:d802:dd7:8000:314f:4575:be3:a064])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cdb36449db7sm1446391a12.8.2026.11.03.05.49.44
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 03 Nov 2026 05:49:47 -0800 (PST)
From: Yuqiang Sun <izaiahsun@gmail.com>
To: leon@kernel.org
Cc: haris.iqbal@ionos.com,
	jinpu.wang@ionos.com,
	jgg@ziepe.ca,
	guoqing.jiang@linux.dev,
	lgs201920130244@gmail.com,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 1/3] RDMA/rtrs-srv: Do not free the path on path file creation failure
Date: Tue,  3 Nov 2026 21:49:39 +0800
Message-ID: <20261103134939.55513-1-izaiahsun@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261103122024.GG264423@unreal>
References: <20261103122024.GG264423@unreal>
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

On Tue, Nov 03, 2026 at 02:20:24PM +0200, Leon Romanovsky wrote:
> Interesting claim. How did you trigger the KASAN warning in the RDMA ULP?

With soft-RoCE in a KVM guest, with both ends of rtrs in the same guest,
and failslab standing in for an allocation failure:

- Kernel: rdma for-next c3e8e9451e6f, x86_64, with KASAN, RDMA_RXE,
  INFINIBAND_RTRS_CLIENT/SERVER, BLK_DEV_RNBD_CLIENT/SERVER, BLK_DEV_RAM,
  FAILSLAB and FAULT_INJECTION_STACKTRACE_FILTER, all built in.
- In the guest: "rdma link add rxe0 type rxe netdev eth0", then failslab
  is limited to call stacks through rtrs_srv_create_path_files()
  (require-start/require-end set to its range from /proc/kallsyms,
  stacktrace-depth 32, probability 100, times 1, interval N), and /dev/ram0
  is mapped through the rnbd client:
  echo "sessname=s1 path=ip:10.0.2.15 device_path=/dev/ram0" \
       > /sys/class/rnbd-client/ctl/map_device
- The server handles the client's info request in its completion worker,
  in rtrs_srv_info_req_done(). With N chosen so that the failing
  allocation is the one in kobject_init_and_add() of srv_path->kobj,
  rtrs_srv_create_path_files() fails, its kobject_put() frees srv_path
  through rtrs_srv_release(), and process_info_req() and
  rtrs_srv_info_req_done() go on using it: that is the KASAN report in
  the changelog, followed by more in rtrs_srv_close_work() and a general
  protection fault. Failing the stats kobject instead gives reports of
  the same kind.

The steps in the guest, after boot:

  ip link set eth0 up
  ip addr add 10.0.2.15/24 dev eth0
  rdma link add rxe0 type rxe netdev eth0
  f=rtrs_srv_create_path_files
  start=$(awk -v f=$f '$3 == f {print $1; exit}' /proc/kallsyms)
  end=$(sort /proc/kallsyms |
        awk -v s=$start 'found && $1 != s {print $1; exit} $1 == s {found=1}')
  F=/sys/kernel/debug/failslab
  echo 0x$start > $F/require-start
  echo 0x$end > $F/require-end
  echo 32 > $F/stacktrace-depth
  echo N > $F/task-filter
  echo N > $F/ignore-gfp-wait
  echo $N > $F/interval
  echo 1 > $F/times
  echo 2 > $F/verbose
  echo 100 > $F/probability
  echo "sessname=s1 path=ip:10.0.2.15 device_path=/dev/ram0" \
       > /sys/class/rnbd-client/ctl/map_device

With verbose=2 failslab prints the stack of the allocation it fails, so
N is found by trying N=1, 2, ... until it is the one in
kobject_init_and_add() for srv_path->kobj (21 in our build).

So it needs an allocation failure while a client connects; nothing else
is unusual. I can send the full KASAN log, the init script and the
kernel config if that helps. The client that triggers patch 2's
use-after-free from the network by sending an empty pathname (fixed by
patch 3) is not public; I can send it to you privately if you want it.

Thanks,
Yuqiang

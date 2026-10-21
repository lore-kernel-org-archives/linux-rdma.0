Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792612719;
	b=ZiszxgQRDwh/XVwhm7JDtkeQljtcgaxO8bJJGQJdnsIFaS7b077HWK1vo1QlY90/7TpJ
	 ndKQukRaAW57B00Sr1ziKDw7SeYOAUvdsqEdwOWAntP9W9aI1F6FLotubp7KO+AS8sCD2
	 PvomftaEOjQyhYHk8fn5fCG6h1nZsFPrab0tVpLThATcOC83biaB8EX93ueaKTF45UGsf
	 Mf63bEDfXqvYgcwGhMUActjDQeRti5BSLyYAthXHsrCkWc8v3SBwvgc4TvAy/G3JsP8uF
	 UwZ8tUIJdlggbtFsn5GlULt77Ua5duSPCBAJtBw0B6FSMLtKGnkCb2M50XIU6znpxog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792612719;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=U84ChnQDxZcRu2DWSeHbLV+TAjKPwPC6JYP/PTzg624=;
	b=nVpKVGuWC0N6Q1JCXRcP4dRBoh/PSCGGNRk04MR33z9PQNEBy6E1jmW+gWGU54rYKGwj
	 t2EaGPfzXDStgHvRHNqsAUWm4n9RZQ2dWSxtA4pHb8vu1HVVM/1XnMkoZjWNadTQsNZ80
	 emaPbg+J7ITnTKXZvqzy05cuYSuiUzWTU/HJVNlZzbTGLRnR/9yx7ordn5NtzZ/lzpYsV
	 gYi7yQrXqVOiMRu1Aa4zmRSYa32+vj52X8b+WtMtkgkfPLYH7KIo/ObrAkkvBfFrSkjqG
	 Oszl72cxrlwuqFJNU7hELLUzLGN11g9RvCB01EE43tKFn+kJidj/WpPoiG8INvSRflQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BvesqopX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59359606A319;
	Wed, 21 Oct 2026 19:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BvesqopX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D9031F000C1;
	Wed, 21 Oct 2026 19:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792612718;
	bh=U84ChnQDxZcRu2DWSeHbLV+TAjKPwPC6JYP/PTzg624=;
	h=From:To:Cc:Subject:Date;
	b=BvesqopXwiW5mRVKkG9yY8y0kJPiFQKacp6stMV0aAVire0Zb2PfMAOvxl3L624Bf
	 aJElPOxxtHmgdwm/g08G/bUd/lt/vghvDMYTeT5IT9xVbnBWj0Mgj71ycTfEKLdOih
	 Ymgfs1jyq8dioWzNB9b+vb1AdOzkVao8dktOnNi8zcxCOZxeqKAExTn/qWg82FZYej
	 KvHaDHsCm7pkBkVOWw5jIEA1Ox8dm7DgIXFZMzaKxZxySR+XFRRm6eMZmqQabAqrZB
	 e8h0FxWF4onm9b5haojTLioMSOdCAXrhp79m/nkGBHfdXWks7G3FN9a/Mc2kEhKMRl
	 vscE+Mb28qwsA==
From: Allison Henderson <achender@kernel.org>
To: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	kuba@kernel.org,
	horms@kernel.org
Cc: achender@kernel.org,
	oleg@redhat.com,
	joel.granados@kernel.org
Subject: [PATCH net 0/2] net/rds: fix init failures leaving built-in transports on a dead core
Date: Wed, 21 Oct 2026 12:58:35 -0700
Message-ID: <20261021195837.142802-1-achender@kernel.org>
X-Mailer: git-send-email 2.50.1
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

The kernel test robot hit a slab-use-after-free on rds_wq at boot with
CONFIG_SYSCTL=n and RDS, RDS_RDMA and RDS_TCP built in [1].  Two
separate bugs are involved.

With CONFIG_SYSCTL=n, register_net_sysctl() is a stub that returns
NULL, and RDS treats that as -ENOMEM, so rds_init() fails even though
every tunable has a usable default.  Patch 1 only treats NULL as a
failure when sysctl support is built in.

Second, when RDS is built in, a failed rds_init() does not stop the
rds_rdma and rds_tcp initcalls.  They run against a core that has
already been torn down and queue onto or flush the freed rds_wq.  The
error path of rds_ib_init() did this in the robot's report.  The
rds_tcp listen socket can also do it when an incoming connection
arrives.  Patch 2 makes both transports bail out with -ENODEV unless
rds_init() succeeded.  Modular builds can't hit this, because the
transports need symbols from rds.ko.

Thanks to Oleg Nesterov and Joel Granados for the analysis in [2].

Testing: x86_64 under virtme-ng, built in RDS/RDS_RDMA/RDS_TCP,
CONFIG_SYSCTL=n, KASAN, booted with initcall_debug:
  - net/main: rds_init() returns -ENOMEM, then rds_rdma_init() hits
    KASAN slab-use-after-free in __flush_workqueue() from rds_ib_init(),
    reproducing [1].
  - patch 2 only: rds_init() still returns -ENOMEM; rds_rdma_init() and
    rds_tcp_init() return -ENODEV and the boot completes cleanly.
  - both patches: rds_init(), rds_rdma_init() and rds_tcp_init() all
    return 0, no KASAN reports.

[1] https://lore.kernel.org/oe-lkp/202610190310.9737b2e3-lkp@intel.com
[2] https://lore.kernel.org/all/atdoGiW_sHlWgOwt@redhat.com/


Allison Henderson (2):
  net/rds: do not fail init when CONFIG_SYSCTL=n
  net/rds: do not initialize transports after rds_init() failed

 net/rds/af_rds.c         | 14 ++++++++++++++
 net/rds/ib_sysctl.c      |  2 +-
 net/rds/rdma_transport.c |  3 +++
 net/rds/rds.h            |  1 +
 net/rds/sysctl.c         |  2 +-
 net/rds/tcp.c            |  5 ++++-
 6 files changed, 24 insertions(+), 3 deletions(-)

-- 
2.50.1


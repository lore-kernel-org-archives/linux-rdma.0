Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F8CF535FA5
	for <linux-rdma@vger.kernel.org>; Wed, 14 Oct 2026 13:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791985217; cv=none; b=kv/B1uJsxVP0lfyLsrRATU5URqAzoY4nYYPv3+5dCO6SyzicfYsq8fWZsBpHuOp1ZQbm1QPqGFkRp1wUOBeQoI7zsyuG/ByMsm+5RQRLlXZN5j9CzTdG+JW4mdS8KXSXtKPphD1aiAiHYj5VLzJFF7aynkxZ5+mYdGoZLxGJK8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791985217; c=relaxed/simple;
	bh=PyLdeeEHDThqMB9grZpq1iyTMBKFxlLGtpCp2tEE8Z4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eLpiQv67tf2CLOxCuAaO+9IscU4p5zGvHQ8MTcWEAQWwGHv+MRsRN65Lk599HSb6wL98C5j6aYujUyHcOMYojxfqpNru6s6iV/emLK2XM+3ZB5HxWDZhOD0wfb+UkmxGivm6/XeZg0Esue0DIczeSxhG8LIotu3HkWqObSEgupQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MDDEkZNC; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MDDEkZNC"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4a02718da81so33227455e9.1
        for <linux-rdma@vger.kernel.org>; Wed, 14 Oct 2026 06:40:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791985208; x=1792590008; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=iHy+jwBHIdnNQeSBeJzVkxI0EtSlpISdpQzIa60gKvU=;
        b=MDDEkZNCkg9MVLCQirpLFn+LawBICrFG7ym9Uo8h132vjm8ERZ800/t1qQuseGCbB7
         avkfAyymqOQcMS+EB9iErcAkQwqlDl8WFlLJgab9Oj1f5T2WkTiqdzGLbhfEkayjwLev
         P1khzhqgNk0XsYiu10d+PgvVY4UbEAEloX8K9zQVCRtkBiiY5wtwj9amCghSm2R/gefq
         J60EcG+ZklUnvh1SDey9o8F2n/udptzvu0Hk84G0GdO4xvtyJHgFGOSjUdIKG2VgmsKg
         w/YLX2opFwGD4GJwLvDZFrSmSXqCaspqZQGk+IkYTRhpzBx7g4zAIuQM4sICaUiNqOFJ
         cb2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791985208; x=1792590008;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iHy+jwBHIdnNQeSBeJzVkxI0EtSlpISdpQzIa60gKvU=;
        b=Iy8zgM+aBV28wqcE55utetugfuAERTn2mDF1YI1Dxx38+98Azk96JPeNoDYm6WObhO
         2qLypA5Wd91ZVOFYaFAa9cUTHg0Y1iTSp/pHBjDjOGNowf2WIaHbNK7h4a8kb+8ztBkp
         DyThWxCcEQXL9KfpOabY1vK+tx5yMSP+18TMzJGRrfQk8fz7RHi94P0+ucdYg1ZawuJ3
         K3bLWUu7648lL07FFn9ZytXJWQpBpmikS61E3ZYFxp8c3PUorNTK4VRITdBpLxRq5rWv
         WJJoiTLlV3dZt0sB2Dchj1cIkkgdWsvZlsW1x6uiMxxWOk0oS6+bPWuESmMjKhMsxC0j
         nyKg==
X-Forwarded-Encrypted: i=1; AKwUvBwly5nFRZyBoSfkYCSwK2n1QjgiUsWu6NGIRIimVIG6ZeCHuSD2/8Qvbkh2ZCq2E+Ok2B9M/WlLUY9g@vger.kernel.org
X-Gm-Message-State: AFq9FYK+ZAg8LBtYc1j/pcuna+Ne3a4BrxgCmLyV8vcjo4mLWH6P45qJ
	sqtgQXVwwrVM/+EYjVC1Hdn774GwRRiYHtCDbd9qa5vfItQ95epVrx7W
X-Gm-Gg: AYBFou3GNrT/qrs7ETUiV9ba3GiOwi7bkcK7cgSIduAYUtf8NVIPwVUqQumXqZyZiNj
	10nVUAgtQpC8QriHeHVLtWdEC4iaoPe8GprwiXM7Ya+oL7+1CI0XGf7nxBhIocKBgK1Pggl6Mie
	d6sdSe/4SF4mJOFA1t1Q0kRIbCksb6TZuuvMH/lBJ54HwHKHLMW8E2i0cME4bNlXocedOdZAXfC
	Ba48t6nz/q624ZCOf8KYwmkmBVvL2sG5YvUkSLT+hQ30XCkYH3c4J18bRWjPzy+hqy7/z2Vdplp
	z7LM67ZskrkXY5w/eUGvjb0Dne+1wDyfPc0ek61lQ0ISF9CyVUQ1vtfrhUCaPV0g0BfIhvErKIv
	MqJpPIOKiMhvLMCOSoGRqsdNRjR55YwaBjwxfuvUHlIj8kgi5yUSkVigDSRAvc5avyOxDGYeyEc
	fv8nc1NWoAN+cy+bNVjXS/IFSzZLSDX+zZVDV1AdnVYooYQkAQoj1gg5+lqOVAsH+plVMEriC2Y
	WumOhKjctMnHIpgYaay2yozH7XQQQq9HQindXGlfhiAoB0SPM0vp4RcztgbQwWXhk3UEW9JlnHW
	AyZC5l62CPOgQ93RXpyoGB3c/1N+EWyrzY+bRJAP3QxLBXXQU7Oxfm8f8jpoZCNNZ4j2KY842vu
	33SJeTKo97i0=
X-Received: by 2002:a05:600c:4f86:b0:4a1:acaa:c355 with SMTP id 5b1f17b1804b1-4a1acaac488mr113319565e9.10.1791985207886;
        Wed, 14 Oct 2026 06:40:07 -0700 (PDT)
Received: from p15v.lan (90.3.169.217.in-addr.arpa. [217.169.3.90])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48de0ac35dfsm12286324f8f.33.2026.10.14.06.40.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 06:40:06 -0700 (PDT)
From: Peter Morrow <pdmorrow@gmail.com>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Petr Pavlu <petr.pavlu@suse.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	Peter Morrow <pdmorrow@gmail.com>
Subject: net/mlx4: no ib device for Ethernet ports without IBoE since v6.6
Date: Wed, 14 Oct 2026 14:39:51 +0100
Message-ID: <20261014133951.3219055-1-pdmorrow@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

Since v6.6, mlx4 no longer creates an RDMA device for an Ethernet port
when the device doesn't advertise IBoE. On Azure, ConnectX-3 VFs are in
that state, so DPDK's mlx4 PMD can no longer open them:

  net_mlx4: cannot access device, is mlx4_ib loaded?

Petr, thanks for looking at this off-list; as you suggested, I'm reporting it here.

What changed
------------
Commit 7d22b1cb9d84 ("mlx4: Connect the infiniband part to the
auxiliary bus") creates the "ib" auxiliary device only when
is_ib_supported() sees an IB port or MLX4_DEV_CAP_FLAG_IBOE. Before it,
mlx4_ib_add() was called for every device and accepted any IB or
Ethernet port via mlx4_foreach_ib_transport_port(). An Ethernet port
without IBoE got a raw-packet-only port. mlx4_port_immutable() still
has that branch (RDMA_CORE_PORT_RAW_PACKET without RoCE), but nothing
can reach it now.

DPDK's mlx4 PMD needs only that: it opens the device through ibverbs
and creates IBV_QPT_RAW_PACKET QPs. It does not ask for RoCE.
mlx5_ib handles the equivalent case by creating the device with raw_eth_profile when
RoCE is disabled.

Evidence
--------
Azure VM, ConnectX-3 VF [15b3:1004], Debian kernel 6.12.107. Mainline
has the same check in is_ib_supported().

- mlx4_core and mlx4_en bind the VF and the netdev works. mlx4_ib is
  loaded, but there is mlx4_core.eth.N and no mlx4_core.ib.N, and
  mlx4_ib never probes: its version banner is missing from dmesg.
- With mlx4_core debug_level=1, the DEV_CAP flags dump goes from
  "UD multicast support" (bit 21) to "Unicast loopback support"
  (bit 32). "IBoE support" (bit 30) is absent on both VFs.

Tested change
-------------
This restores the pre-6.6 behaviour. I built it as an out-of-tree
mlx4_core.ko against the 6.12.107 Debian headers and loaded it at boot
on an Azure VM with two ConnectX-3 VFs. Both got an ib auxiliary device
and an RDMA device, DPDK's netvsc PMD attached both VFs, and traffic
flowed through them. On mainline I have only compile-tested it.

--- a/drivers/net/ethernet/mellanox/mlx4/intf.c
+++ b/drivers/net/ethernet/mellanox/mlx4/intf.c
@@ static bool is_ib_supported(struct mlx4_dev *dev)
  for (int port = 1; port <= dev->caps.num_ports; port++)
- if (dev->caps.port_type[port] == MLX4_PORT_TYPE_IB)
+ if (dev->caps.port_type[port] == MLX4_PORT_TYPE_IB ||
+    dev->caps.port_type[port] == MLX4_PORT_TYPE_ETH)
  return true;
 
- if (dev->caps.flags & MLX4_DEV_CAP_FLAG_IBOE)
- return true;
-
  return false;

I'm not proposing this for merging as it stands as I really do not know this area, rather I am
a user of dpdk via the dpdk application vpp (the vector packet processor).

I'm very happy to test any patches that folks think are a better fix for this issue. Also note, I
used an LLM to assist with debugging/analysis here.

Thanks,
Peter

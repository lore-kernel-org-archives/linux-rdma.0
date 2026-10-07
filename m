Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D3F1378D9A
	for <linux-rdma@vger.kernel.org>; Wed,  7 Oct 2026 18:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791396993; cv=none; b=Hs8/MiXlAOiO8tDX3SdATTX4tDLVhMw91XN/fdBX+lyuapbwtfd1JY+apaAL+VjAio6rbfi06oVDBo5gFTu8uRzLW03FkU2aBxt/cRGkEKJS1e5Kb2m3jxz+DL7fV4zBaz/qg+NMvnBu807py0RJw1KreCBby6V1HdZhf1/2BC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791396993; c=relaxed/simple;
	bh=vn8FTVHGMrT37pYQ+kom/lZJg3xw5yD+Z8WzSqCiJUE=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=ZYk9hjjW/p/EB4L5mkPD7jXfpFzLUoafOXs8SwEqD98PGU7LPrTT8lwDZOMMGGnAz145ez32xhdW/mE88x7h3UaD6heNTdkjxt+GanSNnkR59UnKR3CRDo7h6+WuUYqHDqEhxcQ1YoCQOquguiRAM8GU6Vj7bTKZV754KCUZTSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=pass smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda.com header.i=@toxicpanda.com header.b=IoOsGnJb; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda.com header.i=@toxicpanda.com header.b="IoOsGnJb"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-5339173489eso25441901cf.3
        for <linux-rdma@vger.kernel.org>; Wed, 07 Oct 2026 11:16:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1791396991; x=1792001791; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=+d7uJDJhZJvHZwnUFL8rPNX4HlSixikJ7Pt8tEZOBOA=;
        b=IoOsGnJbJKy36OPNAMat9Kt9v3NAO9/URcCf2sp6GT8SL9vWzNupBMkF+6rnC8584n
         oZNwj+Sr3QMR8BBolnkt4RaBRRTE2VSblWnNQ8eH+8wpGMJy1kj1rqblqLgQ5DzgcFZ3
         1pBJFfk1eX0wM5Oa4FesgtmZXlZJ0zNeH/jXxCpT5a/aygZF+FROZQPIgANH/TedITZ6
         3AhvSAjXpNmtJmeKdIuea8RzIfvNIhjGvfYLzV9MilUV3ne9qvHrxZyxjDATGW5UtjVd
         Ri1Bc2H/lDgCDD01R1MF74ceNjzgrO7e/83pc0gPHPomqOQMEqEYNm4kJAEZL7cz2zbk
         lcNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791396991; x=1792001791;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=+d7uJDJhZJvHZwnUFL8rPNX4HlSixikJ7Pt8tEZOBOA=;
        b=PT6JgrzdeDjq+8xBzE1xgE3WadSyKxysyV6ZNcVr63aXCOSuE9LgiIXO01nSFWNkrT
         uhpZ1gCag/Kls+QNCPWBfOqOqrakhphSQJVaTH1shALRoWNXvXKLPKDun6Bb0egoosWZ
         EAmhEu2w8SyK5ZsCGuURtkZuF4xMPbGznCpm1Z5TjBpp9J0qtUoXvqYBossq0S3MHS25
         cWjMW0ufTtMyBd+kDQgUo4rjvXd40MUd143e2kdDbaCXC/dxBRN90nmXc7wSx4QNGhmE
         n+GIQqQWz8UrKqdL9/09//xOvTmU936Dx24QoyGuatISnt3yaTL+xVGvvuOZ+oYFOazO
         etxw==
X-Forwarded-Encrypted: i=1; AKwUvByrQ4T3DpU9CwRk0kN8XK7jPZJMleuhDPdrtOPOK1e6sIU05ohuGxzvmvndCPDCWb53dqX0n2c8IjA5@vger.kernel.org
X-Gm-Message-State: AFuF++lt4oT37F+h6V7O915yrIMqknYD+s6XWj0ewYvmML9pHyJ7+yEZ
	xF2jKF1HTLpiSx5L3bdQ2CQgD4qJcVcs1lw1bRXN4goH2acRZxObeMQSzHN/uT+Cqwc=
X-Gm-Gg: AYBFou0z4XyNleTJ5IhrHJM/nQKMpMfLEzBAZbz1btODw56Vs72EWhRheDmtmL/fPJl
	hlUGFp9H0lmQI1aeNLrpXCCozgQIMFELhGcvFuh7boZ9nieUVjcJqMuFJ6byXQCLdKuyiRbM1y8
	6aqj+YqgIWEy84pZjHrG9iahp0wt6aVbMV0+zqt7J2LQ2oS6GSGmT/Oit/OsT9X/3l0EDgdPwKV
	9IOPBD72sUl6SQMGfC1uCHMu8ezvd65choP+28YSYro001nPVfulbxtyjuqrM4u/5SJ4WDqxUhg
	Xiejr8HkqZCuHgULO5/CMbGufuVuXRreINdfPOmkyrf1NLQC4y2LkOP58oiMn5JS7RXoGnhG267
	bQ2bgkdDwzi/evuXKtqftxgZKnJAOsY8yFuqL5EAryYqlSOMbYHcqIOwXYndo2qkr6CCuuaq6Lb
	SaijjYSGHMJXZid8rG1vC0sKyIKv0Xg5E15xwMdkraqpmra2YIPJFRBQdoShzfB1CZaossBzby8
	bRpS4onhFpOQZw=
X-Received: by 2002:a05:622a:98b:b0:535:15a9:2516 with SMTP id d75a77b69052e-5357560fcb8mr47504081cf.53.1791396991271;
        Wed, 07 Oct 2026 11:16:31 -0700 (PDT)
Received: from toxicpanda.com ([153.61.196.242])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5357209ff04sm25811551cf.7.2026.10.07.11.16.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2026 11:16:30 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH net-next 0/9] net: stop calling __pskb_pull_tail() from
 drivers
Date: Wed, 07 Oct 2026 18:16:13 +0000
Message-Id: <20261007-b4-pskb-pull-tail-drivers-v1-0-9512b0fb977b@toxicpanda.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAG+MxmoC/22NywqDMBBFf0Vm3cEHQWh/pXSRiZM6bUhDJoog/
 nvVbru8r3NXUM7CCrdqhcyzqHziLtpLBW608ckow66ha7q+bZoeyWDSN2GaQsBiJeCQZeas6L3
 x1F17w62FfZ8ye1lO9h0iF4y8FHj8Ep3oxa4c6KNLVhkp2+jGwwqpJlOf5v8z2LYvyPZACbsAA
 AA=
X-Change-ID: 20261006-b4-pskb-pull-tail-drivers-ff4fb2964e1a
To: Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Eric Dumazet <edumazet@kernel.org>, "David S. Miller" <davem@davemloft.net>, 
 Andrew Lunn <andrew+netdev@lunn.ch>
Cc: Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>, 
 Mark Bloch <mbloch@nvidia.com>, Leon Romanovsky <leon@kernel.org>, 
 Juergen Gross <jgross@suse.com>, 
 Stefano Stabellini <sstabellini@kernel.org>, 
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>, 
 Tony Nguyen <anthony.l.nguyen@intel.com>, 
 Przemek Kitszel <przemyslaw.kitszel@intel.com>, 
 Manish Chopra <manishc@marvell.com>, Rahul Verma <rahulv@marvell.com>, 
 GR-Linux-NIC-Dev@marvell.com, Shahed Shaikh <shshaikh@marvell.com>, 
 Simon Horman <horms@kernel.org>, netdev@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, 
 xen-devel@lists.xenproject.org, intel-wired-lan@lists.osuosl.org, 
 Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1791396985; l=4206;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=vn8FTVHGMrT37pYQ+kom/lZJg3xw5yD+Z8WzSqCiJUE=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QNQafSGevfmZO2PVgBdAMDrT/Q8BcDOZO7ALSZDi6LHzWalQ1RcI/ykJ522k74cd/ODbB0drvUX
 1QhkjFs1aWQY=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA

__pskb_pull_tail() is the slow path behind pskb_may_pull() and
__skb_linearize(), and drivers shouldn't be calling it directly.  It
takes the number of bytes to pull relative to the current head and does
no bounds checking on it.  Ask for more than the skb holds and it BUG()s
in skb_copy_bits().  Ask for a negative amount, which is what a caller
computing "len - skb_headlen(skb)" gets once the head is already long
enough, and skb_copy_bits() is handed a length of nearly 4GB to copy
into the head.  Under KASAN that shows up as an out-of-bounds read of
size 4294967288, after which __pskb_pull_tail() returns success with the
skb's head and paged lengths no longer matching its frags.

It also returns NULL on failure with nothing making the caller look at
it.  Eight network drivers call it directly and four of them don't
check.  All four are RX paths where a failed pull is followed by
eth_type_trans() or skb_pull(), which BUG() in __skb_pull() once the
head is shorter than what they pull.  As far as I can tell none of the
four can fail today, since the skb is fresh, isn't shared and has room
in the head, but that only holds because of how each driver happens to
allocate.

pskb_may_pull() and __skb_linearize() take the length the head should
end up with, check it against skb->len and fail cleanly, which is what
every one of these callers wants.  Convert all eight drivers to them,
check the result, and drop the packet on failure.

The last patch makes skb_condense() check its pull as well.  It can't
fail there today, but it would undercount truesize if it ever did.

The callers left in aoe and xen-netfront are fixed separately, through
the block and net trees:

  https://lore.kernel.org/r/20261007-b4-aoe-short-packets-v1-1-db5155f7bb9c@toxicpanda.com
  https://lore.kernel.org/r/20261007-b4-xen-netfront-short-head-v1-1-12d7113a7e4e@toxicpanda.com

Once those are in I'd like to stop exporting __pskb_pull_tail() so new
drivers can't pick it up.

Testing: every touched file builds with W=1 on x86_64 allmodconfig
(ftmac100 on i386, it's 32-bit only).  e1000e under QEMU, which hits
the converted TSO workaround on every TSO packet, passes TCP traffic
between two emulated 82574Ls, and with failslab failing 5% of atomic
allocations the failed pulls drop the packet and nothing falls over.
The same setup with jumbo frames and copybreak off makes
skb_condense() pull frag data into the head tens of thousands of times
a run.  xen-netfront ran as a Xen HVM guest under QEMU's KVM Xen
emulation, with the backend changed to spread frames over 18 and 19 RX
slots, which takes the converted pull in xennet_fill_frags() and its
overflow path.  The other drivers are compile tested only.

Thanks,
Josef

---
Josef Bacik (9):
      net: ftmac100: check for failure when pulling in the RX header
      net/mlx5e: check for failure when pulling the Ethernet header after XDP
      net: niu: check for failure when pulling in the RX header
      xen/netfront: check for failure when pulling in xennet_fill_frags()
      e1000: use pskb_may_pull() in the 82544 TSO workaround
      e1000e: use pskb_may_pull() in the 82571/2/3 TSO workaround
      netxen: use pskb_may_pull() to pull excess TX frags into the head
      qlcnic: use pskb_may_pull() to pull excess TX frags into the head
      net: skbuff: don't reset truesize in skb_condense() if the pull fails

 drivers/net/ethernet/faraday/ftmac100.c            | 10 ++++++++--
 drivers/net/ethernet/intel/e1000/e1000_main.c      |  5 ++---
 drivers/net/ethernet/intel/e1000e/netdev.c         |  4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |  9 ++++++---
 .../net/ethernet/qlogic/netxen/netxen_nic_main.c   |  2 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c     |  2 +-
 drivers/net/ethernet/sun/niu.c                     |  6 +++++-
 drivers/net/xen-netfront.c                         | 22 ++++++++++------------
 net/core/skbuff.c                                  |  3 ++-
 9 files changed, 37 insertions(+), 26 deletions(-)
---
base-commit: a5e7d8e446af9803e37a3b6a4d416fb41178348f
change-id: 20261006-b4-pskb-pull-tail-drivers-ff4fb2964e1a


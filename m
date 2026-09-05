Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B978030C142
	for <linux-rdma@vger.kernel.org>; Sat,  5 Sep 2026 09:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788600066; cv=none; b=qBeNn3RMhBTj0meeW/EPGTIRwyMyEjRvIoRFzdQmXEw6J1/IhZhJsky8gPeebB7KI5OyI2fmt3lVly3WqhT6425xswhrkBjGp5NH5cW8ekhivRZjry4iJyvkiVNz46WWfArq7KdOeo5GNv6UC9zVWC0jQetHqI7MZ06Phzri1sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788600066; c=relaxed/simple;
	bh=Vu0eeaYgQe/13+TRiG/00soc4KDDagtXGQw8SXDgYho=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=AHcE84RLGRynXhn4ocidr8ncqua/IMRT0lcYuTKNgMJWT+U0UgSBSYIp6bw44GwApnApSay3Cq/o+EpNnHVpXFTj+OHkKRoi4K862Y0no5sBbaRA757nRlmlKXYYlcRbyLdM8q+XtRxGLj09Yz+bdGynm2Bgly5W7Mfj9mct37k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FykSGb7N; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FykSGb7N"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4921eed3fa2so23667845e9.0
        for <linux-rdma@vger.kernel.org>; Sat, 05 Sep 2026 02:21:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788600063; x=1789204863; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=zGn3gQ19w3ozW4mWGX0/53LOe4DnBJu1hu3bgsDwdyk=;
        b=FykSGb7Nbi3RSYuTUYbcylsu41z0Y8OiUXYriMwX+l+DroNnbVgmRxWKhMSniJjE6m
         XlO48ctDwCn5sdV3dRTE3hllwqfV5tOR8OzQV9YT2XaR350UOyt1O+2t0RK1Dypl8bjx
         d6GGMXaBk7zjtstNzxP+jJCqsAzUWLzgM8j8qqvAsSfr6ASDr1KH41t0W0G7THCeU5Hr
         2ozviyez5RZpELY0Itnqnhfr32/YVB8FkWocsME1w+wKYdhweZxFjOJ6csBLfavHBccS
         dUCr0FCVWnoqa7irAl58/HNBbf/g1r/JyQfLI/AgB3TzqLa7pY+wgJsbW1GZPr/oAjWH
         0fpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788600063; x=1789204863;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zGn3gQ19w3ozW4mWGX0/53LOe4DnBJu1hu3bgsDwdyk=;
        b=GM+kpq3eCMRz6Ac5IV86K6IHC3ngI4s7ctjD7Jr1YjtmleuZO2Yf1wDNIg7jRTGXH5
         vAgnjmUkpCi2RkmBXT+9REubT2TGbO0HI3yBViYhFVaHXd0LQA/yMBEPTxLtrkZK5PJM
         tgnWRpF+AuzswUycbBiTb+716ne3ywBxBv7iSiIf+0jRwS507YgjKfP6NaleWz6PyYzP
         Kmz5GHK2NC1fVko6ZCQA4kPNrylOWoFMR4IFjhYpomb9yp+tk93kfnru8jLB1R2s377R
         e572UnA2GIL3We8iKVEa7EpYfIDKi/gkFGbEICsApfhJnkGZeUAjh0yPg/SeAUjldszw
         aW7w==
X-Forwarded-Encrypted: i=1; AKwUvBxu+v2Bb1QkX+hL2DkDhz49GNDEdJv1FD4rKWU0RzeEZUrnUzwAvgSppSSOxRXawHSZG8g2LuTfqxMO@vger.kernel.org
X-Gm-Message-State: AFuF++kpbN6pBF9VVm+g3RcRHBHqaFS1hB3MEi3Q0ItygdnYk+TLdtE+
	kwOXj8Wsnptk9xn/LYKY4Ww/VrrjXhNWNDcWoYudaZYs/xrQhDlceH18
X-Gm-Gg: AYBFou16u8U5U7u0rxuZD8XgAG2QXgjmQVq9x78hB7Ol392rNsOcKh45Xr6ihnWjBv8
	r1mAQ6GLUSjM02MT1J5GKQgdiuHASkamz0UHXMOil8pwoCnt1rYwr7S/qwbQN/TQf8MbVJ8wekK
	Efs0BB9FUtrMyvoGqwRSB+C9NUDZKsef9bRDwt0omlscxP34uFZVmOAsnO0syIQcB6EZH7tBuJs
	24XXSDlvteDOQU7d/QeWlR/MH+FGfQw1oYllzOL6tesYIaw5ag0El0V5QiGCTOV5UjF2Pc7Gh5D
	g3iuOuWKnlFQynKxs5snF5/5h8U3suQQraYy1wVcdCKn8DQkENqJsPP3Pf+gsmSu+T3QrgttV9h
	oCbs9rpjyDfk3s6vsEkgfUe2w9h0cVF3GFfRwQe+1yywx8S8IgqFjn1u4ltPM/4hrz7ALhiEULf
	aJpFTyo219NWtz8+AovaN1aihNqq+tNwvGJL+n+NH6OFpo7nER25RDqP5fqh7cncTonWpuTN89C
	f96ZbEKGGh75EHaiSGe6HsGFcK6IGpOqEKEC+zOzbtkibnLJMYSM+sVRR0hJemu/teXR9pVLHz7
	CVQZti5yOA5QVoGgaO2PWlqcgOAZRSUMZd2ZSAd87PGNISEqvf4ivPKZ3VwJbGsxvGo=
X-Received: by 2002:a05:600c:350f:b0:499:b65d:124f with SMTP id 5b1f17b1804b1-49cf825d1dcmr108797205e9.11.1788600062816;
        Sat, 05 Sep 2026 02:21:02 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-a4eb-3001-c06d-af27-9fa2-ea53.310.pool.telefonica.de. [2a02:3100:a4eb:3001:c06d:af27:9fa2:ea53])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4858d2693e8sm9577653f8f.3.2026.09.05.02.21.02
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 05 Sep 2026 02:21:02 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	linux-rdma@vger.kernel.org,
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Subject: [PATCH] ABI: sysfs-class-infiniband: Drop the entries of the removed qib driver
Date: Sat,  5 Sep 2026 11:20:57 +0200
Message-Id: <20260905092057.41306-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 24baad32b710 ("RDMA/qib: Remove outdated driver") removed the qib
driver but left its /sys/class/infiniband/qibX/* entries in the stable
ABI file. Nothing creates those files any more.

Remove the block.

Fixes: 24baad32b710 ("RDMA/qib: Remove outdated driver")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
 .../ABI/stable/sysfs-class-infiniband         | 118 ------------------
 1 file changed, 118 deletions(-)

diff --git a/Documentation/ABI/stable/sysfs-class-infiniband b/Documentation/ABI/stable/sysfs-class-infiniband
index 7ba116103429..726a38470e58 100644
--- a/Documentation/ABI/stable/sysfs-class-infiniband
+++ b/Documentation/ABI/stable/sysfs-class-infiniband
@@ -422,124 +422,6 @@ Description:
 				information)
 		=============== =============================================
 
-
-sysfs interface for Intel IB driver qib
----------------------------------------
-
-What:		/sys/class/infiniband/qibX/version
-What:		/sys/class/infiniband/qibX/hw_rev
-What:		/sys/class/infiniband/qibX/hca_type
-What:		/sys/class/infiniband/qibX/board_id
-What:		/sys/class/infiniband/qibX/boardversion
-What:		/sys/class/infiniband/qibX/nctxts
-What:		/sys/class/infiniband/qibX/localbus_info
-What:		/sys/class/infiniband/qibX/tempsense
-What:		/sys/class/infiniband/qibX/serial
-What:		/sys/class/infiniband/qibX/nfreectxts
-What:		/sys/class/infiniband/qibX/chip_reset
-Date:		May, 2010
-KernelVersion:	v2.6.35
-Contact:	linux-rdma@vger.kernel.org
-Description:
-		=============== ======================================================
-		version:	(RO) Display version information of installed software
-				and drivers.
-
-		hw_rev:		(RO) Hardware revision number
-
-		hca_type:	(RO) Host channel adapter type
-
-		board_id:	(RO) Manufacturing board id
-
-		boardversion:	(RO) Current version of the chip architecture
-
-		nctxts:		(RO) Return the number of user ports (contexts)
-				available
-
-		localbus_info:	(RO) Human readable localbus info
-
-		tempsense:	(RO) Display temp sense registers in decimal
-
-		serial:		(RO) Serial number of the HCA
-
-		nfreectxts:	(RO) The number of free user ports (contexts)
-				available.
-
-		chip_reset:	(WO) Reset the chip if possible by writing
-				"reset" to this file. Only allowed if no user
-				contexts are open that use chip resources.
-		=============== ======================================================
-
-
-What:		/sys/class/infiniband/qibX/ports/<N>/sl2vl/[0-15]
-Date:		May, 2010
-KernelVersion:	v2.6.35
-Contact:	linux-rdma@vger.kernel.org
-Description:
-		(RO) The directory contains 16 files numbered 0-15 that specify
-		the Service Level (SL). Listing the SL files returns the Virtual
-		Lane (VL) as programmed by the SL.
-
-What:		/sys/class/infiniband/qibX/ports/<N>/CCMgtA/cc_settings_bin
-What:		/sys/class/infiniband/qibX/ports/<N>/CCMgtA/cc_table_bin
-Date:		May, 2010
-KernelVersion:	v2.6.35
-Contact:	linux-rdma@vger.kernel.org
-Description:
-		Per-port congestion control. Both are binary attributes.
-
-		=============== ================================================
-		cc_table_bin	(RO) Congestion control table size followed by
-				table entries.
-
-		cc_settings_bin (RO) Congestion settings: port control, control
-				map and an array of 16 entries for the
-				congestion entries - increase, timer, event log
-				trigger threshold and the minimum injection rate
-				delay.
-		=============== ================================================
-
-What:		/sys/class/infiniband/qibX/ports/<N>/linkstate/loopback
-What:		/sys/class/infiniband/qibX/ports/<N>/linkstate/led_override
-What:		/sys/class/infiniband/qibX/ports/<N>/linkstate/hrtbt_enable
-What:		/sys/class/infiniband/qibX/ports/<N>/linkstate/status
-What:		/sys/class/infiniband/qibX/ports/<N>/linkstate/status_str
-Date:		May, 2010
-KernelVersion:	v2.6.35
-Contact:	linux-rdma@vger.kernel.org
-Description:
-		[to be documented]
-
-		=============== ===============================================
-		loopback:	(WO)
-		led_override:	(WO)
-		hrtbt_enable:	(RW)
-		status:		(RO)
-
-		status_str:	(RO) Displays information about the link state,
-				possible cable/switch problems, and hardware
-				errors. Possible states are- "Initted",
-				"Present", "IB_link_up", "IB_configured" or
-				"Fatal_Hardware_Error".
-		=============== ===============================================
-
-What:		/sys/class/infiniband/qibX/ports/<N>/diag_counters/rc_resends
-What:		/sys/class/infiniband/qibX/ports/<N>/diag_counters/seq_naks
-What:		/sys/class/infiniband/qibX/ports/<N>/diag_counters/rdma_seq
-What:		/sys/class/infiniband/qibX/ports/<N>/diag_counters/rnr_naks
-What:		/sys/class/infiniband/qibX/ports/<N>/diag_counters/other_naks
-What:		/sys/class/infiniband/qibX/ports/<N>/diag_counters/rc_timeouts
-What:		/sys/class/infiniband/qibX/ports/<N>/diag_counters/look_pkts
-What:		/sys/class/infiniband/qibX/ports/<N>/diag_counters/pkt_drops
-What:		/sys/class/infiniband/qibX/ports/<N>/diag_counters/dma_wait
-What:		/sys/class/infiniband/qibX/ports/<N>/diag_counters/unaligned
-Date:		May, 2010
-KernelVersion:	v2.6.35
-Contact:	linux-rdma@vger.kernel.org
-Description:
-		[to be documented]
-
-
 sysfs interface for Mellanox Connect-IB HCA driver mlx5
 -------------------------------------------------------
 
-- 
2.53.0


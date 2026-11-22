Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.27.60.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795383134;
	b=SSsssYP5WlXd9eJd5vnpb4lc4eMWuWsGLC1Y4LX7AmLRrJ//6ipMxNmuy0rRfHcYBG7m
	 0nLCtKLteoi/slw9aD4RfTlHPjXV4vXTbt1FspPUdq/V07e91OPChVcoT4FhH+xNlhTXV
	 kYMYsIUmB9MprvIHYxww+jQfcBLovZurXoQsKnh08JMLcOLLp9SAGDVjnLirwGuHKzzOZ
	 PGFZ+vl3m/Z+57cEVjr8QRwZ7tEUmjXy4PNk75THiYCHfPkGxQkokMKxQDsmV2p0ytGL8
	 +pLVNMNgMfc8y3Pqnt0Yl7YFpTBoIqcBhXmFPItmf1AbPtm/uQVR0/M+SDkbAvRYQNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795383134;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=WwkPKboaRHO3gWj6crYxjpzj9cX9xx9wCpXmZOCeZgY=;
	b=dagiXs4c3WJTYY4eveJknsIZmjzQC4YMv7o+1knneN+1mB2ViSswccwHqXUR8jceIWtq
	 YOJbz2vocDifvMN95uqKkZ+297pBN5+OpUUrg3I+JSJtRbfgVitOWoDXpuRZn3Z+2IPXs
	 DSCls/yeVo6jfvSf7FMQR6cSwdWG+5MgVGR48pf1ICfg9lPBrU0aSrJ0q7ORFFfvwlmzD
	 0uHAPGsa4Ew+pjF5q2jbdk+/ujb2Z9zWRXFyyWzwATTYS0ZcGFtrg8f+ZHhEwVZtB0trC
	 xsjxB5xjsXVzf3jAYnVOTT4MUPv3QJ+8yV+sJDxJ2el72RGa5SiZbbc75is2ZNCS/VA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=corp.free.fr;
	spf=pass smtp.mailfrom=corp.free.fr;
	dkim=pass header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=FvulZixg;
	arc=none smtp.remote-ip=212.27.60.169
Received: from rcs.proxad.net (rcs.proxad.net [212.27.60.169])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32F09606A688;
	Sun, 22 Nov 2026 21:32:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 32F09606A688
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=FvulZixg
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=corp.free.fr; s=rcs;
	t=1795383132; bh=ETQLiklF/DMETVxTZ3pQ7sasKCndEu5GA0chMOax7tQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FvulZixgq4PJqdQfnQ1IeJS6BQ0tWD3bljnhuRLiLMqe2y3GXz+1PyfD16S7nW8+k
	 81lXCA8eZuRfO/2q3etOsAV3tKSE41p2viZH/zydXNIvE+DIjtFCWeG8TzLAysnX4C
	 hP9wwkFIFAE/1G4cZCCNL0AtrI/5fz09jEemEnzsi4JJm6Fy5ZnhdUrP6ryNCwaU/T
	 hP3bS4AgErdCqJB+R9preRvcOyGa3BJBgoWdfrppmZBymGKeaJ1XcMyGNh2bRGUon9
	 D2u+JiOrF6HlqQVTarc1y8y9v36P8+Ev06entFDnof6u0o4Xb4qsHaWo46kuCO1jrP
	 A29vEOiPd/KLA==
Received: from lnxos-dev.home (82-66-150-212.subs.proxad.net [82.66.150.212])
	by rcs.proxad.net (Postfix) with ESMTPSA id 6DEBB44C0B5D;
	Sun, 22 Nov 2026 22:32:12 +0100 (CET)
From: Alexandre Cassen <acassen@corp.free.fr>
To: Saeed Mahameed <saeedm@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jiri Pirko <jiri@resnulli.us>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Michael Chan <michael.chan@broadcom.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Potnuri Bharat Teja <bharat@chelsio.com>,
	Donald Hunter <donald.hunter@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	David Ahern <dsahern@kernel.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Shuah Khan <shuah@kernel.org>,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	oss-drivers@corigine.com
Subject: [PATCH net-next v3 11/11] docs: networking: describe tunnel key partitioning in TC queue filtering
Date: Sun, 22 Nov 2026 22:31:59 +0100
Message-ID: <20261122213200.3207385-12-acassen@corp.free.fr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261122213200.3207385-1-acassen@corp.free.fr>
References: <20261122213200.3207385-1-acassen@corp.free.fr>
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

Tunnel key partitioning steers blocks of tunnel flows to RX queues with a
mask on enc_key_id. Document this use and what enc_key_id means on a
physical port of mlx5. Also document what happens to such a filter when
its queue goes away.

Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>
---
 Documentation/networking/tc-queue-filters.rst | 22 +++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/Documentation/networking/tc-queue-filters.rst b/Documentation/networking/tc-queue-filters.rst
index 6b417092276f..14032375d630 100644
--- a/Documentation/networking/tc-queue-filters.rst
+++ b/Documentation/networking/tc-queue-filters.rst
@@ -35,3 +35,25 @@ queues and/or a single queue are supported as below:
    devices, TC filter directing traffic to a queue have higher
    priority over flow director filter assigning a queue. The hash
    filter has lowest priority.
+
+Tunnel key partitioning splits the key space of a tunnel into blocks. One
+filter with a mask on enc_key_id steers a block to its own queue. This
+helps with traffic that RSS cannot spread because its hashed fields barely
+vary, such as GTP-U tunnels between a few endpoints::
+
+  # GTP-U TEIDs whose two top bits are 01 go to queue 1
+  tc filter add dev eth0 ingress protocol ip flower skip_sw \
+      ip_proto udp dst_port 2152 enc_key_id 0x40000000/0xc0000000 \
+      action skbedit queue_mapping 1 skip_sw
+
+Not all drivers can program a partial mask.
+
+On mlx5 devices such a filter runs on a physical port where nothing
+decapsulates the packet. All the keys describe the packet on the wire.
+enc_key_id is the only tunnel key such a filter matches.
+ip_proto 0x2f, or udp with dst_port 2152, 4789 or 6081, tells the hardware
+which tunnel header holds the key. The software datapath has no tunnel
+metadata on such a port. Only the hardware can match the key.
+
+Reducing the number of channels below the queue of a filter drops the
+traffic of that filter on mlx5 devices until the channel returns.
-- 
2.43.0


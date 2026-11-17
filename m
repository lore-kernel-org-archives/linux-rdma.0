Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.27.60.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794907777;
	b=W5KgHNGRV6yt8YNLlJ4qNmlyk5hy0UpHxUO8FU1qk3Y2nUq5aR7dj1HpI3pFortXisCA
	 ahvAK6NSEtO97lzXtUIz6TdKUrS90UXxuf0hf2C7a2AFFNiDNKaxQsHUyrP58iEnGwh2i
	 hCJNLo7epiCVJ8qVKvD9Wqk79dYiHJyankUq7u3Zm+lutdK7w+L29UbrML9pnq8erBXRV
	 GV9kvKVoSqk+gM+WjvzJA38aGunTEXmOiD4DDjvLMRUqVvoOrWH0s6Iuv5KMaJCZ5LKb2
	 rVgW50wAkDhbBN1J3LNkhVNVo8C0WWcCNkvR7QOfzvZ42iMqKttUR+kQtgddPZW2nsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794907777;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=WwkPKboaRHO3gWj6crYxjpzj9cX9xx9wCpXmZOCeZgY=;
	b=h1DAfE6s6BQ+phWnpe8EWXhsVCMyn/kcnCdAWP7Wnggbz58Kw+bXWiFLDKqJewkd4G5A
	 4IQsiNUsA9hWQVE5UbxaAz4tGIPsPI5BqB4rNtA0yX9nB2v7PK7uOsceqJLc7sVv6Zi+V
	 VHMnmPo0iCN3sSiJ5mzc7dfenEcEB7wzzjeqzZJoyVmicPDw1kK9sPwLgmeCyMTSKIb8n
	 NzOZv2D7JULf7wnaG1Un0Y3Z6chy7edz61BX0OM5ftakaGNQBIk37hbCcChZ75lFi5i+Y
	 ukCFxOIaKKqRRTCVQHJNCIJYpMjUKZ74c0kCQpoq+J6yodb43/mzoapJKL+NZlOiHmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=corp.free.fr;
	spf=pass smtp.mailfrom=corp.free.fr;
	dkim=pass header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=AR7mJYKU;
	arc=none smtp.remote-ip=212.27.60.169
Received: from rcs.proxad.net (rcs.proxad.net [212.27.60.169])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C4A760A261A;
	Tue, 17 Nov 2026 09:29:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6C4A760A261A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=AR7mJYKU
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=corp.free.fr; s=rcs;
	t=1794907767; bh=ETQLiklF/DMETVxTZ3pQ7sasKCndEu5GA0chMOax7tQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AR7mJYKUIRtrhZbZFUN8RbCO7nzL38du94dad2Uxd0sbL1VDMHZoxW4tsGLpAOQiK
	 sByl3UiR7+ADY+ER3BvxcyxfuAD8VOGIh1h98WTyXTkbAkLLwRDE7ax4q+DmILoIGA
	 PvgJ6F9pZDSzlr1ByjIwgdifTNLj3+7Kzx7v0xeKAFUJxCFQbF6URFy0d8TNIitOzn
	 LCwMs16pF5URo/XGfr9LLt8mc7Ya37HSl31qr2uYZ6yfHXvXxMlvC5IBBjAkDKt8sp
	 0dirJNTLY9v7cVeqKm81bVQ1WHs54Ec77eTiSZr+7Du64WmkGCPtd65Rqk1/6e0x4a
	 cRpK9ywmg9gCQ==
Received: from lnxos-dev.home (82-66-150-212.subs.proxad.net [82.66.150.212])
	by rcs.proxad.net (Postfix) with ESMTPSA id 958F844C0C2F;
	Tue, 17 Nov 2026 10:29:26 +0100 (CET)
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
Subject: [PATCH net-next v2 10/10] docs: networking: describe tunnel key partitioning in TC queue filtering
Date: Tue, 17 Nov 2026 10:29:13 +0100
Message-ID: <20261117092915.255194-11-acassen@corp.free.fr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261117092915.255194-1-acassen@corp.free.fr>
References: <20261117092915.255194-1-acassen@corp.free.fr>
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


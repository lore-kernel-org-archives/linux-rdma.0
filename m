Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.27.60.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794229852;
	b=ElczIm5+A4rf2snE4YsWm36twApJkXAH4qVsFBAznDuwOGHHnoHyjk4DPNHoyj1fTa2Q
	 ToF1mKzMSqM2HoFg9zqzKYdGDshU+Pj9jJoSjjfDOStjGmeeE97t1cHMkiOoJ/1Ixxw4a
	 8j81FsRRiaeE9GF6MEvuXAdILFlHHEdHCXqfhiVG8aYD6eD10bZnkb++soITNr4y8Mwk+
	 qY3lRs3fIVaRUnok9xlAcTfaVcWEnlelmQ+FOhAu+D6os5cnokEMt4nooXDtTnXktkwcT
	 4sPYzWXRWqWsaM/BJ6Wbw2kWq4F54YXlHx0z9B7Hk6rDZJscSFaDm8E0GUyLv8DjhPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794229852;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=HzAXuw6kx/SqMIZp1dShy7ZbugxEWtXEk2qfMhHjLSM=;
	b=AXprCuU5S8pBJ1qdvbl5wZmV1KKKx1Z2kCa1xvTDktesO/rsMVr7szKbbhqKUX0i3Rol
	 iYi1DythVgzHaDIE3uKeHjTcWQsC/UHpJA/fop1I8G9EHxn7YevA5UBbP7vl5MIOokZFF
	 xA6fpqDStBkl+FDHC7uf6WylfHzgAB8SlGijRiC8Xt2jj9w93mN53/i+HmUIb39NEcUV7
	 NGbaCklAX3OWOjPSs0ZAGCRsuRBCuqrHfvb996HeqKSVVGiiU1J9EUIj/m8eZrePjc3aT
	 W3AW1CMG/ygXxD1rFoxQ4wpX3c9iaGiTljbvkvC4VbnHkVHf7npyAVl7vSsjygHp1+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=corp.free.fr;
	spf=pass smtp.mailfrom=corp.free.fr;
	dkim=pass header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b="J1XV/DYu";
	arc=none smtp.remote-ip=212.27.60.169
Received: from rcs.proxad.net (rcs.proxad.net [212.27.60.169])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4D41606EEBA;
	Mon,  9 Nov 2026 13:10:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D4D41606EEBA
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=J1XV/DYu
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=corp.free.fr; s=rcs;
	t=1794229850; bh=KuF1boh3DXefV+1K1gtxLHI+aeQQ1EXKnzuOpZ1XR/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J1XV/DYuRDkL2mLYSexLfOCzgDEa7pZgh0/XXGFlT/vJ6bQxEswvTOW/YcPuNiNJP
	 YK4JpYA0sTwLId8TxObmeY3XfaUry5KnDGsoBkPeTx6lcitQaUfJt2pFBNJWDFfeui
	 fHe/urtHHRyzbPPEJ3Tp+RY7JJhkoaaxE/+em+aBhBDjBdm0UV/ASxFe9dARqNQniH
	 hqyZWV/Md15BE+tmmglZlT4X7+PMA0PxBArvLGph8VE7irYP1n4MjmdQfOkYGAWTMw
	 qVbSOTlihCXhjRvuTq6Zl74r/dkSAHWVFOavKToNetCgOdfOFdEaKfMX0mTXU5tskF
	 vS34FUuqyBqwg==
Received: from lnxos-dev.home (82-66-150-212.subs.proxad.net [82.66.150.212])
	by rcs.proxad.net (Postfix) with ESMTPSA id 2FFAD44C11EA;
	Mon,  9 Nov 2026 14:10:50 +0100 (CET)
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
Subject: [PATCH net-next 10/10] docs: networking: describe tunnel key partitioning in TC queue filtering
Date: Mon,  9 Nov 2026 14:10:36 +0100
Message-ID: <20261109131039.959438-11-acassen@corp.free.fr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261109131039.959438-1-acassen@corp.free.fr>
References: <20261109131039.959438-1-acassen@corp.free.fr>
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
index 6b417092276f..de54d43687c6 100644
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
+ip_proto and dst_port tell the hardware which tunnel header holds the key.
+The software datapath has no tunnel metadata on such a port. The filter
+therefore needs skip_sw. Without it the filter stays in software, where
+the port reads key zero.
+
+Reducing the number of channels below the queue of a filter drops the
+traffic of that filter on mlx5 devices until the channel returns.
-- 
2.43.0


Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.27.60.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794907773;
	b=hRfJiPMViDgyvVdGTF/5therZQre+SsnI9yDz06q1sJ2jkoONPTHyCfjVQkoIwsSyGPx
	 8AFbn3N2/36xv2PwkS//RAnPkt/c4z9HTskJ5xSsPfzzKFR+GFLJLBJzxgjLs+BSGYLDl
	 zane1d+4pmtSw2mI1KFGSm5fcTjBDoHmxuCZ+qBxJPNvVzZRV7jTmEAHjyzdkxX+7pL9M
	 eIDGJv0GsyKhq/8vD80g7pgdcoNsHn24nOGpaE08wxslZiWd6vVEgEhyX7fNAQMYp3uWp
	 BniX6F8rYpcWihOXOfwTkub2kVeuV9lSFhyONJaVGAGL+G4CmtD5c0ShZqxgQSkFiag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794907773;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ftyjplaaqgJo4LhIeX0ki8qKF8eGxzQ3xFkDqVwtXDc=;
	b=PvL8HVqVFIfQZYSFAMZu/a4Z+v9GcQ/ByuAL56OJkOKDfX64Ju53vJslRyPerA2U6nFT
	 avX5Db6h3UXoPgxQm1/0u0CEsY3UiiLcpZqB4M3LYV26u7w7hbUkjhS0lF3icNVI2gdKQ
	 9WKjOmuhrE1rdxDWdPJ75FUb4+c/knzU/Yb/7QC2MalA9vioIDFprBuWnc48foU80r62m
	 8U+h/ekssP70I/EuF90OeTiP9xbSCFa0syM5xtF0cjLUzUvpyIlbsfVvmuh89OEjVCOj2
	 EH+dF8OWxY/BaaIJzwbiv3itqoevj4QIo2CjgXsVI9mzxeIkF/zsAQHAgPKyOMOvfFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=corp.free.fr;
	spf=pass smtp.mailfrom=corp.free.fr;
	dkim=pass header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b="DQs2/p19";
	arc=none smtp.remote-ip=212.27.60.169
Received: from rcs.proxad.net (rcs.proxad.net [212.27.60.169])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3691B606A8A7;
	Tue, 17 Nov 2026 09:29:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3691B606A8A7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=DQs2/p19
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=corp.free.fr; s=rcs;
	t=1794907765; bh=T0c4HzQ55Dzx/AWyhK2goK2C5fE6yB+pj/II84Ex6t0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DQs2/p19aeje4JcO3X/3SQmXunjDcEKgP3h37itk11M70jWuD0+mr7U+37LD+/YoA
	 /DSwUrTf3jXb9h3nlH0cPdk2qZL3Qewynie61pkmRnLGmBhc6jIIhV/0fJQjaTBw0J
	 D0OoPLfjYOCdH/XQT4WAMUl1+BYg7sh5/8lSVeU1RIGUTkw3m8VqUBzNkhWxBd0SPl
	 SspAQxFCsUW0UtlwXRLjplyUoHJTGvoIGXjc/V0m7HUW7gd0CJBg/jJw6y5+N8IjZg
	 yIjGnzzjylUbNilotbcDAxe1JFq0k29zCONXWrnv+YQA3qxQr8ma/fRphO26+cMdJ9
	 bp3t9s2bPxlIg==
Received: from lnxos-dev.home (82-66-150-212.subs.proxad.net [82.66.150.212])
	by rcs.proxad.net (Postfix) with ESMTPSA id 1428944C0B71;
	Tue, 17 Nov 2026 10:29:25 +0100 (CET)
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
Subject: [PATCH net-next v2 07/10] selftests: forwarding: tc_flower: test the enc_key_id mask
Date: Tue, 17 Nov 2026 10:29:10 +0100
Message-ID: <20261117092915.255194-8-acassen@corp.free.fr>
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

A filter on a block of tunnel keys must match a key inside the block and
no key outside it. It must also dump its mask. A second filter proves that
the frame outside the block reaches the device.

When tc does not know the mask, the test only logs this. Reporting a skip
would turn the exit status of the whole script into a skip. A tunnel
device takes no skip_sw filter. The test only runs in software.

Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>
---
 .../selftests/net/forwarding/tc_flower.sh     | 54 +++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/tools/testing/selftests/net/forwarding/tc_flower.sh b/tools/testing/selftests/net/forwarding/tc_flower.sh
index b58909a93112..693361c4b8f7 100755
--- a/tools/testing/selftests/net/forwarding/tc_flower.sh
+++ b/tools/testing/selftests/net/forwarding/tc_flower.sh
@@ -3,6 +3,7 @@
 
 ALL_TESTS="match_dst_mac_test match_src_mac_test match_dst_ip_test \
 	match_src_ip_test match_ip_flags_test match_pcp_test match_vlan_test \
+	match_enc_key_id_mask_test \
 	match_ip_tos_test match_indev_test match_ip_ttl_test
 	match_mpls_label_test \
 	match_mpls_tc_test match_mpls_bos_test match_mpls_ttl_test \
@@ -280,6 +281,59 @@ match_vlan_test()
 	log_test "VLAN match ($tcflags)"
 }
 
+match_enc_key_id_mask_test()
+{
+	RET=0
+
+	# A tunnel device has no offload to take a skip_sw filter
+	if [[ $tcflags == "skip_sw" ]]; then
+		return 0
+	fi
+
+	if ! tc filter add dev $h2 ingress flower help 2>&1 | \
+		grep -q MASKED-KEY-ID; then
+		echo "SKIP: iproute2 too old; tc is missing the enc_key_id mask"
+		return 0
+	fi
+
+	tunnel_create gt1 gretap 192.0.2.1 192.0.2.2 dev $h1 key 300
+	tunnel_create gt2 gretap 192.0.2.1 192.0.2.2 dev $h1 key 600
+	ip link set dev gt1 master v$h1
+	ip link set dev gt2 master v$h1
+	ip link add gt-ex type gretap external # To collect tunnel info
+	ip link set dev gt-ex up
+	ip link set dev gt-ex master v$h2
+	tc qdisc add dev gt-ex clsact
+
+	tc filter add dev gt-ex ingress protocol ip pref 1 handle 101 flower \
+		$tcflags enc_key_id 256/0xf00 action drop
+	tc filter add dev gt-ex ingress protocol ip pref 2 handle 102 flower \
+		$tcflags enc_key_id 600 action drop
+
+	tc filter show dev gt-ex ingress pref 1 | grep -q "enc_key_id 256/0xf00"
+	check_err $? "Did not dump the mask"
+
+	$MZ gt1 -c 1 -p 64 -a "$(mac_get gt1)" -b $h2mac -t ip -q
+
+	tc_check_packets "dev gt-ex ingress" 101 1
+	check_err $? "Did not match a key inside the mask"
+
+	$MZ gt2 -c 1 -p 64 -a "$(mac_get gt2)" -b $h2mac -t ip -q
+
+	tc_check_packets "dev gt-ex ingress" 102 1
+	check_err $? "Did not receive the key outside the mask"
+
+	tc_check_packets "dev gt-ex ingress" 101 1
+	check_err $? "Matched a key outside the mask"
+
+	tc qdisc del dev gt-ex clsact
+	tunnel_destroy gt-ex
+	tunnel_destroy gt2
+	tunnel_destroy gt1
+
+	log_test "enc_key_id mask match ($tcflags)"
+}
+
 match_ip_tos_test()
 {
 	RET=0
-- 
2.43.0


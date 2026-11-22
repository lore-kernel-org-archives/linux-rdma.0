Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.27.60.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795383133;
	b=AlME3TQ/CvGKbaZrRtEm/dj2c/PB7sMl8iHN/7Gawly1mfoEM2x8dFeAF+qZ7XB4bwOB
	 hb2bJFrIc8wcx/gfhlrDAoaHBhWALRQviR/WBKHTdlRIRZA57/UR8DxmeVH6fdY97TUyM
	 b+xwg3vvd+8wkNdtC4j152rLT9qIB4nrZmKChOC71hQaYyik51j/hXU1qal/eZhAWDHFh
	 wuHWfzHTTgwCqaMhgfTn2rfiDvgYwppcePaSL5zc3pCl7TkFJT91aPqj5Ah44myQ7U2ED
	 IdvytgISRGBoK21TUazP2Hmd5KWltsO7e7lE70cXyEDdPSXb6tDOwuXeYolq1YCmc2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795383133;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=x8bb8dSlnAi9xysbj9q54f2eazuM7V12au3HzFc3v2s=;
	b=TROfhqHUSsj2m0c6Vs+b8+TQ6VcyGYvoFlX83CR0EL5YEdFl0hHsMEB2d8/Wz6aKwkZp
	 HClDKenqRcKm8cS3ce/hWfwooGlz8ZuDJXIi78jrDVwiuoDWwau7BQtjysy7uXiKECFL9
	 gyEZx3K2gyQu1U3EgiqSm9/q6cgsNQMwc5vKACBjnDw9CPk6pyZZOeJzVMOKFB2iksOwN
	 RMfZyUGj+r7k0B5819DAE7qPSg07P//kl8xrzouSLGzX1YBDLnFpBVmECVZJUe/3kyUt7
	 nxYaKQNO/ckReeltN3HLiwNE6pKvPBo87U6gieqL/5wxBOkJeuBUMdd4pW/j+g3Tq5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=corp.free.fr;
	spf=pass smtp.mailfrom=corp.free.fr;
	dkim=pass header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=kd279qKG;
	arc=none smtp.remote-ip=212.27.60.169
Received: from rcs.proxad.net (rcs.proxad.net [212.27.60.169])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41C55606A33E;
	Sun, 22 Nov 2026 21:32:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 41C55606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=kd279qKG
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=corp.free.fr; s=rcs;
	t=1795383130; bh=T20bBXJlBwEbj1ZdlGMC/bOUUlcqtdRACZ/kT9wMq8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kd279qKGqfcJM/QiPOpx1tAn/UfCvidnvasUEgXMjULT/eJhPWdI/5IHnfE/ikJRm
	 l1gJiUKuzf/UY7SDWCZ0tC/9lDNJCLW3R9JOGL95VipusnOQKwAoJn2gzUeoFNkQ/p
	 CzuKt/QTnzp9RUEVjICyk0dgHNnvgw6w/kD5YGmJbP0q4pCZsyZnuJtfL52Ow0qoGX
	 UzSQlb0DhZTdISuvBO3X7G1mvgdPnI1/C/2+22diPlxKB1E/7wXPNXlFBaJVl/QFiA
	 aAmBTZX1FEgrTko3VUgPoRS2Jr7EeujKhH1KRVCZn8nRg/aX19Kugrmi4UXMrLYd/S
	 wbTVO4M85PRqg==
Received: from lnxos-dev.home (82-66-150-212.subs.proxad.net [82.66.150.212])
	by rcs.proxad.net (Postfix) with ESMTPSA id 7069944C0B51;
	Sun, 22 Nov 2026 22:32:10 +0100 (CET)
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
Subject: [PATCH net-next v3 07/11] selftests: forwarding: tc_flower: test the enc_key_id mask
Date: Sun, 22 Nov 2026 22:31:55 +0100
Message-ID: <20261122213200.3207385-8-acassen@corp.free.fr>
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

A filter on a block of tunnel keys must match a key inside the block and
no key outside it. A second filter proves that the frame outside the
block reaches the device.

A probe filter must dump its mask first. An old tc refuses the mask and
an old kernel drops it. The test then only logs this. Reporting a skip
would turn the exit status of the whole script into a skip. A tunnel
device takes no skip_sw filter. The test only runs in software.

Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>
---
 .../selftests/net/forwarding/tc_flower.sh     | 59 +++++++++++++++++++
 1 file changed, 59 insertions(+)

diff --git a/tools/testing/selftests/net/forwarding/tc_flower.sh b/tools/testing/selftests/net/forwarding/tc_flower.sh
index b58909a93112..0f725ec17468 100755
--- a/tools/testing/selftests/net/forwarding/tc_flower.sh
+++ b/tools/testing/selftests/net/forwarding/tc_flower.sh
@@ -3,6 +3,7 @@
 
 ALL_TESTS="match_dst_mac_test match_src_mac_test match_dst_ip_test \
 	match_src_ip_test match_ip_flags_test match_pcp_test match_vlan_test \
+	match_enc_key_id_mask_test \
 	match_ip_tos_test match_indev_test match_ip_ttl_test
 	match_mpls_label_test \
 	match_mpls_tc_test match_mpls_bos_test match_mpls_ttl_test \
@@ -280,6 +281,64 @@ match_vlan_test()
 	log_test "VLAN match ($tcflags)"
 }
 
+match_enc_key_id_mask_test()
+{
+	local ret
+
+	RET=0
+
+	# A tunnel device has no offload to take a skip_sw filter
+	if [[ $tcflags == "skip_sw" ]]; then
+		return 0
+	fi
+
+	# An old tc refuses the mask and an old kernel drops it
+	tc filter add dev $h2 ingress protocol ip pref 1 handle 101 flower \
+		$tcflags enc_key_id 256/0xf00 action drop 2> /dev/null
+	tc filter show dev $h2 ingress pref 1 | grep -q "enc_key_id 256/0xf00"
+	ret=$?
+	tc filter del dev $h2 ingress protocol ip pref 1 handle 101 flower \
+		2> /dev/null
+	if [[ $ret -ne 0 ]]; then
+		echo "SKIP: tc or the kernel lacks the enc_key_id mask"
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


Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.27.60.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794229851;
	b=GFjO97UnnNnEYaWl9Z1EM2dEq+sDk8uLg5ebraron6GtHJ6chRk6dzDIflmUnXswybB0
	 Uvt13hfxgaaG6SbDHkL0CPefnrvuX7KRpyib3SSJOa9yDhHjiRwEK6GCmZVU6o7jqIgrV
	 +Te3S4V51PeRzh/N0crmH/H6KciVQev3krcBQDxfU91BeUzywcbPhbApiDnRN6PvvZNQq
	 5XleETvtMc7PFsB/aepX/lKl07iu4GhU1u1y0iLf2AyvF9C1Zrg2p9J4BEu0sHORnyssq
	 ar0WQ1FzL92FDT1m40Kyeykm1VpQBw2nTE/Ll2k1pv2SwjMzpWoUzSzqq34EgRFYqpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794229851;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=aMuTF0Rp4AJLqq/hu0ov8pdez1qv5/LPIm5Jj2vh8O0=;
	b=OaI4569Zvr/b4DlsWME1q6OF6NcVduRO6uI82Z2OKecU3DrYnrJoRCuk8KCnas3DQSod
	 j3oIeaaUIq7FVapTU6n24G4h+U0EC+CIX1zXdaccb1avXiemz874eYmTdw9cjbDQFKCMA
	 fUYmzxUz/4WsXfMLv+hOiBR6Amgu0BEQoT+0LYF32gXpLGiduE/zsFw6sLNwmkS08aqrB
	 sVesWrO0cpzbjvwgZzgssKgryitNQcLwuN5v801UNarKo0a21YMqhwaQ5wRvL1o8AmuOg
	 75vsEnqd/vxdXjnI7ZdO7AKE6WqldOWuJ98qQIDiKRpHojtObx3I4XSVlo2T2Y+CDDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=corp.free.fr;
	spf=pass smtp.mailfrom=corp.free.fr;
	dkim=pass header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=iGlistFp;
	arc=none smtp.remote-ip=212.27.60.169
Received: from rcs.proxad.net (rcs.proxad.net [212.27.60.169])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B9A0606EE82;
	Mon,  9 Nov 2026 13:10:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7B9A0606EE82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=corp.free.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=corp.free.fr header.i=@corp.free.fr header.a=rsa-sha256 header.s=rcs header.b=iGlistFp
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=corp.free.fr; s=rcs;
	t=1794229849; bh=AvMfG0x9eaHPXbYtLDNNClLkN0EMNdf+A2XCW1/CUVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iGlistFpJ5qbOjwp6fPAXzTmoqogXfxCJ009kAcl1Df92j55COLYEPGx0kLYQkEEP
	 sj4NU8KjBU4o4IrmlFM/1XfWeEOaPfab1QSW7oVYSewjL0XN/mAVG+AQQCzTVMsog/
	 d6WJ+XORKOW82mQx/yqC/vuoOhAVuUdyP3RgdkUdNlvl45SCO8+rSoUtLkPACkyNC1
	 lptHSdjVtWHsNKzKTErmL4IllGKXZcoVQ6mT/1fVKCbW0uGJHMeRSfHEj37IYII+qX
	 l2FsFzyp4nR9KBhYxjjQFuQnaJFrFvrJnAtWD8bQd7mX9f0mbbQrt++7kr82zbpxgs
	 Xw+pAn7QhnIGw==
Received: from lnxos-dev.home (82-66-150-212.subs.proxad.net [82.66.150.212])
	by rcs.proxad.net (Postfix) with ESMTPSA id AA07844C11DB;
	Mon,  9 Nov 2026 14:10:48 +0100 (CET)
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
Subject: [PATCH net-next 07/10] selftests: forwarding: tc_flower: test the enc_key_id mask
Date: Mon,  9 Nov 2026 14:10:33 +0100
Message-ID: <20261109131039.959438-8-acassen@corp.free.fr>
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

A filter on a block of tunnel keys must match a key inside the block and
no key outside it. It must also dump its mask. A second filter proves that
the frame outside the block reaches the device.

When tc does not know the mask or a device refuses it under skip_sw, the
test only logs this. Reporting a skip would turn the exit status of the
whole script into a skip.

Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>
---
 .../selftests/net/forwarding/tc_flower.sh     | 57 +++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/tools/testing/selftests/net/forwarding/tc_flower.sh b/tools/testing/selftests/net/forwarding/tc_flower.sh
index b58909a93112..9d9f109ab895 100755
--- a/tools/testing/selftests/net/forwarding/tc_flower.sh
+++ b/tools/testing/selftests/net/forwarding/tc_flower.sh
@@ -3,6 +3,7 @@
 
 ALL_TESTS="match_dst_mac_test match_src_mac_test match_dst_ip_test \
 	match_src_ip_test match_ip_flags_test match_pcp_test match_vlan_test \
+	match_enc_key_id_mask_test \
 	match_ip_tos_test match_indev_test match_ip_ttl_test
 	match_mpls_label_test \
 	match_mpls_tc_test match_mpls_bos_test match_mpls_ttl_test \
@@ -280,6 +281,62 @@ match_vlan_test()
 	log_test "VLAN match ($tcflags)"
 }
 
+enc_key_id_mask_check()
+{
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
+	log_test "enc_key_id mask match ($tcflags)"
+}
+
+match_enc_key_id_mask_test()
+{
+	RET=0
+
+	if ! tc filter add dev $h2 ingress flower help 2>&1 | grep -q MASKED-KEY-ID; then
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
+	# A device may refuse a partial mask but software must take it
+	tc filter add dev gt-ex ingress protocol ip pref 1 handle 101 flower \
+		$tcflags enc_key_id 256/0xf00 action drop
+	if [[ $? -ne 0 && $tcflags == "skip_sw" ]]; then
+		log_info "Device refuses the enc_key_id mask"
+	else
+		tc filter add dev gt-ex ingress protocol ip pref 2 handle 102 \
+			flower $tcflags enc_key_id 600 action drop
+		enc_key_id_mask_check
+	fi
+
+	tc qdisc del dev gt-ex clsact
+	tunnel_destroy gt-ex
+	tunnel_destroy gt2
+	tunnel_destroy gt1
+}
+
 match_ip_tos_test()
 {
 	RET=0
-- 
2.43.0


Received: from mail-ed2-f33.google.com (mail-ed2-f33.google.com [74.125.228.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8344471CF0
	for <linux-rdma@vger.kernel.org>; Sun,  4 Oct 2026 17:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791134209; cv=none; b=QX1+1l3/+9mXx75cHAE/rYaJ4Aa/fUOMJSbCTgaJoKnVxCrG1AZmsTIYYIV0DhMCsHCx4YDwJ6mNi7hVCDXrNTT/eF0HUnYqXvG0hYTFgoBgFuyqvMKNHgSqaX7sHQlFbYuV1WOg3llIwDr4He9INrGnqO1JauY2esPI/0djKXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791134209; c=relaxed/simple;
	bh=Y5qEOgngxBaCHA/kBWEYUs6H+TGmwJHQkFWp/hzC6bs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WyQdZmRzL1wGf1ZMoNUzA1LR2o6QB8IeCcMNBgRGdXe8fXRK4Hix+yZ+E6ChyftcVZrmxURYRtT1T1i6hho1h42riCjYKqOcYpFe9xvEijeZbSOUeaqC71M42XOrfecqs9ipbhkWBdJtbZXhMdJwz7Z0rDlG78w2+QOkyzjuo8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=kWkRmFKX; arc=none smtp.client-ip=74.125.228.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="kWkRmFKX"
Received: by mail-ed2-f33.google.com with SMTP id 4fb4d7f45d1cf-6ac6fa788e6so1117190a12.1
        for <linux-rdma@vger.kernel.org>; Sun, 04 Oct 2026 10:16:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1791134204; x=1791739004; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dHUtQGoQ43VDmpGd3bfBB5J/hFSSTUqRFc74DU6+NPk=;
        b=kWkRmFKXjXM0xC0FxMJnO6LoQmczqio07l6m6t4SxoS4hPuty0vr9Go9RpcM2pzb8M
         Vub2TL42Hh8czBNXgG7kSK41MKL8rit7M0ndzb2aTmo9gNhWWQjzHO1W41FmooNv/V7S
         sYdaVys5n3zPm7S2exm1tEhNyfTSmVOseZSG1j384ijQ5oC6upYTTEQQ/im9yp6mk22C
         1IRRDgl9Uvs8qWXYKtWcb1eBYpznbB1Zhr11Mu31e7jESXOdA3FvJXPh2CO+ZF9w2tEz
         JWV+m5Ib4rsI0zRyU07aWI5+pSvv3StVIWrxr2JYWQuc/qRG4guds8OXo/k/7YpZiLNW
         Rkag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791134204; x=1791739004;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dHUtQGoQ43VDmpGd3bfBB5J/hFSSTUqRFc74DU6+NPk=;
        b=Dk2x6b1a9IUqz+5Gt6F6pqa70T2AbiMxXRixxoYM2k/9UgHgxXwBDATZU2ohXovx2l
         Vsgzmpq3sIuNiWMCBal7hci6x6ZfQfT7xWjZBinzYZbj/3Y45Z+1C3bN0FyWDK14V5jt
         FRjFQm6eRTsbDUD6vxTeLigF51tGC4H2Eme8u5gs9dTOwo6bQqrzqc2uajwdM9vBoEF4
         ryEYoLvfJmT+OhGkOfxUHqWD1WYfVcnaULteZ85zgI8D+i4VrfaV1r7R4YPU77j5WrFF
         8/9+npKaFzIUCc/Bgya/w0fUgtRdZdxnx9DNnhnv6/j4ZW1k0vuditpChG7UTG68aEUa
         MmvA==
X-Forwarded-Encrypted: i=1; AKwUvBxdiOZL4WwLVQENpNpS0G1aHdK/YNQ3X+ljIBxsMNZrmUNyOIS3+HgD9PDHDUtYvp0ip9XUOJULXAMb@vger.kernel.org
X-Gm-Message-State: AFq9FYKsire2RK5dAVawDoxKBzn1N46mCqzXoSVJMVih0+01ijiNMYt+
	1+WH19U4IaKfiW28ynpr5xSmoaPMERiek6l/Jlgje9DyTZf2gaTa4HYI1cQf8+p1qg==
X-Gm-Gg: AYBFou2ci21A6OLIw52ZxZDOgMmnTbK9aCSWS6m+PkJpu/nKwuLDA2BiRvKUPyO/zLI
	KaS4ly/b/gn6HGrDxFnUqlMSsLuH3qSPUGhC3NRtBI6eWSXvRj3vJxzvfx3U2hW0Skn/L9D+s77
	TKddUS5nJHL+ZFhWBnnwWxU2AUvtIyLr2HZY/cRmgNkC8yILCd4G8OPEdGTXJGSrFJOqyxORnO7
	UyOwfDIYmyeQ7jgTZ0roJF2zawt6UJoY5T6tKCBZB+LgFb0MoHPUlmdHqJbHuP5++5eIVOfSCGq
	l7kdDRIAtElnTZOhNlgpnExAwwKMY+7Gd2WrpmiQYUqYGEoyfau2VajV4RE++OyEd1T7oqCrZJY
	62VFB57iiZV32aV7D3TSNRMOy8+p+T48D1Lp2S/BDlirbt+ateMezikMbmbmTchelBBZE6Ti/rj
	mtuEMuKn7L69rCwynfppQMJssxz8rpNU5PW8Pa7sWzijs4s3dcM5MsxNelEiKBaboZx8ZmnOW+L
	IPZ83Zm5G2SU76FKZYbm+dTmT4Mq4RWWLFKQ8c021zDHcwKSipb2+a+jU+0cogXuzA/ARc/EOO5
	ESULoOSM+fsFQfe2FWg+Zm96N8PMM/KYgFJoGXVhcSsGo4I1DaML/gNR5RFpdr5O24aUv645N9N
	xywG3asnp5xO8lm9AeYot4pn5/Q6GahwFqHcaMHG28ytr7QTifnQ/hoVK+MM62GxiH8qM4FMTpf
	4Wfoh70I318n1+NtzXSmvJRO4=
X-Received: by 2002:a05:6402:52c1:b0:6ac:7737:e50d with SMTP id 4fb4d7f45d1cf-6af9e2fd054mr5882545a12.29.1791134203816;
        Sun, 04 Oct 2026 10:16:43 -0700 (PDT)
Received: from Desktop (pd9513667.dip0.t-ipconnect.de. [217.81.54.103])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6afb014784bsm2256819a12.3.2026.10.04.10.16.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2026 10:16:42 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: pablo@netfilter.org,
	fw@strlen.de
Cc: phil@nwl.cc,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	lorenzo@kernel.org,
	nbd@nbd.name,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	corbet@lwn.net,
	rdunlap@infradead.org,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	saeedm@nvidia.com,
	leon@kernel.org,
	tariqt@nvidia.com,
	mbloch@nvidia.com,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH nf-next v3 3/3] selftests: netfilter: nft_flowtable.sh: check the priority a flow carries
Date: Sun,  4 Oct 2026 19:16:36 +0200
Message-ID: <20261004171636.3545085-4-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261004171636.3545085-1-julius@bairaktaris.de>
References: <20261004171636.3545085-1-julius@bairaktaris.de>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Count the forwarded TCP packets that leave with priority 0:3 and those
that leave with none, first without a priority and then with "meta
priority set 0:3" ahead of "flow add". With the priority set, every
packet must carry it, including those the flowtable forwards. Runs for
IPv4 and IPv6.

Assisted-by: Claude:claude-fable-5-1
Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
---
 .../selftests/net/netfilter/nft_flowtable.sh  | 110 ++++++++++++++++++
 1 file changed, 110 insertions(+)

diff --git a/tools/testing/selftests/net/netfilter/nft_flowtable.sh b/tools/testing/selftests/net/netfilter/nft_flowtable.sh
index 449c518bd947..73c7b1ec2208 100755
--- a/tools/testing/selftests/net/netfilter/nft_flowtable.sh
+++ b/tools/testing/selftests/net/netfilter/nft_flowtable.sh
@@ -458,6 +458,106 @@ fi
 	check_dscp "dscp_fwd" "$pmtu"
 }
 
+check_priority()
+{
+	local what="$1"
+	local pmtu="$2"
+	local ok=1
+
+	local counter
+	counter=$(ip netns exec "$nsr1" nft reset counter netdev priocheck prio3 | grep packets)
+	local pc3=${counter%*bytes*}
+	pc3=${pc3#*packets}
+
+	counter=$(ip netns exec "$nsr1" nft reset counter netdev priocheck prio0 | grep packets)
+	local pc0=${counter%*bytes*}
+	pc0=${pc0#*packets}
+
+	local failmsg="FAIL: pmtu $pmtu: $what counters do not match, expected"
+
+	case "$what" in
+	"prio_none")
+		if [ "$pc3" -gt 0 ] || [ "$pc0" -eq 0 ]; then
+			echo "$failmsg prio3 == 0, prio0 > 0, but got $pc3,$pc0" 1>&2
+			ret=1
+			ok=0
+		fi
+		;;
+	"prio_fwd")
+		if [ "$pc3" -eq 0 ] || [ "$pc0" -gt 0 ]; then
+			echo "$failmsg prio3 > 0, prio0 == 0, but got $pc3,$pc0" 1>&2
+			ret=1
+			ok=0
+		fi
+		;;
+	*)
+		echo "FAIL: pmtu $pmtu: unknown priority check $what" 1>&2
+		ret=1
+		ok=0
+	esac
+
+	if [ "$ok" -eq 1 ] ;then
+		echo "PASS: $what: priority packet counters match"
+	fi
+}
+
+test_tcp_forwarding_set_priority()
+{
+	local pmtu="$3"
+	local proto="$4"
+	local dstip="$5"
+	local dstport="$6"
+	local lret=0
+
+ip netns exec "$nsr1" nft -f - <<EOF
+table netdev priocheck {
+   counter prio0 { }
+   counter prio3 { }
+
+   chain egress0 {
+      type filter hook egress device "veth0" priority 0; policy accept
+      meta l4proto tcp meta priority 0:3 counter name "prio3"
+      meta l4proto tcp meta priority none counter name "prio0"
+   }
+
+   chain egress1 {
+      type filter hook egress device "veth1" priority 0; policy accept
+      meta l4proto tcp meta priority 0:3 counter name "prio3"
+      meta l4proto tcp meta priority none counter name "prio0"
+   }
+}
+EOF
+	if [ $? -ne 0 ]; then
+		echo "SKIP: Could not load netdev:egress for veth0 and veth1"
+		return 0
+	fi
+
+	if ! test_tcp_forwarding_ip "$1" "$2" "$pmtu" "$proto" "$dstip" "$dstport"; then
+		lret=1
+	fi
+	check_priority "prio_none" "$pmtu"
+
+	# The flow stores the priority set before it is added, so the packets
+	# the flowtable forwards leave with it too, in both directions.
+ip netns exec "$nsr1" nft -f - <<EOF
+table inet prioset {
+   chain forward {
+      type filter hook forward priority -1; policy accept
+      meta priority set 0:3
+   }
+}
+EOF
+	if ! test_tcp_forwarding_ip "$1" "$2" "$pmtu" "$proto" "$dstip" "$dstport"; then
+		lret=1
+	fi
+	check_priority "prio_fwd" "$pmtu"
+
+	ip netns exec "$nsr1" nft delete table inet prioset
+	ip netns exec "$nsr1" nft delete table netdev priocheck
+
+	return $lret
+}
+
 test_tcp_forwarding_nat()
 {
 	local nsa="$1"
@@ -516,6 +616,11 @@ else
 	ret=1
 fi
 
+if ! test_tcp_forwarding_set_priority "$ns1" "$ns2" 0 6 "[dead:2::99]" 12345; then
+	echo "FAIL: IPv6 flow offload for ns1/ns2 with priority update" 1>&2
+	ret=1
+fi
+
 # delete default route, i.e. ns2 won't be able to reach ns1 and
 # will depend on ns1 being masqueraded in nsr1.
 # expect ns1 has nsr1 address.
@@ -572,6 +677,11 @@ if ! test_tcp_forwarding_set_dscp "$ns1" "$ns2" 1 4 10.0.2.99 12345; then
 	exit 0
 fi
 
+if ! test_tcp_forwarding_set_priority "$ns1" "$ns2" 1 4 10.0.2.99 12345; then
+	echo "FAIL: flow offload for ns1/ns2 with priority update and pmtu discovery" 1>&2
+	ret=1
+fi
+
 ip netns exec "$nsr1" nft reset counters table inet filter >/dev/null
 
 if ! test_tcp_forwarding_nat "$ns1" "$ns2" 1 ""; then
-- 
2.53.0


Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DDAD305057
	for <linux-rdma@vger.kernel.org>; Fri, 20 Mar 2026 01:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773969922; cv=none; b=CMVbfqI0Hwb5TDwDPACNqtQs5TOOGicbVNzo2ekfbrysXnrg6FeQRiUF5ZaspiBujfqVMBrMT3fEPc4ehnJuUTtVTag1hRLVXJe28Fd+yJZk4TJswSLA0S2BzqMjFr7hXlweKS0BWEVPhGOtHZicTRaaa2MtpfHPonPdI9ZwU1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773969922; c=relaxed/simple;
	bh=fFbx4L7c5RG8MsSh64xUKulTqmO1Wn4GpSHiz4YrwzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oK78TpvDkfbpor54kJbjm2V3mf67GO4b6aLws6THKFVW8GtMjg6ydhJulwWo2U+eJ5BxBInPPKi1GkNUKYcgZvk3qRfp1u+KyTeRWfO0sPCtZ3UWqwJOuepE866O16tR2rvNVa6thXTsTHYsGepkijTTejeIeFrdYh39K9DKTJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fomichev.me; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=74.125.82.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fomichev.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-2b6b0500e06so1503820eec.1
        for <linux-rdma@vger.kernel.org>; Thu, 19 Mar 2026 18:25:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773969919; x=1774574719;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LwI56IvSstpXQXaX8+DYC8cYl7ak5TMhpM2nnpgQBwA=;
        b=Q7xpnslfTc3fXYTq55BPJHjXkUtuMGk2itMvooH4qbdJt+JHT6mrFjvZ+mBGd+NNOF
         Qy32ULPNnWZASChZP6OaPLHkdVsqlCew0b620QRKARDMwRnhS9fHU3G16NzxD0TJULGv
         OIels5v+y4bcH0T5cN/b1pgfXl0H5EmhRvkeEdhYgrSPyLDztQ6hePYlDz89E1E/Wr4q
         I7vgWbZLZ1j9zc5KIZzSJDQfzYqqno2fmUWTP+Eyifr1+rccHRs83p0oadDisoacwpXy
         Bh8ajs1++UNnimZvCpbIGxA2/NkSHQG+9ZbkhPA1UtEx7DLWL12jBtjEA8LR8TF8bY3c
         SQ5g==
X-Forwarded-Encrypted: i=1; AJvYcCXXkyc7yqp8PrOBhIyxD7UUWV9wRxDK29Xrm+r8vD+W+CNZDpiugKI248Dogfse3phZ7t3sKI+ILQGo@vger.kernel.org
X-Gm-Message-State: AOJu0YxnokVCx1u5O6c1IPMKOfQoit5Cb7QDwZwRy7D0R/uYQnK/uvJU
	jQLHt66hka18X+67VU/fc2qFj7cPhZ6ipTL5gCFbY0NOXjkrFGlF/10=
X-Gm-Gg: ATEYQzwKOHLid8WV+Briu7IxUOdf26CnSLjKQzW4SfJ/D+SatQZkcp5hbfiXgwh/OzK
	L3U7cxtoZFDHaz/qVh7p8hqRuaWj0YiRGniP3q3AkOoKTMkre962yuSy4zxwtPE8WmHzvZ6rRYO
	qIwcfmiMFVo9cNpHgPCBj9yhRXAjcbyOgV97kVMeA2La5vfIT+D/8Uxu4j9JMXs8kpjwVBOEOan
	M4ekCTmmruXMlAxDa/IyEQx9+WNsH75yFEK7i2GDxDBu7+BFIE00QbCzK8gBJveb1Aa6+H8mEwK
	/tPXPoObmACTeofEfpWwfPQYHvBo8LgncKQGTpdFmOz858MN+7jQ+rjUJ9PI2JfaiA9YL9CW0mE
	XW4BYyIdPhA4+4gaiJERIfa+h17oqPrSYGmzhhiQWMBResPrIcS6Gin65xguz3BLbgr8nS8tb5+
	P0dW7MNDCdkm4s9AGnPVubCJVtCOfiOoCARXSU4E3Ye/OXW+Ymlpuy1djdEbW1kyAUJcDP15E1s
	DnL04q5HhJAmaxYmg==
X-Received: by 2002:a05:7301:4198:b0:2c0:c415:cfd0 with SMTP id 5a478bee46e88-2c109666ba0mr851744eec.15.1773969919058;
        Thu, 19 Mar 2026 18:25:19 -0700 (PDT)
Received: from localhost (c-76-102-12-149.hsd1.ca.comcast.net. [76.102.12.149])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2c10b29d28csm1378065eec.19.2026.03.19.18.25.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2026 18:25:18 -0700 (PDT)
From: Stanislav Fomichev <sdf@fomichev.me>
To: netdev@vger.kernel.org
Cc: davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	andrew+netdev@lunn.ch,
	michael.chan@broadcom.com,
	pavan.chebbi@broadcom.com,
	anthony.l.nguyen@intel.com,
	przemyslaw.kitszel@intel.com,
	saeedm@nvidia.com,
	tariqt@nvidia.com,
	mbloch@nvidia.com,
	alexanderduyck@fb.com,
	kernel-team@meta.com,
	johannes@sipsolutions.net,
	sd@queasysnail.net,
	jianbol@nvidia.com,
	dtatulea@nvidia.com,
	sdf@fomichev.me,
	mohsin.bashr@gmail.com,
	jacob.e.keller@intel.com,
	willemb@google.com,
	skhawaja@google.com,
	bestswngs@gmail.com,
	aleksandr.loktionov@intel.com,
	kees@kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	intel-wired-lan@lists.osuosl.org,
	linux-rdma@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	leon@kernel.org
Subject: [PATCH net-next v3 13/13] selftests: net: add team_bridge_macvlan rx_mode test
Date: Thu, 19 Mar 2026 18:25:01 -0700
Message-ID: <20260320012501.2033548-14-sdf@fomichev.me>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260320012501.2033548-1-sdf@fomichev.me>
References: <20260320012501.2033548-1-sdf@fomichev.me>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a test that exercises the ndo_change_rx_flags path through a
macvlan -> bridge -> team -> dummy stack. This triggers dev_uc_add
under addr_list_lock which flips promiscuity on the lower device.
With the new work queue approach, this must not deadlock.

Link: https://lore.kernel.org/netdev/20260214033859.43857-1-jiayuan.chen@linux.dev/
Signed-off-by: Stanislav Fomichev <sdf@fomichev.me>
---
 tools/testing/selftests/net/config       |  1 +
 tools/testing/selftests/net/rtnetlink.sh | 44 ++++++++++++++++++++++++
 2 files changed, 45 insertions(+)

diff --git a/tools/testing/selftests/net/config b/tools/testing/selftests/net/config
index 2a390cae41bf..94d722770420 100644
--- a/tools/testing/selftests/net/config
+++ b/tools/testing/selftests/net/config
@@ -101,6 +101,7 @@ CONFIG_NET_SCH_HTB=m
 CONFIG_NET_SCH_INGRESS=m
 CONFIG_NET_SCH_NETEM=y
 CONFIG_NET_SCH_PRIO=m
+CONFIG_NET_TEAM=y
 CONFIG_NET_VRF=y
 CONFIG_NF_CONNTRACK=m
 CONFIG_NF_CONNTRACK_OVS=y
diff --git a/tools/testing/selftests/net/rtnetlink.sh b/tools/testing/selftests/net/rtnetlink.sh
index 5a5ff88321d5..c499953d4885 100755
--- a/tools/testing/selftests/net/rtnetlink.sh
+++ b/tools/testing/selftests/net/rtnetlink.sh
@@ -23,6 +23,7 @@ ALL_TESTS="
 	kci_test_encap
 	kci_test_macsec
 	kci_test_macsec_vlan
+	kci_test_team_bridge_macvlan
 	kci_test_ipsec
 	kci_test_ipsec_offload
 	kci_test_fdb_get
@@ -636,6 +637,49 @@ kci_test_macsec_vlan()
 	end_test "PASS: macsec_vlan"
 }
 
+# Test ndo_change_rx_flags call from dev_uc_add under addr_list_lock spinlock.
+# When we are flipping the promisc, make sure it runs on the work queue.
+#
+# https://lore.kernel.org/netdev/20260214033859.43857-1-jiayuan.chen@linux.dev/
+# With (more conventional) macvlan instead of macsec.
+# macvlan -> bridge -> team -> dummy
+kci_test_team_bridge_macvlan()
+{
+	local vlan="test_macv1"
+	local bridge="test_br1"
+	local team="test_team1"
+	local dummy="test_dummy1"
+	local ret=0
+
+	run_cmd ip link add $team type team
+	if [ $ret -ne 0 ]; then
+		end_test "SKIP: team_bridge_macvlan: can't add team interface"
+		return $ksft_skip
+	fi
+
+	run_cmd ip link add $dummy type dummy
+	run_cmd ip link set $dummy master $team
+	run_cmd ip link set $team up
+	run_cmd ip link add $bridge type bridge vlan_filtering 1
+	run_cmd ip link set $bridge up
+	run_cmd ip link set $team master $bridge
+	run_cmd ip link add link $bridge name $vlan \
+		address 00:aa:bb:cc:dd:ee type macvlan mode bridge
+	run_cmd ip link set $vlan up
+
+	run_cmd ip link del $vlan
+	run_cmd ip link del $bridge
+	run_cmd ip link del $team
+	run_cmd ip link del $dummy
+
+	if [ $ret -ne 0 ]; then
+		end_test "FAIL: team_bridge_macvlan"
+		return 1
+	fi
+
+	end_test "PASS: team_bridge_macvlan"
+}
+
 #-------------------------------------------------------------------
 # Example commands
 #   ip x s add proto esp src 14.0.0.52 dst 14.0.0.70 \
-- 
2.53.0


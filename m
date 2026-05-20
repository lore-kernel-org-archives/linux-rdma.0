Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11BF9165F1A;
	Wed, 20 May 2026 01:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779240907; cv=none; b=tcTCS7GnCz+TxuCDr5hkmR0su6Kj9a0WeAdGOHTXw4hOu5G60My7nRtWxzsiCTR6iXhioatjMVV/N/GqUU/PNdl+LOOwVK0dbN4xxSP46SA0fGo9Fe7NMj0orUSqcsxsUoFrR7kcvuBUCzHMjWzfKOaXgJrsplURsjYHwwq5x7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779240907; c=relaxed/simple;
	bh=VlF106n3KI77nNqIHl5zCL5S+iUjsagCmF4QnDDQbUs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=sGPTnBveeGuIZePeey5iktNYvAbU5/OliwAUEmlvfj2Tn1Jq2c4zIBLvyoWDFM5VBfD+dFSkzC96BigATbtLOmrPRWkjpciNzChu4gw6An3NQHhpWGfwmFSmxaIF9fcRGSoc4bTEdzqN1DzwfsErolDGq+Pd4PWdgorRb4ES02o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j+cT/oAG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j+cT/oAG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 918A41F000E9;
	Wed, 20 May 2026 01:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779240905;
	bh=B0F19t3trMZWR71OsB5KaKjV93HVmCtzo2gfr6+e4uI=;
	h=From:Date:Subject:To:Cc;
	b=j+cT/oAGm85+UI+Y+awbCu0lQ3eVa4Ae5VcT8lfV+tKtXtZvOSHEftRtVc2kXPrwQ
	 2TDtJte7WA+YuncaIE11kLRQR+7M+8AMUm1C07mUZKaymYl/uW9tlocD+u5dXQfNMJ
	 oVCGLucl07oZaEgOyqI5BKX1q1PNQrXI+cKfQ1fkK3zddlw7nBEI9hrtthQnRdb9Jo
	 dg9deoDp429A5aKqq55NNsgrYjT111zwRr+sZz/FfBIIndvCSEoIjZUyJvfFRcJbrr
	 q7fbQz9fVceo1tbH/XPTx1irJK1JzFTl1kwFZB/1g0EK3DRD3C5BJHF5429somWVP4
	 W/sB2fBfj2qjQ==
From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>
Date: Wed, 20 May 2026 11:34:43 +1000
Subject: [PATCH net] selftests: rds: config: disable modules
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260520-net-rds-config-modules-v1-1-2100df02fe9a@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yWM0QrCMAwAf2Xk2UANrKC/Ij7UJpsRbaXZRBj79
 2X6eAd3C5g0FYNzt0CTj5rW4nA8dJDvqYyCys5AgWLoKWCRCRsb5loGHfFVeX6KY+J0osi5pwg
 ev5sM+v2NL+ANXP/S5ttD8rQvYV03KCFjBX8AAAA=
X-Change-ID: 20260520-net-rds-config-modules-cada926dc526
To: Allison Henderson <achender@kernel.org>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>, Shuah Khan <shuah@kernel.org>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, 
 rds-devel@oss.oracle.com, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, "Matthieu Baerts (NGI0)" <matttbe@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1103; i=matttbe@kernel.org;
 h=from:subject:message-id; bh=VlF106n3KI77nNqIHl5zCL5S+iUjsagCmF4QnDDQbUs=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBqDQ/FZv+ANFO1mdlB9G5PQA9p8tRaj2OEx/t0X
 SSwkI60tkuJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCag0PxQAKCRD2t4JPQmmg
 c0bHEACZAQgBnP1kX0SQ7NBPXwGMhwH2SMna/P37YREjvsl6wK4cH8DGBPzITjN7PpXPsSGF+B3
 5y8DOuc8o70QmWZ52dFcJICluijtbEEZu+5UKo0pYez2TWMB/PoIfXSu2EAhSM1+fEx3hALoyKM
 wgjU8bg/O+hG9j8ETe+XOq49lBl+Ht3dXc8OloEl+AsBzr8zXK5zzwR5XQhziVftNhp+5eQ6qfT
 /oy+METGft6ytG26csBSV5+2L5lsFqBiy1147kI466Zi4nYmxM9egfykeY4dX+WzbSR44lLONJ4
 CDKtKewkC0j+QKuWJi2GYgDnG4ImFhJoLfuUhcqoXF8lBa/IXSDI0XWMxI6vRLpU52fHkE30N2J
 HZ+2cE0Uif11MyDmFsC8ogSs2B/1RMbeTVbJTaI6Wi9qN3b+sMYgGDKnIpNg2wC+7qpvbwkL+Ej
 7ql6H/VSNiMD36KC0PBNowXoj2lTneN9GgW4SdoXJ0S8W4OspyrGtwLfd1iK81/JhHSUEmidXdz
 uC+ToxDY4gKUL2d7fnevp6NiT9NmUzKBMFITQI+JeDyFSMKUxSyXzTV5dP/IcXJT9kZ2x/F5qZW
 yxCeJ599WCW4j9iqL3Tw1eyk8krBFp3Qr7v1Jht7y69lzxq7Q08nXTQrCws8h3iE0d3e1KSjHLM
 1V3kO/485UQMehQ==
X-Developer-Key: i=matttbe@kernel.org; a=openpgp;
 fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073

The run.sh script explicitly checks that CONFIG_MODULES is disabled.

By default, this config option is enabled. Explicitly disable it to be
able to run the RDS tests.

Note that writing '# CONFIG_(...) is not set' is usually recommended to
disable an option in the .config, but it looks like selftests usually
set 'CONFIG_(...)=n', which looks clearer.

Fixes: 0f5d68004780 ("selftests: rds: add tools/testing/selftests/net/rds/config")
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
---
 tools/testing/selftests/net/rds/config | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/net/rds/config b/tools/testing/selftests/net/rds/config
index 97db7ecb892a..3d62d0c750a8 100644
--- a/tools/testing/selftests/net/rds/config
+++ b/tools/testing/selftests/net/rds/config
@@ -1,3 +1,4 @@
+CONFIG_MODULES=n
 CONFIG_NET_NS=y
 CONFIG_NET_SCH_NETEM=y
 CONFIG_RDS=y

---
base-commit: 90fc1a393736063b2b4077115e215a2e2eebb797
change-id: 20260520-net-rds-config-modules-cada926dc526

Best regards,
--  
Matthieu Baerts (NGI0) <matttbe@kernel.org>


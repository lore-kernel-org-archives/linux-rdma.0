Received: from mail-dy1-f195.google.com (mail-dy1-f195.google.com [74.125.82.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA8A770830
	for <linux-rdma@vger.kernel.org>; Sat, 13 Jun 2026 22:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781391549; cv=none; b=iB7QwPYUkwyrWQ2zLBm4facmId9H3ps9H8L4kop4bU0wyHhBVvLwkrYuVDZ0gjLn1SL3rjc6Dlc1dDw6Xk4/jcWh2klt9sErbSE2oR89zD5A95aYoPOUiCZDiOxJzeNxXRDe0XxWsZusW5icV5Kcmv1XRCtXwzniGTSzgsNkeT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781391549; c=relaxed/simple;
	bh=mTS41X7I7ffG+ZNIGyvPp2wrgUZodJJY5+mtQIGxK1o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Zc2omlQXAU6LqUYCZ7JF/X0TfPIKjeiFs3uXy1xSmiP2M+ZvXGBJbp5qFwkgR1z9OyB2gt1FWRRDjEhsdekT+IuFqRl2BkPFK8dcO3j2k/sWRqHddb1w0EJ83uVabOXSd694BWqiOc9hVILniTRQiNn7oL4x9v2/m2bocYP1ltU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LKy+om/c; arc=none smtp.client-ip=74.125.82.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LKy+om/c"
Received: by mail-dy1-f195.google.com with SMTP id 5a478bee46e88-304df7ff4c2so1891079eec.0
        for <linux-rdma@vger.kernel.org>; Sat, 13 Jun 2026 15:59:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781391548; x=1781996348; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZFBr+sp7uL5h9HCXS5j7a1sFp3i7DPsb3E18CPW1FYA=;
        b=LKy+om/caBUpfSxGEHFKa4B8TbEvA4eoe6DwzY45gbQ5gTOdn9A2Z2XZ56ljEo4Hjv
         z6T4b94t1J0PKX4v0UvfJHEQ6qClTCh1tXqKOI2kgYVeAXr4JX+3wydcAw7bon4IWBu9
         TYAvK7RG4T5vZ1b+44vk6MticCZrqvg2qqj+Xwoj2B7KcZDp6Y6abbAG1pT1BbseFMwx
         Ky1ZLCaA/gxX6hDEF/SVFQf/hzSudQw7lFZ0UqQS+obauxD+HcG2ypgEnTxzFf0oE6EF
         5oVGVDr6e5GnREcDzjpeAgJT6KRgdGvwJpCsKRiRdyNOvDnyuJRKJPW2wteis+8sBOdp
         2IqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781391548; x=1781996348;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZFBr+sp7uL5h9HCXS5j7a1sFp3i7DPsb3E18CPW1FYA=;
        b=LQLK8U9BZB02Jv5aE95n1/3goFKoqGV3YSalTcfLcjresMpPGknRqeXC1HWfjEMDFU
         kVsbArhinX+aUclLI9I3M3vEytT+AfWrbeHge3UkLW2CBKAMF3mhoHdmnFix8dwlyCyp
         fITzNFpGoeZJ4VJkmhLM66QnELc66mI8Ow/bW/DaNcZJe53QgQnTJirLWF0Cf7uwJ/gt
         qEZEK4e53HHJ3ui2w+RepnJx7hJRYEl8YX32yyhAEt1hVPzAH87TKzbu+snWGwcHPVFr
         IYbbqIwowVJAVn388S71E1XCtz3ShPiwWXZJkiM4qKUlQ/bhF5pztUVdZqofzgTJzZUC
         JrkA==
X-Forwarded-Encrypted: i=1; AFNElJ+n1PhaIgp/CtS9D9Dd8hHPlDmBY15GEUre8fmJRJaqpcQp/o+9WwXJhwfXBpHKtEIg844RKsXIq0NO@vger.kernel.org
X-Gm-Message-State: AOJu0YwFvlQOfoqNg8AxFL+klAV1b/aie6dFq55Kj88BtnmzV43r40JE
	dgLsM8NcjpcPldGVT3oWjl3DgKm6E75fzlhz9+karkpDbcDcUnFelrtW
X-Gm-Gg: Acq92OEvlunKo9Xy2qtp4wKbT5As+e8sr3pa5ZZqcBAhaBfGRlQWq7vwA35771pGj1z
	n01L2fur5AkgermSR0RlBCMCsVnipMzLDwmSvYPzG7LQDnk0CO8Zd11+p3JzDjUJvH+CCGRSNLK
	cX+Na4GkSe3tZqZW7qMV25a88Ki2oSDyGMlBmWQq9Y0hYshzXVZuJS3PVppAdiLpT88XGu2exWU
	JiBVHorOVEalAlEZ7Q3Ybcu0qi99MdQFzx8Q0rt3tmNov1hRQxOvGJzE7L9MA9ogztUhqAYi/li
	GXUwEFnt9CGmli8hn4vo3wlb5k6ULCUZ3GEt2csNHWZVTXd01Gk9wttj1WRVL+5vdzMuF2HxXDE
	0hgenAtvAdm76klxEwODWyExe1vQ86QQBf0jSX+sPduoDXeJC7jMgzHIijAjZots2U7QiVdiD9I
	sVepcyA6oZ4SoeOhZ8vXQ6kObcG34hL1brSWbb0L2mw1FctR6QnjTRV+eO9tq8Jv9msA/lLu5/C
	wv4eCBFrH/+MOjZnI2t9Kcr1N2SeFA4fh+kzNPbo4sGxkCcsWCFdpWpk+U6p2RofQ8cQcaeaGL4
	huRtAfKc1hFvYX8HMw==
X-Received: by 2002:a05:7300:8ba3:b0:307:3a74:749a with SMTP id 5a478bee46e88-30820cf480cmr4424971eec.16.1781391547690;
        Sat, 13 Jun 2026 15:59:07 -0700 (PDT)
Received: from ethan-latitude5420.. (host-127-24.cafrjco.fresno.ca.us.clients.pavlovmedia.net. [68.180.127.24])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3081e5cea89sm9955573eec.8.2026.06.13.15.59.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Jun 2026 15:59:07 -0700 (PDT)
From: Ethan Nelson-Moore <enelsonmoore@gmail.com>
To: "GitAuthor: Ethan Nelson-Moore" <enelsonmoore@gmail.com>,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH] net/mlx5: HWS: correct CONFIG_MLX5_HW_STEERING macro name in comment
Date: Sat, 13 Jun 2026 15:59:00 -0700
Message-ID: <20260613225904.140791-1-enelsonmoore@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A comment in
drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.h
incorrectly refers to CONFIG_MLX5_HWS_STEERING instead of
CONFIG_MLX5_HW_STEERING. Correct it.

Discovered while searching for CONFIG_* symbols referenced in code but
not defined in any Kconfig file.

Signed-off-by: Ethan Nelson-Moore <enelsonmoore@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.h
index b92d55b2d147..20cdacd8f12e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/fs_hws.h
@@ -116,5 +116,5 @@ static inline const struct mlx5_flow_cmds *mlx5_fs_cmd_get_hws_cmds(void)
 	return NULL;
 }
 
-#endif /* CONFIG_MLX5_HWS_STEERING */
+#endif /* CONFIG_MLX5_HW_STEERING */
 #endif
-- 
2.43.0


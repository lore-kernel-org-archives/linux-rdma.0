Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794885225;
	b=VHd3VG9dUjxg+sE7fi26AIhP4ZgM6mYDy8+0Fn1zGtOSp3bKyovj9iTBTavEvXtiGjQj
	 ar9C1sInex0kizrq61k66pNbHT8P64yq5ppCPGAF4o0FQNR44FHPsNXMDwTYye+SCTGjX
	 A15oU2PMCkQithxutcqs0YRql3x5p8wYnPBAIyI8Ltq0Fx7I8uQcmhLDzALC1cyPOeAmA
	 4gcbYV3ERy7mRXmsBEsHbOJUeWZxfqZVkkjq1H6AxA2UTJmuMGEvLI2n8mKf4I2GJtmcf
	 THwpTxtvOczhkUd5QYoS36SJCvXYwnxAjuNyV/VTt6VS6ksIkY+H9hDxdX7+yZfk0uA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794885225;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=IY0HuO3BnkQdngef+fmsiBdbRJiCtWyfl5JCFdKbRHA=;
	b=UNQAvbKIVNiAA0PeHEkef4Z9R8SPAHKATjZF3nEuatrQifqlOLnGk+6zbkQNoBhd0KLq
	 27E/fQ06RUBmZtStcU1Ck+bJix+1PnClt7KermWOSU/Pz5c8S5t7St+Sa5lNQ8HOBmOEU
	 8BQwGtwhUysVgyoIqpSwL7OJAtLXSkplObKH+SzkN/0ugilm/xuG03zEhDqdCKbLXzdKA
	 wyDm1e7doPyT/kFFPiBVp55XNGn8+46Lcmr/pdLd0gmmZ91wMa9p2ochhsg39cTOs/cbE
	 wDh9dybROc4YWkzrfqQw1MZxl3ud0JJNRwBxV2tXyfDBduy3faF7HJoV0HSwi1h23GQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Xwea8SFy;
	arc=none smtp.remote-ip=209.85.128.46
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 427CE606A31C
	for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 03:13:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 427CE606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Xwea8SFy
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a2000d5fb1so20840035e9.1
        for <linux-rdma@vger.kernel.org>; Mon, 16 Nov 2026 19:13:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794885223; x=1795490023; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=IY0HuO3BnkQdngef+fmsiBdbRJiCtWyfl5JCFdKbRHA=;
        b=Xwea8SFy6dq5YCx5TnEg7s7TjmKn3RqF93jEzkLGdlrO/9brrztpFdqVI3zCuA2abY
         C5ZcxrPW/egan/vtln8DA0VBQlou9hrZBAyZHLFcWYuyX9KsdoD+pQbqnKbil+FjArIi
         aqtPjSm30s9kVsKnV2dKjb1Ce7+Mj0IlHxRGwxrr4WxdzIvIGKNH9k5zl72mHlHnFqe0
         GhGESNLta3lH4dTV8UWrxy6AwyRgXwLnhrU21mlZ8fgFoRoviHfDHzX2M0jiyU2tsbDk
         9hJuHyoF8n4g3rEueOuAWyxSKEcJGFoUQ11d37hOSr7K2dN0YPG6t+2ggkkwkE+ygnVU
         26TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794885223; x=1795490023;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IY0HuO3BnkQdngef+fmsiBdbRJiCtWyfl5JCFdKbRHA=;
        b=Kd+18tiGk6btFKi4JlkGXUDu4TamI87jpTLGbKsK3Ws2YfLP5869GkmwrDZbm8jnEQ
         wmq57I5XC9Fj+bMR92X2vha4338w3aQo5eZxtroEBq25gDQv9l5mYszlSggU6SayjlfT
         baZHxCGZu+d3dywsCEAV9WxHfOv5mPpvyEJAjLadWGToJ8HhDh/xwuHj3rzs4eWyduOp
         UyLPnNc7JuI1KCuJMVQ3l89GbBB0i+6gKjj5qfc8CFJb5ObTzeRIxTOqeWoNJ3O9NZwe
         mrvGIezGBG4LyhXlJl4Py1cNmlz2/RUOrna4hZT4F8j4X1vWRsUCYzMsLwR2+7zgBZA4
         VD7g==
X-Forwarded-Encrypted: i=1; AL+hErFbAHrmu/20VWXdhMrsmeI/9T6S6+IRoQxT6YKm9AlWlvaoYUr2k5lx0GL3lyd2vZ1G1vZNIGJRC/Pp@vger.kernel.org
X-Gm-Message-State: APuU4Z+zKkdHcKDaKPJFUzY/vWQPK2j0aghrwLp5HqLVAwwKJK7S5YpL
	INkKmqhLSEXXSF0uGxs6LLjtNLzGWgYQl4NGmnufBjzztBzr4MvBFWQT
X-Gm-Gg: AYBFou1MXqKF7J6v1M2ExXjcpvz1iY2NhU0EA4rI/+Sal/L9z2hSFwAejQrwDlDeoTm
	gsSOZkJt9E3TczuFfaAQZ4+ndrcTswJWAoUdeR2MJgdug9k/dYAm8Kccn3RMCbXiwz7wJoH0aCl
	+cfum/NIWPd5qI6nwjB5gCDgjFLlFn1QONQ80rk5tOFEr+peVESQVJ3cDAvoB8Fd1iwmWDabEPH
	IgucvF12728UZrxaoyMbhfoiOX6stNRhqmtNF2H9uUFsn/ZeRjI2eBDh3d7ky+LzmRwExTOdyoT
	l2h7vFmiQEYdzyRRfFIHDzA0lwcHGNvcaC5TU1P41/0yWC48Dl8QhB9Uro9f+0XJf9x+jsE0gHt
	/Cs7qJ5gfL0i1gjFc3Gp+1TDhZeT4j2zcFoL1dnj3p8YHE506Kvb6kgxd/jGUmpllTpCswwrD4G
	6mlvpGA6Wrobnena2a65nW0mIPd1zoAPEurPdTeR1CnMn85Yfr0h+9z1f7Fx+/to4FISIHIJVFT
	xbx0aq/RYERVfF3EMTJKH38Wj5HA6eZOddTD7lZxwoSDBwkYfoewe3+YMwznfji1KVSatpjGqIt
	dPPFS8GUd6FBVyMYnHSamoNDmOwbBAnJ1i3e6w3xHvoPnKzl
X-Received: by 2002:a05:600c:1912:b0:4bb:6375:aa41 with SMTP id 5b1f17b1804b1-4bb6375ab25mr186448935e9.27.1794885223384;
        Mon, 16 Nov 2026 19:13:43 -0800 (PST)
Received: from localhost ([2a03:2880:31ff:41::])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c60f8d615sm25876743f8f.56.2026.11.16.19.13.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 19:13:41 -0800 (PST)
From: Mohsin Bashir <mohsin.bashr@gmail.com>
To: netdev@vger.kernel.org
Cc: saeedm@nvidia.com,
	leon@kernel.org,
	tariqt@nvidia.com,
	mbloch@nvidia.com,
	cjubran@nvidia.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: mlx5: Allow police as the last action of a TC rule
Date: Mon, 16 Nov 2026 19:13:37 -0800
Message-ID: <20261117031337.4126403-1-mohsin.bashr@gmail.com>
X-Mailer: git-send-email 2.53.1
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

From: Mohsin Bashir <hmohsin@meta.com>

In switchdev mode, mlx5 offloads police only when other actions follow
it. TC needs no extra action for a police-only rule to work. The mlx5
driver makes every police rule forward to the post meter table, but for
a rate police it adds that forward only after verify_attr_actions() has
checked the rule, so the check rejects it. The ok result of police is
also handled as pipe. In TC, ok accepts the packet and ends the action
list, whereas mlx5 goes on with the actions after police.

Support police as the only action of a rule. Set the forward while
parsing police, as is already done for police with mtu, and forward
an ok result to the end of the TC chains, as the driver does when it
offloads the gact ok action. The upcoming selftest series also relies on
such rules for TC offload validation.

The patch was tested on a ConnectX-7 in switchdev mode with the command
below, and it was verified that the rule is offloaded and limits the
matching traffic to the configured rate, using the hardware drop counter.

  tc filter add dev eth0 ingress pref 100 protocol ipv6 flower skip_sw \
    ip_proto udp dst_port 5201 \
    action police rate 100mbit burst 1m conform-exceed drop/ok

Cc: Carolina Jubran <cjubran@nvidia.com>
Signed-off-by: Mohsin Bashir <hmohsin@meta.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c | 3 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c            | 3 +++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c
index 1bd1c94fb977..52295f5d644c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/police.c
@@ -94,13 +94,14 @@ tc_act_parse_police(struct mlx5e_tc_act_parse_state *parse_state,
 		      MLX5_FLOW_STEERING_CAP_MATCH_RANGES))
 			return -EOPNOTSUPP;
 
-		attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
 		attr->flags |= MLX5_ATTR_FLAG_MTU;
 	} else {
 		attr->action |= MLX5_FLOW_CONTEXT_ACTION_EXECUTE_ASO;
 		attr->exe_aso_type = MLX5_EXE_ASO_FLOW_METER;
 	}
 
+	attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 1d35c97aea0b..8685e41487f3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3892,6 +3892,9 @@ alloc_branch_attr(struct mlx5e_tc_flow *flow,
 		attr->action |= MLX5_FLOW_CONTEXT_ACTION_DROP;
 		break;
 	case FLOW_ACTION_ACCEPT:
+		attr->action |= MLX5_FLOW_CONTEXT_ACTION_FWD_DEST;
+		attr->flags |= MLX5_ATTR_FLAG_ACCEPT;
+		break;
 	case FLOW_ACTION_PIPE:
 		err = set_branch_dest_ft(flow->priv, attr);
 		if (err)
-- 
2.53.1-Meta


Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793199705;
	b=3tQa0ML38hTS1cNCmgfokgGX1nPAQkGAjZgm+2C3NFh/G1GEkR3cinkxQTUivIhdQiNn
	 M+ZLZ8E789VmILxV7VTACh6bU9EmWz0XwcWBu1t+LbJro2qgfd1lMS4rxtp2CKIM4Fs6Y
	 hVsJ34AHR0cK1bkieUOfMjUchWLRjlfvYwo560kCNTI8ae8kSjIDVKq9vQtP3NMbsj+3d
	 jPzHVI8RWmIXgqsAvSLlFiYpqD9gZgkcwkNyzoFpiOEzgo+pJR6sGGG1WEj5SabzG7kOx
	 Wi3EAXMpi5iHT/Xa4IFtD355ZmwoUmvzTXkV6sXkb9ysUISMXCu9Ev8DsKTWjyYe0zg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793199705;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=31f6k6Qk+dLIN5aIDYfqU1+fJxCFB196QGT96yn9g4U=;
	b=XOJ8paTKbJRigl/9H29znfH7PnstifBz5R3WiXYiBLBrj0jsHU6eaTY4Wc6RH2kuyoFz
	 267Na4J3MkuE1y/7jY52Pl7uqjY1ofO6U+JKjWrLEgWE906SjoVgWv8zRFvDSfU6ymTed
	 pML0uiXOB7MPSMD+ZNHqSJu/rswmOApJYXzrZCNPCr/4MZYcGqExwk/a/lMzmgRDWic5q
	 BcKbnv9mB96kuFGO4a4DrGdmZSxro8xOaNwrEXgIqKQ601HKQjycZpSLbJwoMMXEp3ozn
	 3Va1y6l5TmVavnHmE2DI8JOfwqelqEJKx2euTk8mscnpv6vv9ZDaY0nwiXa9DAYW5AQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=r3sNAAXt;
	arc=none smtp.remote-ip=209.85.221.53
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBB8A606A330
	for <linux-rdma@vger.kernel.org>; Wed, 28 Oct 2026 15:01:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BBB8A606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=r3sNAAXt
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-48bbb06f29bso161778f8f.3
        for <linux-rdma@vger.kernel.org>; Wed, 28 Oct 2026 08:01:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793199703; x=1793804503; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=31f6k6Qk+dLIN5aIDYfqU1+fJxCFB196QGT96yn9g4U=;
        b=r3sNAAXtYs2FC/jtFhBxipQFUpM3FslY8spcfNfWA01UUVWzD4GMailvz4SifQgLun
         UL3i8TTTAPERxcZFH76u9T0+NR6kZvfr3FiyZk+MnlGSm0Vy+0Cec5oV8UoIvIjnwNnr
         lBB/Z3n8RQua4T+hRhIotsduSdFQP50yFF2JUnTNMPWz+B+mVzKXGkm0FM/veDc6MMMw
         qPjz0pzYx4OXlKUfucUgj6eNHDHneT7BrQk/0xME3zo7vZZbucRFlHwweMmoYrB3Pb0u
         fT44eTdA1Jved3FeIKDE5uZkNasdxhW2M9Cpd9EPlbQgDKCtPWXKvNDL4/vkCiHpY1k4
         Lx8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793199703; x=1793804503;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=31f6k6Qk+dLIN5aIDYfqU1+fJxCFB196QGT96yn9g4U=;
        b=P3+0QyGU0JQNks0BEGNtRHFDckyPhyYY/hIGw8monB7W9zkw8dXXgaO3+3VmT5ZEpN
         rJLoXAbjDNzG6jq6zpt5nK0cmHgUbKXCy3L2e4nq66uuYHgIZs4gJL7xfMkp8DbtrKqW
         HOOpzvUdzmaul5FySZmWKkSiF88Do8QjeqmXAqcS8hMRHRk2jHYmKu7yUVXHmZ8QHuPw
         btJY2F9ISTnIUBT9vZgbTafvArFWotuqWBYaMTouPWjhMHaDxJdwrIdiivN5+XKmsqYR
         xqLgnFj6mR6t/vhKneypnnkVcxfImj1IlWO/YtNKv+DqttBDJDWURktd8Aom+byBjcGD
         wOzw==
X-Forwarded-Encrypted: i=1; AKwUvBxiC4AebRVkA+Ahd/ekx33eLQ4Iy83SjMfzp2xDOfQCxkngF2TLSIz5j+DF3X6ri1zm0lqVgdZYX2zR@vger.kernel.org
X-Gm-Message-State: AFq9FYLMMJxgGSN0Z8AjhB307fQRbSQSbeAyie/lmEsogElIOWGvWwL4
	6cVxgzrwmUkH4pezAdQJvO0cZzsd5Ojtr2kQOILbdfvhikg8cGGouGAI
X-Gm-Gg: AYBFou0zeMxKrBEoBQuMOWf2hP8yaD1l6Ayr5eIH25eMn9spv0H783d9EEeo3tltU0K
	iLj4FBZMJGlZMyBbE2TPKPyofvWxImxIdMlYu1yBIkqgfgO/01Wyuod/KwrxAuU8AX77oSjujXU
	bVZKkX2yz0Lb4I3LLuuVdr9yDpQkvFDmHgjDHYpDLwxCmub4De9BpZHLS2ywjxEuxLRMjbRNKrT
	bw6HMvocQjscdSkm5DdBfUWkYeCJDhSrvRp2QUchQmlV2WsGSXT3QhagAl00eKJfQgkId/GRdGI
	Lzr5HGt44o9cJlcL0LxpJ7E6qP3bBudts2qlcZWs6Z7Rp5QcIgJyqDv6g+AWUk3ABlWXlQVOiNk
	bBi6ps3fm/YxpPhUHuObnzZX7cSGveB0KT0x9jndrH4GvLsTvl8CiBc11TppRL/eaHmUhhtwh9I
	62Dpwgov43KuNJ3qr1Bwf5L7DTxIFvW0Q6KstEsQNjdlS4Tl5iBrGEtoIsuK9hSviQGiWIBDLLb
	MYMwQ9fTAevWsEaw5htBSZ66FmPpgOxN4RP/HBQlNuy9S9OGjMr3dmkltHNY/kypregRQMEUdA8
	CJke9qh+6KhRa8DSJAytsIWJ4Gq1iovIQtWB9CtFvLJLYT2wab8b+qp/NQpVCOrJUMQJ7KCR9Ou
	Uug0J27D9CsxO4uZ/fgySN5YdOsy2Hs4IBTquJNwfguU=
X-Received: by 2002:a5d:4584:0:b0:48a:f41d:83c with SMTP id ffacd0b85a97d-48e5d2cfc69mr4811478f8f.0.1793199702768;
        Wed, 28 Oct 2026 08:01:42 -0700 (PDT)
Received: from thomas-precision3591.paris.inria.fr (wifi-pro-83-149.paris.inria.fr. [128.93.83.149])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-48e3ebd4bc5sm28951293f8f.34.2026.10.28.08.01.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 08:01:42 -0700 (PDT)
From: Thomas Fourier <fourier.thomas@gmail.com>
To: 
Cc: Thomas Fourier <fourier.thomas@gmail.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Oz Shlomo <ozsh@nvidia.com>,
	Roi Dayan <roid@nvidia.com>,
	netdev@vger.kernel.org (open list:MELLANOX ETHERNET DRIVER (mlx5e)),
	linux-rdma@vger.kernel.org (open list:MELLANOX MLX5 core VPI driver),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net] net/mlx5e: TC, Fix double free of branch in failure
Date: Wed, 28 Oct 2026 15:57:02 +0100
Message-ID: <20261028145805.54595-3-fourier.thomas@gmail.com>
X-Mailer: git-send-email 2.53.0
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

When allocating the false branch fails in parse_branch_ctrl(), the
already allocated true branch is freed but attr->branch_true is left
pointing to it. The caller parse_tc_actions() fails the flow, and
free_flow_post_acts(), mlx5_free_flow_attr_actions() which calls again
free_branch_attr() on attr->branch_true.

Clear the pointer after freeing it.

This bug is theoretical and was compile tested only.

Fixes: f86488cb4685 ("net/mlx5e: TC, initialize branch flow attributes")
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index b290beb4369a..c40c7b55a54d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4005,6 +4005,7 @@ parse_branch_ctrl(struct flow_action_entry *act, struct mlx5e_tc_act *tc_act,
 
 err_branch_false:
 	free_branch_attr(flow, attr->branch_true);
+	attr->branch_true = NULL;
 out_err:
 	return err;
 }
-- 
2.53.0


Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.169
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795143312;
	b=bH/y6JojMbCGaANjTp80Jd05oCwqawW5jRl3fuSNkNgOvMB/LaSUFJUeXy4+37Zu8sLv
	 WL8BT1ZtJoL9a+Jt+Bp6Lt5Yq+6xVJpY7koae2nooBl5VyqNw8neIpzavW8mUtBCcS7C9
	 7IJImUJQR81FtdY7hgb7bogDWz1+iM/wB4A6LaQgBH/d8hy91rGZZKl7k8cq8NbyBOri8
	 ADAnjxmk7o2CWtXvqDwd3/ulV+2YY0m5NHUdZ0FDmIOFDbDYvxaBvaqZ96+GNdb6jTikJ
	 nqK0hNBLK5Xd+sWk1QVN0++92WqWdX3MPnokeJnWt0s5dnKJqNBNdB8Lh8AgwzN+4GA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795143312;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Rjhg0kwaD/wTpUnBxoXJn8jVRPigfkaeSmbsFggc+7k=;
	b=xq+ci4ZPy4d3SqaIP63QWBfdZ0DeKUslxDamfQpoEavy4FLvNgiDxCCGWpTLC2tvnZaX
	 Oozs82k5ccodBoBoWKxmU7W0RAfwnNiH2xyZdILdijhzp2laZ0CtvVJ+8C5YQCcc+K0Np
	 OYKxYktvpZUPEIcIW0aIpC6VcJX+h0K50ASg+mOaTo2AYI5DiJJWYgC2Igq5eYy8OJeNv
	 gluvoJAIgDkLYbVtaA9Pno56MHeaY/oRmDvzYjzuhiI6vgzVW5bHH2fM6TegKJ7UE2Lr+
	 suyxnC5SnEgj9I/dJzgH8lY1j1X/Qh67SB1swzuO3uCbzWOLGhCJNPJ65dW74A+YuSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=JuorWREu;
	arc=none smtp.remote-ip=209.85.160.169
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F2CF606A325
	for <linux-rdma@vger.kernel.org>; Fri, 20 Nov 2026 02:55:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5F2CF606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=JuorWREu
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-536717a4d83so3527381cf.2
        for <linux-rdma@vger.kernel.org>; Thu, 19 Nov 2026 18:55:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795143311; x=1795748111; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Rjhg0kwaD/wTpUnBxoXJn8jVRPigfkaeSmbsFggc+7k=;
        b=JuorWREuLl5FNO3te+6cIjPitDzDBIbPtyfeVNd8KLBi51kMuC3ztk7OY44XqKV2I+
         VLYGQfX+Nbj7E3ZcoRVB13yC8yjGxM4UVrLXoqkwVnpahRjK4ppu0/wC/9AWwDpmmGIK
         66KxBcnLuF4VJDVPHtA3N+h2H8HKBWIvMMyNKFxWm/2ETCPKQmr/gMNrjqlHaqq2LnQz
         PHuH0PKKyqndCP9ITzjafVc+u70bvGCQp1T6GixnL4MIndq9alftttlwMWsO8H3nFrJE
         zw6R5JU1hV1k1re17nA/Tcl1Y6O3IsidZtgNFLHqSodAXQqihZqIdcWgVTRGxohHo/TE
         uHeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795143311; x=1795748111;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Rjhg0kwaD/wTpUnBxoXJn8jVRPigfkaeSmbsFggc+7k=;
        b=z8UUWgwRC8id9zBwwWSnO7W+sfdXND591kmmnZRVNoCUm9t5yNIn8MMVMHjmFXgdmQ
         ace+OX+UH1xmbxn7Q+NFSsNwJDuN1HXvp411QEZg9n7fkEqGwN+g8tTZJEjQ8wqbCsDF
         PQy6uo3YG8H//n4J7hxGrgwjY08Jy5oq+gbXdn1h8iISStxU0sJ5sG6kAzlce6pjhFJa
         +j7kSLH6rifNmTvYkeYab7KrwR7V5BLguAO/XOD9s5K2kvUYArQ8Xv6dfzpX3GFWQbCh
         FdiPHy5QrfVXrzWmP3GE0TyWQ6Lk0/FFZw2vPqZxq4c7woINeS75NUx4Z8R7SIYhVUEQ
         pb3Q==
X-Forwarded-Encrypted: i=1; AL+hErGcLRD9sZruzmKzxemw7uToEq1llWhIcrhm5askCr8+ZnflkvNpoWP2GPPzMYIfQxEVxHcAhAxSMHWg@vger.kernel.org
X-Gm-Message-State: APuU4Z/v8eaqn/m98fQsa6/iNqbf6YA76rSDZojmrcOCB/cC4B2KyYoU
	Mq3uN+kePGXt/dDGWJY87iU+EOByD7A21V0ZO7ZLzZIZ5MxODjZYq2uv
X-Gm-Gg: AYBFou3s5xyFChJCScluSc+z3cg69v4RoWPXKZUhqnh9/fpchAIJG7c9RcoURATI6da
	epDpVygqb3VUqnw5GQ+EDou89cOUKuajxVT72C3bV0bfPzPRuyWRtVSAGn8yMJ/eauoPG4T59iQ
	1bGmDiNf9N/dccAIBjsrgNE6cO6vyC7wOr7D24XlO3aYEbxDDATrOSgrriEux11DdATcbRWWVJp
	T8jeLuEoR7UZVsKqimtZub5iibPSvlVeWyGNotDefm7bezgyfCkT4QObktk6vupDOYu6v15mfwA
	JhCbx0UgGyYJmqVBCxMNe2N+0lEIIDQJ70r+TLTRHO9E1LbybRLvdl0Gh7CJdSXXipN8IeBvDQO
	76IYktdpmqeldF9un2Et+MH/Sm2cdpHHIuylV+Eb1DQDD4O3GzxNgndarm+JHPVR89GNt52lrWS
	765PMw/v4DLVEE+GlnVv5GBCWwbHym7Qwc4fna63iiNj2skPb5PJIJYJ+vnMSGjeBnoOqQIhHK9
	XDgrEFtzk5XiLuS55q+OBTMWI37H4Xl8GI2v/TFx5fPeNlyJtw248LzpjFENPNvS7aZUCOPB57U
	qBrXnQi6bgCmCT4fIMAPXIlr8aHrGcNsgqzHT1+36BtgBy+NJMirN5CSDotEajbusZz09a4oM/M
	=
X-Received: by 2002:a05:622a:58b:b0:533:3192:7a8e with SMTP id d75a77b69052e-55d76a76454mr34189001cf.43.1795143311326;
        Thu, 19 Nov 2026 18:55:11 -0800 (PST)
Received: from linux.. ([8.34.174.240])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-921349b456csm14398686d6.13.2026.11.19.18.55.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 18:55:10 -0800 (PST)
From: Changyul Lee <lcy8047@gmail.com>
To: Saeed Mahameed <saeedm@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: Boris Pismenny <borisp@nvidia.com>,
	Jianbo Liu <jianbol@nvidia.com>,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Changyul Lee <lcy8047@gmail.com>
Subject: [PATCH net v2] net/mlx5e: IPsec, Fix RX mapped ID leak when adding a rule fails
Date: Thu, 19 Nov 2026 21:55:01 -0500
Message-ID: <20261120025501.1675212-1-lcy8047@gmail.com>
X-Mailer: git-send-email 2.43.0
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

In switchdev mode, rx_add_rule() calls
mlx5_esw_ipsec_rx_setup_modify_header(), which allocates a mapped ID for
the SA in ipsec->ipsec_obj_id_map. If a later step fails, the error path
frees the modify header but leaves the ID in the XArray, and
mlx5e_xfrm_add_state() then frees the SA entry. Each failed inbound
packet offload SA leaks one of the 2047 IDs. Once they are used up, no
new inbound SA can be offloaded until the IPsec context is cleaned up.

Release the ID on the error path under the same condition that maps it.
This label is reached only after the mapping succeeded and stored the
new ID in rx_mapped_id, so the copy that mlx5e_accel_ipsec_fs_modify()
passes in never loses the ID of the original SA.

Fixes: 91bafc638ed4 ("net/mlx5e: Handle IPsec offload for RX datapath in switchdev mode")
Signed-off-by: Changyul Lee <lcy8047@gmail.com>
---
Changes in v2:
 - Release the ID under the same condition that maps it, as suggested
   by Jianbo.

v1: https://lore.kernel.org/all/20261118051247.3885308-1-lcy8047@gmail.com/

Found with a static analysis tool we are developing.

Jianbo tested the same change on ConnectX-7 in switchdev mode with fault
injection on one RX SA add: 46 of the 2047 IDs were lost without the
fix, none with it:
https://lore.kernel.org/all/96a5ce67-89c8-4010-bfc4-4553e1aefe87@nvidia.com/

On our side it is compile-tested only, with x86_64_defconfig plus
MLX5_CORE_EN, MLX5_ESWITCH, MLX5_EN_IPSEC and W=1.

 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index 5c69e89b13a7..1f0ed8ab75d5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -2163,6 +2163,8 @@ static int rx_add_rule(struct mlx5e_ipsec_sa_entry *sa_entry)
 err_pkt_reformat:
 	if (flow_act.modify_hdr)
 		mlx5_modify_header_dealloc(mdev, flow_act.modify_hdr);
+	if (!attrs->drop && rx == ipsec->rx_esw)
+		mlx5_esw_ipsec_rx_id_mapping_remove(sa_entry);
 err_mod_header:
 	kvfree(spec);
 err_alloc:

base-commit: 2a324a58a084c5cfd7e5a2f55e0786bee170a4a5
-- 
2.43.0


Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792740843;
	b=tr6Ob2Zs7JVN4GW7yYvfO9/m2iUL+cBYOgRXcs5QIch60HqkQ8u5mVDjEWr577xL8XLB
	 gM2iUf6Vyj2mhbBez6SrOpXFT8wOYvf1pUPbyq6w+gc05tlZUwAnY+5YuhGbAqZLPqlhd
	 QWAcdB3WicKsbMPE+rng9y/cUUrTQy649ypX2CB/bRu69xkdoWfsE3Hvtkwncm5uIQTF9
	 0hWkLnpe4bQzteimXE+UXLxfgvj4qVu1mrOiRm98uCEeEIMqnl7ENg4HU7oYPvTVqn04j
	 Nzetc6vFCwVKER0a6FVIpvvUEIA5KtTQe2uSJ5zF61LkRxuFMjURQYUWrBvZAtqRYhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792740843;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=wePc/O0tHr8BHU6IBxL6zf+pKtKd8GbWsfcZZFn+Mdw=;
	b=31AtPywkvL1WlnkU7u+q5eDYdsLdzU1HZ6s+GE7T1W0Hs0pC35BM+JBj+vjbUscFEcE/
	 MKj+QppclfNF3k9HGMnN7K+RTj4EKtiMUauQnShCT2cX2zyywJkAOqLcghy7RGNjpcaET
	 kTA5vx4T3wX6pzwdXTH06IWfh1T1u7q3R1gTcMrkUVEoD9U3BUKLWZ70iqxCtokbcFlJE
	 NSkXzT1qcWUwOsEjvhdgKLGpQvHh9Q1qEmF5kuVSS+XPLQO79HXCHwlTTIgaPK734xpv5
	 rzexVjrJfFXhuywm1uB1BuGS0wE8QBByA9vM92BpxTzmCZa/mGVN2SxSVEzo46puboA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=aMgzEWvD;
	arc=none smtp.remote-ip=209.85.215.182
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5236606A326
	for <linux-rdma@vger.kernel.org>; Fri, 23 Oct 2026 07:34:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E5236606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=aMgzEWvD
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-cd6a7e1f4e4so244421a12.2
        for <linux-rdma@vger.kernel.org>; Fri, 23 Oct 2026 00:34:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792740842; x=1793345642; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=wePc/O0tHr8BHU6IBxL6zf+pKtKd8GbWsfcZZFn+Mdw=;
        b=aMgzEWvD2KbUmzBpjHhxSUbstZIzFhX83oWfEe1OnpyYqMs6Tr63ZFibCuUkdRF07X
         P7iTauibVzXFGDVIAHwFE0HhTD+UjT/stHetZ/Hzs7LT5oIgDzLR82l4f15uspK3qVn2
         RwqbmMSw3Qkfl8c3gs/Dm4ktlg9HoCYj8YDJxVnxCl1Yp1HdgqeW7DNsPInyqHMOMdAR
         UOd3UV3Y3S086YOeWRj8jHKtdBZn5WBu090h/1t+ZaOzFl2VgNp2tExzAv6ec3f3MtEp
         1d5KjYU+etdMf0v2EQywYTdlOBWaQL7BGiENDhRQEejd0GR7eKpnhYZpZ2BBObVZQR/x
         SpDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792740842; x=1793345642;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wePc/O0tHr8BHU6IBxL6zf+pKtKd8GbWsfcZZFn+Mdw=;
        b=2B9fAM9h7FgydCdIH/IkYxa19HC+2ZiM0UV9ZEvuccZ2ZaJ8V2y4wQqQvBb/C2pxqU
         iAUaKd8lZgoDSekqZD7kn/q1Avk+m4f8rXBQudg6nmQUSftEfz4PONHH9zAh/9SKh3Wj
         YQjxmN9U4qjmc5wOwCp/kCbj4DSbUUU+ThIN/0TA230dgGBO91Vo/9rX6PV7Tq1B/+0B
         l9JYPyDySe5BUkA8Vg9r1lS5V7TQxMmVxeaGgNQmPbzJCOdWtnMEdtwrRvGlXNYr7tSC
         si/6+RW6iAJg84OkmGnUWOJ77nJnoquqcVVzSLC//tV1qB8nqmkHyzaTTkNHAUXbHIEf
         88+g==
X-Gm-Message-State: AFq9FYJUlO52tVNq1eX9zBGs2loCyalZoibGGQdeWwnDcMt/NC6hdyu5
	8I1VC7Y3YwCTGr/m13LYzB7Y2LRUWiJrGCI0q/ihcIkNmiH+SHyqZfzL
X-Gm-Gg: AYBFou2Lzpq/CQi/pB+PWwHnPiyVz7jj6fnbNHQGt583v8ymI6Rlkszg/AKmFjKT1co
	yQhQTrpR4HDynRCnJDSer+/3Vpvh5iPH3LiDas3DB4dDiKJ87ZzakXJHVaO/2kG7ebVBKzR+Y0G
	brwQyboz+9VssIeT8jCedTiBB0n+aKEp+nBsZOT2iD4Lb/DLYTTECf9c8UbKFFSwoJoyAz4Osz5
	qEjOOSDQvNxnjDvQQoE/nQXFL19AQB27GipzgMx9Nz8giBZX1sa6/Vhw6iDSNzyQTpPa2vK+U89
	3juMNmXdyZvpRpREwbA1GIHK8jQAvF9nINNYIlxJzXbfV83ntTGYImwmy6wRIJPtJUuf/OqGmyZ
	QrKS6SQ8O94aoZRfW7R1cf8dfYQ0MOZFUt5IyqD52GRgEeimw8Dgg08xxCkc8RwukrRH9llupcO
	eP8CvHszcpzMtngRuGN6M2bjy1DIU/C5Fqzrc22gP3cbrBj0yUxmxXoTyPD9HIpDE2DmVj90iHg
	ZGKtfSrkrIkrG9bkvxrOBJARb+5vQ6R1dBKQe5pI7zHLU130+5E9if4UzDH1amRFwKYxzY/XGo=
X-Received: by 2002:a17:90b:35cd:b0:3a7:f4d:b23d with SMTP id 98e67ed59e1d1-3adce7c855amr1172820a91.52.1792740842077;
        Fri, 23 Oct 2026 00:34:02 -0700 (PDT)
Received: from spiderman.taila3fd8c.ts.net ([202.112.47.77])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3adcb1b256csm2298742a91.10.2026.10.23.00.33.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 00:34:00 -0700 (PDT)
From: Li Ximo <lixicaicai@gmail.com>
To: Nelson Escobar <neescoba@cisco.com>,
	Satish Kharat <satishkh@cisco.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wang Haoran <haoranwangsec@gmail.com>,
	Li Ximo <lixicaicai@gmail.com>
Subject: [PATCH] IB/usnic: fix wild pointer dereference in usnic_ib_qp_grp_dump_rows()
Date: Fri, 23 Oct 2026 15:33:49 +0800
Message-Id: <20261023073349.1287022-1-lixicaicai@gmail.com>
X-Mailer: git-send-email 2.25.1
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

From: Wang Haoran <haoranwangsec@gmail.com>

While auditing list_first_entry() users we found that
usnic_ib_qp_grp_dump_rows() calls list_first_entry() on
qp_grp->flows_lst without checking whether the list is empty.
list_first_entry() never returns NULL: on an empty list head->next ==
head, so container_of() yields a bogus non-NULL pointer derived from
the list head address. The function then dereferences it twice through
"default_flow->flow->flow_id", which reads a garbage pointer out of
the enclosing structure and dereferences that in turn, almost
certainly causing a kernel oops.

The empty-list state is reachable on a normal path: transitioning a QP
group to IB_QPS_RESET via usnic_ib_qp_grp_modify() calls
release_and_remove_all_flows(), which empties flows_lst, while
disable_qp_grp() only disables the hardware queues and does not
release the VNIC resources, so res->owner still points at the qp_grp.
A later usnic_ib_create_qp() on the same VF unconditionally dumps the
whole VF via usnic_ib_log_vf() -> usnic_vnic_dump(), which invokes
this callback for every res->owner != NULL - including the reset
qp_grp with an empty flows_lst. The existing "if (obj)" guard does not
help because obj (the qp_grp itself) is non-NULL; nothing checks the
flow list.

Fix it by switching to list_first_entry_or_null() and printing "N/A"
for the flow ID column when the qp_grp has no flow, mirroring the
existing all-"N/A" formatting used for a NULL obj. This was found by
code audit; we do not have Cisco usNIC hardware to reproduce it, but
the triggering sequence (create QP, modify to RESET, create another QP
on the same VF) is a plain libibverbs flow.

Reported-by: Wang Haoran <haoranwangsec@gmail.com>
Reported-by: Li Ximo <lixicaicai@gmail.com>
Signed-off-by: Wang Haoran <haoranwangsec@gmail.com>
---
 drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c b/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
index a7327c7a7..6f6aaea06 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
@@ -78,8 +78,17 @@ int usnic_ib_qp_grp_dump_rows(void *obj, char *buf, int buf_sz)
 	struct usnic_ib_qp_grp *qp_grp = obj;
 	struct usnic_ib_qp_grp_flow *default_flow;
 	if (obj) {
-		default_flow = list_first_entry(&qp_grp->flows_lst,
-					struct usnic_ib_qp_grp_flow, link);
+		default_flow = list_first_entry_or_null(&qp_grp->flows_lst,
+							struct usnic_ib_qp_grp_flow,
+							link);
+		if (!default_flow)
+			return scnprintf(buf, buf_sz,
+					"|%d\t|%s\t|%d\t|%hu\t|N/A",
+					qp_grp->ibqp.qp_num,
+					usnic_ib_qp_grp_state_to_string(
+							qp_grp->state),
+					qp_grp->owner_pid,
+					usnic_vnic_get_index(qp_grp->vf->vnic));
 		return scnprintf(buf, buf_sz, "|%d\t|%s\t|%d\t|%hu\t|%d",
 					qp_grp->ibqp.qp_num,
 					usnic_ib_qp_grp_state_to_string(
-- 
2.30.2


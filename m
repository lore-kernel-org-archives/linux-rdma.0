Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793165948;
	b=oLlPqJEUfOTkgxLXFZeeY2rwd2tuyTUVLw+0/TsGTDsxnnOVkgFH9Dy5EdvvUHTy20sT
	 qajzpdryKIzuilVH/hv7e+PBj7zzfSwCRvZ2hN2+UwHZICpDJPPrvsnLv8DWkwtJUxiHR
	 Q/eIxIIuvlgh7k4GCFEYjLsR9wueV2XdBbT9RwC9YqIcdNazIqcCOv7+xCaPdPvvWY59M
	 p5OnTjfyJYsQ4JeLMBIVUxGONpSqJ6mSfGqaKDmo6eUurjTR7CAxQOx/v0XbkvOKdKLaf
	 6QSMOvFFkAfoDP3yzTQZvnnZzmU+jdbzD0M4Gd1oEdq10vg5Fn3B80877gDppmZg+VQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793165948;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=+/9DI4ghtrUoPJ7/JxQAUc3C0bE7cOUVGnHSlKrNsLo=;
	b=h/WKVlMmNjWSW88U6ELSitaiayBhEClWeqFh0zPdifrPXfm2gFh+pOOUf8LKmhtG/G1g
	 hERjNx3JMzMtVSIZKIDjxJV6j1PBG26la5KRUVRTvU49IphvjwDEJ3IpAVSmqL15XkmQB
	 RJ9UPWYIqL3BXOm41uHDeq2LngJL9GCQ7rrfJyOXqC+1LfhRsVhOKb+hgYPgPk7seg+jB
	 9NDck60QOZvWXUmhRUzJxEBZQx8EHCrsA8V6fROuO5meRRUYSZsE4H7gx9IYtXynACCmI
	 TM87JtmSmKBXI76JUOwiSuhf8/chqoRi0OReiRjE/KzE8AcXk8JJB8AyxRttCWSdq6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=CHt77ZqI;
	arc=none smtp.remote-ip=209.85.222.170
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F920606A31A
	for <linux-rdma@vger.kernel.org>; Wed, 28 Oct 2026 05:39:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1F920606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=CHt77ZqI
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-93f3c89594cso34991785a.2
        for <linux-rdma@vger.kernel.org>; Tue, 27 Oct 2026 22:39:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793165947; x=1793770747; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=+/9DI4ghtrUoPJ7/JxQAUc3C0bE7cOUVGnHSlKrNsLo=;
        b=CHt77ZqIXKGtXe78zBpuAK6JNgcHAAqO0PYcQJ9q4Ah2ZCdyVRc1wZ9TcimrEUKpYd
         1kH7Hqy61+deaOxPNEEOhwxEqtWvgUtGXaN+FsxVGJGs9NRh+lZQb5HU3VI4JYj9Kqdw
         MWvRBmh/3DAnStFHZuenQ62Euf01ZnppjcfAVTXI/fahGGpjE7h3KAtEqtw8zEa/DEn0
         EHZLIbQ3IZnGcCBjKGm96r4Ue5H447Eo4oAtZXkz3Fdt91rbSnYDRvxMkEGNs5n2tIg/
         71jajOnAVnmZy1Aj585nTfKTLtm/TawJExoBhtnsmzAd6Cl9H/rTs493RvRXmTIx3/IX
         6jrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793165947; x=1793770747;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+/9DI4ghtrUoPJ7/JxQAUc3C0bE7cOUVGnHSlKrNsLo=;
        b=FlqdQ7HITioylioCZ6in4drFgeQjeYsR3HuKjvgTAVNuv2jJR/iTZBNGZJ0Gnt/qA7
         6wgIXuWwBaKcH5WAalWVqIAHMkkxmLWr2/qPWdLvEqpvFUXKt4CjkocsYx8GhUA1sMWU
         iRFOrf3zfxax5m5nDaMG2kR2LLFNHA07bZf8KTxLpAKJBH4aIlIUvLW4JYZcd8M6LzBl
         QDkwTaMBxd1WJ00nr4PhINjAfugcj58MNBnw8UFbxTHRV0Yr4maPZqGdAuSqebry2irj
         Qfrq6RzZgNNLGkGDMOr4vABrn846qWnadmzkE6mzekfDiNWP9GEav+pT06OdA8P1lPFi
         eQFQ==
X-Forwarded-Encrypted: i=1; AKwUvBzSguTx5QQ4zgtXdXDcrOXGAH0ht4vR02ZkezOtrxLxaMe8vLrAJ3AZ0SVMaWOE/ApRkqy2mtyWm92G@vger.kernel.org
X-Gm-Message-State: AFq9FYKyMaqdUMaFqWl20EzXfJ7OJ+oQoCyIwiht1vM5QV07SWiiHt9S
	gYthI4nXmIO1IWjZ+v+pdS4jpqFkfv9kwaL8mNPZF/6bAmDWzaEE6RCL
X-Gm-Gg: AYBFou0U2uoV2WqLCJ2EfHLLPRGe9xNVgczz9URj+0cuvtIL5w3JEiQCnlNIX3rM0YH
	5F/yVXdXnOSDtnFrvYYiy4nrdPXm04+L0WcKBhDtAox5Sy2IQWeaFWK1hgnRCkZVkRXQNtcLPIm
	5bJIKv7eK8x8Ri+FkV/ZmOkReKXPdCjRWLbupiohEqtDPkrKXr0RuMo0DyifUJEBC5o5bNKlYRb
	wlyGysWDA/Ek5JnZEzbt9DQ96t1cQ5AKrwdmKFlhfFxCVOMEz6z/eipmH1mTlo4SdKQd07nENPI
	3Gum5X6QhRDXwP+diOshaCo1sWx3p1uz7/mGX3QV6K3Mm5V/24TPqZ/+g/E6eBBni3lDCaXNOiB
	as+E4DGIkdjH02aDX0t5EovTvZMYX0Prqf+HTPQf8IHBs+Njy/QXbe5waUc/fY0lvQPXqcpzHzB
	xaDchQwVXOpaRJVmt/HVnqIG/Xp6I5ToHCRHTA8NbVgUiknXLoXaorHA2aobtzgis88No8VQhPS
	jCstnozr2GEMgpWmyzIY5cLsB64wgK+MPCuqLjU5Ir1W57yai6NabVzjrAGaFNspHfVrK/V67Lr
	BiyX7C4CJ+QfQVSUeqEOwskai0kPeY9nbGvyxibEpF+0XQta7qFF
X-Received: by 2002:a05:620a:3190:b0:93f:24e6:403e with SMTP id af79cd13be357-94408a96046mr167512085a.54.1793165946991;
        Tue, 27 Oct 2026 22:39:06 -0700 (PDT)
Received: from i4-gl-tmk5904.ad.psu.edu ([130.203.156.186])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-940f0a912d5sm1169781885a.40.2026.10.27.22.39.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 22:39:06 -0700 (PDT)
From: Yuho Choi <oss.patchbox@gmail.com>
To: Leon Romanovsky <leon@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	Yishai Hadas <yishaih@nvidia.com>,
	linux-rdma@vger.kernel.org
Subject: RDMA/mlx5: question about a failed destroy in the SRQ create error path
Date: Wed, 28 Oct 2026 01:38:57 -0400
Message-ID: <20261028053903.209809-2-oss.patchbox@gmail.com>
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

Hi Leon,

I have a question about the error path of mlx5_ib_create_srq() (rdma
for-next, c3e8e9451e6f) and would appreciate your view. When copying
the response to user space fails, the result of the destroy is not
checked:

	err_core:
		mlx5_cmd_destroy_srq(dev, &srq->msrq);

	err_usr_kern_srq:
		if (udata)
			destroy_srq_user(ib_srq->pd, srq, udata);

If I read it correctly, a failed destroy here would leave the firmware
SRQ using the SRQ buffer and doorbell record that are then released.
Since fd89099d635e ("RDMA/mlx5: Issue FW command to destroy SRQ on
reentry") the SRQ would also be back in dev->srq_table after the core
frees the ib_srq, so SRQ events and ODP page faults (odp_get_rsc())
could find freed memory.

Thanks for explaining in [1] that DESTROY of kernel-owned objects does
not fail on working firmware. I wondered whether user SRQs might be
different, since they carry the uid of their context and a DEVX QP of
the same uid can use them, which 43d781b9fa56 ("RDMA: Allow fail of
destroy CQ") mentions as a reason for destroy to fail. For example,
could user space create such a DEVX QP on the new SRQ number (probing
for it) while the response copy is held up, say on a FUSE-backed
buffer, and then let the copy fail? I could not tell from the tree
whether the firmware would refuse the destroy in that case, so I may
well be missing something.

If this is a real problem, would something like the untested diff below
be acceptable? It keeps the memory and drops the table entry, at the
cost of leaking the SRQ. If you prefer, such SRQs could instead be kept
on the ucontext and destroyed again from mlx5_ib_dealloc_ucontext(),
which avoids the leak.

This was found with a static analysis tool from ongoing, not yet
published research, and confirmed by code inspection. It has not been
reproduced, and I used an LLM to help with the analysis and this mail.

[1] https://lore.kernel.org/r/20261016045849.813696-6-oss.patchbox@gmail.com

Thanks,
Yuho

diff --git a/drivers/infiniband/hw/mlx5/srq.c b/drivers/infiniband/hw/mlx5/srq.c
index 6a4a937d97ce..96ea15ba0487 100644
--- a/drivers/infiniband/hw/mlx5/srq.c
+++ b/drivers/infiniband/hw/mlx5/srq.c
@@ -310,7 +310,15 @@ int mlx5_ib_create_srq(struct ib_srq *ib_srq,
 	return 0;

 err_core:
-	mlx5_cmd_destroy_srq(dev, &srq->msrq);
+	/*
+	 * Only user SRQs get here. If a DEVX object still uses the SRQ, the
+	 * firmware may refuse to destroy it; leak the buffer and doorbell
+	 * record rather than free pages the device can still access.
+	 */
+	if (mlx5_cmd_destroy_srq(dev, &srq->msrq)) {
+		mlx5_cmd_untrack_srq(dev, &srq->msrq);
+		return err;
+	}

 err_usr_kern_srq:
 	if (udata)
diff --git a/drivers/infiniband/hw/mlx5/srq.h b/drivers/infiniband/hw/mlx5/srq.h
index a7e3dc5564ac..4cd63e8d8579 100644
--- a/drivers/infiniband/hw/mlx5/srq.h
+++ b/drivers/infiniband/hw/mlx5/srq.h
@@ -58,6 +58,7 @@ struct mlx5_srq_table {
 int mlx5_cmd_create_srq(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
 			struct mlx5_srq_attr *in);
 int mlx5_cmd_destroy_srq(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq);
+void mlx5_cmd_untrack_srq(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq);
 int mlx5_cmd_query_srq(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
 		       struct mlx5_srq_attr *out);
 int mlx5_cmd_arm_srq(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
diff --git a/drivers/infiniband/hw/mlx5/srq_cmd.c b/drivers/infiniband/hw/mlx5/srq_cmd.c
index c1a088120915..c97e22946ef3 100644
--- a/drivers/infiniband/hw/mlx5/srq_cmd.c
+++ b/drivers/infiniband/hw/mlx5/srq_cmd.c
@@ -697,6 +697,22 @@ int mlx5_cmd_destroy_srq(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq)
 	return 0;
 }

+/*
+ * For an SRQ whose destroy failed in the error flow of its creation: the
+ * firmware object stays, but the caller is about to free @srq, which
+ * mlx5_cmd_destroy_srq() put back into the table. Remove it and wait for
+ * concurrent lookups to drop their references.
+ */
+void mlx5_cmd_untrack_srq(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq)
+{
+	struct mlx5_srq_table *table = &dev->srq_table;
+
+	xa_cmpxchg_irq(&table->array, srq->srqn, srq, NULL, 0);
+
+	mlx5_core_res_put(&srq->common);
+	wait_for_completion(&srq->common.free);
+}
+
 int mlx5_cmd_query_srq(struct mlx5_ib_dev *dev, struct mlx5_core_srq *srq,
 		       struct mlx5_srq_attr *out)
 {

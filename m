Received: from mail-oo2-f0.google.com (mail-oo2-f0.google.com [74.125.231.128])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A38C3A3E73
	for <linux-rdma@vger.kernel.org>; Thu,  8 Oct 2026 16:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.128
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791477538; cv=none; b=fPgdywzU/wjbUAAB/lLTl96FGCBo1rM15Jvk7YdHunmQ1h/6RIbA4Q+1imGSkFhRv+l8RgWUIAozYJhp3Y26QqceCqxhY8HLbZzLpw9QPPQNeUZKj0VfoAuWL5R06sCpjLXpJbc4WQyzdwiL7hrnyO7saujBN+eqKN7cTCN6WM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791477538; c=relaxed/simple;
	bh=B7/RTXGw6xEkN4S3aF0mbacVGPs2NY7fb3eIo7Z50+k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GD8d1CFTlu4vLRRBveas2matYnZ/u5m71M7n7mXnztjTMVO4RjAwFcMBSEY6zrpbq1Thv1wWBTR2deNav6dL9jAkAxxd5cP9pXutcfrKypDxYMT8B+GDRfFqgD84BCTKu9gwKz+ZAJpkr2ZjwPh3yHzvKYUx51plNYLZVrDN9Mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bd12I3zl; arc=none smtp.client-ip=74.125.231.128
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bd12I3zl"
Received: by mail-oo2-f0.google.com with SMTP id 006d021491bc7-6a3900cb2b5so3090637eaf.0
        for <linux-rdma@vger.kernel.org>; Thu, 08 Oct 2026 09:38:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791477536; x=1792082336; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=wcr1e3DelCZYM4o9phxk5vNklRMQLSyAKhNB5dBEr6o=;
        b=bd12I3zlGqyad1SU1bgON32oKdVg4UULWAImb6h+3sJnng3qlhcbkplvxvAkvuk4wy
         n7fxfP1/TRsOZqH/+7c4BzFXKjP7Yl7k4wliFAro8W/8j4Ze7RHGVoEkYBB+dVGXF17n
         BLwdE4Shb1LzlCR1TKekFl1fF25eYKIUcJFPEhPfUDv/lqxm7tqe0kvYFFRxCB3Vdm0l
         QJtS3AU2q4FwEkuhBWyr8qSG119ifKefVvF7EDPdv+EHNIvbwuPN5hTqBlZdsCX3IlcQ
         U1+KL5Z7GdhuL5BUi6Xnz65klnYNoncYECenOGTtbQSbSnh62anWF8f9bUzli/prkDxi
         dWeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791477536; x=1792082336;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wcr1e3DelCZYM4o9phxk5vNklRMQLSyAKhNB5dBEr6o=;
        b=JJnING6xtePpKc2VgabqL7JLZby/qvg6rtD7s4K+3lFkKDPya3hXAz0Yd23BzBgovl
         LF3KtWSSJj4BDQVAtaJ+CLGetYt4J8FUrg/bp+FIsd3coIxbCsfbR6Gn7yYG/v+7kMch
         lm3uTIApKpXGYADUIhadJ/CKiEB9sfuViPeUA40Y/kiJ6cyw+zmdEYHAHV0cQvNMIh5w
         wMnpzDVC4YuW15o4Wn/UF8EeAfNpHh5piKad7uRB6CL/DsMSkmf4qCuA4UnyBC59g9h0
         +HgUVOONRoQT7dVTIpiCUpKZzfVUVMub+0ubxCI4gcxzI7BBc676dIWkGgF8fuWHk5DK
         hUDw==
X-Forwarded-Encrypted: i=1; AKwUvBxXu9u871G4KYyvaxkrmXIvksyTNQtg0Jka6uO7wXDWVp2Pcmv2MUEdEt1atXk2iRAdRlY4RhEA9ONr@vger.kernel.org
X-Gm-Message-State: AFuF++lVodSLFYaylPpJqhi7eeg4z0EyiJVtARnIRNR59GdMlLxQO1qn
	ojmbVXPxKFynT0ekiumqZWAsZKnCQ7T8hUQtr4u93HRKpkIa+X+2A47a
X-Gm-Gg: AYBFou0TlaFfy1U1NmQX2Quta+dFZSEbyCxj/yazYyf3ryJKV2VIZZV4ngJpNPJ6S1j
	qs8xEuXtHXxSgFSZObcROYzhopQjhNZdYMJSVl7EQpvJBKiuu0uimNvfRe2DsJwG7om087kU/RP
	rpVD2C0HAYeq+yF27M9FBCSoYbB5ML4GG1OeHTjo63xm/6WodflRdXsVD2L/fWMdfW2Un4+HQiU
	BRYXYFh9eRwzr6UlOyg8ESwWvt+v5hq5C5kZEMw0WwMXrdozueqZZm3amaY+hLpsM17ejImrR7I
	AcrVwx9RdHZ+ldfCN/2n4VneOeNqYhzaijm7IrOCyQ8pnP/E4UW1xc5BnPR/pwAOdNG/3HLwfvl
	JNrwfWEgaWpLtI3zelcloJe9aQJgCeW5b5RdMUHHUHYBEuTQSFiC5GMQY2LPPRG7B/ljlNXR9ok
	XMEDbT1EBjzIHgmlWaXbc+rRrWRnNNYxIvAHeUxZwe0s6g1STO5Gq0Lp6cqwavjnow09KzUYlza
	a5xyBa9yF/BzDcYLq7YzzGBjX7lo1G6Agtr
X-Received: by 2002:a05:6820:1628:b0:6d7:a13d:fd7d with SMTP id 006d021491bc7-6e7a727cb87mr5941490eaf.53.1791477535895;
        Thu, 08 Oct 2026 09:38:55 -0700 (PDT)
Received: from localhost.localdomain ([14.22.11.164])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-82fc7cc8ad4sm64328a34.7.2026.10.08.09.38.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 09:38:55 -0700 (PDT)
From: Henry Martin <bsdhenrymartin@gmail.com>
To: Allison Henderson <achender@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>
Cc: netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Henry Martin <bsdhenrymartin@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] rds: fix out-of-bounds conn_path access via handshake NPATHS
Date: Fri,  9 Oct 2026 00:38:43 +0800
Message-ID: <20261008163843.957325-1-bsdhenrymartin@gmail.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Connections on the IB transport (t_mp_capable unset) own exactly one
rds_conn_path slot, but the peer can still claim eight lanes through
the NPATHS extension header of a handshake packet, and every
subsequent fan-out path then treats all eight entries as real: the
mp-start helper iterates conn->c_path[0..7], dereferencing cp->cp_conn,
taking cp->cp_lock and queueing delayed work on cp->cp_wq at 504-byte
strides into whatever comes after the single allocated slot (KASAN:
"Read of size 8 in rds_conn_path_connect_if_down").

The negotiated lane count is now clamped to the same value the
transport was allocated with (trans->t_mp_capable ?
RDS_MPATH_WORKERS : 1), so a peer can never ask us to walk lanes that
do not exist.

This vulnerability was discovered by Tencent CodeBuddy Security.

Cc: stable@vger.kernel.org
Fixes: ba3d1f480c7a ("net/rds: size a connection's path set by the transport it ends up with")
Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
---
 net/rds/recv.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/rds/recv.c
+++ b/net/rds/recv.c
@@ -224,7 +224,8 @@
 		/* Process extension header here */
 		switch (type) {
 		case RDS_EXTHDR_NPATHS:
-			new_npaths = min_t(int, RDS_MPATH_WORKERS,
+			new_npaths = min_t(int, conn->c_trans->t_mp_capable ?
+					   RDS_MPATH_WORKERS : 1,
 					   be16_to_cpu(buffer.rds_npaths));
 			break;
 		case RDS_EXTHDR_GEN_NUM:
--
2.43.7

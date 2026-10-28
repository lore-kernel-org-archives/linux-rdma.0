Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.225
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793168015;
	b=wlBhs0sKQPw8oxhsdSBbq4t+Bgiz3ZJ9VmvlmPN9WJ61bO9mfvKt53+kU03qKx2unPxA
	 d7KpVYutZqfbTuuyR7r++uXNCW82etabHLfX2JDBR7TlooC6doSjyvb7dz/WYHi9LJ7Tl
	 Rm9bzqHwsOfPxsw0LQiFbgqQ0RITw6ubGoz/+s+kA0i8b7iVYM8zSdEVCCmEK4gUGznSl
	 w9SZ8KxssmoiyjkW0jz8w6BufpGVYWrp2T2zULCUdCr5K8rQT178GCVwPQDDRahoH8vdm
	 TN66wCPJTYJBycZ5LlDhg2iz4a3AsMIPK0duqwSkgmjn55a2MrEqUkKO7ah/niqf0pg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793168015;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 X-Gm-Gg:X-Received:Received:X-Relaying-Domain:X-CFilter-Loop:Received:
	 DKIM-Signature:X-Received:X-Received:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-DetectorID-Processed;
	bh=lJV2lgYUwqWDOsbagk4uH4gEnYxkjc29oZxcBkNQbe8=;
	b=ld5LyZyE4TjYif2S9dlLE8TeiMsS9gJpZCT/IcBiFBdCCrD/G+3WRWWh31B+r+wjp/nk
	 EWRdSN0p8lViPoRnjw2TIzCdKbLweJpw0gEUQ+YkfsoCidezaobImiEFwUJFVQ2MyDQ8W
	 UHEeIUkAE28XXBCp92+pXkMp7I2JV2pZQM+5VhUSxF3Vf7a0M/Yxv/1vh0VnL90AmTinV
	 tZXmGZPxLFqKCFi+DV7cKrbSMmT8in/yxlS5wXovf9YgpyJh+q5sTYtdJYQZnFS1u/tzH
	 hw6FtNQbkRhIbYdnyND6kzrGAkf+t+F2a7oZrrldg1dK21DyFgrx4AiNPLH0mkwt7og==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=Qx+bNCxL;
	arc=none smtp.remote-ip=209.85.210.225
Received: from mail-pf1-f225.google.com (mail-pf1-f225.google.com [209.85.210.225])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21D5F606A31A
	for <linux-rdma@vger.kernel.org>; Wed, 28 Oct 2026 06:13:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 21D5F606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=Qx+bNCxL
Received: by mail-pf1-f225.google.com with SMTP id d2e1a72fcca58-8a05b210703so293407b3a.0
        for <linux-rdma@vger.kernel.org>; Tue, 27 Oct 2026 23:13:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793168014; x=1793772814;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lJV2lgYUwqWDOsbagk4uH4gEnYxkjc29oZxcBkNQbe8=;
        b=l1mSpQDN4n4TFAKa60wtow2clA48UVMJw87fm0OutyaWapWvRv9RXeiDeX9T5TWRK5
         5EXzXTn6Ia6U3YbtN24XJwkqlJkV3y9Bf2AzoejC/G3SDqu7IEvCb8iOF/L6TNHXC/wv
         cEdAQa3Np4TFlNqDG7H6LegqbqjCMg3rWF+k3wJ0uStaD9sp+sKULAxLC0bQpCbSmvuD
         HImBwg33oSj+IwpWnEQIZHJwMYdg4HFZfjJg94yrn7GXkcwHRFwT7zKoQQ7FxTa3Z/Hl
         AkVxEExsR/5K5GFf0qMOh2YgB0n0av/jozdQN1OuAHx0hZovJDnE/Atr5g5oEA0ldOEC
         9wdQ==
X-Gm-Message-State: AFq9FYK/vMnd0+q75sPMwrxlIvRyzngHmxsZ7riDGGoOXSwo32tvqhZl
	mZRjE+sqS98vGgiX2psLbpJr9GTAnXG4N1OVhlhor0xk3W4iCxxyGG2V58yv6wJVLHUeyKspEgZ
	bHFQNZZhwQz55abPat0O8Xi5zTfaL3ggqxCtNMAqqaThNMHjgoY0WdeQfbAZ91zH+4Z8anJHwHO
	AxNl5oGPBtp4L1zvxoSnZY06x+aZczYoStHF31m+4CmUfwvBbofp+Zhj5CtsOwQaX816s52a7NR
	K3ZLWhnpf1reMsTMw==
X-Gm-Gg: AYBFou0M7PYfceip//rlt/4ZrEVAx1r9ibEn3DvvSRExO82+am7oM5DMLNiSierjV3a
	9kXn+Eh8qEMHlg14MINCSrGeK2cW9jQAJ8Zg64zregeTyLtBwGjWVntwJDibI0VaeDAfPiBzDpa
	OqlFaoju9wR8myhOa7NAoUPnSKFXNMQnvQTjpz6yFSF9D+qYwK0OFPWA4vO9o51dd3CjShOsDea
	p2U8Tdx6dQgtgUiN+Ovdr2rk8e1Ldc+fYxiBIdu0FzRjZVI/JkyB0g70MXGn2Uf8HpKIDsFXECQ
	O+OTHDjixgekWcDstBLNfuuBnJTsygCocrlp7UvF0XFl27hwxd6O6CaNf2nVR0epHB/9Yc+jBL6
	L15GOmruqfpClrGyNzk5AT/+kbxenE2dHwUo7sgl+F0QO6HREf8zbzhRFBQ2Z3WIiizXKoJ0td9
	SNL0P56shu0KQECpxq5AGdoBVf8/pHWN49dTuM
X-Received: by 2002:a05:6a20:d4b:b0:3e2:af00:d0e5 with SMTP id adf61e73a8af0-3e902347b82mr1108249637.44.1793168014411;
        Tue, 27 Oct 2026 23:13:34 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-28.dlp.protect.broadcom.com. [144.49.247.28])
        by smtp-relay.gmail.com with ESMTPS id 41be03b00d2f7-cd8cccce3d6sm159570a12.22.2026.10.27.23.13.34
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Oct 2026 23:13:34 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-8a073778890so611072b3a.1
        for <linux-rdma@vger.kernel.org>; Tue, 27 Oct 2026 23:13:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793168013; x=1793772813; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lJV2lgYUwqWDOsbagk4uH4gEnYxkjc29oZxcBkNQbe8=;
        b=Qx+bNCxLf4K3Www312TCwKV+uW9tjw3iU25FLB89QUyoeL5gAry4ATfoaKdGADi+ud
         GFy7goXMTqIR3a+mUIwpw75rztopFya36Kxm7gux2QbfksMAMOIzNVQoh2q75Vl1KFBW
         ZmArOrq5Ul+7o2OlQ/SgECj0PQsqUlfOkGxMk=
X-Received: by 2002:a05:6a00:3493:b0:8a0:2344:c44b with SMTP id d2e1a72fcca58-8a6e8b8347fmr1050671b3a.40.1793168012741;
        Tue, 27 Oct 2026 23:13:32 -0700 (PDT)
X-Received: by 2002:a05:6a00:3493:b0:8a0:2344:c44b with SMTP id d2e1a72fcca58-8a6e8b8347fmr1050658b3a.40.1793168012289;
        Tue, 27 Oct 2026 23:13:32 -0700 (PDT)
Received: from dhcp-10-123-156-114.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a75cf8fab6sm171717b3a.13.2026.10.27.23.13.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 23:13:31 -0700 (PDT)
From: Selvin Xavier <selvin.xavier@broadcom.com>
To: leon@kernel.org,
	jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org,
	andrew.gospodarek@broadcom.com,
	kalesh-anakkur.purayil@broadcom.com,
	Saravanan Vajravel <saravanan.vajravel@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>
Subject: [PATCH for-rc 4/7] RDMA/bnxt_re: Drop RCFW completions for cookies with no outstanding command
Date: Wed, 28 Oct 2026 04:34:01 -0700
Message-Id: <20261028113404.33289-5-selvin.xavier@broadcom.com>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20261028113404.33289-1-selvin.xavier@broadcom.com>
References: <20261028113404.33289-1-selvin.xavier@broadcom.com>
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
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

From: Saravanan Vajravel <saravanan.vajravel@broadcom.com>

A duplicate CREQ completion for an idle cookie slot is processed as a
command response. It can decrement timeout_send a second time and, for
CREATE_AH, send a spurious DESTROY_AH. Log and drop such completions.

Fixes: 691eb7c6110f ("RDMA/bnxt_re: handle command completions after driver detect a timedout")
Signed-off-by: Saravanan Vajravel <saravanan.vajravel@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
---
 drivers/infiniband/hw/bnxt_re/qplib_rcfw.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
index da6c7779ff87..7278e85a8a40 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_rcfw.c
@@ -718,6 +718,14 @@ static int bnxt_qplib_process_qp_event(struct bnxt_qplib_rcfw *rcfw,
 			return rc;
 		}
 
+		if (!crsqe->is_in_used) {
+			dev_warn_ratelimited(&pdev->dev,
+					     "event %#x for cookie %#x with no outstanding command\n",
+					     qp_event->event, cookie);
+			spin_unlock(&hwq->lock);
+			return rc;
+		}
+
 		if (crsqe->is_internal_cmd && !qp_event->status)
 			atomic_dec(&rcfw->timeout_send);
 
-- 
2.39.3


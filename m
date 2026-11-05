Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.227
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793869875;
	b=qIDxW7l/bIKnVDxNikEfB0+2S5/oY83FNAsRwNdMnpbmQXHRd5JJcnFtSWaT2UNFwpKG
	 AuBlYbc8/H599lmpV8+68GF/4gD0p1FifjCrlyhu2grLecsKt2tM25d5iuDD4GXpKPSVO
	 KBedBriaBYrmbAFqa+NM2TLMnYPIbpCT9/AFtyAk17G0ti0qZpSdhBgVBr5ALWH4aEHed
	 nEhZ5Lx4/EKqjMTV/PPQz6WGysArPCw9d3FrjLHnauSqY8DgrGbKCNA9M0XXuDh3IwYCO
	 CKhgvOPK8GKEw+kAnEv7F0HVc0V626aPnkO3LnJpK0m4qrJAJyWgCB1Rpb6dfJSoN9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793869875;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:X-Relaying-Domain:
	 X-CFilter-Loop:Received:DKIM-Signature:X-Forwarded-Encrypted:
	 X-Received:X-Received:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-DetectorID-Processed;
	bh=hE16CvVTuGg8PBhy5lWSCBxfK0aglpjCX03ajlgSRSI=;
	b=JDOITLu0H2ru3OhhPOyY2dK4MpgyTBTJOjLEht6wtSsBwnCMI6qBfL6qviR+aWz25/h/
	 sufCvoFM2hvQcccveagM7DJKRsoWDpvVQAR2dXQxWBbVYnWYZ0FYIiGG1FYdaz1m2DaQ6
	 H0gf3HBrMm3S3y6k4F0kKwwg+Oj4Ay8RA4pVsRzPcb702PAoaIU94Fv/LIdHqW2w6mQKe
	 MWGGJaw7TVP9bxRi3VZKRsZKW1Kp0IKmo/yiuelojdXPeTzxydhyEn7IfOmFIkygp6CHQ
	 4fzBMwK03RXmx7kSa/qOI4kc4at1niqkePQPOahzKbNHQrqSmll7XXQnzcBD+X7mpKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=g+FGur3n;
	arc=none smtp.remote-ip=209.85.160.227
Received: from mail-qt1-f227.google.com (mail-qt1-f227.google.com [209.85.160.227])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24098606A32E
	for <linux-rdma@vger.kernel.org>; Thu,  5 Nov 2026 09:11:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 24098606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=g+FGur3n
Received: by mail-qt1-f227.google.com with SMTP id d75a77b69052e-5363c8de563so16802861cf.0
        for <linux-rdma@vger.kernel.org>; Thu, 05 Nov 2026 01:11:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793869874; x=1794474674;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hE16CvVTuGg8PBhy5lWSCBxfK0aglpjCX03ajlgSRSI=;
        b=YHxa3hiA3+Mt7vndCcBDdYnrN9mBhyIUnRUQhythxjHPl6edw/f++vu8AVAgAn0scB
         FZdiHO3nJ90SANdmItPioQ5Wl9BoEC6ton+RVHR1+WMprmJ82zxKjI2i6VXQkjJgeTgz
         KAwWeYzQythCDSOs+ek6dlTEKFcVW7/I95LfQB0e6boOweEnOZZ3bMYtGfVTdNCWXdYK
         EBCh2L0tchTpFcBWusuapOjZwQxG2aH1jPxfNCM+Pypx8orGCyJ+fgPh5DSetav8ctf9
         oE+5Nx4NKVJL5EfsyGQTTLvWwuz6iPdDPGi9sbjgv26hVDspRfZcHbeaY3DwBGePPDIx
         mUNA==
X-Forwarded-Encrypted: i=1; AKwUvBwfe6HZDSfx0RQ5WKLpd8IYWR+PDswzhw7AR36ixL8NVDC9DhyE/mE3Jb2i1CLH4EuGYjSDlWJK28d7@vger.kernel.org
X-Gm-Message-State: APuU4Z9r0AE/rjb0MOG2Jf5KtvxXdShmX/LEV/uDG6Nx08qsrJql8aXy
	hvQfICzVgM3xPuo+rW9K09J/Rg5EwULr+UEjrsdtGfWh0C8g17OCkKWPmaSoHkYjo/6XR4kJ7Zr
	KYdxp/gWhCPGUdr63l+R8WkQjsMXUDKGJJ7NTRq6yYjxD1p6o/iZolpBSQ6rQfjD68C1y05FPz/
	vfPmgZQJx0B5g4jhJr+fT0OvBoN1FIEDZfK/tvR/8A0mFpolSs9Yaddm/XbKZ76XBHBsrZ+ekWR
	EaK8YWfe+yqLgB9Qg==
X-Gm-Gg: AYBFou3Rkpoe3NfS2mDRyuSvhOG2ChnE0eacPZf9WUF48XSpFQvzfAb4FXUp6NMD36a
	TFNe/S+ZzV2FVs8jypR7sSPq5GKT8qinuuw+htB9QdukyXdB5JX34LuBwMqHC6V4kz1toB5i+sg
	SlyzeJy9n7uA7V6I0/x0205gBJaLsMd/TgkLG3QtjamkNdmJHUZI4OrrRKpGqcui4u6YZZwa1ED
	nmNFb4hqlMsmr7SNSwdrQYg62VRtNPpIMIMv1q6e7WwNgkAKh1Kg6HJ4+AtzYKmi9f8IuU348Tt
	Dmu83NwA+SVNmfhH+99R853csWy+kAerGBHKMVFNMDCpyl/yLkT/LbM9rSgfXcOJ3yRITa+iB9n
	lp81wLuCAgXjOdC8bey+eKliE4PJIZbpCzou9dK1iHTnfF/hk6EK1TlPyvb5OrRKP5n7XUOi6Ua
	hHyNP8hn6vJmDqZ9SC25QuGkok8+AHXT5dqQ==
X-Received: by 2002:a05:620a:688d:b0:93f:3e39:efa1 with SMTP id af79cd13be357-9442161743amr3139338485a.23.1793869873973;
        Thu, 05 Nov 2026 01:11:13 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-13.dlp.protect.broadcom.com. [144.49.247.13])
        by smtp-relay.gmail.com with ESMTPS id af79cd13be357-945d477e91fsm59304585a.9.2026.11.05.01.11.12
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Nov 2026 01:11:13 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-5351f1b26e6so26306621cf.2
        for <linux-rdma@vger.kernel.org>; Thu, 05 Nov 2026 01:11:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793869872; x=1794474672; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hE16CvVTuGg8PBhy5lWSCBxfK0aglpjCX03ajlgSRSI=;
        b=g+FGur3nQFqnCBb7kM3xzZ/Wt2sPFEeW0ySvQ2NEbygDsk+X5a9bo60mzeI0aLapUr
         vItvFVFLg2bseGspLeQrkeX5X2Ozt5j00/ygc2soTuqZleYpmSOVNonlXufG/W63494k
         lEjtUgoKbitmlqLELlkcZiIyu51ZuH2KnDcMQ=
X-Forwarded-Encrypted: i=1; AKwUvBwwKIu7lIN6SsKzoX81Dn6Lg9eXVU9vJ0NYTWYzZWX5WoT4XwN7hezY9FYkdLp3atO+YPvPMAJTsh60@vger.kernel.org
X-Received: by 2002:ac8:5a16:0:b0:536:600e:843d with SMTP id d75a77b69052e-542b781b1fcmr291258671cf.50.1793869872015;
        Thu, 05 Nov 2026 01:11:12 -0800 (PST)
X-Received: by 2002:ac8:5a16:0:b0:536:600e:843d with SMTP id d75a77b69052e-542b781b1fcmr291258471cf.50.1793869871409;
        Thu, 05 Nov 2026 01:11:11 -0800 (PST)
Received: from mgmt5.dhcp.broadcom.net ([192.19.222.250])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-54b100af507sm47298591cf.6.2026.11.05.01.11.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 01:11:10 -0800 (PST)
From: Siva Reddy Kallam <siva.kallam@broadcom.com>
To: leonro@nvidia.com,
	jgg@nvidia.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	andrew+netdev@lunn.ch,
	horms@kernel.org
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	vikas.gupta@broadcom.com,
	ajit.khaparde@broadcom.com,
	dharmender.garg@broadcom.com,
	sachin.holla@broadcom.com,
	Saswati Das <saswati.das@broadcom.com>,
	Siva Reddy Kallam <siva.kallam@broadcom.com>
Subject: [net-next v3 2/3] bnge: Update HSI
Date: Thu,  5 Nov 2026 01:01:53 -0800
Message-ID: <20261105090154.1293846-3-siva.kallam@broadcom.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20261105090154.1293846-1-siva.kallam@broadcom.com>
References: <20261105090154.1293846-1-siva.kallam@broadcom.com>
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

From: Saswati Das <saswati.das@broadcom.com>

Add support for 64-bit doorbells and Mid Path Channel (MPC) firmware
commands/completions.

Signed-off-by: Saswati Das <saswati.das@broadcom.com>
Signed-off-by: Siva Reddy Kallam <siva.kallam@broadcom.com>
Reviewed-by: Dharmender Garg <dharmender.garg@broadcom.com>
Reviewed-by: Vikas Gupta <vikas.gupta@broadcom.com>
---
 include/linux/bnge/hsi.h | 161 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 161 insertions(+)

diff --git a/include/linux/bnge/hsi.h b/include/linux/bnge/hsi.h
index d4fe662d60b1..834db3991691 100644
--- a/include/linux/bnge/hsi.h
+++ b/include/linux/bnge/hsi.h
@@ -12644,6 +12644,43 @@ struct dbc_dbc {
 	#define DBC_DBC_TYPE_LAST          DBC_DBC_TYPE_NULL
 };
 
+/* dbc_dbc64 (size:64b/8B) */
+struct dbc_dbc64 {
+	__le64	dbc;
+	#define DBC_DBC64_INDEX_MASK        0xffffffUL
+	#define DBC_DBC64_INDEX_SFT         0
+	#define DBC_DBC64_EPOCH             0x1000000UL
+	#define DBC_DBC64_TOGGLE_MASK       0x6000000UL
+	#define DBC_DBC64_TOGGLE_SFT        25
+	#define DBC_DBC64_XID_MASK          0xfffff00000000ULL
+	#define DBC_DBC64_XID_SFT           32
+	#define DBC_DBC64_PATH_MASK         0x300000000000000ULL
+	#define DBC_DBC64_PATH_SFT          56
+	#define DBC_DBC64_PATH_ROCE           (0x0ULL << 56)
+	#define DBC_DBC64_PATH_L2             (0x1ULL << 56)
+	#define DBC_DBC64_PATH_ENGINE         (0x2ULL << 56)
+	#define DBC_DBC64_PATH_LAST          DBC_DBC64_PATH_ENGINE
+	#define DBC_DBC64_VALID             0x400000000000000ULL
+	#define DBC_DBC64_DEBUG_TRACE       0x800000000000000ULL
+	#define DBC_DBC64_TYPE_MASK         0xf000000000000000ULL
+	#define DBC_DBC64_TYPE_SFT          60
+	#define DBC_DBC64_TYPE_SQ             (0x0ULL << 60)
+	#define DBC_DBC64_TYPE_RQ             (0x1ULL << 60)
+	#define DBC_DBC64_TYPE_SRQ            (0x2ULL << 60)
+	#define DBC_DBC64_TYPE_SRQ_ARM        (0x3ULL << 60)
+	#define DBC_DBC64_TYPE_CQ             (0x4ULL << 60)
+	#define DBC_DBC64_TYPE_CQ_ARMSE       (0x5ULL << 60)
+	#define DBC_DBC64_TYPE_CQ_ARMALL      (0x6ULL << 60)
+	#define DBC_DBC64_TYPE_CQ_ARMENA      (0x7ULL << 60)
+	#define DBC_DBC64_TYPE_SRQ_ARMENA     (0x8ULL << 60)
+	#define DBC_DBC64_TYPE_CQ_CUTOFF_ACK  (0x9ULL << 60)
+	#define DBC_DBC64_TYPE_NQ             (0xaULL << 60)
+	#define DBC_DBC64_TYPE_NQ_ARM         (0xbULL << 60)
+	#define DBC_DBC64_TYPE_NQ_MASK        (0xeULL << 60)
+	#define DBC_DBC64_TYPE_NULL           (0xfULL << 60)
+	#define DBC_DBC64_TYPE_LAST          DBC_DBC64_TYPE_NULL
+};
+
 /* db_push_start (size:64b/8B) */
 struct db_push_start {
 	u64	db;
@@ -12739,4 +12776,128 @@ struct hcomm_status {
 
 #define HCOMM_STATUS_STRUCT_LOC 0x31001F0UL
 
+/* MPC macros */
+#define MPC_CMD_HDR_REQ_TYPE_ICA   0x1UL
+#define MPC_CMD_HDR_REQ_TYPE_RCA   0x2UL
+#define MPC_CMD_HDR_REQ_TYPE_PFVF  0x3UL
+#define MPC_CMD_HDR_REQ_TYPE_EVENT 0x4UL
+#define MPC_CMD_HDR_REQ_TYPE_LAST MPC_CMD_HDR_REQ_TYPE_EVENT
+
+#define MPC_CMD_HDR_REQ_SUB_TYPE_ICA_SA_ENABLE                  0x0UL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_ICA_SM_PSP_SA_INIT             0x1UL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_ICA_SM_PSP_NEW_RX_ASSOC        0x2UL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_ICA_SM_PSP_KEY_ROTATE          0x3UL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_ICA_CM_PSP_SA_INIT             0x4UL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_ICA_CM_PSP_KEY_ROTATE          0x5UL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_ICA_CM_PSP_KEY_SET             0x6UL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_ICA_SA_INFO_GET                0x7UL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_ICA_SA_STATS_GET               0x8UL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_ICA_SA_STATS_CLEAR             0x9UL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_ICA_SA_RX_MATCH_RULE_SET       0xaUL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_ICA_SM_PSP_SA_SET              0xbUL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_RCA_QP_MODIFY                  0x0UL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_RCA_AH_MODIFY                  0x1UL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_RCA_QP_MODIFY_CMPL             0x2UL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_RCA_AH_MODIFY_CMPL             0x3UL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_RCA_QP_MODIFY_BATCH            0x4UL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_RCA_AH_MODIFY_BATCH            0x5UL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_RCA_QP_MODIFY_BATCH_CMPL       0x6UL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_RCA_AH_MODIFY_BATCH_CMPL       0x7UL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_RCA_MPC_TEST_CMD               0xc8UL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_RCA_MPC_TEST_CMPL              0xc9UL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_EVENT_RESP_CMPL                0x0UL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_PFVF_QP_CREATE                 0x0UL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_PFVF_AH_CREATE                 0x1UL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_PFVF_QP_MODIFY                 0x2UL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_PFVF_AH_MODIFY                 0x3UL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_PFVF_QP_DESTROY                0x4UL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_PFVF_AH_DESTROY                0x5UL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_PFVF_QP_CREATE_CMPL            0xaUL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_PFVF_AH_CREATE_CMPL            0xbUL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_PFVF_QP_MODIFY_CMPL            0xcUL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_PFVF_AH_MODIFY_CMPL            0xdUL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_PFVF_QP_DESTROY_CMPL           0xeUL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_PFVF_AH_DESTROY_CMPL           0xfUL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_PFVF_QP_CREATE_FWD_REQ         0x14UL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_PFVF_AH_CREATE_FWD_REQ         0x15UL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_PFVF_QP_MODIFY_FWD_REQ         0x16UL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_PFVF_AH_MODIFY_FWD_REQ         0x17UL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_PFVF_QP_DESTROY_FWD_REQ        0x18UL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_PFVF_AH_DESTROY_FWD_REQ        0x19UL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_PFVF_QP_CREATE_FWD_RESP        0x1eUL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_PFVF_AH_CREATE_FWD_RESP        0x1fUL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_PFVF_QP_MODIFY_FWD_RESP        0x20UL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_PFVF_AH_MODIFY_FWD_RESP        0x21UL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_PFVF_QP_DESTROY_FWD_RESP       0x22UL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_PFVF_AH_DESTROY_FWD_RESP       0x23UL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_PFVF_ALL_FWD_RESP_CMPL         0x28UL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_PFVF_QP_CREATE_BATCH           0x32UL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_PFVF_AH_CREATE_BATCH           0x33UL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_PFVF_QP_MODIFY_BATCH           0x34UL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_PFVF_AH_MODIFY_BATCH           0x35UL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_PFVF_QP_DESTROY_BATCH          0x36UL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_PFVF_AH_DESTROY_BATCH          0x37UL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_PFVF_QP_CREATE_BATCH_CMPL      0x3cUL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_PFVF_AH_CREATE_BATCH_CMPL      0x3dUL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_PFVF_QP_MODIFY_BATCH_CMPL      0x3eUL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_PFVF_AH_MODIFY_BATCH_CMPL      0x3fUL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_PFVF_QP_DESTROY_BATCH_CMPL     0x40UL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_PFVF_AH_DESTROY_BATCH_CMPL     0x41UL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_PFVF_QP_CREATE_BATCH_FWD_REQ   0x46UL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_PFVF_AH_CREATE_BATCH_FWD_REQ   0x47UL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_PFVF_QP_MODIFY_BATCH_FWD_REQ   0x48UL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_PFVF_AH_MODIFY_BATCH_FWD_REQ   0x49UL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_PFVF_QP_DESTROY_BATCH_FWD_REQ  0x4aUL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_PFVF_AH_DESTROY_BATCH_FWD_REQ  0x4bUL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_PFVF_QP_CREATE_BATCH_FWD_RESP  0x50UL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_PFVF_AH_CREATE_BATCH_FWD_RESP  0x51UL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_PFVF_QP_MODIFY_BATCH_FWD_RESP  0x52UL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_PFVF_AH_MODIFY_BATCH_FWD_RESP  0x53UL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_PFVF_QP_DESTROY_BATCH_FWD_RESP 0x54UL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_PFVF_AH_DESTROY_BATCH_FWD_RESP 0x55UL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_PFVF_ALL_BATCH_FWD_RESP_CMPL   0x5aUL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_PFVF_DRV_RGTR                  0x64UL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_PFVF_DRV_RGTR_CMPL             0x65UL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_PFVF_DRV_UNRGTR                0x66UL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_PFVF_DRV_UNRGTR_CMPL           0x67UL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_PFVF_BUF_RGTR                  0x68UL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_PFVF_BUF_RGTR_CMPL             0x69UL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_PFVF_BUF_UNRGTR                0x6aUL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_PFVF_BUF_UNRGTR_CMPL           0x6bUL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_PFVF_MPC_TEST_CMD              0xcaUL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_PFVF_MPC_TEST_CMPL             0xcbUL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_PFVF_MPC_TEST_FWD_CMD          0xccUL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_PFVF_MPC_TEST_FWD_CMPL         0xcdUL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_PFVF_MPC_TEST_FWD_REQ          0xceUL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_PFVF_MPC_TEST_FWD_RESP         0xcfUL
+#define MPC_CMD_HDR_REQ_SUB_TYPE_LAST    MPC_CMD_HDR_REQ_SUB_TYPE_PFVF_MPC_TEST_FWD_RESP
+
+#define MPC_CMPL_HDR_ERROR_CODE_ICA_ERR_NONE                   0x0UL
+#define MPC_CMPL_HDR_ERROR_CODE_ICA_ERR_BAD_TARGET_ID          0x1UL
+#define MPC_CMPL_HDR_ERROR_CODE_ICA_ERR_SA_NOT_INIT_ENABLED    0x2UL
+#define MPC_CMPL_HDR_ERROR_CODE_ICA_ERR_HW_CMD_FAILED          0x3UL
+#define MPC_CMPL_HDR_ERROR_CODE_ICA_ERR_BAD_PSP_MODE           0x4UL
+#define MPC_CMPL_HDR_ERROR_CODE_ICA_ERR_BAD_SPI                0x5UL
+#define MPC_CMPL_HDR_ERROR_CODE_ICA_ERR_SPI_THRESHOLD_BREACHED 0x6UL
+#define MPC_CMPL_HDR_ERROR_CODE_ICA_ERR_ACTIVE_QPS_EXIST       0x7UL
+#define MPC_CMPL_HDR_ERROR_CODE_LAST     MPC_CMPL_HDR_ERROR_CODE_ICA_ERR_ACTIVE_QPS_EXIST
+
+/* mpc_cmpl_hdr (size:64b/8B) */
+struct mpc_cmpl_hdr {
+	u8	cmpl_type_reserved;
+	#define CMPL_TYPE_RESERVED_CMPL_TYPE_MASK         0x3fUL
+	#define CMPL_TYPE_RESERVED_CMPL_TYPE_SFT          0
+	#define CMPL_TYPE_RESERVED_CMPL_TYPE_MPC_CMP_SHORT  0x1eUL
+	#define CMPL_TYPE_RESERVED_CMPL_TYPE_MPC_CMP_LONG   0x1fUL
+	#define CMPL_TYPE_RESERVED_CMPL_TYPE_LAST          CMPL_TYPE_RESERVED_CMPL_TYPE_MPC_CMP_LONG
+	u8	error_code_mp_client;
+	#define ERROR_CODE_MP_CLIENT_ERROR_CODE_MASK 0xfUL
+	#define ERROR_CODE_MP_CLIENT_ERROR_CODE_SFT 0
+	#define ERROR_CODE_MP_CLIENT_MP_CLIENT_MASK 0xf0UL
+	#define ERROR_CODE_MP_CLIENT_MP_CLIENT_SFT  4
+	u8	req_type;
+	u8	req_subtype;
+	__le32	opaque;
+};
+
 #endif /* _BNGE_HSI_H_ */
-- 
2.43.5


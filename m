Received: from mail-pj1-f97.google.com (mail-pj1-f97.google.com [209.85.216.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23D91463B7C
	for <linux-rdma@vger.kernel.org>; Tue,  6 Oct 2026 16:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791303830; cv=none; b=GtEub/jGi8fuVaUa9qAsnmre7fyL96ZOxM8CHhWRZOkJNLzwzlx8p/B57Xw50Be8ygQUt1ZH80MTfYagRUJTsVMXr1m/evtX1V9SOVMCe2O2TZ9sHuY+l5mEXdL/7qcLNLKLHwQUnOq7LRDIomDhGlTsxp9n5zNqGYu7kVLx/Zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791303830; c=relaxed/simple;
	bh=5QSdoeQyOeaQ2nPRgt43kjsQrDVLF6Qe5SQ77InDBk8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NWx1I1wnsjY5H0bY/Mlm1o4TUdkZ4SF3iDXteRJ3S8D/FWgpYZiIoy1OJnEBSPjce2IhXIifFCDkBlPOLQBY5dLUeHDPs3COBBC7xWwQdWugYjceSGez8h9o0JUwdLSiDC3Pl1sJ0YbwVwN+ZunpKFk2kqyKK3AzKsfNZsuHb20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=UU59djDT; arc=none smtp.client-ip=209.85.216.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="UU59djDT"
Received: by mail-pj1-f97.google.com with SMTP id 98e67ed59e1d1-3a4a7eb86a4so826933a91.3
        for <linux-rdma@vger.kernel.org>; Tue, 06 Oct 2026 09:23:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791303826; x=1791908626;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=NjN0Qep3AXtJMLugfSyEYf4+Yl9Dz3rPxAXCvJ82fTM=;
        b=nm0qq61bf/DveJhR103noevP+xiNh7chfgxofDrzaX8wPLV+D+pGNqt5gyaNT7tO2F
         n7DmrjjDPoExtYpUNccHJoHyYQ1pnA7V2I6netU6BQtjN7uLDmDaEhDrSayCZsUSlme8
         5uXoUfIHk9qSKrtYycTnowRUkWqqhtP8j9eujS1OGztpwUPyrtmYiEWTYq6LD8AYJhAh
         N8Qtmvd9yqI6kSaEy4Zz1dZE5JojDRKHNTFVs4qEdymTxD+8HBt3launDUbR15gZLSb9
         IZ7nke9c4MPf944Cdv5A/qHKG4oE6QiDXdsNFQABfCV7TRd3PUQtgyD4QC7Fhz5i6r75
         xuqA==
X-Forwarded-Encrypted: i=1; AKwUvBwfT7wp4CjmhSPe+O1VqhVWWZk556FJ64UT6WXUb+XzpuN5dxd7bOKvj5yzfMsuj82wVv2RVanYTAON@vger.kernel.org
X-Gm-Message-State: AFq9FYKJpit0Z3nKqcftMJMpTHS09f2zuTJPXwKcb3AJ5tWxdFoZUSFB
	BT0/emXLlZ/fbAxxk0iZhPCzPnZrW0XKFjaDc8E2tp1BXj71D4VPSV7z4yp3BOLpCeYpGPjOr0f
	bVAzPiXe4s5PnKqfmU0wV+zws/mcwCX5WDQWFp8SPl+7fu0UZeMWIh7hZRJYrnWt1vAOeANkFMQ
	3fRF8uGlWSfJsKxyiaPfvjyhgDp3+sBGvLg5UW7YSLoztldX80rk6X0acCP0lv4QwOuQZMgiQU/
	4rAWANuePnS8Jxn4g==
X-Gm-Gg: AYBFou1LbXV8F75dR9WNgS9HFSLuNOWfTh4OwaYQo24Z5CKnr5UcnmTqd0033EBbpwf
	Ee8V5c426d5dI9N/t07ydbdbUgkUl+JbiTRVDZ0jI/CaLSZDI4VYu7gpEjzwdFHFYCz8Ml78d+N
	Lu4Wk9JEBWQaDLyuLFJjWGfTn5oSa9TSScih0ixR37giGqz9CBm1enE6D+/KBJblhU5ZHm6/L42
	SvWmPko1667pBulJoZ9HUOi7W+Mi38/y7rH7/wJANuZ1W974Jv5XBy2S+N6pB4jPDDDDQIK27x/
	0cZr0lwhC7dMQFk7xsEnBzXpD1A4YhdDic4s75wnjX5+7bqo9DdR3oBc4tbBdN+TpVOevcVF1+0
	fTglUW0Bi4j/6tB8NVFXV+oPp4o2imG/NgXGwKw4HSFLF/C3lDAG+vyd+Sjo9qxkHqvH1/wYUkU
	PAzCSy5AD6g4Lc1lrPRH9a3jyTQnT3KvkAgQ==
X-Received: by 2002:a17:90b:394a:b0:3a2:a576:f67a with SMTP id 98e67ed59e1d1-3a87379dcd7mr1413627a91.52.1791303824186;
        Tue, 06 Oct 2026 09:23:44 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-25.dlp.protect.broadcom.com. [144.49.247.25])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3a8533a7471sm1348896a91.2.2026.10.06.09.23.43
        for <linux-rdma@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Oct 2026 09:23:44 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-91235881828so69482986d6.3
        for <linux-rdma@vger.kernel.org>; Tue, 06 Oct 2026 09:23:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1791303823; x=1791908623; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=NjN0Qep3AXtJMLugfSyEYf4+Yl9Dz3rPxAXCvJ82fTM=;
        b=UU59djDTh/Zey9jHPkk/KqObwIZSvgL7zr9tIIameDAUmGZm3/5aLURs9wqDVz5r2+
         ilSYhEqkdkiFxrnps16E+mFSCMXmIGa4v7Y/f9tRGsGhzpPoUGgS7oOLrC7jwt7snd9K
         syYS1D5iBtxh7svWwn7Iq6aWRgR2Qo26lIJmU=
X-Forwarded-Encrypted: i=1; AKwUvBwCf+silnKH8CgMdEs/D9jZVluNagZoOVhrmMmKvLeDRgs26iLFPHflWCVPmZ7ES6FwohdLxaubEpyF@vger.kernel.org
X-Received: by 2002:a05:622a:1826:b0:535:70b3:3527 with SMTP id d75a77b69052e-53570b337ddmr6046031cf.62.1791303823002;
        Tue, 06 Oct 2026 09:23:43 -0700 (PDT)
X-Received: by 2002:a05:622a:1826:b0:535:70b3:3527 with SMTP id d75a77b69052e-53570b337ddmr6045491cf.62.1791303822485;
        Tue, 06 Oct 2026 09:23:42 -0700 (PDT)
Received: from mgmt5.dhcp.broadcom.net ([192.19.222.250])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5356b860df8sm9020961cf.14.2026.10.06.09.23.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 09:23:41 -0700 (PDT)
From: Siva Reddy Kallam <siva.kallam@broadcom.com>
To: leonro@nvidia.com,
	jgg@nvidia.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	andrew+netdev@lunn.ch,
	horms@kernel.org
Cc: vikas.gupta@broadcom.com,
	ajit.khaparde@broadcom.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	Siva Reddy Kallam <siva.kallam@broadcom.com>
Subject: [net-next v2 0/3] bnge changes for RoCE driver
Date: Tue,  6 Oct 2026 09:12:53 -0700
Message-ID: <20261006161256.1493672-1-siva.kallam@broadcom.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

Add bnge specific changes needed for RoCE MPC channel
support.

v1->v2:
- Created pull request for RoCE MPC channel changes
  of bnge driver 
- Addressed Shasiko review comments

The following are changes since
commit 2c3418fffa9d ("Merge tag 'keys-v7.3-rc7' of
git://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-tpmdd")
   Merge tag 'for_linus' in Linus's tree
and are available in the git repository at:
  https://github.com/siva-kallam/linux bnge-roce-v2
for you to fetch changes up to
commit 4f4b78c1e577 ("bnge: reserve TX/completion rings for the
RoCE MPC channel")

Sachin Holla (1):
  bnge: reserve TX/completion rings for the RoCE MPC channel

Saswati Das (2):
  bnge: Add infrastructure support for RoCE MPC channels
  bnge: Update HSI

 .../net/ethernet/broadcom/bnge/bnge_auxr.c    |   1 +
 .../net/ethernet/broadcom/bnge/bnge_auxr.h    |   1 +
 .../net/ethernet/broadcom/bnge/bnge_resc.c    |  32 +++-
 include/linux/bnge/hsi.h                      | 161 ++++++++++++++++++
 4 files changed, 191 insertions(+), 4 deletions(-)

-- 
2.43.5


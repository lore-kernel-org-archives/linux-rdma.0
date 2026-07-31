Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74AD42367D3
	for <linux-rdma@vger.kernel.org>; Fri, 31 Jul 2026 09:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785489218; cv=none; b=QaxseCgScy+pmAw1m/LtMe7oVFJq+BUf7CAM7Agv9wCVxv0ZM8l5TmbuuF/gamUnHicT8cynObo2zwrka5GNsQd3yP0rXgWhmQrDpyig3WPGBpQY58oiqkjlHo27BQ2OpoAxKwRabLrs/lhQPBaDa2wJpEfqf7OOyVEh4zi4bd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785489218; c=relaxed/simple;
	bh=+NIRmw+EKbK+C/67hZT+XMnvAkhfviRa9JF+k3Wsq2A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tes/b+4DYVRM7WO9murRL8kZuGGnwAqqXXa1I/plq7SLcsL0UcRUmQkb+Yzx9Q7zvKnU2OidisEp8oupunp8vZGmsC2kiF2hXf7tPJSCgsxkWnIarPnXsWOfN4dGaNqCTYZvzZFDziBraPOC6PoPQvKV1InszLzUh5IBYfEkZRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us; spf=none smtp.mailfrom=resnulli.us; dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b=m4cNQoWd; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20251104.gappssmtp.com header.i=@resnulli-us.20251104.gappssmtp.com header.b="m4cNQoWd"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c1c4db7ca93so87616066b.2
        for <linux-rdma@vger.kernel.org>; Fri, 31 Jul 2026 02:13:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20251104.gappssmtp.com; s=20251104; t=1785489211; x=1786094011; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ixlcJKoD+2rBCgJQC9TfZEyIjtmgFBJAR9UpSQq2apc=;
        b=m4cNQoWdrpGSaeUmePC/YRcfKWZzxbrvKl3+5VaVSH1hwaU3G56RVlxZh4ojhGl5bi
         MjdWmmYiw/8ZxNxGli3n6OOWfrAsntqh/KCP2u8EEw2WJqAhRFNKGOeMwi+M86uUCfqS
         7mSInbEXAI/7WNdEUNu1WUsV6bDep5vjLNwb9DxiE4ZhmZF5+UWTBG8FTX5adFNVFZot
         f9ILY14Oc1afcuWeJU13YI4cYPoUOCJM84WMZaJMsPjusdWc6/zRBdih/iVkvcjAB49X
         EvCWMW12zVvJoSlaaDepMmFF5MXQUUpzdHRpjEyAKyM3ZG47OfCB2WBiQH0lqI1sFVSd
         BdIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785489211; x=1786094011;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ixlcJKoD+2rBCgJQC9TfZEyIjtmgFBJAR9UpSQq2apc=;
        b=fx631yJUBney73+mbMdTAGiduPTC1SscQENnlH2kXBNFnkH/C0fsUN1zcIrs03knrN
         pRI0pL/UXx+QomC0hb3Iq5c0GqTW2NVwj8S1pj23lmY4hwAWSBnh5uxiDIjsiTxXQQwx
         K8990xWyMh5zVxb/blSO4bsHVqTobl5dx2zIMLV0/wRAXNbfiusw9VYlrEGJWaJ/iV10
         xMqNWQzc++mrexPwCwjEeqr2JDNSWW3VBmP0WkjHG1vMP597uOSqf8vPjUk54Y0uOUtE
         a95apuvbC/MZr/BjMQCtqZXn6UzMDdBIzcbqWnO6zypBih8V+kZN50ocymsE2rzbZXv2
         xjsw==
X-Gm-Message-State: AOJu0YyhjOD5FUmB644Ud/5tA6PdkTluU2JHNXvROezEpVsNxneKL2sJ
	0T+X9GpqbTMsPOdKGbYt9h7lMP6+5FundgDs1p5pLCxMMY+BQgkJCd1Hg4eZQGNxMrbkWNCbuqS
	EHio8
X-Gm-Gg: AR+sD121J42wcLM6kxvYOc1L3kdBcvq94Cy24WKo2N1aLZi+ziBlFAi/YrJw7I6MnBr
	aJkdcO2794fRN3JwAhRhVhthz6vIshv3iueiEqsKE4S6sFCdEjrsHIu7cg8k3pjWkhsK8aWjeEX
	6l4U/Ch7thTIcIHzA+13C1/u+CNl6psKIcRdWo246qFB8z07Rpanzo1Ckrttiwv3ykRyeXz2TZe
	/jPZm6s+sTWu+EB9ZbEZbNxJRo2fu8k2guVWgPbkBejMV2fi801Beb6Ih55wAGTIEsQa5l0MrHH
	J+Wj1Rti4bgHoyFGpDd+MSD5YsCyoD54GpDPFJVEUHSTJ6gJclPePAkEA031hFYgpXqdQFIWQgF
	pSLuYMrC74um7UgmajbeG+c8QRJ+SeOsKrSONRabcrRvHabjwNWrGLzzsqD9/02InzgWeK+CxgW
	0ukq/xUeOwPeZobvT6TdJc6giwgC3FD/781N7FlxWbXlScANz9+1OfdGfsNQcTbyfq72oYtQ==
X-Received: by 2002:a17:907:c241:b0:c16:2d90:68a7 with SMTP id a640c23a62f3a-c1fd2002d3fmr74364066b.26.1785489211210;
        Fri, 31 Jul 2026 02:13:31 -0700 (PDT)
Received: from localhost ([140.209.217.211])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1fd3c5b608sm78307866b.8.2026.07.31.02.13.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 02:13:30 -0700 (PDT)
From: Jiri Pirko <jiri@resnulli.us>
To: linux-rdma@vger.kernel.org
Cc: jgg@ziepe.ca,
	leon@kernel.org,
	kotaranov@microsoft.com,
	longli@microsoft.com,
	linux-hyperv@vger.kernel.org
Subject: [PATCH rdma-next] RDMA/mana_ib: Retain create CQ flags field name
Date: Fri, 31 Jul 2026 11:10:41 +0200
Message-ID: <20260731091041.2250897-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jiri Pirko <jiri@nvidia.com>

Commit eb70d83a8645 ("RDMA/mana_ib: Adopt robust udata") renamed the
"flags" field of struct mana_ib_create_cq to "comp_mask", as
ib_copy_validate_udata_in_cm() only validates a member with that name.

The layout did not change, but the field has been a part of the UAPI
since commit 44b607ad4cdf ("RDMA/mana_ib: implement uapi for creation
of rnic cq"), so the rename breaks userspace referring to it,
for example the mana provider of rdma-core assigning cmd_drv->flags.

Convert the field to a union providing both names, so that
ib_copy_validate_udata_in_cm() still finds "comp_mask" and userspace
keeps "flags", without having to add a helper for this single case.

Fixes: eb70d83a8645 ("RDMA/mana_ib: Adopt robust udata")
Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 include/uapi/rdma/mana-abi.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/uapi/rdma/mana-abi.h b/include/uapi/rdma/mana-abi.h
index 410f0ddc8c89..431c7076f20a 100644
--- a/include/uapi/rdma/mana-abi.h
+++ b/include/uapi/rdma/mana-abi.h
@@ -25,7 +25,10 @@ enum mana_ib_create_cq_flags {
 
 struct mana_ib_create_cq {
 	__aligned_u64 buf_addr;
-	__u16	comp_mask;
+	union {
+		__u16	comp_mask;
+		__u16	flags; /* the original name of the field */
+	};
 	__u16	reserved0;
 	__u32	reserved1;
 };
-- 
2.54.0


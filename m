Received: from mail-wr2-f9.google.com (mail-wr2-f9.google.com [74.125.225.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2F2249B45A
	for <linux-rdma@vger.kernel.org>; Fri,  9 Oct 2026 13:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791551856; cv=none; b=aSjLFNJFqu4p4Yo68Ize3YHBJxd43CNA/RE+Uh2H6bu79/pLO3/SPB/9bLPw+CvBYayo6XCt9DAlsaz10ihyzGKf2wBAzU1p6JvNH5xr6zScfrKBwpIhx+MbnsQkhDp6OQYWMFvtP1PR/e29gX962kEkfUWF/uwp+vgQGOoTZOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791551856; c=relaxed/simple;
	bh=xqbuFg+8iN+2Dyk01REJqG13xwBPoq3m834weQ9pQ3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iMUk/l4Zj4RNU8djBurDkSIZEppKLViZHTKbwL1mpuH31QEKkVb85rjYT/C4ooT8iK42psWqrUk8yDyH+QM7p+f1ANLbVCc11LYn41zXQAdWLs1w00gkFEKgGPqoUtuZxkPIFpX5Q46U1kxNWSiBniTpPNHPBfaiPSlHwkAKNbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KjVaA7ud; arc=none smtp.client-ip=74.125.225.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KjVaA7ud"
Received: by mail-wr2-f9.google.com with SMTP id ffacd0b85a97d-48afbc2b18bso2542310f8f.0
        for <linux-rdma@vger.kernel.org>; Fri, 09 Oct 2026 06:17:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791551854; x=1792156654; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=+64FNEEi48NFXXTTwHRUHjafgwGY27f3h1TjpTMjEG8=;
        b=KjVaA7udXItsSQgWtgRHSe12cjpL7dui8JzuwZ+AxL0IoTvo3jSeIdvLcYj4k7bAUG
         wUrJPRrnu/6R3NnHk0WqzaiNh++CrNtn0qi+dz0VuzRQ9+g1ilpJ3n7JDPCrRBizhZcZ
         RVgkTkAL+wJCe1QTRNw/ruXOB6dkq6RfAm44/jHzH6j24jsIylXg6kAEB9LHwxvOfVa2
         Oo80aJmBDyN0t0KkP2F91Nid3gwPkEm3NnZcU378R+5Xtio2vDwM4otxeTVUu9jqdeNN
         IXrTsVg1BgEl911gEBnDJnJ12HywGJwuVhFV25WEj7yml9yK5PZ9TmCaGpIyLUyfc2Nn
         Pb1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791551854; x=1792156654;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+64FNEEi48NFXXTTwHRUHjafgwGY27f3h1TjpTMjEG8=;
        b=Oj9Opu4Z/CN7Xph/aAJT8mQK10eNbYQ3KpN+qBgt9iGiOghQdgAfiHIGSL8hTG4iRw
         J3Vo8dhDp54zvnLcVL93PUkLNipMFZXdx8JEk3Qdhq6zBqqFK1j8vTCpzdyXp6ulMzwh
         W31k01EhFbslqLQIhDZ/dby++n0MjpvHVlavYBgpTpGnNbYGSr8v8Eor+cMeQFoVWib9
         5N0kydrUs+yTceMp9SyB1CYmbYQDymKh42NFG2eDckuX0lQiYfzUGLT1GHvHT1BB/Iuf
         2jscXAW6KVhwDldd7gwBdbiUyGHh5ppzHEuMDALfbwExIh36tNY5GAXjKKo8ttvXUw8M
         gGZA==
X-Forwarded-Encrypted: i=1; AKwUvBxWxC9doC3vXUr+DA5en8O0zhdwOMhDjJcCK3EoUOrjFA2FvEIcIAuGNdhLqIEgFX+6/1JlRdjnHig6@vger.kernel.org
X-Gm-Message-State: AFq9FYImt+cxNmpB60NwBc2sYHnFCvVAaAZAIkzRD4mYqaFTD3K6XJUQ
	WHKV6L4xVo7iwQjKFpuJABtYBW3pdku9iy0fir2PHtb5pWHXFeRVNKDD
X-Gm-Gg: AYBFou09FyihOJqwNlHop0/Q1a7SfzOI6XiRRse7aAHZ+FtpwZoxYhnJUphqxjPfZx0
	gsUzDdySdOTsqgw1/qpIxlAYgy3SJriKTUcA6EQX/mUt3DKQ8R1YiLe85pxm7aPDpVnzdibYTpQ
	dACJoEeU/DfJ70aLCuWGVJq+IUhlp4+TOi2hMaTJMZvaw2omw/u7L0ph0AyBwZPYrMdDGCQ5DKA
	QnHzA7ZGZ1mSToqiiOHMDBiClKJgaGtJ9nDt51sEc8uYNuQWtyQSMa8b7MdYRXApIprrAHiT/nc
	eGWNrNjTiiPXXJHAKA8RxdcoaCqxvbduO9PhPz0drA9ruazoWSO1zNyWDZnMjrCRRH6cwJvP9nr
	H5r/atajgeMoKb3vdvrz1cgDIAdzuxqJmJ9HpXb2SHSErH8NqCAC0Q7xa1FPwXm2QDMEePX3Ou9
	mQhdKHA4XgQqKS70bbEzD0q9cXyECqXFL+T30fJMKcMMQVoCQhIRIJhf2dAzhzA2ATJN4YEyMdt
	8DY+QELj9Euxg==
X-Received: by 2002:a05:6000:46da:b0:48b:1276:72e7 with SMTP id ffacd0b85a97d-48dba9db139mr2786462f8f.13.1791551853651;
        Fri, 09 Oct 2026 06:17:33 -0700 (PDT)
Received: from serhat-ubuntu.home ([212.253.205.12])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48db94e2f08sm3997138f8f.15.2026.10.09.06.17.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2026 06:17:33 -0700 (PDT)
From: Serhat Kumral <serhatkumral1@gmail.com>
To: haris.iqbal@ionos.com,
	jinpu.wang@ionos.com
Cc: jgg@ziepe.ca,
	leon@kernel.org,
	danil.kipnis@cloud.ionos.com,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Serhat Kumral <serhatkumral1@gmail.com>
Subject: [PATCH] RDMA/rtrs: Use strscpy() to cache the HCA name
Date: Fri,  9 Oct 2026 16:17:15 +0300
Message-ID: <20261009131715.39217-1-serhatkumral1@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As the comment states, the HCA name is cached for sysfs. Use
strscpy() to copy it directly without unnecessary formatting and
avoid interpreting format specifiers in the name.

Fixes: 6a98d71daea1 ("RDMA/rtrs: client: main functionality")
Signed-off-by: Serhat Kumral <serhatkumral1@gmail.com>
---
found by smatch:
- drivers/infiniband/ulp/rtrs/rtrs-clt.c:1906 rtrs_rdma_conn_established() warn: call of 'scnprintf' with non-constant format argument

 drivers/infiniband/ulp/rtrs/rtrs-clt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
index 927e3f30483c..c85e22f670ba 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
@@ -1918,8 +1918,8 @@ static int rtrs_rdma_conn_established(struct rtrs_clt_con *con,
 		 * Cache the hca_port and hca_name for sysfs
 		 */
 		clt_path->hca_port = con->c.cm_id->port_num;
-		scnprintf(clt_path->hca_name, sizeof(clt_path->hca_name),
-			  clt_path->s.dev->ib_dev->name);
+		strscpy(clt_path->hca_name, clt_path->s.dev->ib_dev->name,
+			sizeof(clt_path->hca_name));
 		clt_path->s.src_addr = con->c.cm_id->route.addr.src_addr;
 		/* set for_new_clt, to allow future reconnect on any path */
 		clt_path->for_new_clt = 1;
-- 
2.53.0


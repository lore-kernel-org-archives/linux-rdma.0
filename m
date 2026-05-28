Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4935636BCC9
	for <linux-rdma@vger.kernel.org>; Thu, 28 May 2026 22:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780007416; cv=none; b=CFC3JxfeaMZhn4VwVJPDwZRdErwbRFS7Sh64h4Ug7MTT/jJJp7rQ/WPS9JvBs+dl8gZ3kzjEGpgEjq0cGF8a/cHFBXqnz+BDs467+Rb7qNBvY4IWCYFBHXh5wIw1RDUpKK/is4DHbYFd62w18gVtLOdHGJoG3M0HsaOUGAOXpas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780007416; c=relaxed/simple;
	bh=XE2Nz8XY3jfeATNv6GLApHENG4QyQDJPsi8VaxfTPGU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=XPFrRTQojItVtth0GQUmWSg5yctvDKh5rDfRfDaAkGK5VcsLtTq7RipmVbg733Etuan+WMQLcrpGCEkJ2J0jaIALkCOn75EbCX2PcnqXOdIeBTSStIR+qwxtoZUQ2NkipjeaNfcF0Cisry37zQhWtCBTX8Eu0OWK+9ZCfIK4lBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fTusoSH/; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fTusoSH/"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-bcda7765d64so2489598166b.1
        for <linux-rdma@vger.kernel.org>; Thu, 28 May 2026 15:30:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780007414; x=1780612214; darn=vger.kernel.org;
        h=user-agent:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IiJpfn9/OPGvc7lLpZ8Q6/8VjpgeaL3UxQCz6z34DRA=;
        b=fTusoSH/yR8iRjMuEGolfK9IdvTG98QnfWNc5ntZmmtvFNYpX+XZ3Zt8Z8RuEHKgY5
         pgurGfE59frtj1mn3DMs2GYMIHnrIW5eAuETCT+Zw8vzB3I+jUX/TAt1NwK2AdkHzg3D
         nrKx9G3+JKcXt1VEthRd2X21kk3tHZLruFchaYF5HWU8EC9mdD++jQI3TJaXUfw/4D1Y
         GjJtSJ5G/3w4eFGmObcsjd09fNw/ZSf6mngyWIeix4ZZlzi1df0w8TMexlXXxx7i65Yy
         6+KLzuUxiRBRwon1I3880/LRzoxghuKIAwxUwENexKS5aXtKDQPyuvAXBrv6GlfcPGIZ
         PRUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780007414; x=1780612214;
        h=user-agent:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IiJpfn9/OPGvc7lLpZ8Q6/8VjpgeaL3UxQCz6z34DRA=;
        b=YnURBew8rWE5HXmN8dJeXkOlpRV8Bl7BzvXsGG/37LFa9VeFj8PKO3dpyuz99WuMeJ
         hmP32gSNGNBkvrwpgShFjHmkcEz4kQoF02W4iNx0sUG3VcMVEV7bxop6Pa7xv0CHgT7R
         WYdB+0rSD3kSWHxEjQcqDGD69xY7xN0pI79dsUngTE4sb3lKjGCUNGJm4xA+0viB183j
         Wb8FDUKc1tC2uvdhXluQnUZikPrfQjoCSG+68c4tklydU3/JyESnAWnao4ZVk9oVSEim
         qhnw3ShjQIDLfl0ANuyNCwic4faveQs/JKprGNPiOY3NXiRkl3JNZ1puZvEmMWRRPvjR
         pUkw==
X-Gm-Message-State: AOJu0YztOJT9lszkVYsgHqzs7vZXIoRTl+YhX6YC0RQ+VgeK5DkSumjr
	jCc64EZY/mbMl9IYpU0II8vyXYxiJQ58mPS7IB8xorGh2baa+Eaw4VdWu2uWgVhL
X-Gm-Gg: Acq92OHCRf98Pj2rXx+pTANpMQ55bTW3eqM75/lQYmLmLpt4j6eTSE99TfAhiogKz+1
	hq+RVVrhkreehsmcqQRz15m90rZOsnjyMCoNC6y18ndGc1uzc/woxomx/iRk9/4TYR1gDtz5NlH
	VPDD5Gi4P8g2o+RPZVF2z+D1k0/tb/zH3KPbnTu/s3Zs8QODHnx8yMUAq+8P/bOr2ULqvshLkSQ
	i3tbgr7+Ye32tG93byt9B1cWNNh02Ie8m+LS7GKs4M0nXafNvuHeF7WUKx9wB0+QgUu4kJobm+w
	M8rjpNfWZIUBCU1SwYKShqv/orMdwz44qess3PL3Y9pFukcQQHNVBPLnPovRbJBsSvG/gFhnlZ8
	b7S4LX7qxQw2XU949hrO/9FtgmyMMD9ODYPPR++16b5W97IGVBkv3YL7YCcHKzF6johx+cxSya+
	sOFtI+wJN4ycjg5xM7QTiRLMW7tcZ1yRpAM4U=
X-Received: by 2002:a17:907:75e4:b0:bc5:2352:555c with SMTP id a640c23a62f3a-be9ac78d0b2mr11752866b.14.1780007413511;
        Thu, 28 May 2026 15:30:13 -0700 (PDT)
Received: from grain.localdomain ([5.18.255.97])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-be9b2bc9b50sm6105166b.0.2026.05.28.15.30.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2026 15:30:13 -0700 (PDT)
Received: by grain.localdomain (Postfix, from userid 1000)
	id 977B85A0061; Fri, 29 May 2026 01:30:11 +0300 (MSK)
Date: Fri, 29 May 2026 01:30:11 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Krzysztof Czurylo <krzysztof.czurylo@intel.com>,
	Tatyana Nikolova <tatyana.e.nikolova@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
Subject: [PATCH] RDMA/irdma: Fix typo in SQ completions generation
Message-ID: <ahjB87k54bYdFbft@grain>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/2.3.1 (2026-03-20)

When we generate completion for SQ the opcode while being properly read
from ring buffer is ignored when written back to completion. Seems
to be a simple typo.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---
Hopefully I didn't miss something obvious here, found it while been
fighting with unrelated issue.

 drivers/infiniband/hw/irdma/utils.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-tip.git/drivers/infiniband/hw/irdma/utils.c
===================================================================
--- linux-tip.git.orig/drivers/infiniband/hw/irdma/utils.c
+++ linux-tip.git/drivers/infiniband/hw/irdma/utils.c
@@ -2442,7 +2442,7 @@ void irdma_generate_flush_completions(st
 			cmpl->cpi.wr_id = qp->sq_wrtrk_array[wqe_idx].wrid;
 			sw_wqe = qp->sq_base[wqe_idx].elem;
 			get_64bit_val(sw_wqe, 24, &wqe_qword);
-			cmpl->cpi.op_type = (u8)FIELD_GET(IRDMAQPSQ_OPCODE, IRDMAQPSQ_OPCODE);
+			cmpl->cpi.op_type = (u8)FIELD_GET(IRDMAQPSQ_OPCODE, wqe_qword);
 			cmpl->cpi.q_type = IRDMA_CQE_QTYPE_SQ;
 			/* remove the SQ WR by moving SQ tail*/
 			IRDMA_RING_SET_TAIL(*sq_ring,

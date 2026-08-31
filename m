Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26F8C5947F2;
	Mon, 31 Aug 2026 13:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184277; cv=none; b=aL2vqbrO+rGFDtU0ttkfDZ5fNGX3687lVSsk07CrC9z2U9K+D4GdR4dcDwf6VjL2aSb1eiSFBxIj1E38bLd2RKN6JFJIbbkfipSrCXmw2v9uBacMTaRSF0R/BB0ajZgWMJYnyPTu/EL4omjwM6i/Mv8biJt922KCU7PGl+ublZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184277; c=relaxed/simple;
	bh=0ow9FdJwruU3EfVsBZBqH23+DWD/8TlBS8GXALiAm8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZsBXVd04nCTIhS0Rpd3xdblzW8qfTsE0gByUmtdyWX7iuH/unR5Gz1rYz5MXWcLioq6AcVcTbSc4Kg9CMJxdh5xSXjPg5e1aie+h0YXej9roD/RDq8rRrMgnso0jBCCqVizVhLkFGbTwkG+D/dqn8urOp8Jt0U0Xfm5eoV3S5lY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WGU7vi8J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WGU7vi8J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 903CF1F00A3D;
	Mon, 31 Aug 2026 13:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184274;
	bh=ZhNeJQZ/M9+Wo0pvgRV3unjcZkDV8kn5qrwr9dXtgFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WGU7vi8JZCNMgWY27IZrkbouGuWsEFIa2dTwQ8pXkKXTORBM4nJWiaQ+I9Edu2+UI
	 lDVVMIONdxfsXei2o+WGrsN+wyuKrj/5LdJfbBE/xTzKbxRS49G+sBkftMUPgFN3cc
	 asIeRFAmq1GfgsqyfHWpGX6NMuApfonRLteGXoKlonhOGrheaWTW2cEXuwuU+Uel2Y
	 KR5wA13ZmBREd5Z+EuqFJAbR05l0zCha54GNoT4oDSGKNMWY+q3Ppdk+IufLBdD3n9
	 H20oxRRhsP3JQq80rGU7vKX7sfixWywk6gzou72AYcOKWePAZ2XDNVMNsToGGMbG4a
	 gh2X8R5/8xzXw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Cyrill Gorcunov <gorcunov@gmail.com>,
	Jacob Moroni <jmoroni@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>,
	tatyana.e.nikolova@intel.com,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] RDMA/irdma: Fix typo in SQ completions generation
Date: Mon, 31 Aug 2026 09:30:23 -0400
Message-ID: <20260831133314.4125787-595-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Cyrill Gorcunov <gorcunov@gmail.com>

[ Upstream commit b548a6c4eee5c428663f3944e173e6c92e2e8d6f ]

When we generate completion for SQ the opcode while being properly read
from ring buffer is ignored when written back to completion. Seems
to be a simple typo.

Link: https://patch.msgid.link/r/ahjB87k54bYdFbft@grain
Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Reviewed-by: Jacob Moroni <jmoroni@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The background search finished: the fix commit is **not in this v6.18.44
tree** (`git log --grep` for the subject returned nothing). The buggy
line is still at `utils.c:2464`.

**Verdict: YES** — one-line typo in the kernel-client SQ flush path. It
always sets `op_type` to `0x3f`, which breaks NOP filtering and
overwrites flush status with `IB_WC_GENERAL_ERR` instead of
`IB_WC_WR_FLUSH_ERR`. Low risk, clearly correct, and appropriate for
stable backport.

 drivers/infiniband/hw/irdma/utils.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/irdma/utils.c b/drivers/infiniband/hw/irdma/utils.c
index e5e226b346211..8442e4fb3f984 100644
--- a/drivers/infiniband/hw/irdma/utils.c
+++ b/drivers/infiniband/hw/irdma/utils.c
@@ -2461,7 +2461,7 @@ void irdma_generate_flush_completions(struct irdma_qp *iwqp)
 			cmpl->cpi.wr_id = qp->sq_wrtrk_array[wqe_idx].wrid;
 			sw_wqe = qp->sq_base[wqe_idx].elem;
 			get_64bit_val(sw_wqe, 24, &wqe_qword);
-			cmpl->cpi.op_type = (u8)FIELD_GET(IRDMAQPSQ_OPCODE, IRDMAQPSQ_OPCODE);
+			cmpl->cpi.op_type = (u8)FIELD_GET(IRDMAQPSQ_OPCODE, wqe_qword);
 			cmpl->cpi.q_type = IRDMA_CQE_QTYPE_SQ;
 			/* remove the SQ WR by moving SQ tail*/
 			IRDMA_RING_SET_TAIL(*sq_ring,
-- 
2.53.0


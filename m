Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FD5453B354;
	Wed, 23 Sep 2026 14:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174659; cv=none; b=ObpMaVK3ZGwtvWgin4UOcpvoDh77AfvFC6vAiXXUgho9NdzFPJrZWuktC7S8DUT+EHVoDOFXr0FSG98bl8Sa/cvMpJk9P6rZT0JDgkLSde3kM3ncW5v3U5Cc9ZbwMfsY026JAFi/LF1xx6UldVdNhiKaIJZ5EWqRtoMiEE1dNsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174659; c=relaxed/simple;
	bh=mikozMaNBzqjOG66MSgnLM0I8SxLEQRRfu0yIks795g=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=R8CMV+g6cRrlpwYM/hGpkVgNvRtM1r1zbuq5rlTiLEFmZKd/rSXkzJMFNmOKS/mITH6nBq2HTWoPvNfR9xhlkjslmg/l1BS16RLs8ysO4S+DrrNzhPiPepxQPWGS3RtA+pcM8rVkcy46YTc/GpYYw+mwYxY1kHfHfSZZymyErlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k/M4a09H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k/M4a09H"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 086C3C2BCC7;
	Wed, 23 Sep 2026 14:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790174659;
	bh=mikozMaNBzqjOG66MSgnLM0I8SxLEQRRfu0yIks795g=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=k/M4a09HSvOjqYPBOrQAk7OsF355p32YEVYTExFKVg6TXf+zywG8HBEJ2fxsYYd+h
	 h+VNwvUQJBaPWBSZBEejcElXPIbHQyWKor4PN8jqMcbxTOjeaW4D84QH2r2/SkyPXo
	 Rn7U8Utx59w3H3Lrr/lmov5SYZqfmrVaoLokqlWetoxvf/dDeaL/BOYX8Ia5SgIkGG
	 q3hn4SJw5NChVzAQIUTUlmM363AnOPrHprexFjToQVoSBgJnH9BPrKXhn3n7iRte13
	 aCo6O0eOQUIgMmyuaI29yj1IhI4KvOMK5kJd3TRGFavPuMdxXRMEfdmAgsHpZjrzzv
	 MGm/REqn1Lp+w==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7D9DC98302;
	Wed, 23 Sep 2026 14:44:18 +0000 (UTC)
From: Norbert Szetei via B4 Relay <devnull+norbert.doyensec.com@kernel.org>
Subject: [PATCH v3 0/2] RDMA/rxe: fix ADVISE_MR prefetch on non-ODP MRs
Date: Wed, 23 Sep 2026 16:40:48 +0200
Message-Id: <20260923-rxe-advise-mr-v3-v3-0-95e1a4077e4d@doyensec.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXMUQrCMBCE4auUfXYhJkSiVyk+xGaqK9iWjZZCy
 d1N28cPZv6VMlSQ6daspJglyzhUuFND3SsOT7CkarLGXszVOtYFHFMdgj/Ks2PnfQwmIPhzT/U
 2KXpZ9mR7P5x/jze679ahUv62/cTIdAAAAA==
X-Change-ID: 20260923-rxe-advise-mr-v3-355a808e851f
To: Zhu Yanjun <zyjzyj2000@gmail.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Leon Romanovsky <leon@kernel.org>, Bob Pearson <rpearsonhpe@gmail.com>, 
 Daisuke Matsuda <dskmtsd@gmail.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Zhu Yanjun <yanjun.zhu@linux.dev>, stable@vger.kernel.org, 
 Norbert Szetei <norbert@doyensec.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790174657; l=1582;
 i=norbert@doyensec.com; s=20260913; h=from:subject:message-id;
 bh=mikozMaNBzqjOG66MSgnLM0I8SxLEQRRfu0yIks795g=;
 b=kCBAAm0NwJRgHGHCrOi500SN2mG6f8WxujQo3QKTKGfYEdueaEXnP7xf403Y3kAvcYVK740kG
 VQZX4OVn8C6C1oUQ+h8Td+5ebdwNPdKm8t3kZWNtjraESP8d5ILVHbI
X-Developer-Key: i=norbert@doyensec.com; a=ed25519;
 pk=c6ZqJ+mhvi5FloJOiMJUcIPPjT7tczbglx5gruwpVi8=
X-Endpoint-Received: by B4 Relay for norbert@doyensec.com/20260913 with
 auth_id=1029
X-Original-From: Norbert Szetei <norbert@doyensec.com>
Reply-To: norbert@doyensec.com

ADVISE_MR prefetch on a plain MR runs to_ib_umem_odp() on a struct
ib_umem, giving a KASAN slab-out-of-bounds read in
ib_umem_odp_map_dma_and_lock() (splat in patch 2).

v1 checked is_odp_mr() after lookup_mr(). Leon asked for lookup_mr() to
do the check itself, off mr->access. That only holds once mr->access
cannot disagree with the umem, so patch 1 stops the two paths that
assign mr->access after registration from touching IB_ACCESS_ON_DEMAND,
and patch 2 passes the flag to lookup_mr() in both prefetch arms.

Based on for-next. In rxe_rereg_user_mr() the new check rejects the
access flags before the mr->ibmr.pd swap, where for-rc's ae36a5b609ae
("RDMA/rxe: validate access flags before swapping the MR's PD") also
moved the existing validation.

v2 -> v3:
 - rebased on for-next, no functional change
v2: https://lore.kernel.org/all/20260913-rxe-advise-mr-v2-v2-0-b806c789871c@doyensec.com/
v1: https://lore.kernel.org/all/521D5E74-89E3-43C0-81C7-AC0BE52591E7@doyensec.com/

Signed-off-by: Norbert Szetei <norbert@doyensec.com>
---
Norbert Szetei (2):
      RDMA/rxe: Reject IB_ACCESS_ON_DEMAND changes after MR creation
      RDMA/rxe: Reject prefetch of a non-ODP MR

 drivers/infiniband/sw/rxe/rxe_mr.c    | 6 ++++++
 drivers/infiniband/sw/rxe/rxe_odp.c   | 4 ++--
 drivers/infiniband/sw/rxe/rxe_verbs.c | 6 ++++++
 3 files changed, 14 insertions(+), 2 deletions(-)
---
base-commit: 9dcacdc41083cccff74292851bf9fde999e0731a
change-id: 20260923-rxe-advise-mr-v3-355a808e851f

Best regards,
--  
Norbert Szetei <norbert@doyensec.com>



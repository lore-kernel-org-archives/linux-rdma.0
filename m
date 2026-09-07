Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D98D9336884
	for <linux-rdma@vger.kernel.org>; Mon,  7 Sep 2026 06:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788763858; cv=none; b=BST0iNI+fqUVrubwL0uc+EhFcATBYse1u5D9E8/Q813rYX2kC67DTKAMLz96EqmhTheah8BhNapeDGmQY9oGo6FmFvwG5VGrIAOWEwVs/gbyFSAiESoyiOkyfTvwqF0JKWVcoe8AxPPvmThVBWYCn0r6R58O/bCmnK985uIgkiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788763858; c=relaxed/simple;
	bh=d4jHdMgw/hJRo9VIwwh3LWCWVZ+jnZBzPIOL3epgxL4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=f9z2Nbvwh2J3WHS+JN/TcxC7xS1kL616o2ysCHdEp0IJj+fAvlCmY80MckyOpsu3xwsSJQoM4HwxzZsaF6ayGSOClVdtJd5M5mDGnI8QN1FaahIOppLgf63jFQMLKsyRw8dQC4poEXdkVf/xh9P8PPGAjrg/preZi/evo+d47hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=o5157sxl; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="o5157sxl"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2d01663d816so21549115ad.1
        for <linux-rdma@vger.kernel.org>; Sun, 06 Sep 2026 23:50:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788763856; x=1789368656; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=xq720iK1M61rs8gdGJ+ohz4/KB2C8tYfW6cPQVAwv0c=;
        b=o5157sxlNS2vHAvwh5kS39T0t4JseL6jJrXUS5eL+6rSHy+4rtQizuiiYRFRuTgUYn
         v1rIZBOcwDcIvyR7dfefToCxpJk5PXjrEygh1rT7eRktfw2WWlu5DQou7spRvsk4H0tX
         0NBWwEdLR/AykuyyrddJPwzTN+ZM4vmFlHstmRpHlF036yEfz/GQCB+apTgdCVljQf9T
         SgCWvZeL0lWc+f+qsi8w87fDzyo3loMDbRvE4+v32Kmixva7d+eDNmuNGQbgS7Xlj+4w
         wvzauto8gPwQ5t2dao4cPDyk50DNnhWicQ9I5hJ5Vd1+apxxzBGOLCNFXJkwY7WhahA0
         yxEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788763856; x=1789368656;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xq720iK1M61rs8gdGJ+ohz4/KB2C8tYfW6cPQVAwv0c=;
        b=EKpzatoZbGCxiNEON5LAn0zzra12eND7YBPslNv+aXvihvLjbVMM0QtiMVyEtVzrWt
         njihJpQWN0j5aTAzEhK+evv5AmD1bL7z+LM/WU0+MXRcDCaBLRKsDQukQHGAcmcrMJvp
         epGF7n09zlpp62/u+IjP85x2ZYIO3rEqXTZpgw9N+HZ61iwvDkyJe2sgBemDw1joc6WA
         SuJ2aOjCGuhIs8bJQTSIW1xGtsEvL/ysAaIQD1Xs9QzOMMHgAokReWiMScdBfxmyJfAJ
         cRrta9dWLWIHX4emIwboUh0W34+mjeHtLRU5ntd7wz2qo+4y+N8fOV2vDqcEdCk1OPcy
         svAA==
X-Gm-Message-State: AFuF++l7ccQdVmYGQBvrilQA4eT2K1vZ6AooWN/K32bKnM1SgCEDfqX1
	rjKb5TjnzkCLYQzzrnXMDN5tlvTQCE+KI7AfR2xUwqVRkh8a5+PLieCr
X-Gm-Gg: AYBFou39K0sXKv7OJQjXovDUuPGe1V3QSyOJE+vPDzipWcpZf66halxeUX1kP3RCjLo
	ZaF4cnmPbOjsZiOaawr1YBL4xIRnxGlSe3z8JVGFADgWeMtMCr3D3abm6JBdp5fLEj0w5YdRmhn
	Y6/Ec2G4Jb/v0KeQvn3WJys9oNZixAHYYdth1Lx7CIxkF4QXC/nofPmlRPqsNI/Lz3VDFXU5Kci
	6Nw36hgw9DY5DC03XJRSCntB9evz4x1124SZRAk4LpoQVK93iF/Rrrcv2leJVed+7+6ow9mB2dz
	DePq08sJZoSQwaUeVlAE99RjTaje97XTXDtsLw0PSl/nCaP2yVN4QAwR0u4fSSkRi+EMfsqpqIB
	Kc3Lgn2TXaUO3ogUQ7GiiT7GKLlxpeI4wmbGP2yMlvE9afnGlSzNF1tYn6gDkRj8RiprhOfHp/v
	iPrGGWZ3luvkTzot7+uwmXMKvQuK23PFa+KW5JMuznbF2sSfduTwjVx6Dpoap93qxMjeYJlYibT
	k32DXSeP4r0LA==
X-Received: by 2002:a05:6a21:458f:b0:3c3:a20f:f729 with SMTP id adf61e73a8af0-3da39beaa21mr32559783637.7.1788763856035;
        Sun, 06 Sep 2026 23:50:56 -0700 (PDT)
Received: from volcano9f6e-hostos.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-338778fb926sm473120eec.31.2026.09.06.23.50.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2026 23:50:55 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Potnuri Bharat Teja <bharat@chelsio.com>,
	Cheng Xu <chengyou@linux.alibaba.com>,
	Kai Shen <kaishen@linux.alibaba.com>,
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Michal Kalderon <mkalderon@marvell.com>,
	Nelson Escobar <neescoba@cisco.com>,
	Satish Kharat <satishkh@cisco.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Max Gurtovoy <mgurtovoy@nvidia.com>,
	Bart Van Assche <bvanassche@acm.org>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	target-devel@vger.kernel.org
Subject: [PATCH 0/2] RDMA: fix typos and repeated words in comments
Date: Mon,  7 Sep 2026 12:20:45 +0530
Message-ID: <20260907065047.26773-1-hemanth.selam@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This corrects 2 misspellings and repeated words in comments.  Each is a
separate patch so that any one of them can be dropped without touching
the rest.

Nothing outside comments changes.  Every touched C file was checked by
dropping its comments, replacing each string literal with a placeholder
and collapsing whitespace; what remained was identical before and after,
so the compiled code cannot differ.

The mistakes were found with scripts/checkpatch.pl against the list in
scripts/spelling.txt.  The scanning, the edits and the changelogs were
produced with Cursor running the claude-opus-5 model, from a request to
find and fix spelling mistakes across the tree, and every correction was
then re-checked by the comparison described above.  Words that name an
identifier were left alone deliberately, even when they read as typos,
because correcting the prose would make the comment disagree with the
code it describes.

Tested by building x86_64 defconfig at v7.3-rc1-269-gbc35965f6940, which
is clean.  Nothing else was built, so any patch touching code that
x86_64 defconfig does not compile has been read but not compiled.

Hemanth Selam (2):
  RDMA: fix typos in comments
  RDMA: fix repeated words in comments

 drivers/infiniband/core/device.c              | 2 +-
 drivers/infiniband/core/iwcm.c                | 2 +-
 drivers/infiniband/core/uverbs_uapi.c         | 2 +-
 drivers/infiniband/core/verbs.c               | 2 +-
 drivers/infiniband/hw/bnxt_re/ib_verbs.c      | 2 +-
 drivers/infiniband/hw/cxgb4/cq.c              | 2 +-
 drivers/infiniband/hw/erdma/erdma_main.c      | 2 +-
 drivers/infiniband/hw/hfi1/affinity.c         | 2 +-
 drivers/infiniband/hw/hfi1/firmware.c         | 2 +-
 drivers/infiniband/hw/mlx4/mcg.c              | 4 ++--
 drivers/infiniband/hw/mlx5/odp.c              | 2 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c   | 6 +++---
 drivers/infiniband/hw/qedr/verbs.c            | 2 +-
 drivers/infiniband/hw/usnic/usnic_abi.h       | 2 +-
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c  | 2 +-
 drivers/infiniband/hw/usnic/usnic_transport.h | 2 +-
 drivers/infiniband/sw/rdmavt/qp.c             | 2 +-
 drivers/infiniband/sw/rdmavt/srq.c            | 2 +-
 drivers/infiniband/ulp/ipoib/ipoib_vlan.c     | 2 +-
 drivers/infiniband/ulp/iser/iscsi_iser.c      | 6 +++---
 drivers/infiniband/ulp/iser/iser_verbs.c      | 2 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c         | 2 +-
 include/rdma/ib_verbs.h                       | 4 ++--
 include/rdma/uverbs_ioctl.h                   | 2 +-
 24 files changed, 30 insertions(+), 30 deletions(-)


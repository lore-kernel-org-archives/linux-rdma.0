Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C03B5464D;
	Wed, 22 Jul 2026 12:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784724963; cv=none; b=h8IpIIpXa1qowbDTqAw8a4dosZl4hKW8D9rc2Ka/2XyhF16TaIl2K66aixu2ovu2u5ra9P7Ys0YjCQBmrYqzYCe2rFh2WUwGzHHEaxPdXfJqSwgOUTcAZPOJfy6xlx70ZiWDHDul0J1EnsRfjWEQPvToImtAXGwT03z1IwwnWdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784724963; c=relaxed/simple;
	bh=zpeg5d5ytCkhdg46vwRqqadZU8fnyKCySEt0DDguDcU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=mN36pZmEoYhyGh7F9/F6FIT/k49gt2SGQ0TKLe1hxFPGu70q5KF9NnuBRgyLnQEdF6PaXfAMbWhsG++IIAFcgWFpcnpbHJ0nA/L+28gLNi/NwXp8J3D11B+VGrtab9+16l84xlCBw8b8reybYGy4HgstG6hLioIu5yb9GEBccWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e7AiHLHK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e7AiHLHK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E78E1F000E9;
	Wed, 22 Jul 2026 12:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784724962;
	bh=Vx/+CsGRRM1h2stz5vle7GBsXwhHi4ckCp1gyGu7hac=;
	h=From:To:Cc:Subject:Date;
	b=e7AiHLHKxVJvQqXmEo1GrE3rGlzwC9H0AaNXSSiHoEjc2VXRQColpPxFUmCGs8OVr
	 G1A+j/4SPc9XvyLVV9yKmdPdefSdM17y6lWWYBXIQssa6DVgLjO+VzUGw8yoTXbCvV
	 lCwTPicu1qXi1Wpq19LR1r7jeQgeR1NGRrY14zLwgCtuRZNqVFdwua1nO7yykKF5nN
	 zDUnnApc691jqJMdF0pTY2AANJBoZ96OyJAVGVET7EQ16efEKspHsW4LAepOaSkLLH
	 xgjxDbbSb95rNEzvVWdmfupPLVBX2+5egdAQbMJL3cB7CfZ7K8xjPPkt3uHzwnnw5P
	 bTy3oRJUkbJdQ==
From: Leon Romanovsky <leon@kernel.org>
To: Selvin Xavier <selvin.xavier@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Chandramohan Akula <chandramohan.akula@broadcom.com>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next] RDMA/bnxt_re: Clear VM_MAYWRITE on read-only mmap of driver pages
Date: Wed, 22 Jul 2026 15:55:52 +0300
Message-ID: <20260722-missing-vma-write-protection-enforce-v1-1-567cd8499e23@nvidia.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Change-ID: 20260722-missing-vma-write-protection-enforce-2e99624c35dc
X-Mailer: b4 0.15-dev-18f8f
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

bnxt_re_mmap() rejects an initially writable mapping of the DBR pacing page
and the toggle page, but leaves VM_MAYWRITE set on the accepted read-only
mapping. A later mprotect(PROT_READ | PROT_WRITE) therefore passes the mm
permission check and upgrades the inserted PTEs, letting userspace write
these driver-owned pages: the DBR pacing parameters maintained under
rdev->pacing.dbq_lock, and the CQ/SRQ toggle state written from the NQ
tasklet.

Clear VM_MAYWRITE before vm_insert_page() so the mapping can never be made
writable, making any such mprotect() fail with -EACCES while the read-only
mapping continues to work.

Fixes: ea222485788208 ("RDMA/bnxt_re: Update alloc_page uapi for pacing")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index adc693736769..dcfb1b0ebc22 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -4984,12 +4984,15 @@ int bnxt_re_mmap(struct ib_ucontext *ib_uctx, struct vm_area_struct *vma)
 		break;
 	case BNXT_RE_MMAP_DBR_PAGE:
 	case BNXT_RE_MMAP_TOGGLE_PAGE:
-		/* Driver doesn't expect write access for user space */
-		if (vma->vm_flags & VM_WRITE)
+		/* Reject writable mappings and prevent mprotect() upgrades. */
+		if (vma->vm_flags & VM_WRITE) {
 			ret = -EFAULT;
-		else
-			ret = vm_insert_page(vma, vma->vm_start,
-					     virt_to_page((void *)bnxt_entry->mem_offset));
+			break;
+		}
+
+		vm_flags_clear(vma, VM_MAYWRITE);
+		ret = vm_insert_page(vma, vma->vm_start,
+				     virt_to_page((void *)bnxt_entry->mem_offset));
 		break;
 	default:
 		ret = -EINVAL;

---
base-commit: 0e8e94c15091041ea8910cbfcade5a9c7cfe3f90
change-id: 20260722-missing-vma-write-protection-enforce-2e99624c35dc

Best regards,
--  
Leon Romanovsky <leonro@nvidia.com>


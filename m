Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com [209.85.128.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81B9743F8A9
	for <linux-rdma@vger.kernel.org>; Tue, 28 Jul 2026 14:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785248105; cv=none; b=XyoFUf5nATu8Yef3Xp+Mcx4BdJLUWJGbwBbDF46xUKVGxnZtdetbtFgByp3icV+yp3EWGho43P84CuYiNY4xNXQOhznft/jfbh2g6lTAFTKbwqfC2/46u1bg92sQWEvKslAE3I2bukQw43E5SX9dkiJFKedJq5tyvT6yM7riHtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785248105; c=relaxed/simple;
	bh=k8BK1468BGFmxpS6M4DkPSelhiHsLwRp5XtIwte9OwY=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=sSm7tSwOd4D/tBEKBETCw3uTXch7MzlCaJJqpJBYp+YQ2jogBQY2lx6DmDd50AC2y0h9gPMFzP2Y7egPdQA1y3g9vmSS194Phu5r0oQmcHsc6kT3u9hBlFsvqn/XPIK4WQ2z9pvqStjAULqbYVyOCjkqPKF29gvkeOMqxME49Zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmoroni.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=F7r8oRIz; arc=none smtp.client-ip=209.85.128.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmoroni.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="F7r8oRIz"
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-81e92ddc199so101658877b3.0
        for <linux-rdma@vger.kernel.org>; Tue, 28 Jul 2026 07:15:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785248103; x=1785852903; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=AJBNpLYuiiEZbLHx2AGAAV1TB2pEXpSP5Advzj0Eml8=;
        b=F7r8oRIz5B8KZM/PgecsqEW1gOOn+9phN1aRWLloVUkfQLAnLw/aRzWFPlN8nfLLD1
         JRAjqB4+xiWCqCR7sQ6uDbwVd4cVlFX85nuBY0kS/+stPPtq33DbrjQAS+2X2JYk79Tr
         MsFzjGS3OToJo9J5bbLl2J3kK6Gv+wDLfpTGDuUVhcXKIh5JkEqtRV/RRygm1DwfwZq9
         2L9l50VJ/ivYhr1LBFSjM6IrO4nHqdleY2jY37qBkcry8zH+S62mVPtyQcjXU/nOgW/5
         2LtJrVY/opgJyjvdwdr+wJtW34kI8AfKZRfQ/Ey4Ce5dOc5eJ8eWooTw5p4awz28AL5D
         u4Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785248103; x=1785852903;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AJBNpLYuiiEZbLHx2AGAAV1TB2pEXpSP5Advzj0Eml8=;
        b=HXcM9V43/0tgBqEmo0OvoJxo7vIg135IznP1YHaBJsb8jaqNXwrTp7C18dCYrI2qD6
         0PEr9+Pk8IgIco3M/m01Daog8gIVjQy69JIyTLAl15zKhs7APgWKD0SMwmedeLiddbTp
         Mt7wNUPE57f8NC6qlYtHTTaRhozeKzZ+iTEMHe6RV64cuDFZYhSLOxujnpsPxIarC+Xy
         q9GtwfLZPxqymDp7u29/Ic0uXx+EUQW6znzUiNrfNzVdKNyDooLVWdVGCjdXDPW+OTkg
         GL+9PYZw99HhPu/VH8bJ8i0Z9THGJqFcZCWOYNfsrBEx6Fv1vYC/BmOHryhqOub1cO+4
         MaKQ==
X-Gm-Message-State: AOJu0YxiFSwqT0Bw5ybGs19HYTTKcfmlMnvH5k3TXmStu/wmH1ieOJ+1
	Tmeh8/LwxKZfYz1sY+rH/DZCw4teGsnHXIqtALpxTKqpTX2cXpXtmLGTBmQsJ6xUiOY6jeAOV0v
	VOdHCeIKXGg==
X-Received: from ywbhw14.prod.google.com ([2002:a05:690c:650e:b0:7fe:8964:6b5c])
 (user=jmoroni job=prod-delivery.src-stubby-dispatcher) by 2002:a05:690c:64c2:b0:81e:eaaa:535b
 with SMTP id 00721157ae682-81f992e2f77mr9452857b3.35.1785248103144; Tue, 28
 Jul 2026 07:15:03 -0700 (PDT)
Date: Tue, 28 Jul 2026 14:15:00 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260728141501.1425737-1-jmoroni@google.com>
Subject: [PATCH rdma-next 1/2] RDMA/core: Prevent rereg_mr for dmabuf umems
From: Jacob Moroni <jmoroni@google.com>
To: tatyana.e.nikolova@intel.com, jgg@ziepe.ca, leon@kernel.org
Cc: linux-rdma@vger.kernel.org, Jacob Moroni <jmoroni@google.com>
Content-Type: text/plain; charset="UTF-8"

The rereg_mr method has always been explicitly blocked in
rdma-core for dmabuf MRs anyway, so add a check to the
ib_umem_check_rereg helper so that each driver doesn't need
to handle it.

Depending on how the driver handled rereg_mr, this also
has the benefit of preventing rereg_mr from being used
to add the IB_ACCESS_MW_BIND flag to a dmabuf MR. This
flag is not allowed during registration, so it seems
sensible to prevent it from being added back with rereg_mr.

Preventing IB_ACCESS_MW_BIND is important for drivers that
support revocable dmabufs and implement "revoke" by issuing
a dereg_mr command to the HW because most(?) HW will reject
this command if the MR has windows bound to it, and a failure
to revoke is supposed to trigger a function reset.

Signed-off-by: Jacob Moroni <jmoroni@google.com>
---
 drivers/infiniband/core/umem.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index 81f44dadfa52..88110b9661f5 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -677,6 +677,9 @@ int ib_umem_check_rereg(struct ib_umem *umem, int flags, int new_access_flags)
 	if (!umem)
 		return 0;
 
+	if (umem->is_dmabuf)
+		return -EOPNOTSUPP;
+
 	if ((flags & IB_MR_REREG_ACCESS) && !(flags & IB_MR_REREG_TRANS))
 		if (ib_access_writable(new_access_flags) && !umem->writable)
 			return -EACCES;
-- 
2.55.0.229.g6434b31f56-goog


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A629742FCA3;
	Thu,  3 Sep 2026 11:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788435568; cv=none; b=mhFXPwf+aSYjBB9yPhb9+XMSWwdDH5XxTxO9vHwP7uVwfSdHAll1ahHgGf7ma4PxfawdfsZcURcHBl0onYpE9Me4ZE97Oys8USOkPbKqx66GyK7aALqBYyr3GPPakAumgFb2KQI1/CbyRB6mZvFxhOnWypTrVTdaLT9Ir7vs0hM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788435568; c=relaxed/simple;
	bh=oHGHo6fJhynnz6k79C+m6iqmvLkQYsZkf+MRlF0WCeg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=s9GWD7a8XibsMfnED/MLljguaBMjJneepUaqdabIfzy1zxb3uBRnhj75VWOyuF2NGKNrFNsM8gRKwODf5JFxuJ7mCCQHU3+ZeRfd9uB3e95/YxQoU9q6s/yMYjsEP1R6i56AjJhOiSZs2uy316naNtMBXify4o8Pa7uqmKLy/pY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g7Ue517d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g7Ue517d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B3101F000E9;
	Thu,  3 Sep 2026 11:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788435555;
	bh=hKHffJapm5ah30qKuA7YhcYG5xXv8P/R9oUfaFV3IJg=;
	h=From:To:Cc:Subject:Date;
	b=g7Ue517daOuYitT8koIW50t/tVqD2ayJEIhaxCoUbHnudYbJDzRRdt+7EZZ5RcTna
	 ye23g5gQJE4L8SRi+KxiUMdYyJpugqN2wHaBdb6a/2+rDjp7NQaZpPd9KKHtA9/Z1O
	 qi3Jw/fMqeJuQ873hiqzrqIt+ffioP6gglfVnO/OpmbfnlKNOYye2WTI3JKQDSDjTk
	 MuuSAZUfFg9T5psIZDnDrx4vvaGnW/QguMYh0PHI0S4S+/t8aGWZ7/7ylZz8FQYcCc
	 RVuLlIo1kWGw9+h5kuRXXAacJpSG3l/QwghfzT18u4YZ5cRiyh8jt05imUW4GHXhBK
	 YHoSIRHzY11XA==
From: Leon Romanovsky <leon@kernel.org>
To: Tatyana Nikolova <tatyana.e.nikolova@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Mustafa Ismail <mustafa.ismail@intel.com>,
	Shiraz Saleem <shiraz.saleem@intel.com>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next 0/2] RDMA/irdma: Preserve fast-registration IOVAs and simplify SQ posting
Date: Thu,  3 Sep 2026 14:38:58 +0300
Message-ID: <20260903-64-bit-iova-is-silently-truncated-to-v1-0-96e878ea6873@nvidia.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Change-ID: 20260903-64-bit-iova-is-silently-truncated-to-f29be6986041
X-Mailer: b4 0.15-dev-18f8f
Content-Transfer-Encoding: 8bit

Fast-registration IOVAs are u64 hardware values, but irdma passes them
through pointer-sized types. This truncates the upper bits on 32-bit
kernels and can program the wrong WQE base address.

Preserve the full IOVA throughout fast registration. Also remove post_sq
controls from QP flush and fast registration because every current call
path requests the corresponding send queue to be posted.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
Leon Romanovsky (2):
      RDMA/irdma: Preserve fast-registration IOVA on 32-bit
      RDMA/irdma: Remove unused post_sq arguments

 drivers/infiniband/hw/irdma/ctrl.c   | 23 +++++++----------------
 drivers/infiniband/hw/irdma/hw.c     |  2 --
 drivers/infiniband/hw/irdma/protos.h |  3 +--
 drivers/infiniband/hw/irdma/type.h   |  7 ++-----
 drivers/infiniband/hw/irdma/verbs.c  |  7 +++----
 5 files changed, 13 insertions(+), 29 deletions(-)
---
base-commit: 6ea2157ce8c7497a2862bd3579a987afe6b129ed
change-id: 20260903-64-bit-iova-is-silently-truncated-to-f29be6986041

Best regards,
--  
Leon Romanovsky <leonro@nvidia.com>


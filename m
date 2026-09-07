Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91AEC4CA76E;
	Mon,  7 Sep 2026 18:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788806710; cv=none; b=gfeqN3lHjqkaqF+mXso8H9MKKE+vbhB3SnvtfApEFSlZbJyhZzzXUP2vyMtztkNsuCiTjt7pDlPro0dGEOaJ6+5+t8eaqphf44D9JJt3ZLwYWCFfb06eM1lMyLdl+qdhSBTxuVbrRZWHzKrt73/lUMdmGF74i1qbKRAHdns1Gf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788806710; c=relaxed/simple;
	bh=101dLjuJxnbFZ4n42T4NCglck7JOmgKXdlLvMEHsTTE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=kixYP8GktYlGRphYUhW86upjSw9XOy6bbz6GNckGmTp78WYPgUJjn4HOzFf6HYRzmCDxkns0mGLwqwFUtLCdVi1MuPK8IQgXaQXvnDN8HY3wsd2+LpN6oqSr6Aof9HxpWsmjYgLAe17rZovtlZuwgy87qLrXaImbpYLMdklIbN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KNUN+DpX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KNUN+DpX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6B411F00A3A;
	Mon,  7 Sep 2026 18:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788806696;
	bh=0wt9sWnJ/J/dmwG3JImQNAZGcvqroWlikEUzzJcdHDQ=;
	h=From:To:Cc:Subject:Date;
	b=KNUN+DpXnGtXHvNDdwfXVegvTQjU3C9Z/YCL/at+bJRWTtPvvYTX/1fxiD5BcZGrz
	 Bdf2Rq8xBzw5+1z2bHOIfFJNlWf+C2HdJSbuvEglqbWvkR9fyFrUhu2RavYzUOij62
	 eU5dbnjgnTD9vByVFoRkUwkVzSpxFoAOWLxOqCOhsphcD99/8UZ5q+wV99OYIIK9x+
	 qLP4lZucTW8FSHvyGx4+mQTEkHAUwfIEty/hg2DEjdtNlC4Ug1y1hVnMsvXs/n632t
	 GMOi4El724B5+UYfZp0lMEASDHW3AfeVjgHi63ygOV9Z7tZS6ZIBcfYADhyIHddF6w
	 qHIDYiTCPXz/w==
From: Leon Romanovsky <leon@kernel.org>
To: Michael Margolin <mrgolin@amazon.com>,
	Gal Pressman <gal.pressman@linux.dev>,
	Yossi Leybovich <sleybo@amazon.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Shiraz Saleem <shiraz.saleem@intel.com>,
	Steve Wise <larrystevenwise@gmail.com>,
	Firas JahJah <firasj@amazon.com>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next 0/2] RDMA/efa: Synchronize IRQ before freeing admin queue and EQ
Date: Mon,  7 Sep 2026 21:44:45 +0300
Message-ID: <20260907-use-after-free-of-admin-queue-struct-v1-0-dd9d9267fbf4@nvidia.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Change-ID: 20260907-use-after-free-of-admin-queue-struct-5c10e817ce3a
X-Mailer: b4 0.15-dev-18f8f
Content-Transfer-Encoding: 8bit

Two similar patches for pre-existing issues.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
Leon Romanovsky (2):
      RDMA/efa: Keep admin queues alive while IRQ is registered
      RDMA/efa: Keep EQ resources alive while IRQ is registered

 drivers/infiniband/hw/efa/efa_com.c  |  7 ++-----
 drivers/infiniband/hw/efa/efa_com.h  |  1 +
 drivers/infiniband/hw/efa/efa_main.c | 33 +++++++++++++++++++--------------
 3 files changed, 22 insertions(+), 19 deletions(-)
---
base-commit: 63367df6e7255067ad6a83abe0d2799dfa491876
change-id: 20260907-use-after-free-of-admin-queue-struct-5c10e817ce3a

Best regards,
--  
Leon Romanovsky <leonro@nvidia.com>


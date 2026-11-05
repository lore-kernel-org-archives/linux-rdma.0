Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793872637;
	b=wnP3jHbx+9IJKFDoXO4jHPbAu96XLkCkLmIiUuxqCe5XB6rv1B041lihoR4+BdAocnRQ
	 5JXRKTxdshCAS84MVpZ6LqmKT+KncMBhzraPje8hkoDjjgfGDBL0FHBY71Es+E/v8U78B
	 vhComMTAYGrH+HyZ38zDzb2UESiVuUulO6VG+gaaU/y85EabfCdKkvYZ894jujElKh+CR
	 zT1N9iJTshck0jXEtPRm5CP7b9GZXsIO0UbZMXbKfv2K1dyxLSH4WhXL7WEnos9DmItHt
	 2GaeGANkD+aIb0rTE+COLLokEFuXf+vsqgHIAH80o8pTfRdNLdArAaVyEEnHS+1wHlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793872637;
	h=Received:From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-Mailer;
	bh=EEl18m9vzuvHXbvU8Pq90NzzLs0UCd8pnitdnK+FGrU=;
	b=0yCiNXraGrmKRc1tbylRpk4bnEsNrQi2eI42QB8fmlygTA1Ao096SIQvS3hY1OyrREmd
	 zExLG1mxRilTU45vnt9YnWrJte29eXWCZFs7G57zRC6XjZSnnb+FPY3gJPvSXML+8v3HC
	 9Spkufe6fpmv4bNtffVOWLX7Zk7l+Jxn1my3L+9eZgT6xAKNeOAmfzRY6AZA8RzFCnV/d
	 rx3JEWMg5aSRRj7kM2a1k5zF6mAUR/o83LkgBy4n7Sf5o76+6KXrma6/wpRYQhVLjPGGW
	 TM7PKZDlz7MyQ8l/H9r1z/SFF3EkMWFwjl/3OYpzeMKl7M/Vl/PS/zP85y/XXdC59PA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7807606A329;
	Thu,  5 Nov 2026 09:57:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC3241F000C1;
	Thu,  5 Nov 2026 09:57:15 +0000 (UTC)
From: Leon Romanovsky <leonro@nvidia.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20261103-rdma-branches-v1-0-763c07cc14aa@nvidia.com>
References: <20261103-rdma-branches-v1-0-763c07cc14aa@nvidia.com>
Subject: Re: [PATCH rdma-rc 0/4] RDMA: Clean up the MAINTAINERS file
Message-Id: <179387263351.3343171.2764229750054748870.b4-ty@nvidia.com>
Date: Thu, 05 Nov 2026 04:57:13 -0500
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Tue, 03 Nov 2026 11:41:56 +0200, Leon Romanovsky wrote:
> Clean up the RDMA-related sections of the MAINTAINERS file.

Applied, thanks!

[1/4] RDMA: Rely on the generic Patchwork instance
      https://git.kernel.org/rdma/rdma/c/da984bd653ac00
[2/4] RDMA: Add missing UAPI files
      https://git.kernel.org/rdma/rdma/c/8a659a44b80f07
[3/4] RDMA: Clean up the INFINIBAND subsystem entry
      https://git.kernel.org/rdma/rdma/c/19c729c9be5492
[4/4] RDMA: Remove pointless links
      https://git.kernel.org/rdma/rdma/c/9378a75946ba32

Best regards,
-- 
Leon Romanovsky <leonro@nvidia.com>


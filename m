Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792697877;
	b=jFRPyje+LLHRdXjRLYlyef6KeQgDfKhWpe2nqSmTMdmLdbcuKn87KF+6NCNk0dJq65gW
	 pRccXUEI1BaioaHawQHSNRwzfzJPJ06WcsLRKn4CxYSJ2iwbWxHu3Z/weXo6rdLibaiEf
	 Mgo6+iviTOG4q1viUKr9j4/2l1FOt9kbwXj+zBKkwTD1esXRKzuvO1EndMs72Xm49CbBR
	 9PAPFUp6UT8FKM5rknfmYYsplMwF9n0VWPJE7tFRYGe6URphRj9rsoIOw6OiPksv5UhHx
	 ZE+u2bZoSHBWRs0hH3jjW2IoESyQQPkSel5e9n669gF9EwCoWmgxZc95KbKOSkjzQeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792697877;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=URC7r36kokGjXCV5G6Ei8oKV54JoMbconYpCKkPt2AY=;
	b=oi9uDKOvJvGg3sxBO/LzJLeTVpo8mKEy+6s7hwapRDadTLd9pusqOUz/G/Xe88OWqgBK
	 Eg6Ce5VUSiL9DfqRTNY0S8KOjxPZrKT3pw6YiUiQ3xLquQr4fl4caA1z4HVmo128EmUHq
	 xb2CsKXdwSQD9Ge2Bk74grFF4L/H5CFVWKB7SAH6qXnZpjJASKixMZvYYlhOB6WtSaUyz
	 VmA1KPqJJDlubfURnFxqEU4Gq1Mt2Xo76clzEcWvcT9Zi3dEEMaKylecl1zp9IG67cdRW
	 c0I3hcyjR5jC8EKWco/jKRfTiJxlYzSygQmxog3OoGJ6OuxPhW1YYfZBxdfx1BGkYYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EWkiZAvN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AE71606A32D;
	Thu, 22 Oct 2026 19:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EWkiZAvN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFA851F01825;
	Thu, 22 Oct 2026 19:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792697877;
	bh=URC7r36kokGjXCV5G6Ei8oKV54JoMbconYpCKkPt2AY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EWkiZAvNCkq9DvMQ7s1/R81TpRVRRDD6OJpo72z+6VV6D1I8/mdLYiQSUk3nzQ79y
	 m7CiX02qFDdtQ3I2ZaiGFSXA3dgOjcmMSbjLFNoXE8WiEL8memyf2ECNzlHsxVp7En
	 gKCbCEwOtCoDpybkBvDgdonMN4UKRVBBHDjjM2WM5+AJJNzukoXPlQn7GkwjmxNQdA
	 aXXKh7ZA730R28n8NZmN5nAANy+ZnzLeyAPMMm2PGSVOcVWTJM8p7uCzJFcU2Ry+XR
	 vRw/Sri2rKnbV8Qr4m/oZyF8gCjNwWekYCEK9B7jMpxJZckVmiceoMqh7NTK/ReYdj
	 ufnd3wyMTth5Q==
From: netdev-bot+sinfo@kernel.org
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
 Paolo Abeni <pabeni@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>,
 Carolina Jubran <cjubran@nvidia.com>, Cosmin Ratiu <cratiu@nvidia.com>,
 Edward Srouji <edwards@nvidia.com>, Gal Pressman <gal@nvidia.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Kees Cook <kees@kernel.org>,
 Leon Romanovsky <leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
 linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org,
 Maher Sanalla <msanalla@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
 Or Har-Toov <ohartoov@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>,
 Shay Drori <shayd@nvidia.com>
Subject: 
 Re: [PATCH net V2 0/4] net/mlx5: fixes for LAG max_tx_speed update flow
Date: Thu, 22 Oct 2026 19:37:55 +0000
Message-ID: <179269787533.3290.2556599268261931387@kernel.org>
In-Reply-To: <20261022193053.3815866-1-tariqt@nvidia.com>
References: <20261022193053.3815866-1-tariqt@nvidia.com>
Auto-Submitted: auto-generated
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Hi!

This is an automated message. This series looks like a fix, but its
commit messages seem to be missing some information:

 - How the issue was discovered, e.g. hit in production, hit during
   development, syzbot report, manual code inspection, LLM or static
   analysis tool scan.

 - Whether the issue was actually triggered, or is only theoretical
   (e.g. found by code inspection). If it was triggered please include
   the symptoms, like the stack trace or error messages.

 - What hardware the change was tested on. For driver fixes please
   mention the device (and if relevant firmware version) used for
   testing, or say that the change was not tested on real hardware.

Please do not repost the series just to address the above. Instead,
reply to this email with the missing information, so that reviewers
can take it into account. If the series needs another revision for
other reasons, please include the information in the commit messages
then.

The evaluation is done by an LLM so it may be wrong, if you think
that is the case please reply and explain.

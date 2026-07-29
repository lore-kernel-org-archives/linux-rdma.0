Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AB6244C4F1;
	Wed, 29 Jul 2026 11:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785325257; cv=none; b=rBUhP5MUrhZIPwdVaHKnHdYcEuXwEoCO8vnV+eTVrUaEOUUVkIyHtvPREJgjkXD5++h+aGUXAJLjwIw4SHohisuZt8P+fPnHuYwW5EgIq205gW0fVq33jLI7GHIHe1yWNS5dhfaPmxQiQgUo7GIDdQ6d8tSCX771wDa8ZW5IQ3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785325257; c=relaxed/simple;
	bh=FG7zhBbRYasUFmMj1eIS4z1BXassXwYqaOKSe6ZjD6w=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=OoXNSH2qYOybrmXPHVVw4nN3Y+3p4rb8MjXKfvUR5R1pH0RXSSoFdsa4g0ix2Wy1gxNK51XPynwLvdKdw+WVDFEsgl7ubiQxgqQZFdT7ZG2fWXo+Z2R93XUZufm1FxzZ25W4Lz18kb82qLFR+/is96ic+yZb+WVyU/9xnrb3L8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 802B91F000E9;
	Wed, 29 Jul 2026 11:40:52 +0000 (UTC)
From: Leon Romanovsky <leonro@nvidia.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Daniel Jurgens <danielj@mellanox.com>, 
 Doug Ledford <dledford@redhat.com>, Parav Pandit <parav@mellanox.com>, 
 Eli Cohen <eli@mellanox.com>, Leon Romanovsky <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260726-get-param-leaks-kernel-stack-memory-v1-1-d61a4d39662d@nvidia.com>
References: <20260726-get-param-leaks-kernel-stack-memory-v1-1-d61a4d39662d@nvidia.com>
Subject: Re: [PATCH rdma-next] RDMA/mlx5: Fix stack out-of-bounds read in
 cc_params debugfs
Message-Id: <178532525030.1588207.9157758662080415344.b4-ty@nvidia.com>
Date: Wed, 29 Jul 2026 07:40:50 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Sun, 26 Jul 2026 12:13:55 +0300, Leon Romanovsky wrote:
> get_param() reads a congestion parameter as a u32 but formats it with the
> signed "%d" into an 11-byte stack buffer. A value with bit 31 set, such as
> 0x80000000, renders as "-2147483648\n" whose full length is 12. snprintf()
> stores only 11 bytes yet returns 12, so simple_read_from_buffer() treats 12
> bytes as valid and reads one byte past lbuf[].
> 
> Size the buffer for the widest unsigned decimal, format with "%u" to match
> the u32, and use scnprintf() so the length passed to
> simple_read_from_buffer() reflects the bytes actually stored.
> 
> [...]

Applied, thanks!

[1/1] RDMA/mlx5: Fix stack out-of-bounds read in cc_params debugfs
      https://git.kernel.org/rdma/rdma/c/03826bc1fa6c90

Best regards,
-- 
Leon Romanovsky <leonro@nvidia.com>


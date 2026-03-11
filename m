Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 092D330214B;
	Wed, 11 Mar 2026 03:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773199226; cv=none; b=qvv5T79089Sj4bOMmwMesvSbbcSEhTuMd9PG/+pGtjYRWWuHTZ3O3GJ7ywZl7vzRtNPO26RBpnld8+LPrnOWpgU/5IE+j2jTDT+JkLmqPI/joEvpnTzWnnxFhXXCaECSFUh77TE2WgFFQBUnWQaFU6OYdXFur4bT7we7csb8E0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773199226; c=relaxed/simple;
	bh=xLFYBcuI2rMmkYeZqyfpWkiZRJ4hm4SwKSMB4iRTA6A=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p8nriScsY04LQXVABPUBccKicDW/OyxylYK/IWuG3LTV4nfycDoTjS/5/UwezrnP/7rNtDrO1J3do/387i6KRBXPoe8FomU4EPk/tX/AxepDISLxdiRJ6U7+R70tbKlB5rxqZ90wfdBCAtt14iz3gqV5uZb+uLkfqKhb8vxYIQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ib6GQNWN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ib6GQNWN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04E6CC2BCAF;
	Wed, 11 Mar 2026 03:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773199225;
	bh=xLFYBcuI2rMmkYeZqyfpWkiZRJ4hm4SwKSMB4iRTA6A=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ib6GQNWNSC6RG8RTDrjqMexyCCxGzxfRJBe9veBKm5Z/qr0yVQhhycLiPcbNIkcls
	 kLnipN2vTk7IH1zgkUQrIH/PTc3uk5lI6+O1tEiLWz9Bw1QpJKUH3qBdXJmD4E1ljX
	 AuBMFZyBZkqLX4TT6Q3sLI4UD5GPoF1T6PM2gjklNU6CerGnNIUGez4xkbyAtI9wAs
	 2zRS9C/lVlQsdETOjN0t8NK7eFeYsSul5YDLrcB7qRQ7+GZ403RsiQqvj4WT06tKlw
	 HTDSAa2kaW4WbZzw7q/mPZc1vus7MqnqbfZbfPcdBQA3Mx6Be9/h4wAKTr4oNtzhep
	 5pCnlOTTq4SHQ==
Date: Tue, 10 Mar 2026 20:20:24 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
 Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Saeed Mahameed <saeedm@nvidia.com>, "Mark Bloch"
 <mbloch@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, Gal Pressman <gal@nvidia.com>, Moshe
 Shemesh <moshe@nvidia.com>, Dragos Tatulea <dtatulea@nvidia.com>
Subject: Re: [PATCH net-next V2 4/5] net/mlx5e: Report RX csum netdev stats
Message-ID: <20260310202024.0caa4ed0@kernel.org>
In-Reply-To: <20260309095519.1854805-5-tariqt@nvidia.com>
References: <20260309095519.1854805-1-tariqt@nvidia.com>
	<20260309095519.1854805-5-tariqt@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 9 Mar 2026 11:55:18 +0200 Tariq Toukan wrote:
> Report RX checksum statistics via the netdev queue stats API by mapping
> the existing csum_complete, csum_unnecessary, csum_unnecessary_inner,
> and csum_none counters to the csum_complete, csum_unnecessary and
> csum_none fields.

The doc doesnt say clearly but I'd assume this should also count wire
frames for consistency with the Tx one

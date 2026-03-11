Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FD093370E3;
	Wed, 11 Mar 2026 03:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773198850; cv=none; b=s9znsHkuRf7YUjk8brEkdlLlRhaGw2++UdAnm5xH6+2mm1iOhKif3QUXmQGD7kdN7K2j3ZVV/x+pFqD7Mkf/tK71kxx4XZQESUBrs20IqKPN8cH+zAg8yYCkJg9lXc6ZiHq0SBhyrX4ZzxM4EEtBrFdSKVAKuwH0OkH7wRSrA/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773198850; c=relaxed/simple;
	bh=Cv6cvOncyse8qx+73yaDQz3wyF1bkScNu1OqBfXJ6yg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Dyle3ttcrmGTKYdHU5L3uMUO1zlL0PKiiRM7iaGsS2mnQXS7Z2DxUZGGSTvG2jfXH4+lttRmk/DrxwwRX8O+TS+v6jxmqnp73wsZmV/GMxtyW2PubhxW0/cifHFiy1DKTvUL/RlBVfiZIaS5nQY3i0HjCrp/tGGqbcdan6xwHnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yodp+ZHG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yodp+ZHG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44EE2C19423;
	Wed, 11 Mar 2026 03:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773198849;
	bh=Cv6cvOncyse8qx+73yaDQz3wyF1bkScNu1OqBfXJ6yg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Yodp+ZHGqQdeH9Ft5cHpYAXT7PA7gqpI9M2YD5t77cwqLj140TbnfvvLDLNGPJvWe
	 DsJYMCNzgbdhCmapxSluf8HV86q6qksOe+KsvlJLQlfxLi7pmGW51enOVBG6x3bJ/V
	 Ak7zg8pPt2WRvfztQtWRKbIUxFEy+zt2TwUM28zHNUBbNlXivS5RqUdEYyjafA3ER+
	 ES/1nTR75td59+wsd1BIT+fUKT6YITQZngC0tWYA1W+W6cSLjfmAo8u1gbiL0QvZHQ
	 Yw80ukNLKK5bawxCw6seUueCNh/kKBM67xh8qq5Seq7tUkk2K5PAkDlYekaoNrRTBP
	 k/kFfjyCR1AUA==
Date: Tue, 10 Mar 2026 20:14:08 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Tariq Toukan <tariqt@nvidia.com>
Cc: Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
 Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Saeed Mahameed <saeedm@nvidia.com>, "Mark Bloch"
 <mbloch@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, Gal Pressman <gal@nvidia.com>, Moshe
 Shemesh <moshe@nvidia.com>, Dragos Tatulea <dtatulea@nvidia.com>
Subject: Re: [PATCH net-next V2 2/5] net/mlx5e: Report RX HW-GRO netdev
 stats
Message-ID: <20260310201408.363ea836@kernel.org>
In-Reply-To: <20260309095519.1854805-3-tariqt@nvidia.com>
References: <20260309095519.1854805-1-tariqt@nvidia.com>
	<20260309095519.1854805-3-tariqt@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 9 Mar 2026 11:55:16 +0200 Tariq Toukan wrote:
> Report RX hardware GRO statistics via the netdev queue stats API by
> mapping the existing gro_packets, gro_bytes and gro_skbs counters to the
> hw_gro_wire_packets, hw_gro_wire_bytes and hw_gro_packets fields.

This looks right now:

Reviewed-by: Jakub Kicinski <kuba@kernel.org>

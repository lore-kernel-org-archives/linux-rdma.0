Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28053423A79;
	Fri, 25 Sep 2026 18:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790362111; cv=none; b=aDU9V8iuzbnlJjOQ7ygGwXtaqI5JcmXljv+F7jq5tY5mgglDiBeqPDG3wysQRRJLBX7UDUfAPmYV1/+VanoNtGrGZORbgDsmwVo7tKYNekQALqg3Qz9agh3fmA8xRpbqjvwNgqSWwIZYUwrBX9e350zR0EWgaMwyLQUIP+WCyGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790362111; c=relaxed/simple;
	bh=NN8HMG3CJkBLmP2lCORwewNsyyr3V5NeSaKxoGI99z4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZuvXlYrqdjxpeNRH+bLfCOkwJGxa/yui5mBh4DyGlFVLKJNgBtf40z5tCqiCs3hNzP7G7AAEYoSj9oOdkq8VXxsfw6YUH0Gbvyol92BA9iB4Cmrafj2PaX9xpCajt8JlDww3lgukcVqzD75mRZcb0pP9XeqZdvAvAdOPsfJhr+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fh3ky6Wh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fh3ky6Wh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76BD71F00898;
	Fri, 25 Sep 2026 18:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790362106;
	bh=UUghsFTVrlc+3PZSfcRcNdNfaaDOYSLWokuXgaIKoog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fh3ky6Wh/lurU9omv/ABZLCvKkQ9gncwgcKazVzHeaGfddaymKjEAN5vT6gDyXkZc
	 b3RCVXYrSsKbYRSXtyGyyPtOqMtV/n2fIl8sVzWb89m6CuoItDavDFQmPLLSFQmQvi
	 tSw5EvcGM9EPYOBeCyKrvmCH47R/XWc7zW22sP3HG19VN97BxhXpBqum6IMUZYBsAM
	 KxSpy9I6L0/fUFdja4SeMlLh8CwKYBi0RALTBI5HakyFk3v77BwC1I8ppTUqWuO6L5
	 3cXW3WmIa1rx6QQmo3GSAHYMPs0nl0a2icsNOwAmttERxlQVmeaUCSqXK0AJM61+qc
	 UWX9cPUoJ1LMg==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	Artem Dinaburg <artem@trailofbits.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Roi Dayan <roid@nvidia.com>,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jianbo Liu <jianbol@nvidia.com>,
	Vlad Buslov <vladbu@nvidia.com>
Subject: Re: [PATCH 6.1.y] net/mlx5e: TC, Fix internal port memory leak
Date: Fri, 25 Sep 2026 14:48:00 -0400
Message-ID: <2026-09-25-daily-reply-0008-re-mlx5e-int-port-leak-6-1@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260924173505.87763-1-artem@trailofbits.com>
References: <20260924173505.87763-1-artem@trailofbits.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> [ Backport to 6.1.y: this tree already releases the primary flow-attribute
>   references in mlx5e_tc_del_fdb_flow() and lacks
>   mlx5_free_flow_attr_actions(); release only cloned post-action attribute
>   references from the corresponding free_flow_post_acts() cleanup. ]

Queued for 6.1, thanks.

-- 
Thanks,
Sasha

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7338C800;
	Sun, 25 Jan 2026 19:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769369880; cv=none; b=fhRgNkbpWsLhFeAFFgAfD/Z9QK+cHOrBxVXZwPpVGyjjhZlelWy55uqY9ggw6gg4hVnXLyH6XneAaxPt9V6sUNCKW64QAAPmyNGJy0wLzu30zPLhPXB2z0Q1EL4UPpdvUCivYbTGXZYSm548qEQLg8IB35ByikSPrd0G5TRWV/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769369880; c=relaxed/simple;
	bh=CJJoAyHycnWBHWJ3K9UH9JsSF4QzEnlHxtNRXEkKYF0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AH31UiTV9zVIa6za7tOoh72VsZa+2QhB/TSWMWr3+O12Df6gMrzD/K0+7I4OOe0QGP1nN+wTMl14Putn8BwKMmKzJpk3rVJcTz4fYdLTrHCd7wREd5lVqebORuz8AXOqkHqQTwmFmUZexME5zSBvyqBbPVloR5AXSWBnZvvmwfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EW91Ki1b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EW91Ki1b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B0D6C4CEF1;
	Sun, 25 Jan 2026 19:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769369879;
	bh=CJJoAyHycnWBHWJ3K9UH9JsSF4QzEnlHxtNRXEkKYF0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=EW91Ki1bnyV6hL0gLSqe0lWMgwVzGSEO4FxhMWUnXMJUxea7tCXNpnWQtApwfQsQz
	 hXX+wKr1b9LhB54vNjlPyKAUT8zMLomBW7pBDjFm/C45EE4TZN/iQ9ABQo52rBYGEA
	 bBjygq4DfWF0iZEbaon9lr3xXRrPyxqPKQA21ynK3QScoof5Ae+PR/nw4A8T8bC5Vr
	 qBWPVTdJkJUBRaZZfEY58mWZCorDxb2GGvdNYTeB48vhxHWsj6JhL23obe5FdjbIFC
	 pnEQ5wZDzrLsEvtzNMpcFqqVNbK65jGwK/QTWTxOV0itRjxTwgfB7lP4zy302fhCAf
	 rmI42ODIOJDLg==
Date: Sun, 25 Jan 2026 11:37:58 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alice Ryhl
 <aliceryhl@google.com>, Boris Brezillon <boris.brezillon@collabora.com>,
 Christian =?UTF-8?B?S8O2bmln?= <christian.koenig@amd.com>, Felix Kuehling
 <felix.kuehling@amd.com>, Leon Romanovsky <leon@kernel.org>, Steven Price
 <steven.price@arm.com>, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Simon
 Horman <horms@kernel.org>, linux-kernel@vger.kernel.org,
 amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
 linux-rdma@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 7/7] netclassid: use thread_group_leader(p) in
 update_classid_task()
Message-ID: <20260125113758.0f985df0@kernel.org>
In-Reply-To: <aXY_4NSP094-Cf-2@redhat.com>
References: <aXY_h8i78n6yD9JY@redhat.com>
	<aXY_4NSP094-Cf-2@redhat.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 25 Jan 2026 17:08:00 +0100 Oleg Nesterov wrote:
> Cleanup and preparation to simplify the next changes.

Acked-by: Jakub Kicinski <kuba@kernel.org>

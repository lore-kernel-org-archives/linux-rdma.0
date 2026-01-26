Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50A4E28468E;
	Mon, 26 Jan 2026 20:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769460833; cv=none; b=iDHn90tN4tsbr9EAMMVwSpz6w1SuIz7sIJE4guiRhA3LZQ2NKyICwA++G1JsrdReGRIMgq1AzGhV0qHkT94QU/dw0eHcuWYtbVujqPE5qVG58jL/BjLFS4Sw4Dk8wXbyKDTQIp0ig9Fj22WB7y2GPuQY4z0XRnKzENvPZ34tgao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769460833; c=relaxed/simple;
	bh=ZkVC19EcWjzRyzhGeVyU0HVhaWtsPYiZcmh7SBkhL9Y=;
	h=Date:From:To:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=BspN8+7MFoo/T24WAK66fkXFp76VbsRxac8WTLqI9jwUEVIEkxXXKcganG9ypFN3mj/UTiZQ236GY0tvka6Zw45wUGfSgC+kawa39/jhmhSzxjfpdHR1/kE+3lGbMHRvleCCeHAxXvzCJsuUs/ZPlH5oLOVza/4tyq0qmJOgf0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=a1Z9bXqs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="a1Z9bXqs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71F59C19425;
	Mon, 26 Jan 2026 20:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769460833;
	bh=ZkVC19EcWjzRyzhGeVyU0HVhaWtsPYiZcmh7SBkhL9Y=;
	h=Date:From:To:Subject:In-Reply-To:References:From;
	b=a1Z9bXqsW6/8QsTFKbpvMfNXqGLf83193758PdiK30NCP+VBrlwXKWu8MU6cV2su8
	 IoGX80kQF1RlWnEfQoTrjW2G8sObZjTqZ2IvfKjSMznUlG/QDVAT8x8PjmX9uCohJT
	 eYyf9B2FKyClREY172247orNQ+rtN1jXSme8PT5c=
Date: Mon, 26 Jan 2026 12:53:51 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>, Alice Ryhl <aliceryhl@google.com>,
 Boris Brezillon <boris.brezillon@collabora.com>, Christian
 =?ISO-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>, Felix Kuehling
 <felix.kuehling@amd.com>, Leon Romanovsky <leon@kernel.org>, Steven Price
 <steven.price@arm.com>, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo
 Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 linux-kernel@vger.kernel.org, amd-gfx@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org,
 netdev@vger.kernel.org
Subject: Re: [PATCH v2 7/7] netclassid: use thread_group_leader(p) in
 update_classid_task()
Message-Id: <20260126125351.9a818b427293617533db114a@linux-foundation.org>
In-Reply-To: <20260126125048.323a281527fb2554c96f40bf@linux-foundation.org>
References: <aXY_h8i78n6yD9JY@redhat.com>
	<aXY_4NSP094-Cf-2@redhat.com>
	<20260126125048.323a281527fb2554c96f40bf@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 26 Jan 2026 12:50:48 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Sun, 25 Jan 2026 17:08:00 +0100 Oleg Nesterov <oleg@redhat.com> wrote:
> 
> > Cleanup and preparation to simplify the next changes.
> > 
> 
> "next changes".  This is the final patch?

Ah, sorry, [0/n] explains.  I'll make that "planned future changes".

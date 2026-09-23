Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8C11498904
	for <linux-rdma@vger.kernel.org>; Wed, 23 Sep 2026 10:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790160014; cv=none; b=ElKkIkecq72GqT3AX9BkF/7s9DSNGxuFVBLh4qnUC23hvxlsDTZmiNYCIjatIK8/4+bnQmY17RCgFoJVwnDmef7zpGbHVflYoTWmtATZtQccqkG7mVWcGK1bE2yEIAU4zUPzJqUvxi7Q5QTIsQT79E0Y+KXb6ZxWu7nCLyvUm6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790160014; c=relaxed/simple;
	bh=jtuqoDJCzIoAQLn+kR68txH9dfjrrjglN6IZaPW/NgI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OSOQRoFC7KAHZetegZ+KbIvizoXeP64N0mH28JMUsDEYj9uYdaVGhZvm6PHjPTw1lZUlRqIbXf4a2rusR0szZFd2liVXSlWR+U33qKh9e3aGlnbGgTrs4sJ7/N6sGTD4rATUC8Z5nIaDlFzlf12KucgPtDtkqUcez3q5/KRKQoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WHj2Tpfv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WHj2Tpfv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2A331F000FF;
	Wed, 23 Sep 2026 10:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790160006;
	bh=MNqLhjtQA+dfHcMUT6GjhHrPC/peTdagxqUPxrcde9w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WHj2Tpfvyh/QJbQ8g8kCjuvf8HiSG7OAnndDoIOft91TQK23dHMy+gWMRc0pIs5WV
	 SzXSWhUnaS7TUnxMqi20ptbEaWxuvrIbIvjF7/9hdp0W2rHwSHxxTKhztE8Hkm84TY
	 o6EUQs7JlTERvbzr7YPUWghff9SEClK9+rP8XQXmG8vXgfwBbXj98FSGWvCTSx2lzn
	 BLmN5IMLfkg7idw0l0pCwfxE8fkkaeu/kNiUG4I+uXlDQJ1asywqVm0kJVFyyzMldJ
	 EBzF1ooqjt8rBRm4jseOUlTDonUqUJ2iacq9/iiIaTRoqEKJQhhOS92qqFVigOeeIM
	 Srnwe809cb73g==
Date: Wed, 23 Sep 2026 13:40:02 +0300
From: Leon Romanovsky <leon@kernel.org>
To: lirongqing <lirongqing@baidu.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Kees Cook <kees@kernel.org>,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH] RDMA/multicast: Fix rb-tree corruption on MGID
 reassignment in join_handler
Message-ID: <20260923104002.GO563127@unreal>
References: <20260917052012.2181-1-lirongqing@baidu.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260917052012.2181-1-lirongqing@baidu.com>

On Thu, Sep 17, 2026 at 01:20:12PM +0800, lirongqing wrote:
> From: Li RongQing <lirongqing@baidu.com>
> 
> When the SA assigns a wildcard (mgid0) join a concrete MGID that already
> has a group in the port table, join_handler() erases the group from the
> tree and calls mcast_insert() with allow_duplicates=false.  mcast_insert()
> then finds the existing group and returns it without re-inserting, but
> join_handler() discards the return value, leaving the group erased yet
> still alive.
> 
> When the orphaned group's refcount later drops to zero, release_group()
> calls rb_erase() on the node that is no longer in the tree, corrupting
> the rb-tree (a stale parent pointer causes a valid subtree link to be
> overwritten with NULL).
> 
> Clear the node with RB_CLEAR_NODE() after the erase in join_handler() so
> release_group() can detect via RB_EMPTY_NODE() that it is already out of
> the tree and skip the second erase.  A successful re-insert by
> mcast_insert() restores the in-tree state via rb_link_node().
> 
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> ---
>  drivers/infiniband/core/multicast.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)

I'm not sure whether this change makes any difference, but at least it is
harmless.

Thanks

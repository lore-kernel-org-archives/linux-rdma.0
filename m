Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2EF4385D72
	for <linux-rdma@vger.kernel.org>; Sun, 13 Sep 2026 03:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789271440; cv=none; b=KjOHN8m3GaBfCYR2GVMnfANRcW+G/aIwXHB+nwH0ZTA3RBhU2Z0/J/aQsaMAPOJhBHO4r+aVjNfJokxaHNprQZrekbgnN+8FaQuKu36+XoMZlZ6aUBdZNLDwkK4yaoMzM023GkBATQkL6InqFMD3gnuiglaRR9q3bF3Hgi3kVW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789271440; c=relaxed/simple;
	bh=gLhiKrB+/KJzt9QBtClREBpLjOv/bSkh9r+/9PzO36A=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=fOcTV2WAFHj7z5J1ylArI5+f9cwO3ssSEnEMQj5t+mJiwqAX83yTLiIU5vVh4A/0YZBX/475nRhJVPDkyFwnD54A2iyzQisHDLlMMH1rcOQK4kTqvKdpXBP2LC6MQJ+pQpGxIQktTn6X4qbBHyIHdj+GmFM+tVgj6FjV7e5eG34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kqQn0aPu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kqQn0aPu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 766A01F00893;
	Sun, 13 Sep 2026 03:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789271439;
	bh=fIs/xbea+fr2WKpPOVe7l3XGhTVWg+CALwrLdD/hIWY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kqQn0aPuNv3uC7OncLx8uRfUjVxfri+w6ipwOYNHcxqmCtHnvvSFoJpzMYNVPW5xZ
	 oKrgVypWUYk9ht2S6PNt/1MZ5ZUeDZXnw9wyWP3IFHGR2V6GhSoAWgDOfmVgCH6dwc
	 ScCq99xN5FwkkfZHh6QpOVhq1ODsCo6FsaSGDS091rAUoJmsiVryW9mE+GIPJ5VBGn
	 mqz7MffjJCJnX/ZuJtdItWfrtPGE+HMAKwAjKt62WyPWRKywxZ9JsasoLQlELf1vYK
	 IfRN3JokpkT8yc837ZzqZoGYRKoSI3wbpsu6YRA1klebJhHbPPdQzAD4LVDZmEoY3A
	 JzSQmoGu7vqZg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v2 5/9] net/rds: unlink transport nodes before
 a possibly deferred connection free
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260912035027.27447-6-achender@kernel.org>
References: <20260912035027.27447-1-achender@kernel.org>
 <20260912035027.27447-6-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 13 Sep 2026 03:50:39 +0000
Message-Id: <20260913035039.766A01F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] rds_ib_destroy_nodev_conns() uses list_splice() without reinitiali=
zing the source list, causing a use-after-free write on subsequent resweep =
invocations.
--

commit cee612cc1485655f9584ac5a60a9a25e2010e66b
Author: Allison Henderson <achender@kernel.org>

net/rds: unlink transport nodes before a possibly deferred connection free

This patch updates RDS transport teardown helpers to unlink nodes from their
stack-based temporary lists before destroying the connection. This prevents
a memory corruption where a deferred connection free attempts to unlink a
node from a stack frame that has already disappeared.

> diff --git a/net/rds/ib_rdma.c b/net/rds/ib_rdma.c
> index db7e92e7bd29f..b30f2a3715878 100644
> --- a/net/rds/ib_rdma.c
> +++ b/net/rds/ib_rdma.c
> @@ -168,8 +168,18 @@ void rds_ib_destroy_nodev_conns(void)
>  	list_splice(&ib_nodev_conns, &tmp_list);

[Severity: High]
This isn't a bug introduced by this patch, but it existed before and is not
addressed in this series. Does this list_splice() leave the original list h=
ead
dangling?

If rds_ib_destroy_nodev_conns() is called multiple times, such as when used
as a resweep callback from rds_conn_wait_conns_freed() during module unload,
subsequent invocations might see a non-empty ib_nodev_conns list because
list_splice() does not re-initialize the source list.

Could splicing this list again result in a use-after-free write to the prev
and next pointers of nodes that were already moved to a temporary stack list
and potentially freed? I notice rds_loop_exit() explicitly calls
INIT_LIST_HEAD() after splicing. Would using list_splice_init() be safer he=
re?

>  	spin_unlock_irq(&ib_nodev_conns_lock);
> =20
> -	list_for_each_entry_safe(ic, _ic, &tmp_list, ib_node)
> +	/* rds_conn_destroy() can return before the connection is freed,
[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260912035027.2744=
7-1-achender@kernel.org?part=3D5

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1169471CE0;
	Wed, 22 Jul 2026 16:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784738619; cv=none; b=BFN0yBoHLxtvLaPrFvGr4V67a12cQ1di5Hdymtz4hyRulmc+z0R3WCiZXzVzMvx32YcfiYAL2ieeAmfi7RZRzZU/0K6Mmy7rPA4Zsp0DKD+NlcKpyipOsWifbmahivLi4/eRGGVmQxbGt6yRkTAMRarJXOy6Bsq17gQGuCllI9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784738619; c=relaxed/simple;
	bh=gJkURQCOVzI7lkeJgt+8mzsvy58CAm30VZBGbLrhjIk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DfkfAxPAtdhS5pYp0xfHMyic+QzSr4G6psqt4Mb1f9WQPFVCtjyRIvnxcNHeGVwpcQqsdbhFiVgzcv5+w3Spx6hVMFqdExzTiGXyNfpgt3tIvBHHZ2l7dWNRIErzVUd89z67Z+w6FsBsVY/9moWmxOK6XXECEQ2eUzVbGnUGaAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=juSHltyd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="juSHltyd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2C5D1F00A3E;
	Wed, 22 Jul 2026 16:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784738611;
	bh=eBijEh6r8DvA8nH2cSmK9mqCysBg63obFVfe+bDLEQI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=juSHltyd7rIUEkt/WZMc0t0qmThY/ii2tjI2FgqmrNSmgOCTWYCLJXt0iVbUQQUX6
	 9MDmc7SM/BjqITYsSGuXljSeFt1ezTgDzDzgqmfQYVieNOIyM+VPLxM5Zi/QCiVJnP
	 gYAgirDXhZEtz3Hk/63eyEdTgsSYTEg4e5ikM9tirCJjdXi2Lbrp0yqFGVlEhEeNAj
	 J/ovGwNYqSKJHqnozm5D5lIwtsty7mfE+nr0/EnQyykoModp3/xaY4ToLEOHh5yepL
	 ZGptGzqrOyh1iYSCKhPxJaFmd8jKz38T2LkU5Byr5dUzvHGIdVeapzpERQSVjdk6cD
	 Av2EwC8YRf8zQ==
Date: Wed, 22 Jul 2026 09:43:30 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Allison Henderson <achender@kernel.org>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, horms@kernel.org
Subject: Re: [PATCH net 1/3] net/rds: don't use
 unpin_user_pages_dirty_lock() from atomic context
Message-ID: <20260722094330.0486c26c@kernel.org>
In-Reply-To: <20260711025118.2449428-2-achender@kernel.org>
References: <20260711025118.2449428-1-achender@kernel.org>
	<20260711025118.2449428-2-achender@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 10 Jul 2026 19:51:16 -0700 Allison Henderson wrote:
> rds_rdma_free_op() and rds_atomic_free_op() are reached from the IB
> send completion path via
> 
>   rds_ib_tasklet_fn_send()
>     rds_ib_send_cqe_handler()
>       rds_message_put()
>         rds_message_purge()
>           rds_rdma_free_op() / rds_atomic_free_op()

Sashiko points out that this just moves the problem to the filesystem,
which also may have mutexes:

  Does calling set_page_dirty() from softirq context introduce a
  potential deadlock?

  If the user pages are file-backed, set_page_dirty() will route to filesystem
  dirty callbacks like filemap_dirty_folio() or block_dirty_folio(). These
  callbacks acquire non-irq-safe spinlocks, such as inode->i_lock or
  mapping->i_private_lock. If the tasklet interrupts a process holding one of
  these locks, could the softirq spin forever?

  Additionally, does calling set_page_dirty() here without holding the folio
  lock or an active file reference risk a use-after-free?

  If a concurrent file truncation removes the page from the page cache and
  frees its mapping, and set_page_dirty() reads folio->mapping just before
  it is zeroed, could it dereference a freed pointer when calling the
  dirty_folio callback or __mark_inode_dirty()? Should this work be
  deferred to a process context workqueue instead?

Is this not true, or not true in most cases? Otherwise we should find a
better fix?
-- 
pw-bot: cr

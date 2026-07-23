Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E866326D55;
	Thu, 23 Jul 2026 06:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784787253; cv=none; b=btCWxw3dpThdU+9DI8MUewt8kDI/oMM40zFgrXv63rDkayXnN6B7ntq1MxsJzPwrIb3b+9oEc7h6LBxqRiiYYdtG5IyWgMjsQi8RT/0OSvNdMrhtoSbvf0LHAlB69q4Fi0nYc/iGam9t19Vf1KLiubLY7hpxZTKlmRnsd8EQ180=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784787253; c=relaxed/simple;
	bh=/m0FBXPE+D/plQKk8zEUT9sWzugq2uCOYDO5I7oW5k4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Scw1in/wap282Q3wcKIo+HE236xxCd/FRVRGrw32ePPlfxUBTuNptNYoHve05D7BiNw06GFwVRfU7l0K9GGsyQMeIavnkpcadPn+lhwBy7ElOSBZx/d3ByPotFcLJitCP2C+xXUffXENWuurzYQ5GBeYhU/sYZKI0TOlixFoiPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TwNQ7X10; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TwNQ7X10"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B45F1F000E9;
	Thu, 23 Jul 2026 06:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784787251;
	bh=9/tqbs6tenY/umv8FiyDc6kPp79zyuQiPNrAaQpcaPU=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=TwNQ7X10r6lrcakXNKwhQcY6XEqI/c+3BVpgff623P8PFu8c1nv66mXXqUn7+r0iP
	 1DpJvCEhITql0Ui3LSnTz88sv5bYfevm7u1JBHDOt7ZDry2rtXRwm5R12bf7anMusy
	 GjZUUfU0TX3oSI1bkMHE6/do4UaO/FHiELzGhrnwX8MwZibRqkNkHk7X7I4YwyFC+v
	 u2zWLnrIt/l8P6YHA86RA5jeS7C9k5JO+1N/o9XOz9oUHrS6Tti1158y9wgOqdbRni
	 288lYCShJWTdIYdLckuwXlRUOcs0dLvzzFwJ2rXu3wy6m3gClSERLav8UEgFpUDHZB
	 YrvOmk9Y3pngA==
Message-ID: <be0e47127d3f6081f05b0039d59d79d5b217bb4f.camel@kernel.org>
Subject: Re: [PATCH net 1/3] net/rds: don't use
 unpin_user_pages_dirty_lock() from atomic context
From: Allison Henderson <achender@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com, 
	edumazet@google.com, horms@kernel.org
Date: Wed, 22 Jul 2026 23:14:08 -0700
In-Reply-To: <20260722094330.0486c26c@kernel.org>
References: <20260711025118.2449428-1-achender@kernel.org>
	 <20260711025118.2449428-2-achender@kernel.org>
	 <20260722094330.0486c26c@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2026-07-22 at 09:43 -0700, Jakub Kicinski wrote:
> On Fri, 10 Jul 2026 19:51:16 -0700 Allison Henderson wrote:
> > rds_rdma_free_op() and rds_atomic_free_op() are reached from the IB
> > send completion path via
> >=20
> >   rds_ib_tasklet_fn_send()
> >     rds_ib_send_cqe_handler()
> >       rds_message_put()
> >         rds_message_purge()
> >           rds_rdma_free_op() / rds_atomic_free_op()
>=20
> Sashiko points out that this just moves the problem to the filesystem,
> which also may have mutexes:
>=20
>   Does calling set_page_dirty() from softirq context introduce a
>   potential deadlock?
>=20
>   If the user pages are file-backed, set_page_dirty() will route to files=
ystem
>   dirty callbacks like filemap_dirty_folio() or block_dirty_folio(). Thes=
e
>   callbacks acquire non-irq-safe spinlocks, such as inode->i_lock or
>   mapping->i_private_lock. If the tasklet interrupts a process holding on=
e of
>   these locks, could the softirq spin forever?
>=20
>   Additionally, does calling set_page_dirty() here without holding the fo=
lio
>   lock or an active file reference risk a use-after-free?
>=20
>   If a concurrent file truncation removes the page from the page cache an=
d
>   frees its mapping, and set_page_dirty() reads folio->mapping just befor=
e
>   it is zeroed, could it dereference a freed pointer when calling the
>   dirty_folio callback or __mark_inode_dirty()? Should this work be
>   deferred to a process context workqueue instead?
>=20
> Is this not true, or not true in most cases? Otherwise we should find a
> better fix?

After a bit of digging, I think its uncommon, but true.  I'll see if I can =
find
come up with an alternate fix.  I think we can use a work item to defer the
rds_message_purge() when needed.  Then the worker can use the correct locke=
d
variant unpin_user_pages_dirty_lock().  I'll send a v2 when I get it worked=
 out.

Thanks!
Allison



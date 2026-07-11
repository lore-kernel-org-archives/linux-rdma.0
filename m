Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F9304499B4;
	Sat, 11 Jul 2026 05:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783748770; cv=none; b=u0iNxxxeFpZvGA3hKOz8ORjkzhEjPRryUa0/q6mhPoAskxKNYi936Au1YwVkWyruR/xnkYygZosxHxJ53L1PGNM8TpvvAxZIxHNfEIzbDOSwVu0YJX7p4PPpIYUPS4EC9zP5qLu9En5AJYMVugWbbofSP32ee0GOadMv3jScd/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783748770; c=relaxed/simple;
	bh=f5jTLoe3Zo1gc5ZUKEpY3XEPQiWZo5Y531JTyQooH8M=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=kKx1hxY/E/dt5WNvdLytiZIWspUxsJUFIUDQ53Lv002AVPXPqDEBJ73U5gopdSXwUj+kkiT5v0/kkLPI5/0iykpvnDttUXAdXIXhxsmmjRpAY5mr9SAhCeopnVfH32enivKJxKAhntFzWqlbpkdv71HOZmHI7zB0lI8NhlCwKEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QgCET+Tx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QgCET+Tx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBB7E1F000E9;
	Sat, 11 Jul 2026 05:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783748768;
	bh=EaiPorL9ahIoJjJNitVwjgM9ztVnjvN7foqXLiq04lM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=QgCET+Tx8Bz0jrdks+rAbU8mUQHeVPcVhmNjnY9QEy3j0IQt8dtIhIBSKEh+5N9As
	 WQNaEldSNdp9DDaqnyfla/F2QwjYqb48w5VbRYV51VDzIlmiP+A0SWtLpP3PLpBuAV
	 qLAHT72ptNutim6kRtqCLNoKDrjqrESrQiMjB/7M=
Date: Fri, 10 Jul 2026 22:46:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stanislav Kinsburskii <skinsburskii@gmail.com>
Cc: airlied@gmail.com, akhilesh@ee.iitb.ac.in, corbet@lwn.net,
 dakr@kernel.org, david@kernel.org, decui@microsoft.com,
 haiyangz@microsoft.com, jgg@ziepe.ca, kees@kernel.org, kys@microsoft.com,
 leon@kernel.org, liam@infradead.org, lizhi.hou@amd.com, ljs@kernel.org,
 longli@microsoft.com, lyude@redhat.com, maarten.lankhorst@linux.intel.com,
 mamin506@gmail.com, mhocko@suse.com, mripard@kernel.org,
 nouveau@lists.freedesktop.org, ogabbay@kernel.org, oleg@redhat.com,
 rppt@kernel.org, shuah@kernel.org, simona@ffwll.ch,
 skhan@linuxfoundation.org, surenb@google.com, tzimmermann@suse.de,
 vbabka@kernel.org, wei.liu@kernel.org, dri-devel@lists.freedesktop.org,
 linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH v8 4/8] mshv: Use hmm_range_fault_unlocked_timeout() for
 region faults
Message-Id: <20260710224606.69235ab5c49b5987fd33e924@linux-foundation.org>
In-Reply-To: <alG1JwgUK44dCiN4@skinsburskii>
References: <178371866223.900500.12312667138651735591.stgit@skinsburskii>
	<178371881034.900500.5214601525971121683.stgit@skinsburskii>
	<20260710151216.0397a6f9ac5c7b4ccd274cc1@linux-foundation.org>
	<alG1JwgUK44dCiN4@skinsburskii>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 10 Jul 2026 20:14:47 -0700 Stanislav Kinsburskii <skinsburskii@gmail.com> wrote:

> > > +	mutex_lock(&region->mreg_mutex);
> > > +
> > > +	if (mmu_interval_read_retry(range.notifier, range.notifier_seq)) {
> > > +		mutex_unlock(&region->mreg_mutex);
> > > +		cond_resched();
> > > +		goto again;
> > > +	}
> > > +
> > 
> > If the calling process has realtime scheduling policy and either a)
> > we're uniprocessor or b) this process and the holder of
> > interval_sub->invalidate_seq are both pinned to the same CPU then
> > cond_resched() won't do anything, and this might be an infinite loop?
> 
> Yes, looks like it might.
> What can be done to prevent this?

Well the best way is remove the polling loop and use a proper sleep/wakeup
mechanism - mutex_lock()/prepare_to_wait()/etc.

If the polling loop is to be retained then maybe msleep(1) or
usleep_range()?

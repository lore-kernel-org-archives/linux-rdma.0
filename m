Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AB5C219FC;
	Wed,  4 Mar 2026 14:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772634164; cv=none; b=am7Aionap3vNeoWvXoihOAPMAxNfObTH7Qv9hb/+py2FhRoUqDQRInRTxAj/8t0UWi5eL7GK6GOgrvCgtBQ3GodsR6i+6HsCa5Y/xMCWTzjwxsvF+3PTvTlIQcvuBe3DBnVMnABN0wFxaNSsegZ3OTsddi4/j6ERuXZT0IuPXgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772634164; c=relaxed/simple;
	bh=qqa28W6cf2h6smxGsD1vyO/h5OoDsQRQWZhIDTKRTCg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FvKBp/Qda10Ost8uXDi34rkH1PwkE1fwc5FBU2T2mn0QTRUqG9a51eFMy2fJu/P/Pg8AwmGA2XVk3ub2/REyledPCv4fQVcVWq/qcSk1aO9E46UaD51TUl79gn0uXdXtBcwu0HVrgJtIkcUaLmVWzl6zo5LP0Lo5GQmQ1OZQ7BE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a95zK3AP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a95zK3AP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48212C2BC87;
	Wed,  4 Mar 2026 14:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772634163;
	bh=qqa28W6cf2h6smxGsD1vyO/h5OoDsQRQWZhIDTKRTCg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=a95zK3APCNfELTqFrcOT95XO/T9uB43o0ivEX4NPLG4QJPvWuApniLVKaoSx+FBt/
	 dMdk3WhDhT3au4Z+11tYJj6zjV7qMPLua0BacXRcj33ievc7o4guZiaaBNIil/brM9
	 BmkZ2a0vvr9lJcsb5aNoQ9+9PN8IbI+SX/lyjhWPnOzfUR92NtiZsbs4Te1VsG4mjD
	 wYfsz/8SjvAS4dJXnlC6NM4dB7s0mYLjtLpW5W67M69x3cV4k1SOOy5TbBTpG8yW/+
	 B7wPlwiN042wej51FNOsCcC9fKu8vYzc349mhS+Do1sBdzl1aOVD3BhMYuwAAAlJXk
	 4ZHhonDthmhmw==
Date: Wed, 4 Mar 2026 16:22:39 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: syzbot+53cf317e7803e4ef2f33@syzkaller.appspotmail.com,
	syzkaller-bugs <syzkaller-bugs@googlegroups.com>, jgg@ziepe.ca,
	linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [syzbot] [rdma?] kernel BUG in ib_device_get_by_index
Message-ID: <20260304142239.GA12611@unreal>
References: <69a27146.050a0220.3a55be.002e.GAE@google.com>
 <14d97798-6cfa-4c2a-b1ab-391e4b823b1d@I-love.SAKURA.ne.jp>
 <20260302191705.GR12611@unreal>
 <6014ee8b-382a-4fe8-81de-74a67595f585@I-love.SAKURA.ne.jp>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6014ee8b-382a-4fe8-81de-74a67595f585@I-love.SAKURA.ne.jp>

On Tue, Mar 03, 2026 at 10:38:17PM +0900, Tetsuo Handa wrote:
> On 2026/03/03 4:17, Leon Romanovsky wrote:
> > On Sat, Feb 28, 2026 at 02:07:46PM +0900, Tetsuo Handa wrote:
> >> Hmm, this assertion was wrong because ib_device_get_by_index()
> >> might be called before enable_device_and_get() is called.
> >>
> >> #syz invalid
> > 
> > I think this is a valid syzkaller report. As you correctly noted, the device
> > was inserted into the xarray database in assign_name(), but its refcount was
> > only set later in enable_device_and_get().
> 
> I was wondering why enable_device_and_get() is using not refcount_add()
> but refcount_set(), and I tried
> https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit?id=510cd4b7d46753b4bf0f57004aa7b53b91b2b25a
> in case commit 9af0feae8016 ("RDMA/core: Fix stale RoCE GIDs during netdev
> events at registration") unexpectedly triggered modification of ->refcount
> before refcount_set(&device->refcount, 2) is called.
> 
> But I concluded from this syzbot report that the reason enable_device_and_get() is
> using refcount_set() is that we cannot use refcount_add() because ->refcount == 0.
> 
> Therefore, it is safe to call ib_device_try_get() before enable_device_and_get()
> calls refcount_set().
> 
> > 
> > The proper fix can be something like that:
> > 
>           down_read(&devices_rwsem);
>           device = xa_load(&devices, index);
>   -       if (device) {
>   +       if (device && xa_get_mark(&devices, index, DEVICE_REGISTERED)) {
>                   if (!rdma_dev_access_netns(device, net)) {
>                           device = NULL;
>                           goto out;
>                   }
>    
>                   if (!ib_device_try_get(device))
>                           device = NULL;
>           }
> 
> Why do you want to make this change? Unless it is unsafe to call
> rdma_dev_access_netns() when DEVICE_REGISTERED is not set,
> refcount_inc_not_zero() from ib_device_try_get() makes the final
> result same (i.e. device == NULL).
> 
> Since enable_device_and_get() sets ->refcount immediately before
> xa_set_mark() is called, adding xa_get_mark() check does not change
> effective behavior.

xa_set_mark() is performed under down_write(&devices_rwsem) and it
ensures that xa_load(...) will return fully initialized device.

But yes, you are right, ib_device_try_get() should return 0 if this
device isn't set yet.

Thanks

> 
> What I rather worry is that refcount_set() is called too early if
> there is an ib_device_try_get() user who expects that
> device->ops.enable_driver()/add_client_context()/add_compat_devs()
> have already completed when ib_device_try_get() succeeded.
> 

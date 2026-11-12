Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794510593;
	b=wAichuU5BxvTcCSgVW4ac3i5I6nqDJlryX8bfcoTuMmrA/fbRuBZYSSjFJiRqSkRcA/p
	 j0py5bXw+xEEifaL3KAxogqdjUU63ak20VZEQihldDohj0o3zuHPceVC4Fz5y1KbKADjY
	 KoIv85Hs4jMBQ+W4aSXd1QwbTJhq+uB4uyzYcmVw3/4l38K5KEj6d5A8imodOYJWL+2IJ
	 CXqu/2fdX5BXSwI/MzCyxrIGzvhkJU8LwPl0l63rRx1kVH6Ecer3uNLVKg0i0Sa6miMW4
	 tIu6LS0l48nQuKT/AxllF9PTs6POD1ktBGE13cKBlMA122bAKe40AJX1Nw6yPooGjjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794510593;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=7vhYx+mU5ZE+8csctxhRGwodyAgV5iSIPIq1rC32lzs=;
	b=I5oPlzti9F3Lnu7W3vvjPotAgDjLO85FMGbrlTXUBkB/BfU/XQOKEHPDBC2RzZ0abylv
	 J609uO3THjEjQKz9cayaIQOP4eRUMbtDkLbGYqTdIpCTPQIi7D95oo+5ON0ax2eOBxNdD
	 9kn/Y2mzroX6jjZEJ4TSU5b33fhInKRIuuYwNyK6BxqWMyH8s5+vbOLT1SFUs6nKdsp/K
	 c/Slqt2CmBe3zREEE/D244VivlHrYy8zndJKjW5v5IlP4k6PloVW0qevDRvsMy9Ae79vI
	 Inn3brwbBGTQ/f6ikUxMRZH8Ou0XYINjHQ7QOFlzmLDVBn6xPfmYStN3kuooAYvQXmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=K6mPTIqZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88751606A8B5;
	Thu, 12 Nov 2026 19:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=K6mPTIqZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5DC41F000C5;
	Thu, 12 Nov 2026 19:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794510593;
	bh=7vhYx+mU5ZE+8csctxhRGwodyAgV5iSIPIq1rC32lzs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=K6mPTIqZ0PqdtRQ0N+/uG83Mvhc5SbmVq/c7r67irEj+eqMifCHccwFKgV3/nQTlx
	 O9ey+T/MGn53XOU2RQSKWCIZKqq1vmtThLfplc9IEG4tk1ALsBZuwhrc8BUCjEoryH
	 wFFXOMUbs1ODS++BgEpdVGqILTydG506R8ZGglXYmBDejlENdN67BGKHWuhCEv1z4B
	 rEzcsk/K4PHb3MKBt9KSukE8IvbAdcV8Bclho6AS1k6ArThMWAyBAZkRNO3qMq97zo
	 jVItj8fx6+yPwmqAQZomGfNgtPRqYWT0UPtFoiCfc7zTGTYtmu8EywezKmPBo1twwe
	 EJpV8om5RPyMg==
Date: Thu, 12 Nov 2026 21:09:48 +0200
From: Leon Romanovsky <leon@kernel.org>
To: =?utf-8?B?5p2O5bm/56GV?= <liguangshuo@mail.sdu.edu.cn>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, stable@vger.kernel.org,
	"Md. Haris Iqbal" <haris.iqbal@ionos.com>,
	Jack Wang <jinpu.wang@ionos.com>, linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: Re: [PATCH] RDMA/rtrs: Fix potential use-after-free on client
 sysfs setup failure
Message-ID: <20261112190948.GV8635@unreal>
References: <ddd08640709b149408b616c3eec8fee847af757e.1793455791.git.liguangshuo@mail.sdu.edu.cn>
 <20261109111652.GD8635@unreal>
 <APEA3wD5LFuJxkDei2Ikqqq4.3.1794229006784.Hmail.202321181@mail.sdu.edu.cn>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <APEA3wD5LFuJxkDei2Ikqqq4.3.1794229006784.Hmail.202321181@mail.sdu.edu.cn>

On Mon, Nov 09, 2026 at 08:56:46PM +0800, 李广硕 wrote:
> Hi Leon,
> 
> Thanks for reviewing.
> 
> From: Leon Romanovsky <leon@kernel.org>
> Date: 2026-11-09 19:16:52
> To:  Guangshuo Li <liguangshuo@mail.sdu.edu.cn>
> Cc:  Jason Gunthorpe <jgg@ziepe.ca>,stable@vger.kernel.org,"Md. Haris Iqbal" <haris.iqbal@ionos.com>,Jack Wang <jinpu.wang@ionos.com>,linux-rdma@vger.kernel.org,linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] RDMA/rtrs: Fix potential use-after-free on client sysfs setup failure>On Sat, Oct 31, 2026 at 10:14:46PM +0800, Guangshuo Li wrote:
> >> rtrs_clt_create_path_files() drops the path reference on failure, but
> >> its callers still close connections and free the path. This can access
> >> freed memory and free the path twice.
> >
> >Sorry, but how?
> >
> Consider an allocation failure while setting the name of the path
> kobject in rtrs_clt_create_path_files(). kobject_init_and_add() has
> already initialized the reference count to one when setting the name
> fails with -ENOMEM. The stats kobject has not been created yet, and
> adding the path to clt->paths_list did not take a kobject reference.
> 
> The error branch then calls kobject_put(&clt_path->kobj). This drops
> the only reference. With CONFIG_DEBUG_KOBJECT_RELEASE=n,
> rtrs_clt_path_release() runs synchronously and calls free_path(), which
> does kfree(clt_path).
> 
> Back in rtrs_clt_open(), the first statement on that error path is:
> 
>         list_del_rcu(&clt_path->s.entry);
> 
> That accesses the list node embedded in the path that was just freed.
> This is the use-after-free I meant.

The error handling appears to be incorrect. rtrs_clt_create_path_files()
should undo only the changes it made internally and error handling of
call to rtrs_clt_create_path_files() should undo what was done in
rtrs_clt_open().

Thanks

> 
> Thanks,
> Guangshuo

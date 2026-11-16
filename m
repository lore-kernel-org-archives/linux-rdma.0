Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794827185;
	b=F2z7/z1Rfh479F6u8MqzXxnAp+lCsoVA73hmwKaUxLINoNlX8siaoup75GYdABCVLzkl
	 7gdjCb1wEE4HwqJ40sVDr7AIUg5gknUXmJeThofiPzKIQsHqk5hz/1yi44B60FR//dfgJ
	 0N/9jG5faHH9A7P3Z3zeaHO8Wg3bU9RYOmsooVlk9owF5gD98oO+FFzhfT7cg+stNpBMF
	 zuMfRyqUtvPf4oAifuRs+YNCTeNMztjl1HIp+jt9jFepSk0h00UA+aJbaUSF5m5NZYyYs
	 lquFGUIu+5yr/epWXyGQaWVYv/o2JTkRhHUOpXQPUPSwx5FgHK58eBS4OOSfPz/FRHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794827185;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=bf/qERKTQweevSc8C6yvUdfbvod8V6ngryzEVo6Iqds=;
	b=ZQNg/MSGTwryJbVUgVLkNf/1JH8YqmYccCZX8Jx8tGXdPBJXjWyRGV2/RHrTu/14wIh2
	 Yxv7W7uE9yWcs2KZ1YlnMLQTL/gMaykyY3iXBoi6EpWCvIKy3xKuRmZuw5c3KMrrjltBQ
	 FV7HDy5Wbj5udoWmX5I/t2LUAV0p4tTr/zH9iawNkwqNVw4LFLMCT9NgKZyNGJnpgvpXB
	 nBgl/EYWjOHIn8F6zpcTfSwSY8+YOcVhBKJd48Fhb24qQYAhcFsx9M6B1YxLlWoWKtJk5
	 eIPMP0FXM008ctrkKQbTygrkA3bXIvBMqfQFVYlFEtEPq0vugM6j+4WpasF7JjRdIlg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kNBUFEUe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FF6E606A8A7;
	Mon, 16 Nov 2026 11:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kNBUFEUe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1B991F000C5;
	Mon, 16 Nov 2026 11:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794827185;
	bh=bf/qERKTQweevSc8C6yvUdfbvod8V6ngryzEVo6Iqds=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kNBUFEUezqyzGlIN4rmtHrloqOiGw0Vsb8niqHycdaMtSmiUEHrff4PN5giC4vZKM
	 dXm4vv+5olTThih9md+zRAhwU6ICeALF/vKeA9p56pb2tl+IUlf7TRro67DxcYSycL
	 l0fvDFbm2GpoMD/y9PeAtcwgxCZjoFczWMEFkGHqaTqH/QjikVHKwKbvbNRB94LVU+
	 x07He+rugp/coI5yksENdLCU1Bs0gQO7C959Yuydz2B621daNnTG3jQZRth9xbHiMD
	 wbmMFygs/pgMgz7yex34U8cDbQ6TR0vJ5V6YX7wch57BDKF0mBbQcrH5743sFd5Mae
	 KDDyJRu+Vs3pA==
Date: Mon, 16 Nov 2026 13:06:20 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Eric Davis <eric.davis@broadcom.com>
Cc: sashiko-reviews@lists.linux.dev, linux-rdma@vger.kernel.org,
	Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH rdma-next v3 11/13] RDMA/core: extended memory
 registration
Message-ID: <20261116110620.GG11319@unreal>
References: <20261109-uet-ib-core-v3-0-3e7e7ffed2e9@broadcom.com>
 <20261109-uet-ib-core-v3-11-3e7e7ffed2e9@broadcom.com>
 <sashiko-outbox-206354@kernel.org>
 <CAMouMYLdU_5yphFCviPKUUieMDzo+ozVyAs+CJXTkh-0Zq0bYg@mail.gmail.com>
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
In-Reply-To: <CAMouMYLdU_5yphFCviPKUUieMDzo+ozVyAs+CJXTkh-0Zq0bYg@mail.gmail.com>

On Wed, Nov 11, 2026 at 08:46:32AM -0800, Eric Davis wrote:
> On Mon, Nov 9, 2026 at 9:55 PM <sashiko-bot@kernel.org> wrote:
> > Does ib_mr_init_core_refs() leave mr->dm, mr->dmah, and mr->sig_attrs
> > uninitialized when a driver returns a non-zeroed struct ib_mr?
> 
> Those three are not new. The REG_MR and REG_DMABUF_MR handlers never
> set dm or sig_attrs, and set dmah only when one is given, so core
> already relies on a zeroed ib_mr from the driver for them. The helper
> covers the fields this series adds, which the extended paths and rereg
> read back. Its comment claims more than that; if there is another
> revision, it will say what the helper clears.

You are adding fields that should be NULL, there is no need to set them
and sashiko is right there.

Thanks

> 
> > --
> > Sashiko AI review · https://sashiko.dev/#/patchset/20261109-uet-ib-core-v3-0-3e7e7ffed2e9@broadcom.com?part=11
> 
> Thanks,
> - eric



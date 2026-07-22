Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3C9348C8AF;
	Wed, 22 Jul 2026 08:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784710563; cv=none; b=it/k4WbpaXQwj/xIfS/w9b3x1EFg6euL1sO1fTmMtRHhWhcI2U9Aedhu/BwUoLkCz6yG2WLEqc9MnF5Objbg5sRhvuZTXq1zdNENVuhuEywwB3IJwfa4UFiU0ZL08b2cQOrvgh1B2/xv0xcrVjU7zA38mhoaJY5pZ/MecFUCdYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784710563; c=relaxed/simple;
	bh=50uNNGo1Qe2pQOHrF1gqImsaGNTapooZrJ+l0Y4ywCc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FIMjUK9u4zZatmt4C4/P77So0aeecGKZrNk3XnIcminW9ecf4rx2n8gOqoXBKWrJdJndGmcuLz1lZiZPrARw9dD3iPudWAAqDIcjo8jsm7zrHAIdQZzAMkogqHyig3huRa25JXQOVBU5pLQ4l9NXq8qjmF6+hkjX7ggHwCeGVtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oz2nFLBQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oz2nFLBQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D103D1F00A3A;
	Wed, 22 Jul 2026 08:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784710561;
	bh=f4l18Y1tLnaol46V81NynxgBkJPAY4/qDT+4mBnK70Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oz2nFLBQZDnO43WyaFlTOICkRbjFXsdYfeDJsfrnvXMdrWJZYbAwgYED7ug6+LD4D
	 Qu5pbUEaZaGtg8Up0zQQQmkN9B1ruUqreMR9PJdDQ49sMSIfaH2DwjN5eq3edblF6K
	 vtYibQOgQUQwtSkJeWhrFuSAkS5PnMJjPGTHytOb/Lz9fYaJ6jGh8QXl/TPi28Xd6h
	 GYC/KXcUngqcNdLDpNUwOHPfEFKBKyB6Liku++yD/XRe+3tAn9KldoHmtPBPuYmchz
	 E2TFsGsJGsyxF2M9zYKHaHb82Y4/8KWH16QzfafdEVvnqVHOivZyqklkZA3+n+zfdi
	 I7einsw1Wc/kg==
Date: Wed, 22 Jul 2026 11:55:55 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Abhijit Gangurde <abhijit.gangurde@amd.com>
Cc: jgg@ziepe.ca, kuba@kernel.org, davem@davemloft.net, allen.hubbe@amd.com,
	andrew+netdev@lunn.ch, brett.creeley@amd.com, edumazet@google.com,
	pabeni@redhat.com, nikhil.agarwal@amd.com,
	linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, dwmw2@infradead.org
Subject: Re: [for-next v4 0/5] ionic: RDMA completion timestamping support
Message-ID: <20260722085555.GW110966@unreal>
References: <20260610154216.712374-1-abhijit.gangurde@amd.com>
 <7c9dea7d-a551-6f6a-3c3a-e0b55497c645@amd.com>
 <20260716080110.GA70906@unreal>
 <7b5f02bb-26db-175e-34cc-40318b0752b2@amd.com>
 <20260716091916.GC357857@unreal>
 <f9757427-8ada-5c3f-2177-25750af65dbe@amd.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f9757427-8ada-5c3f-2177-25750af65dbe@amd.com>

On Wed, Jul 22, 2026 at 02:15:32PM +0530, Abhijit Gangurde wrote:
> 
> On 7/16/26 14:49, Leon Romanovsky wrote:
> > On Thu, Jul 16, 2026 at 02:26:22PM +0530, Abhijit Gangurde wrote:
> > > Thanks Leon. This is already addressed in https://patchwork.kernel.org/project/linux-rdma/patch/20260617132605.1888205-3-abhijit.gangurde@amd.com/
> > > which was sent after this series. Happy to rebase if needed.
> > You need to rebase this, as we moved ib_respond_empty_udata()
> > from the end of the function to the beginning.
> > 
> > Also, please send this as a separate patch or series.
> > 
> > Thanks.
> 
> Hi Leon,
> 
> The robust udata patch has been picked up, and this series still applies
> cleanly on
> the latest for-next. Are there any remaining concerns?

Sorry, I didn't notice that it applies cleanly.

Applied to wip/leon-for-next.

Thanks.

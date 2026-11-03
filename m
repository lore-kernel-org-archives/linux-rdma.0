Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793707970;
	b=Rx7nd46H7xXqRe0B74r81Aejwo0DL623/hxkIar0gnxqq8PO/+CaczVlhUEeL6/9Q81Y
	 4kqa+u96AF7neaj/mpEwRhiE7t7KNo1SGJJXgr9oqhFwDk6gGW26Mo4lWsQEGtYNumNCT
	 x6qbhulzEG2c5VgxJpyW8EH3jcADW3C1Td0cevzJBBQeNxmbce/6QKgrdPvssNkmQM1Gl
	 Movw9H4XGxKeIJFLur+kAZQlm5EafknRpI76tZ6XSHfAnTjL7kDvlH7IJzlkYa8GoaV+Q
	 zzv0vU9o9jt2XM9WWDMMXLvHroQkPjRw2a99F2wOLRT24WcPrjV+d5TyphUD6krQjnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793707970;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=bYgNjmIYMf8GGiJRFq8Z2C527I+wZyryF4hYP2gQ2zQ=;
	b=rIool9IxqkiEGi4ePGONRlYuripWuJ+VMP/6SClZeWgZf6uFhBeP4vl+8YB9MFFleESN
	 RRw0Cy9mbmxn96sK3MrPyGR2ljm8fq9xsgwr+8IYeXyhAAD7YxjYgqdBPELk8RRDyn43L
	 RO4sTjZFoML/vwhRk02NuFivQ7g5HHMC62EiFUJYxpCaXHqct2U1nsTmVfC0UUKW5BY8f
	 voaHS3HL2H2zL54Emk50QXLJBF+f8j00cZoD5hyoBRCwN106qExsMvFESO5G5ivp4wTZV
	 DRvsVHvWSS7gBEpf2zcckmgrfAtjT5r8aS605is04WLZcfPvbjC4xYolyweEiwhNxqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=o1fKkQ5i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BD8A606A324
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 12:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=o1fKkQ5i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ACCF1F000C1;
	Tue,  3 Nov 2026 12:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793707970;
	bh=bYgNjmIYMf8GGiJRFq8Z2C527I+wZyryF4hYP2gQ2zQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=o1fKkQ5i1SMu8CQ1JwuMfpQjlwyyCsqFTbFdcUZLuZRiVWx5gRleTr6L2j4oB9RlG
	 E08Y/qMcLqWYY2lkoomarVhrbZSl3rQvI768zde/4HWuw16ibirvIpLq9PLA7TJ+3/
	 B6k4InG1hUhAoazZBBnAZcOzxwmTloqT64H/HrHAEFeBHZz34PN0DdqO3ZJodnVwVa
	 rQvg8/YZeJDUFr1tfsykcItqX0Oq73G98/W0Q86oBn0bWJqnODw0uiDG5I82ltbBH+
	 WKn6d+ASdGPTBAc5/Nm581gmX2ampCjflSaWk7fu1B+70LM6RLWqdqtffMx8GAG2ZX
	 rH/9giad5f1CA==
Date: Tue, 3 Nov 2026 14:12:46 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Mohamad Pishdar <mohamadpishdar@gmail.com>
Cc: security@kernel.org, jgg@ziepe.ca, linux-rdma@vger.kernel.org,
	shiraz.saleem@intel.com, tatyana.e.nikolova@intel.com
Subject: Re: [PATCH] RDMA/irdma: Restore original PD on rereg_user_mr failure
Message-ID: <20261103121246.GF264423@unreal>
References: <CAAAp7fgvKfLqxsZrvmq2+xtq=_AuGOmKLYijAsMk=bKCJFkSGQ@mail.gmail.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAAp7fgvKfLqxsZrvmq2+xtq=_AuGOmKLYijAsMk=bKCJFkSGQ@mail.gmail.com>

On Wed, Oct 28, 2026 at 11:07:01AM +0100, Mohamad Pishdar wrote:
> Hi,
> 
> While auditing the memory-region re-registration path in the irdma driver I
> found a case where irdma_rereg_user_mr() can leave a struct ib_mr pointing
> at a PD that the uverbs core no longer considers it to hold a reference on,
> if the reregistration itself fails partway through. I think this is worth a
> look before someone hits it in the field, so I'm sending the analysis and a
> proposed fix together rather than just the report.

Thanks for the bug report. Please submit a patch following the guidance in
Documentation/process/submitting-patches.rst. There is no need to CC the
security@ mailing list; this is a regular bug.

Thanks

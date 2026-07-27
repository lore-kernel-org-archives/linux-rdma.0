Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61D6C1427A;
	Mon, 27 Jul 2026 23:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785195289; cv=none; b=PpMOtl4OhYyqp//GARc5PSfOLFD++N9+rRCXyDa4sPIMOQ1N+I4i9xfkPeq5TbtW09RYR6/MTt+jN0u3uBEan2wUjB6IUPjfXwHD3tPqrnXJ6qJ8Dnu46pmhdULhtfZ9Tbe62uqGWgwmYmFTB/Yp1hRhf0m0KQJVt2a4h/b3sqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785195289; c=relaxed/simple;
	bh=QLxx+yYApERbBYmSd0K5LRULK+K5AxFiK+z7OfMUVCA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tRrx9yusStGwI7MPBE5kGYW3o/RkumEJxHiJYH7+SfVhENfqeUPIs7eu5bz3K9AgnHdTgZfaopFgafVX70q+oPh0GBNfIkBlOQ93pdDIMK7qCmxTQRtSRBM+tLKnEKtFEQMJDHZKOcVBnOgJIZ4gUP0gqUeckVOxceC9BvUn0Xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T3kMSVSG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T3kMSVSG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B0041F00A3A;
	Mon, 27 Jul 2026 23:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785195288;
	bh=iXGZfiUf7YZ0kykVr2YRJJZYJLEsjTsMXTxCKOa0dHs=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=T3kMSVSGCxrBRVmGPe0CjvcAR0iIlgEhFX/mLXYVmfBjAoAqTtL9oSfl9xO1lQrmv
	 ppYTk/0YAaUr0zhhuQ0eAF4GFm6M4aclwdqKQDDSO0RJAw2EWDl2m5BNzNEBEW8IhO
	 eiQuXAfMEY0i+cUZ1N4DjXgET7GeFUQ7aFrpSM/OMb3Qw++h/BBz+4b6Cy7BnlhOXF
	 jV1j2I6SzLO146ZQ/hNlLA+ytnEY4tNGjGdBIKc9sA5d0CKUxWvMuNaS0NSsZeNf8h
	 /8Whei5e0Ee7Ks8K0ChFwe/atI2zhuLI6Z9M/GCXvKyHe4u5K/wjxzl+5HmH/lYw9q
	 7myvIo26O/WMg==
Message-ID: <d7b7c7f4588eeb8cef4822af9ae51d38d3e64269.camel@kernel.org>
Subject: Re: [PATCH net-next 0/3] net/rds: Bug fix ports
From: Allison Henderson <achender@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com, 
	edumazet@google.com, horms@kernel.org, jhubbard@nvidia.com, leon@kernel.org
Date: Mon, 27 Jul 2026 16:34:46 -0700
In-Reply-To: <20260727154952.0bc24e1a@kernel.org>
References: <20260725082939.2546624-1-achender@kernel.org>
	 <e770554d9ca05784abb3c9d1ccd378295f46fa08.camel@kernel.org>
	 <20260727154952.0bc24e1a@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Mon, 2026-07-27 at 15:49 -0700, Jakub Kicinski wrote:
> On Sat, 25 Jul 2026 09:25:21 -0700 Allison Henderson wrote:
> > Apologies, this should have been a v2.  Let me know if folks want the
> > resend for the book keeping or would rather forgo the spam.
>=20
> All good, Sashiko has a comment --=20
> https://sashiko.dev/#/patchset/20260725082939.2546624-3-achender@kernel.o=
rg
>=20
> I'm guessing that nothing can get queued at the point where we call
> flush? Since it's late in the exit path?

I think it's because we enqueue an item that might put the delayed purge op=
eration back on the queue.  So we have to
flush twice to clear it.  I sent a v3, but it looks like sashiko has some m=
ore nits so I may need to come back with  a
v4 still.

Thanks,
Allison

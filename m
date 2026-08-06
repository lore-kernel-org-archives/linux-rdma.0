Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 497043FA5EF;
	Thu,  6 Aug 2026 11:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786015066; cv=none; b=Jg3BO/e5R8vGrgIIKjjEKAn04s9NLBIGOO5Dju1IIaM3fNPiGxJoDIPloZeNSOLN/a9YaTy6vgU6QiJeT+LmkNRHRBOB5QXoU8MCYoNvNQh4Bq/QOZgVJkc+z5VBW9sGXf9V+f5bDLYT95y1rmrrD4y5j6mRLiAHoqquPTMeMTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786015066; c=relaxed/simple;
	bh=a0Dydi4AfPQiTq8iSDEtegC0gQrwv4JKRf48BSHIE/s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DUrp5KreT7RrCIbInto5PvWwbn0qtCbiQqJzdkLk9Z64sKxz2QDiBncdviQ7DY/ly5Qa+eRcfe8D40sKzCrdCYLP3QRbCyArpOP7D1rgvPHRYyz9tXO9+RspYfOb2o7cFF2QE3kl8Y6vF8xvn0+nRoddgmdG3wnOdhQSSS9CJXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kfpt7dpx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kfpt7dpx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FC571F000E9;
	Thu,  6 Aug 2026 11:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786015064;
	bh=/g7l2/DivQeWv9dZWEtPvUOrgdueM0b8S2MKUfau0w8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kfpt7dpx5KMmWO2/UfQN0Sogr4uzq14QWE3UuFGATXnRnLO74DImo88nBl1UJrJQ0
	 o3edpjgbL6KOEawTE4Ww1b0IZoxszbgQnYwuGG0Cbi/WYPumihGRSYBOKJ98i+9QPt
	 wyGEUtwJI2XKQV2cmQ3K3uJb/WqXnf7X/tLz+XdGxsxVE6mXWPsux+31W1JLN02uSa
	 RocAmZdFavStMeGTBtDunKbQWNoczgJoOqC4NPFzr16QGW4tlTw+7INhYneL8OuI/Z
	 tRQJpi7PFrNC7umwEGeI1JvtEo7mEHFNVghpiklTk+sycwymLTNUXC3LOjDhVJCi02
	 ysOye0tl3P+8A==
Date: Thu, 6 Aug 2026 14:17:39 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Tariq Toukan <tariqt@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>, Alex Vesker <valex@nvidia.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Gal Pressman <gal@nvidia.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Kees Cook <kees@kernel.org>, linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Yevgeny Kliteynik <kliteyn@nvidia.com>
Subject: Re: [PATCH net RESEND] net/mlx5: Use unique names for software
 steering caches
Message-ID: <20260806111739.GF23431@unreal>
References: <20260730210200.2590115-1-tariqt@nvidia.com>
 <20260803182614.23f26c91@kernel.org>
 <20260804080455.GB326170@unreal>
 <20260804145756.331951b7@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260804145756.331951b7@kernel.org>

On Tue, Aug 04, 2026 at 02:57:56PM -0700, Jakub Kicinski wrote:
> On Tue, 4 Aug 2026 11:04:55 +0300 Leon Romanovsky wrote:
> > On Mon, Aug 03, 2026 at 06:26:14PM -0700, Jakub Kicinski wrote:
> > > On Fri, 31 Jul 2026 00:02:00 +0300 Tariq Toukan wrote:  
> > > > Prefix each cache name with the device name to make it unique.  
> > > 
> > > Why do we need a per-device kmem_cache?
> > > Isn't the right fix to make this driver-level state?  
> > 
> > This kmem_cache is required only for software managed steering mode, which is
> > configured per device by mlx5_fs_mode_set(). In general, resources
> > should be allocated only when they are actually needed.
> 
> Of course you have to wrap the init in a lock and count users.
> Trivial stuff.

I don't see why we should abandon the simple, architecturally
correct approach of allocating and managing resources where they
belong in favor of a more complex global scheme involving locking
and reference counting.

Thanks

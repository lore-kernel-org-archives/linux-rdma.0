Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E304B40961E;
	Tue, 19 May 2026 13:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779199198; cv=none; b=fWn/pax2YEswv05mb6jl0aoJ1bmTEBf51e5jYzI/Ak5WEXZHmObTBbgZqI33cmKt3ufAUIHcF87i3nZ3oJfDVO7CXqshA/ScBMtCe+x6+T1gxS6xR6JxroubLzJX+dijgd6MY4dINEYy6qyvwt12niVP36G7vO+HZhmUfWcmi9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779199198; c=relaxed/simple;
	bh=/dUImDtzIAmB2cBJXFyB/CIZcPGCvfwZOCSB97KcM2k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GkGqFiO/iwZlcn7yn+BW8FswrznanLYGVd3jgkX7thICN6A6eKie3fwoLbhM2ktxssKWnJQ4VLANfUqe6m/rUkfDtpyiwtuU96+hX5t1+I6dESUpgSs6I8POMyknvCsdyv+2h4eI6DNMOTK6dDdXxdNSh8cul9FOO3MmHs9mrvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X+YtpEsN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X+YtpEsN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBFDDC2BCB8;
	Tue, 19 May 2026 13:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779199197;
	bh=/dUImDtzIAmB2cBJXFyB/CIZcPGCvfwZOCSB97KcM2k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=X+YtpEsNb1G6tdUnRd/pFk+r78bDsHdCAh1i237yRveESMSdxpD9TyyRtxMPgK6IH
	 kFTVZO/57irHBhzvyivtgUlHqHGeMyqJCLGYWGOeLA6YU4FJz7vkoKArzpdHaMiV/G
	 pXnF1m38+AdDneKCGhjo1Nki2EkZcs5MutdxCBdwyfzbknu0dQssmehQ2HK/Je2At8
	 i90BAMl9WRMHHqoe4x/3md95886WhaY4wp86bAqul+JCP7a9tZUp5Gzwmww5FvTlp3
	 VH7Jzs2WDsT8nIsXFqu26N59z2+uhNXzTDfHvNeavE3R8gr75GnSG8cSpQlZDQjb2j
	 iMhDMJl3JQTJg==
Date: Tue, 19 May 2026 16:59:53 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Will Mortensen <will@extrahop.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>, netdev <netdev@vger.kernel.org>,
	Shahar Shitrit <shshitrit@nvidia.com>,
	Carolina Jubran <cjubran@nvidia.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	linux-rdma <linux-rdma@vger.kernel.org>,
	Jeremy Royal <jeremyr@extrahop.com>
Subject: Re: [PATCH net v3] net/mlx5: don't printk garbage when transceiver
 overheats
Message-ID: <20260519135953.GX33515@unreal>
References: <20260515-b4-mlx5-sensor-fix-v3-1-f537ce191d6c@extrahop.com>
 <20260518112555.GM33515@unreal>
 <CAMpnoC5ACdKiqy9mzmwvm592fJCbxXJCsuFxKJPG0c75_frFhg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMpnoC5ACdKiqy9mzmwvm592fJCbxXJCsuFxKJPG0c75_frFhg@mail.gmail.com>

On Tue, May 19, 2026 at 12:35:27AM -0700, Will Mortensen wrote:
> On Mon, May 18, 2026 at 4:26 AM Leon Romanovsky <leon@kernel.org> wrote:
> > Honestly, this approach feels overly complex and fragile for something as
> > simple as printing to dmesg. In my opinion, you should drop
> > print_sensor_names_in_bit_set().
> 
> Do you mean basically revert 46fd50cfcc12 ("net/mlx5: Add sensor name
> to temperature event message")? Yes, we could do that. It is
> definitely fragile regardless; there are lots of assumptions that
> there's at most one ASIC sensor and one module sensor. If we want to
> keep the printing, we could simplify by having temp_warn() just print
> a static string like "ASIC" or "Module" rather than using the strings
> from the firmware, and maybe also call a function in hwmon.c to check
> against our module's sensor index in order to ignore events about
> other modules.

Yes

Thanks

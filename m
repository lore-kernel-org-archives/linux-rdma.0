Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 647BC286D5E;
	Mon, 15 Jun 2026 20:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781556171; cv=none; b=LbzJ/zHav9oGp4dAD8/Cz3lgPG5odrqHAd/2Y3Tua4sy9fXq5K/xwIg0EEWyppVre6QzVtafx+N60w82VgutiPzwN1JvX8tPRR4+b0cZXQb5PSK54QCcpGqSMDmY4Rr6OwJnya7TpGSdq5xoB/dMPPRi92Zhtk5bLv5yeyJnT7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781556171; c=relaxed/simple;
	bh=aPTdsFC7OL8pWaV8feS5opuevgkA+VecbasCdeVpSeg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bnoVxxtM/NOj5nygLqssP6kZ4Fu3/XsV1hA2mtSI0jOt6bKsy5ET6pqxzDpGZ7YuLTcAt96+TxerwPvl/xp5vuxDrGTJlkbQ2KmuYuDvKVjiZ3xXxGH0YwnSzCOHUoVWgHdyqRM/NtzbopHuZLo6c9ff6ahOvOBFvW8zKtjZ34w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d1HKdjLw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d1HKdjLw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 813AE1F00A3D;
	Mon, 15 Jun 2026 20:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781556170;
	bh=nMnhxfNIZVyV93CrAHISz+K1WU9OroQwaebImzftECY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=d1HKdjLwer4f02pwmKsxGAre7uZHyuXLCAFi/cGSJVg9/QJcLIjK1XgQi1MrjpW35
	 ECfZ/zEhxc2e0rSqjAXLKUqsNdX2CizYp3sUP7X7QCQKH1xDjerrukAAyjJ2dPzAGy
	 /6ZNzquNxJuNEZOVjDqDSuyOqZUjoaPvfKirr9VSIYC2ghiUz91NdW1kFYA2rDHqAE
	 zFb13JkG6klttPUh9WjcPyrX9NTacXowa/uYomdRYCTX/4z5UZ5YSSXstiqSJIzmoS
	 ahHeu5ukRiw0IvdPAj/gIEbEbCNYsLiXQTsCpNGVuB/T+5k5ogh9FOlqw9uOgiz6TA
	 Z1ikLUSwVDVnA==
Date: Mon, 15 Jun 2026 13:42:47 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Dipayaan Roy <dipayanroy@linux.microsoft.com>
Cc: kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org,
 decui@microsoft.com, andrew+netdev@lunn.ch, davem@davemloft.net,
 edumazet@google.com, pabeni@redhat.com, leon@kernel.org,
 longli@microsoft.com, kotaranov@microsoft.com, horms@kernel.org,
 shradhagupta@linux.microsoft.com, ssengar@linux.microsoft.com,
 ernis@linux.microsoft.com, shirazsaleem@microsoft.com,
 linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 stephen@networkplumber.org, jacob.e.keller@intel.com,
 dipayanroy@microsoft.com, leitao@debian.org, kees@kernel.org,
 john.fastabend@gmail.com, hawk@kernel.org, bpf@vger.kernel.org,
 daniel@iogearbox.net, ast@kernel.org, sdf@fomichev.me,
 yury.norov@gmail.com, pavan.chebbi@broadcom.com
Subject: Re: [PATCH net-next v10 0/2] net: mana: add ethtool private flag
 for full-page RX buffers
Message-ID: <20260615134247.0bd7e16e@kernel.org>
In-Reply-To: <ajBRwYftEol8IE49@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20260602202801.1873742-1-dipayanroy@linux.microsoft.com>
	<ajBRwYftEol8IE49@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 15 Jun 2026 12:25:53 -0700 Dipayaan Roy wrote:
> Just a gentle ping on this series. The approach was agreed upon, and it
> has picked up a few Reviewed-by tags as well.
> 
> Please let me know if you need anything else from me, or if I should
> resend it to collect the tags.

Don't recall now what the exact sequence was but pretty sure this 
no longer applied after some other mana series was merged.

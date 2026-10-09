Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D879F3905E0;
	Fri,  9 Oct 2026 15:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791559154; cv=none; b=ZImCe+b67OmeV8sCjGUW3aaL3k2Gz6O589cJBA+Ss7yvN6OlLEmSoZWi+VG97Q26R5JCcIKmgpouoxCKwv5oNetObklTp0SDrzzgazGX+SQRqzWaT34UBs6tr0jaFVWVWzwhfPmG4xko0zpXl/oYGXHomUDVQeUyr87D9Vplc14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791559154; c=relaxed/simple;
	bh=bPR5Tqwi4Y4erVYP/3BIN0RRkQjgxUFnu09DGUygdvk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=khO4HAwQK8uIYJGAVyANKx0NSZy5mUOfCvh7xsuhaikeUn0qvLtm17uP/aqIosJwKzcBKHwPa+C6/riMpl19v+io1WWptg4oww/cuoBmEe3XuDIAzvbGkI5Beu1q0RX9566aOv8dLn2JwemCTz1aM2fI2ZJhvUJQn3rNovbhGuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gKhhpHI6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gKhhpHI6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D32F71F000FF;
	Fri,  9 Oct 2026 15:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791559153;
	bh=jZKQBS895WjgLPHYyn9gLII3Mh3ShLe3Tp6Or1il/2g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gKhhpHI6zRqA9uKz3Ah2TEHVaj41J6RpNCKNJB7BwQKDW1N72JWeeK8pqVY6vqPhl
	 XwuOXpVCtcW0AvmM3DJKvG8oSlW136BMtQoKGWl4W+a4lTre1tw5IP922hjN84IqC4
	 ZZgxKsDBXjMjtTDveSFLcLQc8oDMGw6lhNrmkyXm6A6vzb029XvJ655AwAl+LS6FAO
	 cH2c8i67NibnQQ0AeJy75X0UgloGIaEaR/X4LfHntWsCOnfJx4TqXCkUswC0uI6Pxv
	 nuzzrwRCOnwOkFnjibpTllQV1vQTFdFTqSDqRkI4vzY7qAosSlM6oUZyPIouzHPU1p
	 26+QaqRJ5FAEg==
Date: Fri, 9 Oct 2026 16:19:06 +0100
From: Simon Horman <horms@kernel.org>
To: Wei Hu <weh@linux.microsoft.com>
Cc: Long Li <longli@kernel.org>,
	Konstantin Taranov <kotaranov@microsoft.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Paolo Abeni <pabeni@redhat.com>, Eric Dumazet <edumazet@google.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>, Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Shradha Gupta <shradhagupta@linux.microsoft.com>,
	Erni Sri Satya Vennela <ernis@linux.microsoft.com>,
	Stephen Hemminger <stephen@networkplumber.org>,
	Shiraz Saleem <shirazsaleem@microsoft.com>, netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Aditya Garg <gargaditya@linux.microsoft.com>,
	Dipayaan Roy <dipayanroy@linux.microsoft.com>,
	Kees Cook <kees+treewide@kernel.org>, Kees Cook <kees@kernel.org>,
	Manish Awasthi <mawasthi@linux.microsoft.com>,
	Wei Hu <weh@microsoft.com>
Subject: Re: [PATCH net-next v6 0/4] net: mana: concurrent HWC requests and
 dynamic queue depth
Message-ID: <20261009151906.GF83879@horms.kernel.org>
References: <cover.1790665894.git.weh@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1790665894.git.weh@linux.microsoft.com>

On Wed, Oct 07, 2026 at 12:53:26PM +0000, Wei Hu wrote:

...

> Long Li (4):
>   net: mana: prepare HWC ownership for safe reinitialization
>   net: mana: give each HWC message slot its own completion state
>   net: mana: support concurrent HWC requests
>   net: mana: add dynamic HWC queue depth with reinit path

Hi Wei,

Unfortunately this patch-set did not apply cleanly to net-next,
and thus our CI did not run.

Please rebase and repost.

...

-- 
pw-bot: changes-requested

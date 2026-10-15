Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82C334DDB43;
	Thu, 15 Oct 2026 08:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792054245; cv=none; b=k7/rotGn7yL84EUDeiEDVKy4ot7modtnKbO03rumSA85jU5L1wplcYJVk2Ow9xhe1ve78dLhzvsE1+6ptioF6FYZNhckk7kRiSrTMXLAMoGsTgt9OsZTIsVvjodLWEEvLsRRkklLmCHgtlrbJxnxeInSS3tiTG/emKv3d0r6xBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792054245; c=relaxed/simple;
	bh=1AjQ1grc8Ta5fjkrNOLoN7Z2TAeP9C0FZcIb5lOtAcg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EZmN1xi6bkrdn34J+YplB3QdFTgfKY9Pnf7F2RJiLAuyWFowjV5gT0waRtg9Rj5LgoNXv50GMaFCb028Wf98vURHNJHYXijHGCNbygaY8bJghjZ+on3AD+kUTrhoqdRjQ+NsS3FUsg5QBv3EoBnqylEE2Ytv0KS0wIUfvhDC45Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lwyzgf9H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lwyzgf9H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FC661F000C4;
	Thu, 15 Oct 2026 08:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792054238;
	bh=1AjQ1grc8Ta5fjkrNOLoN7Z2TAeP9C0FZcIb5lOtAcg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lwyzgf9HUDAbPJXvPi5n2ertcOWol/kL5NEkeDo0mixJpoES7J4+Lsyx9OxUfvDHt
	 +88NiJ2CElMtERhOQeaUx3GppC8g+YQseS4Re+5eZk1Gf+By/vJoQWgLAvwJFfgzCR
	 VDUEjLTmn4KeRUVjqiIhFR+rinn4WaFOdmmmNcSaxjJJII4HWblBM7HWtru6WOceNG
	 i1YYM2xzJT/wLK/cs0f+u3Nx27okZ41mg/9roADQYSiyXVLmj6qzFXU2gwsJg6dCyb
	 +PiX48JK2RxVrlgL8LBPfHXhHPAELkcoVVo6QCQ2sXqJhiEDN8Dj4/aaWhwuoX6DyJ
	 nLHOd7QNi+Otg==
Date: Thu, 15 Oct 2026 11:50:34 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Dongliang Qin <cccccccccccc777777@gmail.com>
Cc: Zhu Yanjun <zyjzyj2000@gmail.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
	Bob Pearson <rpearsonhpe@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 0/4] RDMA/rxe: Fix MW/MR lifetime races
Message-ID: <20261015085034.GY219304@unreal>
References: <20260928171756.3254016-1-cccccccccccc777777@gmail.com>
 <20261014061223.1547823-1-cccccccccccc777777@gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261014061223.1547823-1-cccccccccccc777777@gmail.com>

On Wed, Oct 14, 2026 at 02:12:23PM +0800, Dongliang Qin wrote:
> Any comments on this patch ?

It is hard to say anything meaningful for AI-generated RXE patches.

Thanks

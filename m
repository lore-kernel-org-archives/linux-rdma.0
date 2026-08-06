Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9C7443B4B2;
	Thu,  6 Aug 2026 10:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786011884; cv=none; b=iA6vSf4uFS3rtiQ1hLuTInfhmosiT6UUiGZBEh6hrVfOY0Zi56TEi6+tOKhdbwN1vEv2MxYqz28qeAweVyjKkwMNZbGCeiAM6RU4XStnETOelkIRReQ8w3HUKy+ByogNIi5UN6dpY3S6+p3EB98ottzRlcQz8RN5I9Ir6fBUP50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786011884; c=relaxed/simple;
	bh=wOfK16VtHmGO2b4hQGM3XnK0RcwzxAl0hvUtf3P2sIw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=spK1JDR7V6BBTPHJQNKCMCiLhnsUmfG/YedjogMB7ZSF7Fvjm5tc793YaALD7Ly0RR9RfAxWhj7ASYtv510Rv9Tz6/KmPrV1x3DaITkb7F1RztckgPcfWsowpaZwY7xXHzOhVDMtyt9MWrOr5GuKXn/uYAS4UWwFQElKJfAjELs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KtIVcGfM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KtIVcGfM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 366FC1F000E9;
	Thu,  6 Aug 2026 10:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786011882;
	bh=ee3OPAxNvfSG3egrLD1yO0zsgTfaeFFrMbSVzalHE2I=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=KtIVcGfMPGroL0rLNcCJarHPjVb5QosF7EVTTokOHzNAv+tWro7QHA1nn0NWt74f9
	 ii5gobkf6G6meHnYQfaekFsAjci3cCshhS1UebvslQ4SJw4do/GZTBeqotda5MXNbd
	 Jy3nNUKGot9v5voLh2LknKIPfHtQHZpErAsY0IxD0dkXqgmFuVQjNvWJuuGzE51egJ
	 DczV9jWTS9wLRHHHUaL4vGiEmw5zuk3doyMfIjZclyddLtiXmkuc+IUvSXA2YojT9Y
	 btoTX0qktznEfdWc4jL3uJiqS+FlkClzsuvhO5OKNjljy1AGzAzvQ77RsnhniTRl2m
	 PonaOo27mAlqg==
From: Leon Romanovsky <leon@kernel.org>
To: sagi@grimberg.me, jgg@ziepe.ca, Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Cc: michael.christie@oracle.com, martin.petersen@oracle.com, 
 linux-rdma@vger.kernel.org, target-devel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
In-Reply-To: <20260731041212.1733364-1-yhlee@isslab.korea.ac.kr>
References: <20260731041212.1733364-1-yhlee@isslab.korea.ac.kr>
Subject: Re: [PATCH v4 1/2] IB/isert: delay the final Login Response until
 the session is registered
Message-Id: <178601187994.512025.4260188111386087376.b4-ty@kernel.org>
Date: Thu, 06 Aug 2026 06:24:39 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Fri, 31 Jul 2026 13:12:11 +0900, Yehyeong Lee wrote:
> isert_put_login_tx() puts the final Login Response on the wire before
> __transport_register_session(), which iscsi_post_login_handler() reaches
> only after iscsi_target_do_login() returns.  An initiator that issues a
> SCSI command as soon as it sees that response can have it executed against
> an se_session whose se_tpg is still NULL, and the ib-comp-wq worker oopses
> on the NULL dereference.
> 
> [...]

Applied, thanks!

[1/2] IB/isert: delay the final Login Response until the session is registered
      https://git.kernel.org/rdma/rdma/c/464f5afa92d071
[2/2] IB/isert: post the full-feature receive buffers after session registration
      https://git.kernel.org/rdma/rdma/c/5247dde9daac7e

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>


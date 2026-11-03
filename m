Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793712008;
	b=dD2hjybQzxSYFc8L4Opfd9g6N3/3ilGzMRNRrIb3wrW6gVDJ1342Xd9fndqtBws+yAHb
	 OX3R3/0ZKaNy0Ha9kcZihh3JHQ6Pp9yO6aEiAFw1XZs9IWxJJKLAlQZ4gvExp99I7lOXD
	 mfx7nGPgzsDXZlOvdz85kHpt5wdYSfXWR9MlKF39C/xDDcyPK5jn/poWYnG9drm0t3C8t
	 LLqVg1VypeDj6LQv5zDn6QbR3rTxKtHiKQGGUHXbqi9Xtcn2edj+XkQcQFZdbNqRkjxW8
	 P+/nJMFeSCSzxhb8QvDdlGSev2tMwa5jl4OwOCxXZeMsMLREVEWLriJ9H+Pdku8GDYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793712008;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=6d/8qzKZlQNLmtDnc6vPwct0MOm88mKaTDP0mzv5CUk=;
	b=TjB7iakFEUpA/K1jZzNXXTj/0HQEXkF337NWwifdhO4YqaBBsp/Z4rLsUqdHm0y52yo0
	 ZJGjCHrFHYnOJoTTMRdWIBKEyX8BZ0VQC4lNVA3ffg1R+cglZdizSJQzE6EZ27XMjjZFJ
	 XoRo6HDVwOO1jei5Mto8PnNHiy4HE3UfaP+druyBDGHG3hQzw5h/LTGVnxofizrTaDP7K
	 6+kIAVUPcsLwuPlaZs/7WPsTolCmbCSiZwsBnAbbd0qp+9TagIJ67hKPDL2RVILTO6cYX
	 HFI1kekvjweV+ZvZJz0dcsfD5lTjj0Y3WA+DPQ7GsB+/JgTltfbwqFbphsXJ2IGTPxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nC9IcDo5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95F6B606A324
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 13:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nC9IcDo5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D37E61F000C1;
	Tue,  3 Nov 2026 13:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793712008;
	bh=6d/8qzKZlQNLmtDnc6vPwct0MOm88mKaTDP0mzv5CUk=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=nC9IcDo55SVuN8wVzru4R5rzBFPNIfg0g4XxBeLNxrnJXTaHRTyYrBtVmngdLmQdP
	 tG/r3bGoIwfxEY6Yf8lNzQoZ5HH57tk6Jmxevg5qJAYRq3XBZJe9E1HvldwqUV4MDc
	 D4fJndpB+zMmyIDEFQHkK5Bjam2exIrbf00BoFdIu2U8PIYJ/gdxmmCi7xGbbvF9t8
	 S/DX44Uhf1xX4tjZSfLCMvpPl5AK0U0p9oP3sUpod50jgli5DnjybXjXNWXmnGTsH1
	 EHliWMGvCD3Ggnn6H9kC4FB4fV8M2yT9vmoQ8nF4c3Tss7OdKjnAKqDMbRY/Ps+iPu
	 GTxnQX4jqaXcg==
From: Leon Romanovsky <leon@kernel.org>
To: tatyana.e.nikolova@intel.com, jgg@ziepe.ca, 
 Jacob Moroni <jmoroni@google.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261029135306.1372393-1-jmoroni@google.com>
References: <20261029135306.1372393-1-jmoroni@google.com>
Subject: Re: [PATCH rdma-next 3/3] RDMA/irdma: Do not change mr->pd in
 driver during rereg_mr
Message-Id: <179371200572.1726055.11640512427251640287.b4-ty@kernel.org>
Date: Tue, 03 Nov 2026 08:20:05 -0500
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Thu, 29 Oct 2026 13:53:06 +0000, Jacob Moroni wrote:
> Previously, IB_MR_REREG_PD would cause the driver to set
> iwmr->ibmr.pd to the new PD before reregistering with HW because
> irdma_hwreg_mr() retrieves the PD from there.
> 
> ib_uverbs_rereg_mr() only moves the PD usecnt from the old PD to
> the new one and updates mr->pd itself after the driver's
> rereg_user_mr() call succeeds.
> 
> [...]

Applied, thanks!

[3/3] RDMA/irdma: Do not change mr->pd in driver during rereg_mr
      https://git.kernel.org/rdma/rdma/c/ab5389ccf8bcd3

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CD5254A7D2
	for <linux-rdma@vger.kernel.org>; Tue, 22 Sep 2026 13:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790083390; cv=none; b=P17CR2fzJoaEvGU+eUTPvy4wdkY2l6VGni3gIvdbLY8cbCpYpYR3Xm2triazdB8L3pE7Nxzo2udYBZYy2zHs7ooY3DS9GxhdjhaldZVsA7ib+IY15HioXmfxeiXqJmWh+fLKxqu9tbQVVoSRqKmYx9qfgPqT3agW95WZUnAmlS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790083390; c=relaxed/simple;
	bh=Xc6WzvSfQVVDmMucXN2iDh45RBYiib5jthU1mb64JJE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=FzzZgC384QXH2tCsgpfbCrL7gMv4g032ocV72rgWY8c2DLmNhgEksWCMDpCzDERevhsRu5gMaJz0biMDbNPsIegyuAAGKXnqXjnbCKONEO242LOc0UjjY7BdNS6eqYZ7O7eSoTW9O9YOYVA8MYAZYkDzWSPLT0AZ8Za258VbJ9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GlJshJM/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GlJshJM/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 822801F000FF;
	Tue, 22 Sep 2026 13:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790083389;
	bh=jj5fYhh8ytrP7cN4c6jsbNXKdbP/Our+xjuZXaWNqsM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=GlJshJM/IsH1NDL8DdeCwPJPh2n5feIPtDbDi8Q37/PBujWttTnzSp+4XxNFVhVYe
	 KMl6a8UAR3YOrtydl49hScC+RnZSt3frLmFzPWTEmYasjZou6/GlM3bxkwaBBGZdV8
	 J16Guz6lunI5JHUksbrZDqq/aLm34Ue9XmmyzjiINHeUDFJOVhUOTnA3PYzpqH0meW
	 WcQPC9MTKsvhLVqR7kI2Ds5D4JCZ9WLrGUOfjnDxKARGM/kKvamZZ31Cop0ibHITa0
	 6lpkwIhWzY1TKp9hVuaFPcE8sajWTB5/DYjNfcg+kZqfMlShuiffTvU7LdYJKsnzQT
	 3AZFMM+Yrsu8A==
From: Leon Romanovsky <leon@kernel.org>
To: tatyana.e.nikolova@intel.com, jgg@ziepe.ca, 
 Jacob Moroni <jmoroni@google.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260915170317.2901672-1-jmoroni@google.com>
References: <20260915170317.2901672-1-jmoroni@google.com>
Subject: Re: [PATCH] RDMA/irdma: Fix erroneous -ENOMEM for large MR
 registration
Message-Id: <179008338627.3242310.4297614585688591385.b4-ty@kernel.org>
Date: Tue, 22 Sep 2026 09:23:06 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Tue, 15 Sep 2026 17:03:17 +0000, Jacob Moroni wrote:
> Commit cc8997c94bf3 ("RDMA/irdma: Refactor PBLE functions")
> replaced the explicit level1_only boolean with a bit mask
> but did not properly convert the "if (level1_only)" check
> in irdma_get_pble() to be "lvl == PBLE_LEVEL_1" and instead
> left it as "if (lvl)".
> 
> User MR registration passes "lvl = PBLE_LEVEL_1 | PBLE_LEVEL_2"
> so this check always evaluates to true and causes the
> loop to bail after grabbing a single SD even if the region
> actually requires more than one SD (as is the case for
> regions larger than 1 GiB with 4k pages). As a result, these
> registrations can fail with -ENOMEM even if there are
> sufficient PBLE resources.
> 
> [...]

Applied, thanks!

[1/1] RDMA/irdma: Fix erroneous -ENOMEM for large MR registration
      https://git.kernel.org/rdma/rdma/c/5bb710151753fe

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>


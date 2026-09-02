Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E68AC4A015C
	for <linux-rdma@vger.kernel.org>; Wed,  2 Sep 2026 13:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788355668; cv=none; b=FxKxAFGiabnhzOoo1idExiBAOLuugE/JzGwGN01ARkZzHVjhvdUUCvW6YBEyKRy2B9hfxM9hLJDkknjqySArgeLmbs4aiRlBbe2JmAup5qBfFYDCAZF5p26/IywfuJEjRRWjGAbNwK9c2d+pZzM8sRJKNWgT9seKRmUvV3nj4D0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788355668; c=relaxed/simple;
	bh=VMDlH/EQ3Ri8K8/7Zwoomyxjqw8cpC52bGWWtOSIoYQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=pmKBPv/O436aS/4XCr8pGmGrk2kebdMUuNAkQE6dx/+eCt7E/zpW2nCMWNwTT8R1bA8caOvRu7DupRFGiGk3cKBTdHF5pyS60xLq/Nygyoxr90KOpQNIEHjpzo+oJbDLGPZCyEpD8mVjLxTYwXSSldd1mU7DGSoNZqbhgFi5DMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XF05h58Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XF05h58Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBA801F00AC4;
	Wed,  2 Sep 2026 13:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788355664;
	bh=obFQK+b/IPYwtwgknZbDClXuvQXtujzTtiW/iyPrp9A=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=XF05h58YFm3aZZV5+sSXkBpNAgrrxmv7z2B7Z1OI0lA/E9PDMYMVLmuLu7URDJ+eB
	 EgBNLF40VvDmtVANBawXfL78sEMAfoW1GES5MGUdW7yIRrYsJwD1AULl5J5waMRYqW
	 CEKxIHykZraDRXUHBGTmEg3kRb5C/Z/Grh93u3kMVEfCuWBbThYMwNdGRB564ddnSf
	 04BtxWEquaam/ewM0ZlN0xQPxQO7rVI9VI3ZYFRkjHMo64OLCrkTe4DpF48i2lYlCB
	 zayXGym9COTjIR/F45OhFW1Gkibfgxg4PbsC2n9C6SwyDpjFd/IbZW+io28COluuba
	 I1XT7E47mvNbw==
From: Leon Romanovsky <leon@kernel.org>
To: jgg@ziepe.ca, 
 Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
Cc: linux-rdma@vger.kernel.org, andrew.gospodarek@broadcom.com, 
 selvin.xavier@broadcom.com, kalesh-anakkur.purayil@broadcom.com
In-Reply-To: <20260824172443.33943-1-sriharsha.basavapatna@broadcom.com>
References: <20260824172443.33943-1-sriharsha.basavapatna@broadcom.com>
Subject: Re: [PATCH rdma-rc] RDMA/bnxt_re: Avoid exposing umdbr to
 userspace
Message-Id: <178835566168.2492337.14155439865086540788.b4-ty@kernel.org>
Date: Wed, 02 Sep 2026 09:27:41 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Mon, 24 Aug 2026 22:54:43 +0530, Sriharsha Basavapatna wrote:
> The umdbr field in struct bnxt_re_db_region returns the raw
> unmapped PCI BAR address of the doorbell region. Avoid sharing
> this field to the userspace. Change this to a reserved field
> and stop populating it, keeping the ABI layout and size
> unchanged for existing binaries.
> 
> 
> [...]

Applied, thanks!

[1/1] RDMA/bnxt_re: Avoid exposing umdbr to userspace
      https://git.kernel.org/rdma/rdma/c/23d7e03a52ece6

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 916BD3034C
	for <linux-rdma@vger.kernel.org>; Sun, 17 Dec 2023 13:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aK/kABaV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BE4CC433C8;
	Sun, 17 Dec 2023 13:36:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702820176;
	bh=cd2EnkYSQYPVdKQaLOAoqLfLhxHBLFDgivSw8z7Nqm0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=aK/kABaV4PT9/5o3vOodlkOf548e6QFd1ZBnCrUV0BO9uNMf8w1fotjP+J59A7ep3
	 MNRwHRw0kNxOsmLFKci82deCsvVNufqkcFQddcngsV+DALSQPghUqOvjyS50rKWQP7
	 UpNb0JIIo79wSNDhr3Qw/a5GMyIvMMyqu2ZBAVObqqumXyAEolZS3PD8yGvBjgHKQV
	 Q6Cp3JzXTkj3lLyYBwWykbdzSA6g862cBTuh4DuGPP6ByENTDG9iIIuOzxi0DoB8+e
	 O/gHoeu8q3qWqNtz1UCAEbgVkJG0Bt5JD1DnZ0n7+ICOPNXYqbVWpgiTYcLtTlCnWy
	 fN7qxyZ3lo33g==
From: Leon Romanovsky <leon@kernel.org>
To: jgg@ziepe.ca, Selvin Xavier <selvin.xavier@broadcom.com>
Cc: linux-rdma@vger.kernel.org, andrew.gospodarek@broadcom.com
In-Reply-To: <1702535484-26844-1-git-send-email-selvin.xavier@broadcom.com>
References: <1702535484-26844-1-git-send-email-selvin.xavier@broadcom.com>
Subject: Re: [PATCH for-next v2 0/2] RDMA/bnxt_re: Share the CQ pages for
 GenP7 adapters
Message-Id: <170282017151.63492.16334281031068523452.b4-ty@kernel.org>
Date: Sun, 17 Dec 2023 15:36:11 +0200
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12-dev-a055d


On Wed, 13 Dec 2023 22:31:22 -0800, Selvin Xavier wrote:
> This is the follow up series that adds support for GenP7
> Adapters. Implements mechanism to share the toggle bits
> received from the HW to user space. Adds a new UAPI routine as
> the toggle bit is required for both CQ and SRQ. Current
> patch series is adding support for only CQ.
> 
> Please review and apply. Will be posting the user lib changes soon.
> 
> [...]

Applied, thanks!

[1/2] RDMA/bnxt_re: Add UAPI to share a page with user space
      https://git.kernel.org/rdma/rdma/c/9b0a7a2cb87d9c
[2/2] RDMA/bnxt_re: Share a page to expose per CQ info with userspace
      https://git.kernel.org/rdma/rdma/c/e275919d96693c

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

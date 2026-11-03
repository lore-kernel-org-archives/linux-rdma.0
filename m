Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793697714;
	b=tP1hyRKVL+5qhLxfsIrDit0QwFXXVQDvCa+S+6EQOGMM89SEFkdTXRN8JP2AEqoWxxmj
	 5ejlWX5jq2jPDRFsyxfDqmh4D0vxD4cFCyI1B9Uab0emlSnWL+m7dAl63yoFfigGxuepV
	 VFbBWjOE/y3d8ZeXR7LQAlO/HRCK1mmGutYITNaj2l3LgTL9fVHTFZdgTbr52D3nfsxrd
	 EVXBC0hqq4eMvb3eyCPnXcq0TXrAdqb6UCQSno4+zd30NMZA7Zyb/0243FKwevf7HoEr3
	 8R4UkFF0S4kfHknWPUIssOx2EraKmlPPCu5bJPZF1nIx9I/b5wB87nB5DZRqEG8Cy1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793697714;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=LUWpwYBuIGEbLF9N0wJhb3n/Cjc8fUlO3M1H4nDXmts=;
	b=c9Yugb3TGn6n/agsIckED7i21GbhxtAbBcp4DtbEfjiADDcell5Xpp8RYY0v/9Ez3T1+
	 s0upl+dqKj0KiMqPwDz+TzJdALpKmVUUhR9u5eOv2d7WLJxzCz1JeABP7aBWVNYU/lnfh
	 8FwTftJyVou5CXOZa/OUGCmyX8ef08MnNSMf39ysRaey8qeEhKzOoMTBPOjnZRqnlOadl
	 LonsWHhTi6rj5UUc25qIG6nFGAkHzDIAqNw7ebW+Lupzk/D7hKFUbSg6xKwKKzguHW79z
	 TKJhaELa44CXnJ4ro84cNxbhx3X/Ltw+eS1STF6vLU+OG8J8XIf02nb0d//sLNPiGuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UQoXHkVd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AC356083629;
	Tue,  3 Nov 2026 09:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UQoXHkVd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67CB21F0093A;
	Tue,  3 Nov 2026 09:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793697714;
	bh=LUWpwYBuIGEbLF9N0wJhb3n/Cjc8fUlO3M1H4nDXmts=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UQoXHkVdAP3hp1hkDdM7PbjS+tJ6HvOefKfoKPlMb60OaELYUmK0Gg/L1YV9UlPTB
	 k89D8cHO9dS35rDFBwHjwpZZ1ST8irBFruBdyoRGlf4YX8720VIwedOa51q+Q+CQpC
	 bRCfkcMJ/7/fqAvaM6gp4zJBIHrs2BvA2op7npsnxlh5y8Ftc2XfANp19ABc4vbuno
	 6XfvdOHE4dxphUVW5YTca3LQEeFFoJbdLLVezs1kT4jyujn/gNRmalTzuPrwfqqGs6
	 Zo6zKSrqY/RJSjC8wCzk/mH7GX2millelPFfM8Ml6tx680rkKgwfIqyL9PmK/Ff8yO
	 DmRq0QlQAblsA==
Date: Tue, 3 Nov 2026 10:21:51 +0100
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Wentao Liang <vulab@iscas.ac.cn>
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, 
	stable@vger.kernel.org, selvin.xavier@broadcom.com, jgg@ziepe.ca, leon@kernel.org
Subject: Re: [PATCH] RDMA/ocrdma: Release user memory when MR registration
 fails
Message-ID: <20261103-fulmar-of-stereotyped-beauty-011538@quoll>
References: <20261103081212.1137625-1-vulab@iscas.ac.cn>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261103081212.1137625-1-vulab@iscas.ac.cn>


On Tue, 03 Nov 2026 08:12:12 +0000, Wentao Liang wrote:
> ocrdma_reg_user_mr() pins and maps user memory before preparing its page
> buffer list and registering the MR. If any subsequent step fails, the
> error paths free the MR and any allocated PBL tables, but never release
> the user memory. The pages remain pinned and DMA mapped, and the locked
> memory accounting is not restored.
> 
> Release the umem on these failures. Use a separate label for failure of
> ib_umem_get_va() itself so its error pointer is never passed to the
> release function.
> 
> Fixes: fe2caefcdf58 ("RDMA/ocrdma: Add driver for Emulex OneConnect IBoE RDMA adapter")
> Cc: stable@vger.kernel.org
> Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex
> Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
> ---
>  drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 



Multiple things here:
1. Your team ignored completely previous feedback. Multiple times.

2. You use multiple identities with this email address, thus I doubt that we
   speak with an actual person.

3. Your bot does not even bother running checkpatch, right?

4. Nothing of this was reproduced nor tested.

5. Finally, the same feedback:
You sent multiple independent patches, to multiple independent
subsystems. The amount of these patches clearly suggest this was
AI generated and most likely not tested.

More importantly, you sent all this work without properly organizing
relevant patches into patchsets. This makes reviewing difficult
and might cause multiple reviewers to address the same issue.
Replying to the entire set is impossible and requires handling each
patch independently, instead of applying or discarding the set.
Maintainers also won't see the bigger picture of your work. Quite
worrying.

This is on the verge of hostile patch: bomb us with so many
contributions, we won't be able to handle them in efficient manner,
like responding ONCE to ask you to slow down.  Considering all this
is untested and LLM generated, I have even more doubts whether this
should be considered for review.

Please read kernel documentation BEFORE posting more work. It will
explain you how to identify subsystems, how to organize your work per
subsystem (so a patchset grouping multiple patches with a short cover
letter), how to document the issue discovery method and what was
or was not tested.

Best regards,
Krzysztof





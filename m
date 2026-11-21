Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795289910;
	b=MP3R60OMP1op5RLk/Cggq//ntJlYGfjF74f+/o3FMQifw1/iVRXXuBQoqR+bflP86myA
	 MOz8k8S1/HVsJ4PQaWff5zbyY/wtv54dK/g6ROAJX4bqdTNdfvyH8xci4Vu/oxBr9j3j0
	 nbO4jF0ymF+Pk/pP5v9vtpL1s8z0+QKmG3sistKfT3j0jxLph3hG7XUdrkXG5URNLiazi
	 gf7ezC+fLY7nORNxWk/t2DTaUCCWtasWZE6iwY7Rw60Dm8HEWglLRMR/qDSnIobwX6MuL
	 LK5By+w2i+l27yQP6emIMUERYWmWyqBzVGkAAiZeFZflFndqAgrMOXgkWUrUqO+zT9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795289910;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:Auto-Submitted:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=sS9FIrfW22SIhehTvpH3rdvmtslwIeEYozBr0OvaZe8=;
	b=i8ffivDFz2m2OE2+NrxbFDq1JV4nfBGW1U4idyZoi3OOpQdvvWp96Mxj/nNdfuNi7+CC
	 KvuU+q3wlPVIyMIl7n2vfHKF8RebuptS39fGvK6Z6Sz7Tj0yGFhOFjyHiKrJaWiQwpN2g
	 QO4ORakK4uukpoSjj9m8cAov+S1ZLrxXtomHIYsLRFxyRnHUTVILg/ElqpFShNBPnmTse
	 KjqC8YWieZM05Ht2x3D27MdwjgTFCbW3f1PIgfxdM37/IqSIWOdEenk6NjDkkCm8T+gyG
	 zn+anB/9ozKZ/NQ6SmLnM6cHDxNeW9jT01x/8lPkpVdBguMUt6dcfZsxg3FlvfEHU/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lMEGNHQ0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CFD0606A32A;
	Sat, 21 Nov 2026 19:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lMEGNHQ0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 633BC1F000C0;
	Sat, 21 Nov 2026 19:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795289910;
	bh=sS9FIrfW22SIhehTvpH3rdvmtslwIeEYozBr0OvaZe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lMEGNHQ07oh2MwUfRgwkvZAZ27WeJo6vDD/l30AWPPpzJj5Q+NfMczzLMW8sfxzQ2
	 S4pyJsc00F5CC8ChEwg9HqSdcKXUlnaSRaPcc+PfKz4E2SQ/ktqP6gkAbl5YmrP9zp
	 tQdk8ujImGnzeOEELv3R6oy4k3Ku6FqcDAyXxKli2mxLjR/Jz3wuwS4/EYe3A7nse3
	 q6zNUOAglc3+hvlWLqhelia66rFiXKv5uyUVKYzeX4IOaNsG1JZhw2v+D+nOqaOHVc
	 73RfFZRDnZm/6Q5dwkV75tmV7wsAigidVFbsNq4pyfhtQ7GJrGoLPl23u1QH3WnoJ2
	 cvWELJEQpL3OQ==
From: netdev-bot+sinfo@kernel.org
To: Piyus Kedia <piyus@iiitd.ac.in>
Cc: alibuda@linux.alibaba.com, Dust Li <dust.li@linux.alibaba.com>,
 Sidraya Jayagond <sidraya@linux.ibm.com>,
 Mahanta Jambigi <mjambigi@linux.ibm.com>, netdev@vger.kernel.org,
 Tony Lu <tonylu@linux.alibaba.com>, Wen Gu <guwen@linux.alibaba.com>,
 linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org,
 linux-kernel@vger.kernel.org, Kapil Vaswani <kapil@presceralabs.ai>
Subject: Re: [PATCH net] net/smc: validate the peer's CDC cursors against our
 own buffers
Date: Sat, 21 Nov 2026 19:38:28 +0000
Message-ID: <179528990895.3294.1614564040906254045@kernel.org>
In-Reply-To: <20261121193345.2148966-2-piyus@iiitd.ac.in>
References: <20261121193345.2148966-1-piyus@iiitd.ac.in>
 <20261121193345.2148966-2-piyus@iiitd.ac.in>
Auto-Submitted: auto-generated
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Hi!

This is an automated message. This series looks like a fix, but its
commit messages seem to be missing some information:

 - How the issue was discovered, e.g. hit in production, hit during
   development, syzbot report, manual code inspection, LLM or static
   analysis tool scan.

Please do not repost the series just to address the above. Instead,
reply to this email with the missing information, so that reviewers
can take it into account.

*IMPORTANT*: If you do repost (for other reasons) - please include
the relevant info in the cover letter or commit messages.
-- 
The evaluation is done by an LLM so it may be wrong, if you think
that is the case please reply and explain.

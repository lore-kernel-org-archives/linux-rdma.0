Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794746072;
	b=kCvfNQEtMo4bwSB5KJ/B2IrJRMGSltY7CE5c2tiUg9d9PovNFbVMB8l+vnFkf/Ac4UCc
	 DN6/o5UySlx+Z8hPMVKMtVWK+Eq195g2/ECiPwKCJx5kTc6Vq2lfoveFXtDHKHxJ+D0a/
	 03I+QPMfXQFFPqB6VHtZMtdUCYpGy1mkzmj39qpZ+9goivahCaKhXWoJUdCitFyFXkbfa
	 KPSEQqU+oYL0wWvVm1hnZ1N8L5AAIlu4WdU9IreNTFCNOkWCskBVUoCA0zG6jvPIIlpr6
	 sg4YZv3Di3SvM0H+Vbqt1lklM6ojovaktJMtlmRpdACrM4dUjt/BvLfozcb6iDGq5tg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794746072;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:Content-Type:
	 MIME-Version:Content-Transfer-Encoding:X-Spam-Status:
	 X-Spam-Checker-Version;
	bh=Id9vGSlrDL1t4zwGiCOP4s5P1oMz9WDj7RNi2TTJ84g=;
	b=LzgVY7O8xQvRN6WOzjxW5RSX0ONwY9myOCXDJn7CNh0HAVXfOSbor5VlEx0I+4ZSRn75
	 9rAWJzOyLKcxR+YP2OGQgLZ7BCsV6joelyDSIswZ/qXjTKWXEmP5CJ04ZloAgXK74bLRk
	 +Z/8ejZE9MM0Lfn22In/Ii5F/MliHR9kUIHYFEI2xTU8tCCklJZbsxWuqtLVZl+GvBWnX
	 HJjG9gokp8pTjNVZblXmcAWAz3Z5xR3KUMCmWrz4BYp/t2F+2st004YxIxYWa5v1jBW0X
	 E5bm/lgp8lfqhifo1YxQla52YZ71XXepQDWz3CueM7ZaBlUnnwwMg88zTY5ECLDojGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=PODBvZRz;
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D4A8606A31D;
	Sun, 15 Nov 2026 12:34:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3D4A8606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=PODBvZRz
Received: from weh-cvm-dev-vm.y50bckvjo0hefgfnzfztsfttff.phxx.internal.cloudapp.net (unknown [20.169.55.37])
	by linux.microsoft.com (Postfix) with ESMTPSA id A542220B7167;
	Sun, 15 Nov 2026 04:34:19 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com A542220B7167
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1794746060;
	bh=Id9vGSlrDL1t4zwGiCOP4s5P1oMz9WDj7RNi2TTJ84g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PODBvZRzHERt9jxgzknYwqnmqDvJ/Xbszs8JdXm4J8+O80okHH/xGYKaTRzRp7IyR
	 MmF2+acGDujDsSFt9gTeo8cSZwghh5y5ni4Sr74RKnc325d/3Q2OpRCkNQQ9DaYcKJ
	 wWF7ArpfgpSLKEUT32IT75sClCBvk0vo9CnwOsOo=
From: Wei Hu <weh@linux.microsoft.com>
To: netdev-bot+sashiko@kernel.org
Cc: longli@kernel.org,
	kotaranov@microsoft.com,
	kuba@kernel.org,
	davem@davemloft.net,
	pabeni@redhat.com,
	edumazet@google.com,
	andrew+netdev@lunn.ch,
	jgg@ziepe.ca,
	leon@kernel.org,
	haiyangz@microsoft.com,
	wei.liu@kernel.org,
	decui@microsoft.com,
	shradhagupta@linux.microsoft.com,
	horms@kernel.org,
	ernis@linux.microsoft.com,
	stephen@networkplumber.org,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	gargaditya@linux.microsoft.com,
	kees+treewide@kernel.org,
	kees@kernel.org,
	mawasthi@linux.microsoft.com,
	weh@microsoft.com,
	edumazet@kernel.org
Subject: Re: [PATCH net-next v10 1/4] net: mana: prepare HWC ownership for safe reinitialization
Date: Sun, 15 Nov 2026 12:34:10 +0000
Message-ID: <179457550417.109246.13409427822482979137.hwc-v10-all-reviews-p1@linux.microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <179455239601.2199510.13335902064048081755@kernel.org>
References: <df083dc6ad8a8958398e04afe66ca2c5f4bfb040.1794208055.git.weh@linux.microsoft.com>  <179455239601.2199510.13335902064048081755@kernel.org>
Content-Type: text/plain; charset="us-ascii"
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Thanks for the review.=0D
=0D
Below are my responses, including the small follow-ups planned for v11.=0D
=0D
> mana_hwc_establish_channel() passes &hwc->setup_active as submitted. What=
=0D
> happens when the PF explicitly rejects ESTABLISH_HWC?=0D
=0D
setup_active records that the PF may own the queues, not that ESTABLISH=0D
succeeded. A nonzero status indicates failure, but I do not have a protocol=
=0D
guarantee that a rejected ESTABLISH leaves no partially installed mappings.=
=0D
Also, -EPROTO covers malformed replies as well as a reported failure.=0D
=0D
I plan to leave this unchanged. Clearing ownership on that error would=0D
allow freeing or reusing DMA without an acknowledged teardown or another=0D
proven quiescence point. Distinguishing a validated rejection would only=0D
justify that change if the PF guarantees transactional rollback.=0D
=0D
> Is there anything that bounds this leak? On the PCI probe path, a failure=
=0D
> with -ETIMEDOUT or -EPROTO frees gc via mana_gd_free_context() at free_gc=
.=0D
=0D
The leak is real. Final disposal loses the allocation metadata, and it is=0D
not bounded to one bundle across repeated fresh failed probes.=0D
=0D
Retention is intentional when DESTROY_HWC has not been acknowledged:=0D
freeing the allocations could expose reused pages to outstanding PF DMA.=0D
I do not have a confirmed PF-side quiescence guarantee for these paths=0D
merely from the calls that disable bus mastering.=0D
=0D
I do not plan to add unconditional DMA freeing in this respin. A bounded=0D
recovery or reclamation policy is a worthwhile separate improvement, but=0D
it needs a verified quiescence contract. This is a safety trade-off, not a=
=0D
claim that the allocation loss is harmless.=0D
=0D
> What happens to a retained context across a device reset? Only an=0D
> acknowledged DESTROY_HWC in mana_smc_teardown_hwc_locked() clears=0D
> setup_active, but a reset discards the PF-side HWC state anyway.=0D
=0D
The final premise is not established by the cited mana_serv_reset() path.=0D
That path suspends, waits, and resumes; it does not itself execute or=0D
confirm a hardware reset on every invocation. An all-ones aperture or the=0D
service delay also does not acknowledge that all old PF mappings are gone.=
=0D
=0D
I therefore plan to keep ownership tracking unchanged rather than clear=0D
setup_active or switch reset_vf on this assumption. A confirmed reset that=
=0D
invalidates those mappings could provide a reclamation point, but that=0D
requires the corresponding PF/SMC reset contract.=0D
=0D
> The commit is described as preparation for dynamic HWC sizing. Several of=
=0D
> the changes, though, look like fixes for bugs that can be hit in the curr=
ent=0D
> driver:=0D
=0D
Agreed that the existing failure-path and malformed-init bugs should be=0D
identified explicitly. I will clarify that in the commit description and=0D
include applicable, verified Fixes metadata. A stable backport needs the=0D
dependency-complete fix subset, not an automatic backport of the whole=0D
feature stack. I do not plan to restructure the series solely for this=0D
Low finding.=0D
=0D
> Two cases that used to WARN are now dropped silently: a completion for a =
CQ=0D
> id at or above max_num_cqs, and an empty cq_table slot. The commit messag=
e=0D
> does not mention this.=0D
=0D
I will document the intended quiet drops and correct the stale WARN=0D
reference in mana_destroy_txq(). That is a small description/comment=0D
correction; I will not restore WARNs for these cases during teardown.=0D
=0D
> Does this comment match the teardown order? In mana_hwc_destroy_channel()=
=0D
> the table is withdrawn and freed before the HWC EQ is fenced:=0D
=0D
The comment is misleading. Pointer withdrawal and the RCU grace period=0D
protect the table before the later EQ fencing. I will correct the comment=0D
to describe that ordering, without changing the teardown sequence.=0D
=0D
> This is a pre-existing issue and was not introduced by this patch. Now th=
at=0D
> the RCU protection of cq_table is documented here, though, mana_ib does n=
ot=0D
> seem to follow it.=0D
=0D
The independent RDMA CQ callback publication/lifetime issue is=0D
pre-existing. We will address it separately. The comment clarification=0D
above is not a claim that the separate RDMA lifetime issue is fixed.=0D
=0D
Regards,=0D
Wei=0D

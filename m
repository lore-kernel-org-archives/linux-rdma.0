Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794746075;
	b=otUPC2XiZHKyk5G/0bmbLmFhiEc/rQQfHHm6gykAk+hQ7I5UB03fYpC3Vocp/W5pF2lk
	 7mdaiHidDSG6grdLnJqbS/OFcFTCkk76f8QGQzJKQNC+kH/UkOrRl/Q2KIVNPSv8PoX2D
	 ZTU8PU49JG8/s3SV7EwPFzRdW8PKA2viu+KYGqmvxDN+KkJTdxXkbTeBmJVYxqjjDIxs6
	 lWWHNEj9pTBCikfDASnXYMyBuZeZXXiOIxin8KM7IUuG20do4xGgy8KZmhaMXh5XMwDAD
	 lCq1V2KQAe1kxds1MCci/oIYu6j2M72impVMD7zD6nL3bGF4NyYspYfoVjy07kL8c5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794746075;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:Content-Type:
	 MIME-Version:Content-Transfer-Encoding:X-Spam-Status:
	 X-Spam-Checker-Version;
	bh=+jQashNltLw+ocyr/YXlLyfk8PT4+1WyovCrrhhY0HE=;
	b=Wog7KUv+HYlfMr4KtcEmd3zomUTa/o/EyOr8ckzJ6t14hSYlKf6k/nnU2cKmvEag+NZ1
	 QOvBur9lee+C/GHrMfcluI4elkKG4+rHk6rbEoO5iRsBOZZgaMKd8WdDjjWRjwUiHndj5
	 /HR2g5FFYhw+rbIjftQyedC7XcmyjvFp3A5CyDAyZDgJE/FIhtDSxuTkNxHsxVBNxpERM
	 d+Pi1Sk/ReyMItqEHoaWeAHq0SQx1ECXaiYcBJ0w8kTtSEcnh/4O3G3QHoXy0d0TO+BvV
	 2DDzao18pbhCW3fybLuM4dfUhepYgfLDoU01PeTmhSDY/SlTlmzTMNG4rfUSOp78FVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=Jcg2I8RT;
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 274FE606A33E;
	Sun, 15 Nov 2026 12:34:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 274FE606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=Jcg2I8RT
Received: from weh-cvm-dev-vm.y50bckvjo0hefgfnzfztsfttff.phxx.internal.cloudapp.net (unknown [20.169.55.37])
	by linux.microsoft.com (Postfix) with ESMTPSA id C9E9920B716A;
	Sun, 15 Nov 2026 04:34:22 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com C9E9920B716A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1794746063;
	bh=+jQashNltLw+ocyr/YXlLyfk8PT4+1WyovCrrhhY0HE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jcg2I8RT/dkvAEPu5VhkEOoaPZShgncM+vQhjXobgG2uvnnuhbhXe6B0UYHNfIS11
	 ZzhN07diyfTMPjD4WBCrutuzXH7ybeqDtIOPQU9w1P6shDm0/y4ziciFrEzL58w67o
	 k/G2q/IrBvgAUb8VyYLyh9qaCi4a7eQxBPAFLnSY=
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
Subject: Re: [PATCH net-next v10 3/4] net: mana: support concurrent HWC requests
Date: Sun, 15 Nov 2026 12:34:12 +0000
Message-ID: <179457550421.109246.13016810300207001034.hwc-v10-all-reviews-p3@linux.microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <179455240021.2199510.18244084352437360589@kernel.org>
References: <2ae0e8b22569dc23178d0ea42178808ad92cb6db.1794208055.git.weh@linux.microsoft.com>  <179455240021.2199510.18244084352437360589@kernel.org>
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
I will respin the series as v11 to address the admission/teardown=0D
interaction below.=0D
=0D
> Can this reject teardown commands without ever posting them to the=0D
> device?=0D
=0D
Agreed. With no available slot, abandonment or cancellation can return=0D
-ETIMEDOUT before SQ posting, while existing destructive callers can still=
=0D
free the associated memory. Their error handling predates this series, but=
=0D
the new quarantine-related no-post condition must be reconciled with it.=0D
=0D
I will address this in the next revision while preserving the lifetime=0D
protection for timed-out IDs and buffers. Releasing a quarantined slot=0D
merely to submit another command would reintroduce the late-response and=0D
pending-DMA hazards.=0D
=0D
The rejection is not permanent for every later command: a late response=0D
can release a quarantined slot, and free slots remain usable. However,=0D
that does not remove the unavailable-channel teardown concern. The=0D
source-extracted tests reproduce the no-post/free control flow; they do=0D
not establish that physical DMA corruption occurred.=0D
=0D
> Only -EBUSY keeps a caller waiting here. mana_hwc_try_get_msg_index()=0D
> turns a full bitmap into -ETIMEDOUT whenever abandoned_msgs is non-zero,=
=0D
> however many of the occupied slots are actually abandoned.=0D
=0D
This mixed-pool case is real. One abandoned slot does not imply that the=0D
other occupied slots cannot complete normally.=0D
=0D
I will cover it in the same admission revision, so partial abandonment=0D
alone does not rule out progress from those other slots. Cancellation,=0D
channel stop, and exhaustion of usable capacity still need to wake or=0D
terminate waiters without reusing quarantined IDs. I will not treat an=0D
abandoned-count comparison alone as a verified fix.=0D
=0D
The revision will include focused regression cases for unavailable-channel=
=0D
teardown, mixed healthy/abandoned occupancy, full quarantine, cancellation,=
=0D
and late-response recovery.=0D
=0D
> This isn't a bug, but the quarantine here also fixes a real misdelivery.=
=0D
=0D
Agreed. I will name the original wrong-command response/misdelivery bug=0D
explicitly and include the verified Fixes lineage and backport dependency=0D
guidance. This is a commit-description/metadata follow-up; it does not=0D
require an additional quarantine mechanism.=0D
=0D
> Will this also hide live-channel failures during setup?=0D
=0D
The specific "test_eq failed" diagnostic is suppressed for the private=0D
bootstrap context. The final patch's outer HWC test still logs a generic=0D
failure, so setup failure is not wholly silent.=0D
=0D
Keeping the specific diagnostic is a small, useful fix. I will preserve it=
=0D
using the explicitly passed setup context, without publishing the HWC=0D
early or weakening the intended suppression after runtime unpublication.=0D
=0D
> Should gc->hwc_drain_waitq be initialized once in mana_gd_probe() and=0D
> mana_cdx_gd_probe(), next to spin_lock_init(&gc->hwc_lock)? It belongs to=
=0D
> gdma_context, but here it is re-initialized on every channel creation,=0D
> including each mana_gd_resume()->mana_gd_setup().=0D
=0D
Agreed. I will move this initialization to gdma_context creation beside=0D
hwc_lock in both PCI and CDX probe paths. The per-context waitqueue should=
=0D
not be reinitialized by each channel constructor. This is a small=0D
placement fix, not a broader device-lifecycle serialization change.=0D
=0D
> This is a pre-existing issue, but the new comment claims an exclusion=0D
> that nothing seems to enforce. Is anything keeping hwc alive between=0D
> this read and the later mana_hwc_timeout_read() and=0D
> mana_hwc_timeout_update() calls?=0D
=0D
The wider raw-reader/setup/PM/service lifetime and serialization issue is=0D
pre-existing. We will address it separately. Moving the per-context=0D
waitqueue initialization does not claim to resolve those wider races.=0D
=0D
Regards,=0D
Wei=0D
=0D
pw-bot: cr=0D

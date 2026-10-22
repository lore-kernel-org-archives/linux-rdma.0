Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792682158;
	b=ewDo+CGCWF4hbKWdVAYUYdy+sxqrAbChqKrEnq2yCpIUxER0TyZufa+cJ4xSXyhwZcSY
	 hE8OT9JDep0Ze0PKmakCo8USqEJRJs8I657NkTl42BPa2HHg/8jHicrZq3JOiVi+ko8oZ
	 gYUHFtHcyt83fxWOTf70yxTpF3oMIVs3W0FZSmc1Zjvav6irhUCh22BWIwIxtSVqSann1
	 /brMcdm97AfPYfgrk5dp8M1YZI9k5OdXT/E3LhfW8dcaJ0Ge7f8Q8D0TYhldskWVQ+XOt
	 IlzlhdnxGil2ugpL9UmDfPxPVBqrs3ilVxrSCCgqQXiC0s+l4NBQHKFvwFTYJdhQNbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792682158;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=zOaryBVHnzSXJW7hn6V0qsHdpj5o4fMOReE87gBMUOU=;
	b=Bg6l4WDmN4fdzg40qjFeBdWZ/34buhv/DQW6odwliIjdXpVvxTvu0yYMfGVhkqbfQJTi
	 fSImC2Kx6bsAJldHFnpd2pixClP/FS2Oq8qTTW75C0seLRA2xwZMYrko9fCn6nMhuCHxG
	 CP4oTsFD5MgbDMFRuSNXtWwTgHU1RzgGipdKIEjy57d5/uwVBQaaajm/erBujIqOFKsk5
	 fzGuvtOTS+HzhppaxoIwhft1VULNy0TFyIt/bY2LPnhQ9XmCmsjgu5YHUI/Gv9IXBFzDA
	 k50YoRVELJtN/7oL8kEOs7YLWZLQh/T+P4E60NRsh4tcuHtrKSd81jeQP5PHT4adZ/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Spgo07fN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0B15606ACE7
	for <linux-rdma@vger.kernel.org>; Thu, 22 Oct 2026 15:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Spgo07fN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E9F71F01825;
	Thu, 22 Oct 2026 15:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792682157;
	bh=zOaryBVHnzSXJW7hn6V0qsHdpj5o4fMOReE87gBMUOU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Spgo07fNAP1q2quJcOyPt3n5GmT/Tz/VmudaQl2bvvJ2pnSRdGuu4+Z3M0BnuVHpV
	 /3vt0J5vyWXoEcno9klR6MbkSsmhAFKRMYdwB/j5OVfJuvcFR/6VLpS9882kvLniid
	 vm+wC9F6IzTSDY81QQhDb+mXMdZzpsVyDGSaW37RAdKvARLhusyiae2tiwgiPEpQ0w
	 av/eLx/qKSp8IYi5lv5owfduA/vksX3D9RC14rAx9Ms1ybkkn2SHKfihe/4wIhPPXP
	 xvxvFXUow5jQv3bvw4cdR4d57lZxE2ANboY4Yq7EnoN3ZlqSgeupPKG59XLQyQJ+uQ
	 IO4JQVDFbq1og==
Message-ID: <sashiko-outbox-181683@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v9 4/4] net: mana: add dynamic HWC queue depth
 with reinit path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wei Hu" <weh@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <2bc87c73f232a72eeda9a604d7581bab690968f6.1792679388.git.weh@linux.microsoft.com>
References: <cover.1792679388.git.weh@linux.microsoft.com>
 <2bc87c73f232a72eeda9a604d7581bab690968f6.1792679388.git.weh@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 15:15:56 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Long Li <longli@microsoft.com>
>=20
> The HWC starts with depth-one bootstrap queues. Treat the PF-reported dep=
th
> as a maximum and rebuild the channel exactly for reports from 2 through
> 128. Keep the untouched bootstrap queues for depth one and reports above
> 128, and require a rebuilt channel to repeat the selected depth.
>=20
> Treat the reported request and response sizes as directional maxima.
> Rebuild only when both reports equal the 4096-byte bootstrap allocation.
> Keep allocation strides separate from these limits, and share the effecti=
ve
> host-to-PF request budget with the GDMA and RDMA request builders. Bound
> RDMA CREATE and ADD_PAGES batches by that budget, checking that the heade=
rs
> and at least one page address fit before subtracting their sizes.
>=20
> Reject oversized messages before acquiring a slot or publishing caller
> [ ... ]
>=20
> Link: https://lore.kernel.org/r/20260908035201.402424-5-longli@microsoft.=
com
> Link: https://lore.kernel.org/r/179196575846.434549.7933818740976196422@k=
ernel.org
> Signed-off-by: Long Li <longli@microsoft.com>
> Signed-off-by: Wei Hu <weh@microsoft.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1792679388.gi=
t.weh@linux.microsoft.com?part=3D4


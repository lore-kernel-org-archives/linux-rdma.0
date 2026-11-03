Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793696942;
	b=4r/oPOL5bxyeuGZc7dycDYxydRdM5BX4yBuSz0fgTcMwXwtN10GEng638HPFkNxAgkTq
	 YA1UpaAmygHbmk75yaKdIRZPbFFAXmHe3zMGQ5BYiX7X3y4xSpyrx98f8Ze0E9MQKocki
	 PmqfARiq02iw64VdhidMadVBq/IKdLG8Emyx2yqQ/z9/86N50VhIAAudbmf7D8cW48dG5
	 4uoyL0vbUw58dTUynUiN/mDBwa9on1fKsWNzaZd5u7euFkFKJw6ofjL2H2VLWF8E2RJh0
	 Szu4bbWv8xq7Kf5f+MnPkrXOdvoNylj5g8ddy7C3IhxHBr2I8A1O5Za6K1j20Zo2nXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793696942;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=rbB3/c4h92YNQqndhw+kMdb1cA//aMsaFmSrkyNnO0Y=;
	b=Jdz+gYaieAmuL/856GDt+SnnumXDOH25dXQ6lfdRXVwY8dN8+z4h+DbwkNyz06LBfeiy
	 eOYsfwxhX4A6/kVVW2EhdW2axIJf5/hcIoi2UoAsKxLaeztRWFpQOM1M6k6p8E/LLxFXV
	 l2sFWdxVwKBDUTNJ5maJzsc2W5uKerIKjC/06kHXLwvvG7VW7Znmb9ihBtQc6a0iNU58J
	 /FHS7H62uF5rBeOKlYD2FutO6suXIEoRuonsdeaoQ0fPC0Hsa7l8n1Oev21qMiZOVE7EF
	 qVB/jeHVBQoZRY5Qj0Ns4mQzQnwMYr6aYr+/7Spi/jN/vBFfCYX1N27voQdzrCdQMJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dscVXShT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9CBE606A32D;
	Tue,  3 Nov 2026 09:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dscVXShT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 118BC1F000C1;
	Tue,  3 Nov 2026 09:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793696941;
	bh=rbB3/c4h92YNQqndhw+kMdb1cA//aMsaFmSrkyNnO0Y=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dscVXShT+hFOo75O53e5Tz3HyQpUy6Um6wq+oI3sNugypK2FxMVqeyXpbJa4ZkOdP
	 +A1HhyFRAQcBgfwXrb9PCjnQC+JuxPlScERI6qDvDX03X9HJjYGzF2FqL1MOyIdvFH
	 GuaNcpu7eUP8Fao6CrRkLZ7+An4tTJIgzQj2qysl9hjKZVQUOLBB2mKWtSc6ib67qA
	 MH+OUe0R7PataotUy3hnGXfoqq6YoMlcQvZdIbyu5zhwMz3MmCRypWJ1Pic2IGYaGq
	 j6FYRfTuLtsVlD+xr8cL57hn43NRYZU/v+wdsz/pLHCLzKKLsoTzlB62nGFv+K7s9M
	 PKMeFchXfMfBA==
Message-ID: <sashiko-outbox-194933@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v12 04/19] PCI: Reject unreadable ACS controls in
 isolation checks
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261103-fix-p2p-acs-v4-0-v12-4-912101f93517@nvidia.com>
References: <20261103-fix-p2p-acs-v4-0-v12-0-912101f93517@nvidia.com>
 <20261103-fix-p2p-acs-v4-0-v12-4-912101f93517@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 09:09:00 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> From: Leon Romanovsky <leonro@nvidia.com>
>=20
> pci_acs_flags_enabled() and the Intel SPT PCH quirk use ACS registers
> without checking config-space read errors. A failed read may leave control
> state indeterminate yet allow the device to satisfy requested isolation
> controls. So can a read that returns all ones with a successful status,
> which is what a device that does not answer usually produces.
>=20
> Return false when either ACS capability or control state cannot be read
> or reads as all ones, which neither register can legitimately hold. An
> unknown state cannot prove isolation.
>=20
> Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
> Tested-by: Tushar Dave <tdave@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103-fix-p2p-ac=
s-v4-0-v12-0-912101f93517@nvidia.com?part=3D4


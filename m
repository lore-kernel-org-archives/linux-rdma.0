Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B7B22D8DA8
	for <linux-rdma@vger.kernel.org>; Mon, 21 Sep 2026 10:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789985022; cv=none; b=I2EZuknKWiryOLaSwo6iDnXU9UI6OjNvRpFlhOU1iEiCdnQrTw/6ZOMFTkAOgt0ngyVSO8viKIUY/3V+fRLwXJbVHmbbusAOpX11DdlxSHDAmUnpkSWAHlbev4Wka5TQg31T00kU1tK1E0itrA8h5InontRf6X+PTbVRev2JOeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789985022; c=relaxed/simple;
	bh=Ym1b9AtCXJCf6g5nd1AON2sGAbTYk/eZxqcTr+UgYuY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=XfP5Y4JjEoHx9Lr2bBx0Gj9nlVmUPIey6jBFHGwLAw/YVUztFu60XhXhQjXQDx5XmAcpE9E5yUTA7OPc7cgDVRqSvFWyVR/9e4cb6gQv9TiGAOnUj7aM3fv2qhceOCLDO8vIKLnwU/ThyqJdoGxHLG2dJeys0jqA5jrf2t87osE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P07S5cL8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P07S5cL8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE3451F000FF;
	Mon, 21 Sep 2026 10:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789985021;
	bh=Ym1b9AtCXJCf6g5nd1AON2sGAbTYk/eZxqcTr+UgYuY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=P07S5cL8DH5VkNK9z4IZZjMXRzLmC6F8nT4f62U3vkXDR1I3uONsS+Hq+6F7LN6zN
	 bzAzT+hDCiZW8ceajgQZTSWwhXMj6ZKfy3U+ClJxAA/cHMXWyR0DESfrWxLOfkVDv5
	 sDJGcFP9u99KkrYy7MEnBH13VUmbj384uzzItXcC0o6ZqnHgTfxYxxgHiqFSKGhcjb
	 ZsiRJPk65K3NvgGp4zjTjzYof81kK8BKj1VfqS6bFpGmqEnTCb6d7hA+nzo97zBn5a
	 vH43FO1ZEGBN7NehduBgDZNCjIDdYAWqMYwsNb6e9Z9czAsYS8u3Xpimcm1W0CAym9
	 nuphPqL4vKsPA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v3 2/5] RDMA/mana_ib: Revise UD send posting
 and WQE definitions
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260921095352.3524691-3-kotaranov@linux.microsoft.com>
References: <20260921095352.3524691-1-kotaranov@linux.microsoft.com>
 <20260921095352.3524691-3-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 21 Sep 2026 10:03:40 +0000
Message-Id: <20260921100340.DE3451F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Konstantin Taranov <kotaranov@microsoft.com>
>=20
> Batch a linked list of UD or GSI send requests behind one doorbell,
> returning the first failed WR while publishing all successful entries.
> Move the send PSN into common QP state and describe the extended RDMA
> send and receive OOB layouts needed by subsequent RC support.
>=20
> Keep UD's inline OOB explicitly at INLINE_OOB_LARGE_SIZE even though
> the shared software OOB structure now describes larger formats. UD
> therefore continues using the existing GDMA encoder; extended GDMA
> WQE encoding and RC feature gating remain in their later patches.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260921095352.3524=
691-1-kotaranov@linux.microsoft.com?part=3D2


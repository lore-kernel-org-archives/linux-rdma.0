Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6969742378F
	for <linux-rdma@vger.kernel.org>; Tue, 15 Sep 2026 17:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789492374; cv=none; b=O8KziG2lx6oHSEqgPwowrcufHXTxuU9uHJwhy4wdGSHL4oZa+BFp+Qp9YOfPAHQz3IbhvPBt51EKT93FS9VcJRhiX4KDInBaTIFS0XOB+9seyJYHCOj8UUXo8EsjLjMKnRQXpqlbKgRPckyx8m7tc96SG7ygxUfX/A1whwb84l0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789492374; c=relaxed/simple;
	bh=Zd2JeX0wB79Qgmp7/CFZmrXuZrgrAeWBn3PiSH2tZHM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=kbPvq0tSri4DrR8EcceXlEejWOGQ9y1fIL2xLDFjNDrAwW9NwRYDK2mwL94u/WUJVZ2T5kCfbDW+k22EkTXOKl87sFG5NqER2b8hNp1Qqmj3AiPhRCegHI7Ey6OfW8RaG7A8EiIfLuriJabIFr7DQQ8MMDlqeAn1qpaOoxIe7ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j/Wv1/sr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j/Wv1/sr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D635A1F000FF;
	Tue, 15 Sep 2026 17:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789492373;
	bh=Zd2JeX0wB79Qgmp7/CFZmrXuZrgrAeWBn3PiSH2tZHM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=j/Wv1/sriSTqZtdf6dIuzNlTnCOFQH0G4HmCsUYemp72SN+EonJvEnI3sm6f9r5qT
	 5w/HbNCiW+TabQap3fBC+Ii08uiz9IR5xQC2nW9X9CgRLV0QwU31tTHoddyKor5n8m
	 MqzJCPqigA3s0tI5KGnNSOvPBShXR69jeh8/0/PEeCIZVvXkGDLU2bbrZxzAZhVThs
	 cV9pjJeuKCzqpviv2iwf/7cnbkPveG6uu4Mf6SYgFPtyi0bBcqAhgKZorvezj2g8PL
	 RTML9UdlfdqfNBhw+liz5q8sAnKL03pBRsU9u+GVoGnGXWwaOMQKyhc+6pBkTErrom
	 btCTE2B+Cxr0Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] RDMA/irdma: Fix erroneous -ENOMEM for large MR
 registration
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jacob Moroni" <jmoroni@google.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260915170317.2901672-1-jmoroni@google.com>
References: <20260915170317.2901672-1-jmoroni@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 17:12:52 +0000
Message-Id: <20260915171252.D635A1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> Commit cc8997c94bf3 ("RDMA/irdma: Refactor PBLE functions")
> replaced the explicit level1_only boolean with a bit mask
> but did not properly convert the "if (level1_only)" check
> in irdma_get_pble() to be "lvl =3D=3D PBLE_LEVEL_1" and instead
> left it as "if (lvl)".
>=20
> User MR registration passes "lvl =3D PBLE_LEVEL_1 | PBLE_LEVEL_2"
> so this check always evaluates to true and causes the
> loop to bail after grabbing a single SD even if the region
> actually requires more than one SD (as is the case for
> regions larger than 1 GiB with 4k pages). As a result, these
> registrations can fail with -ENOMEM even if there are
> sufficient PBLE resources.
>=20
> Fixes: cc8997c94bf3 ("RDMA/irdma: Refactor PBLE functions")
> Signed-off-by: Jacob Moroni <jmoroni@google.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915170317.2901=
672-1-jmoroni@google.com?part=3D1


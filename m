Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 671475304B2
	for <linux-rdma@vger.kernel.org>; Wed, 23 Sep 2026 13:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790169999; cv=none; b=gzIeIfwVsFhlU1rAZ9XGm/D5hAtCyog0b67HBdPoo/VoR9WEAiVezLG0QLdYLmbqPIaTPNGeaDSVPrevr2ZJUj7+6JDfzuTSgrOJvD2wdTyG4/0JBllYdrOtY3K4tz71ywdn2ovDprOC2y3AmV62iBKYk0GxYyReFbGlBUY1on0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790169999; c=relaxed/simple;
	bh=PfHfk7jMIDILyUqBZHYSOsFCrupLDR2EwilLzknL85w=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=VPWRDUq3VxgNa5AaEm/2/TN01h9pdPBCQEZEY0Vt7oRzyjfh8dBWytIjNwtzz16j0K79Q/QjzacsRmuHGAfXRD5PTgrNiNM/ZZx8IK6kvltCFPqJW0SfFy1XHYJ3Vz6gYZ8C2Ch0rRKkBFgATKcNudKpQk2C20aesqeNytzqKQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EUEl2dXk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EUEl2dXk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01FEC1F00898;
	Wed, 23 Sep 2026 13:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790169998;
	bh=PfHfk7jMIDILyUqBZHYSOsFCrupLDR2EwilLzknL85w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=EUEl2dXktmZhhv74zMENnqsGkBc+p8HfdrU12HJLJ5ArUKcvEtVuAxwCM6ymtURYj
	 14xdmOqJ9irrFIckMNW7PWqfaIrZyEtYfW5Ym46VvggjPo5ieyEKs69CWyivWp4kdb
	 l3VJk8jIM1lDqux8/UAEHhNOduWea+VeUdvrjlPJ/PYNtCjTdI2DkobuFXi0cToc5t
	 ch9wOBQfVXJW83uPxV0ki7ZsoBb5FhQ5csMoXfqHgFPZKBcWZQ6jn9aK286rdhPKbU
	 L6dOvoBg9vAkfwBIgJVxNle/HwliclteSMSBfIl31Ivo/tVgYmKMU1yNZPOhfor09N
	 qIpT81B4Srhaw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v4 1/5] RDMA/mana_ib: Optimize shadow queue
 bookkeeping
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260923131155.4055875-2-kotaranov@linux.microsoft.com>
References: <20260923131155.4055875-1-kotaranov@linux.microsoft.com>
 <20260923131155.4055875-2-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 23 Sep 2026 13:26:37 +0000
Message-Id: <20260923132638.01FEC1F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Konstantin Taranov <kotaranov@microsoft.com>
>=20
> Pack the posted WQE size and send opcode into compact bitfields. Move the
> UD receive shadow fields into the common shadow_wqe_header. This
> simplifies the code and lets all QP and WQ types share one structure.
>=20
> Use release and acquire operations so posting and polling can safely run
> on different CPUs.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260923131155.4055=
875-1-kotaranov@linux.microsoft.com?part=3D1


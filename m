Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795795014;
	b=z6oZMQRnPvWsEB+Xysibo6b5OiYG39Rh4+WTNfC7aNmBJZ8dcoG0jnB/+jcXknTbzakC
	 C2h5ocXuNyjlVrSe0oA6Fs5+xD9vSgV5Jat1iTlDt552LFiZ47riQe1QkNTf/2Fi6yXY1
	 /wBwy86Rr9nXyssPpJbk03lw46lgndw1jTYnoMx9ocXBin9ZlS9nNaU/+9JZap4q9NaUX
	 //sr1ok6XmeArLNL9SnbonoDxpJQol6Q1Y+T6i/pa2pOdS5oPikKv1a2jpYkdeLwApkXv
	 +zW9aSvDTj5RJ3lrNeofAvTIYucVSs2lov1XOnciU/gui17VhEdIBlDquR/fy9Uz/+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795795014;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=D3V61pmSump7Y+Ma0dHql66TkjkhBzJrhzOLdApCp4w=;
	b=ooX2lAa48U8TcX939v4bP4kxDEnZOPohlNJKn8iGgJqCdIDOPOD/N272ca+QRPbPrPjB
	 jZaZviZPcsEggOWXx9fMmPgPoaQVG54O+wtx/m1J5+UQ/3xvrFBOvtoJVwgW7SHf04Zyi
	 cfBcb2mYZxXPDKEHAUeDKayKS0D5qVy1mgdQ/2uIYYBlYwFAhAN7kfl/yaM0+gfGErPvU
	 QN7Fm6NzrMBRjYiJTruJE0NxYoKzSnU3K8oRQKFid69XK+y7HkUcmrx7Ut3tmmwVIJzgC
	 kP48VssYVTXA5ldBd/xHKu/K4E7gH5ZL19Eljw6hYH4L2QcrlbBMqBrRNbMZ1S8z3TQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jnWCIup8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22F64606A323
	for <linux-rdma@vger.kernel.org>; Fri, 27 Nov 2026 15:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jnWCIup8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3F7F1F0089C;
	Fri, 27 Nov 2026 15:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795795013;
	bh=D3V61pmSump7Y+Ma0dHql66TkjkhBzJrhzOLdApCp4w=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=jnWCIup8xLOAfDWVecCEZ2SlOJu2YVpajIgx2UdLnmM5JIPJ7yvSK8YiJW2HBkG8L
	 xbdkBBuKRjjy/OZLBA3sw5uwdipgs2shMP5PvIzyupw+R5MEnpS5+3e3xu5AuBHcSJ
	 Ql3jSuftpcaJECOY8PsXJu8ofdjefGvwqkaHT78lIKt2SwcH1h5rr2cwsm7kBZqjyO
	 IeyWGmNBG2hQX5x440r1yF+rbUe7ch0McvTSQ2uaQZrNNnBzEtusTHQ0EAOwV49eOw
	 uy+yzDsEPNTT8keg9SeqiwxP72KHwh69jPn3NLiwQWDA50yGL8PQOhyDX2IOE4iqWj
	 lPhg5A75qFFLw==
From: Leon Romanovsky <leon@kernel.org>
To: tatyana.e.nikolova@intel.com, jgg@ziepe.ca, 
 Jacob Moroni <jmoroni@google.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261126173430.2097445-1-jmoroni@google.com>
References: <20261126173430.2097445-1-jmoroni@google.com>
Subject: Re: [PATCH rdma-next] RDMA/irdma: Add budget to CEQE processing
 loop
Message-Id: <179579501033.1359953.13187754627136143856.b4-ty@kernel.org>
Date: Fri, 27 Nov 2026 10:56:50 -0500
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Thu, 26 Nov 2026 17:34:30 +0000, Jacob Moroni wrote:
> irdma_process_ceq() processes CEQEs until the CEQ is empty and
> runs in a tasklet. Under heavy load, CEQEs can be emitted as
> fast as they are processed, so the tasklet does not return,
> which leads to RCU stalls.
> 
> Fix this by implementing a budget in the CEQ handling loop. If
> the budget is exhausted, the tasklet is rescheduled, which gives
> the kernel a chance to defer to ksoftirqd appropriately.
> 
> [...]

Applied, thanks!

[1/1] RDMA/irdma: Add budget to CEQE processing loop
      https://git.kernel.org/rdma/rdma/c/211a4cfd857ddc

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>


Received: from aer-iport-3.cisco.com (aer-iport-3.cisco.com [173.38.203.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3231847729E;
	Wed, 26 Aug 2026 20:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.38.203.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787774980; cv=none; b=NVBd5mo93KZxDOJuXqlEtsA4WrijyorZLqsgabqdWXcc5HO0z0HUn8I+zrCLSvsvfVCAvLbfCk6TXJg5rbuDs43W+D9e9sHoxpcpL4C+kqyF3IyHscKEeAF9sbqLsvvjyAHUJOKlAYSgDZl70FSIRpQjMm7aaXGsBWHkukDUydM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787774980; c=relaxed/simple;
	bh=xFxKnBlj3v6Qc2mrCVc0d/tS+1MVh2H+i9VS2Fv0Lac=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 Content-Type; b=tNeBhgusMjirIXRpZN0HEDlVOeqvmL5Q5bddkK3+iIU9T8YfeNMinffZdPtzKmZo/LOczUlpPw2ogKGOixm2JgbFGr2go1EdfQwDBBeEUbjDYIspak9YweIRCYX3eGj5TddBlyAEsNvknZyp/Z3aQWy5JHGlIJDkjmJdUuLNwqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=U+dLLb6x; arc=none smtp.client-ip=173.38.203.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="U+dLLb6x"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=110; q=dns/txt;
  s=iport01; t=1787774975; x=1788984575;
  h=date:message-id:from:to:cc:subject:in-reply-to:
   references:content-transfer-encoding;
  bh=xFxKnBlj3v6Qc2mrCVc0d/tS+1MVh2H+i9VS2Fv0Lac=;
  b=U+dLLb6xdrGgPq/+ks63IWqEtnbKlvCb6F7RLEIJotHCZAuCqkNKpfMY
   Qi2lXucR8sVo4nMzB9V8U9b9q9P4DqfIzv+szwebU+YcxyhB+5rOgSTP4
   XPB1xdmDY8iQk1m5j0tljxqteHAjawBClfvmJVwCzYSDQgIdvx8j3DjuJ
   ma6F8eG/BR0W7g2FwpehZtHDXnNnqMLdwxmhfHAL8fpUQOya6QFxOZnF/
   ioa67RwtebnKy89lLtDjsBJ7mE9q87lXxA/rF6PZa8Y0Az3v9wRuFe1yE
   YUbKuBFrfTvbf44MdghK6kntBjklYycwnUZMqexmjAxFSnJFKxNml2FxG
   w==;
X-CSE-ConnectionGUID: MwLpWujqTLq+BRhg/vp8hQ==
X-CSE-MsgGUID: iIwTDY1OQCufgnlsUFnyCA==
X-IPAS-Result: =?us-ascii?q?A0BxBQDRRo9q/8pK/pBaglmEKUOFIIRNiwWGUi2NPIwEg?=
 =?us-ascii?q?X4PAQEBD1EEAQGBUQGDKQEJAo1sAiY0CQ4BAgQDAgMBAQEBAQEBAQEBAQEKA?=
 =?us-ascii?q?QEFAQEBAgEHBYEOE4ZchlsCAQMjDwFGEAsODAImAgJWBhuCeoJ1A78oeoEyg?=
 =?us-ascii?q?QGEftlJgXIVgQouiF4BhXiEfCcbgUlEhA8xPogegmoEgiKBDJNkLCZ4HANZL?=
 =?us-ascii?q?AEPETUTFwsHBYEjQwOBBiMPPAUtHYEjIR0XFx5YGwYFEiAqQUQVDgM+gRlBA?=
 =?us-ascii?q?oF1PyMZNnyBCV6BKylkAQIQF0YuFYIHAoJagSdeAgFJQw4HRz4LB2Y9NxQZB?=
 =?us-ascii?q?AIBOnuUUpdLsCOEKKFkEhwXg3EBk22TDZkIqUOBaDyBWTMaCBsVgyNSGQ+OX?=
 =?us-ascii?q?89fRW8BAQcCBw4DC4FokX4BAQ?=
IronPort-Data: A9a23:OvUitavi9iCeNXajuklLLf2y0+fnVI1eMUV32f8akzHdYApBsoF/q
 tZmKTvVa/mMY2XzLtp1YNm+pBwD7JOGmIMwTlc9q39hFClGgMeUXt7xwmUckM+xwmwvaGo9s
 q3yv/GZdJhcokf0/0nrb/656yYghclkf5KkYMbcICd9WAR4fykojBNnioYRj5Vh6TSDK1vlV
 eja/YuFZTdJ5xYuajhKs/LZ9ks11BjPkGpwUmIWNKgjUGD2zxH5PLpHTYmtIn3xRJVjH+LSb
 47r0LGj82rFyAwmA9Wjn6yTWhVirmn6ZFXmZtJ+AsBOszAazsAA+v9T2Mk0NS+7vw60c+VZk
 72hg3AfpTABZcUgkMxFO/VR/roX0aduoNcrKlDn2SCfItGvn3bEm51T4E8K0YIw3/lTGV5T9
 +UkDClORCqDiKWo2OK7c7w57igjBJGD0II3s3x6iDWcBvE8TNWbGuPB5MRT23E7gcUm8fT2P
 pZFL2AyMFKfP1sVYg1/5JEWxI9EglH9bzpcrF+JjaE2+GPUigd21dABNfKIJYDSG5wKwS50o
 ErH3nvFLiBDE+W01DSK9Ha3u8HJjAjSDdd6+LqQs6QCbEeo7mAaFhATfVeyv/S8jkmwR5RZJ
 lB80jEio4A880mqRdnwQVu9rRasvBkcXZxeGvYm4QuAzKb87AOQB2xCRTlEAPQruNIzTC4ny
 neGmNTmATEpu7qQIVqR/7GVoDeaOC8aIGYYbygUCw0I/7HLqZovphHCVNBuFOiylNKdMTH53
 DOiryUkgbgXy8kR2M2T/k3Nihqvq4LPQwpz4R/YNkqs6A9jaZHmYYG05VXFxfJdKoDfRVnpl
 HQYktSD6O0HJZeTlSCMSaMGG7TBz/KINzvGhnZpAZgt9j3r8HmmFahV6jV5L0dBNNgFdT7gJ
 kTUvGt5/5ZeMXevRalpYo6wAoIhyq2IPcjsTPHNcvJIfJl9dQbB9yZrDWaP3nzwuE4ykK0+M
 NGQdsPEJW4TA6lhzRKsSusd2KNtzSc7rUvZXZ7T0Ruqy/ydaWSTRLNDN0GBBsg97aWZsEDW/
 sxZOs+i1RpSSqv9bzPR/IpVKkoFRVA/BJbru4lNeuuKChRpFXtnCPLLx74lPYt/kMx9kOrU8
 nyjclFXxUC5hnDdLwiOLHd5Z9vHRop2p3Y2FTIjMEzu2HU5Z4urqqAFePMKkaIP/eF5iPoxR
 P4fdoDYW7JESy/M/HIWapyVQJFeSSlHTDmmZ0KNCAXTtbY5L+AV0rcIpjfSyRQ=
IronPort-HdrOrdr: A9a23:MyRuC69VFDpMh+gZk3puk+DyI+orL9Y04lQ7vn2ZhyY6TiX+rb
 HKoB17726XtN9/YhsdcLy7VJVoBEm9yXcW2+Qs1N6ZNWGMhILrFvAA0WKI+Vzd8kPFmdJ15O
 NHb7V0DsH2ABxRiMb35xT9LvMbqeP3lJxBQYzlvhFQpcYAUdAG0ztE
X-Talos-CUID: 9a23:MzNqhW+hYn+B38i2U2+Vv2sLPtgab3/E8FPJYGWCCWkuVqXFSWbFrQ==
X-Talos-MUID: 9a23:EuFodgjXrdA3OK5Hwne7OsMpNeZ334ifUWc0uogItM+ALhFePSa2pWHi
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.25,245,1779148800"; 
   d="scan'208";a="57406177"
Received: from aer-l-core-01.cisco.com ([144.254.74.202])
  by aer-iport-3.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 26 Aug 2026 20:08:20 +0000
Received: from localhost (unknown [10.189.105.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by aer-l-core-01.cisco.com (Postfix) with ESMTPS id 764D823BEB2;
	Wed, 26 Aug 2026 20:08:20 +0000 (GMT)
Date: Wed, 26 Aug 2026 22:08:19 +0200
Message-ID: <19fceccafbe776dc0a989b00c971edd8@cisco.com>
From: Jerome Tollet <jtollet@cisco.com>
To: William Tu <witu@nvidia.com>
Cc: Dragos Tatulea <dtatulea@nvidia.com>, netdev@vger.kernel.org, saeedm@nvidia.com, tariqt@nvidia.com, mbloch@nvidia.com, leonro@nvidia.com, daniel@iogearbox.net, andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, ast@kernel.org, hawk@kernel.org, john.fastabend@gmail.com, sdf@fomichev.me, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH net v4 2/2] net/mlx5e: Prevent stale XSK buffer release on MPWQE refill retry
In-Reply-To: <20260824141645.23700-3-jtollet@cisco.com>
References: <20260824141645.23700-1-jtollet@cisco.com> <20260824141645.23700-3-jtollet@cisco.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Outbound-Client-TLS: ANONYMOUS;unknown [10.189.105.31];TLSv1.3;TLS_AES_256_GCM_SHA384;256
X-Outbound-SMTP-Client: 10.189.105.31, [10.189.105.31]
X-Outbound-Node: aer-l-core-01.cisco.com
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Adding William Tu to Cc, as suggested by get_maintainer.pl.
Apologies for the omission.

Regards,
Jerome

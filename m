Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793745595;
	b=OMxvzDH1Q7Po0TJDnJtPM1Ro4XAvx1Tcz96IZLgWAauXw0TykM/qMVWnczDFYOW75v50
	 DN6uqq6/XHiGtUtm4w3xQ3x3jswDSyFB2I9gJfFotCKJmPEb7k3h7tJi1qzYyui/hk/px
	 +z1FLPLRdAzcOwNHav59m6FVwPVXAp0Y7ZE+caRZN0J+K3jJXrMQqJglo60Y1uUIj33AR
	 mvbGNqJ6voW5bLRvWrb+CGLMbO0+/NS9UfgJ3WB4l2b9UW9pLWA4OXfG4lS3q3qqshuaO
	 eNZgz91enILbIxaa4J47OIpZafGZ+hjDVxwh02WYCrjGxaHlOU6zAkh0pSAK2tfhpCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793745595;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hkasm7w43b+dUY5l9LtRYckjAHHkeZc9T5ParUJyZ88=;
	b=hNHiIYTgXL2bV7qeuSpqp71Zm3hL3mVYZHlq34ZDvCz/A9sxYDS71lOdyxYq8jk7m14d
	 OP7nbfgsLJT1c96N8EAqUi4MewGXMbKJvmnmmri1Hr5vewuIqd/mlEPb8PdJZZTGuomQg
	 LVCb14mp8TQdcllO8gK8m2jfM+bmAVHj657gbDJlqF6tYFr1zI4nrEhiy14No4drkd2K2
	 iZB6H72UduCUahca3PVM9RD8Ud5NM5LWvkbz/3xOu8EYj3YHujDStQpMNuTWqjnBc6W9B
	 B7N67ezGOB0meCXLRhGIL9LXSFlekf6Gdy/4nbM72UH8QPwKSTk9A0sn97+YmoGh58g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=t9+0qfDC;
	arc=none smtp.remote-ip=209.85.215.181
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13A27606A333
	for <linux-rdma@vger.kernel.org>; Tue,  3 Nov 2026 22:39:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 13A27606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=t9+0qfDC
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-cc4be0e5351so51667a12.0
        for <linux-rdma@vger.kernel.org>; Tue, 03 Nov 2026 14:39:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1793745594; x=1794350394; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hkasm7w43b+dUY5l9LtRYckjAHHkeZc9T5ParUJyZ88=;
        b=t9+0qfDCYwLylSmVAKRemuYBtlBZtSEc+OwR8egCGuHW44FrD9qGXupxIVP2sK5RcK
         gmHttwu2rBCZKtFtMJrm9PyA6fBRymv4FsKNKVc1zw+XE1ZUKC1PcXjm3fKuNeKOoVTr
         t8HiFndykiCtgEK/lMZajxktnukuNLVgoXXVfg4jQFKtczvWw+/pOYmokImYksBc/ITd
         x0k/nEIdiKco/iaIxoJ0jb2mZ8ry7s/ssMr9cql7NhE7XIaIsRq0H5la4a8ii+DwXAcK
         WaytQ+JGfu5tiiZ8chSCPiCUMyp8RHuwuHwEn1Ww7Jrz8LGwFQMtspL29OMRaeuMMglF
         m5Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793745594; x=1794350394;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=hkasm7w43b+dUY5l9LtRYckjAHHkeZc9T5ParUJyZ88=;
        b=sSXQAODfrOL85GT1SIRxD/X24A3Lt/6faxTnL0LJbyMVkTKhHlT1lYON4Q2XjFFqHZ
         bsGaXOKIFjqk5AqN2pLFF+mgHbs/HKQPZ0HfX3OlNowzKWGhcpzCp4uVEcGS5ZhLk+Wh
         NaJIbGsVB1Bvtj2TGjpGkqCEixhE4kzJ0es4A7RgszfUsZfYs2weBigOWoy1NiqamupA
         /WjfTm8xux9gIWwpXuKkcuSLhWl6QWB8NyFQYCdK5TBfdq6s6FJ25zrD6VFwJzCO0hf2
         VoFvqIffK0xc7+XOoNtoSjfFG+qpfwF1vulwWuDvOFaNPj5HbxyYuVg7J1wkPyIm2hT9
         eqmg==
X-Forwarded-Encrypted: i=1; AKwUvBxvvhRQlcZaNwFTY4S2Hzu2M/Jd3JETDpRqPl1XUj/WtgkSIMz+viovYJg5OdPMDMbo/uMf/59cCKV7@vger.kernel.org
X-Gm-Message-State: APuU4Z9rIaFMEl6tj8wr1v72IVtjzSVYvIErXLaD6C105a10mSGbs1Ba
	Z7tYSBAQtqeNmzXleAAx+SxhzxW0hPNZIgMUzqRvu0coPLVoUcQBL1TBnz8DW4nHsX0=
X-Gm-Gg: AYBFou1HSZW9n0bGY7c8EH+Bt2NvT7etN9H4fFP5z8L3nvm22Qm7wXV2bFHTvXnZ5QJ
	EsQrN5rgsLIZOVTRf0nzPS5VBu0WJKTJ6SeWzPferG6Ts/8n7/vEAUFvrfJsiLg+lgFEtCH/diE
	5cnyRudHzjqcGNNbL6/NsY3JVFtwk2EOE7dzDsGPRypra6DtHKMpUYLDMpJtF4A0gksuePGmAzA
	naYUwhmvWZohXFXjtMlXnCC4mRBFVRfaMlE4dPx01VPVzZfhq4OKSOHKsQNLiU/n3/Aiyc7wOgp
	KUt5MHX1g6Nn9WJhO1D6TXGEY+DLNbX5+WC8wxfucMDkocgKh9BcLhoLKnzE67KiUGDRs1FBSSp
	xccCJnOWbLuTJgRUsQ36qgNO8mblz7KT+r+tVTP2NafJRy0tei0rHWkP33mfYFDUXpReCrTFo6b
	AK7veP1YxS1aptj4soU6e4rJEWm4Hy6iO7pL1c+QXiHnZt+NDSSduJXTw9bk6C5FT7wUPybAdKg
	PQykSt1x8Nsxd7BTbSflfjy/W3vP9JyZSZvczthTj+ZME9lrQzYwO388c7NbzzExUJHXyCFVu/d
	i3xl6yhkU8Wtecmu5aFLAFJE7PPxF7u+C1pvlgFAOH1qx/nh2Aptpp1m6PtbeW99s3cH5IfCMDG
	cL+s/fZVEV75zNbMkpthaaiUcplfEYk2ACOtm
X-Received: by 2002:a17:90b:1844:b0:3ac:9c37:9429 with SMTP id 98e67ed59e1d1-3ae89838746mr11403550a91.52.1793745594421;
        Tue, 03 Nov 2026 14:39:54 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:744:cf40:a7b2:e78f])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b0944a0ff7sm886691a91.10.2026.11.03.14.39.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 14:39:53 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: Sagi Grimberg <sagi@grimberg.me>,
	Max Gurtovoy <mgurtovoy@nvidia.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	Mike Christie <michael.christie@oracle.com>,
	linux-rdma@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Subject: Re: [PATCH v5 0/5] IB/isert: fix the device removal use-after-free
Date: Wed,  4 Nov 2026 07:39:45 +0900
Message-ID: <20261103223945.1697775-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261103125955.1530355-1-yhlee@isslab.korea.ac.kr>
References: <20261103125955.1530355-1-yhlee@isslab.korea.ac.kr>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series is superseded by v6:

  https://lore.kernel.org/r/20261103223802.1697607-1-yhlee@isslab.korea.ac.kr

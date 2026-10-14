Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CA98352C34
	for <linux-rdma@vger.kernel.org>; Wed, 14 Oct 2026 06:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791958352; cv=none; b=jug+VKu8Wfjjehl0HRyNq1xviXF5G6hTaewctLZrx4c5dqrpvyxIu2ftq68m+dvZMoMoR19fiu4r7Gv/4vqF1gimw18sabmDIad7SBVr3Xd+0WANvgzKvXgiPkBauQ3YZ2yrOAon3AKXRUnMWCAHpkOcru7rH39LwfGG1sEhJ7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791958352; c=relaxed/simple;
	bh=ZZ8YhT4vttbyAReWLwDYCcZjAsPCyQJ43qms/rc9dOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jx96kazU7W3kOYTWXYsN/6QmIqBBWGyaPu3hYDIw22VTrhtth3TrFjGdlukOLRjBTPRiqRZ3muzXF7MSsutSMrlBHm/xJcfasSlDtG4HkvOjeheapa2emKGBR+IrJRKV4X+tQKpAddnmrkULQYpfzNicocmCfx+Z9tXooQxCPjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iIoTe7H6; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iIoTe7H6"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-3ab450c0873so3113875a91.3
        for <linux-rdma@vger.kernel.org>; Tue, 13 Oct 2026 23:12:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791958351; x=1792563151; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ZZ8YhT4vttbyAReWLwDYCcZjAsPCyQJ43qms/rc9dOc=;
        b=iIoTe7H6VgKDcV2LZdG9OjmajV6SAJRxiL7dJG5U5TxMocbvVjrhJR5fn9JMHUTB0H
         8namQtdnWK/sIHrfpaSJHw9nCHeAucd6RHYBXcVuxh2Mg87OXAEMcFPIdjPcjF+CA2+2
         xbMO9K33WqQz+2skTzrlpNIL4MYIvZnzM8Q4I3qM7bzU5OTiU+c8+OEzJUr9BcknOxS0
         lodKTX+mBpDan2FoS3LWR9xMqxKxwtd3i+zkhYFrqDf1NkIeTYkILD3pxxZJzUtGRgiV
         G2JF3zFnjl46mhxJeVJtxVoY4n2Ud6z/1GgiR/l5ecL2t+1siAlwEGJ/imvRfvU49lwT
         EVHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791958351; x=1792563151;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZZ8YhT4vttbyAReWLwDYCcZjAsPCyQJ43qms/rc9dOc=;
        b=rNKpA5LGr8F5ATiqEgWpmH0wEY4l6BqbZBAJzzfP7a6Lm7i1qh6VlIsTSEx985FxsV
         LuKf7+6WWslqnBhnKRlW988LEPXXQGtFn8/hOoQKngWgXzZ7f6Pq9WTTi4eALeyUau7p
         IriTgYVOqx9FbfZRRUwyR9RyJwt8CNtJ6zCWk5Vu83HeS+JOM5wD7gznAknK0Ee5Kwih
         HapM0wW8HZ36L7mA2aYdvi1/qgLc+N1q7+UvosuqLCOdxoaVT9ATgdKdXLYIPvJ4NFeu
         sdI4+sdxxQH1Y/jXW5eGdfkZwWMJoP2DNHI/EEewiOfSUdbPiKlLQw19hNHkIQd9CIGl
         d8PQ==
X-Forwarded-Encrypted: i=1; AKwUvByzBeT2bhax3D44cTLhxdyrWa7kSIlA+e5ForSbI0rnDlwiDg/qcqzuY/lGY8mEt548ARcWTD5nposN@vger.kernel.org
X-Gm-Message-State: AFq9FYKHXosKWRu2LpyTZYEpoPpl6qe9oMBtWv/BNPx1YK6Pz+YOvg1R
	1bte1fUWhldjnT56R5zCVwhZyKkIAzvAc4Hs/ieRuEOhpv0oJ0yOAkWD
X-Gm-Gg: AYBFou01F18cj8UsgYW3S5L77PFDSlkBPf+UPjGGzpE8/MXLXPsFdg6KO7wa3NvTiRE
	07YqyCaFlFMK/Zkni9cSplwSXLIDSiUZV6IoiJ5oMf0yTNavcBLlBtI3dyQxQLczefeTof6L0RU
	JIZ6IsW9mu889R2aET/AfGY43OJly+S1pbLUhs10H+JA0LChyo2LXlgNWaUP9Kl9zq59v0xMNlO
	rzeXBx/iRlciA+lTTFwqGGDC221lNltmYRAmDwlXUlrEGJ5ZI0jlSvjvwwmdfeoTX/Dw7ebHpo8
	9VLrwYGw7fkjN+qSDRyLGxD+THY87IllwZwYe2EcSym4Bfv34Bf+PMELim3mYRlw6dBY85BXjtd
	2v7AEPHj/CsdTXphUEGNhouB5o3YBOUHwhgbVNmARY5LwrFJw90hcfo+P5UGNXVXNOAMG29Slbg
	B63xT1n+cI68G3OUP/T8G585CdehzxBkk7uHTUhd5kqIN6e3ZWEYlj7m+Dg2Z0xMMMLPwTpAbL4
	UC2FCoQZtNzgDqo6MkUQar73DvdR2S+HTWVUYbN7oM=
X-Received: by 2002:a17:90b:1e41:b0:3a8:9b79:e6ea with SMTP id 98e67ed59e1d1-3ab3a96ffd7mr13125588a91.59.1791958350750;
        Tue, 13 Oct 2026 23:12:30 -0700 (PDT)
Received: from DESKTOP-0UATUKF.mioffice.cn ([43.224.245.249])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac5f04e324sm3094613a91.2.2026.10.13.23.12.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 23:12:30 -0700 (PDT)
From: Dongliang Qin <cccccccccccc777777@gmail.com>
To: Zhu Yanjun <zyjzyj2000@gmail.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>
Cc: Dongliang Qin <cccccccccccc777777@gmail.com>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Bob Pearson <rpearsonhpe@gmail.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH v2 0/4] RDMA/rxe: Fix MW/MR lifetime races
Date: Wed, 14 Oct 2026 14:12:23 +0800
Message-ID: <20261014061223.1547823-1-cccccccccccc777777@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260928171756.3254016-1-cccccccccccc777777@gmail.com>
References: <20260928171756.3254016-1-cccccccccccc777777@gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Any comments on this patch ?

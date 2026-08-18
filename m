Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3602837C931
	for <linux-rdma@vger.kernel.org>; Tue, 18 Aug 2026 03:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787025403; cv=none; b=IJHBVby0PSkGXepl/yb7cOglZdYCpJ10nsLzMDYd1c42sKxxrdv0QecpZ06cBXShqXuhQp3YcANVJ956nM8Ds2O/LP4XtIm5JvTXoHs9tC3ic7lbj4lc0Mx+0zEDv7X5HBcDjD0CCDQvKklGISLix3PseeCu4ZquI7+k5m0leRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787025403; c=relaxed/simple;
	bh=wx+zANiY53xunKOlqeIwCyVOUxzJ3Wx5qJTgL+9HC7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=duCt9nYIx0yHgg5j2SN1iSIUUueQclhrdP2v8xIgNaHMt4P/0pP2tnIfVH7FXPku3cNX98/726J56l5tMXI6tapgeRP4gAadQmGf6CCDPIh+ahcLoP65UWbotDD1IDdpIadJHCQhdZ3pLQPVrN4Lbj/HwyHh5u4uabQFRvJ3dLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=IYORBAur; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="IYORBAur"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2ceb096e675so47085135ad.0
        for <linux-rdma@vger.kernel.org>; Mon, 17 Aug 2026 20:56:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1787025401; x=1787630201; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RNTwEZXIlkR73mzXPL4Ql6OEd7dNBT6DYu93FDv4mqw=;
        b=IYORBAurcbedsGB+LC/A7FQvuwA9/XMDv7zFnww9nz8uokkfIoyJ+tkq7R8JjBc9qe
         BsgMPmo6HVZwSN5kyhv9eY7I0hQOJwkN81MrJEVTELB1/dF7009RWPYbzMSrxEqhPHD1
         MpOfynusZ2nkSRi3nwON8WySvt0BqdM/IjQ/ISDq9760qa2/acbSzOPUyNQuYvBtD83j
         M5cZPIYpcDfye+PoW4sVfdHV/7Hf+YjGaYk2UTe5F+NHYejyLV3ygpF909DK3LlzVyFw
         OD2RqoMcdws45Zqnz03aEsiv4KP9eKQ3bd+zC5JBP3UmV8/5A6HUyQhxGQQUfyFiNrvp
         65Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787025401; x=1787630201;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=RNTwEZXIlkR73mzXPL4Ql6OEd7dNBT6DYu93FDv4mqw=;
        b=ERuc0OduRUSIq98UVnuaOUmMR3Ij7uXIyJgw8dB3iElZvIzBb6AZ56g96l2siHhPfm
         b8J/x1IszbvAOi9Ck9C9tqXz2w+B4X5zWjd8cdIx7BhaPgU8PDd7rxKkCNrbMpC9CJAB
         396gWNVLY3lNvGlT0UxgsJbm96slTIJRp5k6n8JB+E3U3Bvk3up9mt+2EbLRlTrJQDm8
         /7ypePg6AIKoYfEt+zka7/drkVDCNRrxW/mrKBTJg2RvrU6dY3hxlsE/Tco5+qfZKHY0
         vOALykkjrNHOW+I4PInmC+gnQtHDWMtuPQOfKxuHAmOPk4O4XQOY6vVa1Qlvq+V1989/
         AwrQ==
X-Forwarded-Encrypted: i=1; AHgh+Ro2EyjF88B4BSoykvDQwwCsIdmKon6K65fd1pLzw1KNBl3zemDFQlNksJibtUgZKD2cOGENAKUxCcOF@vger.kernel.org
X-Gm-Message-State: AOJu0Yzp7bDVuroDNJuk56LPJXUo4Msnu3ENuNDgIxsGShflWEUlHPkN
	3vNNnRnye3DPvegDGGXrSJxbMFK0xaYQgu4Bbf6nDcuWqeh7YDYwo9UBRXd7sKuT4Es=
X-Gm-Gg: AR+sD12fzKnF5yNqRRK6iHJKAqCWpcAVa7JRMfHdqFc/jHGm/7SrwBZVjqsZA2gEbM/
	dfkiaWOvH0SAsJpSW8Znr4EGuVNUGaQzX0m+PzOalC8TAiiW7DgkZzRPzu57BeCGuc7hFlYo8MD
	s5CJsyUxsPQ8BQdkK6VNLuQOd7tigQm1W21SyEQ/y2Z1thCfcJMBZ45LxD5QpZVY8p91T+H0E1y
	0OFmE/v+YRQHAdfZ1/bJKd4BhDzGCJ5pH5bhIoeSaxorYOiIlEPOh01YChSHDpL5D3N9BXwuRrQ
	ZCkR326kUQQ+vtsZIHoLX4A5J9mpkVW2w+vZc1LbGK+ib9oWry7i5mKfzqiM8yjtxKKTVrw3Kps
	myhEum5HSoMCIwQNvX3oEJlMl4KLdOhYDYZvQItcWs6aLKb5O7M4Z1oJYUcmGgLDfvXX/eL3qzC
	+Kv9lMJhfeQZdWWhyMUkaTPRtUwbdG/gxjp8EVjz6+dFKWOcmyUlAL9nB0qNDd+yaTA591Xw==
X-Received: by 2002:a17:902:fd8f:b0:2cc:d6de:d597 with SMTP id d9443c01a7336-2d3b086d3f8mr332750115ad.7.1787025401454;
        Mon, 17 Aug 2026 20:56:41 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d5bb499e81sm12141085ad.1.2026.08.17.20.56.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 20:56:41 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: bvanassche@acm.org
Cc: Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	linux-rdma@vger.kernel.org,
	jgg@ziepe.ca,
	leon@kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RDMA/srp: fix use-after-free of a request in srp_destroy_qp()
Date: Tue, 18 Aug 2026 12:56:29 +0900
Message-ID: <20260818035629.505302-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <4462dcb4-acae-4f70-bc65-a9557ce20181@acm.org>
References: <4462dcb4-acae-4f70-bc65-a9557ce20181@acm.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On 8/15/26 2:30 AM, Bart Van Assche wrote:
> Can this crash also be fixed by modifying srp_remove_target() as shown
> below?

It can - 5 of 5 runs without it, 0 of 5 with it.  I sent a v2 series that
carries your patch as 2/2 next to mine:

https://lore.kernel.org/linux-rdma/20260818035229.505098-1-yhlee@isslab.korea.ac.kr/

Best regards,

Yehyeong Lee

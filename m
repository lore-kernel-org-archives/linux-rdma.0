Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A00C0441029
	for <linux-rdma@vger.kernel.org>; Tue, 31 Mar 2026 18:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774980338; cv=none; b=VS9R3O7hSqLmZC8G06VLPr1tzqoqKHarhMr9LEq2x0AW7EcH8LOGSLZRQc5zBZPCsXbAJIEoFDF/GgfPTHQLK1fiWjKa5xr25N0zADYhfRt35/G6arwcUAT0roJgJ266q2FuE0lhiW7rqRJedaTmgubeHaeRyqJVNwaY8qeJx58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774980338; c=relaxed/simple;
	bh=WCKaWsZnuOH3ILXwiQ59qJOVOeDEUiGlBDXxWQbq38Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eIBzU910nVsVtxanpZ38orWsPOcvFZfb2aQWJcUeE6Zs6lmvQ0JMGIDkurOW8RwPhU2CkedbGu+dn1a6gDS3z5yWGr7EUiytroDiGT2x2lLcDCrQ1rArpU3OChrNXinIOXZYATKHo8xLM6Ttd/6tZHhFAZ/iLSLpQ9JUWd2zLAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NpvwoTg/; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NpvwoTg/"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-483487335c2so64573835e9.2
        for <linux-rdma@vger.kernel.org>; Tue, 31 Mar 2026 11:05:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774980334; x=1775585134; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WCKaWsZnuOH3ILXwiQ59qJOVOeDEUiGlBDXxWQbq38Q=;
        b=NpvwoTg/26KxeMfyiq9FqYNsPy+gS9R1CmARvP3f1wEwDPvmtu1uXEicQcwTNTRYv9
         GKly7/1/5ybMiSktVA37ZTJc4JTSy+4/Exf/3T7KSZiALrF9zCfejbWzssMAwNRBGU2n
         vyY/wxAL0uboiLag4HleZMJhGVxEsCOSa3CXnfy3QJ92dsE8xkXmkXAwdccZBR/EKP6H
         NGt/l198XDRBBADJSeia4Lx+kYfJIiitNPvQEAsbXK84qXKAJW4bOUjzPMRHfeachseY
         3DcfSMvQLnigRqxl3jHFAg9ij0LxTp94J+MsBswKrHUZD5eO6GYIuoz0lXWyjN3WZB1g
         05Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774980334; x=1775585134;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WCKaWsZnuOH3ILXwiQ59qJOVOeDEUiGlBDXxWQbq38Q=;
        b=HAOVzDuMUrycXKqShrbPCcvrTj9XDCT4Qihtk5+JBoZ05kDrjfPUWnLwIePmmTrrPR
         XV9jRZTWR3d3VxOYlbm/EacsBypowOPcbOVipFLQuMFsi5V6csAl2xAWyjfpEohOtrMR
         xfI6c/lsKNXeYePxinzdlt/0Dmj+to2HJlriwI3cwnAtMM2ZWz3wLCCuh9tGxsZyJGL+
         dnwUzmcToqQ+2/y9gDv2TxZJ+LoJkTdsKTiifkuYqnWvmv+oFz+/4vs2Aymmb93iiw/R
         jIePk9xTHjSsSWffNGE3ZBHtqbzAXtw+UmlD73SJh04Zc4QV0ic7cOue3va3c2RKLXwp
         p41g==
X-Forwarded-Encrypted: i=1; AJvYcCUbVC27xpf42tcd6dVw9BPKHsSgljKQ+5yKpPmzArgZcc059YUA6yrq7zjFmege8bzdNDcyQwWaMbJ3@vger.kernel.org
X-Gm-Message-State: AOJu0YyWflXFc4AiuY4L5kwM4lrze/qf5HzNniLugFfkHX9Cv+foemhh
	E4IdXtf1LinQ4dfLeiQw9Z8GFNvNHFMtPWNtgm/CWvHuZ0QN2y5gSOHfTK5hJSKc
X-Gm-Gg: ATEYQzzJebw2X6Dxu4P717M6+0SYHkYmnfk+JGFe3zhN17+GEHH/+mIGekGnpr4is06
	xYFdEiGpteRR/VYjAgiFuMv4qRD+6nE4nXNzcXjQF4WfsgJqjwr2WzYamkOpN3ICFHwpyYZM1+P
	/CBe5p04RXExE58HtNNz2mq5Oq5pQUbkc9SERNhkUhanSYKJldrwO+0xYZLyOwTkRHbn3q5u6my
	1gzK+yJ4UwouPACilDuPlCcVGcg/rVWCRFYZAKnNC8yH+Quy34Lg0BVp3+E10rDjqkC5t1bgFGR
	2la+5wCTKrHQvWrt80CvVkZ22uC82DcKLi6KV2/9kzdi/2ptD1tlpJSpT3xMl0ZBX0THT6x2osX
	TgX28jOWdiuDoh3Gm3EL3rG/jDaIOLWz/9Ip2e+RFeeb1SiTxTcuDW1eWCBRBRDjttdTShKaZUD
	dp/k+GgvhzgO7BLElAlDuegmWQsnjZP4UxKnF5zI09sRdEW31z0FWFkF1SmTub5uB1R7jwZZ6Q0
	sLOWaT6MS8TF7a+glopst2mqT98ZlEMQrbjtenpLH5YHLTGIxS6M1Kv7Zc=
X-Received: by 2002:a05:600c:4e88:b0:485:3f72:323f with SMTP id 5b1f17b1804b1-4888358809emr5951695e9.11.1774980333592;
        Tue, 31 Mar 2026 11:05:33 -0700 (PDT)
Received: from DESKTOP-NQ2T5I7.localdomain (heme-13-b2-v4wan-167795-cust403.vm32.cable.virginm.net. [81.108.45.148])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48880946cc5sm34109715e9.13.2026.03.31.11.05.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2026 11:05:32 -0700 (PDT)
From: Prathamesh Deshpande <prathameshdeshpande7@gmail.com>
To: leon@kernel.org
Cc: dledford@redhat.com,
	haggaie@mellanox.com,
	jgg@ziepe.ca,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	prathameshdeshpande7@gmail.com
Subject: Re: [PATCH] IB/mlx5: Fix memory leak in GSI QP destroy error path
Date: Tue, 31 Mar 2026 19:04:02 +0100
Message-ID: <20260331180531.16845-1-prathameshdeshpande7@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260331134508.GD814676@unreal>
References: <20260331134508.GD814676@unreal>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, Mar 31, 2026 at 04:45:08PM +0300, Leon Romanovsky wrote:
> GSI QP are different from other "best-effort" failures. It MUST to fail.
> We are intentionally leaking resources here.

Hi Leon,

Thank you for the explanation.

I understand now that for GSI QPs, the hardware constraints make a
memory leak preferable to the risk of an inconsistency in this
failure path.

I'll keep this in mind for future mlx5 cleanup patches.

Thanks,
Prathamesh

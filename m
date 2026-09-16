Received: from mail-oa2-f12.google.com (mail-oa2-f12.google.com [74.125.231.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F9274C9E07
	for <linux-rdma@vger.kernel.org>; Wed, 16 Sep 2026 18:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.231.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789583562; cv=pass; b=RKi6gGnqhN4d7OBa8VMLelb66nSLUNcct6dCAuENSfbzz5zQkygLmiWXklMpcryqN1/Owl3R8W4o6Il9a4MGCOFdA0193rGdl387l+kXQFWWSchZQ6aKnu7uf651j0lvUMlhRHbK17Q7tR42S8z3dMUW1YOJuYeUB6aRI8qqZes=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789583562; c=relaxed/simple;
	bh=bEYZXb/7L/YtOWAVT4ctcRizZUVUDEWDX8/RG8wgZzc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QScbXLsEX/S5u9lajb2OV1NYxrnh2pFcB7ZLWXN6LI97RO+/Vn3AmAVmEbhph5LhuggCEbmQmEpJBX3E3G50pMkDR1YA5WX3Cr+HYKlK1t1kVF/CPygS/JflrfEaeI0m48EVuZ9xZUWKcyqijXtg+XDg3q57JE95eO94iuG9UY8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kP27ggtT; arc=pass smtp.client-ip=74.125.231.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kP27ggtT"
Received: by mail-oa2-f12.google.com with SMTP id 586e51a60fabf-466cc9ab667so1667094fac.0
        for <linux-rdma@vger.kernel.org>; Wed, 16 Sep 2026 11:32:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789583541; cv=none;
        d=google.com; s=arc-20260327;
        b=NhkXC/tV6AdgS9y21kxl5vWDQ8zJKlBEtKmTYW2Rk+wY/VhgzUQ4Eul2nqqQJOHNUj
         Vhw1S4Vh48qUrpb9ubSDKRbPv8YghaKGS5TgBjZCYMpy/vW3yEj7WYYnu0YNoWO+YI4k
         8mKX2RlGBBSJjytIqePjwgKnIDPiuNh1KxRpZ7k8Q6+79aPe/lf4UH6IaD2ZyCBip4gj
         RT9j6XzOtwWXrtxufyTMZZ0ga/jgzi6DQGZ5gat8xjkyWEyHR5928J8YMZkPg/P29uC8
         jWfFj27Ov3g6O2WHSfxZwQQ9ORrK3Aiv2Dql9GzZIqZAvxrT6KYe2lRO7xgdIhrXTxkB
         WSmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=bEYZXb/7L/YtOWAVT4ctcRizZUVUDEWDX8/RG8wgZzc=;
        fh=ugPK49R/QArtakbvE4JXKLTZlT+nehbGAsL58GWGR3k=;
        b=Tn3OkQ3NDdPRXMGdxRhmDU1zi+PAyxaUMqU+LJraODANJwx3lzEoffCiA9wB1RpwhV
         itSPIDmFtVdUxsZAaRoISy8faZ1Hty7nwPBp54ZW1yJfrsNuMmTwbK4q+WuOeEq3H96j
         AqMFOux6x/5MQMn1HJO8eLFMU8U70FN7QQ+57jnzqVBh5UqfySFCijubQI/Ohere/MSK
         UVfWSI3JWA0FLbfktqsMMqn+IW+U+QNVjTsGCLHVD9YoT4xYDZtzxkCaNV/Yl46TO2h6
         DXMS55zQKpgywzcAA8UU0EGe/fCeZ1wONFb1y/17yoxPFUI60CQGGommPmYXg1lsNHXU
         rdIw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789583541; x=1790188341; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bEYZXb/7L/YtOWAVT4ctcRizZUVUDEWDX8/RG8wgZzc=;
        b=kP27ggtT+Jo8YlZungVX9dA+3qp2/gGI6i6qN+6MGlYW2rOSWmWt0QBNx8Cb76Vbig
         6OtK8D6yPihXcMBI14tO7CJcN0fcLQ1bqNy6BA6HCPFGEcOWxivJayb+A2E8Uqr3yUJS
         1n71VxFLiWh0mPahzoN5/0D+aC9z+7RRPrxGZGOKdVcR4qnk+hvAPEk842Jah2UZQ2yN
         eZm1qjFuMPgaggDvqXKLigIYQ109GxG2CEeY0TxSXEfOdPlR3C3ZTuDj+wavnS9Yf16x
         c+ouK0CGbHLdhnoH7YVikpybQRUszEuGZKiGb+gKqie+qCtk8xIl3pAd1yxtmiuWHlyP
         oCtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789583541; x=1790188341;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=bEYZXb/7L/YtOWAVT4ctcRizZUVUDEWDX8/RG8wgZzc=;
        b=z/g5T6j3NUTw+ygHjEA2g566BnTVvrog0dF8QvYI0vjuiTAPE9VE26NeOEJongKv1n
         U0lgNzVmWLhsQckhIiS5zWwTqGX6e7eh9YG+KvcBVY3/wwvbTklsslwKFHrV1CG8oXRt
         l7eIvlkI22u+0EVbdG3Di/AxhES72ArD/Xmfq5DZLzEHDVpLUnjtubkPmgHHAl7BK0Dm
         q4he5ro/PNwjcQ0KpZjzPKYrTRlTp1vlAKIAlESJy89SD5wjmAl7yekbazRbDAwc3s9+
         6dKlGHrHOdEpkuIJG5Y4GyP6jCU2GmXCG/8SwiQhWmDSS5lnBk+jiSMpWQ/6EAHigrEy
         B1jw==
X-Forwarded-Encrypted: i=1; AKwUvBzQcPgQWGOM7M832zlSpRM8t+LIujwj2xB9hy5zsTEYGqezgbmpHNy4gSukV5KegkDy25kbQfugmSt5@vger.kernel.org
X-Gm-Message-State: AFuF++nOUKzrwSth6d3A3r8hh/sDGWYzEIk/kBbQON/591wEYBptBPqM
	hsNnVPR4L22qixWGpyiIFM8ta3avmk/X7J6J+7l3iWWcAyAW2R5HTNPXUCcbtWnQdL++9HOUIQr
	BB7l/wjokp7iTMtIIoKWFOMWq2RXGrBwudKxtcG2Y
X-Gm-Gg: AYBFou0bw1I0vZviGwiO9ICs002q59ejS3PYlFqQ5mMsXbWkzKlidu0xUiwAEi+kjSb
	tW0Do5uP6VfmwtyDaagFZ8vm39x9dNESvo17NbG4j2+lq8CyoSBReRRSZbfzIBcASQiFNCE2XPT
	cvqQXRH2pHqACBW8WH11Ass3E9lmyY1vrkqoR5SYl3A3ntRqCTt94GDGKuKm2s+VNmxuNSIus+s
	ZBGPTkKxK/B5Z8HxhVyPzaTaL7nxpUFoiEJ4H212LykHen6L1933NbDrTe/uZDmFpnW4Rz4jcKE
	roZnz/3ZiclSY0RGGXrSsMNPQDlD2QB3qv5OcGR12BzQRajY+PirhJJBpaA+YDh3zPJJZ8YAlrR
	qR4+nM4aeG/7pdsFr7jBUBWCb
X-Received: by 2002:a05:6870:9490:b0:434:5c90:9d87 with SMTP id
 586e51a60fabf-48475d862ffmr3569677fac.12.1789583539634; Wed, 16 Sep 2026
 11:32:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260916173203.2555458-1-jbongio@google.com> <20260916174213.832221F000FF@smtp.kernel.org>
In-Reply-To: <20260916174213.832221F000FF@smtp.kernel.org>
From: Jacob Moroni <jmoroni@google.com>
Date: Wed, 16 Sep 2026 14:32:07 -0400
X-Gm-Features: AcwNN1XIDTmzw8R_5GectK79olTXaZFOwnus1SogcYy3Or_QoWrpI-xe7GX8NIk
Message-ID: <CAHYDg1Qk16RM=nbiHSV7AS065CL_H4_WtBmbBHewD+1jM+AAFg@mail.gmail.com>
Subject: Re: [PATCH] RDMA/irdma: Use kvzalloc for lvl2 leafmem allocation
To: sashiko-reviews@lists.linux.dev
Cc: Jeremy Bongio <jbongio@google.com>, linux-rdma@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Tested-by: Jacob Moroni <jmoroni@google.com>

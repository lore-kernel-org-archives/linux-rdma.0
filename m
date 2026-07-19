Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0989E3A5421
	for <linux-rdma@vger.kernel.org>; Sun, 19 Jul 2026 15:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784476123; cv=none; b=N0waX8yFoXjBeqd/ic5T46/DTrrAVYRRFMgKL97DFfuSDLkaluIQ+IrlUl7/InO9I8CX6beLr3APqPb2rXPAqrJO4cucjvPszv0sT7W3GkC6lY0i514AqgXd8jMFVGtSnJZzm1DVDrlrmxuiH8LPpPB2fB1B2I4PbUF0p8QWpkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784476123; c=relaxed/simple;
	bh=NtjG5Nw5m1997/9B7PcQY1C38KxBppjF+qQjGWhTijQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MTfDCy2B7iyKgZmQ+jCTSUjUzzZD5m8vyyJ6QA686J6hmhq75zpx80rCK0foMuVfFxHPNmqJe2dE2p1dNIvWlN1lLdPWm0ActmC7TO4NXfF4u97DbSZEausaVToxzTFuNj4+pDkrRjqig3FsULNl3oNF7jJE/lqLHUdYha60Tms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DlmIeHJX; arc=none smtp.client-ip=209.85.128.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DlmIeHJX"
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-81e6f0b4610so98308067b3.2
        for <linux-rdma@vger.kernel.org>; Sun, 19 Jul 2026 08:48:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784476121; x=1785080921; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NtjG5Nw5m1997/9B7PcQY1C38KxBppjF+qQjGWhTijQ=;
        b=DlmIeHJXO5MbY9WTp7nHuYgbjeU+2obxG5OgAIQo6C6iweCqrOzfEgrnLBr2WHFO+y
         nBDxoOv4jMERB3yI1klFRK6kpOxH35I5iKAps69LnrjZJ6/A8ERNmtHYDPIROrRo79qg
         iZTrKmZvTTFMcDur7DxK7AWJjveC0SJYViKCei+zA+r99v4NwjQMQM/zwz3Nbug77zIr
         6+csbv8GCv7WvXAr6KSfhajxY1P+lfV27ldVGrR83V9pfFEuTZFe90R45tlnW+247HOX
         O5XLCpsHx0+b9H/qiYHel42KLsPBhh6ogQwTEJWy5G4ypj7jGyjuSB+bFEEmDx1+HGj6
         XqPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784476121; x=1785080921;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NtjG5Nw5m1997/9B7PcQY1C38KxBppjF+qQjGWhTijQ=;
        b=kgYgW03gN6fWfr3uNGXA7iN9MZUJO6gA8oWx96/aMai0yPcrID1s6kNaQ4mqC0Qszv
         EATStS+bdXmhRXWh3Z5n259BFoh2fmvgG8NwvhqjeBrEt9YlL7hVNs8gs+VjdIbedlsU
         qMNv5Py5LdAOPIyo1BCEZRbvcabgCcL3bLuXlmIU9KF/GvevkkI5VQGNThXCpVVncHNu
         vvuNl5Q+VOBDAkOfB8JMUr8YCWNE4ttrXZnDrVVGkSqvmelppgRYx2ypL3F2YBcNrxoL
         iOSbrwoV7Htuf1CbEDm+OV7vQ4OxEbAXHem8UnmdvxrrDPnNCtvJs8U1xurVqB90JUvg
         GR2Q==
X-Forwarded-Encrypted: i=1; AHgh+Rpr/AJ0Qj6hSezDoQBg+QTu02G97+sZsApc/iRshgRPrGpSirDeEKlO7FXqOfmRRtgjM2MUBTJK7ksH@vger.kernel.org
X-Gm-Message-State: AOJu0YzI6l2ggQDqyBtelNKkFBMIaChXFemnP4+P/5WK80IXy38qM1pw
	5v74/o4jqs5pqYmW4nwfQ9YQjX6QgThXRus3Y+m9M2rnsy9upKFSbSMCrKe0FHYosQ8=
X-Gm-Gg: AfdE7cn4OQDrYowelZ9GSe6LdDvCjppNnDgtjyBxpX5nr7Q4+AsnI5boBVb60ehdLdC
	UYQsRMg9XPpNo7YRYynHcdJcgZWaXGR0wUe2Q79PrFrFz04bwwtaNciseBjhahECqsUn/z/QcrS
	E46CgHgNQqecZnLbS3Sw9ZSryBG1QOJFUjQHX5jyrpFXIYxW85/2Gf1jlmm3mpEFUu0XLCTtKde
	lGSCVkIAPATef7C8G4SMrwf3CnSA157OMCV6mNpQrWNSh3Fucw0KaoABE/k9PaGwkD8ZOlhquGf
	QeOnoq65JcCVMB0lK57mXBNShI0ZbKGdjTQOp7lqN9Cs/BtkhoSI/hSZNWW1VjvrTg7Ka+7h3lS
	TRYjP4ueLRsEpSL1/jtjmbuQrGlDnu0AFOLdCD7BFJcxIkuBD/h/qc1LVOmAECGOYCOwf5cCI65
	0Ccmtsg48iHvAVQMmdYmjjcdclcmBpbkmRo3MDr5oQ+hUUn++hHo6jFsliMqU+AKSu0b/GV3IHq
	FTnqiIIXBjRhw==
X-Received: by 2002:a05:690e:4813:b0:668:434d:79f8 with SMTP id 956f58d0204a3-668434d837amr1539118d50.109.1784476121006;
        Sun, 19 Jul 2026 08:48:41 -0700 (PDT)
Received: from LAPTOP-83ECOPAB.f7a5e5c3-cab1-4810-bdbb-207cdd06de9e.globalsecureaccess.local ([136.55.173.105])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-6683b80eb49sm4769861d50.11.2026.07.19.08.48.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jul 2026 08:48:40 -0700 (PDT)
From: "Cen Zhang (Microsoft)" <blbllhy@gmail.com>
To: achender@kernel.org
Cc: AutonomousCodeSecurity@microsoft.com,
	blbllhy@gmail.com,
	davem@davemloft.net,
	edumazet@google.com,
	horms@kernel.org,
	kuba@kernel.org,
	kys@microsoft.com,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	netdev@vger.kernel.org,
	pabeni@redhat.com,
	rds-devel@oss.oracle.com,
	tgopinath@linux.microsoft.com
Subject: Re: [PATCH net] rds: tcp: unregister sysctl before tearing down listen socket
Date: Sun, 19 Jul 2026 11:48:40 -0400
Message-ID: <20260719154840.6830-1-blbllhy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <259284aa1280d387c413cc34fa5e4b11ad28379d.camel@kernel.org>
References: <259284aa1280d387c413cc34fa5e4b11ad28379d.camel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Thanks. The KASAN stack was observed on x86_64 QEMU/KASAN.

The full KASAN report and C reproducer are a few hundred lines. Would you
prefer that I include them after the --- line in v2, or reply to this
thread with them separately and keep v2 concise?

I'll prepare v2 after confirming the preferred format.

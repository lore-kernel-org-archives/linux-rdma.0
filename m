Received: from mail-wm2-f9.google.com (mail-wm2-f9.google.com [74.125.225.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A82C939F184
	for <linux-rdma@vger.kernel.org>; Fri, 14 Aug 2026 09:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.137
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786701267; cv=none; b=sTX8DYEzyXHR4bUatKYVUVvLUC7pGn6n3Dr5BDaZDqmqFKfAiktFBTfhDeh1CY2lxLxy5C3xq/RBIcD+7y7e7aLecXGMKTlZTMSrLFjWDit/P0OMmM9FnIGZtEHQZBjVzbTwqjw9leQllZejlvegxvJ04lJeET4P0o5YSQFUdlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786701267; c=relaxed/simple;
	bh=hyDs/8XOTKeJX4iNOsTkCEDXnVVk61OPr7WjBkqE038=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kVezptJ2rpRDYI3Yhs5SqpWzVHql4lB9YEI7zI6uc/ljNIwlSkb1LhqznHTiJY8GSXI8oSctDFjS34csUuS2PXPbpKnvvyrgZ78KuGrcF20PInGf71XWmwmDlI8vUlmnF/KpuKCrpFwNJmwWgQ8HcTlm6vu4FBFSKDDzKCLu7hA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ss2+PXSb; arc=none smtp.client-ip=74.125.225.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ss2+PXSb"
Received: by mail-wm2-f9.google.com with SMTP id 5b1f17b1804b1-49550ec5b41so916395e9.1
        for <linux-rdma@vger.kernel.org>; Fri, 14 Aug 2026 02:54:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786701261; x=1787306061; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JVsUN0kKLPGyxypNEAmw1vf0QkzraHJoaA0MSgFP0hw=;
        b=ss2+PXSbTT46c1qJATPsZE7bGVmR91Tdt7DnUihlrhchc3Gony9/O0cdLlBn8S6loZ
         EqcRTFmddnkX2/G+AEsMT2i42/Y3fPSAlBI+QH2hli51PSVxGdbY6zhFCktX4o4r0Vl1
         c1It+UU0uIUGnaP+hm5uP/Swtw67NZECSmkl0XY8IovSm1On/y1xipH5+ZxAzly+VpRX
         AdnxZOr+VRqyCAGxE88dVe+4pA9dB8wpjoevuKnIJuE4Y4NvXy+XQ2P8gtf7SGqsB4xa
         m3E397geMFYETfl4MuxSYeQqNnGFdF9XaxxnvfREYfpPgcuJuqrdI0CFKXu03hcBL4XF
         T73Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786701261; x=1787306061;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=JVsUN0kKLPGyxypNEAmw1vf0QkzraHJoaA0MSgFP0hw=;
        b=HbV48OrdVvaa5XQoh/HibrXzO72llVeHYBjNbQXTnvve/BWLiSJMJmZGFEb4wgcEjo
         ZoA6mOAGssLD0TBfm3WSwJW1KslHxZoPaqysgpNKED5KsB5LWiqJ3FdAL+9/WkO+3alB
         L9r8b6VVV/3yFnGoWtMs76LMER6gOZk+NPmQn6t8B6crXm7rcmRHCPRQGq0favCWLHns
         S2Q0c+PG8C6WSjOQjDHUu4XAe/9TCE9i9ztZqfTbFXLHeR8ZkkLOgGyVwBbbG4J5q/3Y
         YulXX/SIZAevFU20PumTfGytBO1Y//0/m0HLRZ7HVPB68F57Utl2m6+N1FvxGNS8Mycl
         9O5Q==
X-Forwarded-Encrypted: i=1; AHgh+RqiF1/GJUoPMjej7uaiZ9aqIEX48x+dP9Ik9Vxu90wT0lcHSsG+HnegzoC63iWk+frukOQ0AzBR2AFL@vger.kernel.org
X-Gm-Message-State: AOJu0Yw2wHLRncXwP3swrB9RyoNQHFuPaICyupjcKAafzz7Qec62OHbt
	2xdgxmnQ1AfPZADEOH4JETjiNfwvoGZH71BC/NtuuAfDdSjqrGLg1FUP
X-Gm-Gg: AR+sD10aVIV6+aiuI6WRh7ny+rEtptbpbfO8iQbyQZv8kfjfSpZ7LQyxEuzvmBUV94e
	Tyd0Hn+kkgdG8txnsS9mNwzsS73JApATpUtMnvavgv4xObQI6rCbSOCHsCNxRxeUPn8hxy0D3T+
	x/9FBP9g9lWRzXB7T+mRXIVwJpDo0ed+EnUaIyK2uwrIh7FavqGb5uDIkJpPI2S1fP5+L139lNA
	+ToLNpNoEWjjnmXWgXY0RhvBe6UA7uVaRKgy92Lm6Suk9Jq/qHzV+hJPg1FpXeXlqnVPM9gfmZY
	nByZpU7G7ScX6FBAhkvCQhpQRvkt+tIjzbakRNOEPlxGYChnwegolS9ixuH71AluO1khR0U2qaY
	a/9XhgAVr6FHSTSGW9ElzVoMQgZ1qq5o7WD72HSt+5oX7qjszEelYrm7oa4vzIeCabsITOVYonS
	lPJyZQ+w2a2QFVIrdQKIPe8pX3vY4RV5zYetURQj21h55xub4o0BykVQI6O3U=
X-Received: by 2002:a05:600c:a45:b0:499:5b04:6920 with SMTP id 5b1f17b1804b1-49987990f37mr60314985e9.16.1786701261040;
        Fri, 14 Aug 2026 02:54:21 -0700 (PDT)
Received: from fedora ([212.253.206.77])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49988b1d33asm40906395e9.10.2026.08.14.02.54.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2026 02:54:20 -0700 (PDT)
From: Serhat Kumral <serhatkumral1@gmail.com>
To: jgg@ziepe.ca
Cc: leon@kernel.org,
	dsahern@kernel.org,
	yanjun.zhu@linux.dev,
	zyjzyj2000@gmail.com,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+8c9eede336e3a843750e@syzkaller.appspotmail.com,
	serhatkumral1@gmail.com
Subject: Re: [RFC PATCH 1/2] RDMA/rxe: drive UDP tunnel socket lifetime from the GID table
Date: Fri, 14 Aug 2026 12:54:09 +0300
Message-ID: <20260814095409.35416-1-serhatkumral1@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260810180635.GB507588@ziepe.ca>
References: <20260810180635.GB507588@ziepe.ca>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> I'm skeptical this AI conclusion is right? Or at least a leaking sock
> crashing the kernel sounds like a netdev bug, not something to avoid here.

rxe_ns_exit is unnecessary.  

I put pr_info in rxe_ns_exit(): in 40 iterations of a netns whose
netdev is moved away and which is then deleted, rxe_ns_exit() was
called 82 times and found no entry every time.

That is ordering, not luck. With a 3s msleep injected into rxe_del_gid()
to force the window open (timestamps recorded with kprobes):

  rxe_del_gid_in             65.844231
  rxe_del_gid_out            68.677344
  rxe_del_gid_in             68.679284
  ib_cache_cleanup_one_in    69.011549
  rxe_del_gid_out            71.535930
  gid_table_cleanup_one_in   71.536279
  gid_table_cleanup_one_out  71.536313
  ib_cache_cleanup_one_out   71.536321
  rxe_ns_exit_in             71.582488 


So rxe_ns_exit is dead code. I will remove it in v2.

thanks,
serhat

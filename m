Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E6AB3E0C7A
	for <linux-rdma@vger.kernel.org>; Thu, 30 Jul 2026 09:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785405349; cv=none; b=c4fXVkyPJ2T26gODoUD1Qppn/l3XzghEF/PArQCb9KoWLcytbGzcPALnu33qqcKqbL/iKNO/glQ9WEHDqUR+EClVnaiF9gsTMGKArpgzlUOjC3WqhZDLD0tdY5b+3b7hj7LrbSYj6o89ovU+RuXKVh79GjDYAt6P7wkO7iOI8Zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785405349; c=relaxed/simple;
	bh=B3SEkQ/hEbP5sv+W3Wk37AU3WK2ejG3sDo4XZLp4wFg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=G/BdkSwRNxzYoAl8qExMiibw73jotd/XOy5Wwo13T49WAZtjCxi00lMHevYa5eIoWigA4C9bKehGDnss+NtXe02BaytGyM/RrsHO2LPHT2vv/ffEM1BonNLP1sX24UNthgARyf2zWsfHKq4h0KC1kJz6tjAS5eEb873B3y6j99k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y39Jikgq; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=HxxO12eZ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y39Jikgq";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="HxxO12eZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785405346;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7Lz8IBXystSHPMs3Dd2XtqjCRsgWgqnaNeE680bLV7o=;
	b=Y39JikgqpcBOWGDQ7Tf5x3PpoSWeeayI/s0T1GxiIsXefy5nqvP95I0pyTQUT0TTtwoB4u
	xFQmC5p1vyEMLzp4aoQsXLtYs2W9KxjEwh3JN1UQIoRKOFRXoJyTr8Bk5WvW5nzxjQwZNS
	GOntEnH8srEW6xcRgHxH4x7ZbUVGxlg=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-74-KNlNGxOSPVq57LKi2e3lGA-1; Thu, 30 Jul 2026 05:55:43 -0400
X-MC-Unique: KNlNGxOSPVq57LKi2e3lGA-1
X-Mimecast-MFC-AGG-ID: KNlNGxOSPVq57LKi2e3lGA_1785405342
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-49545071724so21191715e9.0
        for <linux-rdma@vger.kernel.org>; Thu, 30 Jul 2026 02:55:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1785405342; x=1786010142; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=7Lz8IBXystSHPMs3Dd2XtqjCRsgWgqnaNeE680bLV7o=;
        b=HxxO12eZ0OpTyA6R2c6e8bK/fWbFfLhVgrrcUzif0tqtPEkAQjbXYCrCHKL6VQY07x
         z3nwnSSSIoF7tHE4ePm563RZpqeHiv2CCs0YN5sAvEyuKdt0x07eSCnXW7Mok3h52Tcx
         npxVhru08PR9A70VvLQmL+th8dtlMQFg1eyCm1h7Cx3myLwpA5e4lAsVWYBPVi4NcflE
         gd0x2VATBjM/PjGXWt3upemwWigWLCIdNfim146JAYJbJyBs0SEjkuRpm3bYjI0HisJF
         UpYTp7oPrZ95BemLcnE7Cw7gpDt9WPlKUxlWNmZks1kuFsYfmSHNnS1shjKXCR13i1EE
         UVRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785405342; x=1786010142;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7Lz8IBXystSHPMs3Dd2XtqjCRsgWgqnaNeE680bLV7o=;
        b=rJpVkUDCz5wjeujngc7dzYTgIzC00LRfuzduEpuK9D2C7iBSYreWTKROIEbBVt1zOa
         Afu+NGfbWlnjhAflQM8m/pFJELruGSSMMPWM/tcpCuiFc50PxqTNMHH+aoE8w9TEM4o3
         gJGTscxoMfwZ7kD4EV8a0y1aXCZE6BC41TKDusHR8XBgK+nYGa2OPOavqG2L92cWdwh8
         xz50cEWTp8c3ZbSJZPP9fovWbeRNeuVeZF58s8Faa8BGd4aYBXUTuHUPyQeav9wjC19z
         oSgjXz7NFbJLFZ97hA1VgNKr/rzaKmMhIxBBWiA1bU75KIcw+oPG1zsP8rd4o57uHpDz
         dh7Q==
X-Forwarded-Encrypted: i=1; AHgh+RrGtOnYuT3+qIFbcxQx5D5QZ+2aanJyh7w/YJ+3hr68F+hBiDx+TRywVl1668wG28I9m0IlQw4GX8Ip@vger.kernel.org
X-Gm-Message-State: AOJu0YwgIeSfmdgqLppwVdoSiTdo0EkV/L5Ic2Nx9ReoWQ90eI7oWo3Q
	Rz4cs9FwZp+P8JsswzXbCTOPw++r/xazaDy+QG4WBjsj9ozgLU+gfwlSks4zBGou5q3NIfmzkel
	N2Zr4z83bsSp7WxZVPXdL6G2QbovDlhY7HU2fwTt1Z7GgzquKw+CWa6D4/ss8YPc=
X-Gm-Gg: AR+sD11por58KlZZL+Bp+KCgonFF2roNG8nabHwUFJjDxzSHKTanipq10nuzzcuUjIr
	bhUmgIrhPQ0NJZGqiZVU312zy05khXcKvGG2u0nQFzpyg4Qw2cvDnmNV5hx0xDpOWHaVGXPjCmx
	07WyvDDFKt4AZqwWihvt4/6E/hzlQpe9KvFYk/z9cqu7Aq5M1oACdfiWuM/WaX7iSP6wyG3fnwR
	oi+X+aYVjDxLeooaNvLYBsfKuOu9z6Rk44LUrXI6LHjachS+gy4HoLPatoK83106BUhJy+/9gQv
	/lr1DfENDW+vn1ET/AafO6nH1+IyGlGxH2hS5zbtj0QY2UEsmpJOoUHLP7189dpaTo39N/jF3XJ
	voNwOdGpvdE1dbl6KzSxSUuwkCxLo641AJnSIZefNlW9W3uwd9tLXaYfQir/1wWzoUOVNW0vefC
	0KUg==
X-Received: by 2002:a05:600c:a44:b0:495:3c6d:f294 with SMTP id 5b1f17b1804b1-49800ea1a08mr26153155e9.23.1785405342449;
        Thu, 30 Jul 2026 02:55:42 -0700 (PDT)
X-Received: by 2002:a05:600c:a44:b0:495:3c6d:f294 with SMTP id 5b1f17b1804b1-49800ea1a08mr26152705e9.23.1785405342026;
        Thu, 30 Jul 2026 02:55:42 -0700 (PDT)
Received: from ?IPV6:2a0d:3344:5521:6b10:58fd:68f:7756:389d? ([2a0d:3344:5521:6b10:58fd:68f:7756:389d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-498011f4eb7sm45229285e9.6.2026.07.30.02.55.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jul 2026 02:55:41 -0700 (PDT)
Message-ID: <c4fb41a2-4859-4f91-b65b-b1ca036185ed@redhat.com>
Date: Thu, 30 Jul 2026 11:55:39 +0200
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v2] rds: synchronize info callbacks with module
 unload
To: Chengfeng Ye <nicoyip.dev@gmail.com>,
 Allison Henderson <achender@kernel.org>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Simon Horman <horms@kernel.org>,
 Santosh Shilimkar <santosh.shilimkar@oracle.com>,
 Ka-Cheong Poon <ka-cheong.poon@oracle.com>, Dan Carpenter <error27@gmail.com>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
 rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
References: <20260720184955.3008978-1-nicoyip.dev@gmail.com>
 <20260727174826.135662-1-nicoyip.dev@gmail.com>
From: Paolo Abeni <pabeni@redhat.com>
Content-Language: en-US
In-Reply-To: <20260727174826.135662-1-nicoyip.dev@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/27/26 7:48 PM, Chengfeng Ye wrote:
> rds_info_getsockopt() reads a callback from rds_info_funcs and invokes it
> without protecting the callback's lifetime.  Transport modules register
> functions stored in this array.  For example, rds_tcp.ko registers
> rds_tcp_tc_info() for RDS_INFO_TCP_SOCKETS.
> 
> This permits the following interleaving:
> 
>   CPU0                             CPU1
>   rds_info_getsockopt()
>     func = rds_tcp_tc_info
>                                    rmmod rds_tcp
>                                      rds_tcp_exit()
>                                        rds_info_deregister_func()
>                                          rds_info_funcs[offset] = NULL
>                                      free rds_tcp module text
>     func()
> 
> The reader can therefore branch to an address in unloaded module text.
> 
> Protect callback invocation with SRCU.  Enter the SRCU read-side critical
> section before loading the callback and leave it only after the callback
> returns.  Clear the callback with release semantics and call
> synchronize_srcu() before deregistration returns, preventing module unload
> from freeing its text while an old reader is still executing it.  SRCU is
> required because callbacks such as RDS_INFO_COUNTERS can sleep.
> 
> Keep the callback array unannotated and use acquire and release operations
> for publication so sparse does not have to apply __rcu through the
> function-pointer typedef.  Replace the two callback-slot BUG_ON() checks
> with WARN_ON_ONCE() and return without changing the slot on mismatch.
> 
> Fixes: 70041088e3b9 ("RDS: Add TCP transport to RDS")
> Link: https://lore.kernel.org/netdev/20260720184955.3008978-1-nicoyip.dev@gmail.com/
> Suggested-by: Allison Henderson <achender@kernel.org>
> Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
@Alison: I understand you prefer this on net-next, and I'm fine with
such target, but the current guidance for net-next patches is no fixes
tag unless the buggy code is on net-next only.

I'm going to strip the fixes tag while applying this one.

Thanks,

Paolo


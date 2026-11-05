Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.216.46
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793851540;
	b=0DSvvrwWXdAI4oJpt6bIvEUQ9eTedjybrL4zf3CfDodieB54T4rA/YmKPufXGmzoJaK8
	 AUVBjyhmPjAdV7IfNtQHzwsFrNwpsY9SwX/+R+VDLMFg6oX/8s26Hh9SY3qeB5/NA6Brn
	 MMxyN4D0QSwt8NBQyYrfGIxhqAlOvgbZkctWBeXDFqsuJ1tI2Pe9/pkbTQnMWpaK6vGej
	 dnE+6TozGX8ohY8An8UH0BFI3Hsl/fjWQgwMppdpKtPaSUZ4crz81Z5kUff3nKIRkI+lE
	 FboKURwO4y2NGegVFYxyu6ZbJaw+nDkDCX4q6nu9FRj//WFGCZ0o1Q2hv6QVhH9qvsQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793851540;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=fGRZAFWMKVrIznwSD73OSOgAUilAW1lJLlhpS4NkI0o=;
	b=wshHDEDm6Nq5Ij0GqqIqIA1kp3Z3z1ufOMtT5VDCmFdIg3CV53h+XJ2ZXLuZavn5yzzX
	 HY2Z+mHXkXN+iZqCzs+gywSwmh4C08RnigQ5HCefTSO/Tx+xqgY6D5VcXAUQqSu8iJVJS
	 suBMDpnIjtjMmNa0ldRKd1sqrdpR5uLYqwOIbf3mquiCPZ0FUND+9Nwn/zrogk3uGyQc7
	 j2qmQbmpEFvuARvApjmaJEndYPmi7vMI5vFY0U8WZi6j/wwSuqdBf7k/0nXgUpISSkbAF
	 gHRH9H1sadUh4I6HzzUdwsRO6KIW9I2Bj4Uu81Yqz62MMjg2O/UKREVUouuIuu/AVbg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="LBaS/Heq";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.216.46
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3FE0606A326
	for <linux-rdma@vger.kernel.org>; Thu,  5 Nov 2026 04:05:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C3FE0606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LBaS/Heq
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-3b0b6cae44aso21160a91.1
        for <linux-rdma@vger.kernel.org>; Wed, 04 Nov 2026 20:05:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793851539; cv=none;
        d=google.com; s=arc-20260327;
        b=qgh/zTlx+dGo0leHwTqYQBOGZpphkBfU+QxOm59TNt6czaBzn4opwoVWC15mzA96Tl
         HcgaSnc9On0yuASyJ1SXmvkSpiUjgyjq2idbtgsxYmTVbd5bzRoCOh0txFRynIR2t+VR
         qu88I5JbILRkoZRfujR4dRRwAXIl5tA1WiINVShMnOEVCHNGGzkPQ96lap8Fcp1d9KUW
         BPInVWzrAjTO14LHhe6uwJBgqBNZuXrE6OPLTYY7dpiX2LGCWHYh1aFRi/sA9tUJTT51
         k+32V8AMdFfqZ+bGuVWwv6GzYnjb611HNSWPSmuOe5eaIBB6kbh5zsnklZlpm4jyH/n2
         p0wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=fGRZAFWMKVrIznwSD73OSOgAUilAW1lJLlhpS4NkI0o=;
        fh=Je+XfjZZELYMeUFG782y9M4oZFPTVtwBgMoamcbwTg0=;
        b=Z914NMKC6Ia26D6aAhrV3sPHsQcVy8M4VT5jUVcWinATmBmP+K/jiItRVVdu07drZf
         fmDPsW2L8nsO23oze5GvX4S2fSVD36y0G0BdUEPxlWTFsFyQfLnwFswnAPad7zQahq0v
         cGDGh1WFvvFrsF9NoM8XFGa/F28DUrDk8AYoS0d79pv8+W1rPSq/Jb+Uo3LWWU7g9G6a
         1od8RXs7d5MbxO3GZOq9cy1IyJJ4/S1AJDAT/AJRMnIrhkcELmKgnS9x9Rqk8hpljnwc
         WyUCzpVZTMafkfkHuGHU1Y1kGiDaLCydApzeUmqQRLID3GifF1qqOpRcu+/DGO4e7F9w
         pOuA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793851539; x=1794456339; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fGRZAFWMKVrIznwSD73OSOgAUilAW1lJLlhpS4NkI0o=;
        b=LBaS/HeqKjpCbh5It4KOqF1GOVsi0UM5XxJaEgr8u453UOjEcSBhz7l5LQ28hDdXHB
         rSB8xBUPcIT+Fa8F2vlX4nwGmJZeMdhNRDOiDaLcVLiCKoO84i9PNEo/DIELxhGxpZCq
         NBdFjdvk/GLP8nhwwChnf/45cBT6hmSuMPpt6D6NuFeTI95g1NOsH2ITyTKTS8YrgX64
         kh/cGAf/814XEFEbBtSZPKFy0bcfD+FemEVxaWGyG93hJ3piYYQoa5kc1/iqcMnja+rn
         0YkCLShFVTXXdeTmRUrON7omtYDGiXnI1RvgkOIA3hRmzmG0AGXs18J0jBrJXHQgWLHF
         HF7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793851539; x=1794456339;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=fGRZAFWMKVrIznwSD73OSOgAUilAW1lJLlhpS4NkI0o=;
        b=m2ofsYvHg8SdZcX+Trsxg35LwBpGtoAUa+eOiiJLG8oWdc+8GmlLS3b6FvDE6LERJ9
         Nwny7tz8aQqKjv3n09VoF8+2X753UPROt5cMFiSaRhUEGqZRB9M3du0FzeM7QDqnCI7F
         NQZLl8h+2WhE1NfEADw/UWyfz299T3iWR9fQdhyhoCJvybCRfAB8F/n2D5ety9Y8xY/T
         gHNnOmBnom44W//sICdGSEODVYz/dkCiuuvXF/yLlZO8eLVQ4q/KMCayvUHlbvYGx2zY
         kcW/uld+XKknq6igr2UZqeSkFAHFYn+qrA5SegjKRYy/Mf+au4/1vAtZ3PJ/xrF1ylYC
         A5yg==
X-Gm-Message-State: APuU4Z+dRbqPZVnqUpyyF3IX+AMwO/NN36jcqxD3v6AVO704oa5Ok96n
	42ah3R3SsL1ZXUSFChmk4riNrpgAMIzyPz1PcdbWlpBisou8RxoiroX4fUysa4qYDOISW1d64CH
	moVPzOuUWxa2zuSSRAh4duNz/GG+WpCI=
X-Gm-Gg: AYBFou3edVSdFD0HsmykyyO4HiS/wXlH3BoKm2vxgoLrfHKV/kp4mAETpD5BP+7uHNm
	9M6dr2RBWdGZob2qcjk2mi1Bk4ZCcRO60MwLPl7s0YsDK1uoQf55hJfHIeTEJKps7hB7VRPbeNH
	UCVEn7YMXOB2JebEmNQg+eNgJ8LXzfaP6yXQoNAMil9t880sHNS+vVRsyLXql0iph/XoBpMz+8p
	mhvo6E8t3Vlo0yMvCKBXfUtVzVkC4ABCyWrESv1HRC2tZGm2nDNfyUBvI1uwbmhibPlCZ5c6woW
	p8PHnAgdMz4L9OG9IM/JBqXZgTl+nX86pJnLnYxGWJKi7+KATotanLv/qFRlzPJyCToHV5Ak9M0
	ubvkPzAhbUOafVBWf+u5dB+9Ai5594W0ryaHSBq0nwAy/4sr5Nl05Ufosq5M=
X-Received: by 2002:a17:90b:1dc9:b0:3ac:9e76:aa96 with SMTP id
 98e67ed59e1d1-3ae897c3585mr25695647a91.3.1793851539122; Wed, 04 Nov 2026
 20:05:39 -0800 (PST)
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261104181753.1245369-1-lui2012qwq@gmail.com> <sashiko-outbox-197839@kernel.org>
In-Reply-To: <sashiko-outbox-197839@kernel.org>
From: Chengyu Liu <lui2012qwq@gmail.com>
Date: Thu, 5 Nov 2026 12:05:23 +0800
X-Gm-Features: AclHuK9jTbGmY6RMla1XLvLZjatA55u_1AU1gi1NP4ZRIt_yZ2BwifYBqZ6Oswk
Message-ID: <CAE=Q7=4WboBbXH_GAHTm29sUo9zSNs=caSZ4semRfrBRHucamw@mail.gmail.com>
Subject: Re: [PATCH v2] RDMA/ipoib: disable the AH reaper work for good on teardown
To: sashiko-reviews@lists.linux.dev
Cc: linux-rdma@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, Nov 05, 2026, sashiko-bot@kernel.org wrote:
> [High] RDMA/ipoib: disable_delayed_work_sync() permanently kills
> ah_reap_task on stop

Correct, and I verified it in the source before respinning:
ipoib_stop_ah_reaper() also runs on ndo_stop and on the stop/open cycle
of a heavy flush (__ipoib_ib_dev_flush), so a disabled ah_reap_task
makes ipoib_start_ah_reaper()'s queue_delayed_work() silently fail on
reopen and dead_ahs is never reaped again.

v3 goes back to cancel_delayed_work_sync(): it swallows a racing re-arm
while the stop is in flight (the disable window inside
__cancel_work_sync()), then re-enables the work on the way out.  The
original race stays fixed, and restarts keep working.

pw-bot: cr

Chengyu

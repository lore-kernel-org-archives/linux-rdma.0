Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4126C375F82
	for <linux-rdma@vger.kernel.org>; Mon,  7 Sep 2026 21:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788817449; cv=none; b=LTHhyrb7agdFg077/VqBcjFGutCaJjdqzIvPsYLFN3DAcct/TsQfSdW9VpiGgC9wHUbYPUaJbKFuoj/CLRa8fCGcq4P8AUevybPRs+6pSqEVuPpcgbiCNdrWW7G+7hjLlJKfEfy2eR8736a5lHmM8ggvg1DXWMUzJVWqhzPnr/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788817449; c=relaxed/simple;
	bh=kpXyO1Lh3KGAvYZaURiBKRlh0cghrR52T1tvf40z3bs=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=KOWPvlwDhb49+6/DXhxzNMBWnU+wczyojs3GLgI47W+2V4n5/tvYEAB/8IOPUurD4GDSmClpZMKuHjzienGbPs1LjCmna9jRx43to1L+harovkKuZcluinQLoHb+h913fs+S65kEtv9Y/yVwVGziDMQhVrHbWyMmrFrK50B8Lsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=GdQ7JsE8; arc=none smtp.client-ip=74.125.225.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="GdQ7JsE8"
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-482e1b30c94so237920f8f.1
        for <linux-rdma@vger.kernel.org>; Mon, 07 Sep 2026 14:44:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788817446; x=1789422246; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=QZNaXJghCpqSS6WvG2CJpCXyuhSjyxQRoo++ZoILTFY=;
        b=GdQ7JsE8RVsjFTM6bHF8Wu8swLLtoH4cSbaWdF/zdPfVgt473I2KblftAPzArbScI/
         0C4/yMy+R0r07Kn7i8hx1tjdHg924Auusbc2Mfr+VKsBXJJ2jZ+eLwmbwl7n47mbTXDr
         Ae8y9aESW9eufom4DmPg/iKfUg7KB/Qd/fkqVeg00VEhkunIpXIyNP/N8HCRLK5MpeII
         V8+0yHSrfVVH9CjFv2m614Nn9khGUNR7mmWEMzcpf2lfFTKgdOe+fj6ZoTrj6FTcIUsF
         tx2OL9QXuiEDUpHpHZksCIYYJrIz6IscbrpQZvq8xU4kCxwxX2VbtjsgDlrNIuJg1bZ2
         jqsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788817446; x=1789422246;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QZNaXJghCpqSS6WvG2CJpCXyuhSjyxQRoo++ZoILTFY=;
        b=kIU4gQB/2InW/EO17lUU2QA0MD+l4i/jme6s4bzeDfN2X1FqLvt9FDsWKxnwywvPkR
         D6zTLCGTPc7VdmlcVFLG91Yu7rl5XUEFSHueu7k7KkpmpqQjZ8a5T+gmgzD9n4SoAekD
         4zsR99enr4Yk0RLgY0Mkc9HgxMT0+WGEj0bNk77r3+teLeeNIKjuKhR2wNrWwt9wAsPw
         xj4kILuzA/nyc6/T+vdiDHyuHh4aDRhuKUNrt5IGiT5EMFKyMFY7GnLNEtwKDXEqOHOQ
         SSmWo90hKldFD8RkKnm3rQkF0uFFYkTgB4JpMFcqqNxONrMG0uzLR/YF32drDtv7gmCK
         ybwA==
X-Forwarded-Encrypted: i=1; AKwUvByBX8PdqkVvWrt0mOaWgZKN4LesHGOrVbR8lykOae+XJwAV3IVpDFj9ejG7I0gDlO4VXOEfJJaosdQh@vger.kernel.org
X-Gm-Message-State: AFuF++m2Rr1ULlkTTDy6VAigdEN4f+3XHZpV/q9DtRNCWSPZ2iBmBfYi
	i2ONlsjA5/TiVEPqNEVlVdVzfw+8oveh4wEK+RZxdDvv9edHiw2g4mQnqDhZlpQ00DoyLdSa7Z0
	A4bmKj8Cwrg==
X-Gm-Gg: AYBFou0fjx9DLEUIa5RObpHRQb2Ht7AZrRhh0j4UETD4A30qAgmYoqn7SO81P41jU3W
	gzXXtZIIay+e6SKqJlBWduHlSv2ryqaqZ3E3yhHbe8r9xTh2P5XRpFk/5QroeoP4LVJ7PVljAJO
	QrrWPhZ5BVcIqvqnH7OBT2rPmKQGADC0jAcLQjpTFN/jWizGhG5cKi57NfLR1HV9cQ1JLXn/a0D
	zB2OltR5wFa3K4fmsUQcv3oblq92kipwk2X/lxswlUcIbMs1s89DuxBObpArSeIBTwtVK8Evve1
	/usR3yG6GZijIhnsbZlGlHRN1rltpe79c7EBIH5hNxYsGxfMeCXbkw2z9vBDvhTWeLKTkQ2aZ2N
	CK6WN55rRSPO7+jSjS5rxS6VS1scZv/yAY3ZIITdpqAI6OACltxz4xj9azHNeLY2zgK6X3TEwrJ
	8gGSdCxm1xM8ZaRDUU2K5+mleESiazGXoQIij9FSGwy2p8usbaMkqOg7Pt9uexRm4BUgPo8koSb
	lgtxkZFMDu6bHd+iOMy1K83p5w+kNs=
X-Received: by 2002:a5d:5e0a:0:b0:484:3200:b7a6 with SMTP id ffacd0b85a97d-485907ec2c3mr16379341f8f.4.1788817446526;
        Mon, 07 Sep 2026 14:44:06 -0700 (PDT)
Received: from [10.20.0.128] (lfbn-ann-1-199-252.w86-200.abo.wanadoo.fr. [86.200.161.252])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4859162f354sm23836899f8f.20.2026.09.07.14.44.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Sep 2026 14:44:06 -0700 (PDT)
Message-ID: <681ae665-523a-441b-bbd8-dbae51ee64f1@suse.com>
Date: Mon, 7 Sep 2026 23:44:05 +0200
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] RDMA/rxe: Use validated num_sge in local buffer
To: Zhu Yanjun <yanjun.zhu@linux.dev>, Zhu Yanjun <zyjzyj2000@gmail.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 Tristan Madani <tristmd@gmail.com>,
 "open list:SOFT-ROCE DRIVER (rxe)" <linux-rdma@vger.kernel.org>,
 open list <linux-kernel@vger.kernel.org>
References: <20260907161550.716670-1-nmorey@suse.com>
 <27376486-9cab-4d42-8ed7-36e13231dd91@linux.dev>
Content-Language: fr, en-GB
From: Nicolas Morey <nmorey@suse.com>
Autocrypt: addr=nmorey@suse.com; keydata=
 xsBNBFjZETwBCADEkoe7QWAXzd9xpSiPbQK6P2F4wKdxyTp6r0aN4I0O+4fc8xWXvmwOrCjF
 UsuoGZ3CxJaHgdB/3ueW/IhMO5Ldz7pylhKVlG/moUh4CBK2eRUdaG7mHID01GyJMtR3VQqu
 22hJhHPYy0erpYViyr+I4MzQA9QZLoQhSxn4imjZOZPcj20JE+lRfXppNv9g7vQiRLMcXjTi
 KcnrqG5owOi6Cn1sZ201YfdeztGxKA+jvjWO+6absTTlorIlZNGUf85s2+caGDsqa31u2DPs
 hVv5UUTy1g/5aP2wacSWI3Qm4n2MWl1aCnHN2h737PCXXfBk5iGJsgBUnSQULgdgEAt1ABEB
 AAHNH05pY29sYXMgTW9yZXkgPG5tb3JleUBzdXNlLmNvbT7CwI4EEwEIADgWIQRC0lOFwaHA
 K4sbHG+AG924JZiPZAUCY5G8SAIbAwULCQgHAgYVCgkICwIEFgIDAQIeAQIXgAAKCRCAG924
 JZiPZMZiB/9QkcGfH248qvFUWZig3jssK5IgijfOFDKB0YK4e844M5C8LVSuWpu7Z+lM+cql
 3mbrikW6mlZjPEusrQ/KGvT6TdfOM9VCQWjlshMzt7uiRDdzufHGtE5hhk/67UnkEVjmplpD
 k8cb1O0VsBfGym7e0nySHTlDWqr++9EcwgV3uo4psYYEqm6Aon1yKqjbmj+vfl/C5iW3V4lq
 DhBk8w21AvNS+tdEqJzhruxuXkEDZZ07wYFS7m8OxLNb4sMzn/Nz9x/NXeweBWx2ujIERtAq
 1e/hh0ZAcoPVR3CfO2QTmfTfrzVdpZrZ8F54337ze3+BUNnrFGObQhlNe26NqNYWzsBNBFjZ
 ETwBCAC9zAzCRlTgzyO9siVLQYwbRUhcL1TUJU/FiOQWQTmL3uDdBc6MgVBs+hp82RwPbbXT
 v4W4rghBYPKdmFXvRN+jvGDLq1f2hsuCSiE1ckTMzFV+sKoWRIEC12tEpw5ncEFGm+1k/rJR
 Lk9eHxuqn+yRjPryN8CK6tK4+b4tZ2urKlP29XG+T3l/mbUSoqfjqvyeKaW6xw7ku89EX2Xo
 QWP/pm92RxUd6VDU9vpVW/T7qPZRl0wtUnDnO2wePoZmvUfEr5Osh3MNvm1myG+v4EV2Hgva
 NT6pa27IptrUq06cA6dDsIKwPtMuThJQp8/xumgl5Q9A/ErQoJTrB9rclIm7ABEBAAHCwF8E
 GAECAAkFAljZETwCGwwACgkQgBvduCWYj2QwNwf/eOIpFB67cKoUJvcm3JWcvnagZOuyasCw
 xwH9a0o9jORcq+nsJoynS/DpjUKGyZagy7+F7sBrF7Xx0cXF2f5Bo42XNNiQDE5P/VLwvgn9
 62AJ3q0dp4O7oQI8UgNmdsocQhNaBHHCoOabLGrgNobDTaLBeb9zaOZqz8CBuAiZ0bVABEpg
 50hDEYTHp4jCgWpadhAsp/eCgm93Tc+Y+e1fqtE3FmoOLxyhFa6evhn0Q1iX0kCasMZwlzse
 zqLZjTM1Koqn6+UIHXE3QaULyFKD1GDhisXxyolOB6P2TXsyfvitYdIZ3CCtI7PVDxzmX2Xk
 kvEz9bMtStoMpse9qAsmHQ==
In-Reply-To: <27376486-9cab-4d42-8ed7-36e13231dd91@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 2026-09-07 23:20, Zhu Yanjun wrote:
> 在 2026/9/7 9:15, Nicolas Morey 写道:
>> For both SRQ and non-SRQ receive paths, the WQE is copied into a local
>> buffer to provide a kernel-owned, validated copy. While calculating the
>> memcpy size from the validated num_sge prevents overflow during the
>> copy, memcpy() itself still copies num_sge from shared memory.
>>
>> A concurrent userspace modification before or during memcpy() leaves
>> an unvalidated num_sge in the local buffer, leading to potential
>> out-of-bounds reads in rxe_resp_check_length() and copy_data().
>>
> 
> Hi Nicolas,
> 
> Thanks for the patch. The logic makes total sense to prevent the TOCTOU race condition after memcpy.
> 
> Just out of curiosity, do you happen to have a reproducer or a POC script that demonstrates this race in practice?
> 
> It would be great to know if this can be reliably reproduced or integrated into testing setups (like rdma-core tests, or tools/testing/selftests/rdma) to catch similar double-read issues in the future.
> 

No reproducer or PoC sadly. I haven't tried to make one though.
This got caught by one of our AI tools when checking the backport of CVE-2026-74377.

I assumed from the 2 existing fixes (ending up as CVEs) that this could happened.

Nicolas

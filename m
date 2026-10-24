Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.227.15.3
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792831466;
	b=2sDn1CRddAOSDW8D9Cv8cETLa8k9298g7b5tbzvG0wLg5YZBtN239tV1/wuD/mKvzZlF
	 Bd6tRjD8gSA0oNlMJYmDXCgwGMosYyu1li0ClrKQ2cVVcFlBXu5MNh1rIeNU6SVRMylVp
	 wOnWm17YNKta/4QV5OweCSAsSWmfCwU8mZz5Cc1AMLGDIghQIKX/T9Om8jPQIVsGSbEGU
	 aUt1GiG5dZ0JHv6bOTuwkJPwFnEoAOL3eGTT8RinQqEbXP5ROeIC0RKK/ySqLbEglFqO4
	 dZtQ8dvgLGhZasaNtVIwshxIPpg05VU5JTpANaPSrY0gZrWTI11rb6CmzNRmZvV8GjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792831466;
	h=DMARC-Filter:DKIM-Signature:X-UI-Sender-Class:Received:Message-ID:
	 Date:MIME-Version:User-Agent:To:Cc:References:Subject:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Provags-ID:X-Spam-Flag:UI-OutboundReport;
	bh=hTj3cXk1m4gZEvPvh6oO6BCfVERaB176717oG7Thj3Y=;
	b=3KzgmNwG7ycWjtGDR7yOTuDX24hCGK5pGVAW1ck/OarDViV6yo67Cib747lrkGgPaEMl
	 7lD2zGvhX69Yj83Ba1dZapg0IjG1U41wqi37nYMW8HfrSZXGk0T3jnthgPCiFXTXcDGVv
	 Wk5MaAP/FmwnZy3x08/d3ifIfcFOnRxEKib0cjOudMMMIeORued8He1aU2JPQabUUIoJD
	 6ZnjExPI9BTG50chxQP4POGSqV0Er0rpEKGjFw/1u8DA5h2aZXmsXvbNZlNWl8bmKR+e8
	 cAwL08QJueiaNYYJI7NxFKQ//QRrgMgW5spz9BpbQ467grNf18m0i/N9kLjWb21Izmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=web.de;
	spf=pass smtp.mailfrom=web.de;
	dkim=pass header.d=web.de header.i=markus.elfring@web.de header.a=rsa-sha256 header.s=s29768273 header.b=rtjcZbRf;
	arc=none smtp.remote-ip=212.227.15.3
Received: from mout.web.de (mout.web.de [212.227.15.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C252606A31A;
	Sat, 24 Oct 2026 08:44:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4C252606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=web.de header.i=markus.elfring@web.de header.a=rsa-sha256 header.s=s29768273 header.b=rtjcZbRf
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1792831462; x=1793436262; i=markus.elfring@web.de;
	bh=hTj3cXk1m4gZEvPvh6oO6BCfVERaB176717oG7Thj3Y=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=rtjcZbRfvSSodZU50bxKMGfHBvuk3lYv/JeRWLxAjBRSOxoApU1aiZdF9GoqVscb
	 IoFRLEBRb0mKZ5CBOa6wX1Yd4EK3zPzP75SiJI+JLAdQTUr7SzIaih1lXyqRbqbo5
	 L6lUvKDQnE6n2vwcPjgXiQwsb2j8y6uEyvTbqYSUnWvh6RSX2/uS6mj4dcwSu88VE
	 Oxjotn4+ke4+PLtJYCbQWl2dTrnXFRazUG6jeMUZlyokuw2Vl/2T7SaJ2O7nDsH+M
	 G15HStNIORrOxmGCeWCSFR9P8iLocr5mILVfblTwoHmTl2gcBSZAVHznUJF6Ig9dq
	 1/+4DmWGdpyf0+lFJg==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from client.hidden.invalid by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1M3m59-1xLMJB21T9-00Gnj8; Sat, 24
 Oct 2026 10:44:22 +0200
Message-ID: <17e2204c-b16a-43f4-bf13-9e897d611736@web.de>
Date: Sat, 24 Oct 2026 10:43:58 +0200
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Yanze Zhang <zhang.yanze@zte.com.cn>, linux-rdma@vger.kernel.org,
 Jason Gunthorpe <jgg@ziepe.ca>, Julian Braha <julianbraha@gmail.com>,
 Junxian Huang <huangjunxian6@hisilicon.com>,
 Leon Romanovsky <leon@kernel.org>, Zhu Yanjun <yanjun.zhu@linux.dev>
Cc: lkp@intel.com, LKML <linux-kernel@vger.kernel.org>,
 Chengfei Han <han.chengfei@zte.com.cn>, Junyang Han
 <han.junyang@zte.com.cn>, Ming Ran <ran.ming@zte.com.cn>,
 Quan Wei <wei.quan@zte.com.cn>
References: <20261024071539.2182864-4-zhang.yanze@zte.com.cn>
Subject: Re: [PATCH v6? 3/7] RDMA/zrdma: Add internal headers and hardware
 register definitions
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20261024071539.2182864-4-zhang.yanze@zte.com.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:QxwLPP2tcItfJ69c2vTfqQ4UtgpefKU9bsEOCevcrUlsy2nx8vS
 PmkQr2iUC16w9n6aR0ABvxoqcSNvfnjNo/dwwy5fEn6OPTLdIpWMAq4ZrvkjVGto6fCQHRO
 4EYX7wFjDLcQR+ILAtb+Dd2mWExjjnpJzHpxEmLx+WI6Evc47YApZTb3NAAUQITjVYhweJt
 RXRl6NSmL3s0ZeimXXe4A==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:n+mftfA5/Ss=;64ultQSe+wr4XN+wfhS4FYeO4PL
 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

Please specify version identifications in a consistent way.
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/submitting-patches.rst?h=3Dv7.3#n711
https://lore.kernel.org/linux-rdma/20261024071539.2182864-1-zhang.yanze@zt=
e.com.cn/


=E2=80=A6
> +++ b/drivers/infiniband/hw/zrdma/zrdma_main.h
> @@ -0,0 +1,216 @@
=E2=80=A6
> +static inline void zxdh_free_rsrc(struct zxdh_pci_f *rf,
> +				  unsigned long *rsrc_array, u32 rsrc_num)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&rf->rsrc_lock, flags);
> +	__clear_bit(rsrc_num, rsrc_array);
> +	spin_unlock_irqrestore(&rf->rsrc_lock, flags);
> +}
=E2=80=A6

Under which circumstances would you become interested to apply a statement
like =E2=80=9Cguard(spinlock_irqsave)(&rf->rsrc_lock);=E2=80=9D?
https://elixir.bootlin.com/linux/v7.3/source/include/linux/spinlock.h#L642=
-L645


See also:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/coding-style.rst?h=3Dv7.3#n977

Regards,
Markus

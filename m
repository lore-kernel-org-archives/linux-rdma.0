Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795009015;
	b=EPJuJlKraVnjO2Koa8ZsAB6Y5Wif1c+Q27gIrUykNB/gbekIkIgvCySGCwF2g/7YJKF5
	 lgJFJvp6h759rQOJlJ0IEVxzdI85a36vTLkd5sgNwccsgSv9JGbwR3EcYj++0PhsDZNFB
	 aXAsOeDL015MvpH4W9Sq8ds2LOOcOrid1qTmZGfd8Dz1E2mcoFdIrhOdLsSuSj9kK+JrY
	 foImpiSdU00c0LmjS7BilMLSEXu/zu1F7GQiNIrj09U8zoLdGACe0XsUpVULc9qcvidaE
	 q2uM0KtOIJ/Auwo/zybTdoUUEdSZz6MouLAtsEkRXcocIDQ5sO5HuExh8nwZG3W5xMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795009015;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 In-Reply-To:References:Date:Message-ID:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=w03ATw2OTpQDW02bPwlZS4vw6PB0Ktdw/58eiEbhtvw=;
	b=lCla3lfI/wntn5ZnNP+o0nbeIchuf9CzxP+7AKpCNDKC9rdLVgwVZIL0JPZE1/nkA6vX
	 8tU7waEDjyofrde9aWHTBZobWkKjq66tQGqH7TbNteuD2ct2HhqJtPA9OPXiKWiRMlT9b
	 34F5thDtckDkNk7aYy9aSPdcX3d5iHMqNCHbjLZceM8bYIquCX5QJEuusDzoT1djeT5Q5
	 GTHbI8IF/HhOFhLn+FVihnR8GeiCs23QlXaOavjbB0sv2wf+KCate9KD0EGDtkyPkXPhk
	 wAgh0jhtXJHdwF3YvmDwfHw2nGGPFoH0wYUVczK1AEYp8prLU+7HjSIh+4Q9g+IXD4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FRUkX+2N;
	arc=none smtp.remote-ip=209.85.221.42
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D1DD606A320
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 13:36:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3D1DD606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FRUkX+2N
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-4a33359c1b3so646962f8f.3
        for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 05:36:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795009014; x=1795613814; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:content-type:message-id:date
         :references:in-reply-to:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=w03ATw2OTpQDW02bPwlZS4vw6PB0Ktdw/58eiEbhtvw=;
        b=FRUkX+2NhFl4XqD9rpeSVQucmu57vbpg2eha8Mz8lWdmBjpaGBurFtgDELJFy31kJw
         L00oBXdpnmokno8GZvoMQTAtPYICc8ROR4cXC7rwKL+y4PcRSr3cO0wHf1NjCy8kT/n1
         GaNs1GTzmMRtk5nNi7k39O16boudO1LV7E0iIYUsrLCM2+BIsspvfualxN5gqYRRlZv0
         EdUezlKgauGiIana6C2npWsrZ3HwzFDZ/WBXv1ppxWsGZjLHvjS7ULlTA5d9ks2O9+xE
         h24lt/K0yxr/c7pMaSr72AJUlGuih6xCKKqpR9XeydsLn7NSnI8vURamUxTyOO9qvcJG
         BDTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795009014; x=1795613814;
        h=mime-version:content-transfer-encoding:content-type:message-id:date
         :references:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=w03ATw2OTpQDW02bPwlZS4vw6PB0Ktdw/58eiEbhtvw=;
        b=uBoMIIXYbJciHHN2uW/NyqB0Vylun2Jo0aCB0pBFPg3NFyK0aE2FRewhsevCXtnQgm
         /+GOEVHJyoQ1y6whR8PxvI+don7haTLtGvtrhIOovhzsqeiGfdZxEbjjAB4hh9E5gRes
         zZTXK38hvl3ujn8BjQgMBh6VmiQa4rtLpYFME5dEkAT5BiwHF+yQRKnIG0Ugh5sA35/Z
         k/+V9Xf+kGjXGxrEzMghHHsr8mN6t2VmzKlDsr1iFEgNJuKDEC4HmVuiZT+uYLCM2mSj
         HSJ/LqVSujBGZemtt+bndI9PpA1V2p+oN2ZayX6bRdQLwcMPBVLRj2CnAdUDzXTWD6+6
         8RDw==
X-Gm-Message-State: APuU4Z8RV+OiN5SmWzPeajZxXB09oCiIlfBUDznXTknhAe0/+Z5bzfwR
	zFP5JkiSEkXYJyl3dDyY4co31sIIzyGwCTasZptvqGlBNt3yxEqbg+jqcvWtb2W7Emo=
X-Gm-Gg: AZFdTZfxBzC2nhn08qtf7aTp3MU0diVdlmZz96XqnxRSdGl7MNlJgUTYYm2ZWaqjc28
	gLk7b8+ytGr/Zdnksc+/lCkuvpZzQ6fvAO6b7fmayaCdntHgd0lzqnr/9HDe0iNyBuca2daVfcM
	t3xkFzHB+j+nwmUCBiCgVyHg4u1QZ+8n5fcnHCTUIsKsvDFGJOhVzAB8i8SNoOiAhC4F/rbIwcF
	K7NXTEfyS6kLp6PPO5Y1YurvNLR0PZwlUN+bG8xTE9VOD+fPSQMRpCnKWQPZl0XY22dgG9/Eluu
	JApXpMim496pHNwxWyxzqR01FIDYh0fYPMojKWPQxcOn6f3tYPQiSCQSUqMa4CmLAhf8QQvdMIo
	+2priRVvRJgBVgL5SKBxopKAJm+XYCbJiBa7VB9PeFmqQBw+53yj7MCZ6Wi/C/FbJzxLb9quYxg
	rlToS23XSUkpeYtyb9YBAaWijLGg4Zr4XZd9huBlzuRG3H406kvF26blrklehU0aN+be/xlxwXQ
	3xGodk52IEKAkfOjONwVIsUGJD8FZiYOSqZ3VN/MIJqKpdqCORysWsTCMh3LZTtbPyCB5rbLMoD
	gJQGUuLXiGlucLRnrEyFj7EEKieS8PATygpcu6/gBEn8q8G1bYg114uPQDtUuaoAqCa3hYBgkUK
	hQayv
X-Received: by 2002:a05:6000:1606:b0:48e:6f84:2e8e with SMTP id ffacd0b85a97d-4a63e6f1a49mr3403179f8f.39.1795009013537;
        Wed, 18 Nov 2026 05:36:53 -0800 (PST)
Received: from SurHub.localdomain ([196.188.113.38])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4a656c11f1csm5299746f8f.53.2026.11.18.05.36.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 05:36:53 -0800 (PST)
From: Abdifatah Suruur <suruurism@gmail.com>
To: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Cc: linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
 Leon Romanovsky <leonro@nvidia.com>
Subject: Re: [PATCH 2/2] IB/hfi1: reject writable SUBCTXT_EGRBUF mmap
In-Reply-To: <20261118131948.28748-2-suruurism@gmail.com>
References: <20261118131948.28748-1-suruurism@gmail.com>
 <20261118131948.28748-2-suruurism@gmail.com>
Date: Wed, 18 Nov 2026 16:36:51 +0300
Message-ID: <179500901107.1415.1266627283580496093@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Hello,

Please drop patch 2/2 of this series ("IB/hfi1: reject writable SUBCTXT_EGRBU=
F mmap").
The automated review pointed out that uctxt->subctxt_rcvegrbuf is a
vmalloc_user() buffer that userspace subcontexts sharing a hardware
context intentionally map PROT_READ|PROT_WRITE: the process polling the
hardware receive queue forwards eager packets into it. Rejecting VM_WRITE
would break subcontext initialization, and the existing VM_MAYWRITE clear
is deliberate policy. My patch was wrong; I am withdrawing it.

Patch 1/2 (STATUS VM_MAYWRITE) is unaffected and stands on its own.

Sorry for the noise,
Abdifatah Suruur
suruurism@gmail.com

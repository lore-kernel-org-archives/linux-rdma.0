Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794747157;
	b=g0slNXA94xb3clbjNZphMlHuFVZEdIvbEHqzXsfspllT2rwwdQPuIbSlnOFT9eVHengq
	 tWKcXIhP3B0X1AqsPsviihlWDHxUSlkGPLdpXMgWutsY5BQwSfc5uZhfQTCowXC4AJY8s
	 SAdc1iIO6cO0NMs+SqAYqna66X9wSHPNoek3ljBElTQlXFVRc64Q0wwbQTh7IJ1O7jpwu
	 0ztEnxxkSXuYyTscmqIhtXgsbyrfw4IuSIX+CQ6dqOei/V5uoJx8/L7zJB1tVRzaK0yNN
	 fhwxQJrl6Pc/s8nU70Liu4DrkYcumaJLZa8DJhiNA6ODPnsPi7bUZusWRgcSR4Cam1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794747157;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=EF14ylpOObr6PPjxpjs1ziBYXFSJlaR5tN+CHwL2L0Q=;
	b=N7wLyBrxsOMINwMzIRPlC3TA/6Zbj2aMSr/nSEGgy1nETYU+zV+3omG2uoHrMe5XmF10
	 TYfwFhzOMOg2gQGkOiVPlrXxPmFi9JvI4eYPLCf4702MPnDvvtTRSRU+0TsS30y8eeLkM
	 RtLPxFyzfVaSwghljcbk7U2L9Kl2ePQudjB8bv+EX8JAk255jteFvA3wJHpVhuRGntHPY
	 lWRSRUBh52ZTPCzcZfp5IIxg8JG1MqNRXY0KIWMPTE3UwQlvaNDSPGZJsI9z/+EPAJHLh
	 GKvrwyp3T/4rVcKMIZYq4GjsJi9XCviXBDFidW2O2YGvQZdR8J+DlPbucKNmfvG3Tjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FvWHgOWt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9C08606A31E
	for <linux-rdma@vger.kernel.org>; Sun, 15 Nov 2026 12:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FvWHgOWt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F8831F000C4;
	Sun, 15 Nov 2026 12:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794747157;
	bh=EF14ylpOObr6PPjxpjs1ziBYXFSJlaR5tN+CHwL2L0Q=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=FvWHgOWt/jm0Hdoos5s2Of5BU8sKHSj+htnr9ubkagL41lzyEp5+zfFawY3+TPxMz
	 p3P+pVefKbl9OkhyI+ZuoEIxpm/7kNmp72aZFCgUqdbFGdogX9hg0DWC/Miwqe/cRn
	 n7aAw2NPvje8WiEZwSwqhpbiRhTOil2zVTYsvxuCLgZSuKo1urCDIzApOd1nSivUv6
	 o3iS0Kj6HAnM/jAjLulMKHit17AtjxkANE0Lybo2yW6/6Pt8BYi4ELfSOKx/nXGZ9e
	 E5GGx2tVhjXHOLQaIYPuvSVyAkkrOdDCTd/43o3DiT814dvOME1xz2g4Mhvc9jhCy8
	 nJFDBfJj3jePA==
From: Leon Romanovsky <leon@kernel.org>
To: tatyana.e.nikolova@intel.com, jgg@ziepe.ca, 
 Jacob Moroni <jmoroni@google.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261109202525.2937295-1-jmoroni@google.com>
References: <20261109202525.2937295-1-jmoroni@google.com>
Subject: Re: [PATCH rdma-next 1/2] RDMA/irdma: Fix potential UAF during SRQ
 limit AE handling
Message-Id: <179474715512.1305858.15747650114156355759.b4-ty@kernel.org>
Date: Sun, 15 Nov 2026 07:52:35 -0500
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Mon, 09 Nov 2026 20:25:24 +0000, Jacob Moroni wrote:
> Previously, the raw SRQ pointer was used for the AE cookie
> without any mechanism to ensure that the SRQ object was valid
> and remained valid while processing the AE.
> 
> This could lead to a UAF if the SRQ happens to get destroyed
> before the AE handler has a chance to process the AE (and any
> other AEs in the queue in front of it...). It also means that
> a bogus cookie from HW could cause a wild dereference.
> 
> [...]

Applied, thanks!

[1/2] RDMA/irdma: Fix potential UAF during SRQ limit AE handling
      https://git.kernel.org/rdma/rdma/c/ca28a5ce3559f8
[2/2] RDMA/irdma: Drop unused SRQ table from resource memory
      https://git.kernel.org/rdma/rdma/c/c890a62746d086

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>


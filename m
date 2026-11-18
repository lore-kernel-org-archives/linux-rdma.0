Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794965374;
	b=dIUOHa+qXjYtpVvzW7qmemirhPsMOfj8tGFsAx8ITnp0NX3T+i+4ceXf+9R9gpSzvoNT
	 GJcUXVVJrlnaI8KNJ4hEi9BDdFbbXmv9SZ9EfAZhVQSTLKZP9IHRyjKeFq9NYRjYCYpzU
	 XYDT7R80dqr/3F/XoHQYX7xijUcOIYzndvbbZogDW9XAJwI8GybyYHdyhHPAfx2clZ2lJ
	 B2otZKDsNuEvU8uHhja3aaDj4yoHxX8JaDDowTAo8KzbDYVvTxYaJuRf4C2FX+7y5caMg
	 cv6AVseXid73x//3H3IlzPHs5Fjq+2ViV+TlG94uCAe+zuNWijTm25f86q/nCwvq3bA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794965374;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=w3JSCXNwcogBu1PJnd6LhkuPj4w6tsB9fs1YwGA31yI=;
	b=YblRpi16/gx7PoLmZEh/81LoWJuuYUrp82cJNx2yZYeTFVNANskX9lzox5U8668gZ+Fk
	 VmFlTwlPxE0RIIlXb+JfCq+T59T16ceBQllys42lIG22QdwfDJc6z0GSC5JnN8I7Cu/Jh
	 H17nMbsKarshBVn0Qd2WHljktqrmzBoxH6AYtGgDHI8Z5xtai0F7MoPzPlIG6WFQJAwRi
	 9+WVJabpTV1uGEPYtT2XPqQroBwkdmehtziMfuqlV0eFCuSGkCZJCEviDOWWlkvUcdhgj
	 Cd5FiNhe1yCBRPZoxovyBjDxr0e+7Lv/+54iDoiRy7Cj4pMPuf4dwMUHucqw0KfnGKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chromium.org;
	spf=pass smtp.mailfrom=chromium.org;
	dkim=pass header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=O9DHBRIP;
	arc=none smtp.remote-ip=209.85.216.44
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B24A606A32C
	for <linux-rdma@vger.kernel.org>; Wed, 18 Nov 2026 01:29:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5B24A606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=O9DHBRIP
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-3b3b522ef8dso29771a91.3
        for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 17:29:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1794965374; x=1795570174; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=w3JSCXNwcogBu1PJnd6LhkuPj4w6tsB9fs1YwGA31yI=;
        b=O9DHBRIPmjIqt6AhONYCYYyAxWEJ+jwHuEmk99wwjzt2Nc0YnZQ+dKRQk4BcX4Tx3/
         EAwCsCIjOfij+kfDzFdvTyjQb7+AGv+8efMSQO+env5URswiaB4hGUmHq/mLnQ/2rVeR
         InpfSAF+62jlzeryXe/PJ2gNlX/ew/8siqlyY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794965374; x=1795570174;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=w3JSCXNwcogBu1PJnd6LhkuPj4w6tsB9fs1YwGA31yI=;
        b=kMjz2GGxYcwr6r+nmmlegBW+gU0aCktMuLc27UbaXwufmE/aykJRHd2zwS7IAZcxuI
         eEMzx0+6tAhSfdDrU/42QDJ9Vd9hYD5ROZPKat+zqTspHSiSfggj6HcaN6sp/KwGvr3s
         3Ds+G7NsaQH6NAd+swTHsBaRTV1Gl8OnhO2aObhNqsi4/TqRV6S/kZ5odAbWyEzLqWBO
         iofUYom2JyeMSv44UOZHKm5gDXauRuuPuQrvNJaOJhfzad8b6fCly7KfpZsLjZEFMUSI
         MCfTMvoq0rND5aDz26hSASL0IWQi+/j6c1m84pZ6kNYzt3ctMqMxkxCwg9ZD6Givy55J
         0Tvg==
X-Forwarded-Encrypted: i=1; AL+hErHclxQgv2F62CC0qhmiFltz2kkOpxBVcAwFDmC2Emfxi8J2SpmRQj/4ZhMW/mLDxSZLNm88D+bPrBsd@vger.kernel.org
X-Gm-Message-State: APuU4Z8Cflf7NOxZHStg/fqWNjkA0BN4YrPxq5Fisb3ggG0EO55djTTD
	ux+LGsVoIXXrmeJThPteTANwS7SZLE//yuSd8WDYVihOXkLjBCwxMz9UwCubx/GGKQ==
X-Gm-Gg: AZFdTZeor3d4lMI0B3ZrwpIpjEV6l2pfHJ6kneNVmjIwhGkjG369GpBzIJa4Nz6eIQi
	EdGOEIccSqYZECzeV4C4znYNrW20Si+k6wItrQHxXNIw4OdoJD8PCvGtB988WVroRleXmFL4H5Q
	eb1HpH5kf1WUMjuwEQR4Qe4atrbQSydA715qzD/FbMbBtChlyYwpXtA/JblUXtUGnb0evpygsHl
	7B9ukAKq5tKI9aM3miIL9qSFbwMH+XBrl8D4FDIvRA6k56ftE9OFrXXK8oVxUwAYj1CliLvQyna
	r1LmrCxGzR4gTAZL1qutHwSMVkskb58amsHLbFBTrCv5imNW6DuDcKZAdmdQGQxZrPsw1wvLTlU
	vxEXRbcclq7VlAU7yQCGMIHw0XxpadgbSSkSEUB3SifauZSxKeSiD2mG0APg2xXoLzarLWet40O
	1Mqs5bGBxHAN/q/VJCDk0NCYOlXcOyHnIiIEzO+CayWA7lHuFVEMTCa8qqMtjz4aFFbyX2jCGN3
	Q8rw0kqBRz1puVHlsLeDlqFQMtATaH7TfgP9mW/gBwR6QXDanaKYJRC6dyfwaw9pUW9CWAYkvQF
	BdMabSrz7Gl5gSG0/jmry/HWTrga1VxaUxuBfIFiL71D9Hts0NsKfsI3IAgLcNxtCNykfL3+Hfc
	JxU4gsP6PUYRin7QB
X-Received: by 2002:a17:903:3bd0:b0:2ef:eadc:5c98 with SMTP id d9443c01a7336-2eff6f86b0emr15976975ad.0.1794965373725;
        Tue, 17 Nov 2026 17:29:33 -0800 (PST)
Received: from localhost (221.247.125.34.bc.googleusercontent.com. [34.125.247.221])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-2eff5ed09b4sm4409835ad.9.2026.11.17.17.29.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Nov 2026 17:29:33 -0800 (PST)
From: Jeff Xu <jeffxu@chromium.org>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Jeff Xu <jeffxu@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Marco Elver <elver@google.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Chia-I Wu <olvaffe@gmail.com>,
	Dev Jain <dev.jain@arm.com>,
	Evgenii Stepanov <eugenis@google.com>,
	Ian Rickards <ian.rickards@arm.com>,
	Jann Horn <jannh@google.com>,
	Jeff Vander Stoep <jeffv@google.com>,
	Jeff Xu <jeffxu@google.com>,
	Kees Cook <kees@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Peter Collingbourne <peter@pcc.me.uk>,
	=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?= <ptosi@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Tomasz Figa <tfiga@chromium.org>,
	Will Deacon <will@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Baoquan He <baoquan.he@linux.dev>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Allison Henderson <achender@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	linux-mm@kvack.org,
	kasan-dev@googlegroups.com,
	linux-arm-kernel@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	kexec@lists.infradead.org,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	rds-devel@oss.oracle.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 5/7] mm: kasan: skip KASAN for GFP_HIGHUSER
Date: Tue, 17 Nov 2026 17:29:29 -0800
Message-ID: <20261118012929.290499-1-jeffxu@chromium.org>
X-Mailer: git-send-email 2.56.1.703.gf848ed807c-goog
In-Reply-To: <avwp1ZpVudiT1Gux@gremlin>
References: <20261116230627.3537051-1-jeffxu@chromium.org> <20261116230627.3537051-6-jeffxu@chromium.org> <avwp1ZpVudiT1Gux@gremlin>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Tue, Nov 17, 2026 at 10:21 AM Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
>
> This commit message is just inscrutable. It's like reading Finnegan's Wake :)
> LLMs are obscenely terrible at this stuff unfortunately.
>
> You seem to have rewritten commit messages for the other patches, could you do
> the same for this one? Thanks.
>
> > Link: https://lore.kernel.org/r/20260519-panthor-kasan-v2-1-b7384458f076@gmail.com/ [1]
> > Link: https://lore.kernel.org/r/20260521105148.5497c281@fedora/ [2]
> > Assisted-by: LLM
>
> This tag isn't used any longer! Thanks for acking LLM usage though, we prefer
> you disclose it but in the commit message or the cover letter etc.

Fair point -- looking at patch 5 again, it is way too wordy. I will
rewrite it concisely from scratch for v2, and drop the Assisted-by:
tags (keeping the note in the cover letter).

Thanks for the review!
Jeff

Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795404681;
	b=M94JmB3bFtfssajejmDY15jEeQSG3jgmAm1eius6m0haUauh37vHZxFKJngJuYlREIwf
	 MEii5p7e+80hLFAH2VV9YLf6QYX/jwjmsdl1T4oe3JW0XDpU4zu+2kLuPFc7UwgGIda78
	 GYkcNKmt1zRXsbzq04R3Wjfssb/bdx7F8WCyIs9fath5cSQRMaOB7MKNFkwYvIplLteXO
	 ikWAdRr2c2JKY46UR68QGyUgih3f4TSi/TUVPsGmrfFTx/DLxk5ORlXyg11hpuY6y6ZAX
	 SkJgPsQhopOYSiV+behQkgf+oQIiep7herRPv039WHIMvo/NpzlQr1QJc/5tEyZK3IQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795404681;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=n3/QgCFjzvK6G73Tiampz5hPbLES3QQEgOsn43qeBn8=;
	b=IGlGrqBeuqZFzjR/9u0L0zutr+drgkBF65CPMvWrSUIk26mKvwNF6laOQ+Z4aFWqSPPU
	 zv0DkXGymOyWMrFkNXvarJRpIH5XoeP1/L7/jH6U67nk8zb9N/jK0wUP4KJQkYP4ZpTyp
	 h2/xaElHAQso11e96l9Q4YWFXPawdEKI6+3tYe0E1Azp1JgvjKzw3SbMQa9s4EEpSnDlq
	 YFSOwbbr/33kkyfMfIcGMrzugdNoh2m7jA8MWEOM4vLgxwARiNbXnLjiaJ/GW6wfchV8A
	 zeWos5/iIR7wE+QKbFdJ16ycbcYWPGY53wlYMqiaubgOkGQOtR5sVVHnFD2Lm5WizBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chromium.org;
	spf=pass smtp.mailfrom=chromium.org;
	dkim=pass header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=Edl3tDou;
	arc=none smtp.remote-ip=209.85.210.170
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAD28606A327
	for <linux-rdma@vger.kernel.org>; Mon, 23 Nov 2026 03:31:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EAD28606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=Edl3tDou
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-89a837bf00eso62090b3a.2
        for <linux-rdma@vger.kernel.org>; Sun, 22 Nov 2026 19:31:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1795404680; x=1796009480; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=n3/QgCFjzvK6G73Tiampz5hPbLES3QQEgOsn43qeBn8=;
        b=Edl3tDoudDKu8O2PRwvYnO8MJvLjWtgoT26qqZAO1ooxzE3Tz8K2jSrkMRJ74CY71T
         gmeUGNF0Du2akiiBchns1KHvONx24mVE1qX81TBQ16SMRNqU5PNNIc/hqFlKoySErJOB
         LBybGaxPrLQI6vmhdHWQGORNw914goHqfldQc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795404680; x=1796009480;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=n3/QgCFjzvK6G73Tiampz5hPbLES3QQEgOsn43qeBn8=;
        b=U9umNKE2pKBCpcqTkVsPa+U9ou3vs0Ixk3vdGrdcpsL/xzZUbBtx2UaNkdEHEoRzas
         xvffOqLKPasdifA8BE7ENOKpDYDDiYMEnEg/hNKU6MPsnx79+54Ta5IjoBac+UCAfP8u
         GJQwQTmCcBm8ABbcZ397SRhOBtRdwga6lbqKNSerYgveeu0jlHqFYDiCd+wqnH+OcV86
         5XpGwvXLPt8JZgDu0hfdHbi5mnTQuIDSVWU1lltypv6FXHMr17vUyjrux9MPvFXuWlAl
         C7SJcHs7iX/BpyIXRsLdh6OIEVZgwNZhL8rfrjsXHKTn462DLYVAm9rc6L3sGcAHIMct
         DCpQ==
X-Forwarded-Encrypted: i=1; AL+hErH96kzvrsso0AntiWfoaLcv2wbrk8ggn5pAEMM2mwinG9M65nqZQ9rGTsEAhGtSj+DWJFVo0dkbmsX2@vger.kernel.org
X-Gm-Message-State: APuU4Z8HLwK2x3ALqZLg4511Q2JIkVoBQgjPEYLR9sQVrCbnF+pWFQgS
	1K4fV4jtU6wgSKP2u+sOhOtu9POam04aZy/uDIXFLr8b4C93FG81EotoP3A4LuK+Vg==
X-Gm-Gg: AZFdTZfj18o34TRaLeuCDzBsvz+qgmnKe9/qVSDLylUY77wKoADSnBrnTsAZa4gmyVE
	5gs/wBCbWPO8+HMxoBX8aT6VBXwoE5Y0sxgXqb1BVKWapc9cms2yxVIAjSKoG/5kATKO/bbtDpi
	ZCFu3ImrJifP2xJziY/w2Tvo5ePcmcvE8M1V1+hixr+NzswB8dtvlH2N1oji78qQUly4udeFWss
	/+4nTcLNxh02byRdUGnmlQfQck2vY7Sp2b6r40tMUMPKQ4w6wMWsSgQpXZ3Xnrg7AKez6vpIFYH
	aHyvuwT92izfsKwsRr2LplxyCbB37AHU2F4MqxwKBjtR4pG24nP65OI0QBPFwAydHSUMAomALVP
	3N8qguet095nUoD2vKo2Y7kmkTenbwwuoez41vmVGwi+Vgr122NLXqF634GWQiI3fejkvMhiuMP
	ag/Gxr258eRiZMVLMvkA4h7buk/8cYK8JN9hw1YCYwFojaxh9+rilntN6kONJ4VCkXxCpq9VPcR
	wOi/Rn6XMYl/ZhYBRp7Obhb1xQdG5Tk7K2LAJ3vv5GpW5NLgqbWrb5bruXTH7ggjLF361/nBEoa
	jGE7F4nny/hA96rHO7bzr0dVNmngSJtxSIvU4biK3EAH/MiOP4hXYgRDEjyqmfwVKvV1ig==
X-Received: by 2002:a05:6a00:c1ca:20b0:8b0:4ee8:10b7 with SMTP id d2e1a72fcca58-8c8792b617bmr11211724b3a.1.1795404680238;
        Sun, 22 Nov 2026 19:31:20 -0800 (PST)
Received: from localhost (221.247.125.34.bc.googleusercontent.com. [34.125.247.221])
        by smtp.gmail.com with UTF8SMTPSA id d2e1a72fcca58-8c87285c14fsm4712022b3a.15.2026.11.22.19.31.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Nov 2026 19:31:19 -0800 (PST)
From: Jeff Xu <jeffxu@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Jeff Xu <jeffxu@chromium.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
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
Subject: [PATCH v2 0/2] mm: kasan: skip KASAN for GFP_HIGHUSER
Date: Sun, 22 Nov 2026 19:31:09 -0800
Message-ID: <20261123033111.2349160-1-jeffxu@chromium.org>
X-Mailer: git-send-email 2.56.1.750.gf70dc682cf-goog
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

This series moves __GFP_SKIP_KASAN from GFP_HIGHUSER_MOVABLE to
GFP_HIGHUSER (patch 1) and adds a KUnit test for __GFP_SKIP_KASAN
(patch 2).

GFP_HIGHUSER_MOVABLE already skips KASAN tagging under
CONFIG_KASAN_HW_TAGS, whereas GFP_HIGHUSER does not despite sharing the
same userspace-allocation contract. On an Armv9.2-A device (6.12 kernel,
kasan.mode=sync), skipping KASAN on GFP_HIGHUSER cuts 32 MB
/dev/dma_heap/system alloc+free latency by ~80% and improves an
app-loading OpenGL benchmark by 15-23%. As a side effect, GFP_HIGHUSER
shmem mappings (such as drm_gem_shmem_helper / panthor [1, 2]) stop
hitting the swap-in readahead PROT_MTE tag mismatch, though the general
readahead issue for other gfp masks remains separate.

Changes since v1 [3]:
- Dropped GFP_HIGHUSER_KASAN, the pipe/FUSE/kexec/RDS conversions, and
  page_alloc_highuser_kasan (v1 patches 1-4 and 7) following David
  Hildenbrand's and Tomasz Figa's feedback; kept those callers on
  GFP_HIGHUSER (2 patches instead of 7).
- Rewrote patch 1's commit message concisely (Lorenzo Stoakes).
- Dropped Assisted-by: trailers from the patches, keeping tool
  disclosure here (Lorenzo Stoakes).
- Rebased onto mm-unstable (d12eccbcb79a).
- Kept the fs/kexec/RDS maintainers from v1 on Cc for visibility since
  those patches were dropped.

Testing: built and booted both commits on arm64 with
CONFIG_KASAN_HW_TAGS under QEMU (virt,mte=on) across kasan.mode=sync,
async, and asymm (9/9 runs passed for page_alloc_skip_kasan; 3/3 failed
as expected when patch 1 was reverted, with the next test still
passing). Verified W=1 builds with 0 warnings across arm64 (HW_TAGS,
generic, SW_TAGS, no KASAN) and x86_64 (generic, no KASAN). KUnit tests
were not run on real hardware.

Tooling: an AI coding assistant was used under the author's direction to
audit GFP_HIGHUSER callers, draft the KUnit test helper and changelog
revisions, and run the QEMU/KUnit build and test matrix.

Link: https://lore.kernel.org/r/20260519-panthor-kasan-v2-1-b7384458f076@gmail.com/ [1]
Link: https://lore.kernel.org/r/20260521105148.5497c281@fedora/ [2]
Link: https://lore.kernel.org/all/20261116230627.3537051-1-jeffxu@chromium.org/ [3]

Jeff Xu (2):
  mm: kasan: skip KASAN for GFP_HIGHUSER
  mm/kasan/kunit: add page_alloc_skip_kasan test

 include/linux/gfp_types.h |  4 ++--
 mm/kasan/kasan_test_c.c   | 44 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 46 insertions(+), 2 deletions(-)

base-commit: d12eccbcb79a4fa35c3aa588eb79056af62eb859
-- 
2.56.1.750.gf70dc682cf-goog

Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71FAE389107
	for <linux-rdma@vger.kernel.org>; Tue,  1 Sep 2026 22:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788302336; cv=none; b=Tb+y4Wmwqm8NpL/S6EmL8vmQjjHl09RG1R+uGtES3LrMIBU21BaroOaNXDRYxgvTN62ncjnz6hloXGJg15JVLsgkh+Zc6AjLSNgdXwrRA6iWfYdBSL3yquIX8fmrZCd2LNoFIymUsMzuibjXv+0GoKHEnHYgwVg57Cz3hi+HQ9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788302336; c=relaxed/simple;
	bh=j9UQvDhnTz8iWLmNRuA0DNH2ohcjBp5KDNWd4xaepTk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mjmtLTLFNXYuHmMEIQm3zzsEWeH1HtSoET+ZNsLxXrubsiHdJ62ubto82yYXoI0KAx8/vCYzvuiFxjMkoffxibJ3t17cooF/NdArYZxRgGOd9bfctvARyH+El1sTkn+fzpgx//AaZihORCZrgJ5w+dmVPftXBq+5COnFgjXiKfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=pass smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=Edw8m4fG; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="Edw8m4fG"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-8485ab7c382so52133b3a.1
        for <linux-rdma@vger.kernel.org>; Tue, 01 Sep 2026 15:38:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1788302334; x=1788907134; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xZmM4o6AtfOjzX+lBw9oMlu0125coIi3sG1O5FhkJfs=;
        b=Edw8m4fG5qQfyrjoJMzGlj6O9Ua8KcqvaH1S3y/1D4YvNdQLM+RhOy6gd/6MMGQm+V
         RymL+gsqeJ7GdgSEHkplICxrK1+PG40UXkSZjYuKxbrHZSAdhkBLbPsC8Bj1dWCR2fuF
         v4kCJ/jhfVGqUJruZZc3K2AklQIsk6eNthSnHK5zVHJdvGC9BgCthCDKxvw+zjin5EmR
         /KsPVyW6y+KfrceoJh91VX/Pr0LKE2yqm36YZQaGlO0ZIbTmXLaDCQcqfndwUCGFc5VQ
         Ld1lpzv34Yat96DXwjg4mbvO2d2Qz1T19l74DKL/+z67cF4gqet8wAZn/F903s/p1Hc+
         wTAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788302334; x=1788907134;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xZmM4o6AtfOjzX+lBw9oMlu0125coIi3sG1O5FhkJfs=;
        b=geMs+8w4DHsr47rgUeH+nmSGrk2bWb9j2x7DNI0WouGQnJ6Y4TBA5SSa0dkFKXgDc5
         tLPZArMyy4u0eO9bD5WsSuKfFY6l6nbBAH0YSOV4Ra/NvsnnNG5zG8MDfyKkbgaGDBwy
         IR70+AbL3NWq4K2TjHdrIEdepYg07nCWDs6a4i7r8LND+/Tb7x/gppALETJ+l7eKGwfH
         +eOJeq333eBJ55fhJl3uc0PsBrGm5f8Mkq8aAJYOTXR6zXSHJ68OXhON0ZTxvGWVLBXL
         Enbu218vR1cwFIPLNtl9/wU2q1Hx26zHE0l53ouM1GhwHmWtHRl06PU9HkOOAw5Sackw
         tnnQ==
X-Forwarded-Encrypted: i=1; AKwUvByvZ5cOnWjfKlEp7hu9LV9KPGPxthWLbNnr+t34GXooleLaURTYOwgQOwcEWvmwgeERsXpn1/K/tqBi@vger.kernel.org
X-Gm-Message-State: AFuF++kvDJnml5d9Ee3PVOkyQgHjX7me01nHDhhkOPdWH+/0cIcPlUZb
	ke//QAKFTqhtN2IMPxmJD8S1gdmhC9G2Z6MhRXl3dgqqoR4iRW0z1ErvJIwrWaaZrls=
X-Gm-Gg: AYBFou1kkJH9R0kkUcBrxkXLKp4T+od11a4Ix6zfZyT3eFIH41TGCUc0egwX7xla6y6
	o3JDacvPA17x5zH4FLxS1vWlNP5rAAQueZJ1Uiz8BYiH8L/iiJ+C2xpeYFmjp4ttuNx2Et7ll+l
	JJYxdWS95VtmViSSGEWDW9e4ARu777ew3ZDSQ3ISEvLXCsskjP6PB56j2RG5SU9omLVq5MBcm7w
	N64FiK3UkN042XSLuEwexqEBe9S0Gq/cP5XiXF/14ueTtyufyS4PBZjf1IaoHFUEn6gajiqMlUH
	C3e7aKfDed4MUDmr+C3Gh1xTQ2YL+B3jiNhGDOS5Jd1jq8siO+IDznqm6r1mr6MKzpfS1GxR7mx
	EH9SetdVYAyzvcc8flnUi+gJkILVh2fGYREcqlZDzlX21INECJLgc3sGEA1jp0OlaMeonIIF57p
	yAmhFecbifxqq+i7YrCUCALOfhg6pKuNRhgMeYqYJWhcue3uNvEFDGYX/NFi/8ctlJD1QuYML2k
	mNvlqGd5bUbRpuN
X-Received: by 2002:a17:90b:4b8b:b0:38e:76f8:fcbb with SMTP id 98e67ed59e1d1-39aee1c6d08mr164366a91.4.1788302333643;
        Tue, 01 Sep 2026 15:38:53 -0700 (PDT)
Received: from dev-cachen2.dev.purestorage.com ([208.88.159.129])
        by smtp.googlemail.com with ESMTPSA id 5a478bee46e88-32f07baa594sm1453891eec.22.2026.09.01.15.38.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 15:38:53 -0700 (PDT)
From: Casey Chen <cachen@purestorage.com>
To: linux-nvme@lists.infradead.org
Cc: leon@kernel.org,
	sagi@grimberg.me,
	kbusch@kernel.org,
	hch@lst.de,
	axboe@kernel.dk,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] nvme-rdma: fix ib_device removal race that hangs PCI unbind
Date: Tue,  1 Sep 2026 16:38:09 -0600
Message-Id: <20260901223809.2346699-1-cachen@purestorage.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260831221355.1715088-1-cachen@purestorage.com>
References: <20260828232436.270184-1-cachen@purestorage.com> <20260831221355.1715088-1-cachen@purestorage.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On 31/08/2026 16:13, Casey Chen wrote:
> The ->add path is new in this version and has not run on the setup that
> reproduced the hang, so this wants a fresh soak before it is applied.

That soak is done now, so the caveat above no longer applies.

The test bounces both mlx5 interfaces carrying the NVMe-oF RDMA
connections, one at a time, with IO running throughout and a userspace
daemon reconnecting the controllers:

  ethtool -i <iface> | grep bus-info
  echo 1 | sudo tee /sys/bus/pci/devices/<bdf>/remove
  sleep 30
  echo 1 | sudo tee /sys/bus/pci/rescan
  sleep 30

30 iterations over the two interfaces, so 60 remove/rescan cycles, with
60s of settle time between iterations - roughly 90 minutes.

No hang with v3 applied. Every write to remove returned, the interface
came back on the following rescan and the controllers reconnected. The
->add path is covered by this, since each rescan re-probes the HCA as a
new ib_device and so goes through nvme_rdma_add_one().

For contrast, on the same setup without the fix the write to remove
eventually never returns and the task is left in D state with the trace
in the commit message. It is intermittent - most removals complete
normally, and only one that lands while a connect is in flight strands a
controller.

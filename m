Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C85054A35;
	Thu, 30 Apr 2026 04:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777521685; cv=none; b=hlOvBnzelqpRqulmFsasvKEmX9BQK0MGgAkLv8KnCa90b47JajSfqTymzmaap0JQlcrrn1AqB04XVJMvJynvwv/Fn77JQqh9auYQ9x9Lo/W2kewVvBmXyDa5VaGvpNYRLpG5JEJBgywvoeu5fq30JjLaeh6esjsrfFiRWans9ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777521685; c=relaxed/simple;
	bh=8oxP5EqKXJYQuAtM9mvq5dYKEkKBVCKuUMutgRZC1mM=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Jg75/PtL9Qx4KIu+nIgESFm3mf6ip/Y67xLpnUKfWT4/J2MlW3EkyX6RCk/obIpSqwIzenSWUUIsXfwc+p3830KYOw6PjBGF/uooDDCZC/3bfv9laeRA2lrwQ+S607R/kVCA9O7CvCeM6WDoJUc5y4LW+C6wY2CIZljNX4p81yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=lcKZKe1r; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="lcKZKe1r"
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (linux.microsoft.com [13.77.154.182])
	by linux.microsoft.com (Postfix) with ESMTPSA id 99BFF20B716C;
	Wed, 29 Apr 2026 21:01:23 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 99BFF20B716C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1777521683;
	bh=KRsW0ZE1gsdLQcEsyxF+0Whp9BSulyxr8i92HJWzBww=;
	h=From:To:Subject:Date:From;
	b=lcKZKe1r7ErSAkUflJjK5oHZi6OGOoIvW/jqQzamDGsZ6c99zUHQ7xQEkFJNQ6mic
	 bywkglQWfbbVyV5Y7BsHoyEr2TS0jqG5z+ILeRbDNUGunxjGQBKozRXfgR8KfuCIlQ
	 +7nmxGgIdkn7TaPE3ld/5HrcVzl6Y18Z7QTwYGjk=
From: Dipayaan Roy <dipayanroy@linux.microsoft.com>
To: kys@microsoft.com,
	haiyangz@microsoft.com,
	wei.liu@kernel.org,
	decui@microsoft.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	leon@kernel.org,
	longli@microsoft.com,
	kotaranov@microsoft.com,
	horms@kernel.org,
	shradhagupta@linux.microsoft.com,
	ssengar@linux.microsoft.com,
	ernis@linux.microsoft.com,
	shirazsaleem@microsoft.com,
	linux-hyperv@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	stephen@networkplumber.org,
	jacob.e.keller@intel.com,
	dipayanroy@microsoft.com,
	leitao@debian.org,
	kees@kernel.org,
	john.fastabend@gmail.com,
	hawk@kernel.org,
	bpf@vger.kernel.org,
	daniel@iogearbox.net,
	ast@kernel.org,
	sdf@fomichev.me,
	yury.norov@gmail.com
Subject: [PATCH 0/3] net: mana: Fix mana_destroy_rxq() cleanup for partial RXQ init
Date: Wed, 29 Apr 2026 20:57:51 -0700
Message-ID: <20260430035935.1859220-1-dipayanroy@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

When mana_create_rxq() fails partway through initialization (e.g. the
hardware rejects the WQ object creation), the error path calls
mana_destroy_rxq() to tear down a partially-initialized RXQ.
This exposed multiple issues in mana_destroy_rxq() path, as it assumed
the RXQ was always fully initialized, leading to multiple issues:

1. xdp_rxq_info_unreg() was called on an unregistered xdp_rxq,
   triggering a WARN_ON ("Driver BUG") in net/core/xdp.c.

2. mana_destroy_wq_obj() was called with INVALID_MANA_HANDLE,
   sending a bogus destroy command to the hardware.

3. mana_deinit_cq() was called twice — once inside mana_destroy_rxq()
   and again in mana_create_rxq()'s error path — causing a
   use-after-free since mana_destroy_rxq() frees the rxq first.

This was observed during ethtool ring parameter changes when the
hardware returned an error creating the RXQ. This series makes
mana_destroy_rxq() safe to call at any stage of RXQ initialization
by guarding each teardown step, and removes the redundant cleanup
in mana_create_rxq().

Dipayaan Roy (3):
  net: mana: check xdp_rxq registration before unreg in
    mana_destroy_rxq()
  net: mana: Skip WQ object destruction for uninitialized RXQ
  net: mana: remove double CQ cleanup in mana_create_rxq error path

 drivers/net/ethernet/microsoft/mana/mana_en.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

-- 
2.43.0


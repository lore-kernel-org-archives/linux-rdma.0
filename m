Received: from alln-iport-8.cisco.com (alln-iport-8.cisco.com [173.37.142.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C97D43846C;
	Mon, 24 Aug 2026 14:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.142.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787580596; cv=none; b=LeIG2vyPku8CwZhd/gfvaYR2qpq9J41LicG9SN8skJAlfVr9sLsnVUD1JMbUOH/Sva00kJQmUwnF9mcRu0zDG3JUk3xWQ2xGkJFnRP8WKp7nkZe1g6ALkoZiMFwLFrS20bOj4rIPo54ul4RgeIWYhmnVej5LdpzujVf76a+oVX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787580596; c=relaxed/simple;
	bh=EWk4hyPG7+FOgPwNlMRsuGfg5oxxmX/Xb9vd6xeiMSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HgGx+ysnGMuy/rgvRRRoAxgm6C3Mzyakr1J5LXGVZb6K7o9wm0PdPztz/4rNXKrzRvqzI+cHKT2WAP9wqDHDBelIfhrwNsHrga+inkgxZtAD2cdiw+aKnkSPnivV3LK+vuIHkSyiDNmMwwp1tyh80T11UEn3CISxxTMhHgHHztA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=CTvRWbFI; arc=none smtp.client-ip=173.37.142.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="CTvRWbFI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=771; q=dns/txt;
  s=iport01; t=1787580594; x=1788790194;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EWk4hyPG7+FOgPwNlMRsuGfg5oxxmX/Xb9vd6xeiMSk=;
  b=CTvRWbFIGaubNPrCVLp+cFTlhsnlT0Zv7Mk+e5t/pCmswJgSPuMZvTnc
   ZunkFzYtb08fkinKPCLjusz/UmgLCpiyLpGfujlyxEbxuRhGQcV4ZFvnc
   RDuNkleDTadoJqIsO1YCDi4bEmJKs6fBdE6US5fOhRBAB9avSEAC5VL9D
   OALOuQ4K1L7o1RyXXT4tiGfKTnTiXP/E008tgZbRNH7evlqU8xkVjsj0x
   Zt5XIFs5EVrf+3UoUxzAKwPiBs02TjJJl7On3cT/K6Tu0Dwg7R0GXxnnq
   2+wa98qORkhSbXZeq+djCPPO1dwdHXzFjbEX+SrSUr0oAf21AYGuwDpq3
   A==;
X-CSE-ConnectionGUID: Ch0jTdYOQZmVofPRK3MPUg==
X-CSE-MsgGUID: Dj2cqU4SQLGstu02LBJnEQ==
X-IPAS-Result: =?us-ascii?q?A0BnBAA1T4xq/4sQJK1aglmEKUOUcoIhnh6Bfg8BAQEPU?=
 =?us-ascii?q?QQBAYUFAo1sAiY2Bw4BAgQDAgMBAQEBAQEBAQEBAQsBAQUBAQECAQcFgQ4Th?=
 =?us-ascii?q?lyGWwIBAzIBRhALDjhWBoMVgnUDvnaCLIEB3keBchWBOI1hdhuEYScbgUlEh?=
 =?us-ascii?q?A8xPosIBIIigQyTVUgKgRQDWSwBVRMNCgsHBYEjQwM1EioVIw88BS0dgSMhH?=
 =?us-ascii?q?RcXdhsGBRIgKkFEFQ4DPoEZQQKBdT8jGTZ8gQlegSspYAECEBdGLhWCBwKCW?=
 =?us-ascii?q?oEnXgIBSUMOB0ciCxgNSBEsNxQZBD5uB5FBBgExSlaBAStvllywI4QooVwaM?=
 =?us-ascii?q?5dfkw2ZCKlDgW4BNYFZMxoIGxWDI1IZD45fz19FbwEBBwIHDgMLgWiRfgEB?=
IronPort-Data: A9a23:W4a3yaNwgCZaqh7vrR1vl8FynXyQoLVcMsEvi/4bfWQNrUoqgzZVy
 zdOD2GGa/ffYWqgf493bY63ph9Q7JCHz9JkSXM5pCpnJ55oRWUpJjg4wmPYZX76whjrFRo/h
 ykmQoCeaphyFTmE+kvF3oHJ9RFUzbuPSqf3FNnKMyVwQR4MYCo6gHqPocZh6mJTqYb/WV7lV
 e/a+ZWFZgf1gWIsawr41orawP9RlKWq0N8nlgRWicBj5Df2i3QTBZQDEqC9R1OQapVUBOOzW
 9HYx7i/+G7Dlz91Yj9yuu+mGqGiaue60Tmm0hK6aYD76vRxjnBaPpIACRYpQRw/ZwNlMDxG4
 I4lWZSYEW/FN0BX8QgXe0Ew/ypWZcWq9FJbSJSymZT78qHIT5fj695uVEMKMbw/w9RyP2ZAz
 cY7cxU1Ux/W0opawJrjIgVtrs0nKM+uOMYUvWttiGmDS/0nWpvEBa7N4Le03h9p2ZsIRqiYP
 pRfMGE+BPjDS0Un1lM/Co45mOOlmlH0ciZTrxSeoq9fD237nFUhj+C9boeIEjCMbelXxE2Bm
 z79xkDWGQ0HbIa74xiD30v504cjmgu+Aur+DoaQ+vd0jVi7ymUNBRgSUlWn5/+0liaWQN5RA
 0IT/yslraUsskmmJvH/WB2+5nCNpQIVUddWH8U17QiMzuzf5APxLmUIUztIetE6nMAxQjMu2
 xmCmNaBLTBmtryYTVqc8biZpCm4PjhTK2IeDQcNVhct4NT5pow3yBXVQb5LEKeqjfX2FCv2z
 jTMqzIx750QkMQC/6a251bKh3SrvJehZgcz6h/aQSGj4x91aZCNY5Gu7x7Q7Z5oIJqQUkSFs
 XEsndaf4OEHS5qKkUSlROgKGquuz/CbMTHdiBhkGJxJ3zGn/3mofahW/jByJU4vOcEBERfya
 ULetQZ54oFSMHqjK6RwZuqZF80wzLH8PdL7V/zVZ5xFZZ0ZXBeO9ixoZGaK0mztmVRqmqY6U
 b+RaciEE3kXE+JkwSCwSuNb1qUkrgg6xGXOVdX4wg6h3L62enGYU/EGPUGIY+R/67mLyC3R8
 tBCJ46QxxBWePPxbzOR8oMJK10Oa38hCvjercFLeuOdChRpFXtnCPLLx74lPYt/kMx9jfvB9
 HWwclFXxUC5hnDdLwiOLHd5Z9vSsY1XpHY/O2koeF2vwXVmOdzp56YEfJxxdr4inAB+8cNJo
 zA+U53oKpxypv7volzxsbGVQFReSSmW
IronPort-HdrOrdr: A9a23:7hitjKumPSL4Rgy0f8kWD2rZ7skDVtV00zEX/kB9WHVpmwKj+/
 xG+85rsSMc5wx+ZJhNo7q90ey7MBDhHP1OkOws1NWZPTUO0VHAROpfBMnZsl/d8kbFmdK1u5
 0MT0EHMr3NJGk/q9rm6w+lFNtl6tyG/Ke0wdr69R5WPGZXg2UK1XYBNu5deXcGIjV7OQ==
X-Talos-CUID: =?us-ascii?q?9a23=3Azh53mmiI/0HrjrqmMJZp2NW90zJuWX2FzkvcEmi?=
 =?us-ascii?q?BO2NXT7Otc3zL3ZtZnJ87?=
X-Talos-MUID: =?us-ascii?q?9a23=3AaPAE6g2mWk1KVrU7mZaQmuEiaTUjz6b0A1kwza4?=
 =?us-ascii?q?/n+afKTEoYRO3rjKae9py?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.25,240,1779148800"; 
   d="scan'208";a="818708655"
Received: from alln-l-core-02.cisco.com ([173.36.16.139])
  by alln-iport-8.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 24 Aug 2026 14:09:46 +0000
Received: from localhost (unknown [10.228.224.45])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by alln-l-core-02.cisco.com (Postfix) with ESMTPS id B3FF51800015B;
	Mon, 24 Aug 2026 14:09:45 +0000 (GMT)
From: Jerome Tollet <jtollet@cisco.com>
To: Dragos Tatulea <dtatulea@nvidia.com>
Cc: Jerome Tollet <jtollet@cisco.com>,
	netdev@vger.kernel.org,
	saeedm@nvidia.com,
	tariqt@nvidia.com,
	mbloch@nvidia.com,
	leonro@nvidia.com,
	daniel@iogearbox.net,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	ast@kernel.org,
	hawk@kernel.org,
	john.fastabend@gmail.com,
	sdf@fomichev.me,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH net v3 2/2] net/mlx5e: Prevent stale XSK buffer release on MPWQE refill retry
Date: Mon, 24 Aug 2026 16:09:43 +0200
Message-ID: <20260824140943.20665-1-jtollet@cisco.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <b4abc8e4-aa9e-4e92-97b8-c6a661014c16@nvidia.com>
References: <20260820151558.11015-1-jtollet@cisco.com> <cover.1787347981.git.jtollet@cisco.com> <675ce8a404cfe305e788a8e273b4091c9a90f867.1787347981.git.jtollet@cisco.com> <b4abc8e4-aa9e-4e92-97b8-c6a661014c16@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Outbound-Client-TLS: ANONYMOUS;unknown [10.228.224.45];TLSv1.3;TLS_AES_256_GCM_SHA384;256
X-Outbound-SMTP-Client: 10.228.224.45, [10.228.224.45]
X-Outbound-Node: alln-l-core-02.cisco.com

Hi Dragos,

Agreed, thanks. I changed the patch to set all skip_release_bitmap bits in
the common error path of mlx5e_xsk_alloc_rx_mpwqe(), consistently with
mlx5e_alloc_rx_mpwqe().

I tested both early and partial allocation failures. With three consecutive
failures on the same MPWQE, the original 16 XSK buffers were released only
once. Retries observed a full bitmap, and a later successful allocation
cleared it. The partial case allocated 8 of 16 replacement buffers before
unwinding.

I also ran a 20-second AF_XDP zero-copy striding-RQ pressure test with the
clean patch. It exercised 1,575,262 XSK buffer allocation failures and
reported no invalid descriptors, WQE errors, or kernel warnings.

I'll send v4 with this change.

Thanks,
Jerome

Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=111.22.67.137
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795168426;
	b=js/tstw71kj+BUej25bQ1+RoidR0L/KxBZi7bvLEQ3WQxpd+QpFzPG/zxNTpBkHH13E4
	 JalKCw3N8LY5vcPs6UYwN9GXQqdPO6lW8sAnWBrRBv7DXtys7CrzZmh+YgBFrzO16etM3
	 nk4/nAD3FiDLT8uZZyLUjtRjAcfDorlSV/KMt/IL4ceaFvUVgg9lfjK8IHaSA/1EusFwn
	 A4jAIsIFV63+thtcdVm8muCbr5CAxxT1QYIy+qX0y75mHnsRC00sMd2G6gI5io1ujW6WN
	 ok8hbd3cPnA/1JPSLnNEElM9n7TuOt4ShZ50scbzOl8c/v5QcKflF5urXz3U91m41/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795168426;
	h=DMARC-Filter:DKIM-Signature:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:
	 X-RM-TRANSID:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:X-RM-TRANSID:From:
	 To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5ofwWF4BbSu2ZoIqY2hK6IvWa8riDyXLn0Lwxc6gChk=;
	b=Ku/yX7m3SAwf2F+9HW6Nv9N7UN2widcFbl+/IVhA5tDMpEy6+ZVqSz2fp/5n4ihep0IK
	 fOo3AMCIqTyZBh/vZy6sy2OLh101LZa2NQOegP8IYCWgo6n9UlDG6DQSvjdAX67+L6n06
	 FfiHneCEM7fqiKUfOwOYWXhbBN7Piyh5f0Yu/r2nBDhxY1XPiKwGZCRKN7pQmSKlxUIPH
	 ijnfvLyq+Ib22AeRYjX1j4+P67EIb7VjfMSbWHwSFR1uxywGPiCYfHoLTbeTpkG5TkOsl
	 PQDWOKTrTilu92Gubs9/hJBzWs5dtgyuTKIFO002Pj4AOOacuHv9aumZKCWJSdnM81g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cmss.chinamobile.com;
	spf=pass smtp.mailfrom=cmss.chinamobile.com;
	dkim=pass header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=oNMk6ctz;
	arc=none smtp.remote-ip=111.22.67.137
Received: from cmccmta4.chinamobile.com (cmccmta4.chinamobile.com [111.22.67.137])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96993606A33B;
	Fri, 20 Nov 2026 09:53:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 96993606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=oNMk6ctz
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=cmss.chinamobile.com; s=default; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=oNMk6ctzGqaLhfVyU3qsOK6FrF65dzVgWFJQCXhhOaAe+ByUhLuZlCgZ548DMNcGeAR3oF+0sgboG
	 USb2XGDq0NvwlacFx92RLfh3cBW+pw84tkEdGpGm16pOfwYy/wHIRXY7Q/YZahnZvpMH8BpQKpADJF
	 hq0VyMFL+yLiNOeM=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app04-12004 (RichMail) with SMTP id 2ee46b0018a4ceb-c82a4;
	Fri, 20 Nov 2026 17:53:42 +0800 (CST)
X-RM-TRANSID:2ee46b0018a4ceb-c82a4
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from FHD-W7400297 (unknown[10.55.1.70])
	by rmsmtp-syy-appsvr10-12010 (RichMail) with SMTP id 2eea6b0018a444e-206a2;
	Fri, 20 Nov 2026 17:53:42 +0800 (CST)
X-RM-TRANSID:2eea6b0018a444e-206a2
From: Aibing Chen <chenaibing@cmss.chinamobile.com>
To: netdev-bot+sinfo@kernel.org
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net/mlx5: fix a stack over-read in the QP debugfs files
Date: Fri, 20 Nov 2026 17:53:40 +0800
Message-ID: <20261120095340.1564-1-chenaibing@cmss.chinamobile.com>
X-Mailer: git-send-email 2.50.1.windows.1
In-Reply-To: <179516120532.3291.16859269248680746966@kernel.org>
References: <179516120532.3291.16859269248680746966@kernel.org>
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

Hi,

How it was found: by code inspection, not from a report or a tool - while
looking at how the mlx5 debugfs field readers use the return value of
snprintf().

Was it triggered: no, I did not reproduce it at runtime.  It is statically
decidable from the code: snprintf() returns the length the output would
have had (23 for "Invalid transport type" plus the newline) instead of the
number of bytes written (18), and simple_read_from_buffer() uses that
value to bound the copy to userspace.  It is only reachable when the
device reports a QP transport value that mlx5_qp_type_str() does not name.

Hardware: not tested on real hardware, I do not have mlx5 hardware
available.  The change only uses scnprintf() so that the length passed to
simple_read_from_buffer() can no longer exceed the buffer, and enlarges
the buffer so that the longest string still fits; neither needs device
specific behaviour.

Thanks,
Aibing Chen



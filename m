Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795791496;
	b=tVTsm7IwCQA8VRSp6sZjWv+Mye7C8WEXAApwtXBn3/Dz2qdE8Q0BfVJnab7XvH+1Go+D
	 uGQMtEoA9gQrEjwMj2hzRUaeY3VINA9rPPKp94oKKDRwnneqyd17c36fIGpDdDOv65Xyj
	 0ay7U6zf4BiIspRQLFWqlhyexy/HZUJHyG3mhwK0LX7SX63HyFe9StJl6RtPZXazIKTYB
	 is7gQK+208Viy4c8bUSnw6RWcnEkBGMAdFvlTnkzzjWSZh3gOS0VE6YzqmnCKM9O9zN2W
	 dUN0HlYbq5XK18nSo0I1elbtWgeqhQWQCYpjtTjOu1OWAQ7k+LJm2Kmj1bjZf5i1r0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795791496;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=HjzSygG5VeMzHT2fHlftprZBgTk7aZFFgJu6JVXS3/c=;
	b=tgOhHqGJRXzWBmsK5iX9xUHUMAHjKFY95le9PA81AV4MC726VavMerhABYGHOke/PA/n
	 3QnspigImIyfSb3yvJjYULqUyJgLhOTa0BVNgIHZAFti/OTwF/NOml7I/xJ1Qsy7iyXxE
	 BYjVOEp3jBqXHgF7pg16TiKHmGtbWRe4G8Bh67Y1Q5+1pFwlQnV+KCakjI+ToSvzy6Ysn
	 LFlYn/LmBUp98ov72wgln+m1Lyof8YHipWpYB+HK9/bI5bPH56kCjFOry0b+VulZWETYM
	 sbY0XtJADFeql5M4wZGAf5D3/tlZH8ks4AFqKUa4OBst1XBDF3Hjloeb9DZqJLk7p1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CIe8ENQE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DAA2606A323
	for <linux-rdma@vger.kernel.org>; Fri, 27 Nov 2026 14:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CIe8ENQE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64BBF1F00897;
	Fri, 27 Nov 2026 14:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795791496;
	bh=HjzSygG5VeMzHT2fHlftprZBgTk7aZFFgJu6JVXS3/c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CIe8ENQEjioBT4YO8v3qIW0WDU+tP1nes5QCJ+Q3jWRLbDQgvZ+uK+caeUszM+9tg
	 4d1TLSj5tjV/fjidHuUGiZ/rNUZjYAe/ZeZDSI/q/TG5E2gFZ0eBf8W4+JtlPOWKfI
	 zEGIVbHnqYYvQf2IToLxS9YSI5v1dVYD4Sc/R9dwWP44d8jZW4QKxmdMWup7J8MJTH
	 URNuYztVy/d9MddY9TdZyYT5mAn8b1BTaC/VquDOH+j9IAEn5gamE5lGxLsb7WG2aP
	 rhiazEEoKj65YVqkjTZUhPfOg7J3Bp+pbjSteEiyuArOx/lne3IKdR7yt0lXSSVrfE
	 Bcuk3E8eNmOXg==
Message-ID: <sashiko-outbox-237645@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 00/11] net/xsc: add the Yunsilicon XSC ethernet
 driver
Reply-To: sashiko-reviews@lists.linux.dev
To: "Xin Tian" <tianx@yunsilicon.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261126145711.70868-1-tianx@yunsilicon.com>
References: <20261126145711.70868-1-tianx@yunsilicon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 27 Nov 2026 14:58:16 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Sashiko has finished reviewing this 11-patch series:

- Patches 1 and 2: no issues found.
- Patch 3 ("net/xsc: add the command queue"): 4 potential issues (1
  High, 3 Medium)
- Patch 4 ("net/xsc: query HCA capabilities and reset function"): 2
  potential issues (1 Medium, 1 Low)
- Patch 5 ("net/xsc: add event queues and MSI-X"): 1 potential issue (1
  High)
- Patch 6 ("net/xsc: add CQ and QP helpers"): 1 potential issue (1
  Medium)
- Patch 7 ("net/xsc: add the ethernet netdev"): 1 potential issue (1
  Medium)
- Patch 8 ("net/xsc: add the single TX/RX channel"): 5 potential issues
  (5 Medium)
- Patch 9 ("net/xsc: report link state changes"): 1 potential issue (1
  Medium)
- Patch 10 ("net/xsc: add the transmit path"): 4 potential issues (1
  High, 3 Medium)
- Patch 11 ("net/xsc: add the receive path"): 7 potential issues (2
  High, 5 Medium)

Detailed reviews have been sent as separate replies to patches 3-11.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261126145711.7086=
8-1-tianx@yunsilicon.com

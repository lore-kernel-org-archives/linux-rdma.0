Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795878316;
	b=iV3nNhlAcMnHlKd96NeyciPF3QG0AIPfgRDizRb+CxPzSWq2u8ZCuFo2LMOlcT+YbRl2
	 XLDd4Kl5fp6mArURMkx/jQrwcB2BfU8pWgD06fHDglvdbRLIJggQ7VBPjhXne8U81PztL
	 xuZra8Qm/TzwZilTe3CF27hAY4EEGdyXpWeEND25e9tXpFTmmCh4cKY/ZRLbDc2JF/1/E
	 nLZrjtt50hsF2knoh610ggOrV5KssEeKO5nmJ86qxUDJsw+PgFRPITdViUrAD6po/Z+s7
	 ETd/hYZc0i7pjWwts5zwVcUEQCf4G6agzutwGpCQKbUitOnnLenq7bjHSj6J2jNW9Xg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795878316;
	h=Received:DKIM-Signature:Received:From:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Endpoint-Received:X-Original-From:Reply-To;
	bh=GRllC+RerAm1g+uXYtJ60wWDU3aGjaypEV0zv3GXb5g=;
	b=lNcAhLkooxZ8FcIgYB3bAjNQqkaRyFuECamvNq59DAdw7KckstCoscoyGYO4LjNsuXBZ
	 Pg5XZWD9rji8OKWSeyvweV1ntiKy1ZV9vgpkFEmhwDGqApY7orezyOEfYix3vuXCikMvP
	 L+3X/rH4OnswC8Wj7MKWXrsHhW9aKoQh2GsQXW/yEKXCPFWudRE4GqYRHN8Ff5TnvfANX
	 oJc6mqEc3PoQor+VpuAcb9RHkgjJIg19ZCuEnc+KUVMKk8XZC0zKqgXnPWHkksAuRBE3f
	 aegvJty4TPPKmuxdlDs8boq5eYoeqTN0rI62uY7sJQjH+qclXZ/HVHG0ybn+Lem8Tzg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Baqs8TtN;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E01B0606A323;
	Sat, 28 Nov 2026 15:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Baqs8TtN
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795878314;
	b=uKzf2FYUAaQyIcESPEUZ54Wn20W42hcb0oXqArq61aoVuAQHPt9MH8OyAtnJos2Xv1ip
	 GQhUD9mzmlNqCqZE4sjZOxk4J81l8QAvcquwWiauRwBxTbCYEgOLdxr7HnzV1oirF97Ek
	 TX308TnMmw2BO7CY8gT6AldM8QvWuwxImOUydYo5jmVjh6kalYcNEtwO6bJ7wmtpQS0dO
	 ZhL4RvQjKzFRm9Q417a3GA7gXcvxYpPI66hmC5hkB1Bn/iGM1xNWkrVySCFm8HcW2cImr
	 OX4SlcaEMVLQi/U297hJRRh4hqqZS/IotaVjrThouUnPiURRJ5wBHEiqLIUIIm4EtRA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795878314;
	h=DKIM-Signature:Received:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:
	 Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=GRllC+RerAm1g+uXYtJ60wWDU3aGjaypEV0zv3GXb5g=;
	b=M6VI+R5f7GrZHk4om/2Mo+EkGtDD1+pUGvePL069G5YINhrOwwMWxshCgVcXArPa7/w0
	 ySx8Z0FLJni6WjY/v2FlqihACTludDRzx7quVyzxi3XzB3fbSmz5i8vkK+E4FrtwbV0Br
	 D5Qkq65DYdlqfFX47VBt8oT2rNy2/gpnMlxbsDbus74+f6nJRx+slRpPETdIctXZOyABp
	 tMtg2WBn/58225mgMGhe6n6MjY9PS8QKISZS1OxNvrkteA6YiSeATAO4U99zOpZgAwHSc
	 wyk6JYUCW+1x4x0iNcGgMIaqFFzsrIZGxxCVCFUiWS7nVKJBXkVF6ZfX9of5WRalgZg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 714A11F00897;
	Sat, 28 Nov 2026 15:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795878314;
	bh=GRllC+RerAm1g+uXYtJ60wWDU3aGjaypEV0zv3GXb5g=;
	h=From:Subject:Date:To:Cc:Reply-To;
	b=Baqs8TtNZThircDPZazZ0SF+NH3+7Jj53E7IG4jkVp4tY+Bt33g9Dqa59nmclUcio
	 IZiXUn/kwuJhgtB7Wwgqk925TMomLNP66BQ4PXo+JDKzYjzoWlzhBzkbbYydPXLFeE
	 CbUYmPCFNmSLZCvcVA5dhKkfF9uwPKOH7ifGLNfTlshVmjD0qNMcGi2akKErt/0hFG
	 bY2nZRr2Gj5kgrU7rlLxTIsJXCzJVB/9sjJTvmlm+LIUaplz7lPg+tXKrfvZ/1utg0
	 IF7ON5h4akGmv8H0ZAFQKNHFGt6NgpC23UBDgOz79wvdELQ3t/hBJXgWeRi0hW2tqr
	 f9TtKkLcxUrNw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id CB2654E11E;
	Sat, 28 Nov 2026 15:05:06 +0000 (UTC)
From: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Subject: [PATCH net v3 0/2] net/smc: do not reuse the DMB of a nocopy
 device
Date: Sat, 28 Nov 2026 10:05:06 -0500
Message-Id: <20261128-b4-disp-2c190c90-v3-0-c566f64196c8@proton.me>
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
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yWMzQrCMBAGX6Xs2YUklf74KuLBJF/a9RBLtopQ+
 u5Ge5yBmY0URaB0aTYqeIvKM1doTw2F+Z4nsMTK5IzrrHUD+zNH0YVdsKMJo+GYumSGCI++pZo
 tBUk+/+WVMla6HVJf/oGw/ma071+Q/8RqeQAAAA==
X-Change-ID: 20261128-b4-disp-2c190c90-df6f08debe73
To: Jakub Kicinski <kuba@kernel.org>, 
 "D. Wythe" <alibuda@linux.alibaba.com>, 
 Mahanta Jambigi <mjambigi@linux.ibm.com>, 
 "David S. Miller" <davem@davemloft.net>, 
 Sidraya Jayagond <sidraya@linux.ibm.com>, Paolo Abeni <pabeni@redhat.com>, 
 Eric Dumazet <edumazet@kernel.org>, 
 Alexandra Winter <wintera@linux.ibm.com>, 
 Dust Li <dust.li@linux.alibaba.com>
Cc: Hidayath Khan <hidayath@linux.ibm.com>, Simon Horman <horms@kernel.org>, 
 Julian Ruess <julianr@linux.ibm.com>, netdev@vger.kernel.org, 
 linux-s390@vger.kernel.org, Wenjia Zhang <wenjia@linux.ibm.com>, 
 linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Tony Lu <tonylu@linux.alibaba.com>, Wen Gu <guwen@linux.alibaba.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795878306; l=7563;
 i=hexlabsecurity@proton.me; s=default; h=from:subject:message-id;
 bh=6phDgKdsZJWLyUCE2IM60WLJ7U9pi5RkouSEBgDoK1I=;
 b=GzqYSNOeXR1M04c982tP1/WXTyu1rm/9QPJZy7cNp5AbxS5qqcvukhGVlNOzIpXHPrXt9K2pK
 P/y9S5uzIFjDWLe5oapPwRhycrEt7Wgq6hnTXDoYQrK3DBkrOR593kg
X-Developer-Key: i=hexlabsecurity@proton.me; a=ed25519;
 pk=xw1AhCtQdvuoQc+bOQIYy9o8G++cp4/VniI2G/tc3G8=
X-Endpoint-Received: by B4 Relay for hexlabsecurity@proton.me/default with
 auth_id=893
X-Original-From: Bryam Vargas <hexlabsecurity@proton.me>
Reply-To: hexlabsecurity@proton.me

With DMB nocopy (the dibs loopback device) a peer writes into the other
end's RMB through its own attachment. smc_buf_unuse() puts that DMB back
in the link group's pool with its token still registered, IOW the old
peer can still send its CDCs to it. The next connection that takes the
DMB gets those CDCs, and a peer that attaches after the other end gave
up lands in another connection's DMB. 2/2 stops pooling DMBs on nocopy
devices. This is the reused-DMB case that the v6 cover of the CDC
receive ordering series [1] lists as not fixed; Sashiko flagged it on
v5 2/2 [2].

2/2 depends on 1/2, a dibs loopback fix: when the owner unregisters a
DMB that a peer still holds, its dmb_clientid_arr[] entry is never
reset, and rmmod smc then warns in dibs_unregister_client() and leaves
smc registered as a dibs client. On net that needs a link group freed
while a peer still holds one of its DMBs; with 2/2 alone, each of the 20
connections of the rmmod test below left an entry set.

Tested in an x86 KVM guest on KASAN kernels, with net/smc and
drivers/dibs from the base below built as modules. The runs with the
series are v3 on v7.4-rc4; the retry after a terminate was also run on
that kernel with v1's 2/2 and with v2's 2/2. The other runs (net, 1/2
alone, 2/2 alone, 2/2 without the conn->rmb_desc clear where it frees
the DMB, the cost run) date from v1, on v7.4-rc2; v3's 2/2 is v1's plus
the clear in smc_conn_free() for a link group off its list. The modules
had test counters, and some tests set a test-only knob (a hold, a
shorter link group free delay, an injected failure or a forced
terminate), named below. Each test that fails without the series has a
control that passes on net and with the series, and each part of the
series has a test that fails without it. No KASAN report or WARN with
the series.

- A DMB reused while the old peer is still attached, 8 rounds: 4 with
  the new server end held before its attach by a knob, 4 with no knob,
  the new client's connect() at SCHED_IDLE on a busy CPU instead. On net
  the old peer's CDCs reach the new connection every time: it reads EOF
  while its own client is open, and its send space goes past its buffer
  size. With the series it gets a new DMB and token and sees none of
  them, and with 1/2 the old peer's CDCs raise no interrupt.
- Late attach, after an earlier connection set up the link groups: the
  client held 8 s by a knob after the CLC accept, past the server's 6 s
  wait for the confirm. On net it attaches to a DMB another connection
  already took, and after close() it stays orphaned in PEERCLOSEWAIT1,
  keeping smc in use. With the series the attach fails with -EINVAL and
  the client falls back to TCP.
- rmmod smc after 20 sequential connections, the 600 s link group free
  delay cut to 3 s by a knob: with 2/2 alone it warns, with 118 entries
  still set after the other tests of the same boot; with the series it
  unloads clean, and smc loads and connects again. On net, after the
  same tests, rmmod smc fails with "Module smc is in use" (the orphan
  above). In a separate boot, with the same knob, net warns too when a
  link group is freed while a peer still holds one of its DMBs; 1/2
  alone fixes that.
- 2/2 without the conn->rmb_desc clear where it frees the DMB: KASAN
  slab-use-after-free in smc_ism_unset_conn() when the client retries
  the handshake on the same socket. It took two injected failures, the
  CLC confirm send of the first attempt and the RMB allocation of the
  second. Clean with the series.
- The same retry with the first attempt's link group terminated by a
  knob before that attempt is aborted: smc_conn_free() then skips
  smc_buf_unuse(), and with v1's 2/2 the pointer stays set. KASAN
  slab-use-after-free, again in smc_ism_unset_conn(), then a GPF in
  smc_conn_free(), and close() hangs. Clean with v2 and v3.
- A connection closed while its link group is being terminated (a knob
  terminates the link group and holds its terminate work before the
  kill loop): its DMB is unregistered when the link group is freed, and
  rmmod smc is clean.
- 6000 connect/close cycles, more than the device's 5000 DMBs, with 120
  peers kept open and the same 3 s delay: one DMB per connection end, no
  fallback and no -ENOSPC.

Cost, one run of 2000 connect/echo/close cycles per RMB size on a KASAN
kernel, so relative only: 3.6% fewer cycles/s with 64 KiB RMBs (4251 to
4098), 2.9% fewer with 1 MiB (3328 to 3232); handshake median 107 to 113
us and 112 to 167 us; a 1 GiB stream with 64 KiB RMBs 4759 to 4750 MB/s.
Each connection end now registers its own DMB instead of taking a pooled
one. Not measured: under memory pressure that allocation can fail, and
the connection then gets a smaller DMB or falls back to TCP, as a first
connection does today.

With the series a loopback peer that is still attached is not told the
DMB is gone, as on net; its writes land in the old DMB, which nobody
reads and which is freed when that peer closes.

On net a client that retries the handshake on the same socket still has
conn->rmb_desc from its first attempt; v6 2/3 of [1] clears it at the
next registration. 2/2 clears conn->rmb_desc where it frees the DMB and
where smc_conn_free() finds the link group off its list, so a retry
after an attempt on a nocopy device does not depend on that patch. After
an attempt on a device without nocopy the pointer stays set, as on net.
The DMB of a connection freed with its link group off the list, and the
DMB of a connection the termination already killed, stay registered
until the link group is freed, as on net; no connection can take them.
A killed connection keeps the pointer, as on net; by inspection a
killed socket cannot start a new handshake.

Test patch and logs on request.

v3:
 - 2/2: when smc_conn_free() finds the link group off its list it only
   clears conn->rmb_desc and leaves the DMB to the link group's free;
   v2 unregistered it there, which Sidraya pointed out buys nothing [4].
   The commit message names the path that needs the pointer cleared.
 - 1/2: unchanged; Reviewed-by from Alexandra.
 - No ISM paragraph in the cover: the series does not touch ISM.
 - On net e9e45fcb6d39; net/smc and drivers/dibs have not changed since
   v2's base.
v2: https://lore.kernel.org/all/20261114-b4-disp-4e6374c2-v2-0-3b7050bddef7@proton.me/
 - 2/2: also unregister the DMB and clear conn->rmb_desc when
   smc_conn_free() finds the link group off its list and skips
   smc_buf_unuse(); v1 left the pointer set there, which Sashiko
   found [3].
v1: https://lore.kernel.org/all/20261113-b4-disp-19244662-v1-0-39b256b70ca7@proton.me/

[1] https://lore.kernel.org/all/20261112-b4-disp-1c8d3a53-v6-0-36a38ae35021@proton.me/
[2] https://lore.kernel.org/all/179241208501.3135.14193534440423847161@kernel.org/
[3] https://lore.kernel.org/all/sashiko-outbox-214598@kernel.org/
[4] https://lore.kernel.org/all/3b16c6c2-7bf1-4261-9c0c-abc56aa6d608@linux.ibm.com/

---
Bryam Vargas (2):
      dibs: loopback: reset the client id when the owner unregisters a DMB
      net/smc: do not reuse the DMB of a nocopy device

 drivers/dibs/dibs_loopback.c | 14 ++++++++------
 net/smc/smc_core.c           | 27 +++++++++++++++++++++++++--
 2 files changed, 33 insertions(+), 8 deletions(-)
---
base-commit: e9e45fcb6d39bee9325e6a7dca72bd14e82760f3
change-id: 20261128-b4-disp-2c190c90-df6f08debe73

Best regards,
--  
Bryam Vargas <hexlabsecurity@proton.me>



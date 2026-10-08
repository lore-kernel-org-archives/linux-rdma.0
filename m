Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7D7344AB73
	for <linux-rdma@vger.kernel.org>; Thu,  8 Oct 2026 21:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791493416; cv=none; b=P62XLT5ECvLObwhlSjmGl218vJRWFEio4yR+OCXi2gkYbKsNSDaFl5PyqT3KkskSmab4Y7NFRbgj0SUT7nE5Hmw3G/uDFKrbE/JrqYtJB/YlZZyj+Qv+dAuiElw9eQWLlEjXRr4M6fC3uNFiJQ9uoYGelEpG7kFzE6lX0gjaER0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791493416; c=relaxed/simple;
	bh=3f5WzTjnDsDOAnT0hR8gZXIWFT9KoT8c/AVMjDx6NOM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Ikfd3CM6716DBUzDDlUhegJ5kr0zfnhd8HE4sfGsVevT4EpxTikY4pxreT/h/Wb5eCmgPmkhfI9+E2f9tihY9OZi064QGxqrI+VNMz98UOjHlecdQZHpY1iBC0vvZ8gkCWdTrm09BYAYCsCoklTIvFsmoY/izAADuSeEc9YJRww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=pass smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda.com header.i=@toxicpanda.com header.b=q7pzm3nr; arc=none smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda.com header.i=@toxicpanda.com header.b="q7pzm3nr"
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-93cb1c0e851so263495085a.0
        for <linux-rdma@vger.kernel.org>; Thu, 08 Oct 2026 14:03:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1791493410; x=1792098210; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=blrnvRK83a0BrC00ZsKjSLnGbEsSK17m6K1yrBXm/SE=;
        b=q7pzm3nrFDtplCyFUQ2gMv1Uz59Vk3Up1x+wsTJP5aAGDqd4kqjwAGU2qebIPCtwEN
         PBRgOvLMPWJFn4NOV4DMZU3RWVV5R2hK/JKmk4ym6BrIZzZwpysiExnW3DiPDpnbzLzh
         7soCgzjgGz2WRekTxJNydvIyyes3/wBZID4pF0MZEMVVFJfX2ELHel8PVUUYDUCrfDOj
         jAWOabz9qAx/QGzQ1yXwMSI/GzjlFAtyDihsj/Yd21lkB688nZqzCe9Fp1PC+kxLHch2
         nif2IB7em0In6/IjmmOwd5Y7lMK5ZDUCW3oLVViyqKtW3AqsB3YhgZhotV0Y46e8SUhn
         8vLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791493410; x=1792098210;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=blrnvRK83a0BrC00ZsKjSLnGbEsSK17m6K1yrBXm/SE=;
        b=HjI8FuhV59Z+cpzp0ESJp+iL1yAoI4JqEtXpQavQvcqZiANTP+j4/44ZeQAglT1a+l
         KEc7Rd0eqT8iFgYc5gMrJ+R3fAPcS2A+FVEnKTjK5EyWHcJ6KGVMjowyG/+ysznyEaxu
         S9XAJKhJb2sRMHZBeJeKV7fvJIXLqiOx79sYRhoneeVHKlixbUxNr8RLsI2Itbe5hxP4
         +UF6WhpgSKdj1u/IhKpas9mCmpnoAxhDzLsqh3BX1ru9hsph4+GHlBQPg5C7FbRqWPE2
         FUicXo9Ve/3GcEbON0vNo3OO8ZDenBFflO79Msxi9BQvc8D90Tldsb9yy2FT1tm73KZR
         Fwhw==
X-Forwarded-Encrypted: i=1; AKwUvBwwukpHhvbU8HokERo/Lu6j0KUqo3howxVOxnB6x3BBdGEWckajOoMsXM0CtWXW7uoXEp+JruiutiRT@vger.kernel.org
X-Gm-Message-State: AFuF++mdSFJL4FnYVsl/C4kj3hdT5NWYxHmyzxv1n/cPtvpPWia3cO9c
	VEW6hsrhCM8wG6w10sQ4LslkmHeOFYnLJ/7fZZoUKAsa4NHzN3DX8gujXfWJh/1HsV4=
X-Gm-Gg: AYBFou0Ykae47Ie/mwgABqLNQZMO8VtKWteRbxSyh2Vu9EKq7Bd+QRPPvA975K/viCU
	NOmHo5M8tn4yAr531o0kq26ATD8tZ6HP5NCU45XCmoxmq1GTVWMQKrJKgfBgCtwk3cXsTH3F/aN
	b49KI7T4ZZ+WVA3quzsIjBo/ZSRea0SlvIT9xZWpxH1zPZ1fZ/LTdif8JuXgsIqIGQCwIZpDLic
	UMgUrIcRWHmFQ+fH24gIo1RqiRhH7QfvDWhelNRADQ1IYYRuGDFsPpSPnr/6//6j6HOe2+LkuGq
	VDS7eeYwfUG2pX6DR/OUKS1QMP2A/U0Kii806LjbadFk1sC8GYVD3Hxkd29PofCzJMDyi88Ys8v
	JKKjuCLeX2hpwM6iNrx5sdfwvYGS/6E+b79xRacZUrOYM2MARdpQr6DLgopKsVu8H0AG37x6XBG
	BImjFBZFsoIBJJ9l/3fXBQbrZgILPYaA/erg3e7mTQa1Qh+6WkdXvg8MJs3foduuFK5/S6Nh9eD
	pywOxOa+tFpG5U=
X-Received: by 2002:a05:620a:1d03:b0:93e:9809:dbff with SMTP id af79cd13be357-93e9b8ecbf4mr1178890585a.82.1791493410404;
        Thu, 08 Oct 2026 14:03:30 -0700 (PDT)
Received: from toxicpanda.com ([153.61.196.247])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93eb99074f7sm22172785a.46.2026.10.08.14.03.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 14:03:29 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
Date: Thu, 08 Oct 2026 21:02:51 +0000
Subject: [PATCH net-next v2 04/10] net: niu: check for failure when pulling
 in the RX header
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261008-b4-pskb-pull-tail-drivers-v2-4-8f2bd9bee138@toxicpanda.com>
References: <20261008-b4-pskb-pull-tail-drivers-v2-0-8f2bd9bee138@toxicpanda.com>
In-Reply-To: <20261008-b4-pskb-pull-tail-drivers-v2-0-8f2bd9bee138@toxicpanda.com>
To: Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Eric Dumazet <edumazet@kernel.org>, "David S. Miller" <davem@davemloft.net>, 
 Andrew Lunn <andrew+netdev@lunn.ch>
Cc: Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>, 
 Mark Bloch <mbloch@nvidia.com>, Leon Romanovsky <leon@kernel.org>, 
 Juergen Gross <jgross@suse.com>, 
 Stefano Stabellini <sstabellini@kernel.org>, 
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>, 
 Tony Nguyen <anthony.l.nguyen@intel.com>, 
 Przemek Kitszel <przemyslaw.kitszel@intel.com>, 
 Manish Chopra <manishc@marvell.com>, Rahul Verma <rahulv@marvell.com>, 
 GR-Linux-NIC-Dev@marvell.com, Shahed Shaikh <shshaikh@marvell.com>, 
 Simon Horman <horms@kernel.org>, netdev@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, 
 xen-devel@lists.xenproject.org, intel-wired-lan@lists.osuosl.org, 
 Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1791493385; l=1236;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=3f5WzTjnDsDOAnT0hR8gZXIWFT9KoT8c/AVMjDx6NOM=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QHTAZLO2IxS2OmXjiwrMC0xtj/kaDkW3OSxxKLc7dWB8wtA0dY5E/Ye18IDZRljWIONenVbHWP+
 B0r4Rpj6pmA0=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA

niu_process_rx_pkt() uses __pskb_pull_tail() to pull the hardware RX
header and the Ethernet header into the skb head, and ignores the
return value.  If that pull failed, the skb_pull() of the RX header
right after it would BUG() in __skb_pull().

It doesn't fail today because the skb is freshly allocated, isn't
shared and has room in the head.  Use pskb_may_pull() anyway and drop
the packet if it fails, rather than depending on that.

Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 drivers/net/ethernet/sun/niu.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sun/niu.c b/drivers/net/ethernet/sun/niu.c
index c74a97fe5464..d1c0e868004d 100644
--- a/drivers/net/ethernet/sun/niu.c
+++ b/drivers/net/ethernet/sun/niu.c
@@ -3488,7 +3488,11 @@ static int niu_process_rx_pkt(struct napi_struct *napi, struct niu *np,
 
 	len += sizeof(*rh);
 	len = min_t(int, len, sizeof(*rh) + VLAN_ETH_HLEN);
-	__pskb_pull_tail(skb, len);
+	if (unlikely(!pskb_may_pull(skb, len))) {
+		rp->rx_dropped++;
+		kfree_skb(skb);
+		return num_rcr;
+	}
 
 	rh = (struct rx_pkt_hdr1 *) skb->data;
 	if (np->dev->features & NETIF_F_RXHASH)

-- 
2.55.0


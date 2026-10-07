Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAF3C3E63AC
	for <linux-rdma@vger.kernel.org>; Wed,  7 Oct 2026 18:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791397005; cv=none; b=VTyF9cbGwdpZMzGdA0I0IcxwmGgH1zOEy+2fnHT+nRQ40vQzyULsTf+hG2XNTCRI6WQy+K4LSr6ZKY9hFhWcaWr2XoQcP7xhmNsWyctfyZcU1FNC23bM8iQoGu0TYlKGA8zsatbaLQdiUyh582lAQ7+Q219fEUN+DtdLpXIKiiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791397005; c=relaxed/simple;
	bh=yldyXc+k9IUGHFBVvbXY7100U73O47dmandGyjhHpkE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=sMpgioYPzBHHwnv21IpHtBnvSgbtvmu28Og6YeqJEoBPIS6e/tHvrc+WqDlV0YBCpEBZs+k3ferfPGSf4//2dsDktAig04HSphvFpq6CJGfUFW+ZFk7IU/7fi0uKNCcGrP7bE4+61oe3JK5fxpUX68KlZlIoXdmZOv8OH440E3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=pass smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda.com header.i=@toxicpanda.com header.b=jfaBhvLA; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda.com header.i=@toxicpanda.com header.b="jfaBhvLA"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-5352a876d5aso24837821cf.1
        for <linux-rdma@vger.kernel.org>; Wed, 07 Oct 2026 11:16:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1791397003; x=1792001803; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jtyJNESs2NfaCrmwRAvvPnxlfOHCunirXFuek+zM5MM=;
        b=jfaBhvLAeYW/Z/XfxewbmV+PvC6o70j1qCRvOsbqqFn4ubNkwhfq6hmU/K6ZdrQ8ZQ
         7TqNIOXZFxgwWn5+5jog4vME465wW+Z/ZKZwXNt3+1OQUSXkbWPvcCy4WYAfUNJyDyEG
         C5PuvNDpVdlOpRtV2WkgFoC5agKGnvZXVksjJO+Sf2sSBtm6IIuUK6KbK08fYD3km7wn
         5/rNl1SAzrRhryJefBwUkUcDnhRD4jDH0xlk9WfRuI6iNDNHFQtbhB74Bi57Dva1mtXo
         pbi9MuR8vQ/jmE9rZ3yydqFObb8QmJO5UynxQjl78GU1jkO+XCN4UiujWwgPkjCcLPRp
         1EvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791397003; x=1792001803;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jtyJNESs2NfaCrmwRAvvPnxlfOHCunirXFuek+zM5MM=;
        b=0qpUEYx1VXQO1ggheArQ/4kYMzvdFTjGrmr8hBYUn6kzyqDTfgFNFXRp14jNEVD8vM
         dE8cR5SF0bibtHn9uomLysRVUJnDP/M07YuIfr3cIeTSZkH4JQ0gvpvvjY5sQ3iSX0yF
         Ms+odWJhrvcX5AxNj8kJBoeTElbkoibG0gUTXmD3dFvPqUnWgALakLNMmOAwHr1KTVg2
         4QH7iNXdB54D5nUH3hLpR+e9skY3UeA4E8jkQ4wh/gZ1TsmqQvnbUN3q3xvbV6dFE94t
         6CNo+fp8B+cVrcZCpvnuPTrrfrqMnBvQvoHeLSg8MZXoRtFpX45LIUdfaHYrFoHo61tQ
         ZhNg==
X-Forwarded-Encrypted: i=1; AKwUvBwS3lxSxZxfoYhfvYzYeCgsae7rUOSc2WKWXcdEo2Om2lnNyDxqbSdRdchG7WF+ZdKPZ5VD+ynW05tt@vger.kernel.org
X-Gm-Message-State: AFuF++nj2PdRX9TD6XfuI3cPClC/LSu+XesEOixbs0OvYcC8/hdk7Ic6
	WRx+ez2jJrINffLzt5lu4TO2AoGo7I1Ej3+YS2OWwPLVGQBdmw8LElVkFWvLSp0/mkM=
X-Gm-Gg: AYBFou0gVH3xPuTxzI90TKWaca2HjBG3JljiJz1ydHA3Z03mRcNuZGXoJWncJ4FdkDA
	8Vs1RrJLwsKF3NJGQISLSKXFVtxxpKKW+sTesNmaAuhI/9Vu8Hf2Y0keRv89sRvdp1kOEHxUFW3
	I+lpEua/Wn1mFb1jNTZALNOt2FkpFH99y7rPp7Vl6dvNVMXfYzbAqoof/fcBEUpx/Y+ABNa69bg
	kgcGMuMzMqFguO6sj+sORQYtjHWPaEDoAn7Lig8aphF1SM2RBKxQW8mt8AaQm+gbCt/1CqOVfa6
	btwaerUwTaHvrzaiE5bJEpAMMc41LeWcNXMqsJ59u8EOVtLi3TlPP4k5y/NH4Sg/tScocnc2Whx
	WtNcFjs1wgfBtd1qguNO6dnni0xvyUGnBBMq4VOMHinAu4LttwBsRDVZyGbbFuEVTr838nHofNi
	YMku9xaUWAJpKsA4fkQ4d2wEiadxYXbC60GVkhr3pP9EgMCuRrYMIuQ+u7y5Kx2GQylhkHWggno
	YwmiXQ6E05xc7JvxS+WbO0Szw==
X-Received: by 2002:ac8:6f10:0:b0:530:5152:75f0 with SMTP id d75a77b69052e-53575522f94mr50565161cf.22.1791397002737;
        Wed, 07 Oct 2026 11:16:42 -0700 (PDT)
Received: from toxicpanda.com ([153.61.196.251])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-53571f185d7sm26074811cf.2.2026.10.07.11.16.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2026 11:16:42 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
Date: Wed, 07 Oct 2026 18:16:18 +0000
Subject: [PATCH net-next 5/9] e1000: use pskb_may_pull() in the 82544 TSO
 workaround
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261007-b4-pskb-pull-tail-drivers-v1-5-9512b0fb977b@toxicpanda.com>
References: <20261007-b4-pskb-pull-tail-drivers-v1-0-9512b0fb977b@toxicpanda.com>
In-Reply-To: <20261007-b4-pskb-pull-tail-drivers-v1-0-9512b0fb977b@toxicpanda.com>
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
X-Developer-Signature: v=1; a=openssh-sha256; t=1791396985; l=1221;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=yldyXc+k9IUGHFBVvbXY7100U73O47dmandGyjhHpkE=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QNqFTCEFL30xWoiEbNRl0xB0Ou+bDMfIq1Ujmi8Mmc+Z3YK0ZHA9JyEcAtxrEeF+xJvGJrfmT0r
 2sKFeMZQHNwo=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA

e1000_xmit_frame() uses __pskb_pull_tail() to pull up to 4 bytes of
payload into the head for the 82544 TSO workaround.  It already checks
the result.  Switch to pskb_may_pull(), which takes the length the head
should end up with and checks it against the skb, so this driver no
longer calls __pskb_pull_tail() directly.

Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 drivers/net/ethernet/intel/e1000/e1000_main.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000/e1000_main.c b/drivers/net/ethernet/intel/e1000/e1000_main.c
index d7f5c6f16142..3a55b211f5a6 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_main.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_main.c
@@ -3155,9 +3155,8 @@ static netdev_tx_t e1000_xmit_frame(struct sk_buff *skb,
 				    & 4)
 					break;
 				pull_size = min((unsigned int)4, skb->data_len);
-				if (!__pskb_pull_tail(skb, pull_size)) {
-					e_err(drv, "__pskb_pull_tail "
-					      "failed.\n");
+				if (!pskb_may_pull(skb, len + pull_size)) {
+					e_err(drv, "pskb_may_pull failed.\n");
 					dev_kfree_skb_any(skb);
 					return NETDEV_TX_OK;
 				}

-- 
2.55.0


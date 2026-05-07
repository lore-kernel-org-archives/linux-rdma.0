Received: from xmbghk7.mail.qq.com (xmbghk7.mail.qq.com [43.163.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C90EE3F54D5;
	Thu,  7 May 2026 13:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=43.163.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778161226; cv=none; b=l+BqH5YWsl0+Dnm6wJ+5hhUvAsa6CNgM/ZFmvJ3cxDbhk8oujUQqJcOsjogue20QFeEkil0Am2bevgXmvuAgNShUR3S0jas+anF7k57SSYN8FCyHVfKak4ETVYjMJuse44q/fZKh0tscUdg8LTXj7jbpnL5c687ECoNpcFAjmfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778161226; c=relaxed/simple;
	bh=vQKlqoTGSV7Dk9rTcYshSvUcl7TYgWZf2yGyW9A30yo=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=cW7YjsisbXloou8Wz5gBwKSgjdQ39fLKi8/3JU9BU2xft0pf9Bz15H3OGbRaGha4iordiEK+od8ZE1n3/uPFsdwBq0KoWUv34Osvzr3wDXlkfBD18hBZmA4DPs720HMMlmEJC0myTHE4FYdgPfP3TQtmqJRAXRUO7ylmvOCRoRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=I5AsX48K; arc=none smtp.client-ip=43.163.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="I5AsX48K"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1778161211; bh=yh4K8iCkn4uRuUMWFiPkLL+C08zpCASkp5Atth0VSPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I5AsX48KZJU610HonA92fFqu/4F6OhnULEWl2PBDir6M9jMS9FGLauL+9qpJelSsq
	 BPmxhTZ66psrTFm3leiDk6L/LMRu8BqzMfeKcH/ugj7wFZ6OjtKZ+0MzwUPIX2C6YC
	 zgochhGEQiHU3+eNFmMZEx5hZOXVOYxNou5fSwAQ=
Received: from lxu-ped-host.. ([111.198.231.89])
	by newxmesmtplogicsvrszb51-0.qq.com (NewEsmtp) with SMTP
	id A06264FF; Thu, 07 May 2026 21:40:06 +0800
X-QQ-mid: xmsmtpt1778161206tqgk9slia
Message-ID: <tencent_D175A964A3A32452D77DB76B66C2B3730305@qq.com>
X-QQ-XMAILINFO: OATpkVjS499uNXgQ2jef7WoftjrHLGeA8ybk5nomzW+LDFPFsTu1YsivxQWeJ+
	 Ge9Jo7RQ1tFxN2CZKoQFC8mA29NRBgVlUig58DaTDZwtBzFIavPBZ/CMeWeCdh3WMFWIBpR1/5M3
	 ABfsy+gE1DA01E9XhsEEhdqFbcUj4IMwGnM9O8OkBqqGAfbyJpvb9fZacWQkDZ7ckiPF1CSP0UGk
	 4XGlszbLYGpd9c4lNtNmtAQ5BQQsxUI8/sMRsj4aeK47fWHPVzAjeHyUiPj8BNEMBtSLwWiTe5oo
	 lO4/rYvoPo/nu0zrAmCtb6e3Vzbs81LAq6qsh+yKM7pnXP8SXi4cJ5hmgx9/b+qZ7/nGOst9lTCj
	 kv79KuSEq0Eex/Lo+HGunhbQQTsWrG0z+Ote48WwByk2UUJ3etTXhHyIFsCB+4AFTM+HLRdaiCSN
	 XxLgC9vCl2gIN9VfdWYIviCyGGR8gMooYWCfezFljH6t+2qkA4lKEOhVKnC63GvUqUJMGG7Q87qp
	 /4Su+lZaufk1J2dUCDG8QgwTF6T0Yb8519y5Erv+A0htYnYMxlFxu4rwI/hyy04DZ+mtLRaYYE3D
	 uI+bdw2LEAc5Z03WBupD6w/1avXQVgRthRa2ombThCOVJuuRaQLqQVV7ZtSmuaNSeYReCpT5dTnw
	 MoIWdKHqYrOHwvW0eHpBrYWewCNf2WgxJlxb9E4vmwZ74P0wu9hnxrzDxf+JskW1/Icl2S975N5X
	 ag2+xt5BDB57OlLtk5bQWxUM0NnBKPTq+pK2wJwVL/l0Ip41hBmgWJJvRNFKO1VVb/xqmr9mHuVO
	 Sa1pMHTfmnYcesgyAmN8j07/a0pW9GbThayk5LSfMH0Jn0xcLvgtqZ4j/nNmLTxH2yh+Ya9IWJZY
	 Pyi9jlENvHzL4jMe/ImErFY8MmSLbilgpVhfye7gwcc9qYGAN3ftNSJmgStEzi26nguWqgyVMb2l
	 Ie4DRFO+PavMy97j5ZS8JXa/aHAyc5qEMQMUeAnYqjsfIgrTljpMste6FJVjHTEY5jL5L6vGcAZw
	 Ou5yD65xzTxHJ5D0VD3Aiy9szYEcPxErbw7+cubiONggrAyBb9I4hH6ASz5egLx9R25HlQvg==
X-QQ-XMRINFO: MPJ6Tf5t3I/ylTmHUqvI8+Wpn+Gzalws3A==
From: Edward Adam Davis <eadavis@qq.com>
To: yanjun.zhu@linux.dev
Cc: akpm@linux-foundation.org,
	arjan@linux.intel.com,
	davem@davemloft.net,
	dsahern@kernel.org,
	eadavis@qq.com,
	edumazet@google.com,
	hdanton@sina.com,
	horms@kernel.org,
	jgg@ziepe.ca,
	kuba@kernel.org,
	kuni1840@gmail.com,
	kuniyu@google.com,
	leon@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	netdev@vger.kernel.org,
	pabeni@redhat.com,
	syzbot+d8f76778263ab65c2b21@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com,
	zyjzyj2000@gmail.com
Subject: Re: [PATCH] RDMA/nldev: add mutual exclusion in nldev_dellink()
Date: Thu,  7 May 2026 21:40:06 +0800
X-OQ-MSGID: <20260507134005.112613-2-eadavis@qq.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <3c4264e6-2e93-4121-a8ec-5ac20e5cc213@linux.dev>
References: <3c4264e6-2e93-4121-a8ec-5ac20e5cc213@linux.dev>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 7 May 2026 06:25:54 -0700, Zhu Yanjun wrote:
> > We must serialize calls to nldev_dellink() or risk a crash as syzbot
> > reported:
> >
> > KASAN: null-ptr-deref in range [0x0000000000000020-0x0000000000000027]
> > Call Trace:
> >   udp_tunnel_sock_release+0x6d/0x80 net/ipv4/udp_tunnel_core.c:197
> >   rxe_release_udp_tunnel drivers/infiniband/sw/rxe/rxe_net.c:294 [inline]
> >   rxe_sock_put drivers/infiniband/sw/rxe/rxe_net.c:639 [inline]
> >   rxe_net_del+0xfb/0x290 drivers/infiniband/sw/rxe/rxe_net.c:660
> >   rxe_dellink+0x15/0x20 drivers/infiniband/sw/rxe/rxe.c:254
> >
> > Fixes: a60e3f3d6fba ("RDMA/nldev: Add dellink function pointer")
> > Reported-by: syzbot+d8f76778263ab65c2b21@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=d8f76778263ab65c2b21
> > Tested-by: syzbot+d8f76778263ab65c2b21@syzkaller.appspotmail.com
> > Signed-off-by: Edward Adam Davis <eadavis@qq.com>
> 
> Thanks a lot. This looks like a good solution. Since the issue is
> reproducible,
> 
> have you sent this commit to syzbot for verification?
The patch has been verified by syzbot.

BR,
Edward


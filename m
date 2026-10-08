Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D64A4EFFC4
	for <linux-rdma@vger.kernel.org>; Thu,  8 Oct 2026 18:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791483421; cv=none; b=OrQ/R5WY1MhWeyOPNTEpZ1yfPcdPmX3wwPEQB7YKVmoIo/3rEXvtOz0E8iRTlyDWCzUhDLZ2S5YNAnqAZBjHuKtFBGKRMJPq9yUDSyZutA2FQbxq/8rOS3mttlfVnaPfPLSFXbjdhlMsdw0cJJeQjd1OCqA1cyVQUf7k6bQJfoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791483421; c=relaxed/simple;
	bh=eH4OZEsYNq/F8YX+wIhMyOJ+JCEQZVNnankWvyuwjG0=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=A7wZLh5HlPxE9uJqcBapxqKtFNcnUYeqjfN/8hOR4+AzxeoNKIpr2b8ywHSmZA3uciKCW/LvbpNQ9MBrmhBosFWdrguA/zJphb4qUXUAGI2IcgKyKV1Yle6gx2lSc89sut29r9qCoMm/WTA9nfj9xqR3XlH86YdMp8nmS5Eztuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cvRfmqp9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cvRfmqp9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD7441F000FF;
	Thu,  8 Oct 2026 18:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791483420;
	bh=+YKRW4tmPv8f2DylTjG51YtABlKuN36zuKEQ8ZwJcog=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=cvRfmqp9nlYJkuXFvMJyE3D0x+cIiRmtu9x963+m4SAtAhY9DUabkzjKsQ9onaSMo
	 HYrUSOOWpYq9nGuHkts3PFpDiPYJIvbojkn2WW6Cg+rY/sp7Rw7YP+ke5T7WXGq/Eb
	 U4Fq77tKb35nzR1V60Szcu3LgFhpYSevxXdiLDI7XfOCXy0qPgjg6cVVtX7JEF+2xG
	 CFtmwiSvrt/mcS/GiXErU/xhuyt4dFcutAq86k59u7Qi1r9YrZWCSQut1S/B48noTm
	 4E3Dq3OYGTDCVk7NzdBJtWZyysIMnndlVHru3hfdveF7uMaNebvNHH3olIERRUPzEE
	 2z//w2vuBUYvg==
Message-ID: <sashiko-outbox-164448@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next 8/9] qlcnic: use pskb_may_pull() to pull excess
 TX frags into the head
Reply-To: sashiko-reviews@lists.linux.dev
To: "Josef Bacik" <josef@toxicpanda.com>
Cc: intel-wired-lan@lists.osuosl.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261007-b4-pskb-pull-tail-drivers-v1-8-9512b0fb977b@toxicpanda.com>
References: <20261007-b4-pskb-pull-tail-drivers-v1-0-9512b0fb977b@toxicpanda.com>
 <20261007-b4-pskb-pull-tail-drivers-v1-8-9512b0fb977b@toxicpanda.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 08 Oct 2026 18:16:59 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] net: qlcnic: 0-length TX fragments bypass hardware descriptor li=
mit
--

commit 8b8cbbac7b14c094feb17203e37bd51a63c158cf
Author: Josef Bacik <josef@toxicpanda.com>

qlcnic: use pskb_may_pull() to pull excess TX frags into the head

This commit replaces __pskb_pull_tail() with pskb_may_pull() in
qlcnic_xmit_frame() to pull excess TX fragments into the skb head.

> diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c b/drivers/net=
/ethernet/qlogic/qlcnic/qlcnic_io.c
> index 761ef3bc8193a..4a81d499e51c0 100644
> --- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c
> +++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c
> @@ -682,7 +682,7 @@ netdev_tx_t qlcnic_xmit_frame(struct sk_buff *skb, st=
ruct net_device *netdev)
>  		for (i =3D 0; i < (frag_count - QLCNIC_MAX_FRAGS_PER_TX); i++)
>  			delta +=3D skb_frag_size(&skb_shinfo(skb)->frags[i]);
> =20
> -		if (!__pskb_pull_tail(skb, delta))
> +		if (!pskb_may_pull(skb, skb_headlen(skb) + delta))

[Severity: Medium]
Does this change bypass the hardware descriptor limit if the excess fragmen=
ts
are 0-length?

When delta is 0 (due to 0-length fragments), pskb_may_pull() returns true
immediately because the requested length is already in the head. This skips
the internal call to __pskb_pull_tail().

The old code safely removed 0-length fragments by unconditionally calling
__pskb_pull_tail(skb, 0), which processes and unrefs them. Because the new
code exits early without removing these fragments, frag_count is not reduce=
d.

Could this result in a packet exceeding the QLCNIC_MAX_FRAGS_PER_TX (14)
fragment limit being mapped and sent to the hardware, potentially causing
the NIC to hang or behave unpredictably?

>  			goto drop_packet;
> =20
>  		frag_count =3D 1 + skb_shinfo(skb)->nr_frags;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261007-b4-pskb-pu=
ll-tail-drivers-v1-0-9512b0fb977b@toxicpanda.com?part=3D8

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53D503A7F47;
	Wed, 12 Aug 2026 22:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786575570; cv=none; b=Np0VHlZHuMO3+PssG+tlL21PySYk1KM7pPwnP+LaQomtN+cgti3VJRLGDAlGRVqtKnSJETn70yU5EpJD6IJkjq9VnyElSMfNt/xTrEFj5h9flz024476OchXKFzHtDPdO0sds0M2b4VhNie6KUSulHy2DSPxJybvpAlM32wmgbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786575570; c=relaxed/simple;
	bh=d4yIF0D4XhMsyOIVSO+1as0E79CeV3D97MNBMfcc3zY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oIPcDqi8n7VzM+Yh5feyZ3jJ0eYjzoJjGrR2N4TO83B1headjh28BMQK/Ivr9rXLN1k0xhQU9/CxnPyRPOLR9O5e6stLrYH3WFGzHo6Fa1tJpfD7WJTmE/R6zFe/xYeOKUQFfUb9XXsECt1it+inDZYoasHt7aXQIvuVZiJpRcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ume6A3Zq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ume6A3Zq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 081BC1F000E9;
	Wed, 12 Aug 2026 22:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786575569;
	bh=d4yIF0D4XhMsyOIVSO+1as0E79CeV3D97MNBMfcc3zY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Ume6A3ZqN94wI8OSB9faQU4L9XGqQT5tRxtv+hWd/6Sj5395EcPOICDqatZ4qCAFF
	 Owv3bPabi1gW4mTuzHGtbDyfiFydHt51e3qGBZpMZ5NxJnKhY2cyKHinNfahUo/keY
	 GnEHqA9MJBgx9QOVS39iud9N74uni1Bs5Df4n1Qr1cN202d6lqMMFHLaVl9Wn7eim3
	 CknOHZ1YmS2etae+BdiHba8pIaosel7IBk0oxXUT28ziSnnn7ofxYj+j0wP/kxFnp0
	 GczTa+sPK2dWmkq3htUQzWHLJIpq/RzsiMT8k+Kn+QCrm8H5jkOEWt7ZY6cgb+vPuC
	 uWJe7Z7VI+oXg==
Date: Wed, 12 Aug 2026 15:59:27 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: "Chia-Yu Chang (Nokia)" <chia-yu.chang@nokia-bell-labs.com>
Cc: Jijie Shao <shaojijie@huawei.com>, "shenjian15@huawei.com"
 <shenjian15@huawei.com>, "linux-rdma@vger.kernel.org"
 <linux-rdma@vger.kernel.org>, "eperezma@redhat.com" <eperezma@redhat.com>,
 "jasowang@redhat.com" <jasowang@redhat.com>,
 "virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
 "mst@redhat.com" <mst@redhat.com>, "xuanzhuo@linux.alibaba.com"
 <xuanzhuo@linux.alibaba.com>, "pabeni@redhat.com" <pabeni@redhat.com>,
 "edumazet@google.com" <edumazet@google.com>, "linux-doc@vger.kernel.org"
 <linux-doc@vger.kernel.org>, "corbet@lwn.net" <corbet@lwn.net>,
 "horms@kernel.org" <horms@kernel.org>, "dsahern@kernel.org"
 <dsahern@kernel.org>, "kuniyu@google.com" <kuniyu@google.com>,
 "bpf@vger.kernel.org" <bpf@vger.kernel.org>, "netdev@vger.kernel.org"
 <netdev@vger.kernel.org>, "dave.taht@gmail.com" <dave.taht@gmail.com>,
 "jhs@mojatatu.com" <jhs@mojatatu.com>, "stephen@networkplumber.org"
 <stephen@networkplumber.org>, "xiyou.wangcong@gmail.com"
 <xiyou.wangcong@gmail.com>, "jiri@resnulli.us" <jiri@resnulli.us>,
 "davem@davemloft.net" <davem@davemloft.net>, "andrew+netdev@lunn.ch"
 <andrew+netdev@lunn.ch>, "donald.hunter@gmail.com"
 <donald.hunter@gmail.com>, "ast@fiberby.net" <ast@fiberby.net>,
 "liuhangbin@gmail.com" <liuhangbin@gmail.com>, "shuah@kernel.org"
 <shuah@kernel.org>, "linux-kselftest@vger.kernel.org"
 <linux-kselftest@vger.kernel.org>, "ij@kernel.org" <ij@kernel.org>,
 "ncardwell@google.com" <ncardwell@google.com>, "Koen De Schepper (Nokia)"
 <koen.de_schepper@nokia-bell-labs.com>, "g.white@cablelabs.com"
 <g.white@cablelabs.com>, "ingemar.s.johansson@ericsson.com"
 <ingemar.s.johansson@ericsson.com>, "mirja.kuehlewind@ericsson.com"
 <mirja.kuehlewind@ericsson.com>, "cheshire@apple.com" <cheshire@apple.com>,
 "rs.ietf@gmx.at" <rs.ietf@gmx.at>, "Jason_Livingood@comcast.com"
 <Jason_Livingood@comcast.com>, "vidhi_goel@apple.com"
 <vidhi_goel@apple.com>
Subject: Re: [PATCH v5 net-next 2/2] net: hns3: fix GSO_ECN flag setting in
 the RX path
Message-ID: <20260812155927.57ee295b@kernel.org>
In-Reply-To: <PAXPR07MB79842CC27C2F5CF9BD40E007A3DC2@PAXPR07MB7984.eurprd07.prod.outlook.com>
References: <20260804213510.673084-1-chia-yu.chang@nokia-bell-labs.com>
	<20260804213510.673084-3-chia-yu.chang@nokia-bell-labs.com>
	<61721708-0d77-4f59-aa08-02562af282bb@huawei.com>
	<PAXPR07MB79842CC27C2F5CF9BD40E007A3DC2@PAXPR07MB7984.eurprd07.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 12 Aug 2026 10:35:25 +0000 Chia-Yu Chang (Nokia) wrote:
> > Tested on hns3 HW (2x 100G, direct cable, openEuler 24.03, kernel 7.2.0=
-rc6).
> >=20
> > tcpdump confirms HW GRO zeroes IP ToS: aggregated (>MTU) packets carry =
tos 0x0, while non-aggregated packets keep their ToS/ECN marks =E2=80=94 so=
 the zeroing is done by HW GRO, not the sender. Before patch, CWR packets h=
ad SKB_GSO_TCP_ECN set (0x5 =3D SKB_GSO_TCPV4 | SKB_GSO_TCP_ECN). After pat=
ch, all GRO events gso_type=3D0x1 (SKB_GSO_TCPV4 only), no 0x5 observed.
> >=20
> > Tested-by: Jijie Shao <shaojijie@huawei.com> =20
>=20
> Thanks Jijie for confirmation, I will submit to net in the next round.

Hold on.. Sounds like hns3 zeros ToS out (?!)

This would be invalid and illegal for HW-GRO. If hns3 nukes crucial IP
header fields it should probably be advertising LRO not HW-GRO in the
first place.

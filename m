Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 795E6470125
	for <linux-rdma@vger.kernel.org>; Fri, 14 Aug 2026 13:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786714448; cv=none; b=I1DyC6ZvdcZAVnxdjpoFS5iqMfcB/b35Vn1KAbYa/lBq4l6Vvqb7Tg7jkpxiA15iAuuTNIC0jJMGB6KBbs/OQ9TLT3QebGyvtw6FlxLX6E5dW6JYyssbd8ubukrhdWJogQMSbNm4oemCdky7t81jvGrTBaLsILqMQCyJdAKypEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786714448; c=relaxed/simple;
	bh=KLPBe7MmMT+rRxR0SQnKlMKqxOvfblXjnlpnb8WUCTE=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 Mime-Version:Content-Type; b=lsu3akyZedxhvF4IWpLOkOzDlxETRq+UdVN8FUervSNUiR4Kx9OF8lQemv8PKUliNwJLHqapibbFC6pewGpO7fKUU6HEgp0D32eEdXxK5wMvLinkTLxv/snQFpZ9UTlqx8p9+1PDEgrZD80Z1/RuA9sYUgbz/RLZuO/m5PYLP6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Lqg5pwzs; arc=none smtp.client-ip=209.85.128.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lqg5pwzs"
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-836cd7310f4so14561417b3.2
        for <linux-rdma@vger.kernel.org>; Fri, 14 Aug 2026 06:34:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786714443; x=1787319243; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:subject
         :references:in-reply-to:message-id:cc:to:from:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=OJqvMkGymJf5lK4k8ANoduG6M5FSqz82g4dX9Jup2y4=;
        b=Lqg5pwzsnZxn34CloqKJwtpoirBRewCQGo/8tFN+WA+typhxYaqTk2xPT8X28ibUJS
         vUxYV/EDjLLvcixo+2JX4VeoLk6GBuJTm7XjiVusDKbMcmlesVepCSKRl2r/NaEuJHPr
         zPsuqVG2/3J4CWxEsJItAnewoc9FzI1daKgN1F5ILSaROVO2GsrrNxD64aQ6TUmwwXQA
         Xalr/IufIdrsaR9IQ01ucF5iIwAd3BiVpLSBnhdOBZczAjvOJXSn7TuGZN0M8lLCoQCk
         G3QYoFSltpJR1CxuE7z+lRxhElKbterjtISdT0eQ3c3WPwEVnpeQFfRliNCtuq0ae82s
         zQuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786714443; x=1787319243;
        h=content-transfer-encoding:content-type:mime-version:subject
         :references:in-reply-to:message-id:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OJqvMkGymJf5lK4k8ANoduG6M5FSqz82g4dX9Jup2y4=;
        b=eIclgNOMX4LkSWyfnMwF5/S7iyrGY2pClp4kKVXGwGo2fGZi+q84mSk4r4WX2OTTBv
         5CAp03Hw37+FaxK4floC4MtFHOFBW8+mRd1PJ7bKlez2SKtVHTyJthlJCHQB5297pOFo
         uf139GhjBeBxPbl0tXhSM5+tmLTbz3GLR6pC9oVD1OUW2fBYi2pmPsF9KIKJ7DUBAr8U
         ZxVG+DoN6ZYQ1y68eGM2N6+XHwz22lAoiqdwiDX6uTN9/IZVc+xj9kHdRDVLWbkT70Oj
         LYMirkD26Wpsv6JWoNF7iHg2rsdVZba5sbAphkl+Km2f3ID6NmbZoOva+1aKWtl2Libh
         QKMw==
X-Forwarded-Encrypted: i=1; AHgh+RoeYWlNY8mefXzqlUxeRA2B+FQlqI/U8lQo6yp1BVJIuUq83kWLFGaRkO+FtUJY7xzdr8z0j48ND4kz@vger.kernel.org
X-Gm-Message-State: AOJu0Ywu/PO1dPqj3HKWdvk8OeYoKFruejpTG8K9L1bt8qqyXoCT/6pc
	LsHDfGlOvWRtMPqypn59TISNcT4U7QKAHFgbhEjG4uQzQ7Nx/ro+7l1V
X-Gm-Gg: AR+sD13qzot5/Jp5AyAn4d2+LDZdgaB7x662gFlP9E6n+GqbxKYOza6iJMCR87Txoqm
	U0Rldawz9K0Ixx/YaAgRLUlZ8d4Dv/c74+XNE145vRFcfu+seuvjFz3f2EWOTOoLQtJ8+Sl/4Ab
	ud61nm1zT7OkrIl8auHT/1fiLs8nAwTDFWkExU7bCM0hRbe9dAmHmQJ5SaVi6rD9kEK2ZzLcxIG
	yAylJKx4CqJOy/dDhvgN6EuPmG/IcqI2o832gyKVFx0i3DXOaFsNX4fbamWk3NEfUWP+SKI5naL
	evMqOey79dWyvCn2p/QgrFMDPm0w0TNXKg+/kwKH+po+XZDSIyA1+Ns48Ueo3j2sJG+1TbqbMBB
	9Z+9zz0F3nKxZnKUKdI+VfkFHHyI7ZMbs7ORppsehGlHNiD2EaarpUCsPSuMceCe1aTuC+Scawz
	b+Xtx2OKNT1y/UcP1juyayFCQtm0vyI4/01ikHSanYecBoJMhZ333dXMOMCQ5HE5w5rK2jGwNXT
	fF6UXlxpHoNRi0QFYRFIdNP/LJ4Lnm5UkrN
X-Received: by 2002:a05:690c:a6cc:b0:80b:9f4e:a70 with SMTP id 00721157ae682-837124de3b4mr18643737b3.26.1786714442899;
        Fri, 14 Aug 2026 06:34:02 -0700 (PDT)
Received: from gmail.com (250.4.48.34.bc.googleusercontent.com. [34.48.4.250])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-836bc689e3asm12934997b3.17.2026.08.14.06.34.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2026 06:34:01 -0700 (PDT)
Date: Fri, 14 Aug 2026 09:34:01 -0400
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To: "Chia-Yu Chang (Nokia)" <chia-yu.chang@nokia-bell-labs.com>, 
 Mirja Kuehlewind <mirja.kuehlewind@ericsson.com>, 
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>, 
 "shaojijie@huawei.com" <shaojijie@huawei.com>, 
 "shenjian15@huawei.com" <shenjian15@huawei.com>, 
 "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, 
 "eperezma@redhat.com" <eperezma@redhat.com>, 
 "jasowang@redhat.com" <jasowang@redhat.com>, 
 "virtualization@lists.linux.dev" <virtualization@lists.linux.dev>, 
 "mst@redhat.com" <mst@redhat.com>, 
 "xuanzhuo@linux.alibaba.com" <xuanzhuo@linux.alibaba.com>, 
 "pabeni@redhat.com" <pabeni@redhat.com>, 
 "edumazet@google.com" <edumazet@google.com>, 
 "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
 "corbet@lwn.net" <corbet@lwn.net>, 
 "horms@kernel.org" <horms@kernel.org>, 
 "dsahern@kernel.org" <dsahern@kernel.org>, 
 "kuniyu@google.com" <kuniyu@google.com>, 
 "bpf@vger.kernel.org" <bpf@vger.kernel.org>, 
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>, 
 "dave.taht@gmail.com" <dave.taht@gmail.com>, 
 "jhs@mojatatu.com" <jhs@mojatatu.com>, 
 "stephen@networkplumber.org" <stephen@networkplumber.org>, 
 "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>, 
 "jiri@resnulli.us" <jiri@resnulli.us>, 
 "davem@davemloft.net" <davem@davemloft.net>, 
 "andrew+netdev@lunn.ch" <andrew+netdev@lunn.ch>, 
 "donald.hunter@gmail.com" <donald.hunter@gmail.com>, 
 "ast@fiberby.net" <ast@fiberby.net>, 
 "liuhangbin@gmail.com" <liuhangbin@gmail.com>, 
 "shuah@kernel.org" <shuah@kernel.org>, 
 "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, 
 "ij@kernel.org" <ij@kernel.org>, 
 "ncardwell@google.com" <ncardwell@google.com>, 
 "Koen De Schepper (Nokia)" <koen.de_schepper@nokia-bell-labs.com>, 
 "g.white@cablelabs.com" <g.white@cablelabs.com>, 
 Ingemar Johansson S <ingemar.s.johansson@ericsson.com>, 
 "cheshire@apple.com" <cheshire@apple.com>, 
 "rs.ietf@gmx.at" <rs.ietf@gmx.at>, 
 "Jason_Livingood@comcast.com" <Jason_Livingood@comcast.com>, 
 "vidhi_goel@apple.com" <vidhi_goel@apple.com>, 
 Parav Pandit <parav@nvidia.com>, 
 Willem de Bruijn <willemb@google.com>
Message-ID: <willemdebruijn.kernel.c248a28f9c86@gmail.com>
In-Reply-To: <PAXPR07MB7984ED42ED0849D3A9AB8C19A3DA2@PAXPR07MB7984.eurprd07.prod.outlook.com>
References: <20260804213510.673084-1-chia-yu.chang@nokia-bell-labs.com>
 <20260804213510.673084-2-chia-yu.chang@nokia-bell-labs.com>
 <20260811173017.3d18dfdc@kernel.org>
 <PAXPR07MB79849A3F1724DBB2DA8EA20AA3DC2@PAXPR07MB7984.eurprd07.prod.outlook.com>
 <20260812155430.6ec81eec@kernel.org>
 <PAXPR07MB7984E3E73868BF8966821C27A3DB2@PAXPR07MB7984.eurprd07.prod.outlook.com>
 <CAF=yD-LQbndjPZiXcfA6fMp6msza_+YdzqqwyeUDVTdOCOHhDw@mail.gmail.com>
 <47BE8A8A-F80C-4C30-BC95-C85FEBFFB606@ericsson.com>
 <PAXPR07MB7984ED42ED0849D3A9AB8C19A3DA2@PAXPR07MB7984.eurprd07.prod.outlook.com>
Subject: RE: [PATCH v5 net-next 1/2] net: update comments for SKB_GSO_TCP_ECN
 and SKB_GSO_TCP_ACCECN
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

Chia-Yu Chang (Nokia) wrote:
> > From: Mirja Kuehlewind <mirja.kuehlewind@ericsson.com> =

> > Sent: Friday, August 14, 2026 10:57 AM
> > To: Willem de Bruijn <willemdebruijn.kernel@gmail.com>; Chia-Yu Chang=
 (Nokia) <chia-yu.chang@nokia-bell-labs.com>
> > Cc: Jakub Kicinski <kuba@kernel.org>; shaojijie@huawei.com; shenjian1=
5@huawei.com; linux-rdma@vger.kernel.org; eperezma@redhat.com; jasowang@r=
edhat.com; virtualization@lists.linux.dev; mst@redhat.com; xuanzhuo@linux=
.alibaba.com; pabeni@redhat.com; edumazet@google.com; linux-doc@vger.kern=
el.org; corbet@lwn.net; horms@kernel.org; dsahern@kernel.org; kuniyu@goog=
le.com; bpf@vger.kernel.org; netdev@vger.kernel.org; dave.taht@gmail.com;=
 jhs@mojatatu.com; stephen@networkplumber.org; xiyou.wangcong@gmail.com; =
jiri@resnulli.us; davem@davemloft.net; andrew+netdev@lunn.ch; donald.hunt=
er@gmail.com; ast@fiberby.net; liuhangbin@gmail.com; shuah@kernel.org; li=
nux-kselftest@vger.kernel.org; ij@kernel.org; ncardwell@google.com; Koen =
De Schepper (Nokia) <koen.de_schepper@nokia-bell-labs.com>; g.white@cable=
labs.com; Ingemar Johansson S <ingemar.s.johansson@ericsson.com>; cheshir=
e@apple.com; rs.ietf@gmx.at; Jason_Livingood@comcast.com; vidhi_goel@appl=
e.com; Parav Pandit <parav@nvidia.com>; Willem de Bruijn <willemb@google.=
com>
> > Subject: Re: [PATCH v5 net-next 1/2] net: update comments for SKB_GSO=
_TCP_ECN and SKB_GSO_TCP_ACCECN
> > =

> > Hi Willem,
> > =

> > The current function of is SKB_GSO_TCP_ECN wrong. Fixing this causes =
the regression.
> > =

> > Mirja
> > =

> > =

> > =

> > From: Willem de Bruijn <mailto:willemdebruijn.kernel@gmail.com>
> > Subject: Re: [PATCH v5 net-next 1/2] net: update comments for SKB_GSO=
_TCP_ECN and SKB_GSO_TCP_ACCECN
> > =

> > On Thu, Aug 13, 2026 at 6:33=E2=80=AFAM Chia-Yu Chang (Nokia)
> > <mailto:chia-yu.chang@nokia-bell-labs.com> wrote:
> > =

> > > On Wed, 12 Aug 2026 10:33:19 +0000 Chia-Yu Chang (Nokia) wrote:
> > > > > > -     /* This indicates the tcp segment has CWR set. */
> > > > > > +     /* For TX, this indicates that the first TCP segment ha=
s CWR set, and
> > > > > > +      * any subsequent segment in the same skb has CWR clear=
ed. This flag
> > > > > > +      * must not be used in RX, because the connection to wh=
ich the segment
> > > > > > +      * belongs is not tracked to use RFC3168 or AccECN. Usi=
ng RFC3168 ECN
> > > > > > +      * offload may clear CWR and corrupt ACE signal (CWR is=
 part of it).
> > > > > > +      * Instead, SKB_GSO_TCP_ACCECN shall be used to avoid C=
WR corruption.
> > > > > > +      */
> > > > >
> > > > > I still can't wrap my head around this TBH.
> > > > >
> > > > > SKB_GSO_TCP_ECN means RFC3168
> > > > > SKB_GSO_TCP_ACCECN means AccECN
> > > > >
> > > > > If the HW can correctly detect cwr on first frame and then no c=
wr and report that as ECN/RFC3168 - what's the problem? TSO will produce =
the exact expected segment sequence.
> > > > >
> > > > > Is the program that if we re-GRO that frame in SW we end up wit=
h
> > > > > ECN+ACCECN on the same skb?
> > > >
> > > > Yes, this is the problem.
> > > > The HW does not know whether the received packets belong to an RF=
C3168 ECN flow or an AccECN flow on the RX path.
> > > > For example, HW GRO may set SKB_GSO_TCP_ECN after observing that =
the first packet has CWR=3D1:
> > > >
> > > > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+
> > > > |     Packet id     | CWR flag |       Flag      | Flushed as SKB=
 |
> > > > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+
> > > > |         0         |     1    | SKB_GSO_TCP_ECN |        0      =
 |
> > > > |         1         |     0    |         -       |        0      =
 |
> > > > |         2         |     1    |         -       |        0      =
 |
> > > > |         3         |     1    |         -       |        1      =
 |
> > > > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+
> > > >
> > > > If the aggregated skb is forwarded through a device using GSO, e.=
g.,
> > > > HW RX (GRO) -> veth TX (GSO), the SKB_GSO_TCP_ECN applies RFC3168=

> > > > semantics. This means that only the 1st segment keeps the CWR fla=
g
> > > > while all subsequent segments have CWR cleared:
> > > >
> > > > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D+
> > > > |     Packet id     | CWR flag |
> > > > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D+
> > > > |         0         |     1    |
> > > > |         1         |     0    |
> > > > |         2         |     0    |
> > > > |         3         |     0    |
> > > > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D+
> > > >
> > > > This behavior is ok for RFC3168, since CWR is expected to appear =
only
> > > > once. However, for AccECN, CWR is part of the ACE signal and must=
 be
> > > > preserved across all segments.
> > >
> > > But this would be obviously a buggy HW-GRO implementation.
> > > The rules for HW-GRO RFC3168 are -- ignore CWR on first segment (ho=
st responsible for populating SKB_GSO_TCP_ECN), and CWR _must be 0_ for a=
ll subsequent segments.
> > >
> > > > In the example above, the original CWR sequence was 1,0,1,1.
> > > > But after re-segmentation it becomes: 1,0,0,0.
> > > > This is why SKB_GSO_TCP_ECN should not be used in RX/GRO paths.
> > >
> > > We have extensive gro tests under
> > > tools/testing/selftests/drivers/net/gro.py
> > >
> > > If you want to catch bad devices - add appropriate test cases there=
.
> > >
> > =

> > I added a test case in patch 6f74bc8b6e8d related to the CWR flag.
> > In that case, there are 5 packets with CWR values of 0, 1, 1, 0, and =
0, and packets are flushed after the 1st, 3rd, and 5th packets.
> > The gro.py uses this case in tools/testing/selftests/net/lib/gro.c to=
 verify CWR behavior.
> > But indeed, that does not cover whether SKB_GSO_TCP_ECN or SKB_GSO_TC=
P_ACCECN shall be set during the GRO.
> > So, a test might be added to verify the SKB_GSO_TCP_ECN or SKB_GSO_TC=
P_ACCECN flags (if there is another suggested way, please let me know)?
> > =

> > > The comment as stated seems to be misleading - there's nothing wron=
g with using the flag if the device follows the RFC3168 semantics correct=
ly.
> > >
> > > And of course, adding a comment and hoping people will find it is m=
uch weaker than adding tests.
> > >
> > > Again, maybe I'm missing what _actually_ doesn't work here.
> > =

> > Before adding an extra test, we need to clarify the definition and us=
ages of these flags.
> > At the TX path, in tcp_gso_segment() of net/ipv4/tcp_offload.c, the S=
KB_GSO_TCP_ACCECN flag is used to preserve the CWR flags for AccECN flows=
.
> > Otherwise, when without SKB_GSO_TCP_ACCECN (RFC3168 ECN or Non-ECN fl=
ows), cwr will be cleared from the following packets.
> > =

> > For the RX path, unfortunately I do not find a clear rule of when SKB=
_GSO_TCP_ECN shall be set except in include/linux/skbuff.h.
> > Plus, the device usually does not track packets belonging to RFC3168 =
ECN or ACCECN flows.
> > So, my previous thought is to always use SKB_GSO_TCP_ACCECN in the RX=
 path to avoid any potential CWR bleaching.
> > =

> > This would be a case where AccECN support causes a regression for
> > regular ECN handling, if that is no longer allowed to be coalesced.
> > =

> > Most HW-GRO hardware out there today likely only supports ECN. In
> > which case they can set SKB_GSO_TCP_ECN fine.
> > =

> > If AccECN flows cannot be differentiated from ECN flows, on such
> > devices, does the admin have to disable HW-GRO with ECN if they care
> > about preserving AccECN signals?
> > =

> > What does SW GRO do here?
> =

> Hi Willem,
> =

> Current SW GRO sets SKB_GSO_TCP_ACCECN when the flushed skb carries CWR=
 in tcp_gro_complete():
> if (th->cwr)
>     shinfo->gso_type |=3D SKB_GSO_TCP_ACCECN;

And I suppose it follows correct AccECN rules for coalescing.

That is a performance regression from RFC 3168 ECN, as it allows for
less effective coalescing. I have no intuition how much it will
differ in practice.

> =

> For HW GRO of a legacy device that implementing RFC3168 semantics, sett=
ing SKB_GSO_TCP_ECN seems reasonable.
> However, such a device would not be able to preserve ACCECN signaling a=
cross the GRO/GSO.
> In that case, if preserving AccECN signaling is required, disabling HW =
GRO may indeed be necessary.

Right. And there currently is no kernel API to disable only ECN
coalescing. NETIF_F_GRO_HW enables or disables HW-GRO entirely.
Or even to signal whether a HW-GRO implementation is AccECN
capable.

Disabling HW-GRO can be a huge efficiency regression. I suspect
many users will prioritize the efficiency over preserving the AccECN
signal.

That said, some devices may have other ways to configure such
finer details of their HW-GRO, even though not available through
Ethtool.

> And I still think the SKB_GSO_TCP_ECN comment could be clarified.
> For example, by stating that "RX GRO implementations which need to pres=
erve CWR information across re-segmentation should use SKB_GSO_TCP_ACCECN=
."?
> =

> Thanks!
> Chia-Yu



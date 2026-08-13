Received: from mail-yx1-f51.google.com (mail-yx1-f51.google.com [74.125.224.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F26BF46AF0A
	for <linux-rdma@vger.kernel.org>; Thu, 13 Aug 2026 15:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786636742; cv=pass; b=QW3t3yo7Xi6TebRBX5Mmmi9BvxRXKxZefDjeTlnSzhcQsBViJfJHiB89GejYsdcfKOg0TwH83GZzUG2wK+uWwk2Hu2cCBJoSa3G2rrkthzmQnkShCmluS9L15hwYh/EqZEMFVnlBnX4zZmY1dYWEl6wQYblzs+yR7IjD1uj55dM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786636742; c=relaxed/simple;
	bh=1qZPJLbxk0wqdttDxWXJdq7N6rwl113FWoMfJzcYy9U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Uuss4FUoTZ8gliCd6WUSRjaJ3iTW2k+7yyN1wH4caUkXEULS3imcEsIj+YoH6sRIMJTxrwRDMicTi5gulUAILseQ8vT8fi1tb6FLvWTpexevNE9KbVkGOJlD6n9IclU+Gm4kr6m/aptzDvREnzEEyKXsSY3v6RYob4RPjZK3TiQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MrzowlQs; arc=pass smtp.client-ip=74.125.224.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MrzowlQs"
Received: by mail-yx1-f51.google.com with SMTP id 956f58d0204a3-6688acd1a51so27429d50.3
        for <linux-rdma@vger.kernel.org>; Thu, 13 Aug 2026 08:59:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786636740; cv=none;
        d=google.com; s=arc-20260327;
        b=o2np67/0IIWiK3fWi6AsbBoGBeMCAdx4XVAkqyGJjHllaC5uOLdTDKjhrBg4TqBIJm
         5Fj1hX3UG7hyVM0UyM7cL4ZvA1gKeURuyjtYxn0yAZN51wStuHTIXlGSzd0cxOlDKcfM
         Aar/nd1OuNt2hp2umIYVBu7Y7x2iE3rsz1C+mL2eFjoE7bb1nI1ZrZWFsF/Q/mX14Ob3
         me1EC7AbmEoOKNMz2o1Y09usr94LDY3oVNVbRTkrBhNaMOMXmI1FGe6SmlAVFVft+qyR
         ur4o1BNLRlbvBRdADI0/pab5LKBcSFrThpaBxDzTruTBw3//RfwPL0x8uNxuc4aEzwxI
         IAkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3700YXJGZEBQK93k1TvUa1Hm3bijHaLKBZNSZbXc0r4=;
        fh=wMry/JUn93VhZnnsN/S/JsM8arZUTdqSvZVnUQlZ9i8=;
        b=dqfpdmVyJkuoc4wm1MpOcJVyiYgv2QDzooxYX4s0oEcgTypVEN/1v2xL69m4dYH4Ov
         zzq8zRzqLb/+MGNXXxJI0zUyIxC5Ndxw0WV68d3PCoO98lexW/Q+Knh2nhF+Z57nWTL1
         6P1juvMgW/fGneNEChCDPkQe3rDVOXs/DpTrM4ZCPzjBJgGYZ/tBkTdMolaBgq2AZtg0
         j2oWltVbSJU+capNgtr2OG7BzSC+pdfzlSc0/IEj1JFhvsfFL4bLgCzZ1DGNezeBvtwZ
         N20zrZMCX+E6Kg85vnsfPI6Ha/Q5sRMfxUPWMX4cHNJMFAt98xc2Z8QcKVBGmh8KCUDn
         FMFw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786636740; x=1787241540; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3700YXJGZEBQK93k1TvUa1Hm3bijHaLKBZNSZbXc0r4=;
        b=MrzowlQszLEqiBBehep4WqtMSpuSEEeYlMBaQmCdjcZ7w68XjKztneXqwnVnHlJ+Cx
         Q9ZrBPq1V7D8EmR9vtLP/NESkVz8g0BjcDq0XdA1dEBdhfAaZF5hS0cKhjBxRxi9qCGF
         GXxTOUptJskpS/C3EKhkA/pz0Eiy6XEMJ+ko708oCW8qhPWm1I4b084T41nzgurGfA2z
         8nroP7gSmfOHO7UszCK9XIQMsvQsPumXaJIFJChBdIlcGZkdLXleMYdHyu2iUEXSIAnS
         z5cvzBRMJOdMiQHnELBUym9lEC7cxVHHRQcBTi1jULDQYTR9Y7pDA+FohB/FEvwRvKly
         RoyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786636740; x=1787241540;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3700YXJGZEBQK93k1TvUa1Hm3bijHaLKBZNSZbXc0r4=;
        b=b+POUXKqoxypWme5PKe1BxWqW8/xrmmgf176WAZfJOl9LLVbGsQTKyQhutqmheCMlz
         M36ADGmX3CVoszvM8W/8g7Y9SuYIR+VNi90Cfypq1GqAgLAKzSp0HQyrH71lcaM9jzvX
         GfqDwB7YRv50CXBYcxeOqDWnwfbSnxCHR3XUenmzk7ETt4djSnfCD5wWNbvCixWYnBeF
         u70ggF2idbISvX27qCynGRokJyGH+k18U3TibcQPjUM3yYmWWBd/IplWj/GR9hA4OaDw
         ON0qIRhO44u7wKyDNwZ0tLZqn5EZSGj8vhITd7QeKVgQVmTaYc7Wl9X5svcw/L6HUrCW
         3Ylw==
X-Forwarded-Encrypted: i=1; AHgh+RqM/WehpiNLkgggnAp6Xsm7Og2LANJ4FuDHYm7OaX1sknMPVREO/dYhXphBKinRLTr22YOcSSHij2h7@vger.kernel.org
X-Gm-Message-State: AOJu0YyRyafVw7i/3vHweJMVh3+gkbyyLDIfcemmtgH3NCEA/1uIO9Pp
	ZDm+1SnBNYsXkrx+u2h+8wh2fapPq6I3pAyVdzRGODqhZLf/TpqyUANOAAtCDqrvBcZEWKsCfcE
	QUJusdu0DdI/e8UYIByerm5KxzrSAe+o=
X-Gm-Gg: AR+sD11CjxwwGKjoJxI80ofHsWRXulZpaSssY1hZtG20Wb0mKCWzCEDdimzaTugHVWl
	bIvJYyJPpbAdNxLci9v9VtSCC3vGe+0f60uOXr5a8poQkdD/D0kjxw67+zoNycim87/6LF3PpZz
	lPSdp80Aj3GLmWPk1SOhUERATGUB0MDWkT7ZMoriVoVIZkFCqH7X6mKCTAnqY2PoaT/3T2EqUWd
	PeCaATBGzoACqZ9X7Kgt+z2MvhOBbBoY7prACXoI4awpywzeLFX8Q1FFx2bEyfBRzYQDSyESXHc
	lYBYAMmGB0ooGVBg/7WhLawNLNXdzq03uy/Ds3BrMgPKtwNJ3uzd5ixNVLIKYarWAzRH+EXTgc/
	yDLUf
X-Received: by 2002:a53:ca09:0:b0:664:d0ac:7c8f with SMTP id
 956f58d0204a3-66c51642096mr1997694d50.30.1786636739609; Thu, 13 Aug 2026
 08:58:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260804213510.673084-1-chia-yu.chang@nokia-bell-labs.com>
 <20260804213510.673084-2-chia-yu.chang@nokia-bell-labs.com>
 <20260811173017.3d18dfdc@kernel.org> <PAXPR07MB79849A3F1724DBB2DA8EA20AA3DC2@PAXPR07MB7984.eurprd07.prod.outlook.com>
 <20260812155430.6ec81eec@kernel.org> <PAXPR07MB7984E3E73868BF8966821C27A3DB2@PAXPR07MB7984.eurprd07.prod.outlook.com>
In-Reply-To: <PAXPR07MB7984E3E73868BF8966821C27A3DB2@PAXPR07MB7984.eurprd07.prod.outlook.com>
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Thu, 13 Aug 2026 11:58:22 -0400
X-Gm-Features: AUfX_mwopSgwyvZOjYUqpXm2XmwhtsPjHx2eC07FAHM6dlfLpKgUy4Q4kn_Y1Ps
Message-ID: <CAF=yD-LQbndjPZiXcfA6fMp6msza_+YdzqqwyeUDVTdOCOHhDw@mail.gmail.com>
Subject: Re: [PATCH v5 net-next 1/2] net: update comments for SKB_GSO_TCP_ECN
 and SKB_GSO_TCP_ACCECN
To: "Chia-Yu Chang (Nokia)" <chia-yu.chang@nokia-bell-labs.com>
Cc: Jakub Kicinski <kuba@kernel.org>, "shaojijie@huawei.com" <shaojijie@huawei.com>, 
	"shenjian15@huawei.com" <shenjian15@huawei.com>, 
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "eperezma@redhat.com" <eperezma@redhat.com>, 
	"jasowang@redhat.com" <jasowang@redhat.com>, 
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>, "mst@redhat.com" <mst@redhat.com>, 
	"xuanzhuo@linux.alibaba.com" <xuanzhuo@linux.alibaba.com>, "pabeni@redhat.com" <pabeni@redhat.com>, 
	"edumazet@google.com" <edumazet@google.com>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "corbet@lwn.net" <corbet@lwn.net>, 
	"horms@kernel.org" <horms@kernel.org>, "dsahern@kernel.org" <dsahern@kernel.org>, 
	"kuniyu@google.com" <kuniyu@google.com>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>, 
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, "dave.taht@gmail.com" <dave.taht@gmail.com>, 
	"jhs@mojatatu.com" <jhs@mojatatu.com>, 
	"stephen@networkplumber.org" <stephen@networkplumber.org>, 
	"xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>, "jiri@resnulli.us" <jiri@resnulli.us>, 
	"davem@davemloft.net" <davem@davemloft.net>, "andrew+netdev@lunn.ch" <andrew+netdev@lunn.ch>, 
	"donald.hunter@gmail.com" <donald.hunter@gmail.com>, "ast@fiberby.net" <ast@fiberby.net>, 
	"liuhangbin@gmail.com" <liuhangbin@gmail.com>, "shuah@kernel.org" <shuah@kernel.org>, 
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, "ij@kernel.org" <ij@kernel.org>, 
	"ncardwell@google.com" <ncardwell@google.com>, 
	"Koen De Schepper (Nokia)" <koen.de_schepper@nokia-bell-labs.com>, 
	"g.white@cablelabs.com" <g.white@cablelabs.com>, 
	"ingemar.s.johansson@ericsson.com" <ingemar.s.johansson@ericsson.com>, 
	"mirja.kuehlewind@ericsson.com" <mirja.kuehlewind@ericsson.com>, "cheshire@apple.com" <cheshire@apple.com>, 
	"rs.ietf@gmx.at" <rs.ietf@gmx.at>, 
	"Jason_Livingood@comcast.com" <Jason_Livingood@comcast.com>, "vidhi_goel@apple.com" <vidhi_goel@apple.com>, 
	Parav Pandit <parav@nvidia.com>, Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 13, 2026 at 6:33=E2=80=AFAM Chia-Yu Chang (Nokia)
<chia-yu.chang@nokia-bell-labs.com> wrote:
>
> > On Wed, 12 Aug 2026 10:33:19 +0000 Chia-Yu Chang (Nokia) wrote:
> > > > > -     /* This indicates the tcp segment has CWR set. */
> > > > > +     /* For TX, this indicates that the first TCP segment has CW=
R set, and
> > > > > +      * any subsequent segment in the same skb has CWR cleared. =
This flag
> > > > > +      * must not be used in RX, because the connection to which =
the segment
> > > > > +      * belongs is not tracked to use RFC3168 or AccECN. Using R=
FC3168 ECN
> > > > > +      * offload may clear CWR and corrupt ACE signal (CWR is par=
t of it).
> > > > > +      * Instead, SKB_GSO_TCP_ACCECN shall be used to avoid CWR c=
orruption.
> > > > > +      */
> > > >
> > > > I still can't wrap my head around this TBH.
> > > >
> > > > SKB_GSO_TCP_ECN means RFC3168
> > > > SKB_GSO_TCP_ACCECN means AccECN
> > > >
> > > > If the HW can correctly detect cwr on first frame and then no cwr a=
nd report that as ECN/RFC3168 - what's the problem? TSO will produce the ex=
act expected segment sequence.
> > > >
> > > > Is the program that if we re-GRO that frame in SW we end up with
> > > > ECN+ACCECN on the same skb?
> > >
> > > Yes, this is the problem.
> > > The HW does not know whether the received packets belong to an RFC316=
8 ECN flow or an AccECN flow on the RX path.
> > > For example, HW GRO may set SKB_GSO_TCP_ECN after observing that the =
first packet has CWR=3D1:
> > >
> > > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+
> > > |     Packet id     | CWR flag |       Flag      | Flushed as SKB |
> > > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+
> > > |         0         |     1    | SKB_GSO_TCP_ECN |        0       |
> > > |         1         |     0    |         -       |        0       |
> > > |         2         |     1    |         -       |        0       |
> > > |         3         |     1    |         -       |        1       |
> > > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+
> > >
> > > If the aggregated skb is forwarded through a device using GSO, e.g.,
> > > HW RX (GRO) -> veth TX (GSO), the SKB_GSO_TCP_ECN applies RFC3168
> > > semantics. This means that only the 1st segment keeps the CWR flag
> > > while all subsequent segments have CWR cleared:
> > >
> > > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D+
> > > |     Packet id     | CWR flag |
> > > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D+
> > > |         0         |     1    |
> > > |         1         |     0    |
> > > |         2         |     0    |
> > > |         3         |     0    |
> > > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D+=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D+
> > >
> > > This behavior is ok for RFC3168, since CWR is expected to appear only
> > > once. However, for AccECN, CWR is part of the ACE signal and must be
> > > preserved across all segments.
> >
> > But this would be obviously a buggy HW-GRO implementation.
> > The rules for HW-GRO RFC3168 are -- ignore CWR on first segment (host r=
esponsible for populating SKB_GSO_TCP_ECN), and CWR _must be 0_ for all sub=
sequent segments.
> >
> > > In the example above, the original CWR sequence was 1,0,1,1.
> > > But after re-segmentation it becomes: 1,0,0,0.
> > > This is why SKB_GSO_TCP_ECN should not be used in RX/GRO paths.
> >
> > We have extensive gro tests under
> > tools/testing/selftests/drivers/net/gro.py
> >
> > If you want to catch bad devices - add appropriate test cases there.
> >
>
> I added a test case in patch 6f74bc8b6e8d related to the CWR flag.
> In that case, there are 5 packets with CWR values of 0, 1, 1, 0, and 0, a=
nd packets are flushed after the 1st, 3rd, and 5th packets.
> The gro.py uses this case in tools/testing/selftests/net/lib/gro.c to ver=
ify CWR behavior.
> But indeed, that does not cover whether SKB_GSO_TCP_ECN or SKB_GSO_TCP_AC=
CECN shall be set during the GRO.
> So, a test might be added to verify the SKB_GSO_TCP_ECN or SKB_GSO_TCP_AC=
CECN flags (if there is another suggested way, please let me know)?
>
> > The comment as stated seems to be misleading - there's nothing wrong wi=
th using the flag if the device follows the RFC3168 semantics correctly.
> >
> > And of course, adding a comment and hoping people will find it is much =
weaker than adding tests.
> >
> > Again, maybe I'm missing what _actually_ doesn't work here.
>
> Before adding an extra test, we need to clarify the definition and usages=
 of these flags.
> At the TX path, in tcp_gso_segment() of net/ipv4/tcp_offload.c, the SKB_G=
SO_TCP_ACCECN flag is used to preserve the CWR flags for AccECN flows.
> Otherwise, when without SKB_GSO_TCP_ACCECN (RFC3168 ECN or Non-ECN flows)=
, cwr will be cleared from the following packets.
>
> For the RX path, unfortunately I do not find a clear rule of when SKB_GSO=
_TCP_ECN shall be set except in include/linux/skbuff.h.
> Plus, the device usually does not track packets belonging to RFC3168 ECN =
or ACCECN flows.
> So, my previous thought is to always use SKB_GSO_TCP_ACCECN in the RX pat=
h to avoid any potential CWR bleaching.

This would be a case where AccECN support causes a regression for
regular ECN handling, if that is no longer allowed to be coalesced.

Most HW-GRO hardware out there today likely only supports ECN. In
which case they can set SKB_GSO_TCP_ECN fine.

If AccECN flows cannot be differentiated from ECN flows, on such
devices, does the admin have to disable HW-GRO with ECN if they care
about preserving AccECN signals?

What does SW GRO do here?

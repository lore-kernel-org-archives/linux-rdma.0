Received: from mail-4325.protonmail.ch (mail-4325.protonmail.ch [185.70.43.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A48432110E
	for <linux-rdma@vger.kernel.org>; Thu,  3 Sep 2026 04:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788408422; cv=none; b=rfWAMAEvMInmSRY5uGpWp7mL4tsaUXbCZv01b5E2otxc4HpjQ8fCmZQdbxjSwb137jBG00dbJ6/OOM92IS2EbJVAAeA9GpKdkZcXr5zmV9EoDB2eSyi9PoZ4k4qdW2j/LYkraO+TUKS2Kq7VrwCm33fTyuBgfx1u5rr0x9pHdiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788408422; c=relaxed/simple;
	bh=gAmwA/Rxqppk70vzbQnOlL1N+OV0qNrSDg5aE/U2TY0=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Upi8XYZdHfXIvCVVPTnEHGuDcwPWe1V7xKiGXXwdJ57uPst+aq6abkFGXcx190aGaSzLQIvyl1dhHhesRJjwOR9dJ4I0Ry5780TNqFUCeLNqrbXZQAvRXYZrYXcvz9GkJ1cb9vCiNcpc5CfyqhVhEszOInN1ejMBZXMWCC5q6iE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=TQ6MHhXq; arc=none smtp.client-ip=185.70.43.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="TQ6MHhXq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail; t=1788408405; x=1788667605;
	bh=gAmwA/Rxqppk70vzbQnOlL1N+OV0qNrSDg5aE/U2TY0=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=TQ6MHhXqFegbQyFZyZbuIkQXOyjTY7c8J3jvM/pFtHN1i9jaR7DJk8eyXkh0kO5Bb
	 IqGNY/0Grq3JQ0lPluvJ0JtIp8gNcFgLrv9krDlyawY4+PBd8AugGuFjKuGNK1a7qd
	 s4oXgabZTwvzi1OPq/47UFJUKUU1XIZZ9PpXhpRksmBCW39RlVBnGRfHE8cCFxcXGy
	 qg0Q1vZ7vnNCKKXqsGsosOg1+TORxmUOQ0OXDTDiTtJdesTQvMeAUsRyxrPbSZ2Vl8
	 kdH0RUVeghYzVXrQvUW1M0VNQrCRpHFx1Ic5e9T54sH8zL2jw56RN94huDgoR3lHyV
	 4FcSVqS1Z+6nA==
Date: Thu, 03 Sep 2026 04:06:44 +0000
To: Jinpu Wang <jinpu.wang@cloud.ionos.com>
From: quanyeyang <quanyeyang@proton.me>
Cc: Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, syzbot+d396918a29afb8543e1c@syzkaller.appspotmail.com
Subject: Re: [PATCH] RDMA/rtrs-clt: Fix CQ pool leak when connect is interrupted
Message-ID: <ANOSEdInjxoti993P_wPWGuTPEEr-eZDjuLNMkXhG0yW63ECGVftgiFWetVMMKjLBrQc6dUiZtThzpFuEvDy4hqbNjooSjKeY2UW9qR7pk0=@proton.me>
In-Reply-To: <CAMGffEmz_QSy2TLM5OBQ5GUaOiRozkLyuTNOXV8f9CnbvhPYSQ@mail.gmail.com>
References: <20260830-rdma-rtrs-clt-cq-pool-leak-v1-1-b169434fd3df@proton.me> <20260902162518.GW24140@unreal> <CAMGffEmz_QSy2TLM5OBQ5GUaOiRozkLyuTNOXV8f9CnbvhPYSQ@mail.gmail.com>
Feedback-ID: 206494642:user:proton
X-Pm-Message-ID: d2cea401a73f162c98d43d78310855efc9434a06
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Thursday, September 3rd, 2026 at AM 12:48, Jinpu Wang <jinpu.wang@cloud.=
ionos.com> wrote:

> Hi Leon, hi Quanye,
>=20
> I had a look at the report. The syzbot bug seems to be triggered with
> smbdirect (ib_dev[syz2] removed), so I'm not sure how this change in
> RTRS client would fix that issue.

Hi Jinpu,

The smbdirect line is from ib_client->remove() during disable_device(),
which always runs before ib_cq_pool_cleanup(). smbdirect just logs that
the IB device is going away; it does not use ib_cq_pool_get().

rtrs is not an ib_client, so it does not appear in that remove loop.
The leftover cqe_used comes from rtrs-clt borrowing pool credits in
ADDR_RESOLVED and then dropping the con without PUT, which we hit
locally with rnbd-client only (no smbdirect traffic): map_device with
path=3Dip:127.0.0.1, interrupt create_cm(), then rdma link delete.

The same "ib_dev[...] removed" line shows up in that repro right before
the WARN, for the same reason it shows up on syzbot.

Thanks,
Quanye

>=20
> Thanks,
> Jinpu



Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7A1B344DB9
	for <linux-rdma@vger.kernel.org>; Tue, 23 Jun 2026 12:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782217434; cv=pass; b=bbxh4ULVxN1tV+U5GEG+Uvyt2DVbMittjw80VGPlMV4SUC1SgA4gQNABdMrBsStf49SzNCqZ160WFAWlm5MbZqwavMzMePZN3C6lJu4odTX8RPYzenwu+6JdeQ4Q28sx+nWNR9IxOFVloyUuA9s93rc9pC2RS37nmZIWS579AyY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782217434; c=relaxed/simple;
	bh=DQXfc1J5fli4Josq0nJh+hNaWCpnlpOOE1XZU/d8Kck=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ky9EMlriPwq3Oc4098QAjN8Z4/Hqj8e7GQqrriD9wD6HwDIM0rK/GORCvBNJKE9ozZkkXF5jXQ12RqxH+qIJoEtSmMdVFDHgaskc6UQiqTF3qUjPYBcVfUZgJOVPTPcwkmTltC943kjLQ06rny7xb9r49N5U0UrFEU2RJ7PHG/4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eAYELpxV; arc=pass smtp.client-ip=209.85.167.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eAYELpxV"
Received: by mail-oi1-f171.google.com with SMTP id 5614622812f47-4864a5c83f1so3091704b6e.0
        for <linux-rdma@vger.kernel.org>; Tue, 23 Jun 2026 05:23:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782217432; cv=none;
        d=google.com; s=arc-20240605;
        b=KE2fMqd/3Vc8avRYj2IR23rZE1Nv8QoDDCqmLOe0hlC5E822/oyImXhFJx5VVtoZdJ
         iD/j2tQ3pUjgJVNACAopI4ECQp10Tii4qyXHph0NuBLq+it6pgyeHieoGusXE4I9CD0W
         bg6eWomJ2Y0vi6mtV++pzGmULb71wTk910mOuvWKFi/j99YqhBVGFWPuCejQTrbiuSuk
         N2T4JPQlGXVJH380CCOwMt64pKo6mZUwAbykeDFmbrXuu+F6wIPEmXneRcFv8QvuDo6+
         eISYSPyMW96TSwNbnlJ+0zj4vFQ46bn4UbddPDb37WlBxzkfU61PcDNWjvN3O4/9p0ue
         sFzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=M86eFM23Q6eR8zY03x/LWGfSqCVPcpLNQHFbDnMWpDQ=;
        fh=BmzpygDwfH6SX2QKOVAMgllMQJgo6Dq1sPHsdXuzfNk=;
        b=Hvez+1UcY2X5Okxugm4QQHVx06Z2kylZk/cAyBMjNTw9bO8Ah2Vi7dyCbwnbTUMTd1
         LCrQb1IXP1Ya7NSbSbR4MqW6VebLv0bSYJEcfTTOmlrY+yboCjL8urS7mhzHJgoLCR0y
         JBBzuRbxO7H2lYStxhkfAYeSGNLMWHH2K+1+n2bBt77bC3+vWRLYQV2xJsCX0n0EWprO
         ze7DdBJ3mPrVps5zLoxvGVhRTcKUBU8vxK+kkrhYlViGc/5u64Ub/WBUqaQCPULoKPDj
         oDjrw/sUnQXgcXAN4lfUAbP4VURGfWkx/2bXF+uriq6q5Yhpk5h7C05w11ekj/5bSUoP
         HdAw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782217432; x=1782822232; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=M86eFM23Q6eR8zY03x/LWGfSqCVPcpLNQHFbDnMWpDQ=;
        b=eAYELpxVD283aVeEjydHSFUawmiTEKQYh/BbXwVpOaLCxTbga03yq22gAGNgURArcp
         3nGE88bFFFHQmYIgAJ921TDaKZ5ab/7RsXlgO5MLv+bGQwIDxiPToWT/4xlCR5AXSOzt
         8EKhGqk++VAxSLqBnZ5cvx0SPIsVGFLDTWdMkO3mUXtT1dNeO9DUw8xABuggC95ez9fb
         OdbbIiNARomfW2bMhjbdo+P8e9P/qc5UQMyE9PuNvejZ0rhklEDFlmiAGcj+yphPY0lh
         zXySkbp0kb2MkGTxEdS0NVDid0BLGnS9cDRE/vYty4XpyYfvbVSxvIWXtShGj0RCDgdA
         qnmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782217432; x=1782822232;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M86eFM23Q6eR8zY03x/LWGfSqCVPcpLNQHFbDnMWpDQ=;
        b=IWrP7k/99qXqXJpzM9f68o6ocH3ud2caPf15w6roCDsmOAtwJKe/gizvmtHDL4AXLl
         owzSCxfeLACv+MURyh/b4s4OkpZwLhR4PcMlquTci2cmjaDRuRnNiimUkj2h7jJecep3
         uEqJ5gzlrqu23dqnRPzRvWpH+JqRy7V7EF+WJ4NwhfITEOo+rCabprv53W/OIW0DaVEf
         QayZ7iUOGMY+BP0MVzW/LzzV4x9Q6+gBT+gb0c+NCYhZlAZVWjzCEDRY5mstx8r2oDOl
         +TwCbwkqIzysXriKM45IUD2FzLOeCuJJx1y2naRHyhqN6RLbSU3Ue6s2NxEaYqwhBIG7
         8CHA==
X-Forwarded-Encrypted: i=1; AFNElJ9kAGQn1f3gqSJ5zR2iAobYKPJGEQJvu70JhJ5PG+WzWhA28wwzgfJL2hkZtDlHRVHGBmEKjq9PYqNG@vger.kernel.org
X-Gm-Message-State: AOJu0YzecJKjGiHncXViR0A1qkQClVtoIR2LXOUfkl+KKqAMAvyxG1zI
	pRhNsfwRJjhDusNCiWkqIZxRzxLJ2wGvleL6pmg3jwUxCQDfoZbdl8JuYdVCHVK/JYqrAWaKB0H
	KJ81cGJwnm6jNKVscYKD0dhNWDcvERI2hG/6SJ698
X-Gm-Gg: AfdE7clY8Kg1ORkYdHNEjFQq0HYcuS7woHnpSxuE7sVBqVhNM3apaN7P5jFZO0xlCWI
	wGHgvThZ0W/mV5LS9t6SW76JeDsLIoikVQxO1tObAYG50Fdzj7v7YLjLi5aXLmFeBTM9rUMJTDa
	rGjWPLGZhq6eb5yiyfiRo5HuI1Vfo+XVLwKcc2r57wTofNQ6xcRIQeB1+pu08UtZfMCXe3hUYhg
	qSGlHF7ClzfcXwTZxDbg6nl5LecavNRvpzVeTHdeKpYskS3Geb4qJcv1ebYE8ppHQUOeHm5CPTw
	4osJnpdIYaSGLCfIrxIzjYTc1U4E+hI=
X-Received: by 2002:a05:6808:bc1:b0:482:c2dd:d18f with SMTP id
 5614622812f47-4896acafc31mr15563979b6e.40.1782217432035; Tue, 23 Jun 2026
 05:23:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260623114444.1429042-1-kotaranov@linux.microsoft.com>
In-Reply-To: <20260623114444.1429042-1-kotaranov@linux.microsoft.com>
From: Jacob Moroni <jmoroni@google.com>
Date: Tue, 23 Jun 2026 08:23:40 -0400
X-Gm-Features: AVVi8CfZiX_YopiS1zprImiq5JpmSlmYc1-3LEYW1rGIM0qrsHEiJkM-aFcjfvM
Message-ID: <CAHYDg1RQ8vEMrKPoS3qHgtf5S+T1Wzrm=YuwdfzFEX3g22Ruhg@mail.gmail.com>
Subject: Re: [PATCH rdma-next 1/1] RDMA/mana_ib: Adopt robust udata
To: Konstantin Taranov <kotaranov@linux.microsoft.com>
Cc: kotaranov@microsoft.com, shirazsaleem@microsoft.com, longli@microsoft.com, 
	jgg@ziepe.ca, leon@kernel.org, linux-rdma@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> +struct mana_ib_uctx_req {
> +       __aligned_u64 client_caps1;
> +       __aligned_u64 client_caps2;
> +       __aligned_u64 client_caps3;
> +       __aligned_u64 client_caps4;
> +       __aligned_u64 comp_mask;
> +};
> +

I am curious about the addition of these unused "client_caps" fields.

I guess the idea is to be able to reject older providers that lack support for
some mandatory feature in the future - like if a new HW variant breaks the
descriptor ABI or something and therefore requires a provider update?

My main question is: how come they need to be added now as opposed
to extending the structure later?

I'm not proposing any changes, just trying to understand the intent.

Thanks,
Jake

Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3F1C3ED3AF
	for <linux-rdma@vger.kernel.org>; Wed, 22 Jul 2026 20:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784750834; cv=pass; b=UabM3V5oCdmyG0QKMKr6Ln5nzG/vd0XlCHN7nNWzjLQ+/T2Sl3YfoKNdjmX1xZfclgfHCdVrLmGgqXFtSnfDOdKfLKG9Fb8zUSO6ZRNuukbmRUa1zab597wgwcOawei/i8A9E7bSA3ssdWKWj2nikjZPS96zcZQAF0IUrhaGb54=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784750834; c=relaxed/simple;
	bh=xHcPaISUtz1B8fOHnPYorZ9jbOCvXaMM70oogJXim0s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=B6wi4Ewwb48S0U/9nO141i34T/5F7NXAnTbUhvE2pT+p8x6F5hrjFWc3NZqdBcHokSQh38w9HDH7Yg21Htz7hdeOu8yMtqvs5wkywXNd7T0CAQQFdEl7xdxKXUdqwwtonDHw58OXusm9wOq66OCo4FpDK2pm7i7WFww2jNNeFEQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu; spf=pass smtp.mailfrom=asu.edu; dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b=cVWOEzHS; arc=pass smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b="cVWOEzHS"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-84862b0d5f8so7869237b3a.3
        for <linux-rdma@vger.kernel.org>; Wed, 22 Jul 2026 13:07:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784750832; cv=none;
        d=google.com; s=arc-20260327;
        b=ZBfRUcz9/Bp01e8ISoWLrGoLf6Zss3kCwepCOIgP7EstqYrzng7nMddSPv8J2OTLM9
         I0O9KvQ6fhR5h8y+0x6MHgl/LlOzF0+NPABXZF8LkmMIa/F73gR/ycFXyoLnAFJKLtCn
         QJgOeCLUmkRpSfPB+8IBfjDprLrMS1D67PuQ7PfRMLRiKgWCWUCma0l6B0qtb3MVGQBM
         pzia184GWdG2FttT8YxwAOu+NZgdz56L0LsMkcZalV/eYoPbOKC+MXRIj8aH61ebZoMT
         pxS3Ru1Xz5jA9aj+T5aGgcOUhekkD91Gf5jLpnIF/1PfKI3DsJTIRYlmpgIUQN5+Xy9u
         VCNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=fGv3sKwue91Jp1IMJ42L3qkjCq6etFSBQOQqlp9Euxg=;
        fh=iH2sZepFhfXxhVFiFf1lqB6fT3YfwzDWUNkfmTukULA=;
        b=JQG0eNN8z8cOjWcRqkYjUQVnz4kNjmUHlggr7dqXVf5q7sZF5diCmtGFKgLCeXZ5T+
         3vWAI3QLTyClpWWmMIJz8p6ZdZQL3a5p2eM9zNaWVaW2lbrzDCP5ymegCsHWlYmQGmDN
         /3fNYgyrRYvtlN+Gh5aVPk4/RlZeQ7tFhslHghE51+2mH2ZiFK2E8bfanOjlcbYGTHiH
         oSSO4eh4G/3vZyjtw84mnmfEpNacj1ICxkN5c0B9WTyliZYIZYyHIlz/66hiKYdFOVOn
         XiMRNJdcdXq0KbyCg3CfRO3LxC7egVMp2Zykpg7HqKO7TGzRxGk9VR6grsi9KZaQ+NvJ
         YPLw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1784750832; x=1785355632; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=fGv3sKwue91Jp1IMJ42L3qkjCq6etFSBQOQqlp9Euxg=;
        b=cVWOEzHSNo40xIvYtyH467HivPDMnsF7F/hcWX29y6uR4jRTCrDo5on7Y7X+HKRlC+
         ao8eXTLAxZWDoWEx6br+F2JyFRjQl2ROvWL/2wRM4Ex/KAGafEQ+euYNiJwyev9/jMNQ
         r7kHfSpSZkmj4IQPODpij1ZyeRBPi7cdEvl8tUovdh2H2Kdrhe98RrC54G19lUmCk97w
         8hHb0cQf4AgWCSchWlBpjtrFIvSU/5EvUabM6p8CsxayINc5CAdJO45kdVLRj9y81ZtC
         uhEuERDhVgnf02jmDjDWUfwTwd9A+r5VU/3JCrI1bG74isEtzkmOqF4jW9L01U9iyJgE
         XjKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784750832; x=1785355632;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fGv3sKwue91Jp1IMJ42L3qkjCq6etFSBQOQqlp9Euxg=;
        b=jAqm2kmzyBIWsdt5caYykMy7hgFscTSZuGvEK7sDQ35YD0Kl735d0zacHjqaqcb3R5
         pZdSoAcW9kOxidkOVm5d3aCYHM+W6Ya77B+xrj72799CSsQxtfwxUrcpSYL4nO2nvCL4
         lItC+R+4ITY34+DgOu/FYrN4Hv4Dl0KofNT8cMlr0/NGXFCDf0QfJ2rI4oLpO0y3y1aZ
         yFNDhpwBs06x2e2yeVwqzNdgI/QKropn66nNuL/vMd76gt226dkmy/MelvUC84aV1VP9
         Twv0BY4KeV1My1MnaGi261ZHyrXXxYSRJCzu4bArdxElHbay4w4ybvAZFWbg0rh4+R9Q
         k3Uw==
X-Forwarded-Encrypted: i=1; AHgh+Roo6arLVVGWprGX/aroka3yP1+Eb77yZoveCINdGBkBnw8s6Xt/ncC/tuSLw2xQu220QUDjzw1bfGhT@vger.kernel.org
X-Gm-Message-State: AOJu0Ywas0XVwWX32N3FFnXUaau1xrfmGVNmkORVvy9Oq1zLv1Li0MG6
	mnEn/n7K9n2NWluMARY5BGRNiN9Ck4QBZyyQVCIT4GqItncO1gnqRA14sGYqUjtKiCcUt4e4+PD
	S6Gzp7L76dUfrPmOF8NJrB+lTFF9jK0snTK+3AQOf
X-Gm-Gg: AR+sD13lTQmwoHk47TfCjqWmoZ4WBqsanpD0Z7dPp9A+J43ZcKev+4FNpVIcbJduLui
	6tlmAvMvo68Ai8s34P7BeMg98hfzYa9/DcO3Metdz9VY7A2vVV9TIG/PD+e/2SOGahqwDlpDOFq
	YxOSqjS10s1DUg5qjcKOaeKHYw/nm7LSvW1tWAUcyYGduG2hr51huTuKiEkYl6vYOEZJGwUOdMb
	zhxgCwlqhHMxVWTkwgBbI6C6+m2HWSDGB33xzB4HQsohppiJczdWskfAVMscD/nzaqGBoQag1gJ
	vS1TFruVGeqVhiVsDQ==
X-Received: by 2002:a05:6a00:278d:b0:848:2e3c:9955 with SMTP id
 d2e1a72fcca58-84e2b82f7c2mr359711b3a.4.1784750832014; Wed, 22 Jul 2026
 13:07:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260714212239.1511269-1-xmei5@asu.edu> <20260722112719.17665461@kernel.org>
In-Reply-To: <20260722112719.17665461@kernel.org>
From: Xiang Mei <xmei5@asu.edu>
Date: Wed, 22 Jul 2026 13:07:01 -0700
X-Gm-Features: AUfX_mx-yqJnOpcfMEPOaEX19bsQKnvPlcLtmh3BL8I6eGX4G775jKjDpzEbzf8
Message-ID: <CAPpSM+RURyJdL_bXC_LX+ai8R_s3AP2zK9tOq6KnEjKG6ccdDg@mail.gmail.com>
Subject: Re: [PATCH net v3] rds: tcp: hold the RCU lock across ipv6_chk_addr()
 in rds_tcp_laddr_check()
To: Jakub Kicinski <kuba@kernel.org>
Cc: Allison Henderson <achender@kernel.org>, "David S . Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com, 
	linux-kernel@vger.kernel.org, 
	Santosh Shilimkar <santosh.shilimkar@oracle.com>, Ka-Cheong Poon <ka-cheong.poon@oracle.com>, 
	bestswngs@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 22, 2026 at 11:27=E2=80=AFAM Jakub Kicinski <kuba@kernel.org> w=
rote:
>
> On Tue, 14 Jul 2026 14:22:39 -0700 Xiang Mei wrote:
> > Changes since v1:
> >   Use rcu_read_locks instead of dev_hold/put
> >   Rebased on [PATCH net v2] rds: Fix inet6_addr_lst NULL dereference wh=
en IPv6 is disabled
> >
> > Changes since v2:
> >   Add change log
>
> Why did you(r LLM) leave this portion of the change log in here and the
> rest in the correct place below?
>
I added that based on Allison Henderson's suggestion of v2. I don't
know how the change log works, so I may misunderstand Allison's
suggestion.
I'll do some research to fix that in v4.
(https://lore.kernel.org/all/f69ec0975481ad04dc7403834bbb6b93d1092ecb.camel=
%40kernel.org/)

> > Fixes: eee2fa6ab322 ("rds: Changing IP address internal representation =
to struct in6_addr")
> > Reported-by: Weiming Shi <bestswngs@gmail.com>
> > Assisted-by: Claude:claude-opus-4-8
> > Signed-off-by: Xiang Mei <xmei5@asu.edu>
> > Reviewed-by: Allison Henderson <achender@kernel.org>
> > ---
> > v2: Use rcu_read_locks and rebase on rds: Fix inet6_addr_lst NULL
> >     dereference when IPv6 is disabled
> > v3: Add change log to commit message as Allison suggested
>
> The patch does not apply, if it's still relevant please rebase and
> repost.
> --
> pw-bot: cr

I'll check the rebase issue, thanks.

Xiang

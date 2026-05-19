Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6864F3DB622
	for <linux-rdma@vger.kernel.org>; Tue, 19 May 2026 07:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779176157; cv=pass; b=iV5es+JBK0/KOWxvvMfmNDKwMQcw7zVg64w1tubJw9FLfR9HKBVDvBaCriGCIZoCTnfdy52oaaGiwJglFusI8lZULH6kN8d4/xgNucp6LR1Z1Nh2D6agZADH5PVpD23AeIYEL0+tymqjEiv61MKVwTQ+osdX0g3cqrh0ErkuT6Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779176157; c=relaxed/simple;
	bh=XxLdTRIRViloeA/nl/9zKQHbIk6Fd7dTbO8JdCx3yxI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MySg4xA/34QUL2amf/YNE4enisKhP+h2QsS65+F1M63fWOjxXBmrJM2E2k0FqTncu9N3vJiKBIXdazOUX5p99Gqcnh9hQDONmffe1tW0h7zr5xnvMWNSIaLVA0/ERMhOOUG/wwoRJRJpV2n6llhZMbS3AI3HIdX0Qc0n1boWYQE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=extrahop.com; spf=pass smtp.mailfrom=extrahop.com; dkim=pass (2048-bit key) header.d=extrahop.com header.i=@extrahop.com header.b=IsqOUNZn; arc=pass smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=extrahop.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=extrahop.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=extrahop.com header.i=@extrahop.com header.b="IsqOUNZn"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-67c3cb1433cso6899385a12.0
        for <linux-rdma@vger.kernel.org>; Tue, 19 May 2026 00:35:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779176155; cv=none;
        d=google.com; s=arc-20240605;
        b=M6tNAg758pWm7rvEdby17OmCDL9Mq1bFCZeiXk/0QOQfql2OyhoagTJnZfpqJeExaD
         WS2Y+AVYrw9jnTpnEVbaStSvl9jHfV2eiogVJqSt8XrSzoAIIJoN/TYzqRfcGqfR14JG
         2jra582T2UvxmRgJZqdc76NaPxO0+lnNYDn8cWrHmX+ICRfQVgsJppKxcVjCXV8jX82C
         T/ecXrXwD8No57tPlsKXieU90VI5Y1DuhYdknUrEZ/bOUs3mD8c8ctG9SUVx0cmRPVhj
         +UnKeZyEZmI0aOG006gJIDqrAjJVwGlaV1dLUzqHDyQWxfQWJOLfhb0aZ1vdFBI6+XYn
         Gm9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=XxLdTRIRViloeA/nl/9zKQHbIk6Fd7dTbO8JdCx3yxI=;
        fh=+O2xz/K9YP8lNVfZvU83SKPRGAg8gJ34LmSM7zHfDNw=;
        b=iyaIHlBR5KQ3/8GstT3GvaIIN5GWlPLl25fqeGkOqQXNicizxGggRUlGtDNbt+qwWz
         yzRXGiCB+mSfXkJr/84TBi7xMIY747yauNAUAF0tJamRdIQ7uwAI0EwOBY+yT34ggW4y
         kZ3nQniQJy6GNS7j9lBcr6gQn2lgC4pa8lEX8kKzhENMfg6kOyLcypa3t7zKppFcZyAt
         NANxIaEuJEqQRQH3liZ6aUVIw0iWVaMRIBMSen389by+xJObWoUSZq4jagMW6goj+RDX
         My/BMhiWwfgyBduI+FDI7mW+0DZt01szYW6ode/4YV/XALu0oeyczXcZltQsL7eUYxSB
         CLnA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=extrahop.com; s=google; t=1779176155; x=1779780955; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XxLdTRIRViloeA/nl/9zKQHbIk6Fd7dTbO8JdCx3yxI=;
        b=IsqOUNZnMQfRoZ6gSCa5/Pb2IodpWraRaiEmlMzTCL+GThCnUm8SrFbHhAjgQx2ZUE
         nsyMPQZ6jQS3atbIl7h8ezZH6nynMKAHyY48krtJUJA2SPgIZqk254S3O2LBJ/ij9fKg
         CzOrAEovkEUbwJUbOiADKmQBc8VGT0nhag7aa246G1VVW0r+Ol/L/V0iBXRrSgsdjNli
         dJ/oFXsd5PmwIueoATaqYBLC5KBWO0YF1o7F/RwnGzCeib05V39T1apxi9pXU+qfcjlQ
         IxKMk/dZz//J0TCJUyoIsVJXU5TZRWy3OTmYu/+2/UGpKT2zNQyj4ZbxSN+0gMzEqISI
         9IHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779176155; x=1779780955;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XxLdTRIRViloeA/nl/9zKQHbIk6Fd7dTbO8JdCx3yxI=;
        b=Iri+q7DZHVlTa+OyJf73qXqeR0IWdIQUe2h9sgJMVXvP6IZDTn+Qb6rW93Sz83DYQE
         nKM1tXYDZ7G0I7tq04I8XjobLglCGH3e410Qs2IxffPeTP1skmOe8sHsUYtEB4xWzg+0
         1w+ANrpdGHLeqjNgGPFjjRrmjQ9CNt8DCPOLJqtlgpaLadCb2TuwuZiAPR8G7P8mZ3xl
         jYxAEkpFBfc4VOwKctz0VvsMRGa97cKcsW0QxEyL/47f7X6sL8WXN4+WnKN4pWccRgZ2
         TWkJwFcmYO29qC8TspOgAGzxAQ3EiS8mU/Gd77EGjagwgzNHNQrC6NexnTI4Y5Qb/JK2
         U2iA==
X-Forwarded-Encrypted: i=1; AFNElJ+0DmZeiy6t/HSC8S7pj/ClzV8BRJKt75TDX3DEJdKVHV/IkGeLUP58vxxlY4sNW2YRsXz4krRxlYhA@vger.kernel.org
X-Gm-Message-State: AOJu0Yz6kPSb4dsu4b1z2xVUple/4ejr0kaSN1rcUinZY1OLZQZXVM2v
	HxbuZXrx4ZyweEDlRkEyQI2ft85OLRcKdyA5wrVfiMUBKr8QQeZ25SUHgorL53BHV0Vj2tyH0J7
	0aKNvB7BLDjxv814gASSky4BWDCMJlYf8ClHomvOWXS+HmwCBrNeygnnFxCdzOfHqhjUIuAsIrN
	3jGVjcGuCgQu7p1guawBag/rWgX8jeyx4QIFhObCEWvM+gn8bBdoX2swFjXa52+2mRuJJjxH2nQ
	R7aREPk/PkLIBr4HZkae4MrZ8ibKho=
X-Gm-Gg: Acq92OGHAe2v7MEyDl8DTK/urWRVd+T1niNEBZoG7G3fCNZ29DeGj4xvZncH59Kt/58
	VzDDJ3onYRMptc4b5oiOglTTiYoLTphZ8sH6vFui/64brRD9djJWqT+fCWkBQcD5jvlpSvp0Y1e
	gAr6VqUWTzV7jUHN8OkypZWTn4HpSU4WWH/WR92SRN79lfzewDdz/BEgYmX0P+8LDewCqPpGiZ0
	NhCY2+dMhgN8ppfb60tm+UBi1BGH1pxnWQ/skbUOeqLmZZxqosctJ5EQuUMrcBI52YeTzS0umGq
	oYydyAw=
X-Received: by 2002:aa7:d6cc:0:b0:67c:6836:7b0a with SMTP id
 4fb4d7f45d1cf-683bd58b751mr7883025a12.23.1779176154645; Tue, 19 May 2026
 00:35:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260515-b4-mlx5-sensor-fix-v3-1-f537ce191d6c@extrahop.com> <20260518112555.GM33515@unreal>
In-Reply-To: <20260518112555.GM33515@unreal>
From: Will Mortensen <will@extrahop.com>
Date: Tue, 19 May 2026 00:35:27 -0700
X-Gm-Features: AVHnY4KCOWuQ5o5TO5dLsOENIYFb6b7Fc_T6vOXkgGzYg1538-vpqKBjLazAOTc
Message-ID: <CAMpnoC5ACdKiqy9mzmwvm592fJCbxXJCsuFxKJPG0c75_frFhg@mail.gmail.com>
Subject: Re: [PATCH net v3] net/mlx5: don't printk garbage when transceiver overheats
To: Leon Romanovsky <leon@kernel.org>
Cc: Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>, 
	netdev <netdev@vger.kernel.org>, Shahar Shitrit <shshitrit@nvidia.com>, 
	Carolina Jubran <cjubran@nvidia.com>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	linux-rdma <linux-rdma@vger.kernel.org>, Jeremy Royal <jeremyr@extrahop.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 18, 2026 at 4:26=E2=80=AFAM Leon Romanovsky <leon@kernel.org> w=
rote:
> Honestly, this approach feels overly complex and fragile for something as
> simple as printing to dmesg. In my opinion, you should drop
> print_sensor_names_in_bit_set().

Do you mean basically revert 46fd50cfcc12 ("net/mlx5: Add sensor name
to temperature event message")? Yes, we could do that. It is
definitely fragile regardless; there are lots of assumptions that
there's at most one ASIC sensor and one module sensor. If we want to
keep the printing, we could simplify by having temp_warn() just print
a static string like "ASIC" or "Module" rather than using the strings
from the firmware, and maybe also call a function in hwmon.c to check
against our module's sensor index in order to ignore events about
other modules.

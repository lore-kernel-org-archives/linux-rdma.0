Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794352875;
	b=nuvCOg3sWohxz8fXzZM+OAoIkqosJBnJ2XDyd8WE1CQEaNFU4q/njD2R/C5r22ynOeox
	 8bIGwJoYgssX3gSIykafzqVIrcScEnzCN6+cMnvTqKFvuzUL5nQQnRUUJv2sDgGHhIgzU
	 fgvdwrMf4eCH0ZGtOFdzD2ewhixXKCDu8871CslHGsHWXQw9g1nPkDTTccmfuFMSuYfov
	 KQwwPvI5pO4dl+hzFAeEQODvBBtfYmPVveeZv+si+RaSY2TsgEeR6STM5iTeoUeGEznYg
	 zpPdCluwmN/AAB1HvLns3NWJOHqBjG3GOZRFitJFJ6DHgkPpESOZvdpSeEh5Ekc6oeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794352875;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:Mail-Followup-To:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=dmjEUol2qh+/Kf+BAZYRdZvYZ50LeNOIlSk9Quu1FKU=;
	b=MI6KqZg+oiH1jMwBIeHXItCK2glqCn9f98SztGUmpU2byEsKe+scDx7S5OfaZ9yuAbgK
	 tKZvpHRMVO1b4lzH9UrZyBneaGGyyFUua0MHbYNrXBRhnYG+MnCvZrLy9PTrNIljCfmU7
	 HO5x7Er8kp8CDmwwQhidmJKaxVNrVzCIAFeB+gNTkz4jTmgKBb7ZHLJFnc3cqx0tskC+P
	 vujE8guCHw/gz8BQlsJKk/xxCyO7n2AqqA26AFoTf6HQUeSha8kYJLiVRtD5Ezy3FIK1A
	 w/UR87InTshLruFF7WbbIWmTfdcQuSFit63gpzVG848i5qT1fc9hJ4kI1B59a004PIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=dama.to;
	spf=none smtp.mailfrom=dama.to;
	dkim=pass header.d=dama-to.20260707.gappssmtp.com header.i=@dama-to.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=ihJmqArm;
	arc=none smtp.remote-ip=209.85.214.171
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D91C606A31C
	for <linux-rdma@vger.kernel.org>; Tue, 10 Nov 2026 23:21:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9D91C606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dama.to
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=dama.to
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=dama-to.20260707.gappssmtp.com header.i=@dama-to.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=ihJmqArm
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2e9eb579c0eso14781715ad.3
        for <linux-rdma@vger.kernel.org>; Tue, 10 Nov 2026 15:21:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dama-to.20260707.gappssmtp.com; s=20260707; t=1794352874; x=1794957674; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:mail-followup-to:message-id:subject:cc:to:from:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dmjEUol2qh+/Kf+BAZYRdZvYZ50LeNOIlSk9Quu1FKU=;
        b=ihJmqArmhhakMFCEzwTIjw/CEHNtN7ibidz+IQW+Zs6SdfWUceC9QePZqpzX8L6jgI
         q2fIUwMTkq9BjGo/g9JF7U0ThMCM4KSMaC+JpiOlUv8xUsZnjMgyTXUMtYwbAZ6GOwZP
         hUPGyQ7Fuay3QW4X1y2qW9MDLjghavNwl0FKVz5+vuL+Rkkq+JcOq+R5TR61/sl9gCR7
         GhH7y4cyRDFqe5NpyFy5R0RlW2hFyjYtFJJkRTorvcoNMpVnunc8C9I2/ACKrMgVPFyG
         EpTYeQsDXpReLgbY3r5W2XN0RozHUsGlvt/9RWYbBBMQ06wNaUSY46JplreNk+b9NjTT
         w5nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794352874; x=1794957674;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=dmjEUol2qh+/Kf+BAZYRdZvYZ50LeNOIlSk9Quu1FKU=;
        b=ZyqVHloYShslA6yhe3Fvxy6t0WoAmg5BV60rkYWmEgpL9hEGkt/nTL0z7ntxmg7gV4
         6A5gN8NtKmt3pp4azrH3V4orXwRFyKpNFD0bNhBRDgLbwqrU2mhxqpQpeB00cC4lZpcT
         zmg5pX4U0NUIsBaC08QOl2Nt7/znfR2c2qjdsQOdfNkDI645p80m107TMELbZlJg+i+Q
         xNQbm7Qio9us6Qy02lkbi40d+D6F27pIAcP4Y2GrEAz36PRS4J2FxQwCbVQlf+sFKDDd
         urqLTcoZPuiU6nPSyQ/y92T3lmNNA55JRGS1c27/+XzhMfrp5wPxo7waMmLKCEsxhHTa
         SKUA==
X-Forwarded-Encrypted: i=1; AL+hErEGGG4BQvIBLhLxUoszhljVz7rYUA47fixS7Cr5A95SbfTKbV60izm5vsWvZYL97i0DTaLhCznhpijF@vger.kernel.org
X-Gm-Message-State: APuU4Z+jfg2CdFsQd1XfqODGzHb8N2wWuic/7B6WrOx77XO7QXOuKhAo
	YoD4bcDERcnPcElu3UGt3UIAG6U6qsIqaCP2QJU7hcmX7DMaMuqvwj5yGFeLL0UJ4/U=
X-Gm-Gg: AYBFou2nOJOYMyrtv8fqXVfqNIVPqxqznCkemJVVW+93XzQb9VSCxTActJ9dZR2xlou
	YsCR2BSHlaWH7LQLcKDHx2fUSUN8Z6P0ovBNQvTGlarjcy2MuVm2mDxyismdcclV5gvh7kd0/rx
	JxEj9gTP49zMiyuTnrnYH82Fo7drYozwe0b6ZAG5iyIq0DpUqUWNS0bGrsreAor/nwaenRCuSir
	enPsWtLOs5/O3yryQLaDS3YfbysQIGPWtQTCCTDhSeZRE/gUfnE650if9MeYTsVdG2ae+eZLM6I
	l4XmzKCq70rzPer3FWyUzamhSwN8VRifX3G8Tzq6Pw62kYbotxARufcq8PxEBwMzu+eyXBgs8Kl
	nr19oUvglfU9hyjccbGa3eNEx55i38m8tofTj6gW6L6nScQMpdb55NfFyHpmcPa3k/aoxnD/Gne
	gg+kjPjq730KN0tAHrUFxMKyM+AaOXhSFRc49p7KA/WNJgB+7FrvIfwFzWzquvcjUqIuVRmtm+s
	nFq2GDszlTtWUQ0bMps1Ip08VG5Csj2anbcPhKB+ZEXzmefvyZZ8B/z1ndVMKEgbM19kXCWPzcx
	8TSHcA/aepBMvl4HVH8z+BXmI9xudKS/H/wnctWEHbzcA7YjcYbSytMgrRpilmtB
X-Received: by 2002:a17:903:2f43:b0:2e2:cb65:a719 with SMTP id d9443c01a7336-2edd77694cbmr7109555ad.15.1794352874082;
        Tue, 10 Nov 2026 15:21:14 -0800 (PST)
Received: from localhost ([2a03:2880:2ff:5f::])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cdd8d7a26e5sm1257643a12.18.2026.11.10.15.21.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 15:21:13 -0800 (PST)
Date: Tue, 10 Nov 2026 15:21:12 -0800
From: Joe Damato <joe@dama.to>
To: netdev-bot+sinfo@kernel.org
Cc: netdev@vger.kernel.org, andrew+netdev@lunn.ch, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	horms@kernel.org, linux-kernel@vger.kernel.org,
	Eric Dumazet <edumazet@kernel.org>, linux-rdma@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>
Subject: Re: [PATCH net-next 0/5] mlx4: cleanup and doorbell fix
Message-ID: <avOm6IDyQokvMnc3@devvm20253.cco0.facebook.com>
Mail-Followup-To: Joe Damato <joe@dama.to>, netdev-bot+sinfo@kernel.org,
	netdev@vger.kernel.org, andrew+netdev@lunn.ch, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	horms@kernel.org, linux-kernel@vger.kernel.org,
	Eric Dumazet <edumazet@kernel.org>, linux-rdma@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>
References: <20261110231304.1859217-1-joe@dama.to>
 <179435264086.488859.12644173782807656441@kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179435264086.488859.12644173782807656441@kernel.org>

On Tue, Nov 10, 2026 at 11:17:20PM +0000, netdev-bot+sinfo@kernel.org wrote:
> Hi!
> 
> This is an automated message. This series looks like a fix, but its
> commit messages seem to be missing some information:
> 
>  - What hardware the change was tested on. For driver fixes please
>    mention the device (and if relevant firmware version) used for
>    testing, or say that the change was not tested on real hardware.
> 
> Please do not repost the series just to address the above. Instead,
> reply to this email with the missing information, so that reviewers
> can take it into account. If the series needs another revision for
> other reasons, please include the information in the commit messages
> then.
> 
> The evaluation is done by an LLM so it may be wrong, if you think
> that is the case please reply and explain.

I ran this code as part of a larger series that also includes SW USO support
on an mlx4 machine.

The only fix in this series is the deferred doorbell flush (patch 5), but I
need the other code (patches 1-4) for SW USO support I plan to submit next if
this series is applied.

Since patch 5 fixes an issue I've never actually seen, I am sending this
series to net-next without a fixes tag.

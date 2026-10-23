Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792782058;
	b=DlzjT5h+pMKGn+VQPRSA6D7aXQqVCWaCJXMfrvMyhtimaFhrBlsubk0sFvTpPs33oDpF
	 quhRS0jHOepneyrNKG1LwAS8ryV8SHqapSb4ryxUamGuni5Fx45y5FOSJVYVw3DBb5S7e
	 WJnwjHvt53OyYKuhfz2Wy3ZNrJcAKqoSTiW9wjiwFhp94PtbNl2AYQw2Ojl5ETNRvHcFf
	 MTf6uD0oyD0qCxhrOSDjS7LWU4K2AYg77HPUbtMc4FttyXaM7Sm467LqcBFse5PdDje0X
	 pasigO5LbNVqt2gZAdG+664F8WA/nkHElYv012Hlw6/EooZ5iLQUoV7S0EvT9SqnlqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792782058;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=5tf4s8d8+MZT/ng3kYJALwtT1EAbBRaxelT7QvlTQng=;
	b=L5W2zrbVL2QT3V3LF6RTMnRmIyD11rlJR6B6ScejRJF/DuLbJVMuu4pWVu0usXJZbTXt
	 ijBTrrPVcF8RC8wxHXcAmpuh+K2xz/u5AcFbO9PjZpXVWvXZ7KSF2DD1NAfJP88Z7dDtX
	 Xkuwkg6wTY/Ia8zw1UyNrs77kzanHjLsFYzuM7ZjsAq9JCHInITt/8034AePGh0oM2NYJ
	 F2UjDVAsVRZe3PyGUDqeQ/2LmAk5SSMfsSrwXMu+SaDnKG7vJIrDrbW9D91wZUSCNQ7lH
	 iGwoLdy2XVkELvP7xsXjNU9m2z/J+YSxbYOuNMyroVXlt7CUosS7fTVtH0i5wnLd0Aw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=bzc4Cg9j;
	arc=none smtp.remote-ip=209.85.160.174
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E797C606A324
	for <linux-rdma@vger.kernel.org>; Fri, 23 Oct 2026 19:00:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E797C606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=bzc4Cg9j
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-53669f7b518so11399641cf.2
        for <linux-rdma@vger.kernel.org>; Fri, 23 Oct 2026 12:00:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1792782039; x=1793386839; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5tf4s8d8+MZT/ng3kYJALwtT1EAbBRaxelT7QvlTQng=;
        b=bzc4Cg9jHc+EwZ+EF2GHA00SaE7XNzyRJ2jPm8VaHgqzKDLrehIHY+5e8wqB1yH17y
         sndSYk22aMmceP9P1fMLTu0Z4V8EzlM2RGsFmTw4gK3j741dLn2NCvrwBRx9Zs2Y9Nrl
         IH1Flz0MwkfAlUgvicHD3GXb1HCVFF/PCxVAEn/OVSguv9eR9Zs++ljRZWXpHTqI+xAr
         rfcFCA7qmIwN9IxX9GeYG2HRZ3YRwMSM0MH1BmgGZbTGcamONR+rAGI29PTmp5avInXD
         sAUAnL9pEXhpYTml9nJyCuJ6EjWQTeYXwbhCn5SvYnMgGcHEU9aguEL9UamXbiSuNSk7
         hQSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792782039; x=1793386839;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5tf4s8d8+MZT/ng3kYJALwtT1EAbBRaxelT7QvlTQng=;
        b=kZ5VvqECwhMlhOc0IVHmePx0JZEbtqke6ZM3ijlLO+L8/JOj9Xn1ks5dEQPBuNeV8a
         PsuhIQd6RZSKVeqr2xkaZ2+wpjnHaVIJ5xRv7klYH1JGJHEAJ3Yyik3nsYJ8k6ic4hYX
         G1/iZvPdqm5y0KFOvb42IgpxTAuQyqQLkq9OANj7hsqfSyJUeqNGeWekZASxFm1/cdDl
         EbqzM4LW/DSaZSm4yuNBoJMZY5Wi9bsFJMN/zPGysTldeQVoDkcc9733TFiiCTrz8sGq
         piyyAb0IbmTaMbj41wC0Dgpcy1HYxXiQcZ+GHjwsMQ8AWceiYiqclUckk9OFGcHvPAVY
         7D/w==
X-Forwarded-Encrypted: i=1; AKwUvBxGtSCbKIIr7pNbrUkWOCzp+I3S1Sl605c7LKA37SOgGti9aDTHGrkdh7FSjtHO//L0em/InhByd9MN@vger.kernel.org
X-Gm-Message-State: AFq9FYJ8O/oS0Jc3b67TxX4ejS435X8EbAy1r6H+TQpfHePCYg/WoQdy
	zmtJQzLYR5z8WoIJgwnmpBv7tk1SqJVLrJp2hFmPQzggBZCLo0sHDa/BR1ICpGch10A=
X-Gm-Gg: AYBFou1xmPxcYd2HNydwPlhQPu/iHIe3bnQpdG6bq1WUmOGnbTTI24XVlolztobhk9X
	r1hqUfH9jxDo1E0chxcli114gY/THhDsO+8co18C/hA6IElYfZgRpO+QSYMvCSucV+VvZV6/RxQ
	qqzf3I+DoMB891ngBIqWovhzYgcKbj4Ow4OXU+KCsC5z6hVr1OnJIQxa49HTj9q8KjSjNi+bhuC
	IYV/H03rQjfShJQMnrXscz0lc+bxWLxrOqEHrz3Jep3/CpcPV5U3Q+rX40ACiA6Kuab5nDCq5Fg
	P6y+Ai3ysil2wkMdj6E5/TnMZ+FFUVVWXEaZPq1E++n88jh965VWtkikogiA3akjR49PxWRgf3L
	53L8f+Db7xqv02rP6Xqb7Ejkjrcpdy/1wXS3sB+ltXYo91M9zYhOBcixwl8WNEc5oxE2F87AIeA
	p49W6C0u+/VZxkzr0t2Fd9eJvSETmQbHnueokoBKJlLqYXYJLuCeIr8Au6b22Y2sNxpH1T54z98
	eDuobSE71mPPSoqaQoONHjhnaDw4uYlysAfpfZinee/0mhwLAF7gdi33JFNWueWe+LA+Ki+VuBR
	JK2mdhx3wpqZ8Vyu2eJyNmU0JLq+cR82m4NboQ==
X-Received: by 2002:ac8:5d8e:0:b0:535:a5f9:7520 with SMTP id d75a77b69052e-536c26e2168mr47897061cf.63.1792782038589;
        Fri, 23 Oct 2026 12:00:38 -0700 (PDT)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-53839709ed6sm1185741cf.16.2026.10.23.12.00.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 12:00:37 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xKKVI-0000000GxzN-4BG5;
	Fri, 23 Oct 2026 16:00:36 -0300
Date: Fri, 23 Oct 2026 16:00:36 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: Leon Romanovsky <leon@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
	Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, iommu@lists.linux.dev,
	Tushar Dave <tdave@nvidia.com>, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	linux-rdma@vger.kernel.org, kvm@vger.kernel.org,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jens Axboe <axboe@kernel.dk>, Alex Williamson <alex@shazbot.org>,
	Ankit Agrawal <ankita@nvidia.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Sumit Semwal <sumit.semwal@linaro.org>
Subject: Re: [PATCH v9 02/18] PCI/P2PDMA: Derive routing from directional ACS
 controls
Message-ID: <20261023190036.GL3977851@ziepe.ca>
References: <20261023155914.GK3977851@ziepe.ca>
 <20261023182715.GA2798722@bhelgaas>
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
In-Reply-To: <20261023182715.GA2798722@bhelgaas>

On Fri, Oct 23, 2026 at 01:27:15PM -0500, Bjorn Helgaas wrote:

> > Yes, the ACS combination is selected to avoid ordering issues
> 
> Does a user have any way to know whether the configuration is safe?

No, unfortunately in PCIe so much is really difficult when it comes to
deployment :(

> I'm wondering whether users might use "pci=config_acs=" to configure
> ACS so things appear to work as they prefer but may not provide the
> ordering guarantees drivers depend on.

I imagine that could happen, but on most practical systems the root
complex will blow up if you do asymmetric routing so there is an early
indication.

I know this because I've help debug such configurations at
customers. Some servers helpfully MCE if you do this. Lovely.

> If that's a possibility, do we have any notes in dmesg that we are
> depending on fabric behavior that the OS can't discover and verify?

Maybe, it could be interesting if the P2P logic found asymetric paths
it refuses to permit it.

Jason

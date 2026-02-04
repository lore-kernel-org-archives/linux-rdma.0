Received: from mail-qk1-f193.google.com (mail-qk1-f193.google.com [209.85.222.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 543F640B6EB
	for <linux-rdma@vger.kernel.org>; Wed,  4 Feb 2026 13:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770213419; cv=none; b=iFjBxFWInhieNGjz6d0HL5ZaLCKm/meYSQoF0yEvTajHPCGLKDU6sv81hVBZ9rHPgdm8eiaPAPoANN6QNqfoWA91TCQzvB+3TIW5L9jPxLPAIpHnjrOaMRMIvxdLp1DHbJlDawyCgOUsDpCzR4ih0jK6Qsg+7lRIKnDvyHCw6G4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770213419; c=relaxed/simple;
	bh=Ne+l1aDUaLXnO+/mFbaO6kEskLTskqAwvLQ5aTo6Qxo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QEwn3XXr+2I2bN2doE9Gho8Q3PvWh6pVW3FqlrQaaaDh35ODTi00fd5naPrMC+Dmi1Ulfa4GuD7UCDDS42djZEoDyf0x2gPCQ7rEjZ5Tr54Rmiv/+hMtghpO4WkA+7sj+PJYd5PVXSjZk/3jBaG7gmoIr5IJzAeHTuEDoAUh/rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=IA35i1w+; arc=none smtp.client-ip=209.85.222.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="IA35i1w+"
Received: by mail-qk1-f193.google.com with SMTP id af79cd13be357-8c9f6b78ca4so724735685a.0
        for <linux-rdma@vger.kernel.org>; Wed, 04 Feb 2026 05:56:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1770213418; x=1770818218; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=iRrqXVZVX7Z3YtbKGBkBfsPXFsl6FxGibC0bf/QAItY=;
        b=IA35i1w+ff8OoDwcKSgMprZiCngIzZMxiNv3nGC7K7nWh7Sc/RZyX9GmL4u/HbQtv2
         uxT5To6R+Htg/97rAGsg4o8sFB0/qYUcEgkUBE5Zseu/sEOfR8NvRiLrEj/7waGLFSr1
         8mcpT3hPrZ0LEJHQ/NOZn28F9D4HenGFY8LelO3NiVpCHG1Utwwc7QfbZXPiRqtFkWo5
         gn0AFncfnoi9hpGxOmwsP+AB58ZCyHcxhmXzY+05FzJX1Ai8keJumOLYc+HysPW2jX4F
         sgnGg7fwBe6939ORNMsmG57XfDtXbOesF68dEGuJ0yneH5uhiEQem6UTrsmlSW3usb8l
         mVqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770213418; x=1770818218;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iRrqXVZVX7Z3YtbKGBkBfsPXFsl6FxGibC0bf/QAItY=;
        b=PFIF6AWhNZkjvNb2NWdTi79PX91mtZ2aovR9mSUyfijZtoaCuJqVz2So7mc9O8mILx
         oVz4+e3OIWRAK80jmnQr85T4WU8eRzv1jvC7cBtwT4BQP5d8MurNjnNIaz2X6FL8USpF
         l/O7dqsU9cbqdOEvMslgjtqrSr+CTSONUN8GqaYWmqHIMm2UNlwW6FsBYOTJZzXdOZ6O
         yKWhfg0WnS/L0SH0wEY1/m13ufIK9posG885SK3WEODHZWNyP84HKpZcVWXMCOwrMjU4
         zE3sQgPdJkMJ1CqLmyeYP6mqd7usqXODNq4ANjb16lJsQiG7KJmz9jA+VbjciAt+TG7v
         A73A==
X-Forwarded-Encrypted: i=1; AJvYcCVl9+bg2LUGwxG6q7xtPq8eX9Ta9zsWjs2T0Gbz6S1iNxdv4iMHIwb9aZg83GOe8POF+mWaBoLgjvVC@vger.kernel.org
X-Gm-Message-State: AOJu0YwqI6/0qYW1P0ZvRcGnfC6fo3aAIW+WohG8fU0PB8aTb9JPq5MD
	VBFPPwrNQqwiSmq+1JoQCA9K5sJpQwTpckXe72UelKaspC4c2UJbjB1EJ6el1+RUdjw=
X-Gm-Gg: AZuq6aI9r0i+3gezOrrIrcKJfXzb1+KOMBHyAOtmrtLltnHml0LND2slUktsVbQ4OAE
	RN+rZ56QaCj0AnnvrLx+9eTgv7hQ6jr9yNx3Xx9yQo0N5TdPm3GK3udKelHmODYIAQ3Z05hzUlx
	HKhOUWsWq3H3p3l3FWPEUibPSl7Xk+UYeUhbTa+FqKTq4utdupk5vM8K5/qQ/dXVuR54vPU8svp
	8WyKGbyt9BHhiFZ5VhJIPbkZ+NkpQsDOuMK0a3W/BcJ0vpXt53/4dKsfXcQ/+MQrNDAIIYxGTon
	f2kNtN3/y3adBShehMQkaIZFXAW8LF7YPRTPG0eXVAkfEezws5PE7dyPTx5DQzYeVNoxUSDVjz2
	Ja5Exqq9JO2P0WLFY4DJ9BWiFEuyMp3NR8ewSBmBDV+6rJOnuIZlfJ4RiHEKRz5NWm/Xg+ZubSA
	FztooLIuJjkWf7erGaa1CqdDr479ZruSC/8TD+XuGt87f2vaPf7K9taCpVAUaTVFXKbvc=
X-Received: by 2002:a05:620a:3953:b0:8a1:21a6:e045 with SMTP id af79cd13be357-8ca2f82b068mr371751685a.19.1770213418187;
        Wed, 04 Feb 2026 05:56:58 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8ca2fa552f2sm187407785a.11.2026.02.04.05.56.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Feb 2026 05:56:57 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vndNJ-0000000H1He-18eG;
	Wed, 04 Feb 2026 09:56:57 -0400
Date: Wed, 4 Feb 2026 09:56:57 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Maxime Ripard <mripard@kernel.org>
Cc: Leon Romanovsky <leon@kernel.org>,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Alex Deucher <alexander.deucher@amd.com>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Gurchetan Singh <gurchetansingh@chromium.org>,
	Chia-I Wu <olvaffe@gmail.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Kevin Tian <kevin.tian@intel.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Alex Williamson <alex@shazbot.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
	amd-gfx@lists.freedesktop.org, virtualization@lists.linux.dev,
	intel-xe@lists.freedesktop.org, linux-rdma@vger.kernel.org,
	iommu@lists.linux.dev, kvm@vger.kernel.org
Subject: Re: [PATCH v7 0/8] dma-buf: Use revoke mechanism to invalidate
 shared buffers
Message-ID: <20260204135657.GE2328995@ziepe.ca>
References: <20260131-dmabuf-revoke-v7-0-463d956bd527@nvidia.com>
 <20260202160425.GO34749@unreal>
 <20260204081630.GA6771@unreal>
 <20260204-icy-classic-crayfish-68da6d@houat>
 <20260204115212.GG6771@unreal>
 <20260204-clever-butterfly-of-mastery-0cdc19@houat>
 <20260204121354.GH6771@unreal>
 <20260204-bloodhound-of-major-realization-9852ab@houat>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260204-bloodhound-of-major-realization-9852ab@houat>

On Wed, Feb 04, 2026 at 02:44:42PM +0100, Maxime Ripard wrote:
> > From what I have seen, subsystems such as netdev, the block layer, and RDMA continue
> > to accept code that is ready for merging, especially when it has been thoroughly
> > reviewed by multiple maintainers across different subsystems.
> 
> He said it multiple times, but here's one of such examples:
> 
> https://lore.kernel.org/all/CA+55aFwdd30eBsnMLB=ncExY0-P=eAsxkn_O6ir10JUyVSYdhA@mail.gmail.com/

Woah, nobody is saying to skip linux-next. It is Wednesday, if it
lands in the public tree today it will be in linux next probably for a
week before a PR is sent. This is a fairly normal thing for many trees
in Linux.

Linus is specifically complaining about people *entirely* skipping
linux-next.

> So, yeah, we can make exceptions. But you should ask and justify for
> one, instead of expecting us to pick up a patch submission that was
> already late.

I think Leon is only pointing out that a hard cut off two weeks before
the merge window even opens is a DRMism, not a kernel wide convention.

Jason

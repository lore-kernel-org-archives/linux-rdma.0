Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794752223;
	b=IoVVylKg0hgH9zzXj91v7ZqlnwU5s3DuGHJqUkR/VS7hGJjffqNQvsC/iale70soz2TW
	 i/MlNvvhxbAJu4DDTsj87G5kJ4uiZfJv6rr4sRjQ38ikLKiDQdnJi+tDwIupZp1m5logs
	 VoaCuYVdlY68/K/bJL6sVI+xy7u9gZ6BAKcFUgmmEf/Vl1WVh567YHscA4o/gnkWEcYAu
	 Z+lfogTsi8/nNRZToDXGWffsdRLNfx7/XACiZUo7076QME1lWnB09Xp5Q7i2vD3AKZzYg
	 Y3AQFKZ6YQj6hOg/ZvcS9D30h9YlJ4Ix6v70W3M/yN/gjFqGCXihzyE/evKt43TTaVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794752223;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=q9cg/E3QdjYcdsPXOKvO9DxZi0+4E1CzOv2QaSxS3r4=;
	b=4wKLGHR//jGiOXqLwZKPeNR1laNrqMrBpfiuITZymRLh5rEFp/wFsJ90wcESXIJ4cBGp
	 Jj9aoPOAKNAbWwsVApfvDrziAr+wD5BIF0dHHM+X3nRqFnk5WZcGxIYCtpaZxsbmeRrJb
	 LUtylJrVhjqH83xPsMdTtckRpbfWm9/A48/efi/wjvX6VX+lT3Y6VKEUqKmDWj2bYw99J
	 Dlc0JPmBkDSRPndmfavKxYYIyFze5RcM+E3MIpy6I053IY2ojyuFPz9EKLNRZ6s5dvUuq
	 CK8lwwS4zPXwYKe34LBTCvoEdHu2eCGA/4UrPWr8zEjsXwewrNKjNAbjVE09i2p4MXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DUrjT30Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ED3B606A31E;
	Sun, 15 Nov 2026 14:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DUrjT30Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D2281F000C4;
	Sun, 15 Nov 2026 14:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794752222;
	bh=q9cg/E3QdjYcdsPXOKvO9DxZi0+4E1CzOv2QaSxS3r4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DUrjT30Zvci5+/6jbWPZq8nRVvP5/whcNQiT9XiFOJOQgBetlpYbhEgonZwqnYdr9
	 ZVAuzmAqVrkFi7PJkmNF3biO8NCQJn69+2fySFXNENL6zHOaq81YFKcOF9QfrwQCHZ
	 2AuZfrPZPBTTAIFc8cHpKhChHUI6q85y+CY/tnqMQLpI9Ri8TOrYYM2xSzvUI1Q6dC
	 i1tQXJCwfrpZ7vszOFcSsltK1Ou2dHVHoONziqmHXt1oNrhp1XBNANlL5wWC9svQ6E
	 YRfe1dqZQsVELAaGi1nI5RjIIOF/lHslIGPL+NMgV5XogwCBw9dcSIs7j1+uXF03rJ
	 4lem6h3ZO8zSQ==
Date: Sun, 15 Nov 2026 16:16:59 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Jacob Moroni <jmoroni@google.com>
Cc: Jaeyeong Lee <lee@jaeyeong.cc>,
	Tatyana Nikolova <tatyana.e.nikolova@intel.com>,
	linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>,
	Shiraz Saleem <shiraz.saleem@intel.com>,
	Mustafa Ismail <mustafa.ismail@intel.com>,
	"Gustavo A . R . Silva" <gustavoars@kernel.org>,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] RDMA/irdma: publish APBVT entries after hardware setup
Message-ID: <20261115141659.GG42525@unreal>
References: <20261111092505.3121847-1-lee@jaeyeong.cc>
 <CAHYDg1SDOd_0ukm=7AX029Cr7Oc1UKoSpmd=iBz55C3DFzv_hA@mail.gmail.com>
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
In-Reply-To: <CAHYDg1SDOd_0ukm=7AX029Cr7Oc1UKoSpmd=iBz55C3DFzv_hA@mail.gmail.com>

On Wed, Nov 11, 2026 at 10:15:40AM -0500, Jacob Moroni wrote:
> Thanks. Looks good.
> 
> > +       entry = kzalloc_obj(*entry, GFP_KERNEL);
> > +       if (!entry)
> > +               goto out;
> 
> I think the GFP_KERNEL argument can be omitted here.

I fixed it locally.

> 
> Reviewed-by: Jacob Moroni <jmoroni@google.com>

Thanks

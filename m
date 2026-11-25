Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795597393;
	b=ueKa980kc4uY0mPWnCFNclVD+8BimEfD+mNGWsYo6me/fUf5eDL+9QoaXT6PYDNFXgb3
	 Bi2TQV47ZEc2dnnDrj9Qe4aP4QA956ScfvF+g1bU7sMbE7n1zGwuSlhnbzsF+Z6AFBZyE
	 WoycpRjcfvOP+O/VXYWeKEhyeVIMgFpuNUjlxupdUVH9+xJNHI2iAQ0JN9/7m9ABdozRP
	 w/I9DqiR9kDCfTgctzRciBBcdseo8jQi39cNglCrWuIoGZV8dmC6jH3lMsIZLHDJ7eY30
	 +Izv7ebHnzWPJD8VJ+M0T6dEjNq5NaVnCqBmC38xme0SNWgTDT+urQI/UiEl9AL33GQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795597393;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=H02Chv/kTDA9DNyv6i0SRF7smNMbCIr47MOJGSbJx7g=;
	b=wN6b3m/x6ILUzIv1YYlcwMO+7gWOodCmXo73WIywsg5sQPEldGT0PP+fGJbZxHKZyDy0
	 GfBdVLtupXHxuCHEEHcx7pCyJXWcw+3w0qOZd2WZBiOEExJ5Qjc+dH7BvLBzFUfMCcuyO
	 g765vcvERjSaYItd0xZ9FszF/wV4AcqEp8E9lHHWqlBhqIzdRXlH4VvkJjKYZeF0XaD6/
	 ntPRWt1DgL3H8sLcz9YO/RaYUiRqSOTpOfrn4wxecsZj2g6ZOUolfECeoQ2ESOGcWIPDT
	 TLj7vQr8c/6JfD+QUpTWdDcXAGV2fCnyA1Oue43ux7rZlSI3E+833k2phz3N9J82AVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kZHYfqPH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75BC9606A321;
	Wed, 25 Nov 2026 09:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kZHYfqPH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 801861F000C0;
	Wed, 25 Nov 2026 09:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795597393;
	bh=H02Chv/kTDA9DNyv6i0SRF7smNMbCIr47MOJGSbJx7g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kZHYfqPH+dc7uXBaf6gRnjtWGpXGyL+m1jB+cwCbIyh0Gy1d1DA4uMm8zftWc8TsA
	 bQZeodpCjiMZguGmiI7BzRriQ+56EcCzB5IfChJWE6JNsff3XGMMXnUzF/SQjsAfJo
	 bOheiIQPfQHCPIEx8fabZ+UN9chBeGV2C93wt1Qw1hvjlDwiU67xtv/dnsDXk8dSSw
	 52zaB6/C1+QP0qkZQ6xIFdChA9PnhplE7KnJ4SaLVPclwbXNWe+sFFF+aQ7jBimKgj
	 tnTciR/fEiI4QzhgV5J/6sT2azGR9NRUIPS1vi1llwbXP4pEkQzirBdsdFp2XhKpR6
	 FCqhEz5cTTXFg==
Date: Wed, 25 Nov 2026 11:03:09 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Yishai Hadas <yishaih@nvidia.com>, linux-rdma@vger.kernel.org,
	netdev@vger.kernel.org, saeedm@nvidia.com, tariqt@nvidia.com,
	mbloch@nvidia.com, kuba@kernel.org, pabeni@redhat.com,
	edumazet@kernel.org, davem@davemloft.net, andrew+netdev@lunn.ch,
	dtatulea@nvidia.com, moshe@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V2 rdma-next 21/21] RDMA/core: Report and enforce
 adversarial mode via GET_CONTEXT
Message-ID: <20261125090309.GY14811@unreal>
References: <20261117170914.27410-1-yishaih@nvidia.com>
 <20261117170914.27410-22-yishaih@nvidia.com>
 <20261122073156.GA12665@unreal>
 <761ca80e-a772-41f3-b8e9-cc332e4ba5d9@nvidia.com>
 <20261124125327.GR14811@unreal>
 <20261124125950.GC9566@ziepe.ca>
 <20261124133353.GT14811@unreal>
 <20261124134751.GJ9566@ziepe.ca>
 <20261124140906.GU14811@unreal>
 <20261124143024.GO9566@ziepe.ca>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261124143024.GO9566@ziepe.ca>

On Tue, Nov 24, 2026 at 10:30:24AM -0400, Jason Gunthorpe wrote:
> On Tue, Nov 24, 2026 at 04:09:06PM +0200, Leon Romanovsky wrote:
> > On Tue, Nov 24, 2026 at 09:47:51AM -0400, Jason Gunthorpe wrote:
> > > On Tue, Nov 24, 2026 at 03:33:53PM +0200, Leon Romanovsky wrote:
> > > > On Tue, Nov 24, 2026 at 08:59:50AM -0400, Jason Gunthorpe wrote:
> > > > > > > RDMA/core: Report and enforce adversarial mode via GET_CONTEXT
> > > > > > > 
> > > > > > > In adversarial mode the NIC is not trusted. As the kernel protects its
> > > > > > > own code from it, user space has to protect its own area, e.g. the data
> > > > > > > path that polls CQEs directly from the HW.
> > > > > > > 
> > > > > > > Hardened user space might use a different data path, with extra checks,
> > > > > > > and support a smaller surface. This isn't needed for a trusted NIC, so user
> > > > > > > space must know when a device is in adversarial mode.
> > > > > > 
> > > > > > This information is part of trust level series. Why is this a “must” in RDMA UAPI? 
> > > > > 
> > > > > Userspace has to work differently if the kernel driver is in the
> > > > > adversarial mode, and the kernel should not permit an old non-supporting
> > > > > rdma-core from loading to prevent a security downgrade.
> > > > 
> > > > I understand the first part of the sentence above, but the second part is
> > > > unclear. Why should this prevent it? In adversarial mode, the kernel simply
> > > > isolates that device from the others.
> > > 
> > > Userspace needs to do it too or it is not a complete defense.
> > > 
> > > > Moreover, the kernel cannot determine whether rdma-core has actually been
> > > > adapted. A locally cloned version of rdma-core can set the new adversarial
> > > > flag without changing the old, legacy version.
> > > > 
> > > > Once that flag is set, the kernel allows the patched rdma-core to proceed.
> > > > Therefore, saying that it “should not permit” this makes no sense.
> > > 
> > > If someone makes a non-official version of rdma-core that doesn't work
> > > securely then I don't care one bit.
> > > 
> > > I care that the official versions are not improperly mismtached to
> > > give something insecure.
> > 
> > You explain why rdma-core needs to know about adversarial mode, which is
> > fine. However, you also say that rdma-core MUST send this new flag back
> > to justify the statement, “The kernel should not permit an old,
> > non-supporting ...”.
> > 
> > However, in your last reply, you said that the kernel does not actually care about
> > the rdma-core mode.
> 
> What do you mean? This is a mechanism to help the user manage software
> versions by not accepting incompatible rdma-cores.

Please take a look at the patch.
User space provides that new adversarial flag.

+	ret = uverbs_get_flags32(&ctx_flags, attrs, UVERBS_ATTR_GET_CONTEXT_FLAGS,
+				 UVERBS_ATTR_GET_CONTEXT_FLAG_ADVERSARIAL_SUPPORTED);
+	if (ret)
+		return ret;
+
+	if (ib_dev->adversarial_mode &&
+	    !(ctx_flags & UVERBS_ATTR_GET_CONTEXT_FLAG_ADVERSARIAL_SUPPORTED))
+		return -EPERM;

...
+	UVERBS_ATTR_FLAGS_IN(UVERBS_ATTR_GET_CONTEXT_FLAGS, u32,
+			     UA_OPTIONAL),

The kernel does not care whether rdma-core is up to date. It works either
way, so why should we prohibit older userspace on these systems?

> 
> It is not a security mechanism to hard guarantee that rdma-core has no
> bugs.

It is you who talked about "... security downgrade ...".

Thanks

> 
> Jason
> 

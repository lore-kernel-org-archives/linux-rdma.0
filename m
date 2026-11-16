Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794837234;
	b=NIrMgJwrgnGYzZqpnzfbELhgz/uxMk/33wOLI04Uz5WR8P21TQC7Vnw8zdGiRSEMV73y
	 PcAb1cEpC+x8JWo5pSXrwi92wVk7sEwQFxvpJlm+2oQdhHG46GEWCNUNn4gfqgaX+AXu1
	 IMhLp9jyBOudwz9P2wZQ5VzNh0zISLZDkErcWwZ/SGQlp6mjLpshtEzXUGc1r5Bm54rHr
	 GfIQUktFyIl9NR8dCFjwpESY/UbUGU1Z+DNfqCbrxhDtoDED7eEfys7uprDk4quzkpD+0
	 Pl58d1uT7Gort94Er1qbNCwloSi4CvUrX3D5Plf8WC21ciPQYOJHkI+d8u70vm8cbxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794837234;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=DDlc2ipa3lyHVuvf17z6/jobZjt8tJOUrFDDN7JBUPg=;
	b=sD4zL/W9AtCVQf24z01hZ4KO9DZq4gj/TAOTUMan3LVXSx9dWIK0p/eWHNwGKo79PbTt
	 yCm/b0AP6Jhz9BV+GYWqzozQz+TY4ckhHCxujJvAndwwZSexZsU2yCE4ilLTjvL6o673B
	 ypn13rCSh1u7ipl4nksEyokmDjx4FRZqe3dS2Gvzu6WMbURVbMtVcmWmg3zC8wmESM2gh
	 rdy3DqKf0mUKLqsYJwQzvL94yHEBfLWshereZNptyagu3uLNXWSaqhwcQ2EY3TdG0NXKg
	 X2YYQofIIOv0iQ119MN3s4hPz1hFRyE4qak18894tYYZK8XsHl39A0qXn3e8pqmEnqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=orxncKwf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB3ED606A323;
	Mon, 16 Nov 2026 13:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=orxncKwf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAFC61F000C5;
	Mon, 16 Nov 2026 13:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794837234;
	bh=DDlc2ipa3lyHVuvf17z6/jobZjt8tJOUrFDDN7JBUPg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=orxncKwfJxb1Poi7aCW5qJLpiLznZFOZgYLbZKVwjOPt4pjzKtV4/RPv17w7WVzsC
	 pZzX6H4QbeTLyWW6bkEgohhqwdIBMQ+sorzsiImhuW3QddKTMEzankDmeMMO2sCiyw
	 G0a+efSqS+IyJGClThreYHl6e+fhE7inB5fBdVwHyPR6Yloltlgnizjtad869qD1Cr
	 2D0VB7omtzwxeGBcJbJpBnP6mdcIrCVjmVOl1xvHXBCvuI9fOLl3+aukiVubuUQqW8
	 pP6hZy6c6zn6o5+1MZTY2Ycv9GY9Ii/+aYQVXkBcI9PEnfWgiRNk9qdeDfTJJ3o5OO
	 7JFuImKAgsDCQ==
Date: Mon, 16 Nov 2026 15:53:50 +0200
From: Leon Romanovsky <leon@kernel.org>
To: Abhijit Gangurde <abhijit.gangurde@amd.com>
Cc: sashiko-reviews@lists.linux.dev, linux-rdma@vger.kernel.org
Subject: Re: [for-next 3/4] RDMA/ionic: allocate a PD-scoped DMA MR
Message-ID: <20261116135350.GP11319@unreal>
References: <20261107150249.1576835-1-abhijit.gangurde@amd.com>
 <20261107150249.1576835-4-abhijit.gangurde@amd.com>
 <sashiko-outbox-203825@kernel.org>
 <2770c6d3-f595-5d6b-afec-dfa8fee30697@amd.com>
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
In-Reply-To: <2770c6d3-f595-5d6b-afec-dfa8fee30697@amd.com>

On Mon, Nov 16, 2026 at 02:47:15PM +0530, Abhijit Gangurde wrote:
> 
> On 11/8/26 20:34, sashiko-bot@kernel.org wrote:
> > Thank you for your contribution! Sashiko AI review found 1 potential
> > issue to consider:
> > - [High] RDMA/ionic: build failure in ionic_fill_lif_cfg() due to
> >    missing rdma.cap
> > --
> > 
> > commit 71ee46b9e5e60e185b9553d17b2722a569d100ad
> > Author: Gregor Dick <gregor.dick@amd.com>
> > 
> > RDMA/ionic: allocate a PD-scoped DMA MR
> > 
> > This commit allocates a PD-scoped DMA MR via CREATE_MR with
> > IONIC_MRF_DMA_MR when the firmware advertises IONIC_GEN_CAP_DMA_MR.
> > 
> > [ ... ]
> > 
> > > diff --git a/drivers/infiniband/hw/ionic/ionic_lif_cfg.c b/drivers/infiniband/hw/ionic/ionic_lif_cfg.c
> > > index 66cee57442e7a..dcf54856603d4 100644
> > > --- a/drivers/infiniband/hw/ionic/ionic_lif_cfg.c
> > > +++ b/drivers/infiniband/hw/ionic/ionic_lif_cfg.c
> > > @@ -95,6 +95,7 @@ void ionic_fill_lif_cfg(struct ionic_lif *lif, struct ionic_lif_cfg *cfg)
> > >   	cfg->rq_expdb =
> > >   	    !!(lif->qtype_info[IONIC_QTYPE_RXQ].features & IONIC_QIDENT_F_EXPDB);
> > >   	cfg->alloc_qid_cap = ident->rdma.alloc_qid_cap;
> > > +	cfg->cap = le64_to_cpu(ident->rdma.cap);
> > >   }
> > [Severity: High]
> > Does this break the build when CONFIG_INFINIBAND_IONIC is enabled?
> > The rdma struct inside union ionic_lif_identity in
> > drivers/net/ethernet/pensando/ionic/ionic_if.h has no cap member.
> 
> Patch 1/4 adds __le64 cap to ionic_lif_identity.rdma (replacing reserved
> bytes). Patch 3/4 uses that field, so the build succeeds when the series is
> applied in order. This appears to be a series context false positive(?)

I don't know, maybe because net patch was involved.

Thanks

> 
> Abhijit
> 
> 

Received: from mail-qv2-f42.google.com (mail-qv2-f42.google.com [74.125.230.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D0CD352C28
	for <linux-rdma@vger.kernel.org>; Mon, 28 Sep 2026 17:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790616583; cv=none; b=CBd9SDUduEQlfSvD60KTDB5e+dckAofqcRxUADSLHd6wvOYzThgo1gN2urRVKbgiRU79AY8kkk+Iof/axRrKxzqzPa/XjYYAFx9Fq0RU2RiwQjHx2EOypvOH0CoTtNy2ajZc4aj/CWN3kV/H2xcdvsMoOrSWCNhVqUzqfRnUYVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790616583; c=relaxed/simple;
	bh=SKQB0mEZagqmGsDNZPnaWe7gUble3NHrhIKbwNSH1Jw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YoeXCtkSLscwerYPDGq3F3GTJzNIne1wzqJ1jEoNbrdOABd8Rlkw15pw1bzV/iDqbl84Mjnfgcm35BHHR09xaB/QiSx1dJH/FzT0haAiffnPh7RRz6ckK65toqlWxw5kiS3HfCzEeaIyF92QwUWAqdT6kzC5CMq1hn0OxXMSUFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=AXmJdboN; arc=none smtp.client-ip=74.125.230.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="AXmJdboN"
Received: by mail-qv2-f42.google.com with SMTP id 6a1803df08f44-914488d0455so23108376d6.2
        for <linux-rdma@vger.kernel.org>; Mon, 28 Sep 2026 10:29:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1790616581; x=1791221381; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=F8wHi2lHLlVmnngzxn3a4naORn9qZPczzGL0TvCk5Do=;
        b=AXmJdboNcWfKQqwuUPCXX6Rn93Y/ElzgHMYokUjabBvqd2Xqe8xSV+pwcD0LXzNZW2
         8viM3Ku+mp73QMATFvmcekMooi2y7DURd7K97gX6ogo9XH/0i80JoLcUwLr14lwGgje2
         uXVL+jaLV2cPhsmHFcgkWM1+NQflhZkSRUkCpfI6fR8UBC5ZOrsLx/3Zp6rgE+ZXQW+v
         YZZAFTIec7nOUhTYT0SSMxVudqvgh/VKoBxSo48Ry8BMg9KgFWpnIKlEW+yJW/Db4J5B
         fSF7H1/lLqMh9MrlEVrvnSqWdih01PAd0RdYO/AaK8rLLHEvulSG7LoKrZ/8QZ6sCiln
         1a5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790616581; x=1791221381;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=F8wHi2lHLlVmnngzxn3a4naORn9qZPczzGL0TvCk5Do=;
        b=xJ+aBW2JhKJLmjwQHYmVjmN0xWQO3BsI2PRg67Ic9XaTIX80czHn2+/to2UM3BgsPZ
         PHDUZxw3c28pMmFJG5vRAL2OOJuWgebY6PW631eYaMt6UcgA6DjCJcyRu+7iIvUdRNoa
         AXZiEm9lInPMtowCGiju7OpG1Cx95LRLd8HxzySikME8LiM8GjTv5DnU4Zlzn7XOSzLP
         8Ordjo3GiMKcPiYy8qbYIMAMviQSePlIgFPvG6ibrslanxZNwI21RMl5e8MKvtvni4o/
         ZKcwm0MWsnsO0fJjwTlGVxZSliTtWag3EQWRAd9tokvOZ2Emi2+iiMwJx+slqlN1m07r
         DejQ==
X-Forwarded-Encrypted: i=1; AKwUvBw8BBW+CZxy1KvWFMgsyxe3FGGJcQomrwyAh4YLX/p5np/M3LilzxauG+w6aEOQN9rRXbINR6TCH3Hh@vger.kernel.org
X-Gm-Message-State: AFuF++kO4abAC9ySc/wGMUKha3l96ECDQ6D0cP7+gdc1FFO+QYc3Mpck
	r368XPOG2X1KgT8DL7YcQ8UDvco6aIt1chnxdaHPDY+RB886skVZVvWG0Yn/egsU2Kk=
X-Gm-Gg: AYBFou0mJjtEq9vccA7KWjG1OYvSyTghuplT8iD3wxFs87kO9GWVF2iIIPk/P1apU4j
	Ca5RVJeec9wAWlHyXiSfye4/2ETZOVt3URb1AY1JXr2FjmfwmZd+euw1CB2GT7TXeSPQuCHJu2w
	mdfkFJ5l5+5IYta9YtdpaPySfQAJ5dTTLIVKUk4KnNkt25b0fEWaWccJ0J0KPJ1EDooZLJV4ywV
	1N7OK2PKfiAXbGFjS2uV3UisHrfp74n+/qViF+PschWEaF9MRBorshxrUDoQ8LZB0PkrgC4zF8Z
	digqoCoc8ZkN5yZcrDeZehmZJE8nzyqvHKB4ZKhmanlmmZoyLUN8GjqWyviItvs7h0AahHY4Vxz
	c97glKiSZ2Wmua4+Co5U7sBnVibBpXflX72MsfJTBfeEz0rB9TlzLudavLHgakoI7RMkSiSPyLJ
	+lSwsDYWTKzVH3E8wsbSfL4ZfmV32R85ZDrJABL1C0zqPp
X-Received: by 2002:a05:6214:19c6:b0:916:7629:f1c with SMTP id 6a1803df08f44-91676291098mr52487856d6.10.1790616581176;
        Mon, 28 Sep 2026 10:29:41 -0700 (PDT)
Received: from ziepe.ca ([130.41.10.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91430df77adsm84361036d6.26.2026.09.28.10.29.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 10:29:40 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xBFAZ-00000007NhG-43XU;
	Mon, 28 Sep 2026 14:29:39 -0300
Date: Mon, 28 Sep 2026 14:29:39 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Zhiping Zhang <zhipingz@meta.com>
Cc: fengchengwen <fengchengwen@huawei.com>,
	Leon Romanovsky <leon@kernel.org>,
	Michael Guralnik <michaelgur@nvidia.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Christian Konig <christian.koenig@amd.com>,
	Alex Williamson <alex@shazbot.org>,
	Bjorn Helgaas <bhelgaas@google.com>, kvm@vger.kernel.org,
	linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org,
	dri-devel@lists.freedesktop.org
Subject: Re: [PATCH v13 5/5] RDMA/mlx5: get tph for p2p access when
 registering dma-buf mr
Message-ID: <20260928172939.GK163130@ziepe.ca>
References: <20260731211601.3033906-1-zhipingz@meta.com>
 <20260731211601.3033906-6-zhipingz@meta.com>
 <f4ff7ced-63b6-42e6-8e01-9f01d2e59843@huawei.com>
 <CAH3zFs24esHCGA=wPrkiH8oKQCv7SnOwcBbkMxrOEvOVtwstYg@mail.gmail.com>
 <20260924233058.GA163130@ziepe.ca>
 <CAH3zFs2rhg6-b-pVDps1V8LsM4Dn48t4J4LFVyKOZtT4axdY=Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAH3zFs2rhg6-b-pVDps1V8LsM4Dn48t4J4LFVyKOZtT4axdY=Q@mail.gmail.com>

On Thu, Sep 24, 2026 at 11:17:57PM -0700, Zhiping Zhang wrote:
> On Thu, Sep 24, 2026 at 4:31 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
> >
> > >
> > On Wed, Sep 23, 2026 at 11:24:56PM -0700, Zhiping Zhang wrote:
> > > I don't think this belongs in the importer. Every in-tree dma-buf
> > > caller of pci_p2pdma_distance() is the exporter, in its .attach,
> > > clearing attach->peer2peer -- amdgpu_dma_buf.c, xe_dma_buf.c,
> > > habanalabs memory.c. There is no importer-side caller.
> >
> > Right, and they shouldn't be doing that, but it still has to be
> > checked that the st is going directly to the peer device not the host
> > bridge. Not using the distance, but by the PCI_P2PDMA_MAP_BUS_ADDR
> > indication.
> >
> > I fear you will need some of Leon's series to make that happen.
> >
> > So probably the proposed change to dmabuf ops is far too simple.
> >
> > Jason
> 
> Hi Jason,
> 
> Thanks for the comments.
> 
> Agreed -- the tag should not be handed out unless the routing is
> PCI_P2PDMA_MAP_BUS_ADDR. That can be enforced conservatively on 7.3
> with two changes. I can fold both into patch 4.
> ```
> In drivers/pci/p2pdma.c, make pci_p2pdma_map_type() callable from
> tristate VFIO_PCI_CORE:
> 
>     EXPORT_SYMBOL_GPL(pci_p2pdma_map_type);

No, that's been rejected several times already.
 
> and in drivers/vfio/pci/vfio_pci_dmabuf.c,
> vfio_pci_dma_buf_get_pci_tph() gains:
> 
>     struct dma_buf_attachment *attach;
> 
>     if (list_empty(&dmabuf->attachments))
>         return -EOPNOTSUPP;
> 
>     list_for_each_entry(attach, &dmabuf->attachments, node)
>         if (pci_p2pdma_map_type(priv->provider, attach->dev) !=
>             PCI_P2PDMA_MAP_BUS_ADDR)
>                 return -EOPNOTSUPP;
> ```

Also no, this has to be done via PCI_P2PDMA_MAP_BUS_ADDR which also
enforces putting the determination in the right place in the code
flow..

> Two properties are worth stating explicitly:

Ah! AI!

Jason

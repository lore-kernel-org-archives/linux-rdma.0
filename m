Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794929589;
	b=AFZIkxP2nLNsq2HyuzG4GqAGqwDoA2QsH2ybbiN136cwz3ZKydwJvCSRBOkNi3jgcyj5
	 h8FnFb+50rzs1dzBVL+2eM6sOM3u+6nmRay1/6j/g9yWd+++UEJ8dEMyOdOo6e3XrFaJz
	 h2mxlatejVHmHqiYbx13HbIIny7qDECuxk+sM//Lrj6SzqLd802ZYIyhii7QHNBi7pE2P
	 7y79U5SNvVNlJ6t9qGwvpP8V8sjepdFnNr3//lHmj1ndU4+jHwv7O/pyr0wwct1Sqyxbf
	 +WxVnT3nHERXUKAUCKpbiTsd3lkS7iSkcQCtTpFg+s1qH1nZKOVI0kI88/K7UAl5azQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794929589;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:Mail-Followup-To:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=ic0ZV2l8vdmrXTqu+lMUrh7Ne4ma2q8MNEr28fS3hxw=;
	b=VAaA8LcTU9EdO2jG4NAt/fDn0GN9MZSkb6EI08Qm0oa2vLuQzN0TVW+W0oIuOgvtMmSv
	 CHAfwolmIy1DHjhr+b5zhJhhsX0cUTCnetJ4dIMFsiKJXlnE5XcZ2Zwv3MKVeybbZnmRp
	 ATap9PKxDrw/nnV1ick2cvKdIuKHz/h4UzmRnt5HEhoLZkHjilMXRd9+hYnpxdHjRqvTf
	 g2TUpd3XdwFuz6MwP41jGdrlVZIrxeY0rjhWzbq9oaWRCi0nEPfs6uiMW/gPeAnVIkxIf
	 GS272U3V47ai5ZVexRlqqn2IUdFeZns+X/SY4xdA6s71aoATmky2LmjGgOrQCfg2MzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=dama.to;
	spf=none smtp.mailfrom=dama.to;
	dkim=pass header.d=dama-to.20260707.gappssmtp.com header.i=@dama-to.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b="Nq2As/OY";
	arc=none smtp.remote-ip=209.85.210.177
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49D38606A32C
	for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 15:33:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 49D38606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dama.to
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=dama.to
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dama-to.20260707.gappssmtp.com header.i=@dama-to.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=Nq2As/OY
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-8b32bc605d9so2291390b3a.2
        for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 07:33:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dama-to.20260707.gappssmtp.com; s=20260707; t=1794929588; x=1795534388; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:mail-followup-to:message-id:subject:cc:to:from:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ic0ZV2l8vdmrXTqu+lMUrh7Ne4ma2q8MNEr28fS3hxw=;
        b=Nq2As/OYS8Rk/AJs+LfYrpJSfF6Buvx+xKdbIX4flq+eZrRjURbUNWDmvARrjsOMyp
         G4Gx7PLMS4t+lD5oQcYMVZipAItazYPQ/M4meWE5SJxFxatVGe9ROPR8uYtsVXSKDFFO
         ktD3ViGsehj7fvmOS+rsJFzMQP/LL7SrApPeoCrIZkRytaDjhZQ0X7IYsR5XOepFhFt+
         JKJ3eI8Od+PvKhxlcvAMz0AvFtM/rG8vP7w8MNFXVtYOsThIy0qp3z1ylgviHTV2ORwT
         6txojRUx4fE/Wz5UNh/Mhq0JSCVkqHb7tGYrHXiJfW2XoLH9t7s6zh9hLk+TgqK7sshF
         VhkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794929588; x=1795534388;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=ic0ZV2l8vdmrXTqu+lMUrh7Ne4ma2q8MNEr28fS3hxw=;
        b=o3s3GFwr+8WmkXHuA3DiOvUGH+nA3VLLaq3NUosxOOetjAmx1JurPPTTh/IyxiJ3sH
         YzkYb6b/d/3f4iUdpo9nyy3N8ORJNccLnHGzMLds5BaVd/PicpMjhUeY9Dgx6vht1jEo
         qBsPGRRuWCCgrIkRBBhtrwEbG4cscRg+QrogiU0xpoQN4Ts/cHJzE6cENKWS4+V/WkFp
         7A+aKIfS8q7GIP23ag95esfl2jbuoYtngl6zA1ktZC99A8vcth7FbZwDaXBpUqLDhHpe
         U/G2nOtulqbQ8pISEOQFCeOyPyMCHqE9JMIG0VjNH018u1hkpqe9U58Eq3B3CnTL7DBu
         7iQQ==
X-Forwarded-Encrypted: i=1; AL+hErE4y2jTGLamzwn0o4HuS+l+AGb1EfmhEwI8au6vJMt9BJrlZSvSgPZpGpI6XV38ZomDNN+peU2n1cxO@vger.kernel.org
X-Gm-Message-State: APuU4Z94fcy+hKyK31hhIl5Be2abhtQNFM1OggRmkbB4LJ9oXI6z2uI9
	HpOugbqArKEfOlAPgz5v2FrQ/S+zBuZ9MK3TwJUUMU4X3kkQIaN+gJs3GceHznw6+44=
X-Gm-Gg: AYBFou0Wlqe0oI+lz/AO8313liPkLfX5AciaYjDDK+KREhZ7i6HvBfdsMfkuCRUctu6
	gehCN96IdRA/hPN4Y0jXdrTmThP1kz0LJO5zvYg4DXCZdJk43XBzZdW3as4KoVWmq2+2pbpwfBS
	0FWsNzX9DFOEppaoGnbVLKlJ04nEN9K1BXCsiv3YfY58tObFEAwrkVavgwska+RfLJ2KKievJTh
	iFJ6Icw/Y7ENZXAMMjbJhAWUDmIsu6Pt7ATDduSCjPH424BBUPw3fBkZCO7l+u5/Uw72ZweP83a
	0cgNquKA1/Xyio4+VmjgS09SY1ttbSr7RpAhGgFRQzBkdJfUKmOUXe/pJuqJx7rUOJUZMrsTi/I
	PuuGpSkB+mTO2piDeHUuNwWKkIPltT0uvFPFHokeAD6exlEKSG87dYremKH6a5maH7RLMjCVTcn
	9m+SVcaq9jmAYWcP+XnpajG2Y02KcOAhaOXmEwEIGv1hM3JtRhGNGSF/AEO66GGqISlclg8+ueC
	MsGrzWgve/fTMH8wKHC2O7oYG8lXAAyp0WmgTkMLGtYBV/UmblqivuDZC3a3FpR6PTL9iPHdTbh
	bpP48+qQzapfgXQJVLKaQmAr04knteJKJKc87skNdQ==
X-Received: by 2002:a05:6a00:17a8:b0:8a0:70ff:ab2c with SMTP id d2e1a72fcca58-8beb7e12866mr12534223b3a.57.1794929588396;
        Tue, 17 Nov 2026 07:33:08 -0800 (PST)
Received: from localhost ([2a03:2880:2ff:3::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8bed12a8f63sm5517226b3a.9.2026.11.17.07.33.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 07:33:07 -0800 (PST)
Date: Tue, 17 Nov 2026 07:33:06 -0800
From: Joe Damato <joe@dama.to>
To: Daniel Machon <daniel.machon@microchip.com>
Cc: netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	edumazet@google.com, horms@kernel.org, linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next 5/5] net/mlx4: flush pending doorbell when
 dropping a TX skb
Message-ID: <avxzsj1Ro8Mzazmz@devvm20253.cco0.facebook.com>
Mail-Followup-To: Joe Damato <joe@dama.to>,
	Daniel Machon <daniel.machon@microchip.com>, netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	edumazet@google.com, horms@kernel.org, linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org
References: <20261110231304.1859217-1-joe@dama.to>
 <20261110231304.1859217-6-joe@dama.to>
 <20261112134346.zvctvknj4mc5s2pm@DEN-DL-M70577>
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
In-Reply-To: <20261112134346.zvctvknj4mc5s2pm@DEN-DL-M70577>

On Thu, Nov 12, 2026 at 02:43:46PM +0100, Daniel Machon wrote:
> > If mlx4_en_xmit drops an skb (for example because DMA mapping fails) and
> > that skb happens to be the last one in the batch, the doorbell for the
> > WQEs posted earlier in the batch isn't written.
> > 
> > The queue stays awake, though, so those WQEs are eventually announced to
> > the HW after the next TX, but that depends on traffic and could induce
> > latency.
> > 
> > Avoid all of that by writing the pending doorbell in the drop path.
> > 
> > Signed-off-by: Joe Damato <joe@dama.to>
> > ---
> >  drivers/net/ethernet/mellanox/mlx4/en_tx.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/drivers/net/ethernet/mellanox/mlx4/en_tx.c b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
> > index 123071a47bed..3166837711be 100644
> > --- a/drivers/net/ethernet/mellanox/mlx4/en_tx.c
> > +++ b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
> > @@ -1135,6 +1135,9 @@ netdev_tx_t mlx4_en_xmit(struct sk_buff *skb, struct net_device *dev)
> >  
> >  tx_drop_count:
> >  	ring->tx_dropped++;
> > +	/* an earlier skb in this batch may have deferred the doorbell */
> > +	if (ring->doorbell_pending)
> 
> I think checking !netdev_xmit_more() here would let you ditch the new ring
> state, but it seems bnxt does it the same way, so fine by me.

I need the state for the SW USO followup I mentioned in the cover letter.

That aside, every mlx4 doorbell site today writes it only after posting at
least one WQE. I think replacing this with !netdev_xmit_more() might write a
doorbell with no new WQEs and idk if that is supported by the hardware. It
looks like the XDP path gates against that specifically.
 
> > +		mlx4_en_xmit_doorbell(ring);
> >  tx_drop:
> >  	dev_kfree_skb_any(skb);
> >  	return NETDEV_TX_OK;
> > -- 
> > 2.53.0-Meta
> >
> 
> Reviewed-by: Daniel Machon <daniel.machon@microchip.com>

Thanks

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3E6B3C3443;
	Tue, 13 Oct 2026 10:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791886843; cv=none; b=QVZmDyCam9ygisOtjZ1wkUTjO9u4xgyvOqCBodyeMqWU3Zw0N/mXo5uTltc/VOS3tekzbkspdrbKnH/UNNdBIfUoyAAOu4SCLTG7DXTnTG20PDwfSmOnAbD/HpTFoigplkp1QjrXRFMp8CvgIRSM15yrPAcxE2xPDC36tlWp6JY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791886843; c=relaxed/simple;
	bh=1n0+o9IuXJ5uHNAvYROm434hYktLq2UIIv/znUV3Sq0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UMJF7ewAIvUFFzwHC/dVw/q/CekyvQhP5Arf92F9Gxv4V2brpuSh7iZsWmDSklqpWo/stJVaYPluS5rBRQ46A9DeyzySnpwRnHb61Ej1DSqs8FTOPtT1AaRs79es8XdrYeSuAS3sOBiLpKqW+DVZKjF7/uRmVZVDm2u8LzmirVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i3NVT5Ho; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i3NVT5Ho"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E9F51F000FF;
	Tue, 13 Oct 2026 10:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791886842;
	bh=AVAYNwUMQ+BeeMqt1ft6Fv+OqKfgqLgMQ0pa+yPgBYQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=i3NVT5Hohfe+3z5wZCd3vGfBthmqLEh2b3JvScE5dr0aMuYEzV+Lh4QRHZjoJVbAR
	 G66xxrBnVLNx9ysoMoQVTIy/ZmDUoZ/Acy8jddanbY1k75/bqJ44INvnbs5T4pggmN
	 vtI0AXeMH9ZPgiNVSIJGCl27/sumFjVoV+mjuaH8FHFACVvMa9ohJGGSuQBGK5Sr5i
	 O+JvZ53EkQJ806n3goae3vZHZMpyEchr12loY8IdhhnC+dPpvkdhEaM3cLUHFF+8DY
	 g/beHBdoiNx8x8VwtrzS7Mo7+Tk1fswzN3twB7vO/3uO2BdWzMP/+nN/R9KvAqETRw
	 9BMN7imnYr5eA==
Date: Tue, 13 Oct 2026 13:20:36 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Jinpu Wang <jinpu.wang@cloud.ionos.com>
Cc: Serhat Kumral <serhatkumral1@gmail.com>, haris.iqbal@ionos.com,
	jgg@ziepe.ca, danil.kipnis@cloud.ionos.com,
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RDMA/rtrs: Use strscpy() to cache the HCA name
Message-ID: <20261013102036.GL219304@unreal>
References: <20261009131715.39217-1-serhatkumral1@gmail.com>
 <20261012080826.GB219304@unreal>
 <CAMGffEkYWj77M5V_p9W+i=_pKEg+seVV1S_EaFro9-feYaki9Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMGffEkYWj77M5V_p9W+i=_pKEg+seVV1S_EaFro9-feYaki9Q@mail.gmail.com>

On Mon, Oct 12, 2026 at 03:11:05PM +0200, Jinpu Wang wrote:
> On Mon, Oct 12, 2026 at 10:08 AM Leon Romanovsky <leon@kernel.org> wrote:
> >
> > On Fri, Oct 09, 2026 at 04:17:15PM +0300, Serhat Kumral wrote:
> > > As the comment states, the HCA name is cached for sysfs. Use
> > > strscpy() to copy it directly without unnecessary formatting and
> > > avoid interpreting format specifiers in the name.
> > >
> > > Fixes: 6a98d71daea1 ("RDMA/rtrs: client: main functionality")
> > > Signed-off-by: Serhat Kumral <serhatkumral1@gmail.com>
> > > ---
> > > found by smatch:
> > > - drivers/infiniband/ulp/rtrs/rtrs-clt.c:1906 rtrs_rdma_conn_established() warn: call of 'scnprintf' with non-constant format argument
> > >
> > >  drivers/infiniband/ulp/rtrs/rtrs-clt.c | 4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/drivers/infiniband/ulp/rtrs/rtrs-clt.c b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
> > > index 927e3f30483c..c85e22f670ba 100644
> > > --- a/drivers/infiniband/ulp/rtrs/rtrs-clt.c
> > > +++ b/drivers/infiniband/ulp/rtrs/rtrs-clt.c
> > > @@ -1918,8 +1918,8 @@ static int rtrs_rdma_conn_established(struct rtrs_clt_con *con,
> > >                * Cache the hca_port and hca_name for sysfs
> > >                */
> > >               clt_path->hca_port = con->c.cm_id->port_num;
> > > -             scnprintf(clt_path->hca_name, sizeof(clt_path->hca_name),
> > > -                       clt_path->s.dev->ib_dev->name);
> > > +             strscpy(clt_path->hca_name, clt_path->s.dev->ib_dev->name,
> > > +                     sizeof(clt_path->hca_name));
> >
> > Haris, Jinpu
> >
> > These names shouldn't be cached.
> 
> Leon, you mean the hostname could change at runtime?

Yes, users can change the hostname at any time. However, this code caches the
`ib_device` name, which can also change at any time.

Thanks

> 
> >
> > Thanks
> >
> > >               clt_path->s.src_addr = con->c.cm_id->route.addr.src_addr;
> > >               /* set for_new_clt, to allow future reconnect on any path */
> > >               clt_path->for_new_clt = 1;
> > > --
> > > 2.53.0
> > >

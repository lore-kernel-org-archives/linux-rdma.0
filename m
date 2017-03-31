From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Extend LID space in InfiniBand beyond 48k? Is this really
 possible?
Date: Fri, 31 Mar 2017 04:25:27 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB10E3F7@ORSMSX109.amr.corp.intel.com>
References: <b9531f99-c350-3985-edae-296b1bc97509@simula.no>
 <20170330040409.GL20443@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170330040409.GL20443-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vangelis Tasoulas <vangelis-S8y2klWGCOFhl2p70BpVqQ@public.gmane.org>
Cc: Linux RDMA Mailing List <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > I was reading a year+ old article where Steve Scott (CRAY CTO) was
> > interviewed here:
> > https://www.nextplatform.com/2016/01/08/cray-cto-connects-the-dots-
> on-future-interconnects/
> >
> > At a certain point Steve mentions (or at least that's what the
> article
> > claims):
> >
> > /InfiniBand has another limit in terms of the number of logical IDs,
> or
> > LIDs, it can support, which is around 48,000 end points, and for the
> > most point, people have stayed within that limit. There is an
> extended
> > version that has some higher packet overhead that can go to higher
> > scalability./
> >
> > Is this true? Is there any reference that one can point me to for
> the
> > part of the "extended version that has some higher packet overhead
> that
> > can go to higher scalability"?
> >
> > To the best of my knowledge, there is no extended version defined in
> the
> > InfiniBand specification. What is mentioned is that /The unicast LID
> > range is a flat identifier space defined as 0x0001 to 0xBFFF./
>=20
> Right, there is no any extended version of that spec.
> As far as I know, Intel's OmniPath technology is marketed as new and
> extended version of Infiniband [1], so it is probably that he
> referenced to it.

At one point there was talk about using the GRH to extend IB subnet address=
 space.  I can't remember what became of that proposal, but I can't quickly=
 find any mention of it in the spec.  But adding the GRH would result in a =
small increase to packet overhead.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

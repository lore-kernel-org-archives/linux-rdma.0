From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V1 for-next 1/2] IB/core: Report LSO capabilities when
 querying device
Date: Mon, 9 May 2016 09:27:32 -0500 (CDT)
Message-ID: <alpine.DEB.2.20.1605090926440.6128@east.gentwo.org>
References: <d8f8d6bf-9fad-fcc9-5a15-2b2423349c26@mellanox.com> <1828884A29C6694DAF28B7E6B8A82373AB0480DB@ORSMSX109.amr.corp.intel.com> <20160502175011.GB32096@obsidianresearch.com> <1828884A29C6694DAF28B7E6B8A82373AB04816A@ORSMSX109.amr.corp.intel.com>
 <20160502190619.GB32613@obsidianresearch.com> <1828884A29C6694DAF28B7E6B8A82373AB048E47@ORSMSX109.amr.corp.intel.com> <20160504181135.GA15355@obsidianresearch.com> <21d9307f-766e-9aaa-54d3-207a4a4d5d8c@mellanox.com> <20160505181423.GB5957@obsidianresearch.com>
 <alpine.DEB.2.20.1605052116570.1091@east.gentwo.org> <20160506225523.GA21309@obsidianresearch.com>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160506225523.GA21309-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 6 May 2016, Jason Gunthorpe wrote:

> > > This is where I get upset with the process we are following here,
> > > without input from other hardware architects in other companies,
> > > it is hard to design something truly common.
> >
> > Presumably the other vendors are listening in on this conversation. The
> > lack of alternate proposals and objections by them has often been
> > considered silent approval in the past.
>
> I know the various hardware architects that would be involved with a
> IBTA process/etc do not monitor this list.

An IBTA process? How would that be relevant here?

> > On the other hand nothing is going to happen if one vendor does not push
> > ahead. There were multiple implementations in the IP stack as well until
> > things settled. We need to be able to do the same and not stifle
> > innovation by making a vendor to wait until the competition comes
> > up with something similar.
>
> Agreed.
>
> I'm just saying, do it in user space and leave the common kernel uAPI
> alone until a more obvious consensus is reached. That should speed
> everything up..

How would you do this in user space?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

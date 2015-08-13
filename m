From: Jerome Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 4/8 v2] IB/odp/hmm: prepare for HMM code path.
Date: Thu, 13 Aug 2015 17:11:21 -0400
Message-ID: <20150813211121.GA10678@redhat.com>
References: <1439493653-1191-1-git-send-email-jglisse@redhat.com>
 <1439493653-1191-5-git-send-email-jglisse@redhat.com>
 <20150813201335.GA22581@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150813201335.GA22581-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christophe Harle <charle-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Duncan Poole <dpoole-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Sherry Cheung <SCheung-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Subhash Gutti <sgutti-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, John Hubbard <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Mark Hairgrove <mhairgrove-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Lucien Dunning <ldunning-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Cameron Buschardt <cabuschardt-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Arvind Gopalakrishnan <arvindg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Aug 13, 2015 at 02:13:35PM -0600, Jason Gunthorpe wrote:
> On Thu, Aug 13, 2015 at 03:20:49PM -0400, J=E9r=F4me Glisse wrote:
>  =20
> > +#if IS_ENABLED(CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM)
> > +#else /* CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM */
>=20
> Yuk, what is wrong with
>=20
>  #if !IS_ENABLED(...)
>=20
> ?

Just that latter patches add code btw #if and #else, and that
originaly it was a bigger patch that added the #if code #else
at the same time. Hence why this patch looks like this.

>=20
> > -#ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
> > +#if IS_ENABLED(CONFIG_INFINIBAND_ON_DEMAND_PAGING)
> > +#if IS_ENABLED(CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM)
> > +#else /* CONFIG_INFINIBAND_ON_DEMAND_PAGING_HMM */
>=20
> Double yuk
>=20
>  #if !(IS_ENABLED(..) && IS_ENABLED(..))
>=20
> ?

Same reason as above.


> And the #ifdefs suck, as many as possible should be normal if
> statements, and one should think carefully if we really need to remov=
e
> fields from structures..

My patch only add #if, i am not responsible for previous code
that used #ifdef, i was told to convert to #if and that's what
i am doing.

Regarding fields, yes this is intentional, ODP is an infrastructure
that is private to infiniband and thus needs more fields inside ib
struct. While HMM is intended to be a common infrastructure not only
for ib device but for other kind of devices too.

Cheers,
J=E9r=F4me
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

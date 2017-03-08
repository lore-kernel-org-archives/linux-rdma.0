From: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH] IB/cq: Don't process more than the given budget
Date: Wed, 8 Mar 2017 22:14:35 +0000
Message-ID: <1489011263.2813.9.camel@sandisk.com>
References: <1489003801-4410-1-git-send-email-sagi@grimberg.me>
         <1489010916.2813.4.camel@sandisk.com> <20170308221227.GA447@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170308221227.GA447-jcswGhMUV9g@public.gmane.org>
Content-Language: en-US
Content-ID: <E4C2612957CB9B499D4A29620842DAEE-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "hch-jcswGhMUV9g@public.gmane.org" <hch-jcswGhMUV9g@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org" <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2017-03-08 at 23:12 +0100, hch-jcswGhMUV9g@public.gmane.org wrote:
> On Wed, Mar 08, 2017 at 10:09:08PM +0000, Bart Van Assche wrote:
> > > -	while ((n =3D ib_poll_cq(cq, IB_POLL_BATCH, cq->wc)) > 0) {
> > > +	while ((n =3D ib_poll_cq(cq, min(IB_POLL_BATCH, budget - completed)=
,
> > > +			cq->wc)) > 0) {
> > >  		for (i =3D 0; i < n; i++) {
> > >  			struct ib_wc *wc =3D &cq->wc[i];
> > > =20
> >=20
> > This breaks the SRP initiator driver since that driver can pass -1 as b=
udget.
>=20
> Good point, we'd need to special case that.

How about using min_t(u32, IB_POLL_BATCH, budget - completed)?

Bart.=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

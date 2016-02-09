From: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [PATCH v2] IB/ipoib: fix for rare multicast join race condition.
Date: Tue, 9 Feb 2016 09:18:47 +0200
Message-ID: <20160209071847.GA14741@leon.nu>
References: <20160206135041.11630.77019.stgit@phlsvlogin03.ph.intel.com>
 <CAAk-MO8b_bpb=cd0Ki7wu3sUSG_rC+fS0sxhmdn5cA-91WfR4g@mail.gmail.com>
 <F3529576D8E232409F431C309E29399328F6C892@CRSMSX102.amr.corp.intel.com>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <F3529576D8E232409F431C309E29399328F6C892-8k97q/ur5Z1cIJlls4ac1rfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Estrin, Alex" <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Feb 08, 2016 at 04:43:29PM +0000, Estrin, Alex wrote:
> Hi Erez,
> =20
> > Can you please elaborate what will avoid the other task that
> > invalidate the priv->broadcast (ipoib_mcast_dev_flush) to do it rig=
ht
> > after that check?
>=20
> I was considering check for IPOIB_FLAG_OPER_UP in mcast task loop=20
> would be sufficient as its state is serialized  by priv->lock:
> > >         list_for_each_entry(mcast, &priv->multicast_list, list) {
> > > +               if (!test_bit(IPOIB_FLAG_OPER_UP, &priv->flags)) =
{
>=20
> And I can see your point now. We unlock before calling mcast_join().
> Apparently check for OPER_UP flag should be added along priv->broadca=
st check
> as it will ensure indication if mcast worker is competing with event =
handler worker.

Will you plan to respin it?

>=20
> Thanks,
> Alex.
>=20
> N?????r??y????b?X??=C7=A7v?^?)=DE=BA{.n?+????{??=D9=9A?{ay?=1D=CA=87=DA=
=99?,j=07??f???h???z?=1E?w???=0C???j:+v???w?j?m????=07????zZ+?????=DD=A2=
j"??!
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

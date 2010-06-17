From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] pkey fix for ipoib - resubmission
Date: Thu, 17 Jun 2010 19:36:37 +0300
Message-ID: <AANLkTimLfiuWMpiUFGIvotG0aWiebXC5jv5kfgKUmG4a@mail.gmail.com>
References: <4C2744E8AD2982428C5BFE523DF8CDCB49D09E7A43@MNEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C2744E8AD2982428C5BFE523DF8CDCB49D09E7A43-amwN6d8PyQWXx9kJd3VG2h2eb7JE58TQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 16, 2010 at 4:59 PM, Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org> =
wrote:
>
> IPoIB is coded to use the 1st PKey in the PKey table as its ib0 inter=
face. Additional ib0.pkey interfaces may be created using the /sys/clas=
s/... add_child interface.
>
> However, there is a race. =A0During normal boot, IPoIB will be starte=
d before the port is Active. =A0Hence the pkey table has not yet been p=
rogrammed and has a default pkey table (with 0xffff as only pkey).
So what's wrong with using the default pkey? It is a valid and I don't
see why we should ignore it.

>
> Later when the SM moves the port to Active, the SM may program the pk=
ey table differently. =A0However at this point IPoIB has already starte=
d using the incorrect pkey.
>
> It appears that the initially formatted 'broadcast' mgid is never upd=
ated to supply actual pkey value if ipoib comes up before hca port. Pro=
posed patch targets two issues:
>
> 1. Suppress activation of interface and join multicast group queries =
(it will fail anyway) until hca port is initialized. When port becomes =
active - update pkey value and move on.
I don't think this is required.


> 2. Update broadcast mgid based on actual pkey, then issue join broadc=
ast group request.
I agree that the broadcast MGID is not updated. But it seems to me
that all that's needed is to update priv->dev->broadcast with the
updated pkey at ipoib_open(). The rest is already taken care of since
pkey change events are handled by IPoIB.



>
> Signed-Off-By: Michael Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
>
> -------
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infini=
band/ulp/ipoib/ipoib_ib.c
> index ec6b4fb..496d96c 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> @@ -51,6 +51,7 @@ MODULE_PARM_DESC(data_debug_level,
> =A0#endif
>
> =A0static DEFINE_MUTEX(pkey_mutex);
> +static void ipoib_pkey_dev_check_presence(struct net_device *dev);
>
> =A0struct ipoib_ah *ipoib_create_ah(struct net_device *dev,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struc=
t ib_pd *pd, struct ib_ah_attr *attr) @@ -654,12 +655,13 @@ int ipoib_i=
b_dev_open(struct net_device *dev)
> =A0 =A0 =A0 =A0struct ipoib_dev_priv *priv =3D netdev_priv(dev);
> =A0 =A0 =A0 =A0int ret;
>
> - =A0 =A0 =A0 if (ib_find_pkey(priv->ca, priv->port, priv->pkey, &pri=
v->pkey_index)) {
> + =A0 =A0 =A0 ipoib_pkey_dev_check_presence(dev);
> +
> + =A0 =A0 =A0 if (!test_bit(IPOIB_PKEY_ASSIGNED, &priv->flags)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ipoib_warn(priv, "P_Key 0x%04x not fou=
nd\n", priv->pkey);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0clear_bit(IPOIB_PKEY_ASSIGNED, &priv->=
flags);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -1;
> =A0 =A0 =A0 =A0}
> - =A0 =A0 =A0 set_bit(IPOIB_PKEY_ASSIGNED, &priv->flags);
>
> =A0 =A0 =A0 =A0ret =3D ipoib_init_qp(dev);
> =A0 =A0 =A0 =A0if (ret) {
> @@ -694,9 +696,26 @@ int ipoib_ib_dev_open(struct net_device *dev) =A0=
static void ipoib_pkey_dev_check_presence(struct net_device *dev) =A0{
> =A0 =A0 =A0 =A0struct ipoib_dev_priv *priv =3D netdev_priv(dev);
> - =A0 =A0 =A0 u16 pkey_index =3D 0;
> + =A0 =A0 =A0 struct ib_port_attr =A0 =A0port_attr;
> +
> + =A0 =A0 =A0 if (!test_bit(IPOIB_FLAG_SUBINTERFACE, &priv->flags)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 clear_bit(IPOIB_PKEY_ASSIGNED, &priv->f=
lags);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ib_query_port(priv->ca, priv->port,=
 &port_attr)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ipoib_warn(priv, "Query=
 port attrs failed\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (port_attr.state !=3D IB_PORT_ACTIVE=
)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ib_query_pkey(priv->ca, priv->port,=
 0, &priv->pkey)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ipoib_warn(priv, "Query=
 P_Key table entry 0 failed\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 set_bit(IPOIB_PKEY_ASSIGNED, &priv->fla=
gs);
> + =A0 =A0 =A0 }
>
> - =A0 =A0 =A0 if (ib_find_pkey(priv->ca, priv->port, priv->pkey, &pke=
y_index))
> + =A0 =A0 =A0 if (ib_find_pkey(priv->ca, priv->port, priv->pkey, &pri=
v->pkey_index))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0clear_bit(IPOIB_PKEY_ASSIGNED, &priv->=
flags);
> =A0 =A0 =A0 =A0else
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0set_bit(IPOIB_PKEY_ASSIGNED, &priv->fl=
ags); @@ -955,7 +974,8 @@ static void __ipoib_ib_dev_flush(struct ipoib=
_dev_priv *priv,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* restart QP only if P_Key index is c=
hanged */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (test_and_set_bit(IPOIB_PKEY_ASSIGNE=
D, &priv->flags) &&
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (test_bit(IPOIB_FLAG_SUBINTERFACE, &=
priv->flags) &&
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 test_and_set_bit(IPOIB_PKEY_ASS=
IGNED, &priv->flags) &&
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0new_index =3D=3D priv->pkey_in=
dex) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ipoib_dbg(priv, "Not f=
lushing - P_Key index not changed.\n");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return;
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers=
/infiniband/ulp/ipoib/ipoib_multicast.c
> index 3871ac6..6fe6527 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
> @@ -552,6 +552,13 @@ void ipoib_mcast_join_task(struct work_struct *w=
ork)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_lock_irq(&priv->lock);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!test_bit(IPOIB_FLAG_SUBINTERFACE, =
&priv->flags)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* fix broadcast gid in=
 case if pkey was changed */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 priv->pkey |=3D 0x8000;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 priv->dev->broadcast[8]=
 =3D priv->pkey >> 8;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 priv->dev->broadcast[9]=
 =3D priv->pkey & 0xff;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0memcpy(broadcast->mcmember.mgid.raw, p=
riv->dev->broadcast + 4,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sizeof (union ib_gid));
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0priv->broadcast =3D broadcast;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo i=
nfo at =A0http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: list corruption in IPOIB
Date: Sun, 19 May 2013 11:17:36 +0200
Message-ID: <519898B0.1000901@profitbricks.com>
References: <519686B4.7010300@profitbricks.com> <CAJZOPZJNA7E005x9+XdVMG31fLEZm2mKB1nkpt5m3hA1qh7fYg@mail.gmail.com> <5197F447.5020702@profitbricks.com> <51986A8B.9030806@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51986A8B.9030806-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dongsu Park <dongsu.park-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 2013=E5=B9=B405=E6=9C=8819=E6=97=A5 08:00, Or Gerlitz wrote:
> On 19/05/2013 00:36, Jack Wang wrote:
>> I tried 3.4.23, and mainline kernel from Roland's rdma-for-linus, we
>> added bug injection interface,  run multithread iperf, and switched =
ib
>> mode between connected and datagram in sync on each side as Shlomo
>> suggested.
>=20
> Can you be more specific re the  bug injection interface, is that
> existing kernel mechanism or something you added? so the bug triggers
> when you run iperf in multi-threaded mode AND in parallel inject erro=
rs
> AND  in parallel switch between datagram and connected mode? bee --- =
I
> assume this isn't something you do just for the fun of it... so some
> problem X hits you in production and this problem Y you get with the
> above juggling, any known or empiric relation between the two?
>=20
> Or.

we added inject_bug sysfs node to make function run into error case,
like something below.
Yes, you are right, we want to speedup the bug reproduce process,
and we saw the warning and come to conclusion the neigh->list corrupted
some where.
What's your opinion?

Regards,
Jack
--- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
@@ -797,10 +797,12 @@ void ipoib_cm_handle_tx_wc(struct net_device *dev=
,
struct ib_wc *wc)
            test_bit(IPOIB_FLAG_ADMIN_UP, &priv->flags))
                netif_wake_queue(dev);

-       if (wc->status !=3D IB_WC_SUCCESS &&
-           wc->status !=3D IB_WC_WR_FLUSH_ERR) {
+       if (priv->inject_bug ||
+           (wc->status !=3D IB_WC_SUCCESS &&
+            wc->status !=3D IB_WC_WR_FLUSH_ERR)) {
                struct ipoib_neigh *neigh;

+               priv->inject_bug =3D 0;
                ipoib_dbg(priv, "failed cm send event "
                           "(status=3D%d, wrid=3D%d vend_err %x)\n",
                           wc->status, wr_id, wc->vendor_err);
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

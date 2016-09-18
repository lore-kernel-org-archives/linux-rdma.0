From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-rc 4/7] IB/mlx4: Fix possible vl/sl field mismatch
 in LRH header in QP1 packets
Date: Sun, 18 Sep 2016 09:53:56 +0300
Message-ID: <20160918065356.GA2923@leon.nu>
References: <1473696984-6161-1-git-send-email-leon@kernel.org>
 <1473696984-6161-5-git-send-email-leon@kernel.org>
 <4ad7c7fb-71a4-8ac4-f3a2-d0b4f2001385@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="LQksG6bCIzRHxTLp"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4ad7c7fb-71a4-8ac4-f3a2-d0b4f2001385-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 16, 2016 at 02:01:57PM -0400, Doug Ledford wrote:
> On 9/12/2016 12:16 PM, Leon Romanovsky wrote:
> > From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
> >
> > In MLX qp packets, the LRH (built by the driver) has both a VL field
> > and an SL field. When building a QP1 packet, the VL field should
> > reflect the SLtoVL mapping and not arbitrarily contain zero (as is
> > done now). This bug causes credit problems in IB switches at
> > high rates of QP1 packets.
> >
> > The fix is to cache the SL to VL mapping in the driver, and look up
> > the VL mapped to the SL provided in the send request when sending
> > QP1 packets.
> >
> > For FW versions which support generating a port_management_config_change
> > event with subtype sl-to-vl-table-change, the driver uses that event
> > to update its sl-to-vl mapping cache.  Otherwise, the driver snoops
> > incoming SMP mads to update the cache.
> >
> > There remains the case where the FW is running in secure-host mode
> > (so no QP0 packets are delivered to the driver), and the FW does not
> > generate the sl2vl mapping change event. To support this case, the
> > driver updates (via querying the FW) its sl2vl mapping cache when
> > running in secure-host mode when it receives either a Port Up event
> > or a client-reregister event (where the port is still up, but there
> > may have been an opensm failover).
> > OpenSM modifies the sl2vl mapping before Port Up and Client-reregister
> > events occur, so if there is a mapping change the driver's cache will
> > be properly updated.
> >
> > Fixes: 225c7b1feef1 ("IB/mlx4: Add a driver Mellanox ConnectX InfiniBand adapters")
> > Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
> > Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > ---
> >  drivers/infiniband/hw/mlx4/mad.c        |  64 ++++++++++++++++++-
> >  drivers/infiniband/hw/mlx4/main.c       | 110 +++++++++++++++++++++++++++++++-
> >  drivers/infiniband/hw/mlx4/mlx4_ib.h    |   7 ++
> >  drivers/infiniband/hw/mlx4/qp.c         |  23 ++++++-
> >  drivers/net/ethernet/mellanox/mlx4/fw.c |  13 ++--
> >  include/linux/mlx4/device.h             |  13 +++-
> >  6 files changed, 220 insertions(+), 10 deletions(-)
>
> That's a lot more code churn than I would like to see in a late RC.  I'm
> going to drop this patch and move it to 4.9 instead.  If this fixed an
> oops or something like that, I would be more open to taking it now, but
> the problem being resolved is credits on a switch.  That isn't the sort
> of showstopper issue that would justify this large of a patch this late
> in the cycle.

No problem, Thanks.

>
>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     GPG Key ID: 0E572FDD
>




--LQksG6bCIzRHxTLp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX3joEAAoJEORje4g2clin3WkQANGJ2L8kdREWGnOOtVRe6QeR
DbJQhF6HZNXizL4SSeZc1CUmjWBzBY8zdSlIOrWoO5BlTsnXJnblDkW1oAGHrWqv
+scTxNCc2pXyz1JjUDdNd0ha6rtsV6qZXL31+zmeKaye2g4GogORqWYuaP0ha/AP
vgImdXI8QLSBANPnSL8w68U7Z3Radm0zrnHqq3qhSO0I2Os//6MnOJy3P1uvgYoO
Zh3OwIADn4syGIcww8W9809JDv/pE993LkgqV81VPM4zWE72/S6spg19T0jXlQLE
yxGfQikASqIlMdDq+ZERGG+v44D3lgdaf5KHBokZkNJgmkUhSvUzgAmC41MJKcur
n1G+lu9HgfAaVJk3jqVRfXOLq2btmaOFC5W+dAkQdRZVwA/ylEoZCwN1YtRJmGRz
0coG4gbsZM+q7XoQA1gK8Q//IfNsh+vsgnjS8NmIp1DTucCXhzh0GJ/SQ8MhYRcZ
NfSKI0YWKirE92cJWGMUFgoB3MnuAYgb1PFMUJ8F5GDFQZIfXBao8VClbTauJ90A
8bC13qbDPQMHuhZZ21kYZWI57CcCzq/V9ltH7bUdCIgBdlJKl2MlC3ZMXUqQJdV2
GmLPLMhtVuOshHn1fTRO7C041YIVlsEl3UebhSXSagKY4mleG5JfvConuuajvJLS
OfTpG6WxJKXx4FF43ucv
=Ay1b
-----END PGP SIGNATURE-----

--LQksG6bCIzRHxTLp--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] hw: Fix permissions for OCRDMA_RESET_STATS
Date: Tue, 19 Dec 2017 14:30:30 +0200
Message-ID: <20171219123030.GD2942@mtr-leonro.local>
References: <1502207797-25589-1-git-send-email-vasilyev@ispras.ru>
 <20170815183158.GB24282@mtr-leonro.local>
 <CA+sbYW2FHpCH+=f_v6j7J6eQhw++wQeUp1GmX=h-CwVA2OSr4w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="vni90+aGYgRvsTuO"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CA+sbYW2FHpCH+=f_v6j7J6eQhw++wQeUp1GmX=h-CwVA2OSr4w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: Anton Vasilyev <vasilyev-ufN2psIa012HXe+LvDLADg@public.gmane.org>, Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Michael Mera <dev-5Y08+B5RRAgbhb6IIWwbbQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ldv-project-tpLiQldItUH5n4uC9ZG1Ww@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--vni90+aGYgRvsTuO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 19, 2017 at 03:59:30PM +0530, Selvin Xavier wrote:
> On Wed, Aug 16, 2017 at 12:01 AM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > On Tue, Aug 08, 2017 at 06:56:37PM +0300, Anton Vasilyev wrote:
> >> Debugfs file reset_stats is created with S_IRUSR permissions,
> >> but ocrdma_dbgfs_ops_read() doesn't support OCRDMA_RESET_STATS,
> >> whereas ocrdma_dbgfs_ops_write() supports only OCRDMA_RESET_STATS.
> >>
> >> The patch fixes misstype with permissions.
> >>
> >> Found by Linux Driver Verification project (linuxtesting.org).
> >>
> >> Signed-off-by: Anton Vasilyev <vasilyev-ufN2psIa012HXe+LvDLADg@public.gmane.org>
> >> ---
> >>  drivers/infiniband/hw/ocrdma/ocrdma_stats.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_stats.c b/drivers/infiniband/hw/ocrdma/ocrdma_stats.c
> >> index 66056f9..d42c617 100644
> >> --- a/drivers/infiniband/hw/ocrdma/ocrdma_stats.c
> >> +++ b/drivers/infiniband/hw/ocrdma/ocrdma_stats.c
> >> @@ -834,7 +834,7 @@ void ocrdma_add_port_stats(struct ocrdma_dev *dev)
> >>
> >>       dev->reset_stats.type = OCRDMA_RESET_STATS;
> >>       dev->reset_stats.dev = dev;
> >> -     if (!debugfs_create_file("reset_stats", S_IRUSR, dev->dir,
> >> +     if (!debugfs_create_file("reset_stats", S_IWUSR, dev->dir,
> >>                               &dev->reset_stats, &ocrdma_dbg_ops))
> >>               goto err;
> >>
> >
> > If I didn't miss anything, the reset_stats knob wouldn't work.
> >
> > Any read of statistics from that debugfs will trigger the call to
> > ocrdma_update_stats and it will call to ocrdma_mbx_rdma_stats(dev, false).
> >
> > For write operations to that "reset_stats", there is call
> > to ocrdma_mbx_rdma_stats with second argument (reset) as true.
> >
> > But it doesn't do much with that "reset" argument, except update of reset_stats.
> >
> > git grep reset_stats drivers/infiniband/hw/ocrdma/* drivers/net/ethernet/emulex/
> > drivers/infiniband/hw/ocrdma/ocrdma.h:  struct ocrdma_stats reset_stats;
> > drivers/infiniband/hw/ocrdma/ocrdma_hw.c:               req->reset_stats = reset;
>
> "reset" filed is passed down to the FW mailbox command to reset the
> stats maintained by FW.
> req is a pointer to dev->stats_mem.va and this is used to send down
> the command to FW.
> status = ocrdma_nonemb_mbx_cmd(dev, mqe, dev->stats_mem.va);

It still doesn't make a lot of sense to me:

ocrdma_mbx_rdma_stats():
1315        if (reset)
1316                 req->reset_stats = reset;
1317
1318         status = ocrdma_nonemb_mbx_cmd(dev, mqe, dev->stats_mem.va);


1117 static int ocrdma_nonemb_mbx_cmd(struct ocrdma_dev *dev, struct ocrdma_mqe *mqe,
1118                                  void *payload_va)
1119 {
1120         int status;
1121         struct ocrdma_mbx_rsp *rsp = payload_va;
1122
1123         if ((mqe->hdr.spcl_sge_cnt_emb & OCRDMA_MQE_HDR_EMB_MASK)
1124                                 OCRDMA_MQE_HDR_EMB_SHIFT)
1125                 BUG();
1126
1127         status = ocrdma_mbx_cmd(dev, mqe);

You are not using rsp and/or payload_va to provide data to ocrdma_mbx_cmd.

How are you passing reset_stats information to FW?

Thanks




>
>
> > drivers/infiniband/hw/ocrdma/ocrdma_sli.h:      u8 reset_stats;
> > drivers/infiniband/hw/ocrdma/ocrdma_stats.c:    dev->reset_stats.type = OCRDMA_RESET_STATS;
> > drivers/infiniband/hw/ocrdma/ocrdma_stats.c:    dev->reset_stats.dev = dev;
> > drivers/infiniband/hw/ocrdma/ocrdma_stats.c:    if (!debugfs_create_file("reset_stats", S_IRUSR, dev->dir,
> > drivers/infiniband/hw/ocrdma/ocrdma_stats.c:                            &dev->reset_stats, &ocrdma_dbg_ops))
> > drivers/net/ethernet/emulex/benet/be_cmds.c:    req->cmd_params.params.reset_stats = 0;
> > drivers/net/ethernet/emulex/benet/be_cmds.h:    u8 reset_stats;
> >
> > Thanks
>
> The patch looks good to me.
> Acked-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
>
> Thanks
> Selvin

--vni90+aGYgRvsTuO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlo5BmUACgkQ5GN7iDZy
WKdSmg//d6DoH5ffYPx8CVU8qeBOgMFB3YhsKsTDZ/QKjVtuKpe8/tafpewRtI02
amESA0hICym/X85pEz+ce2/lRZFHeHHdlTSNq9EiVsyK/MvvyR6SU/ce4b/nrui5
nAzCRdAdIT3wH+Fbr5yvqdi0ACVBk7Z7ijDgbN1K0mMwrOksv7b01w+aDhv0mOc5
aTCBolphUWcUjavco+ScfAlBP3EQtxGMdMKeuY0WwYGNGoUz+peCth1rQ+zVZat2
ElrwD13w7bxRb5WYoFu6XQZDS0YQ0+C3fL8XXEY3NRDSDlq6htgjWD5WbD7lxB23
sn7qyx8DSzEeE6+PVnyyqsWaRkBFqWJwUtATx+eDX95XjLZlncKxEEry6ai6lG/s
34NulGDrXwdyH2FOGOwAT4PdL+hcvFbpq8z36FD2mKfhPjUUrZ1em+D9SFJhm2DN
0zMJNJFyQhFVKpCDWPCup/jv0oS+xQdrQR6tIOcM8i5vaTYt84gcGND9Q/gSzGR5
THZ2AEnuRoCuWasGatMucXRlA8OtBwb4OJNtvLX7ryJ5ymHdoMKMw4lk4EwmT+2N
59+XQrb7MW+5Vgzg73lBMplTzqZ6pUdyMzEej1/WJsMd6LUHul/GeZGaHNrCra+X
yMP++C5i7PB4/Ma93I4+vvT47awpH1KmXxboeNVyR8CJSFwL1Xk=
=XJ39
-----END PGP SIGNATURE-----

--vni90+aGYgRvsTuO--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

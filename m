From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] hw: Fix permissions for OCRDMA_RESET_STATS
Date: Thu, 21 Dec 2017 07:05:43 +0200
Message-ID: <20171221050543.GD2942@mtr-leonro.local>
References: <1502207797-25589-1-git-send-email-vasilyev@ispras.ru>
 <20170815183158.GB24282@mtr-leonro.local>
 <CA+sbYW2FHpCH+=f_v6j7J6eQhw++wQeUp1GmX=h-CwVA2OSr4w@mail.gmail.com>
 <20171219123030.GD2942@mtr-leonro.local>
 <CA+sbYW06=taq46tUxP0nto2Tj0p_Jt--AobDwP4TaEwK9mnqLQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="MOeiELSuYwpLEKvX"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CA+sbYW06=taq46tUxP0nto2Tj0p_Jt--AobDwP4TaEwK9mnqLQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: Anton Vasilyev <vasilyev-ufN2psIa012HXe+LvDLADg@public.gmane.org>, Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Michael Mera <dev-5Y08+B5RRAgbhb6IIWwbbQ@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ldv-project-tpLiQldItUH5n4uC9ZG1Ww@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--MOeiELSuYwpLEKvX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 19, 2017 at 11:14:03PM +0530, Selvin Xavier wrote:
> On Tue, Dec 19, 2017 at 6:00 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> >> status = ocrdma_nonemb_mbx_cmd(dev, mqe, dev->stats_mem.va);
> >
> > It still doesn't make a lot of sense to me:
> >
> > ocrdma_mbx_rdma_stats():
> > 1315        if (reset)
> > 1316                 req->reset_stats = reset;
> > 1317
> > 1318         status = ocrdma_nonemb_mbx_cmd(dev, mqe, dev->stats_mem.va);
> >
> >
> > 1117 static int ocrdma_nonemb_mbx_cmd(struct ocrdma_dev *dev, struct ocrdma_mqe *mqe,
> > 1118                                  void *payload_va)
> > 1119 {
> > 1120         int status;
> > 1121         struct ocrdma_mbx_rsp *rsp = payload_va;
> > 1122
> > 1123         if ((mqe->hdr.spcl_sge_cnt_emb & OCRDMA_MQE_HDR_EMB_MASK)
> > 1124                                 OCRDMA_MQE_HDR_EMB_SHIFT)
> > 1125                 BUG();
> > 1126
> > 1127         status = ocrdma_mbx_cmd(dev, mqe);
> >
> > You are not using rsp and/or payload_va to provide data to ocrdma_mbx_cmd.
> >
> > How are you passing reset_stats information to FW?
> >
> This is a command where the response size is more than  236 bytes. So this is
> sent as a non-embedded command where the req/resp will be available in
> payload_va
> and phys address of payload_va (payload_pa) will be send down to
> firmware as MQE. FW will dma the mailbox
> from the payload_pa and response is transferred back.
>
> req->reset_stats = reset; is actually setting the corresponding bit in
> the request structure @payload_va.
> FW receives reset_stats once the request is DMA-ed from payload_pa.

Thanks

>
> > Thanks
> >
>
> Thanks,
> Selvin

--MOeiELSuYwpLEKvX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlo7QScACgkQ5GN7iDZy
WKfLvRAAx+yLthlDf4QRLo6u8GeM9dJqPY8vP3h395gprS676ao1q/fPhoJuiwxa
fNrFAqOZGV+ZMCTJTD8tvA5HTq5bgCVCNyfpnRczKoPXfGUZlM2yKXsLra6RAAIc
wSkCTZAjlY/qvvp7x9b5nXAe4CyrV5dtmItTLx9WBHUYh3sQFwtOIwoQX84wOVxj
1mPy2XjolkDpT689jbOC4TrKNm8SXNslfv2wJtHvyFksZX4TRn+KLHS/6lme7s9l
AqaEtL2f2Ixp3AObMflTRJ4JFq0X+4Wlj6S4S0E0a8xsSwhb8v6X1Bsn/tEA8JD9
he3BE2R9KaZCvBsNGAc4WVNWFh7BJNFMznihnALuhjO++C6qp2KUG3SXcqj+yf7H
WCSinN3DAYsjpQhbjj/0T5qc9+mD2qPzk0czt/9eLFUFrnTsZqodJyGB/4uFCEDi
XJxvUWobK+izKFvUwegM2StyRn7iHavJKZcsV7nQIxRCw47x+ls7dOEsa8eGPqNT
uLzG05ExSG7u/Wj3XfsgwyHSxiwNl3LOVdBgvdSUris/PQ1HSpE+puAGR9rEbOvQ
zz4ceH+IjH/r3k6OywLhrMtn560t7OLhQtBC1Uzv4iQD5DIzY7jP/4JHRTFb0PVg
ALMa9StZM/5pHesJO3vI6KO0eBq+dMnjcRH2851ZLQoazsx3muA=
=mOFt
-----END PGP SIGNATURE-----

--MOeiELSuYwpLEKvX--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

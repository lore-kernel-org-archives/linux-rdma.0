From: jackm <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] IB/mlx4: Fix CM REQ retries in paravirt mode
Date: Mon, 26 Jun 2017 12:40:48 +0300
Message-ID: <20170626124048.00002ef5@dev.mellanox.co.il>
References: <20170620120750.32268-1-Haakon.Bugge@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170620120750.32268-1-Haakon.Bugge-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?ISO-8859-1?Q?H=E5kon?= Bugge <Haakon.Bugge-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Nice catch, Haakon!

-Jack

On Tue, 20 Jun 2017 14:07:50 +0200
H=E5kon Bugge <Haakon.Bugge-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:

> CM REQs cannot be successfully retried, because a new pv_cm_id is
> created for each request, without checking if one already exists.
>=20
> By checking if an id exists before creating one, the bug is fixed.
>=20
> This bug can be provoked by running an RDMA CM user-land application,
> but inserting a five seconds delay before the rdma_accept() call on
> the passive side. This delay is larger than the default CMA timeout,
> and triggers a retry from the active side. The retried REQ will use
> another pv_cm_id (the cm_id on the wire). This confuses the CM
> protocol and two REJs are sent from the passive side.
>=20
> Here is an excerpt from ibdump running without the patch:
>=20
> 3.285092       LID: 4 -> LID: 4       SDP 290 CM: ConnectRequest(SDP
> Hello) 7.382711       LID: 4 -> LID: 4       SDP 290 CM:
> ConnectRequest(SDP Hello) 7.382861       LID: 4 -> LID: 4
> InfiniBand 290 CM: ConnectReject 7.387644       LID: 4 -> LID:
> 4       InfiniBand 290 CM: ConnectReject
>=20
> and here is the same with bug fix applied:
>=20
> 3.251010       LID: 4 -> LID: 4       SDP 290 CM: ConnectRequest(SDP
> Hello) 7.349387       LID: 4 -> LID: 4       SDP 290 CM:
> ConnectRequest(SDP Hello) 8.258443       LID: 4 -> LID: 4       SDP
> 290 CM: ConnectReply(SDP Hello) 8.259890       LID: 4 -> LID: 4
> InfiniBand 290 CM: ReadyToUse
>=20
> Suggested-by: Venkat Venkatsubra <venkat.x.venkatsubra-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: H=E5kon Bugge <haakon.bugge-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Reported-by: Wei Lin Guay <wei.lin.guay-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Tested-by: Wei Lin Guay <wei.lin.guay-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

Acked-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

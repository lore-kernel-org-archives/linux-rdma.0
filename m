From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH rdma-next 0/3] Support out of order data placement
Date: Mon, 12 Jun 2017 17:37:16 +0000
Message-ID: <VI1PR0502MB3008CE85A4F274886B74DF2BD1CD0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
References: <20170612064918.12510-1-leon@kernel.org>
 <074a01d2e39f$edc28860$c9479920$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <074a01d2e39f$edc28860$c9479920$@opengridcomputing.com>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Idan Burstein <idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Steve,

> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Steve Wise
> Sent: Monday, June 12, 2017 12:19 PM
> To: 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>; 'Doug Ledford'
> <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Idan Burstein <idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Subject: RE: [PATCH rdma-next 0/3] Support out of order data placement
>=20
> > -----Original Message-----
> > From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> > owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Leon Romanovsky
> > Sent: Monday, June 12, 2017 1:49 AM
> > To: Doug Ledford
> > Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Idan Burstein
> > Subject: [PATCH rdma-next 0/3] Support out of order data placement
> >
> > Hi Doug,
> >
> > This patch set which is based on v4.12-rc4 comes from Parav and it
> > adds support for out of order data placement for RDMA read and write
> > requests.
> >
> > Thanks
> >
> > ---
> > >From Parav:
> >
> > In certain fabric configurations IB packets for a given QP may take up
> > different paths in a network from source to destination. This results
> > into reaching packets out of order at the receiver side. Instead of
> > dropping packets, handling out of order packets can improve overall
> > network performance in following ways:
> >  * improve network utilization by avoiding retransmission
> >  * avoiding latency increase due to retransmission
> >
> > This patchset allows HCA to expose out of order data placement
> > capability to users who can take benefit of such feature.
> >
> > This is optional feature of an HCA and enablement of this feature is
> > done on per QP basis. The optional QP attribute is set when a QP state
> > is changed from INIT to RTR.
> >
> > Out of order data placement capability indicates that if HCA receives
> > out of order RDMA packets, their data placement can be done at the
> > desired memory destination given in the packet(s). This is applicable
> > to RDMA read and write operations.
> >
> > Send queue work requests are still completed in-order regardless of
> > their data placement order at requester or responder side.
> >
> > In-order semantics is always guaranteed by setting the Fence indicator
> > for appropriate WRs.
> >
> > An application shall not depend on the contents of the RDMA write
> > buffer at the responder until one of the following occurred:
> > - Completion of the RDMA WRITE with immediate data receive
> completion.
> > - Arrival and completion of the subsequent SEND message.
> > - Update of a memory element by subsequent ATOMIC operation.
> >
> > An application shall not depend on the contents of the RDMA read
> > buffer at the requester until one of the following occurred:
> > - Completion of the RDMA READ work request if requested or such
> >   work request completes with error status.
> > - Completion of the subsequent work request.
>=20
>=20
> Given the application follows the above semantics, why does it care if da=
ta
> is placed out of order?  IE Why does this impact the application API at a=
ll?
>=20
If application wants to benefit from out-of-order placement, it should enab=
le this flag.
Following semantics is fine, but letting HCA enable something under the hoo=
d for all QPs, is not good.
HCA or stack doesn't know which all applications are running, handling/foll=
owing such semantics.
So its best left to the end user applications to benefit or not from it.


> Steve.
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in =
the
> body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info
> at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH v2 2/2] RDMA/core: Initialize port_num in qp_attr
Date: Wed, 19 Jul 2017 08:09:48 +0000
Message-ID: <DM2PR0701MB13920AC9BBE7471A921FBF0A88A60@DM2PR0701MB1392.namprd07.prod.outlook.com>
References: <1500043291-19768-1-git-send-email-mustafa.ismail@intel.com>
 <1500043291-19768-3-git-send-email-mustafa.ismail@intel.com>
 <32E1700B9017364D9B60AED9960492BC34341CD3@fmsmsx120.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <32E1700B9017364D9B60AED9960492BC34341CD3-RjuIdWtd+YbTXloPLtfHfbfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Ismail, Mustafa" <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, "Saleem, Shiraz" <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Marciniszyn, Mike
> > Initialize the port_num for iWARP in rdma_init_qp_attr.
> >
> > Fixes: 5ecce4c9b17b("Check port number supplied by user verbs cmds")
> > Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # v2.6.14+
> > Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
> > Signed-off-by: Mustafa Ismail <mustafa.ismail-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>=20
Why is the second patch required if you only validate the port_num if the I=
B_QP_PORT mask is on?=20
Given the first patch [PATCH v2 1/2] RDMA/uverbs: Fix the check for port nu=
mber, this one seems
redundant.=20

Thanks,
Michal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

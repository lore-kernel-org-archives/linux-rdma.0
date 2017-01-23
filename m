From: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: RE: include/uapi/rdma/Kbuild file doesn't include "qedr-abi.h"
Date: Mon, 23 Jan 2017 16:46:19 +0000
Message-ID: <SN1PR07MB22071BC77DEE906AAD853F24F8720@SN1PR07MB2207.namprd07.prod.outlook.com>
References: <alpine.LFD.2.20.1701230633430.5922@uk63952.mitel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LFD.2.20.1701230633430.5922-znbnsbi9Yjij2xbMDHtV/wC/G2K4zDHf@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Robert P. J. Day" <rpjday-L09J2beyid0N/H6P543EQg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>   just an observation -- that Kbuild does not include the header file
> "qedr-abi.h" sitting in that directory. should it? it's definitely
> included by a few kernel files:
>=20
> $ grep -r "qedr-abi.h" *
> drivers/infiniband/hw/qedr/main.c:#include <rdma/qedr-abi.h>
> drivers/infiniband/hw/qedr/qedr_cm.c:#include <rdma/qedr-abi.h>
> drivers/infiniband/hw/qedr/verbs.c:#include <rdma/qedr-abi.h>
> $
>=20
> rday

Thanks Robert, I've just sent a fix.

Ram

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

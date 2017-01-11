From: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: NFSoRDMA Fails for max_sge Less Than 18
Date: Wed, 11 Jan 2017 07:41:22 +0000
Message-ID: <SN1PR07MB2207F28F05DC6E22B03CC516F8660@SN1PR07MB2207.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hariprasad S <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Chuck,
We discovered that your recent work (see[1]) on NFSoRDMA broke that functio=
nality on our device.
This seems to stem from a new requirement of minimum 18 SGES for NFSoRDMA t=
o work.
Our device supports only 4 SGEs, and it seems other devices also have limit=
ations in that
regard which would prevent the NFSoRDMA from working on them.

Mounting NFS over RDMA fails with the message: "Cannot allocate memory".
After enabling RPC debug information we've found this is due to this piece =
of code
from net/sunrpc/xprtrdma/verbs.c:

        if (ia->ri_device->attrs.max_sge < RPCRDMA_MAX_SEND_SGES) {
                dprintk("RPC:       %s: insufficient sge's available\n",
                        __func__);
                return -ENOMEM;
        }

Our device supports 4 sges while the minimum is now 18 sges, for PAGE_SIZE =
of 4KB:

        #define RPCRDMA_MAX_INLINE  (65536)     /* max inline thresh */

        RPCRDMA_MAX_SEND_PAGES =3D PAGE_SIZE + RPCRDMA_MAX_INLINE - 1,
        RPCRDMA_MAX_PAGE_SGES =3D (RPCRDMA_MAX_SEND_PAGES >> PAGE_SHIFT) + =
1,
        RPCRDMA_MAX_SEND_SGES =3D 1 + 1 + RPCRDMA_MAX_PAGE_SGES + 1,

On kernel 4.8 and before, NFSoRDMA worked well with our device as only 2 SG=
Es were required.
The code looked like this:
        #define RPCRDMA_MAX_IOVS        (2)

        if (ia->ri_device->attrs.max_sge < RPCRDMA_MAX_IOVS) {
                dprintk("RPC:       %s: insufficient sge's available\n",
                        __func__);
                return -ENOMEM;
        }

Browsing the code of other drivers it can be seen that this ability is eith=
er hardcoded or is
learnt by the driver from the device. If I'm not mistaken, this issue affec=
ts nes and
cxgb3/4 drivers, and perhaps others.

E.g., for cxgb4:

        #define T4_MAX_RECV_SGE 4

        static int c4iw_query_device(struct ib_device *ibdev, struct ib_dev=
ice_attr *props,
                                     struct ib_udata *uhw)
        {
                ...
                props->max_sge =3D T4_MAX_RECV_SGE;

***
[1] https://patchwork.kernel.org/patch/9333951/

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

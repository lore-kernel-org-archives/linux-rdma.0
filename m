From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: How to tell RoCE v1 vs v2?
Date: Fri, 2 Feb 2018 22:05:54 +0000
Message-ID: <VI1PR0502MB3008131CCEE4D9523F346611D1F90@VI1PR0502MB3008.eurprd05.prod.outlook.com>
References: <DE927C68B458BE418D582EC97927A9287FE1FCF7@ORSMSX113.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <DE927C68B458BE418D582EC97927A9287FE1FCF7-8oqHQFITsIFQxe9IK+vIArfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Gruher, Joseph R" <joseph.r.gruher-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Joseph,

> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Gruher, Joseph R
> Sent: Friday, February 02, 2018 1:19 PM
> To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: How to tell RoCE v1 vs v2?
>=20
>=20
> Hi folks-
>=20
> We're doing some NVMeoF testing.  We have Xeon servers with Mellanox CX4
> NICs connected through an Arista 7060CX switch.  We're using the kernel
> support for RDMA and NVMeoF in Ubuntu 16.10 with a 4.12.5 kernel.  I'm tr=
ying
> to figure out if we're running RoCE v1 or RoCE v2.  I can't seem to Googl=
e up a
> way to check when running the kernel solution, just answers for Mellanox =
OFED.
> Is there a way to tell?  And if we're running v1, is there a way to force=
 v2?

Steps:
mkdir /sys/kernel/config/rdma_cm/mlx5_0
cat /sys/kernel/config/rdma_cm/mlx5_0/ports/1/default_roce_mode
#Above command tells whether default is RoCEv1 or v2.

echo "RoCE v2" > /sys/kernel/config/rdma_cm/mlx5_0/ports/1/default_roce_mod=
e

Above command will force to pick RoCEv2 GIDs by default when using RDMACM b=
ased applications (if HCA supports it).
RoCEv2 was made default in below patch.

commit 3c7f67d1880db4bda8eed12ca603c92b5434390e
Author: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Date:   Fri Jul 28 13:47:24 2017 -0400

    IB/cma: Fix default RoCE type setting

    The initial patch for changing the stack to use RoCEv2 GIDs by default
    set the CMA_PREFERRED_ROCE_GID_TYPE to an incorrect value.  Instead of
    an absolute value, we needed to set the right bit in a bitmask.  Correc=
t
    the default setting so we use RoCEv2 by default.

    Fixes: 63a5f483af0e (IB/cma: Set default gid type to RoCEv2)
    Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

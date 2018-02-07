From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH v3] Documentation/ABI: update infiniband sysfs interfaces
Date: Wed, 7 Feb 2018 16:09:11 +0000
Message-ID: <VI1PR0502MB3008B3A337DB4DDA140094B9D1FC0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
References: <20180207045955.GA31749@mordor.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180207045955.GA31749-BxiFm0zuoZpSq9BJjBFyUp/QNRX+jHPU@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Aishwarya Pant <aishpant-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Julia Lawall <julia.lawall-L2FTfq7BK8M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Aishwarya,


> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Aishwarya Pant
> Sent: Tuesday, February 06, 2018 11:00 PM
> To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>; Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>;
> linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Jonathan Corbet
> <corbet-T1hC0tSOHrs@public.gmane.org>; Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
> Cc: Julia Lawall <julia.lawall-L2FTfq7BK8M@public.gmane.org>
> Subject: [PATCH v3] Documentation/ABI: update infiniband sysfs interfaces
>=20
> Add documentation for core and hardware specific infiniband interfaces.
> The descriptions have been collected from git commit logs, reading throug=
h
> code and data sheets. Some drivers have incomplete doc and are annotated
> with the comment '[to be documented]'.
>=20
> Signed-off-by: Aishwarya Pant <aishpant-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
> Changes in v3:
> -  outbound -> inbound in description of port_rcv_constraint_errors
> v2:
> - Move infiniband interface from testing to stable
> - Fix typos
> - Update description of cap_mask, port_xmit_constraint_errors and
>   port_rcv_constraint_errors
> - Add doc for hw_counters
> - Remove old documentation
>=20
>  Documentation/ABI/stable/sysfs-class-infiniband  | 818
> +++++++++++++++++++++++  Documentation/ABI/testing/sysfs-class-infiniband
> |  16 -
>  Documentation/infiniband/sysfs.txt               | 129 +---
>  3 files changed, 820 insertions(+), 143 deletions(-)  create mode 100644
> Documentation/ABI/stable/sysfs-class-infiniband
>  delete mode 100644 Documentation/ABI/testing/sysfs-class-infiniband
>=20
> diff --git a/Documentation/ABI/stable/sysfs-class-infiniband
> b/Documentation/ABI/stable/sysfs-class-infiniband
> new file mode 100644
> index 000000000000..f3acf3713a91
> --- /dev/null
> +++ b/Documentation/ABI/stable/sysfs-class-infiniband
> @@ -0,0 +1,818 @@
> +sysfs interface common for all infiniband devices
> +-------------------------------------------------
> +

> +What:		/sys/class/infiniband/<hca>/ports/<port-
> number>/gid_attrs/ndevs/<gid-index>
> +Date:		November 29, 2015
> +KernelVersion:	4.4.0
> +Contact:	linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> +Description: 	The net-device's name associated with the GID resides
> +		at index <gid-index>.
> +
> +What:		/sys/class/infiniband/<hca>/ports/<port-
> number>/gid_attrs/types/<gid-index>
> +Date:		November 29, 2015
> +KernelVersion:	4.4.0
> +Contact:	linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> +Description: 	The RoCE type of the associated GID resides at index <gid-
> index>.
> +		This could either be "IB/RoCE v1" for IB and RoCE v1 based
> GODs
GIDs.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v3 00/37] IB: Optimize DMA mapping
Date: Fri, 20 Jan 2017 22:18:59 +0000
Message-ID: <1484950725.2665.10.camel@sandisk.com>
References: <20170120210437.26389-1-bart.vanassche@sandisk.com>
         <1671405275.19009584.1484949453215.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1671405275.19009584.1484949453215.JavaMail.zimbra-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Content-ID: <D2A5A3D166E6E94DAA1F5105AB616A8F-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 2017-01-20 at 16:57 -0500, Laurence Oberman wrote:
> Hello Bart, if this the match to what you shared with me earlier I have
> tested the IB/SRP part of this series.
>=20
> This is the IB/RDMA/SRP stack, testing both ib_srp and ib_srpt.
>=20
> 1. Tested direct and buffered read I/O with 4MB I/O and smaller I/O sizes
>    direct to mpath devices
> 2. Tested read and write I/O with 4MB and smaller I/O to XFS file systems=
.
> 3. Removed a SRP paths one by one and let then reconnect with no issues
>=20
> All my tests were SRP using connectX-4 (mlx5) at EDR (100G)
>=20
> For: Optimize DMA mapping tree, branch for next from latest copy on:
> https://github.com/bvanassche/linux
> Tested-by: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Hello Laurence,

The code I posted is identical to the code I asked you to test. Thanks for
the help with testing!

I tested the following ULP and HBA drivers myself with this patch series:
ib_srp, ib_srpt, ib_mlx4 and rxe.

Bart.=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

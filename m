From: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Subject: Re: [PATCH rdma-core 1/5] Common infrastructure for auto loading rdma
 modules
Date: Tue, 25 Jul 2017 17:15:18 +0000
Message-ID: <1501002916.8931.4.camel@wdc.com>
References: <1500929067-1583-1-git-send-email-jgunthorpe@obsidianresearch.com>
         <1500929067-1583-2-git-send-email-jgunthorpe@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1500929067-1583-2-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Content-ID: <D6F07DD5DF81EF44A07891580C73B1A6-+cFlbfsKLD6cE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org" <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "notifications-9UaJU3cA/F/QT0dZR+AlfA@public.gmane.org" <notifications-9UaJU3cA/F/QT0dZR+AlfA@public.gmane.org>, "swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 2017-07-24 at 14:44 -0600, Jason Gunthorpe wrote:
> +This is to avoid exposing systems not using RDMA from having RDMA enable=
d, for
> +instance if a system has a multi-protocol ethernet adaptor, but is only =
using
> +the net stack interface.

adaptor -> adapter ?

> +Finally udev will cause systemd to start RDMA specific daemons like
> +srp_deamon, rdma-ndd and iwpmd. These starts are linked to the detection=
 of
> +the first RDMA hardware, and the daemons internally handle hot plug even=
ts for
> +other hardware.

Please change srp_deamon into srp_daemon such that the spelling matches the=
 name
of the executable.

> +
> +## Hot Plug compatible services
> +
> +RDMA using services need to have device specific systemd dependencies in=
 their
> +unit files, either created by hand by the admin or by using udev rules.

"RDMA using services" -> "Services using RDMA" ?

> +++ b/kernel-boot/modules/infiniband.conf
> @@ -0,0 +1,12 @@
> +# These modules are loaded by the system if any InfiniBand device is ins=
talled
> +# Infiniband over IP netdevice

Please spell "InfiniBand" consistently in the above comment.

> +ib_ipoib
> +
> +# Access to fabric management SMPs and GMPs from userspace.
> +ib_umad
> +
> +# SCSI Remote Protocol target support
> +# ib_srpt
> +
> +# ib_ucm provides the obsolete /dev/infiniband/ucm0
> +# ib_ucm

If ib_iser is loaded by default, should ib_srp also be loaded by default if=
 the
appropriate hardware is present? I don't think that there are fewer SRP use=
rs
than iSER users.

> diff --git a/kernel-boot/rdma-description.rules b/kernel-boot/rdma-descri=
ption.rules
> [ ... ]
> +# Hardware that supports RoCE
> +DRIVERS=3D=3D"be2net", ENV{ID_RDMA_ROCE}=3D"1"
> +DRIVERS=3D=3D"bnxt_en", ENV{ID_RDMA_ROCE}=3D"1"
> +DRIVERS=3D=3D"hns", ENV{ID_RDMA_ROCE}=3D"1"
> +DRIVERS=3D=3D"i40e", ENV{ID_RDMA_ROCE}=3D"1"
> +DRIVERS=3D=3D"mlx4_core", ENV{ID_RDMA_ROCE}=3D"1"
> +DRIVERS=3D=3D"mlx5_core", ENV{ID_RDMA_ROCE}=3D"1"
> +DRIVERS=3D=3D"qede", ENV{ID_RDMA_ROCE}=3D"1"

Should the "rdma_rxe" driver be added to this list?

> +ENV{ID_NET_DRIVER}=3D=3D"mlx4_en", RUN{builtin}+=3D"kmod load mlx4_ib"
> +ENV{ID_NET_DRIVER}=3D=3D"mlx5_core", RUN{builtin}+=3D"kmod load mlx5_ib"

Why this inconsistency between mlx4 and mlx5? Additionally, if these rules =
are
added, shouldn't the request_module() calls be removed from the mlx4 and ml=
5 core
drivers?

Anyway, nice work!

Bart.=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

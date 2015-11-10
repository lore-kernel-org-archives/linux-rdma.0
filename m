From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC 1/3] IB/core: Expose a device attribute for
 rdma_read access flags
Date: Tue, 10 Nov 2015 12:51:10 +0100
Message-ID: <1447156270.7089.3.camel@opteya.com>
References: <1447152255-28231-1-git-send-email-sagig@mellanox.com>
	 <1447152255-28231-2-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447152255-28231-2-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

Le mardi 10 novembre 2015 =C3=A0 12:44 +0200, Sagi Grimberg a =C3=A9cri=
t=C2=A0:
> Different devices may require different access permissions
> for rdma reads e.g. for Infiniband devices, local write access
> suffices while iWARP devices require remote write permissions as
> well.
>=20
> This situation generates extra logic for ULPs that need to be aware
> of the underlying device to determine rdma read access. Instead,
> add a device attribute for ULPs to use without being aware of the
> underlying device.
>=20
> Also, set rdma_read_access_flags in the relevant device drivers:
> mlx4, mlx5, qib, ocrdma, nes: IB_ACCESS_LOCAL_WRITE
> cxgb3, cxgb4, hfi: IB_ACCESS_LOCAL_WRITE | IB_ACCESS_REMOTE_WRITE
>=20

Why were those hw providers not modified to
enforce=C2=A0IB_ACCESS_REMOTE_WRITE when needed, instead of asking user=
s to
set it for them ?

Regards.

--=C2=A0
Yann Droneaud
OPTEYA

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

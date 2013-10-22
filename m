From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH/RFC] IB/core: Temporarily disable
 =?UTF-8?Q?create=5Fflow/destroy=5Fflow=20uverbs?=
Date: Tue, 22 Oct 2013 10:32:23 +0200
Message-ID: <9e8f20353099007001d534c9ec565c1f@meuh.org>
References: <1382380843-15647-1-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1382380843-15647-1-git-send-email-roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

Le 21.10.2013 20:40, Roland Dreier a =C3=A9crit=C2=A0:
> From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
>=20
> The create_flow/destroy_flow uverbs and the associated extensions to
> the user-kernel verbs ABI are under review and are too experimental t=
o
> freeze at this point.
>=20
> So userspace is not exposed to experimental features and an uinstable
> ABI, temporarily disable this for v3.12 (with a Kconfig option behind
> staging to reenable it if desired).
>=20
> The feature will be enabled after proper cleanup for v3.13.
>=20
> Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
> Link: http://marc.info/?i=3Dcover.1381351016.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
> Link: http://marc.info/?i=3Dcover.1381177342.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
>=20
> [ Add a Kconfig option to reenable these verbs.  - Roland ]
>=20
> Signed-off-by: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>

=46or the record:

Acked-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>

Thanks Roland for updating the patch with the Kconfig entry.

Regards.

--=20
Yann Droneaud
OPTEYA

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

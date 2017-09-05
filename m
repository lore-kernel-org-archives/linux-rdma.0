From: "Kalderon, Michal" <Michal.Kalderon@cavium.com>
Subject: RE: [PATCH] RDMA/qedr: fix build error without ipv6
Date: Tue, 5 Sep 2017 17:13:33 +0000
Message-ID: <CY1PR0701MB201243B753F0EA92B2225D9E88960@CY1PR0701MB2012.namprd07.prod.outlook.com>
References: <20170905145935.1578698-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170905145935.1578698-1-arnd@arndb.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, "Amrani, Ram" <Ram.Amrani@cavium.com>, "Elior, Ariel" <Ariel.Elior@cavium.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

> From: Arnd Bergmann [mailto:arnd@arndb.de]
> Sent: Tuesday, September 05, 2017 5:59 PM
> To: Amrani, Ram <Ram.Amrani@cavium.com>; Kalderon, Michal
> <Michal.Kalderon@cavium.com>; Elior, Ariel <Ariel.Elior@cavium.com>;
> Doug Ledford <dledford@redhat.com>; Sean Hefty
> <sean.hefty@intel.com>; Hal Rosenstock <hal.rosenstock@gmail.com>
> Cc: Arnd Bergmann <arnd@arndb.de>; David S. Miller
> <davem@davemloft.net>; Mintz, Yuval <Yuval.Mintz@cavium.com>; linux-
> rdma@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [PATCH] RDMA/qedr: fix build error without ipv6
>=20
> When CONFIG_IPV6 disabled, we run into a link error:
>=20
> drivers/infiniband/hw/qedr/qedr_iw_cm.o: In function
> `qedr_addr6_resolve.isra.3':
> qedr_iw_cm.c:(.text+0x4e0): undefined reference to
> `ip6_route_output_flags'
>=20
> The ipv6 handling code is obviously not needed here, so this adds a compi=
le-
> time check for the Kconfig symbol in all three places in the code that de=
cide
> between ipv4 and ipv6.
>=20
> We don't have to worry about a link error wtih QEDR=3Dy/IPV6=3Dm, as that
> configuration is already prohibited by CONFIG_INFINIBAND depending on "m
> || IPV6 !=3D m".
>=20
> Fixes: e411e0587e0d ("RDMA/qedr: Add iWARP connection management
> functions")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/infiniband/hw/qedr/qedr_iw_cm.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/qedr/qedr_iw_cm.c
> b/drivers/infiniband/hw/qedr/qedr_iw_cm.c
> index fe9b2b6149b0..2950d3f6ecb8 100644
> --- a/drivers/infiniband/hw/qedr/qedr_iw_cm.c
> +++ b/drivers/infiniband/hw/qedr/qedr_iw_cm.c
> @@ -98,7 +98,8 @@ qedr_iw_mpa_request(void *context, struct
> qed_iwarp_cm_event_params *params)
>  	event.event =3D IW_CM_EVENT_CONNECT_REQUEST;
>  	event.status =3D params->status;
>=20
> -	if (params->cm_info->ip_version =3D=3D QED_TCP_IPV4)
> +	if (!IS_ENABLED(CONFIG_IPV6) ||
> +	    params->cm_info->ip_version =3D=3D QED_TCP_IPV4)
>  		qedr_fill_sockaddr4(params->cm_info, &event);
>  	else
>  		qedr_fill_sockaddr6(params->cm_info, &event); @@ -522,7
> +523,8 @@ int qedr_iw_connect(struct iw_cm_id *cm_id, struct
> iw_cm_conn_param *conn_param)
>  	memset(cm_info->local_ip, 0, sizeof(cm_info->local_ip));
>  	memset(cm_info->remote_ip, 0, sizeof(cm_info->remote_ip));
>=20
> -	if (cm_id->remote_addr.ss_family =3D=3D AF_INET) {
> +	if (!IS_ENABLED(CONFIG_IPV6) ||
> +	    cm_id->remote_addr.ss_family =3D=3D AF_INET) {
>  		cm_info->ip_version =3D QED_TCP_IPV4;
>=20
>  		cm_info->remote_ip[0] =3D ntohl(raddr->sin_addr.s_addr);
> @@ -616,7 +618,8 @@ int qedr_iw_create_listen(struct iw_cm_id *cm_id,
> int backlog)
>  	iparams.event_cb =3D qedr_iw_event_handler;
>  	iparams.max_backlog =3D backlog;
>=20
> -	if (cm_id->local_addr.ss_family =3D=3D AF_INET) {
> +	if (!IS_ENABLED(CONFIG_IPV6) ||
> +	    cm_id->local_addr.ss_family =3D=3D AF_INET) {
>  		iparams.ip_version =3D QED_TCP_IPV4;
>  		memset(iparams.ip_addr, 0, sizeof(iparams.ip_addr));
>=20
> --
> 2.9.0

Thanks!

Acked-by: Michal Kalderon <michal.kalderon@cavium.com>

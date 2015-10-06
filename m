From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] usnic: add missing clauses to BSD license
Date: Tue, 6 Oct 2015 14:17:01 -0400
Message-ID: <5614101D.5040902@redhat.com>
References: <1443645240-21250-1-git-send-email-jsquyres@cisco.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="5mWP8HVUBKurk7uoGtrrAHece4n7RlW2q"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1443645240-21250-1-git-send-email-jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Benoit Taine <benoit.taine-L2FTfq7BK8M@public.gmane.org>, Benoit Taine <benoit.taine-oid7hba3+9NWj0EZb7rXcA@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Joerg Roedel <jroedel-l3A5Bk7waGM@public.gmane.org>, Masanari Iida <standby24x7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Wei Yongjun <yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org>, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Fabio Estevam <fabio.estevam-KZfg59tc24xl57MIdRCFDg@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--5mWP8HVUBKurk7uoGtrrAHece4n7RlW2q
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 09/30/2015 04:34 PM, Jeff Squyres wrote:
> The usnic_verbs kernel module was clearly marked with the following in
> its code:
>=20
>   MODULE_LICENSE("Dual BSD/GPL");
>=20
> However, we accidentally left a few clauses of the BSD text out of the
> license header in all the source files.  This commit fixes that: all
> the files are properly dual BSD/GPL-licensed.
>=20
> Signed-off-by: Jeff Squyres <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>

I added all of the people that are Cc:ed on this email to the Cc: list
in the changelog, but otherwise, applied.

> ---
>  drivers/infiniband/hw/usnic/usnic.h                 | 21 +++++++++++++=
+++++---
>  drivers/infiniband/hw/usnic/usnic_abi.h             | 21 +++++++++++++=
+++++---
>  drivers/infiniband/hw/usnic/usnic_common_pkt_hdr.h  | 21 +++++++++++++=
+++++---
>  drivers/infiniband/hw/usnic/usnic_common_util.h     | 21 +++++++++++++=
+++++---
>  drivers/infiniband/hw/usnic/usnic_debugfs.c         | 21 +++++++++++++=
+++++---
>  drivers/infiniband/hw/usnic/usnic_debugfs.h         | 21 +++++++++++++=
+++++---
>  drivers/infiniband/hw/usnic/usnic_fwd.c             | 21 +++++++++++++=
+++++---
>  drivers/infiniband/hw/usnic/usnic_fwd.h             | 21 +++++++++++++=
+++++---
>  drivers/infiniband/hw/usnic/usnic_ib.h              | 21 +++++++++++++=
+++++---
>  drivers/infiniband/hw/usnic/usnic_ib_main.c         | 21 +++++++++++++=
+++++---
>  drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c       | 21 +++++++++++++=
+++++---
>  drivers/infiniband/hw/usnic/usnic_ib_qp_grp.h       | 21 +++++++++++++=
+++++---
>  drivers/infiniband/hw/usnic/usnic_ib_sysfs.c        | 21 +++++++++++++=
+++++---
>  drivers/infiniband/hw/usnic/usnic_ib_sysfs.h        | 21 +++++++++++++=
+++++---
>  drivers/infiniband/hw/usnic/usnic_ib_verbs.c        | 21 +++++++++++++=
+++++---
>  drivers/infiniband/hw/usnic/usnic_ib_verbs.h        | 21 +++++++++++++=
+++++---
>  drivers/infiniband/hw/usnic/usnic_log.h             | 21 +++++++++++++=
+++++---
>  drivers/infiniband/hw/usnic/usnic_transport.c       | 21 +++++++++++++=
+++++---
>  drivers/infiniband/hw/usnic/usnic_transport.h       | 21 +++++++++++++=
+++++---
>  drivers/infiniband/hw/usnic/usnic_uiom.c            |  2 +-
>  drivers/infiniband/hw/usnic/usnic_uiom.h            | 21 +++++++++++++=
+++++---
>  .../infiniband/hw/usnic/usnic_uiom_interval_tree.c  | 21 +++++++++++++=
+++++---
>  .../infiniband/hw/usnic/usnic_uiom_interval_tree.h  | 21 +++++++++++++=
+++++---
>  drivers/infiniband/hw/usnic/usnic_vnic.c            | 21 +++++++++++++=
+++++---
>  drivers/infiniband/hw/usnic/usnic_vnic.h            | 21 +++++++++++++=
+++++---
>  25 files changed, 433 insertions(+), 73 deletions(-)
>=20
> diff --git a/drivers/infiniband/hw/usnic/usnic.h b/drivers/infiniband/h=
w/usnic/usnic.h
> index 5be13d8..f903502 100644
> --- a/drivers/infiniband/hw/usnic/usnic.h
> +++ b/drivers/infiniband/hw/usnic/usnic.h
> @@ -1,9 +1,24 @@
>  /*
>   * Copyright (c) 2013, Cisco Systems, Inc. All rights reserved.
>   *
> - * This program is free software; you may redistribute it and/or modif=
y
> - * it under the terms of the GNU General Public License as published b=
y
> - * the Free Software Foundation; version 2 of the License.
> + * This software is available to you under a choice of one of two
> + * licenses.  You may choose to be licensed under the terms of the GNU=

> + * General Public License (GPL) Version 2, available from the file
> + * COPYING in the main directory of this source tree, or the
> + * BSD license below:
> + *
> + *     Redistribution and use in source and binary forms, with or
> + *     without modification, are permitted provided that the following=

> + *     conditions are met:
> + *
> + *      - Redistributions of source code must retain the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer.
> + *
> + *      - Redistributions in binary form must reproduce the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer in the documentation and/or other materials
> + *        provided with the distribution.
>   *
>   * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
>   * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> diff --git a/drivers/infiniband/hw/usnic/usnic_abi.h b/drivers/infiniba=
nd/hw/usnic/usnic_abi.h
> index 04a6622..7fe9502 100644
> --- a/drivers/infiniband/hw/usnic/usnic_abi.h
> +++ b/drivers/infiniband/hw/usnic/usnic_abi.h
> @@ -1,9 +1,24 @@
>  /*
>   * Copyright (c) 2013, Cisco Systems, Inc. All rights reserved.
>   *
> - * This program is free software; you may redistribute it and/or modif=
y
> - * it under the terms of the GNU General Public License as published b=
y
> - * the Free Software Foundation; version 2 of the License.
> + * This software is available to you under a choice of one of two
> + * licenses.  You may choose to be licensed under the terms of the GNU=

> + * General Public License (GPL) Version 2, available from the file
> + * COPYING in the main directory of this source tree, or the
> + * BSD license below:
> + *
> + *     Redistribution and use in source and binary forms, with or
> + *     without modification, are permitted provided that the following=

> + *     conditions are met:
> + *
> + *      - Redistributions of source code must retain the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer.
> + *
> + *      - Redistributions in binary form must reproduce the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer in the documentation and/or other materials
> + *        provided with the distribution.
>   *
>   * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
>   * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> diff --git a/drivers/infiniband/hw/usnic/usnic_common_pkt_hdr.h b/drive=
rs/infiniband/hw/usnic/usnic_common_pkt_hdr.h
> index 3935672..596e0ed 100644
> --- a/drivers/infiniband/hw/usnic/usnic_common_pkt_hdr.h
> +++ b/drivers/infiniband/hw/usnic/usnic_common_pkt_hdr.h
> @@ -1,9 +1,24 @@
>  /*
>   * Copyright (c) 2013, Cisco Systems, Inc. All rights reserved.
>   *
> - * This program is free software; you may redistribute it and/or modif=
y
> - * it under the terms of the GNU General Public License as published b=
y
> - * the Free Software Foundation; version 2 of the License.
> + * This software is available to you under a choice of one of two
> + * licenses.  You may choose to be licensed under the terms of the GNU=

> + * General Public License (GPL) Version 2, available from the file
> + * COPYING in the main directory of this source tree, or the
> + * BSD license below:
> + *
> + *     Redistribution and use in source and binary forms, with or
> + *     without modification, are permitted provided that the following=

> + *     conditions are met:
> + *
> + *      - Redistributions of source code must retain the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer.
> + *
> + *      - Redistributions in binary form must reproduce the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer in the documentation and/or other materials
> + *        provided with the distribution.
>   *
>   * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
>   * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> diff --git a/drivers/infiniband/hw/usnic/usnic_common_util.h b/drivers/=
infiniband/hw/usnic/usnic_common_util.h
> index 9d737ed..b54986d 100644
> --- a/drivers/infiniband/hw/usnic/usnic_common_util.h
> +++ b/drivers/infiniband/hw/usnic/usnic_common_util.h
> @@ -1,9 +1,24 @@
>  /*
>   * Copyright (c) 2013, Cisco Systems, Inc. All rights reserved.
>   *
> - * This program is free software; you may redistribute it and/or modif=
y
> - * it under the terms of the GNU General Public License as published b=
y
> - * the Free Software Foundation; version 2 of the License.
> + * This software is available to you under a choice of one of two
> + * licenses.  You may choose to be licensed under the terms of the GNU=

> + * General Public License (GPL) Version 2, available from the file
> + * COPYING in the main directory of this source tree, or the
> + * BSD license below:
> + *
> + *     Redistribution and use in source and binary forms, with or
> + *     without modification, are permitted provided that the following=

> + *     conditions are met:
> + *
> + *      - Redistributions of source code must retain the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer.
> + *
> + *      - Redistributions in binary form must reproduce the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer in the documentation and/or other materials
> + *        provided with the distribution.
>   *
>   * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
>   * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> diff --git a/drivers/infiniband/hw/usnic/usnic_debugfs.c b/drivers/infi=
niband/hw/usnic/usnic_debugfs.c
> index 5d13860..5e55b8b 100644
> --- a/drivers/infiniband/hw/usnic/usnic_debugfs.c
> +++ b/drivers/infiniband/hw/usnic/usnic_debugfs.c
> @@ -1,9 +1,24 @@
>  /*
>   * Copyright (c) 2013, Cisco Systems, Inc. All rights reserved.
>   *
> - * This program is free software; you may redistribute it and/or modif=
y
> - * it under the terms of the GNU General Public License as published b=
y
> - * the Free Software Foundation; version 2 of the License.
> + * This software is available to you under a choice of one of two
> + * licenses.  You may choose to be licensed under the terms of the GNU=

> + * General Public License (GPL) Version 2, available from the file
> + * COPYING in the main directory of this source tree, or the
> + * BSD license below:
> + *
> + *     Redistribution and use in source and binary forms, with or
> + *     without modification, are permitted provided that the following=

> + *     conditions are met:
> + *
> + *      - Redistributions of source code must retain the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer.
> + *
> + *      - Redistributions in binary form must reproduce the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer in the documentation and/or other materials
> + *        provided with the distribution.
>   *
>   * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
>   * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> diff --git a/drivers/infiniband/hw/usnic/usnic_debugfs.h b/drivers/infi=
niband/hw/usnic/usnic_debugfs.h
> index 4087d24..98453e9 100644
> --- a/drivers/infiniband/hw/usnic/usnic_debugfs.h
> +++ b/drivers/infiniband/hw/usnic/usnic_debugfs.h
> @@ -1,9 +1,24 @@
>  /*
>   * Copyright (c) 2013, Cisco Systems, Inc. All rights reserved.
>   *
> - * This program is free software; you may redistribute it and/or modif=
y
> - * it under the terms of the GNU General Public License as published b=
y
> - * the Free Software Foundation; version 2 of the License.
> + * This software is available to you under a choice of one of two
> + * licenses.  You may choose to be licensed under the terms of the GNU=

> + * General Public License (GPL) Version 2, available from the file
> + * COPYING in the main directory of this source tree, or the
> + * BSD license below:
> + *
> + *     Redistribution and use in source and binary forms, with or
> + *     without modification, are permitted provided that the following=

> + *     conditions are met:
> + *
> + *      - Redistributions of source code must retain the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer.
> + *
> + *      - Redistributions in binary form must reproduce the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer in the documentation and/or other materials
> + *        provided with the distribution.
>   *
>   * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
>   * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> diff --git a/drivers/infiniband/hw/usnic/usnic_fwd.c b/drivers/infiniba=
nd/hw/usnic/usnic_fwd.c
> index e3c9bd9..3c37dd5 100644
> --- a/drivers/infiniband/hw/usnic/usnic_fwd.c
> +++ b/drivers/infiniband/hw/usnic/usnic_fwd.c
> @@ -1,9 +1,24 @@
>  /*
>   * Copyright (c) 2013, Cisco Systems, Inc. All rights reserved.
>   *
> - * This program is free software; you may redistribute it and/or modif=
y
> - * it under the terms of the GNU General Public License as published b=
y
> - * the Free Software Foundation; version 2 of the License.
> + * This software is available to you under a choice of one of two
> + * licenses.  You may choose to be licensed under the terms of the GNU=

> + * General Public License (GPL) Version 2, available from the file
> + * COPYING in the main directory of this source tree, or the
> + * BSD license below:
> + *
> + *     Redistribution and use in source and binary forms, with or
> + *     without modification, are permitted provided that the following=

> + *     conditions are met:
> + *
> + *      - Redistributions of source code must retain the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer.
> + *
> + *      - Redistributions in binary form must reproduce the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer in the documentation and/or other materials
> + *        provided with the distribution.
>   *
>   * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
>   * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> diff --git a/drivers/infiniband/hw/usnic/usnic_fwd.h b/drivers/infiniba=
nd/hw/usnic/usnic_fwd.h
> index 93713a2..3a8add9 100644
> --- a/drivers/infiniband/hw/usnic/usnic_fwd.h
> +++ b/drivers/infiniband/hw/usnic/usnic_fwd.h
> @@ -1,9 +1,24 @@
>  /*
>   * Copyright (c) 2013, Cisco Systems, Inc. All rights reserved.
>   *
> - * This program is free software; you may redistribute it and/or modif=
y
> - * it under the terms of the GNU General Public License as published b=
y
> - * the Free Software Foundation; version 2 of the License.
> + * This software is available to you under a choice of one of two
> + * licenses.  You may choose to be licensed under the terms of the GNU=

> + * General Public License (GPL) Version 2, available from the file
> + * COPYING in the main directory of this source tree, or the
> + * BSD license below:
> + *
> + *     Redistribution and use in source and binary forms, with or
> + *     without modification, are permitted provided that the following=

> + *     conditions are met:
> + *
> + *      - Redistributions of source code must retain the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer.
> + *
> + *      - Redistributions in binary form must reproduce the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer in the documentation and/or other materials
> + *        provided with the distribution.
>   *
>   * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
>   * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> diff --git a/drivers/infiniband/hw/usnic/usnic_ib.h b/drivers/infiniban=
d/hw/usnic/usnic_ib.h
> index e5a9297..525bf27 100644
> --- a/drivers/infiniband/hw/usnic/usnic_ib.h
> +++ b/drivers/infiniband/hw/usnic/usnic_ib.h
> @@ -1,9 +1,24 @@
>  /*
>   * Copyright (c) 2013, Cisco Systems, Inc. All rights reserved.
>   *
> - * This program is free software; you may redistribute it and/or modif=
y
> - * it under the terms of the GNU General Public License as published b=
y
> - * the Free Software Foundation; version 2 of the License.
> + * This software is available to you under a choice of one of two
> + * licenses.  You may choose to be licensed under the terms of the GNU=

> + * General Public License (GPL) Version 2, available from the file
> + * COPYING in the main directory of this source tree, or the
> + * BSD license below:
> + *
> + *     Redistribution and use in source and binary forms, with or
> + *     without modification, are permitted provided that the following=

> + *     conditions are met:
> + *
> + *      - Redistributions of source code must retain the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer.
> + *
> + *      - Redistributions in binary form must reproduce the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer in the documentation and/or other materials
> + *        provided with the distribution.
>   *
>   * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
>   * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> diff --git a/drivers/infiniband/hw/usnic/usnic_ib_main.c b/drivers/infi=
niband/hw/usnic/usnic_ib_main.c
> index 34c49b8..0c15bd8 100644
> --- a/drivers/infiniband/hw/usnic/usnic_ib_main.c
> +++ b/drivers/infiniband/hw/usnic/usnic_ib_main.c
> @@ -1,9 +1,24 @@
>  /*
>   * Copyright (c) 2013, Cisco Systems, Inc. All rights reserved.
>   *
> - * This program is free software; you may redistribute it and/or modif=
y
> - * it under the terms of the GNU General Public License as published b=
y
> - * the Free Software Foundation; version 2 of the License.
> + * This software is available to you under a choice of one of two
> + * licenses.  You may choose to be licensed under the terms of the GNU=

> + * General Public License (GPL) Version 2, available from the file
> + * COPYING in the main directory of this source tree, or the
> + * BSD license below:
> + *
> + *     Redistribution and use in source and binary forms, with or
> + *     without modification, are permitted provided that the following=

> + *     conditions are met:
> + *
> + *      - Redistributions of source code must retain the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer.
> + *
> + *      - Redistributions in binary form must reproduce the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer in the documentation and/or other materials
> + *        provided with the distribution.
>   *
>   * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
>   * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> diff --git a/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c b/drivers/in=
finiband/hw/usnic/usnic_ib_qp_grp.c
> index db3588d..85dc3f9 100644
> --- a/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
> +++ b/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
> @@ -1,9 +1,24 @@
>  /*
>   * Copyright (c) 2013, Cisco Systems, Inc. All rights reserved.
>   *
> - * This program is free software; you may redistribute it and/or modif=
y
> - * it under the terms of the GNU General Public License as published b=
y
> - * the Free Software Foundation; version 2 of the License.
> + * This software is available to you under a choice of one of two
> + * licenses.  You may choose to be licensed under the terms of the GNU=

> + * General Public License (GPL) Version 2, available from the file
> + * COPYING in the main directory of this source tree, or the
> + * BSD license below:
> + *
> + *     Redistribution and use in source and binary forms, with or
> + *     without modification, are permitted provided that the following=

> + *     conditions are met:
> + *
> + *      - Redistributions of source code must retain the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer.
> + *
> + *      - Redistributions in binary form must reproduce the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer in the documentation and/or other materials
> + *        provided with the distribution.
>   *
>   * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
>   * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> diff --git a/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.h b/drivers/in=
finiband/hw/usnic/usnic_ib_qp_grp.h
> index b0aafe8..b1458be 100644
> --- a/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.h
> +++ b/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.h
> @@ -1,9 +1,24 @@
>  /*
>   * Copyright (c) 2013, Cisco Systems, Inc. All rights reserved.
>   *
> - * This program is free software; you may redistribute it and/or modif=
y
> - * it under the terms of the GNU General Public License as published b=
y
> - * the Free Software Foundation; version 2 of the License.
> + * This software is available to you under a choice of one of two
> + * licenses.  You may choose to be licensed under the terms of the GNU=

> + * General Public License (GPL) Version 2, available from the file
> + * COPYING in the main directory of this source tree, or the
> + * BSD license below:
> + *
> + *     Redistribution and use in source and binary forms, with or
> + *     without modification, are permitted provided that the following=

> + *     conditions are met:
> + *
> + *      - Redistributions of source code must retain the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer.
> + *
> + *      - Redistributions in binary form must reproduce the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer in the documentation and/or other materials
> + *        provided with the distribution.
>   *
>   * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
>   * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> diff --git a/drivers/infiniband/hw/usnic/usnic_ib_sysfs.c b/drivers/inf=
iniband/hw/usnic/usnic_ib_sysfs.c
> index 27dc67c..3412ea0 100644
> --- a/drivers/infiniband/hw/usnic/usnic_ib_sysfs.c
> +++ b/drivers/infiniband/hw/usnic/usnic_ib_sysfs.c
> @@ -1,9 +1,24 @@
>  /*
>   * Copyright (c) 2013, Cisco Systems, Inc. All rights reserved.
>   *
> - * This program is free software; you may redistribute it and/or modif=
y
> - * it under the terms of the GNU General Public License as published b=
y
> - * the Free Software Foundation; version 2 of the License.
> + * This software is available to you under a choice of one of two
> + * licenses.  You may choose to be licensed under the terms of the GNU=

> + * General Public License (GPL) Version 2, available from the file
> + * COPYING in the main directory of this source tree, or the
> + * BSD license below:
> + *
> + *     Redistribution and use in source and binary forms, with or
> + *     without modification, are permitted provided that the following=

> + *     conditions are met:
> + *
> + *      - Redistributions of source code must retain the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer.
> + *
> + *      - Redistributions in binary form must reproduce the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer in the documentation and/or other materials
> + *        provided with the distribution.
>   *
>   * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
>   * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> diff --git a/drivers/infiniband/hw/usnic/usnic_ib_sysfs.h b/drivers/inf=
iniband/hw/usnic/usnic_ib_sysfs.h
> index 0d09b49..3d98e16 100644
> --- a/drivers/infiniband/hw/usnic/usnic_ib_sysfs.h
> +++ b/drivers/infiniband/hw/usnic/usnic_ib_sysfs.h
> @@ -1,9 +1,24 @@
>  /*
>   * Copyright (c) 2013, Cisco Systems, Inc. All rights reserved.
>   *
> - * This program is free software; you may redistribute it and/or modif=
y
> - * it under the terms of the GNU General Public License as published b=
y
> - * the Free Software Foundation; version 2 of the License.
> + * This software is available to you under a choice of one of two
> + * licenses.  You may choose to be licensed under the terms of the GNU=

> + * General Public License (GPL) Version 2, available from the file
> + * COPYING in the main directory of this source tree, or the
> + * BSD license below:
> + *
> + *     Redistribution and use in source and binary forms, with or
> + *     without modification, are permitted provided that the following=

> + *     conditions are met:
> + *
> + *      - Redistributions of source code must retain the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer.
> + *
> + *      - Redistributions in binary form must reproduce the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer in the documentation and/or other materials
> + *        provided with the distribution.
>   *
>   * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
>   * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> diff --git a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c b/drivers/inf=
iniband/hw/usnic/usnic_ib_verbs.c
> index 7df4382..f8e3211 100644
> --- a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
> +++ b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
> @@ -1,9 +1,24 @@
>  /*
>   * Copyright (c) 2013, Cisco Systems, Inc. All rights reserved.
>   *
> - * This program is free software; you may redistribute it and/or modif=
y
> - * it under the terms of the GNU General Public License as published b=
y
> - * the Free Software Foundation; version 2 of the License.
> + * This software is available to you under a choice of one of two
> + * licenses.  You may choose to be licensed under the terms of the GNU=

> + * General Public License (GPL) Version 2, available from the file
> + * COPYING in the main directory of this source tree, or the
> + * BSD license below:
> + *
> + *     Redistribution and use in source and binary forms, with or
> + *     without modification, are permitted provided that the following=

> + *     conditions are met:
> + *
> + *      - Redistributions of source code must retain the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer.
> + *
> + *      - Redistributions in binary form must reproduce the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer in the documentation and/or other materials
> + *        provided with the distribution.
>   *
>   * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
>   * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> diff --git a/drivers/infiniband/hw/usnic/usnic_ib_verbs.h b/drivers/inf=
iniband/hw/usnic/usnic_ib_verbs.h
> index 0bd04ef..414eaa5 100644
> --- a/drivers/infiniband/hw/usnic/usnic_ib_verbs.h
> +++ b/drivers/infiniband/hw/usnic/usnic_ib_verbs.h
> @@ -1,9 +1,24 @@
>  /*
>   * Copyright (c) 2013, Cisco Systems, Inc. All rights reserved.
>   *
> - * This program is free software; you may redistribute it and/or modif=
y
> - * it under the terms of the GNU General Public License as published b=
y
> - * the Free Software Foundation; version 2 of the License.
> + * This software is available to you under a choice of one of two
> + * licenses.  You may choose to be licensed under the terms of the GNU=

> + * General Public License (GPL) Version 2, available from the file
> + * COPYING in the main directory of this source tree, or the
> + * BSD license below:
> + *
> + *     Redistribution and use in source and binary forms, with or
> + *     without modification, are permitted provided that the following=

> + *     conditions are met:
> + *
> + *      - Redistributions of source code must retain the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer.
> + *
> + *      - Redistributions in binary form must reproduce the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer in the documentation and/or other materials
> + *        provided with the distribution.
>   *
>   * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
>   * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> diff --git a/drivers/infiniband/hw/usnic/usnic_log.h b/drivers/infiniba=
nd/hw/usnic/usnic_log.h
> index 75777a6..183fcb6 100644
> --- a/drivers/infiniband/hw/usnic/usnic_log.h
> +++ b/drivers/infiniband/hw/usnic/usnic_log.h
> @@ -1,9 +1,24 @@
>  /*
>   * Copyright (c) 2013, Cisco Systems, Inc. All rights reserved.
>   *
> - * This program is free software; you may redistribute it and/or modif=
y
> - * it under the terms of the GNU General Public License as published b=
y
> - * the Free Software Foundation; version 2 of the License.
> + * This software is available to you under a choice of one of two
> + * licenses.  You may choose to be licensed under the terms of the GNU=

> + * General Public License (GPL) Version 2, available from the file
> + * COPYING in the main directory of this source tree, or the
> + * BSD license below:
> + *
> + *     Redistribution and use in source and binary forms, with or
> + *     without modification, are permitted provided that the following=

> + *     conditions are met:
> + *
> + *      - Redistributions of source code must retain the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer.
> + *
> + *      - Redistributions in binary form must reproduce the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer in the documentation and/or other materials
> + *        provided with the distribution.
>   *
>   * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
>   * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> diff --git a/drivers/infiniband/hw/usnic/usnic_transport.c b/drivers/in=
finiband/hw/usnic/usnic_transport.c
> index ddef6f7..de31838 100644
> --- a/drivers/infiniband/hw/usnic/usnic_transport.c
> +++ b/drivers/infiniband/hw/usnic/usnic_transport.c
> @@ -1,9 +1,24 @@
>  /*
>   * Copyright (c) 2013, Cisco Systems, Inc. All rights reserved.
>   *
> - * This program is free software; you may redistribute it and/or modif=
y
> - * it under the terms of the GNU General Public License as published b=
y
> - * the Free Software Foundation; version 2 of the License.
> + * This software is available to you under a choice of one of two
> + * licenses.  You may choose to be licensed under the terms of the GNU=

> + * General Public License (GPL) Version 2, available from the file
> + * COPYING in the main directory of this source tree, or the
> + * BSD license below:
> + *
> + *     Redistribution and use in source and binary forms, with or
> + *     without modification, are permitted provided that the following=

> + *     conditions are met:
> + *
> + *      - Redistributions of source code must retain the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer.
> + *
> + *      - Redistributions in binary form must reproduce the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer in the documentation and/or other materials
> + *        provided with the distribution.
>   *
>   * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
>   * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> diff --git a/drivers/infiniband/hw/usnic/usnic_transport.h b/drivers/in=
finiband/hw/usnic/usnic_transport.h
> index 7e5dc6d..9a7a2d9 100644
> --- a/drivers/infiniband/hw/usnic/usnic_transport.h
> +++ b/drivers/infiniband/hw/usnic/usnic_transport.h
> @@ -1,9 +1,24 @@
>  /*
>   * Copyright (c) 2013, Cisco Systems, Inc. All rights reserved.
>   *
> - * This program is free software; you may redistribute it and/or modif=
y
> - * it under the terms of the GNU General Public License as published b=
y
> - * the Free Software Foundation; version 2 of the License.
> + * This software is available to you under a choice of one of two
> + * licenses.  You may choose to be licensed under the terms of the GNU=

> + * General Public License (GPL) Version 2, available from the file
> + * COPYING in the main directory of this source tree, or the
> + * BSD license below:
> + *
> + *     Redistribution and use in source and binary forms, with or
> + *     without modification, are permitted provided that the following=

> + *     conditions are met:
> + *
> + *      - Redistributions of source code must retain the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer.
> + *
> + *      - Redistributions in binary form must reproduce the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer in the documentation and/or other materials
> + *        provided with the distribution.
>   *
>   * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
>   * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> diff --git a/drivers/infiniband/hw/usnic/usnic_uiom.c b/drivers/infinib=
and/hw/usnic/usnic_uiom.c
> index cb2337f..645a5f6 100644
> --- a/drivers/infiniband/hw/usnic/usnic_uiom.c
> +++ b/drivers/infiniband/hw/usnic/usnic_uiom.c
> @@ -7,7 +7,7 @@
>   * licenses.  You may choose to be licensed under the terms of the GNU=

>   * General Public License (GPL) Version 2, available from the file
>   * COPYING in the main directory of this source tree, or the
> - * OpenIB.org BSD license below:
> + * BSD license below:
>   *
>   *     Redistribution and use in source and binary forms, with or
>   *     without modification, are permitted provided that the following=

> diff --git a/drivers/infiniband/hw/usnic/usnic_uiom.h b/drivers/infinib=
and/hw/usnic/usnic_uiom.h
> index 7044099..45ca7c1 100644
> --- a/drivers/infiniband/hw/usnic/usnic_uiom.h
> +++ b/drivers/infiniband/hw/usnic/usnic_uiom.h
> @@ -1,9 +1,24 @@
>  /*
>   * Copyright (c) 2013, Cisco Systems, Inc. All rights reserved.
>   *
> - * This program is free software; you may redistribute it and/or modif=
y
> - * it under the terms of the GNU General Public License as published b=
y
> - * the Free Software Foundation; version 2 of the License.
> + * This software is available to you under a choice of one of two
> + * licenses.  You may choose to be licensed under the terms of the GNU=

> + * General Public License (GPL) Version 2, available from the file
> + * COPYING in the main directory of this source tree, or the
> + * BSD license below:
> + *
> + *     Redistribution and use in source and binary forms, with or
> + *     without modification, are permitted provided that the following=

> + *     conditions are met:
> + *
> + *      - Redistributions of source code must retain the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer.
> + *
> + *      - Redistributions in binary form must reproduce the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer in the documentation and/or other materials
> + *        provided with the distribution.
>   *
>   * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
>   * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> diff --git a/drivers/infiniband/hw/usnic/usnic_uiom_interval_tree.c b/d=
rivers/infiniband/hw/usnic/usnic_uiom_interval_tree.c
> index 3a4288e..42b4b4c 100644
> --- a/drivers/infiniband/hw/usnic/usnic_uiom_interval_tree.c
> +++ b/drivers/infiniband/hw/usnic/usnic_uiom_interval_tree.c
> @@ -1,9 +1,24 @@
>  /*
>   * Copyright (c) 2014, Cisco Systems, Inc. All rights reserved.
>   *
> - * This program is free software; you may redistribute it and/or modif=
y
> - * it under the terms of the GNU General Public License as published b=
y
> - * the Free Software Foundation; version 2 of the License.
> + * This software is available to you under a choice of one of two
> + * licenses.  You may choose to be licensed under the terms of the GNU=

> + * General Public License (GPL) Version 2, available from the file
> + * COPYING in the main directory of this source tree, or the
> + * BSD license below:
> + *
> + *     Redistribution and use in source and binary forms, with or
> + *     without modification, are permitted provided that the following=

> + *     conditions are met:
> + *
> + *      - Redistributions of source code must retain the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer.
> + *
> + *      - Redistributions in binary form must reproduce the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer in the documentation and/or other materials
> + *        provided with the distribution.
>   *
>   * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
>   * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> diff --git a/drivers/infiniband/hw/usnic/usnic_uiom_interval_tree.h b/d=
rivers/infiniband/hw/usnic/usnic_uiom_interval_tree.h
> index d4f752e..c0b0b87 100644
> --- a/drivers/infiniband/hw/usnic/usnic_uiom_interval_tree.h
> +++ b/drivers/infiniband/hw/usnic/usnic_uiom_interval_tree.h
> @@ -1,9 +1,24 @@
>  /*
>   * Copyright (c) 2013, Cisco Systems, Inc. All rights reserved.
>   *
> - * This program is free software; you may redistribute it and/or modif=
y
> - * it under the terms of the GNU General Public License as published b=
y
> - * the Free Software Foundation; version 2 of the License.
> + * This software is available to you under a choice of one of two
> + * licenses.  You may choose to be licensed under the terms of the GNU=

> + * General Public License (GPL) Version 2, available from the file
> + * COPYING in the main directory of this source tree, or the
> + * BSD license below:
> + *
> + *     Redistribution and use in source and binary forms, with or
> + *     without modification, are permitted provided that the following=

> + *     conditions are met:
> + *
> + *      - Redistributions of source code must retain the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer.
> + *
> + *      - Redistributions in binary form must reproduce the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer in the documentation and/or other materials
> + *        provided with the distribution.
>   *
>   * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
>   * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> diff --git a/drivers/infiniband/hw/usnic/usnic_vnic.c b/drivers/infinib=
and/hw/usnic/usnic_vnic.c
> index 656b88c..66de93f 100644
> --- a/drivers/infiniband/hw/usnic/usnic_vnic.c
> +++ b/drivers/infiniband/hw/usnic/usnic_vnic.c
> @@ -1,9 +1,24 @@
>  /*
>   * Copyright (c) 2013, Cisco Systems, Inc. All rights reserved.
>   *
> - * This program is free software; you may redistribute it and/or modif=
y
> - * it under the terms of the GNU General Public License as published b=
y
> - * the Free Software Foundation; version 2 of the License.
> + * This software is available to you under a choice of one of two
> + * licenses.  You may choose to be licensed under the terms of the GNU=

> + * General Public License (GPL) Version 2, available from the file
> + * COPYING in the main directory of this source tree, or the
> + * BSD license below:
> + *
> + *     Redistribution and use in source and binary forms, with or
> + *     without modification, are permitted provided that the following=

> + *     conditions are met:
> + *
> + *      - Redistributions of source code must retain the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer.
> + *
> + *      - Redistributions in binary form must reproduce the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer in the documentation and/or other materials
> + *        provided with the distribution.
>   *
>   * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
>   * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> diff --git a/drivers/infiniband/hw/usnic/usnic_vnic.h b/drivers/infinib=
and/hw/usnic/usnic_vnic.h
> index 14d931a..a08423e 100644
> --- a/drivers/infiniband/hw/usnic/usnic_vnic.h
> +++ b/drivers/infiniband/hw/usnic/usnic_vnic.h
> @@ -1,9 +1,24 @@
>  /*
>   * Copyright (c) 2013, Cisco Systems, Inc. All rights reserved.
>   *
> - * This program is free software; you may redistribute it and/or modif=
y
> - * it under the terms of the GNU General Public License as published b=
y
> - * the Free Software Foundation; version 2 of the License.
> + * This software is available to you under a choice of one of two
> + * licenses.  You may choose to be licensed under the terms of the GNU=

> + * General Public License (GPL) Version 2, available from the file
> + * COPYING in the main directory of this source tree, or the
> + * BSD license below:
> + *
> + *     Redistribution and use in source and binary forms, with or
> + *     without modification, are permitted provided that the following=

> + *     conditions are met:
> + *
> + *      - Redistributions of source code must retain the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer.
> + *
> + *      - Redistributions in binary form must reproduce the above
> + *        copyright notice, this list of conditions and the following
> + *        disclaimer in the documentation and/or other materials
> + *        provided with the distribution.
>   *
>   * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
>   * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--5mWP8HVUBKurk7uoGtrrAHece4n7RlW2q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWFBAdAAoJELgmozMOVy/dcicQAJwaJaMgh9a9kf91uTK6lfr4
FAUlj5+pLwAvHBEkJ+ag5EVkUAEHqHwh3+qBeRxzNrwzF+wUtReb9RRwNDMS6sud
VHQDq5Kgz2PE0uzgL+D8/WO1OXi4i+0a46NU7gJoaQGeZE3upzOqvAAceHiunOVU
6uksP6Mm4qKZloMd350FrTzk8xYbEw+HZ/s1HCnD3Vb/GG1yZF/YVawFNjYgWDi0
1OHCyQY0hgBQ7jVyMI9qp55JGWNPXRNZPjlR8QuVEG7YqPr6XbBeOWSAl05cLDSh
cPYyf24njqhfKH0VS9lpr5HNrr9j1nfSlkOj+RXrB7NiGBRWNXEiusd7Lj+43USV
UC5F5TJCEvUWBkbbYddO71ocyQOfcq8mcNky4jTDUe75mDZu8cT7dnVJKjjjhUeb
CqdfS/BH5vXDKPlDvmQarzqAWnNeoF9XoeYRPPSL+UsqLFDY2ZP66WUpvL6jCeOz
vEOBvA9ptXw6BH6m6oslCL0iYC7EFk/gxRQeh6ZCB2MTEwImR4ob01XCu0t/S1ux
gwqcWLJq0kOxxPHc6sBad6MVlKOzUG/rbRk0AH+WVKRLjKxrD2GUOU/oZwxEjQdo
CLzHnZV3+xRQMs3ztfSyN8M5rrXyhUgrNp1WhRNYEfih2c1Hn+1a+GffjJ2kTgm5
sZjZq0cf171Gjw6NrCn2
=0oaS
-----END PGP SIGNATURE-----

--5mWP8HVUBKurk7uoGtrrAHece4n7RlW2q--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

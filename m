Return-Path: <SRS0=tt2b=BD=vger.kernel.org=linux-rdma-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B509AC433E0
	for <linux-rdma@archiver.kernel.org>; Fri, 24 Jul 2020 08:41:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 993E920674
	for <linux-rdma@archiver.kernel.org>; Fri, 24 Jul 2020 08:41:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbgGXIlP (ORCPT <rfc822;linux-rdma@archiver.kernel.org>);
        Fri, 24 Jul 2020 04:41:15 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:37428 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726591AbgGXIlO (ORCPT
        <rfc822;linux-rdma@vger.kernel.org>); Fri, 24 Jul 2020 04:41:14 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 4E5861C0BD2; Fri, 24 Jul 2020 10:41:13 +0200 (CEST)
Date:   Fri, 24 Jul 2020 10:41:12 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     dledford@redhat.com, jgg@ziepe.ca, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: [PATCH] RDMA/mlx5: fix typo in structure name
Message-ID: <20200724084112.GC31930@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="VywGB/WGlW4DM4P8"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-rdma-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-rdma.vger.kernel.org>
X-Mailing-List: linux-rdma@vger.kernel.org


--VywGB/WGlW4DM4P8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

This is user API, but likely noone uses it...? Fix it before it
becomes problem.

Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>


diff --git a/include/uapi/rdma/mlx5_user_ioctl_cmds.h b/include/uapi/rdma/m=
lx5_user_ioctl_cmds.h
index 8e316ef896b5..2d889df38df6 100644
--- a/include/uapi/rdma/mlx5_user_ioctl_cmds.h
+++ b/include/uapi/rdma/mlx5_user_ioctl_cmds.h
@@ -259,7 +259,7 @@ enum mlx5_ib_create_flow_attrs {
 	MLX5_IB_ATTR_CREATE_FLOW_FLAGS,
 };
=20
-enum mlx5_ib_destoy_flow_attrs {
+enum mlx5_ib_destroy_flow_attrs {
 	MLX5_IB_ATTR_DESTROY_FLOW_HANDLE =3D (1U << UVERBS_ID_NS_SHIFT),
 };
=20

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--VywGB/WGlW4DM4P8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl8anqgACgkQMOfwapXb+vJDugCfaYsiuj7DNwprSvQEpcgL6Ny3
ZI0An1SzQHO9yKKHkQOGUCxPcJlZh9JZ
=fHM/
-----END PGP SIGNATURE-----

--VywGB/WGlW4DM4P8--

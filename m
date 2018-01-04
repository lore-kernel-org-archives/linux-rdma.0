From: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Subject: [ANNOUNCE] rdma-core-15.2 and 16.1 has been tagged/released
Date: Thu, 4 Jan 2018 11:22:28 +0100
Message-ID: <8d19ae60-d090-9b0c-cb42-acaadc57a079@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: fr-xx-classique+reforme1990
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Here's the information from the tags:
tag v15.2
Tagger: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-IBi9RG/b67k@public.gmane.org>
Date:   Thu Jan 4 10:51:06 2018 +0100

rdma-core-15.2:

Updates from version 15.1:
 * Backport fixes:
   * srp_daemon: Don't create async_ev_thread if only run once
   * srp_daemon: handle SM lid change
   * srp_daemon: fix CQ handling
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABAgAGBQJaTfkaAAoJEIAb3bglmI9kfzAH/jrBPrtNzLtbHndrF8SSlIdo
rYisRasrW3bFFsm6NmaZ28Cd1LPrmBLkn6iSkNB4od7A0amjCR/gsYEryhlxqmCb
ue04MVWyPpAbMJPTTIJ51fEeBSYVOJVkv4wIceVjPLALbGf314x7WOHRXRn/HaG4
faL8xx/Pq+1KFEyGIID4gUVI/rMLdPvEb03tykIF39ozJ/xhWtGnW+ik+mxZIz8M
2tTiBUL1/7rQB+m/1T4g8x8A7WtUFDaOaorIzLeDJYgQKi0EhO9CpKt4HlB+rAI8
qGjYJLFWhNtk3e/LW1trYFyDl4c5XQ16B9gRYIQFWrOuqBQcZi5HqTe9tl20FFc=
=iZ0B
-----END PGP SIGNATURE-----


tag v16.1
Tagger: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-IBi9RG/b67k@public.gmane.org>
Date:   Thu Jan 4 09:33:09 2018 +0100

rdma-core-16.1:

Updates from version 16:
 * Backport fixes:
   * srp_daemon: Don't create async_ev_thread if only run once
   * srp_daemon: handle SM lid change
   * srp_daemon: fix CQ handling
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABAgAGBQJaTebLAAoJEIAb3bglmI9kjNUH+wayraL0L66QVi4VB92bBSzw
qc7neTTid2H9eOHCigTD4bZLNFfFiuUC5zjjYqBs4DHp5A0M3E3JtDR86ieTrqDZ
w+WvEalxEgGZir+eTmksIU4ft4v6UD4+VKvK5h3wGansJ4ZoI5EaGt4tvS65j5Bn
+mZNjHR9wfA3ky0w0Nt1A8WkVqXSWkXOsCYAjMikUUROh4gVvjuZwvrXry06/KLR
JrFMK/gcPjjnv2B+XS6yb7orORmtwBir6btSmXuDop2cT59W+6adCdME19JVaaNJ
zSSWSWPGcLcLMfsFxWamyEvYx4q20BRoW0JCCi3QN8sPvvEgYHqQqJhPNLQ0dX4=
=VsrY
-----END PGP SIGNATURE-----


It's available at the normal places:

git://github.com/linux-rdma/rdma-core
https://github.com/linux-rdma/rdma-core/releases


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Subject: [ANNOUNCE] rdma-core-15.1 has been tagged/released
Date: Wed, 29 Nov 2017 09:38:17 +0100
Message-ID: <1759aa23-7bae-b48b-b870-b4093a9c0320@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: fr-xx-classique+reforme1990
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Here's the information from the tag:

tag v15.1
Tagger: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-IBi9RG/b67k@public.gmane.org>
Date:   Tue Nov 28 11:17:49 2017 +0100

rdma-core-15.1

Updates from version 15:
 * Backport CI checks on centos/SUSE from master
 * Stable ABI auto checks
 * Backport fixes:
   * verbs: Do not block QP attr_masks used by older kernels
   * libibumad/umad.c: In get_port, ignore sysfs rate file errors
   * bnxt_re/lib: fix the memory barrier call during poll-cq
   * bnxt_re/lib: increment psn in case of 0 length packets
   * libqedr: fix inline data copy
   * verbs: Fix declaration of C++ include file in C-block
   * verbs: Fix C++ compilation break
   * verbs: fix compilation error with ICC
   * hns: Fix create QP structure layout
   * ibacm: Incorrect list used for subnet list causes a segfault
   * ibacm: Incorrect usage of BE byte order of MLID attach/detach_mcast()
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABAgAGBQJaHTgyAAoJEIAb3bglmI9k65oH/RGnAKB8xZLQ38f2DhyD1a3G
TBlPY8Koh8LoQWNTWu7Q1dprW5ePivf6AtA1XfoM7rTboHzbr6uOZxaJXFrBwa0u
e2Ec1qkRtBcUNLYhuafYQ8O1RvXmO4xtZt/VImMFSQ7/mvAwlFcW8OZswdzUtV0a
0Izt5UWPd8ZixfMeHbNTw74LE1v+/LybXT6D2994yr1ZrLyayHtgh7dR2iI6ryv6
tz2kcbEo17qgdB7T4EX3vWLm1g+M1bSQaWEz7X8km/f6ugXyV35Ju26qb8IlDxmY
6YBDbLRUCDu1g82HGOJUOrDvbx+KUMY1W5EAtnupb05ijW66U0c9uEUFk4wc+/M=
=5JJn
-----END PGP SIGNATURE-----

It's available at the normal places:

git://github.com/linux-rdma/rdma-core
https://github.com/linux-rdma/rdma-core/releases

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

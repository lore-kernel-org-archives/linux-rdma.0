From: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH rdma-core 0/3] cbuild tweaks
Date: Fri, 4 Aug 2017 18:57:48 +0200
Message-ID: <27366048-d80f-3711-c6cd-93c87809650e@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: fr-xx-classique+reforme1990
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Few minor cbuild tweaks needed to upstream SUSE spec file
The first one is purely cosmetic to qllow alignment in the spec file

The two other could be worked around by changing the SUSE spec but it means it won't be 100% match with the upstream one.

Nicolas Morey-Chaisemartin (3):
  cbuild: allow indentation in RPM version
  cbuild: support .tar.(gz|bz|>...) extensions
  cbuild: use rpmspec for macro replacement

 .gitignore      |  3 +++
 buildlib/cbuild | 14 +++++++++-----
 2 files changed, 12 insertions(+), 5 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

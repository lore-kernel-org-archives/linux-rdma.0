From: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH rdma-core 0/4] Cleanp SUSE Tumbleweed build
Date: Wed, 8 Nov 2017 15:30:38 +0100
Message-ID: <627d02ab-1e95-8e1e-c7d3-f3db02fce75a@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: fr-xx-classique+reforme1990
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This series is to fix the issue reported by Alaa here: https://www.spinics.net/lists/linux-rdma/msg56580.html

#1 adds details on the existing situation and an option in the spec file to allow rpmbuild to work
#2 adds support for env specific rpmbuild options
#3 Add the option from #1 to the tumbleweed env
#4 switches the default SUSE env to tumbleweed for validation

Nicolas Morey-Chaisemartin (4):
  suse: add a bcond to disable usage of curl-mini
  cbuild: allow envs to pass custom options to rpmbuild
  cbuild: disable curl-mini usage for tumbleweed env
  buidlib: validate tumbleweed instead of leap 42.3

 buildlib/cbuild             |  4 +++-
 buildlib/package-build-test |  2 +-
 suse/rdma-core.spec         | 12 ++++++++++++
 3 files changed, 16 insertions(+), 2 deletions(-)

-- 
2.14.1.461.g503560879

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

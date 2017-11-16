From: Nicolas Morey-Chaisemartin <nmoreychaisemartin-IBi9RG/b67k@public.gmane.org>
Subject: [PATCHv2 rdma-core 0/5] ABI consistency check
Date: Thu, 16 Nov 2017 18:35:05 +0100
Message-ID: <551ccda1-bb8d-45bf-1c7c-22a82fc64efc@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: fr-xx-classique+reforme1990
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Add scripts to generate an ABI dump and compare against a ref.
Travis will automatically do that if a ref is present.
Ref should be added at stable-* branch creation (see doc update)


Changes since v1:
- Import tools as submodules instead of sources.
  Less clutter and no licensing issue.
- Only run gen-abi in travis-checkbuild IF the reference ABI is present (avoid useless ABI builds on the master branch)

Nicolas Morey-Chaisemartin (5):
buidlib: import abi checking tools
buildlib: add script to dump ABI
buildlib: add script to check ABI
buildlib: run ABI check in travis-build
Documentation: update stable doc about ABI reference generation

.gitmodules | 6 ++++++
Documentation/stable.md | 19 ++++++++++++++++++-
buildlib/abi-compliance-checker | 1 +
buildlib/abi-dumper | 1 +
buildlib/gen-abi | 21 +++++++++++++++++++++
buildlib/travis-build | 4 ++++
buildlib/travis-checkabi | 29 +++++++++++++++++++++++++++++
7 files changed, 80 insertions(+), 1 deletion(-)
create mode 100644 .gitmodules
create mode 160000 buildlib/abi-compliance-checker
create mode 160000 buildlib/abi-dumper
create mode 100755 buildlib/gen-abi
create mode 100755 buildlib/travis-checkabi

-- 
2.15.0.168.g9a51f1b30.dirty

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v1 0/4] Use same proto= after traversing a referral
Date: Mon, 04 Dec 2017 14:13:22 -0500
Message-ID: <20171204190904.18629.70341.stgit@manet.1015granger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Anna-

Today when the Linux client traverses an NFSv4 referral, it always
chooses proto=tcp on the submount. This means following a referral
on an NFS/RDMA mount will always make the submounts use TCP, which
is not desirable. These patches make the client try NFS/RDMA first
when traversing a referral so that submounts will continue to use
NFS/RDMA.

Please consider this series for v4.16.

---

Chuck Lever (4):
      nfs: Define NFS_RDMA_PORT
      nfs: Referrals should use the same proto setting as their parent
      nfs: Update server port after referral or migration
      SUNRPC: Remove rpc_protocol()


 fs/nfs/nfs4client.c         |   24 +++++++++++++++++++++---
 fs/nfs/nfs4namespace.c      |    2 --
 include/linux/sunrpc/clnt.h |    1 -
 include/uapi/linux/nfs.h    |    1 +
 net/sunrpc/clnt.c           |   16 ----------------
 5 files changed, 22 insertions(+), 22 deletions(-)

--
Chuck Lever
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

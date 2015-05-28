From: Shirley Ma <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: NFSoRDMA bi-weekly developers meeting minutes (5/28/15)
Date: Thu, 28 May 2015 11:11:30 -0700
Message-ID: <55675A52.1010700@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Charles EDWARD Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org" <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, "devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org" <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "dominique.martinet-KCE40YydGKI@public.gmane.org" <dominique.martinet-KCE40YydGKI@public.gmane.org>, "jeffrey.c.becker-NSQ8wuThN14@public.gmane.org" <jeffrey.c.becker-NSQ8wuThN14@public.gmane.org>, "rsdance-rzwDkyJvnYokmLvzuZlaBw@public.gmane.org" <rsdance-rzwDkyJvnYokmLvzuZlaBw@public.gmane.org>, "skc-YOWKrPYUwWM@public.gmane.org" <skc-YOWKrPYUwWM@public.gmane.org>, "sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "SteveD-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <SteveD-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "wendy.cheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <wendy.cheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Attendees:

Jeff Becker (NASA)
Yan Burman (Mellanox)
Chuck Lever (Oracle)
Rupert Dance (Soft Forge)
Steve Dickson (Red Hat)
Shirley Ma (Oracle)
Anna Schumaker (Net App)
Devesh Sharma (Avago Tech)

Today's meeting notes:

NFSoRDMA deployment (Jeff)
-------------------
NASA is interested in deployment NFS/RDMA, it's on the table.

NFSoRDMA RFC update (Chuck)
--------------------
Updating IETF specifications for RPC/RDMA (RGFC5666) and NFS/RDMA (RFC5=
667) to close the holes that might cause confusion. We=E2=80=99d like t=
o replace RFC 5666 with a new document that fixes problems with the RPC=
/RDMA version 1 protocol; and replace RFC 5667 with a new document that=
 fills in missing or
incorrect items with regard to NFSv4.0 and NFSv4.1 (and pNFS). There wi=
ll be no protocol changes that would break backwards compatibility.

Chuck has published an experimental draft describing the conventions ne=
eded for bi-directional RPC/RDMA:
https://datatracker.ietf.org/doc/draft-cel-nfsv4-rpcrdma-bidirection/

NFSoRDMA bi-directional implementation (Chuck)
---------------------------------------
Chuck has done an experimental implementation, which has been tested am=
ong Linux client, Linux server, Solaris client and Solaris server. NFS/=
RDMA bi-directional support is targeted in Linux 4.3 or 4.4, which migh=
t be available 6 months later.

Wireshark dissectors support RPC/RDMA, NFS/RDMA (Yan)
-----------------------------------------------
Yan and his team have been working on wireshark dissectors to support R=
PC/RDMA, NFS/RDMA. The patches will be submitted next week for review. =
This is a good news for debugging NFS/RDMA problems.

NFS/RDMA client and server shutdown issue (Nevesh, Shirley)
-----------------------------------------
Any outstanding mounts will prevent both client and server from shut do=
wn properly. The right fix is to handle CM_DEVICE_REMOVAL properly so t=
he resources being allocated can be gracefully clean up. We can suggest=
 umount before shutdown the client to avoid this issue, but on server s=
ide, we need to add a handler to handle outstanding cm_ids, which is no=
t presented in current implementation.

NFSD workqueue mode vs. threading mode performance impacts: (Shirley)
---------------------------------------------------------------------
Shirley has spent sometime test/fix/evaluating NFSD workqueue mode orig=
inally implemented by Jeff Layton. NFSD workqueue patchset NFSD workque=
ue modes benefit some workloads while global threading mode benefits so=
me other workloads. workqueue mode is better than per-cpu threading mod=
e in general. workqueue is per-cpu workqueue while global threading mod=
e is not per-cpu based. There might be some room to make NFSD workqueue=
 not worse than global threading mode, but this requires to do more in =
depth performance investigation work.

=46eel free to reply here for anything missing or incorrect. Thanks eve=
ryone for joining the call and providing valuable inputs/work to the co=
mmunity to make NFSoRDMA better.

Cheers,
Shirley
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

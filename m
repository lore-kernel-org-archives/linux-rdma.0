From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: 0-day service tree move for rdma
Date: Fri, 8 Dec 2017 17:11:11 -0700
Message-ID: <20171209001111.GA23222@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="liOOAslEiF7prFVr"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: kbuild-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, Fengguang Wu <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--liOOAslEiF7prFVr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Fengguang,

RDMA has moved to a co-maintainer and shared tree model for our
official repo, can you update the 0-day build service information?

I looked at your lktp git tree and came up with the patch below, not
sure it is totally right, and wasn't able to check 'subsystems'..

The main thing is we'd like to test all branches in rdma.git, and
loose patches posted to our mailing list (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)
and both of us would receive email'd build completion notifications.

Thank you for running this service, we in the RDMA community have
found it valuable!

Regards,
Jason

=46rom 7d783252c64be7ece381e0f60fd272c17ebb35e4 Mon Sep 17 00:00:00 2001
=46rom: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date: Fri, 8 Dec 2017 17:03:31 -0700
Subject: [PATCH] repo: Update rmda repos

RDMA is now co-maintained by Doug & Jason and has a new git location
- Delete the very old 'infiniband' repo, this is not used and
  Doug is not the owner.
- Move the 'rdma' repo from kernel.org/dledford to kernel.org/rdma
  which is the new location for the co-maintained tree

Our development model works as:
 - Patches posted to linux-rdma@vger are against the for-next
   branch of the rdma.git
 - Stephen uses tags/for-text (which closely tracks heads/for-next)
   to construct linux-next
 - Build success notifications to be emailed to both owners
 - 0-day to test all branches in the repo

Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 repo/linux/infiniband |  6 ------
 repo/linux/rdma       | 10 +++++++---
 2 files changed, 7 insertions(+), 9 deletions(-)
 delete mode 100644 repo/linux/infiniband

diff --git a/repo/linux/infiniband b/repo/linux/infiniband
deleted file mode 100644
index 3005d3e1e38ed5..00000000000000
--- a/repo/linux/infiniband
+++ /dev/null
@@ -1,6 +0,0 @@
-url: https://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git
-owner: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
-git_am_branch: for-next
-subsystems:
-- ib
-mail_cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
\ No newline at end of file
diff --git a/repo/linux/rdma b/repo/linux/rdma
index b2e2bc5aec60c8..75d9200b001f5f 100644
--- a/repo/linux/rdma
+++ b/repo/linux/rdma
@@ -1,7 +1,11 @@
-url: https://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git
+url: https://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git
+git_am_branch: for-next
+integration_testing_branches: for-next
 mail_cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
-owner: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
-git_am_branch: master
+owner:
+- Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
+- Jason Gunthorpe <jgg+lists-uk2M96/98Pc@public.gmane.org>
+notify_build_success_branch: .*
 subsystems:
 - ib
 - iser
--=20
2.15.1


--liOOAslEiF7prFVr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJaKyocAAoJEDht9xV+IJsaNgkP/1OcRqPr7l5Bq2+vcCiFMJhe
41aAJfrsW5t+suzd24yAz1lPeS8mO9Szlvbvfz7PrkAa9cyPDk7oir8EZgEgWb/W
cqPW7cglt43mWGZPYTGUcRWwdZgdZ7SpP9QU8ZqpNZVAGwku5jKPQm1HKrjq+DzW
tv3VEho6z83RqmUvK/WcN5VYmV5ydyw2tCf6Har+AzDcDhCa2E68esIipq1UQZUC
YhWK1rkbxkzO8pjions4J4qKA0knciQObrZFwThbrgerRO8O54OYZCE7iGvxaRE9
2B5kkmEEx9gaRrfjtLvsVnwoMMK0Wou08mUkaaLykCGZQEXbZ7jwMin4CqPedUoy
Pt+DxGS6jgJItYV5Ta3GR/Ud1IE2CqD6tMZS1dhOXOGYiMZ/7wgqzldWezENJXSY
rZL5NaM8ci5oR1dWpMKTrVIVTFFxIcJQzvJNJ8ze1ZAH+2jqF1S62bHr8Aknd2Li
BWJl5858Wms9eGCyYvaPcLIxQ2zpf0WILG5XiG/xUjah7IopRRMQN6TzuBHJ7VMs
Q4T1h1F/AnvtRQsgzVpMcqOew3MyHmeEhLZXmSOu7x38GTI2szlg1k+r8ed4XQTx
XG4BGgELpKooBTfAyxMhwC8+SFcG0vSMbqSwTXSP/CyldzV1r6jpPPB0Tawgf0PX
R/ppvbmXfk4jpI9d9ZT4
=Z3Nw
-----END PGP SIGNATURE-----

--liOOAslEiF7prFVr--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

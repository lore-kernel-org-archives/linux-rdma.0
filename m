From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] IB/srpt: Update sport->port_guid with each port refresh
Date: Wed, 24 Aug 2016 17:38:45 -0400
Message-ID: <716b076ba4b273f5f85c97448c5110c6d21e73e6.1472072382.git.dledford@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

If port_guid is set with the default subnet_prefix, then we get a change
event and run a port refresh, we don't update the port_guid.  As a
result, attempts to create a target device that uses the new
subnet_prefix in the wwn will fail to find a match and be rejected by
the ib_srpt driver.  This makes it impossible to configure a port if it
was initialized with a default subnet_prefix and later changed to any
non-default subnet-prefix.  Updating the port refresh task to always
update the wwn based upon the current subnext_prefix solves this
problem.

Cc: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org
Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

---

Bart, Nicholas;

This doesn't entirely resolve the problem I'm seeing here.  It only fixes
one part of it, the ability to set the config once the right subnet_prefix
is known.  There still is the problem of a race condition between the
attempt to configure the target subsystem and the subnet_prefix becoming
known.  It seems what is needed is the ability to enter srpt configuration
even if it doesn't match any known WWNs at the moment, and on a port
refresh, if the WWN changes, we should drop the current config and reload
any other config that the new WWN matches.  But I have no idea how to make
this happen in the target core.  The other option would be to have a
user space dispatcher that reloaded the target config on subnet_prefix
changes, but the lio code would need modified to be able to restrict
the reload to a specific interface or else if the user had changed the
config on another port, then a subnet_prefix change occurred, the
lio code might wipe out the user's custom changes.

---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index dfa23b075a88..883bbfe08e0e 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -522,6 +522,11 @@ static int srpt_refresh_port(struct srpt_port *sport)
 	if (ret)
 		goto err_query_port;
 
+	snprintf(sport->port_guid, sizeof(sport->port_guid),
+		"0x%016llx%016llx",
+		be64_to_cpu(sport->gid.global.subnet_prefix),
+		be64_to_cpu(sport->gid.global.interface_id));
+
 	if (!sport->mad_agent) {
 		memset(&reg_req, 0, sizeof(reg_req));
 		reg_req.mgmt_class = IB_MGMT_CLASS_DEVICE_MGMT;
@@ -2548,10 +2553,6 @@ static void srpt_add_one(struct ib_device *device)
 			       sdev->device->name, i);
 			goto err_ring;
 		}
-		snprintf(sport->port_guid, sizeof(sport->port_guid),
-			"0x%016llx%016llx",
-			be64_to_cpu(sport->gid.global.subnet_prefix),
-			be64_to_cpu(sport->gid.global.interface_id));
 	}
 
 	spin_lock(&srpt_dev_lock);
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

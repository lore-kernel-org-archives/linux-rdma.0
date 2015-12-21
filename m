From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/3] Display extended counter set if available
Date: Mon, 21 Dec 2015 13:31:31 -0600 (CST)
Message-ID: <alpine.DEB.2.20.1512211330290.19955@east.gentwo.org>
References: <20151221142026.238104419@linux.com> <20151221142039.386488696@linux.com> <20151221175311.GI3860@phlsvsds.ph.intel.com> <56783D89.4060704@dev.mellanox.co.il>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56783D89.4060704-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 21 Dec 2015, Hal Rosenstock wrote:

> > Don't we need to change all the sysfs_remove_groups to use get_counter_table as
> > well?
>
> Looks like it to me too. Good catch.

Fix follows:

From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Fix sysfs entry removal by storing the table format in  pma_table

Store the table being used in the ib_port structure and use it when sysfs
entries have to be removed.

Signed-off-by: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>

Index: linux/drivers/infiniband/core/sysfs.c
===================================================================
--- linux.orig/drivers/infiniband/core/sysfs.c
+++ linux/drivers/infiniband/core/sysfs.c
@@ -47,6 +47,7 @@ struct ib_port {
 	struct attribute_group gid_group;
 	struct attribute_group pkey_group;
 	u8                     port_num;
+	struct attribute_group *pma_table;
 };

 struct port_attribute {
@@ -651,7 +652,8 @@ static int add_port(struct ib_device *de
 		return ret;
 	}

-	ret = sysfs_create_group(&p->kobj, get_counter_table(device));
+	p->pma_table = get_counter_table(device);
+	ret = sysfs_create_group(&p->kobj, p->pma_table);
 	if (ret)
 		goto err_put;

@@ -710,7 +712,7 @@ err_free_gid:
 	p->gid_group.attrs = NULL;

 err_remove_pma:
-	sysfs_remove_group(&p->kobj, &pma_group);
+	sysfs_remove_group(&p->kobj, p->pma_table);

 err_put:
 	kobject_put(&p->kobj);
@@ -923,7 +925,7 @@ static void free_port_list_attributes(st
 	list_for_each_entry_safe(p, t, &device->port_list, entry) {
 		struct ib_port *port = container_of(p, struct ib_port, kobj);
 		list_del(&p->entry);
-		sysfs_remove_group(p, &pma_group);
+		sysfs_remove_group(p, port->pma_table);
 		sysfs_remove_group(p, &port->pkey_group);
 		sysfs_remove_group(p, &port->gid_group);
 		kobject_put(p);
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Animesh K Trivedi1 <ATR-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Subject: [PATCH] Fixing segfault in libibverbs
Date: Fri, 27 May 2011 11:58:13 +0200
Message-ID: <OFC348E58C.B4C03447-ONC125789D.0035F094-C125789D.0036C4F7@ch.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Bernard Metzler <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Hi,

This patch fixes SEGFAULT in libibverbs in case when there are no user
space drivers found. I've cloned the libibverbs from
git://git.openfabrics.org/ofed_1_1_5/libibverbs.git (I hope this is
correct)

Example: rping gets segmentation fault in libibverbs when there are no user
space drivers found. Here is the output
$ rping -s
libibverbs: Warning: no userspace device-specific driver found
for /sys/class/infiniband_verbs/uverbs0
Segmentation fault

rping[28471]: segfault at 3 ip 00007f20c5a51ca6 sp 00007fffddc22b80 error 4
in libibverbs.so.1.0.0[7f20c5a4b000+c000]

This is caused by corrupt pointers, driver_name_list and sysfs_dev_list.
They are used in maintaining the head of the link list but are not
re-initialized to NULL in between the invocations. The previous stale
address values are used in read_config() and find_sysfs_dev() calls.
Although I am not sure if calls to rdma_create_event_channel() and
rdma_create_id() (in rping) should succeed, if there are no user space
drivers. That is why there are multiple invocations to ibverbs_init().

Thanks,
--
Animesh


Signed-off-by: Animesh Trivedi <atr-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>

diff --git a/src/init.c b/src/init.c
index 4f0130e..45c360f 100644
--- a/src/init.c
+++ b/src/init.c
@@ -232,6 +232,7 @@ static void load_drivers(void)
 		free(name->name);
 		free(name);
 	}
+	driver_name_list=NULL;
 }

 static void read_config_file(const char *path)
@@ -536,6 +537,7 @@ out:
 		}
 		free(sysfs_dev);
 	}
+	sysfs_dev_list=NULL;

 	return num_devices;
 }

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

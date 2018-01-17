From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 3/5] mlx5: Add direct verb to translate device timestamp to nanoseconds
Date: Wed, 17 Jan 2018 15:51:31 +0200
Message-ID: <1516197093-20699-4-git-send-email-yishaih@mellanox.com>
References: <1516197093-20699-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1516197093-20699-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Eitan Rabin <rabin-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add a direct verb that translates device timestamps from HCA
core clock units to nanoseconds using the device clock info.

Signed-off-by: Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Eitan Rabin <rabin-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/mlx5/man/CMakeLists.txt    |  1 +
 providers/mlx5/man/mlx5dv_ts_to_ns.3 | 35 +++++++++++++++++++++++++++++++
 providers/mlx5/mlx5dv.h              | 40 ++++++++++++++++++++++++++++++++++++
 3 files changed, 76 insertions(+)
 create mode 100644 providers/mlx5/man/mlx5dv_ts_to_ns.3

diff --git a/providers/mlx5/man/CMakeLists.txt b/providers/mlx5/man/CMakeLists.txt
index 6ce94a9..876b6fc 100644
--- a/providers/mlx5/man/CMakeLists.txt
+++ b/providers/mlx5/man/CMakeLists.txt
@@ -2,5 +2,6 @@ rdma_man_pages(
   mlx5dv_get_clock_info.3
   mlx5dv_init_obj.3
   mlx5dv_query_device.3
+  mlx5dv_ts_to_ns.3
   mlx5dv.7
 )
diff --git a/providers/mlx5/man/mlx5dv_ts_to_ns.3 b/providers/mlx5/man/mlx5dv_ts_to_ns.3
new file mode 100644
index 0000000..197b195
--- /dev/null
+++ b/providers/mlx5/man/mlx5dv_ts_to_ns.3
@@ -0,0 +1,35 @@
+.\" -*- nroff -*-
+.\" Licensed under the OpenIB.org (MIT) - See COPYING.md
+.\"
+.TH MLX5DV_TS_TO_NS 3 2017-11-08 1.0.0
+.SH "NAME"
+mlx5dv_ts_to_ns \- Convert device timestamp from HCA core clock units to
+the corresponding nanosecond counts
+.SH "SYNOPSIS"
+.nf
+.B #include <infiniband/mlx5dv.h>
+.sp
+.BI "uint64_t mlx5dv_ts_to_ns(struct mlx5dv_clock_info *clock_info,
+.BI "			      uint64_t device_timestamp);
+.fi
+.SH "DESCRIPTION"
+.B mlx5dv_ts_to_ns(3)
+Converts a host byte order
+.I device_timestamp
+from HCA core clock units into the corresponding nanosecond wallclock time.
+.PP
+\fBstruct mlx5dv_clock_info\fR can be retrieved using \fBmlx5dv_get_clock_info(3)\fR.
+.PP
+The greater the difference between the device reporting a timestamp and the last
+mlx5dv_clock_info update, the greater the inaccuracy of the clock time conversion.
+
+.fi
+.SH "RETURN VALUE"
+Timestamp in nanoseconds
+.SH "SEE ALSO"
+.BR mlx5dv (7),
+.BR mlx5dv_get_clock_info (3),
+.BR mlx5dv_query_device (3)
+.SH "AUTHORS"
+.TP
+Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
diff --git a/providers/mlx5/mlx5dv.h b/providers/mlx5/mlx5dv.h
index 2447517..2a4a823 100644
--- a/providers/mlx5/mlx5dv.h
+++ b/providers/mlx5/mlx5dv.h
@@ -811,4 +811,44 @@ struct mlx5dv_clock_info {
 int mlx5dv_get_clock_info(struct ibv_context *context,
 			  struct mlx5dv_clock_info *clock_info);
 
+/*
+ * Translate device timestamp to nano-sec
+ *
+ * Input:
+ *      clock_info  - clock info to be filled
+ *      device_timestamp   - timestamp to translate
+ *
+ * Return: nano-sec
+ */
+static inline uint64_t mlx5dv_ts_to_ns(struct mlx5dv_clock_info *clock_info,
+				       uint64_t device_timestamp)
+{
+	uint64_t delta, nsec;
+
+	/*
+	 * device_timestamp & cycles are the free running 'mask' bit counters
+	 * from the hardware hca_core_clock clock.
+	 */
+	delta = (device_timestamp - clock_info->last_cycles) & clock_info->mask;
+	nsec  = clock_info->nsec;
+
+	/*
+	 * Guess if the device_timestamp is more recent than
+	 * clock_info->last_cycles, if not (too far in the future) treat
+	 * it as old time stamp. This will break every max_clock_info_update_nsec.
+	 */
+
+	if (delta > clock_info->mask / 2) {
+		delta = (clock_info->last_cycles - device_timestamp) &
+				clock_info->mask;
+		nsec -= ((delta * clock_info->mult) - clock_info->frac) >>
+				clock_info->shift;
+	} else {
+		nsec += ((delta * clock_info->mult) + clock_info->frac) >>
+				clock_info->shift;
+	}
+
+	return nsec;
+}
+
 #endif /* _MLX5DV_H_ */
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 1/2] net/mlx5e: Add clock info page to mlx5 core devices
Date: Tue, 16 Jan 2018 20:08:40 +0200
Message-ID: <20180116180841.18976-2-leon@kernel.org>
References: <20180116180841.18976-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180116180841.18976-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eitan Rabin <rabin-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Adds a new page to mlx5 core containing clock info data that allows
user level applications to translate between cqe timestamp to
nanoseconds. The information stored into this page is represented
through mlx5_ib_clock_info.

In order to synchronize between kernel and user space a sequence
number is incremented at the beginning and end of each update.
An odd number means the data is being updated while an even means
the access was already done. To guarantee that the data structure
was accessed atomically user will:

repeat:
        seq1 = <read sequence>
        goto <repeate> while odd
        <read data structure>
        seq2 = <read sequence>
        if seq1 != seq2 goto repeat

Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Feras Daoud <ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Eitan Rabin <rabin-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 .../net/ethernet/mellanox/mlx5/core/lib/clock.c    | 55 ++++++++++++++++++++++
 include/linux/mlx5/driver.h                        |  3 ++
 include/uapi/rdma/mlx5-abi.h                       | 16 +++++++
 3 files changed, 74 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
index fa8aed62b231..4b6cb9b38686 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
@@ -31,6 +31,8 @@
  */
 
 #include <linux/clocksource.h>
+#include <linux/highmem.h>
+#include <rdma/mlx5-abi.h>
 #include "en.h"
 
 enum {
@@ -71,6 +73,28 @@ static u64 read_internal_timer(const struct cyclecounter *cc)
 	return mlx5_read_internal_timer(mdev) & cc->mask;
 }
 
+static void mlx5_update_clock_info_page(struct mlx5_core_dev *mdev)
+{
+	struct mlx5_ib_clock_info *clock_info = mdev->clock_info;
+	struct mlx5_clock *clock = &mdev->clock;
+	u32 sign;
+
+	if (!clock_info)
+		return;
+
+	sign = smp_load_acquire(&clock_info->sign);
+	smp_store_mb(clock_info->sign,
+		     sign | MLX5_IB_CLOCK_INFO_KERNEL_UPDATING);
+
+	clock_info->cycles = clock->tc.cycle_last;
+	clock_info->mult   = clock->cycles.mult;
+	clock_info->nsec   = clock->tc.nsec;
+	clock_info->frac   = clock->tc.frac;
+
+	smp_store_release(&clock_info->sign,
+			  sign + MLX5_IB_CLOCK_INFO_KERNEL_UPDATING * 2);
+}
+
 static void mlx5_pps_out(struct work_struct *work)
 {
 	struct mlx5_pps *pps_info = container_of(work, struct mlx5_pps,
@@ -109,6 +133,7 @@ static void mlx5_timestamp_overflow(struct work_struct *work)
 
 	write_lock_irqsave(&clock->lock, flags);
 	timecounter_read(&clock->tc);
+	mlx5_update_clock_info_page(clock->mdev);
 	write_unlock_irqrestore(&clock->lock, flags);
 	schedule_delayed_work(&clock->overflow_work, clock->overflow_period);
 }
@@ -123,6 +148,7 @@ static int mlx5_ptp_settime(struct ptp_clock_info *ptp,
 
 	write_lock_irqsave(&clock->lock, flags);
 	timecounter_init(&clock->tc, &clock->cycles, ns);
+	mlx5_update_clock_info_page(clock->mdev);
 	write_unlock_irqrestore(&clock->lock, flags);
 
 	return 0;
@@ -152,6 +178,7 @@ static int mlx5_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
 
 	write_lock_irqsave(&clock->lock, flags);
 	timecounter_adjtime(&clock->tc, delta);
+	mlx5_update_clock_info_page(clock->mdev);
 	write_unlock_irqrestore(&clock->lock, flags);
 
 	return 0;
@@ -179,6 +206,7 @@ static int mlx5_ptp_adjfreq(struct ptp_clock_info *ptp, s32 delta)
 	timecounter_read(&clock->tc);
 	clock->cycles.mult = neg_adj ? clock->nominal_c_mult - diff :
 				       clock->nominal_c_mult + diff;
+	mlx5_update_clock_info_page(clock->mdev);
 	write_unlock_irqrestore(&clock->lock, flags);
 
 	return 0;
@@ -470,6 +498,7 @@ void mlx5_init_clock(struct mlx5_core_dev *mdev)
 						  clock->cycles.shift);
 	clock->nominal_c_mult = clock->cycles.mult;
 	clock->cycles.mask = CLOCKSOURCE_MASK(41);
+	clock->mdev = mdev;
 
 	timecounter_init(&clock->tc, &clock->cycles,
 			 ktime_to_ns(ktime_get_real()));
@@ -482,6 +511,25 @@ void mlx5_init_clock(struct mlx5_core_dev *mdev)
 	do_div(ns, NSEC_PER_SEC / 2 / HZ);
 	clock->overflow_period = ns;
 
+	mdev->clock_info_page = alloc_page(GFP_KERNEL);
+	if (mdev->clock_info_page) {
+		mdev->clock_info = kmap(mdev->clock_info_page);
+		if (!mdev->clock_info) {
+			__free_page(mdev->clock_info_page);
+			mlx5_core_warn(mdev, "failed to map clock page\n");
+		} else {
+			mdev->clock_info->sign   = 0;
+			mdev->clock_info->nsec   = clock->tc.nsec;
+			mdev->clock_info->cycles = clock->tc.cycle_last;
+			mdev->clock_info->mask   = clock->cycles.mask;
+			mdev->clock_info->mult   = clock->nominal_c_mult;
+			mdev->clock_info->shift  = clock->cycles.shift;
+			mdev->clock_info->frac   = clock->tc.frac;
+			mdev->clock_info->overflow_period =
+						clock->overflow_period;
+		}
+	}
+
 	INIT_WORK(&clock->pps_info.out_work, mlx5_pps_out);
 	INIT_DELAYED_WORK(&clock->overflow_work, mlx5_timestamp_overflow);
 	if (clock->overflow_period)
@@ -521,5 +569,12 @@ void mlx5_cleanup_clock(struct mlx5_core_dev *mdev)
 
 	cancel_work_sync(&clock->pps_info.out_work);
 	cancel_delayed_work_sync(&clock->overflow_work);
+
+	if (mdev->clock_info) {
+		kunmap(mdev->clock_info_page);
+		__free_page(mdev->clock_info_page);
+		mdev->clock_info = NULL;
+	}
+
 	kfree(clock->ptp_info.pin_config);
 }
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 9136e35f2f7e..c403151133e9 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -797,6 +797,7 @@ struct mlx5_clock {
 	u32                        nominal_c_mult;
 	unsigned long              overflow_period;
 	struct delayed_work        overflow_work;
+	struct mlx5_core_dev      *mdev;
 	struct ptp_clock          *ptp;
 	struct ptp_clock_info      ptp_info;
 	struct mlx5_pps            pps_info;
@@ -844,6 +845,8 @@ struct mlx5_core_dev {
 	struct cpu_rmap         *rmap;
 #endif
 	struct mlx5_clock        clock;
+	struct mlx5_ib_clock_info  *clock_info;
+	struct page             *clock_info_page;
 };
 
 struct mlx5_db {
diff --git a/include/uapi/rdma/mlx5-abi.h b/include/uapi/rdma/mlx5-abi.h
index f6d319dfc7bf..0299deed71a2 100644
--- a/include/uapi/rdma/mlx5-abi.h
+++ b/include/uapi/rdma/mlx5-abi.h
@@ -381,4 +381,20 @@ struct mlx5_ib_modify_wq {
 	__u32	comp_mask;
 	__u32	reserved;
 };
+
+struct mlx5_ib_clock_info {
+	__u32 sign;
+	__u32 resv;
+	__u64 nsec;
+	__u64 cycles;
+	__u64 frac;
+	__u32 mult;
+	__u32 shift;
+	__u64 mask;
+	__u64 overflow_period;
+};
+
+enum {
+	MLX5_IB_CLOCK_INFO_KERNEL_UPDATING = 1,
+};
 #endif /* MLX5_ABI_USER_H */
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

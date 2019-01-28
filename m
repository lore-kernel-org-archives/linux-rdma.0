From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.20 236/304] mlx5: update timecounter at least twice per counter overflow
Date: Mon, 28 Jan 2019 10:42:33 -0500
Message-ID: <20190128154341.47195-236-sashal@kernel.org>
References: <20190128154341.47195-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190128154341.47195-1-sashal@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Miroslav Lichvar <mlichvar@redhat.com>, Richard Cochran <richardcochran@gmail.com>, Ariel Levkovich <lariel@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Miroslav Lichvar <mlichvar@redhat.com>

[ Upstream commit 5d8678365c90b9ce1fd2243ff5ea562609f6cec1 ]

The timecounter needs to be updated at least once in half of the
cyclecounter interval to prevent timecounter_cyc2time() interpreting a
new timestamp as an old value and causing a backward jump.

This would be an issue if the timecounter multiplier was so small that
the update interval would not be limited by the 64-bit overflow in
multiplication.

Shorten the calculated interval to make sure the timecounter is updated
in time even when the system clock is slowed down by up to 10%, the
multiplier is increased by up to 10%, and the scheduled overflow check
is late by 15%.

Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Ariel Levkovich <lariel@mellanox.com>
Cc: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Miroslav Lichvar <mlichvar@redhat.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
index 0d90b1b4a3d3..2d6168ee99e8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
@@ -511,14 +511,14 @@ void mlx5_init_clock(struct mlx5_core_dev *mdev)
 			 ktime_to_ns(ktime_get_real()));
 
 	/* Calculate period in seconds to call the overflow watchdog - to make
-	 * sure counter is checked at least once every wrap around.
+	 * sure counter is checked at least twice every wrap around.
 	 * The period is calculated as the minimum between max HW cycles count
 	 * (The clock source mask) and max amount of cycles that can be
 	 * multiplied by clock multiplier where the result doesn't exceed
 	 * 64bits.
 	 */
 	overflow_cycles = div64_u64(~0ULL >> 1, clock->cycles.mult);
-	overflow_cycles = min(overflow_cycles, clock->cycles.mask >> 1);
+	overflow_cycles = min(overflow_cycles, div_u64(clock->cycles.mask, 3));
 
 	ns = cyclecounter_cyc2ns(&clock->cycles, overflow_cycles,
 				 frac, &frac);
-- 
2.19.1

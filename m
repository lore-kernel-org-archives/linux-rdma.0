From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: Working NVMeoF Config From 4.12.5 Fails With 4.15.0
Date: Sun, 4 Feb 2018 16:59:36 +0200
Message-ID: <c0e91150-72be-44f3-6cb4-f95f85444915@grimberg.me>
References: <DE927C68B458BE418D582EC97927A9287FE2088B@ORSMSX113.amr.corp.intel.com>
 <HE1PR0502MB3004A319E5CBF9FC43806136D1F80@HE1PR0502MB3004.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <HE1PR0502MB3004A319E5CBF9FC43806136D1F80-692Kmc8YnlL9PhveBwpv4cDSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Gruher, Joseph R" <joseph.r.gruher-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> I didn't read much email details.
> However there was a mention and git bisect done by Logan Gunthorpe in recent email in [1].
> Where he mentioned possible commit that introduced the regression.
> 05e0cc84e00c net/mlx5: Fix get vector affinity helper function
> 
> [1] https://www.spinics.net/lists/linux-rdma/msg60298.html
> 
> You might want to try to revert that commit and attempt.
> Might be same issue. Might be different, not sure.

Indeed,

Does this fix your issue?
--
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index a0610427e168..b82c4ae92411 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1238,7 +1238,7 @@ mlx5_get_vector_affinity(struct mlx5_core_dev 
*dev, int vector)
         int eqn;
         int err;

-       err = mlx5_vector2eqn(dev, vector, &eqn, &irq);
+       err = mlx5_vector2eqn(dev, MLX5_EQ_VEC_COMP_BASE + vector, &eqn, 
&irq);
         if (err)
                 return NULL;

--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

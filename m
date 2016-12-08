From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/5] mlx5: Avoid that sparse complains about dubious !x &
 y expressions
Date: Thu, 8 Dec 2016 11:26:32 +0200
Message-ID: <CAJ3xEMjPZYgLhDi_6Jxkx_dg_RaehD=3SchMt_noLzQEChPrxQ@mail.gmail.com>
References: <9ff07804-492c-c67a-e729-b31e0f863027@sandisk.com> <572c702f-589f-2d5a-9e13-45223191db85@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <572c702f-589f-2d5a-9e13-45223191db85-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Dec 6, 2016 at 3:19 AM, Bart Van Assche
<bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org> wrote:
> This patch does not change any functionality.

Hi Bart,

Matan came up with a fix (below) which solves all these sparse
complaints in both drivers (mlx5 IB and core)
while basically not touching the code, we will be going with that fix
to 4.11, thanks, I will add reported
by pointing to you.

Doug, in case you picked that, I guess you have to drop it.

Or.

iff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 9f48936..0abdc66 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -67,10 +67,11 @@

 /* insert a value to a struct */
 #define MLX5_SET(typ, p, fld, v) do { \
+       typeof( v ) _v = v; \
        BUILD_BUG_ON(__mlx5_st_sz_bits(typ) % 32);             \
        *((__be32 *)(p) + __mlx5_dw_off(typ, fld)) = \
        cpu_to_be32((be32_to_cpu(*((__be32 *)(p) + __mlx5_dw_off(typ, fld))) & \
-                    (~__mlx5_dw_mask(typ, fld))) | (((v) &
__mlx5_mask(typ, fld)) \
+                    (~__mlx5_dw_mask(typ, fld))) | (((_v) &
__mlx5_mask(typ, fld)) \
                     << __mlx5_dw_bit_off(typ, fld))); \
 } while (0)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH ] mlx4_core: Verify that port types are the same only if
 DPDP supported
Date: Sun, 14 Dec 2014 10:25:26 +0200
Message-ID: <20141214082526.GA3445@yuval-lab>
References: <1417971956-16577-1-git-send-email-yuval.shaia@oracle.com>
 <54881CDF.1090603@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <54881CDF.1090603-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Dec 10, 2014 at 12:13:51PM +0200, Matan Barak wrote:
> 
> 
> On 12/7/2014 7:05 PM, Yuval Shaia wrote:
> >This patch is merely makes code more nice and readable.
> >Instead of checking for DPDP on every loop cycle the check moves out of the loop.
> >
> >Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> >---
> >  drivers/net/ethernet/mellanox/mlx4/main.c |    7 +++----
> >  1 files changed, 3 insertions(+), 4 deletions(-)
> >
> >diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
> >index 861035f..ec4e3fd 100644
> >--- a/drivers/net/ethernet/mellanox/mlx4/main.c
> >+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
> >@@ -567,15 +567,14 @@ int mlx4_check_port_params(struct mlx4_dev *dev,
> >  {
> >         int i;
> >
> >-       for (i =; i < dev->caps.num_ports - 1; i++) {
> >-               if (port_type[i] !=ort_type[i + 1]) {
> >-                       if (!(dev->caps.flags & MLX4_DEV_CAP_FLAG_DPDP)) {
> >+       if (!(dev->caps.flags & MLX4_DEV_CAP_FLAG_DPDP))
> >+               for (i =; i < dev->caps.num_ports - 1; i++) {
> >+                       if (port_type[i] !=ort_type[i + 1]) {
> >                                 mlx4_err(dev, "Only same port types supported "
> >                                          "on this HCA, aborting.\n");
> >                                 return -EINVAL;
> >                         }
> >                 }
> >-       }
> >
> >         for (i =; i < dev->caps.num_ports; i++) {
> >                 if (!(port_type[i] & dev->caps.supported_type[i+1])) {
> >--
> >1.7.1
> >
> >--
> >To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> >the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 
> Hi,
> 
> Thanks for the patch. Could you please just fix the commit message?
Commit message has been changed.
New patch sent, please review.
This thread is close.
> 
> Regards,
> Matan
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

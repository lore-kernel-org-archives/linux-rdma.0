From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v3 1/1] IPoIB: Improve parent interface p_key handling.
Date: Tue, 17 Jun 2014 09:02:18 +0300
Message-ID: <539FD9EA.8030301@mellanox.com>
References: <20140611191947.31937.75434.stgit@phlsvlogin03.ph.intel.com> <20140611192132.31937.30869.stgit@phlsvlogin03.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140611192132.31937.30869.stgit-u2TXY/5TJkdZ7WVY1cDZ9q2pdiUAq4bhAL8bYrjMMd8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/06/2014 22:22, Alex Estrin wrote:
> With reference to commit c2904141696ee19551f1553944446f23cdd5d95e
> (IPoIB: Fix pkey change flow for virtualization environments)
> It was noticed that parent interface keeps sending broadcast group
> join requests if p_key index 0 is invalid. That creates unnecessary
> noise on a fabric:
>
> ib0: multicast join failed for ff12:401b:8000:0000:0000:0000:ffff:ffff,
> status -22
>
> Proposed patch re-init resources, then brings interface
> up only if p_key idx 0 is valid either on bootup or on PKEY_CHANGE event.
> Original code could run multicast task regardless of p_key value,
> which we want to avoid.
>
> Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Alex Estrin <alex.estrin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Hi Alex, I re-wrote the change-log to make it clearer and also follow some
practices we use in the kernel (mentioned them to you over prev posts, 
but maybe
it wasn't clear enough...) also see some comments further down the patch --

IPoIB: Avoid multicast join attempts when having invalid p_key

Currently, the parent interface keeps sending broadcast group join 
requests even if p_key index 0 is invalid, which for itself is 
possible/common in virtualized environmentswhere a VF has been probed to 
VM but the actual p_key configuration has not yet been assigned by the 
management software. This creates unnecessary noise on the fabric and in 
the kernel logs:

ib0: multicast join failed for ff12:401b:8000:0000:0000:0000:ffff:ffff, 
status -22

The original code run the multicast task regardless of the actual
p_key value, which can be avoided. The fix is to re-init resources  and 
bring interface up only if p_key index 0 is valid either when starting 
up or on PKEY_CHANGE event.

Fixes: c290414169 ('IPoIB: Fix pkey change flow for virtualization environments')

> ---
>   drivers/infiniband/ulp/ipoib/ipoib_ib.c |   35 +++++++++++++++++++------------
>   1 files changed, 21 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> index 6a7003d..a2af996 100644
> --- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> +++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
> @@ -52,6 +52,7 @@ MODULE_PARM_DESC(data_debug_level,
>   #endif
>   
>   static DEFINE_MUTEX(pkey_mutex);
> +static void ipoib_pkey_dev_check_presence(struct net_device *dev);
>   
>   struct ipoib_ah *ipoib_create_ah(struct net_device *dev,
>   				 struct ib_pd *pd, struct ib_ah_attr *attr)
> @@ -669,12 +670,13 @@ int ipoib_ib_dev_open(struct net_device *dev)
>   	struct ipoib_dev_priv *priv = netdev_priv(dev);
>   	int ret;
>   
> -	if (ib_find_pkey(priv->ca, priv->port, priv->pkey, &priv->pkey_index)) {
> -		ipoib_warn(priv, "P_Key 0x%04x not found\n", priv->pkey);
> -		clear_bit(IPOIB_PKEY_ASSIGNED, &priv->flags);
> +	ipoib_pkey_dev_check_presence(dev);
> +
> +	if (!test_bit(IPOIB_PKEY_ASSIGNED, &priv->flags)) {
> +		ipoib_warn(priv, "P_Key 0x%04x is %s\n", priv->pkey,
> +			!(priv->pkey & 0x7fff) ? "Invalid" : "not found");
CHECK: Alignment should match open parenthesis
#44: FILE: drivers/infiniband/ulp/ipoib/ipoib_ib.c:677:
+               ipoib_warn(priv, "P_Key 0x%04x is %s\n", priv->pkey,
+                       !(priv->pkey & 0x7fff) ? "Invalid" : "not found");

please run checkpatch --strict on your patch to fix this one and it's 
such (there are more) basically the guideline (based on a quote ofDave 
Miller ...) is:

when you have a multi-line function call or if () conditional,the first 
non-whitespace character on the second and subsequent lines should line 
up with the first column after the openning parenthesis on the first line.

@@ -1038,8 +1043,10 @@ static void __ipoib_ib_dev_flush(struct ipoib_dev_priv *priv,
  		ipoib_ib_dev_down(dev, 0);
  
  	if (level == IPOIB_FLUSH_HEAVY) {
-		ipoib_ib_dev_stop(dev, 0);
-		ipoib_ib_dev_open(dev);
+		if (test_bit(IPOIB_FLAG_INITIALIZED, &priv->flags))
+			ipoib_ib_dev_stop(dev, 0);
+		if (ipoib_ib_dev_open(dev) != 0)
+			return;
  	}


is testing the return code of ipoib_ib_dev_open() really part of the 
functional/fix change introduced by this patch or a different fix? if 
the latter, put to different/future patch
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: BUG: unable to handle kernel paging request at 0000000000070a78
 IPoIB
Date: Tue, 21 May 2013 17:19:54 +0200
Message-ID: <519B909A.8010004@profitbricks.com>
References: <51963BC6.1050901@profitbricks.com> <519B6DD6.4090502@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <519B6DD6.4090502-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 05/21/2013 02:51 PM, Sebastian Riemer wrote:
> On 17.05.2013 16:16, Jack Wang wrote:
>> unable to handle kernel paging request
> 
> Hi Jack,
> 
> this should be related to the list corruption in IPoIB as list_del()
> sets the LIST_POISON1 and LIST_POISON2 pointers.
> Referencing these results in page faults according to the documentation
> in the code.
> 
> Cheers,
> Sebastian
> 
This bug is easy triggered with below inject_bug with iperf -P 50 &&
switch ib mode in sync on both side.
-- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
@@ -1315,7 +1315,8 @@ static void ipoib_cm_tx_start(struct work_struct
*work)
 		netif_tx_lock_bh(dev);
 		spin_lock_irqsave(&priv->lock, flags);

-		if (ret) {
+		if (ret || priv->inject_bug) {
+			priv->inject_bug = 0;
 			neigh = p->neigh;
 			if (neigh) {
 				neigh->cm = NULL;

It turned into another panic after patch list_del to list_del_init, I'm
managing to get the back trace.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

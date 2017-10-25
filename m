From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] bnxt_re: Implement the shutdown hook of the L2-RoCE
 driver interface
Date: Wed, 25 Oct 2017 15:28:47 -0400
Message-ID: <1508959727.3325.61.camel@redhat.com>
References: <20171025034230.30656-1-somnath.kotur@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171025034230.30656-1-somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, 2017-10-25 at 09:12 +0530, Somnath Kotur wrote:
> When host is shutting down, it invokes the shutdown hook of the
> L2 driver where it would attempt to free the MSI-X vectors, but would
> fail
> because some vectors are held by the RoCE driver.
> Implement the new hook in the L2 -> RoCE interface which will be
> invoked so that
> the RoCE driver can unregister the device and free up the MSI-X
> vectors it had
> claimed so that L2 can proceed with it's shutdown without failure.
> 
> Signed-off-by: Somnath Kotur <somnath.kotur-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>

Thanks, applied.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next] IB/mthca: Check validity of output parameter
 pointer
Date: Mon, 24 Apr 2017 12:28:24 -0400
Message-ID: <1493051304.3041.47.camel@redhat.com>
References: <20170415154725.17559-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170415154725.17559-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sat, 2017-04-15 at 18:47 +0300, Leon Romanovsky wrote:
> The mthca driver didn't check supplied pointer to functions
> mthca_cmd_poll() and mthca_cmd_wait(). This caused to the following
> smatch errors:
> 
> drivers/infiniband/hw/mthca/mthca_cmd.c:371 mthca_cmd_poll() error:
> we previously assumed 'out_param' could be null (see line 353)
> drivers/infiniband/hw/mthca/mthca_cmd.c:454 mthca_cmd_wait() error:
> we previously assumed 'out_param' could be null (see line 432)
> 
> In reality all callers of these functions are setting out_is_imm
> flag are providing pointer too. However it is better to check
> again to remove smatch errors to achieve warning free subsystem.
> 
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks, applied.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

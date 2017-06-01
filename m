From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] ib/core: not to set page dirty bit if it's already set.
Date: Thu, 01 Jun 2017 18:33:59 -0400
Message-ID: <1496356439.7171.73.camel@redhat.com>
References: <20170518233353.14370-1-qing.huang@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170518233353.14370-1-qing.huang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Qing Huang <qing.huang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, 2017-05-18 at 16:33 -0700, Qing Huang wrote:
> This change will optimize kernel memory deregistration operations.
> __ib_umem_release() used to call set_page_dirty_lock() against every
> writable page in its memory region. Its purpose is to keep data
> synced between CPU and DMA device when swapping happens after mem
> deregistration ops. Now we choose not to set page dirty bit if it's
> already set by kernel prior to calling __ib_umem_release(). This
> reduces memory deregistration time by half or even more when we ran
> application simulation test program.
> 
> Signed-off-by: Qing Huang <qing.huang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

Thanks, applied.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
   
Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

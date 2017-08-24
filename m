From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-4.14] IB: Avoid ib_modify_port() failure for RoCE
 devices
Date: Thu, 24 Aug 2017 17:36:57 -0400
Message-ID: <1503610617.78641.65.camel@redhat.com>
References: <1503475687-5227-1-git-send-email-selvin.xavier@broadcom.com>
         <20170823085712.GM1724@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170823085712.GM1724-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, 2017-08-23 at 11:57 +0300, Leon Romanovsky wrote:
> On Wed, Aug 23, 2017 at 01:08:07AM -0700, Selvin Xavier wrote:
> > IB CM calls ib_modify_port() irrespective of link layer. If the
> > failure is returned, the mad agent gets unregistered for those
> > devices. Recently, modify_port() hook was removed from some of the
> > low level drivers as it was always returning success. This breaks
> > rdma connection establishment over those devices.
> > For ethernet devices, Qkey violation and port capabilities are not
> > applicable. So returning success for RoCE when modify_port hook is
> > is not implemented.
> > 
> > Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > Signed-off-by: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> > ---
> >  drivers/infiniband/core/device.c | 11 +++++++----
> >  1 file changed, 7 insertions(+), 4 deletions(-)
> > 
> 
> Thanks,
> Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Thanks, applied.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

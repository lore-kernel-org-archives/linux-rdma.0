From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next V2 0/6] Enable flow steering on IPoIB UD QP
Date: Fri, 28 Jul 2017 14:24:49 -0400
Message-ID: <1501266289.2593.40.camel@redhat.com>
References: <20170608131511.21040-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170608131511.21040-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, 2017-06-08 at 16:15 +0300, Leon Romanovsky wrote:
> Hi,
> 
> This is v2 of patch set from Yishai,
> 
> Changelog:
>  v1->v2:
>    * Use 'source_qpn' as part of QP creation without mandating
> association
>      of an overlay with underlay QP.
>  v0->v1:
>    * Improved commit message
> 
> ----
> From Yishai:
> 
> Enable accelerating IPoIB traffic from user applications
> 
> This series comes to allow user space applications to accelerate send
> and receive traffic which is typically handled by IPoIB ULP. On the
> receive flow, the user space application will use flow steering rules
> to
> direct the ingress IPoIB UD QP traffic to its own user space UD QP.
> On
> the send flow, the user space application will send from its own UD
> QP
> with UD AH, while the packet on the wire will have the source QPN of
> the
> IPoIB UD QP, which is the network interface advertised L2 hardware
> address.
> 
> This will be achieved by extending QP creation of IB UD QP to get
> the source QP number of the matching IPoIB UD QP.
> 
> In order to create such a UD QP needs to provide the source QPN of
> the
> IPoIB network interface.
> 
> The QPN should be achieved by using some networking tool as of
> ifconfig,
> ip link show on the associated interface. For example, when IPoIB is
> used, the QPN is the value of 3 bytes from the hardware address
> starting
> after the first byte as defined by rfc4391 [1]
> 
> Current mlx5 driver implements this API for the IPoIB ULP.
> 
> Thanks
> 

Thanks, series applied.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

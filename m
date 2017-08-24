From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [pull request][rdma-next 0/8] mlx5 feature for 4.14
Date: Thu, 24 Aug 2017 17:50:09 -0400
Message-ID: <1503611409.78641.68.camel@redhat.com>
References: <20170817125235.5107-1-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170817125235.5107-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, 2017-08-17 at 15:52 +0300, Leon Romanovsky wrote:
> ----------------------------------------------------------------
> The mlx5 features for 4.14
> 
> 1) Software paring from Nos
>  * Software parsing (SWP) is a feature that can be used to instruct
> the
>    device to stop using its internal parser and to parse packets on
> the
>    transmit path according to offsets set for each packets.
> 
>    Through this feature, the device allows the handling of checksum
> and
>    LSO by the hardware according to the location of IP and TCP/UDP
>    headers.
> 
> 2) Decouple UMR usage from the MR cache from Ilya and fix from Kamal
>  * Previously, UMR (HW population of translation entries) was used
>    only for MRs allocated from the MR cache.
>    This resulted in slow allocations of large MRs,
>    and also limited ODP (which relies on UMR) only to cached MRs.
> 
>    This series uses UMR for populating translations of any MR,
>    regardless of the cache. Consequently, allocation speed of
> new/large
>    MRs is improved considerably.
> 
> 3) Add support for multi underlay QP from Yishai
>  * Set underlay QPN as part of flow rule when it's applicable.
> 
> 4) Enhanced multi packet WQE from Bodong
>  * This feature enables sending multiple various sized packets
>    using a single WQE, where each data segment in the posted WQE
>    points to a separate packet.
> 
> ----------------------------------------------------------------

Hi Leon,

I didn't see any problems in here.  It plays with mlx5 internal ABIs,
but it was all extensions, and no breakages, so that's fine.  I've
applied this on the mellanox branch on github.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

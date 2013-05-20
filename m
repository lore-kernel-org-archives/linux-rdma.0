From: Shawn Bohrer <shawn.bohrer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 0/9] Add receive Flow Steering support
Date: Mon, 20 May 2013 17:54:23 -0500
Message-ID: <20130520225423.GB16639@sbohrermbp13-local.rgmadvisors.com>
References: <1366811932-28199-1-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1366811932-28199-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Apr 24, 2013 at 04:58:43PM +0300, Or Gerlitz wrote:
> Hi Roland, all
> 
> The first five patches in the series are mlx4 DMFS (Device Managed Flow 
> Steering) pre-patches needed for flow steering access from the mlx4 IB driver.
> 
>   net/mlx4_core: Move DMFS HW structs to common header file
>   net/mlx4: Match DMFS promiscuous field names to firmware spec
>   net/mlx4_core: Change few DMFS fields names to match firmare spec
>   net/mlx4_core: Directly expose fields of DMFS HW rule control segment
>   net/mlx4_core: Expose few helpers to fill DMFS HW strucutures
> 
> We're submitting them through the rdma tree as the next patch depend on them,
> please apply them for 3.10 this way (accepting also the next patches) or 
> another (even if they are not accepted now), so we will not have extra 
> dependencies with further changes on that area.
> 
> The next four patches add Flow Steering support to the kernel IB core, 
> to uverbs and to the mlx4 IB (verbs) driver along with one patch
> to uverbs which adds some code to support extensions.
> 
>   IB/core: Add receive Flow Steering support
>   IB/core: Infra-structure to support verbs extensions through uverbs
>   IB/core: Export ib_create/destroy_flow through uverbs
>   IB/mlx4: Add receive Flow Steering support
> 
> The main patch which introduces the Flow-Steering API is "IB/core: Add receive Flow 
> Steering support", see its change log. Looking on the "Network Adapter Flow Steering" 
> slides from Tzahi Oved which he presented on the annual OFA 2012 meeting could be helpful
> https://www.openfabrics.org/resources/document-downloads/presentations/doc_download/518-network-adapter-flow-steering.html

Hi Or,

Are there any patches for libibverbs to add
ibv_create_flow/ibv_destroy_flow?  And are there any needed patches
for libmlx4?  I'm building up a stack so we can begin testing this
series.

Thanks,
Shawn
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

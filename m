From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 35/47] IB/opa: Fix endianness annotation of
 opa_is_extended_lid()
Date: Wed, 11 Oct 2017 09:59:39 -0400
Message-ID: <b8f6b31b-375f-eb61-4f1c-3340877da891@intel.com>
References: <20171006213333.6721-1-bart.vanassche@wdc.com>
 <20171006213333.6721-36-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171006213333.6721-36-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/6/2017 5:33 PM, Bart Van Assche wrote:
> This patch does not change any functionality.
> 
> Fixes: commit e92aa00a5189 ("IB/CM: Add OPA Path record support to CM")
> Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
> Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: Niranjana Vishwanathapura <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>   include/rdma/opa_addr.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/rdma/opa_addr.h b/include/rdma/opa_addr.h
> index e6e90f18e6d5..72995a39cb97 100644
> --- a/include/rdma/opa_addr.h
> +++ b/include/rdma/opa_addr.h
> @@ -97,7 +97,7 @@ static inline u32 opa_get_lid_from_gid(const union ib_gid *gid)
>    * @dlid: The DLID
>    * @slid: The SLID
>    */
> -static inline bool opa_is_extended_lid(u32 dlid, u32 slid)
> +static inline bool opa_is_extended_lid(__be32 dlid, __be32 slid)
>   {
>   	if ((be32_to_cpu(dlid) >=
>   	     be16_to_cpu(IB_MULTICAST_LID_BASE)) ||
> 

Doug already has taken a patch for this, it is in his for-next branch:

a917374e8a20 ("IB/core: Use __be32 for LIDs in opa_is_extended_lid").

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

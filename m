From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 14/20] IB/core: Add IB_DEVICE_OPA_MAD_SUPPORT device cap
 flag
Date: Wed, 14 Jan 2015 18:47:16 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E0CC0060C@CRSMSX101.amr.corp.intel.com>
References: <1421082672-22588-1-git-send-email-ira.weiny@intel.com>
 <1421082672-22588-15-git-send-email-ira.weiny@intel.com>
 <54B60A28.2030409@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54B60A28.2030409-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> 
> On 1/12/2015 7:11 PM, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> 
> --- a/include/rdma/ib_verbs.h
> +++ b/include/rdma/ib_verbs.h
>   enum ib_signature_prot_cap {
>   	IB_PROT_T10DIF_TYPE_1 = 1,
>   	IB_PROT_T10DIF_TYPE_2 = 1 << 1,
> @@ -210,6 +214,7 @@ struct ib_device_attr {
>   	int			sig_prot_cap;
>   	int			sig_guard_cap;
>   	struct ib_odp_caps	odp_caps;
> +	u64			device_cap_flags2;
> 
> 
> Just make the existing kernel size device_cap_flags field a u64, note it's not
> blankly copied to user space in uverbs as part of a chunk, so just go there and
> copy the lower 32 bits.
> 

It is an easy change but before changing this I'd like to hear what Roland or others think.

I prefer to define an additional field.  Eventually we are likely to have flags which need to be communicated to user space.  I think it will be cleaner at that time to report the entire new field rather than go through some sort of "upper 32 bit device capability" logic.

Thoughts?
Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

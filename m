From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next V2 02/22] IB/core: change pkey table lookups
 to support full and partial membership for the same pkey
Date: Thu, 13 Sep 2012 18:53:55 +0300
Message-ID: <50520193.2010304@mellanox.com>
References: <1343983258-6268-1-git-send-email-jackm@dev.mellanox.co.il> <1343983258-6268-3-git-send-email-jackm@dev.mellanox.co.il> <504F6C4F.6050207@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <504F6C4F.6050207-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 11/09/2012 19:52, Doug Ledford wrote:
> On 8/3/2012 4:40 AM, Jack Morgenstein wrote:
>> >Enhance the cached and non-cached pkey table lookups to enable limited and full
>> >members of the same pkey to co-exist in the pkey table.
>> >
>> >This is necessary for SRIOV to allow for a scheme where some guests would have the full
>> >membership pkey in their virtual pkey table, where other guests on the same hypervisor
>> >would have the limited one. In that sense, its an extension of the IBTA model for
>> >non virtualized nodes.
> OK, maybe I'm not getting something, but I'm curious why we always pick
> the full pkey in preference to the partial pkey.  Shouldn't we pick the
> pkey that's appropriate for the vHCA sending the message?
>
> Also, given the rule of least surprise, don't you think it would be best
> to rename this function ib_find_cached_full_or_parital_pkey and in your
> next patch instead of naming it ib_find_exact_pkey just call that one
> ib_find_cached_pkey?
>

reply from Liran, our architect:

The physical PKey table can contain both full and partial memberships of 
the same Pkey.
This is needed to serve 2 VFs that are granted access to the same PKey, 
albeit with different membership types.

Indeed, there is no reason that the virtual PKey table of any *single* 
VF will contain both membership types.However, the PF PKey table 
certainly can because it mirrors the physical Pkey table.This patch is 
required for ULPs running on top of the PF.

--Liran
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

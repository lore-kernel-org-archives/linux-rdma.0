From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next 00/29] Add SRIOV support for IB interfaces
Date: Tue, 12 Jun 2012 10:22:46 +0300
Message-ID: <4FD6EE46.20900@mellanox.com>
References: <1339411570-4689-1-git-send-email-jackm@dev.mellanox.co.il> <CAL1RGDVsGUBHUBOaajnzO4NcFjA1xBZczLA=vxV3=oRKme+LrQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDVsGUBHUBOaajnzO4NcFjA1xBZczLA=vxV3=oRKme+LrQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dotanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, tziporet-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 6/12/2012 10:00 AM, Roland Dreier wrote:
> Jack Morgenstein<jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>  wrote:
>> several of the patches have notations indicating things that will be fixed in V1
>
> Not sure what you want me to do with this -- it seems you yourself are saying this series is not ready to merge yet?

Roland,

We observed few last minute issues and preferred not to further defer 
submission,
with the reasons being:

1. be sure that the submitted code passed through regression, not even a 
bit change since

2. the issues we spotted are all fairly simple to fix and V1 will be out 
quickly

3. the design --> resulted code is a bit complex, wanted it to see the 
day light such that review can start (thank you for the quick feedback 
on patch 03)

All in all, V1 is coming soon, and if you prefer starting from there, 
let it be, but
still, will love to get any comments / questions / corrections.

Or.

The known issues to be fixed in V1, with NNN being the patch number:

002 illegal use here of the MSB of the port_num field in the ib core ah 
structure

013 add patch which will indicate some of the most-significant bits in
     ib_qp_create_flags as reserved for low-level driver use.

015 modify the slave_num macro defined here to be usable in mlx4_core as 
well

022 require some slight cleanup

024 require some slight cleanup

029 change the patch to reflect that RoCE is still not supported on slaves

also librdmacm will currently not support multiple VF/PF on the same host,
we will change the patch set to solve that, no change in the library


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

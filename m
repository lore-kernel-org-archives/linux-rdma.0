From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 14/14] RDMA/bnxt_re: Update the driver version
Date: Thu, 11 May 2017 09:55:49 -0400
Message-ID: <06939fa3-5f9e-1c1c-e4bb-3d7f4f2fd325@intel.com>
References: <1494413139-11883-1-git-send-email-selvin.xavier@broadcom.com>
 <1494413139-11883-15-git-send-email-selvin.xavier@broadcom.com>
 <84d9a0ce-0e5c-fc50-237f-b7ad9d541324@intel.com>
 <20170510155430.GC1839@mtr-leonro.local>
 <CA+sbYW2ObMdDOdhPL9GMe5YNk7P2MsG5q=f+Ke5e4MU6A=WV6w@mail.gmail.com>
 <20170511082700.GA3616@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170511082700.GA3616-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 5/11/2017 4:27 AM, Leon Romanovsky wrote:
> On Thu, May 11, 2017 at 10:52:31AM +0530, Selvin Xavier wrote:
>> Thanks Leon and Dennis for your comments.
>>
>> The main intention of this patch is to easily map the upstream driver
>> to the level of supported features in the
>> internal code base. I understand the point you and others are
>> mentioning while porting to older kernels or during
>> the bug fixes/feature additions from other contributors. But, can we
>> consider it as just a number to enable vendors
>> to track their base branch?
>
> It is up to you, just wanted to warn you that in long run it won't give
> you any information. We are in similar situation and decided to change
> versions in really rare situations, like addition of new driver. In other
> cases, it is useless.

Personally it doesn't bother me one bit. I mean, hey we did it in our 
driver. But it was NAKed by the maintainer of the staging tree when our 
driver was there, so just wanted to point out that some in the community 
are pretty strongly opposed to it.

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

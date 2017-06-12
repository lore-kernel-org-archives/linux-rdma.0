From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next 0/3] Support out of order data placement
Date: Mon, 12 Jun 2017 15:06:38 -0400
Message-ID: <3fa7a4b5-5c19-8c6a-d78b-93219a9be888@intel.com>
References: <20170612064918.12510-1-leon@kernel.org>
 <074a01d2e39f$edc28860$c9479920$@opengridcomputing.com>
 <VI1PR0502MB3008CE85A4F274886B74DF2BD1CD0@VI1PR0502MB3008.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <VI1PR0502MB3008CE85A4F274886B74DF2BD1CD0-o1MPJYiShExKsLr+rGaxW8DSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Idan Burstein <idanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 6/12/2017 1:37 PM, Parav Pandit wrote:
>> Given the application follows the above semantics, why does it care if data
>> is placed out of order?  IE Why does this impact the application API at all?
>>
> If application wants to benefit from out-of-order placement, it should enable this flag.
> Following semantics is fine, but letting HCA enable something under the hood for all QPs, is not good.
> HCA or stack doesn't know which all applications are running, handling/following such semantics.
> So its best left to the end user applications to benefit or not from it.

I don't understand why the application has to care about this at all. If 
the HW wants to place things out of order. Ok go for it. Applications 
should be depending on the correct mechanism to know when it's OK to 
look at the data. Why do they care what order it arrived in?

The only reason to care is if the applications wants to do something 
that is not compliant and look at parts of the data early. Perhaps you 
can explain *how* an application may benefit from out-of-order placement 
and likewise, why it wouldn't want to benefit.

It seems to me, the real benefit is reducing the number of 
retransmissions which the application shouldn't care about.

-Denny





--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

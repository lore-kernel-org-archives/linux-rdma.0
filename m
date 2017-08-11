From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [rdma-next 07/22] RDMA/core: Remove unimplemented node_types and
 node transport
Date: Fri, 11 Aug 2017 14:13:01 -0400
Message-ID: <72f3047f-8b29-435d-57bf-be0734606368@intel.com>
References: <20170811105003.7661-1-leon@kernel.org>
 <20170811105003.7661-8-leon@kernel.org>
 <36aea320-a018-040d-c44a-3a23d54771cd@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <36aea320-a018-040d-c44a-3a23d54771cd-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 8/11/2017 12:46 PM, Hal Rosenstock wrote:
> On 8/11/2017 6:49 AM, Leon Romanovsky wrote:
>> From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>
>> There is no need to carry code, which is not implemented in any
>> underlying hardware. This patch removes unimplemented node_types and
>> their respective node transport layers.
> 
> We have supported IB switches and routers since day 1 of OpenIB and
> linux-rdma. Although not the original intent, there are still no in-tree
> consumers, but there are several out of tree ones. Every time this issue
> has come up in the past, it has been decided to continue to support
> them. Effectively, IB routers and switches are grandfathered.

I swear I remember having this exact conversation but can't find it in 
my mail. Figures. Well regardless...

> Rather than doing this, perhaps a better approach would be to supply
> some skeleton drivers for IB switch and router.

If someone were to volunteer to do that I could see leaving the 
functionality, no not functionality, the non-functioning code, leaving 
that in on a _temporary_ basis. In reality though it's been years that 
this has been sitting there.

I can see the grandfather clause applying to stuff in the kernel tree, 
or even publicly available implementations at a stretch (even then still 
probably not). If there any any out of tree switch/router drivers, what 
is the likelihood that they support the latest and greatest kernel out 
of the box anyway? Is this really going to be a huge problem for them? I 
doubt it.

On the flip side, is this code that's been there for forever and a day 
really that big of a problem? No not really. It would be good to clean 
it up if no one has that big of a problem and I'm not going to argue 
very strongly on one side or the other.

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

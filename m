From: Cao jin <caoj.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH] infiniband/hfil: drop pci_link_reset()
Date: Tue, 20 Dec 2016 11:17:05 +0800
Message-ID: <5858A2B1.1020701@cn.fujitsu.com>
References: <1482129996-19255-1-git-send-email-caoj.fnst@cn.fujitsu.com>
 <1482129996-19255-2-git-send-email-caoj.fnst@cn.fujitsu.com>
 <e6f22b2d-faf7-390a-ca4d-564c6d0841b8@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <e6f22b2d-faf7-390a-ca4d-564c6d0841b8-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 12/19/2016 11:54 PM, Dennis Dalessandro wrote:
> On 12/19/2016 01:46 AM, Cao jin wrote:
>> In AER recovery, pci_error_handlers.link_reset() is never called,
>> drop it now.
>>
>> Signed-off-by: Cao jin <caoj.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
> 
> Is this part of a larger patch series?

Not now.

> If the function is never called
> it should be removed from struct pci_error_handlers should it not? Then
> in the same series be removed from all the drivers.

Maybe we can remove the unnecessary implementation in each device first,
if finally pci guys confirmed that .link_reset could be removed, then we
could removed it in the future, not quite necessary to place them into
the same series. But it is also good hear their voice first.

-- 
Sincerely,
Cao jin

> 
> Probably should check with the folks on linux-pci about this though.
> 
> -Denny
> 
> 
> 
> 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 4/7] IB/srp: Fix a potential queue overflow in an error
 path
Date: Tue, 3 Nov 2015 12:50:59 -0800
Message-ID: <56391E33.5050300@sandisk.com>
References: <562FF404.7000504@sandisk.com> <562FF484.6030400@sandisk.com>
 <5638F08D.9070206@dev.mellanox.co.il> <56390557.204@sandisk.com>
 <56391181.8040207@dev.mellanox.co.il> <56391290.2080708@sandisk.com>
 <5639157C.2060107@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5639157C.2060107-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/03/2015 12:13 PM, Sagi Grimberg wrote:
>> Sorry but I strongly prefer not to introduce new contention points in
>> the SRP initiator driver.
>
> Yea... Me neither.
>
> What if you just have a simple check on the SG list and reserve the
> required descriptors up front? Would that work?

Such a check wouldn't be that simple because the only way to perform 
such a check is either by doubling the number of ib_map_mr_sg() calls or 
by performing additional memory allocations.

Bart.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

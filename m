From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 4/7] IB/srp: Fix a potential queue overflow in an error
 path
Date: Wed, 4 Nov 2015 14:19:43 -0800
Message-ID: <563A847F.30308@sandisk.com>
References: <562FF404.7000504@sandisk.com> <562FF484.6030400@sandisk.com>
 <5638F08D.9070206@dev.mellanox.co.il> <56390557.204@sandisk.com>
 <56391181.8040207@dev.mellanox.co.il> <56391290.2080708@sandisk.com>
 <5639157C.2060107@dev.mellanox.co.il> <56391E33.5050300@sandisk.com>
 <20151104040322.GA22142@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151104040322.GA22142-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/03/2015 08:03 PM, Christoph Hellwig wrote:
> On Tue, Nov 03, 2015 at 12:50:59PM -0800, Bart Van Assche wrote:
>> Such a check wouldn't be that simple because the only way to perform such a
>> check is either by doubling the number of ib_map_mr_sg() calls or by
>> performing additional memory allocations.
>
> The other option woud be to disallow gappy SG lists unless supported by
> the hardware with a single MR similar to iSER.  While this would leave
> the SRP protocol support for multiple SG entries per command unused it
> would significantly simplify the driver.

Hello Christoph,

I will have a look into this after the kernel 4.4 merge window has been 
closed.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

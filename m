From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 1/8] IB/srp: Re-enable FMR for non-page aligned buffers
Date: Sun, 16 Aug 2015 08:49:07 -0700
Message-ID: <55D0B0F3.60105@sandisk.com>
References: <55BBF4B8.2050700@sandisk.com>
 <20150803152420.GA24193@infradead.org> <55BFB40F.8000500@sandisk.com>
 <20150804180933.GB5038@obsidianresearch.com>
 <1438756876.5698.2.camel@haswell.thedillows.org>
 <20150805195122.GA31595@obsidianresearch.com> <55C2840C.5050301@sandisk.com>
 <55C2912A.50709@sandisk.com> <20150806001006.GD2483@obsidianresearch.com>
 <55C2A7FE.7020904@sandisk.com> <20150806043642.GA14153@obsidianresearch.com>
 <55C93C61.9010508@sandisk.com> <55C93C85.6090003@sandisk.com>
 <55D06BB3.7070905@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55D06BB3.7070905-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 08/16/15 03:53, Sagi Grimberg wrote:
> On 8/11/2015 3:06 AM, Bart Van Assche wrote:
>> During a discussion in 2011 nobody recalled why FMR was not used for
>> non-page aligned buffers (see also
>> http://thread.gmane.org/gmane.linux.drivers.rdma/7149). Re-enable FMR
>> for such buffers. For the reason why the srp_map_fmr() function needs
>> to be modified, see also patch "IB/srp: rework mapping engine to use
>> multiple FMR entries" (commit ID 8f26c9ff9cd0; January 2011).
>>
>> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
>
> Hi Bart,
>
> Just wanted to confirm that this was tested with FMR and non-aligned IO.
> (the change log doesn't say it).

Hello Sagi,

This patch series has been tested with FMR and I/O buffers that were not 
aligned to a page boundary by setting the ib_srp kernel module parameter 
prefer_fr to 0.

Bart.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

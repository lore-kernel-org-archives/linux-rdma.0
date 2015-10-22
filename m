From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v6 0/4] Add network namespace support in the RDMA-CM
Date: Thu, 22 Oct 2015 09:38:04 +0300
Message-ID: <5628844C.6070905@mellanox.com>
References: <1440685772-14076-1-git-send-email-haggaie@mellanox.com>
 <562859E1.4020807@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <562859E1.4020807-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 22/10/2015 06:37, Doug Ledford wrote:
> On 08/27/2015 10:29 AM, Haggai Eran wrote:
>> Hi,
>>
>> Now that the code for demuxing requests is inside rdma_cm, here are the patches
>> to add InfiniBand network namespace again.
>>
>> Changes from v5:
>> - removed patches that got in as part of the cleanup series.
> 
> Hi Haggai,
> 
> This series no longer applies cleanly after all of the cm changes that
> made it into 4.3.  Can you please rebase and resend?

Sure, I'll do that.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

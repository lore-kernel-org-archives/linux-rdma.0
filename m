From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH for-next 02/10] IB/core: Add flags parameter for ib_create_cq
Date: Wed, 20 May 2015 11:54:03 +0300
Message-ID: <555C4BAB.6090602@dev.mellanox.co.il>
References: <1431869786-6308-1-git-send-email-ogerlitz@mellanox.com> <1431869786-6308-3-git-send-email-ogerlitz@mellanox.com> <20150519184711.GK18675@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150519184711.GK18675-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 5/19/2015 9:47 PM, Jason Gunthorpe wrote:
> On Sun, May 17, 2015 at 04:36:18PM +0300, Or Gerlitz wrote:
>> From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>>
>> We add a flags parameter for ib_create_cq in order
>> to specify creation flags for the CQ.
>
> Why?
>
> At this point you should keep flowing ib_cq_init_attr up to callers of
> ib_create_cq , so we don't have to do this again.
>
> It makes sense to keep that as a distinct patch..

I completely agree with Jason. Let's move away from
non-easily-extendale APIs.

Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

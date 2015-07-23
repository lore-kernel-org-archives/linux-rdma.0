From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH WIP 37/43] xprtrdma: Port to new memory registration API
Date: Thu, 23 Jul 2015 13:20:50 +0300
Message-ID: <55B0C002.60307@dev.mellanox.co.il>
References: <1437548143-24893-1-git-send-email-sagig@mellanox.com>
 <1437548143-24893-38-git-send-email-sagig@mellanox.com>
 <55AFED4C.9040409@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55AFED4C.9040409-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/22/2015 10:21 PM, Steve Wise wrote:
>
> On 7/22/2015 1:55 AM, Sagi Grimberg wrote:
>> Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> ---
>>   net/sunrpc/xprtrdma/frwr_ops.c  | 80
>> ++++++++++++++++++++++-------------------
>>   net/sunrpc/xprtrdma/xprt_rdma.h |  4 ++-
>>   2 files changed, 47 insertions(+), 37 deletions(-)
>
> Did you intend to change svcrdma as well?

All the ULPs need to convert. I didn't have a chance to convert
svcrdma yet. Want to take it?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH for-next 08/10] iser-target: Support the remote
 invalidation exception
Date: Tue, 17 Nov 2015 11:50:15 +0200
Message-ID: <564AF857.5090701@dev.mellanox.co.il>
References: <1447691861-3796-1-git-send-email-sagig@mellanox.com>
 <1447691861-3796-9-git-send-email-sagig@mellanox.com>
 <564AE0C6.2030203@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <564AE0C6.2030203-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Jenny Derzhavetz <jennyf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 17/11/2015 10:09, Or Gerlitz wrote:
> On 11/16/2015 6:37 PM, Sagi Grimberg wrote:
>> We'll use remote invalidate, according to negotiation result
>> during connection establishment. If the initiator declared that
>> it supports the remote invalidate exception then the target will
>> use IB_WR_SEND_WITH_INV with the correct rkey for the response.
>
> same comment as the one I posted for the initiator patch, check for
> IB_DEVICE_MEM_MGT_EXTENSIONS

SEND_WITH_INV doesn't have anything to do with
IB_DEVICE_MEM_MGT_EXTENSIONS does it? What is the relations between
the device capability to do FRWR and invalidating a remote rkey?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

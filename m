From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next 03/10] IB/iser: Don't register memory for all
 immediatedata writes
Date: Tue, 17 Nov 2015 12:11:22 +0200
Message-ID: <564AFD4A.4030300@mellanox.com>
References: <1447691861-3796-1-git-send-email-sagig@mellanox.com>
 <1447691861-3796-4-git-send-email-sagig@mellanox.com>
 <564ADB7D.20806@mellanox.com> <564AF653.6060401@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <564AF653.6060401-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Jenny Derzhavetz <jennyf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/17/2015 11:41 AM, Sagi Grimberg wrote:
>
>> what's the role of this hunk? why it belongs here? you are testing
>> device->mr but this is something global and has nothing to do 
>> specially with specific IOs for
>> which this patch aims to act
>
> It's because device->mr might not be allocated at all if
> always_register=Y, however in this case for all-immediatedata writes
> I don't need memory registration and I can use pd->local_dma_lkey.
>
> This hunk prevents a NULL dereference (as I mentioned, device->mr might
> not be allocated at all). 

I am not sure to follow, but can't you put this fix into a separate 
patch to make things more clearer?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

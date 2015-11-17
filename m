From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH for-next 04/10] IB/iser: set intuitive values for mr_valid
Date: Tue, 17 Nov 2015 11:43:42 +0200
Message-ID: <564AF6CE.9060904@dev.mellanox.co.il>
References: <1447691861-3796-1-git-send-email-sagig@mellanox.com>
 <1447691861-3796-5-git-send-email-sagig@mellanox.com>
 <564ADAB5.3080208@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <564ADAB5.3080208-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Jenny Derzhavetz <jennyf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 17/11/2015 09:43, Or Gerlitz wrote:
> On 11/16/2015 6:37 PM, Sagi Grimberg wrote:
>> This parameter is described as "is mr valid indicator".
>> In other words, it indicates whether memory registration
>> is valid or not. So intuitive values would be:
>> mr_valid=True, when memory registration is valid and
>> mr_valid=False otherwise.
>
> and what was there before? the other way around?
>
> on what cases the indicator is false (with the new semantics)?

This is just an attempt to fix the confusing semantics I gave these
flags. If the MR is valid it needs invalidation, that's it...

>
> Also, we have a convention of starting commit titles with capital
> letters, please follow on that "Set iser [...]"

Will fix...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

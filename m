From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: COMMERCIAL: Re: [PATCH V3] IB/mad: Fix 0-day build
Date: Wed, 1 Jul 2015 10:46:38 +0300
Message-ID: <55939ADE.3070307@mellanox.com>
References: <1435248289-16477-1-git-send-email-ira.weiny@intel.com>
 <558C3A55.3050701@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <558C3A55.3050701-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 6/25/2015 8:28 PM, Bart Van Assche wrote:
> On 06/25/2015 09:04 AM, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
>> From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>>
>> The define OPA_LID_PERMISSIVE is big endian and was compared to cpu 
>> value
>> opa_drslid.
>>
>> 0-day build caught this while building with the OPA (hfi1) driver 
>> which was
>> recently sent to the list.
>>
>> Fixes: 8e4349d13f33 (IB/mad: Add final OPA MAD processing)
>
> Hello Ira,
>
> For future patches please make sure that the subject of the patch 
> describes what has been fixed instead of referring to the tool that 
> detected the issue.
>

Also, Ira, make sure to avoid two patches with the same name in the same 
series, such as

f28990b IB/mad: Add partial Intel OPA MAD support
548ead1 IB/mad: Add partial Intel OPA MAD support

Maybe you should ask Sean to go over patch titles and change-logs till 
you'll be up to speed on how this should be done, he has lots of kernel 
experience

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

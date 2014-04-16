From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 7/8] xprtrdma: Split the completion queue
Date: Wed, 16 Apr 2014 18:18:24 +0300
Message-ID: <534E9F40.8000905@dev.mellanox.co.il>
References: <20140414220041.20646.63991.stgit@manet.1015granger.net> <20140414222323.20646.66946.stgit@manet.1015granger.net> <534E7C1C.5070407@dev.mellanox.co.il> <534E8608.8030801@opengridcomputing.com> <534E8FCE.909@dev.mellanox.co.il> <003401cf597f$b0f8d590$12ea80b0$@opengridcomputing.com> <534E9534.9020004@dev.mellanox.co.il> <004a01cf5982$44793b50$cd6bb1f0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <004a01cf5982$44793b50$cd6bb1f0$@opengridcomputing.com>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Chuck Lever' <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 4/16/2014 5:43 PM, Steve Wise wrote:
>>>> Hmm, But if either FASTREG or LINV failed the QP will go to error state
>>>> and you *will* get the error wc (with a rain of FLUSH errors).
>>>> AFAICT it is safe to assume that it succeeded as long as you don't get
>>>> error completions.
>>> But if an unsignaled FASTREG is posted and silently succeeds, then the next signaled work
>> request fails, I believe the FASTREG will be completed with FLUSH status, yet the operation
>> actually completed in the hw.
>>
>> Actually if (any) WR successfully completed and SW got it as FLUSH error
>> it seems like a bug to me.
>> Once the HW processed the WQ entry it should update the consumer index
>> accordingly thus should not happen.
> Aren't you assuming a specific hardware design/implementation?  For cxgb4, the fact that a work request was consumed by the HW from the host send queue in no way indicates it is complete.  Also, the RDMA specs specifically state that the rnic/hca implementation can only assume an unsignaled work request completes successfully (and make its slot in the SQ available for the ULP) when a subsequent signaled work request completes successfully.   So if the next signaled work request fails, I believe the completion status of prior unsignaled work requests is indeterminate.

Well actually I wasn't, I just assumed that FLUSH errors will come for 
all WQ entries in the range {CI, PI}.
I get it, if a suppressed WQe was consumed and QP went to error state 
before a completion was placed, HW may flush it as well.
I agree this may happen. Thanks!

Sagi.
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

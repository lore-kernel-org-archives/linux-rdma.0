From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: Re: [PATCH] IB/qib: remove duplicate code
Date: Sat, 22 Jul 2017 12:29:39 -0500
Message-ID: <ba06517e-d5c6-d20b-08a2-4daaa35d0486@embeddedor.com>
References: <20170607204202.GA29640@embeddedgus>
 <0d5d4e1c-ee2f-2ecb-bf25-b95954cbb5f7@redhat.com>
 <b8850d3a-982e-3e06-aafe-58187691e5dc@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <b8850d3a-982e-3e06-aafe-58187691e5dc@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Mike Marciniszyn <infinipath@intel.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Hi Doug,

On 07/22/2017 12:22 PM, Doug Ledford wrote:
> On 7/22/2017 1:20 PM, Doug Ledford wrote:
>> On 6/7/2017 4:42 PM, Gustavo A. R. Silva wrote:
>>> Remove duplicate code.
>>>
>>> Addresses-Coverity-ID: 1226951
>>> Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
>>
>> This patch was accepted into 4.13-rc, thanks.
>
> Correction, this patch is in my queue for my for-next branch, only the
> other patch, referenced below, made it into 4.13-rc.
>

That's cool.

>> In addition, I no longer have the original email for another patch of
>> yours that was also accepted into 4.13-rc.  You created the patch in a
>> thread asking about the argument position for argument usage in
>> ib_init_ah_from_wc().  Your comment addition was accepted as well.
>>
>>

Yeah, I noticed that. I'm glad to help out. :)

Thank you
-- 
Gustavo A. R. Silva

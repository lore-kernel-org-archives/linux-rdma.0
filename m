From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: Re: [PATCH 1/2] IB/hfi1: Fix a parameter of find_first_bit.
Date: Sat, 27 Aug 2016 07:25:02 +0200
Message-ID: <d3eea048-5c7e-a5e9-900b-fabf0f6e38c8@wanadoo.fr>
References: <1472186949-9025-1-git-send-email-christophe.jaillet@wanadoo.fr>
 <cf61e699-9e2d-a594-64e6-43ea33b239d9@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <cf61e699-9e2d-a594-64e6-43ea33b239d9@redhat.com>
Sender: kernel-janitors-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, mike.marciniszyn@intel.com, dennis.dalessandro@intel.com, sean.hefty@intel.com, hal.rosenstock@gmail.com
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Kernel Janitors <kernel-janitors@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

Le 26/08/2016 à 15:35, Doug Ledford a écrit :
> On 8/26/2016 12:49 AM, Christophe JAILLET wrote:
>> The 2nd parameter of 'find_first_bit' is the number of bits to search.
>> In this case, we are passing 'sizeof(unsigned long)' which is likely to
>> be 4 or 8.
> If the size can be 4 or 8, then using 64 universally is not correct.
> Why not use sizeof() * 8 (or << 3)?
I agree with you...

BTW, the log message is wrong. 'port_mask' is a u64. (not an unsigned 
long). So the sizeof should always be 8.
(cut and paste error from another patch, sorry)

>
>> It is likely that the number of bits of 'port_mask' was expected 
>> here. This
>> variable is a 'u64', so use 64 instead.
>>
>> It has been spotted by the following coccinelle script:
>> @@
>> expression ret, x;
>>
>> @@
>> *  ret = \(find_first_bit \| find_first_zero_bit\) (x, sizeof(...));
>>
>> Signed-off-by: Christophe JAILLET 
>> <christophe.jaillet-39ZsbGIQGT5GWvitb5QawA@public.gmane.org>
>> ---
>> Not sure that using 64 directly is the best option.
>> Maybe '8 * sizeof(port_mask)' as used in the same file for
>> 'for_each_set_bit' would be better
>> ---
... as noted here

Would you like a v2 patch or, will you update it by yourself?

Best regards,
CJ

---
L'absence de virus dans ce courrier électronique a été vérifiée par le logiciel antivirus Avast.
https://www.avast.com/antivirus


From: Don Hiatt <don.hiatt@intel.com>
Subject: Re: [PATCH 2/2] IB/hfi1: Do not warn on lid conversions for OPA
Date: Mon, 4 Dec 2017 09:28:07 -0800
Message-ID: <caedb116-7e5a-5461-0c72-500b56d5b6be@intel.com>
References: <20171129125943.31113.29038.stgit@phlsvslse11.ph.intel.com>
 <20171129125948.31113.59826.stgit@phlsvslse11.ph.intel.com>
 <20171129184324.GF4011@ziepe.ca> <20171204121333.GC18589@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20171204121333.GC18589@kroah.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Greg KH <greg@kroah.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: Mike Marciniszyn <mike.marciniszyn@intel.com>, stable@vger.kernel.org, linux-rdma@vger.kernel.org, stable-commits@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org



On 12/4/2017 4:13 AM, Greg KH wrote:
> On Wed, Nov 29, 2017 at 11:43:24AM -0700, Jason Gunthorpe wrote:
>> On Wed, Nov 29, 2017 at 07:59:49AM -0500, Mike Marciniszyn wrote:
>>> From: Don Hiatt <don.hiatt@intel.com>
>>>
>>> Upstream commit 4988be5813ff2afdc0d8bfa315ef34a577d3efbf.
>>>
>>> On OPA devices opa_local_smp_check will receive 32Bit LIDs when the LID
>>> is Extended. In such cases, it is okay to lose the upper 16 bits of the
>>> LID as this information is obtained elsewhere. Do not issue a warning
>>> when calling ib_lid_cpu16() in this case by masking out the upper 16Bits.
>> The concept for the 32 bit lids was to keep it 32 bit inside the
>> kernel, ingress_key_table_fail puts the lid into
>> err_info_constraint.slid which is already 32 bits, so this cannot be
>> the right place for this.
>>
>> These truncations should only appear at the uapi boundary.
> Ok, but that's what the change in Linus's tree does.  If you object to
> that, please fix it there :)
Hi Jason,

I have changes for this that I can submit as a follow on patch, please 
let me know
if this is how you'd like to proceed.

don


> thanks,
>
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

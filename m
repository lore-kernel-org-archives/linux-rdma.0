From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: Re: [PATCH for-rc] IB/hfi: Only read capability registers if the
 capability exists
Date: Fri, 22 Dec 2017 12:11:20 -0500
Message-ID: <88313671-f548-f42a-6162-f02482db3912@intel.com>
References: <20171222164717.31842.12554.stgit@scvm10.sc.intel.com>
 <20171222165352.GD30884@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20171222165352.GD30884@ziepe.ca>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: dledford@redhat.com, linux-rdma@vger.kernel.org, "Michael J. Ruhl" <michael.j.ruhl@intel.com>, Mike Marciniszyn <mike.marciniszyn@intel.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 12/22/2017 11:53 AM, Jason Gunthorpe wrote:
> On Fri, Dec 22, 2017 at 08:47:20AM -0800, Dennis Dalessandro wrote:
>> From: Michael J. Ruhl <michael.j.ruhl@intel.com>
>>
>> During driver init, various registers are saved to allow restoration
>> after an FLR or gen3 bump.  Some of these registers are not available
>> in some circumstances (i.e. Virtual machines).
>>
>> Delete unnecessary register read/write, and only access register if
>> the capability exists.
>>
>> Cc: <stable@vger.kernel.org> # 4.14.x
>> Fixes: a618b7e40af2 ("IB/hfi1: Move saving PCI values to a separate function")
>> Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
>> Signed-off-by: Michael J. Ruhl <michael.j.ruhl@intel.com>
>> Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
>>   drivers/infiniband/hw/hfi1/hfi.h  |    1 -
>>   drivers/infiniband/hw/hfi1/pcie.c |   30 ++++++++++++------------------
>>   2 files changed, 12 insertions(+), 19 deletions(-)
> 
> Since we are getting late in the RC cycle can you help me clarify the
> user visible bug here? No need to resend
> 
> I'm guessing when hfi1 is used in a virtual machine with passthrough
> (SRIOV?) it fails in ?? way?

Ugh. I actually amended the commit message to include a blurb on the 
impact. Sorry about that, not sure what happened. It should have had 
this line of text:

"
Without this patch the driver will not load on a virtual machine.
"

So basically we just don't work on VMs. There is no panic or anything. I 
was on the fence whether it could go for this late of an -rc or not.

-Denny

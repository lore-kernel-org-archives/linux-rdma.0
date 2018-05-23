From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: Re: [PATCH for-next 0/5] IB/hfi1,isert: Updates for-next 5/15/2018
Date: Tue, 22 May 2018 20:54:05 -0400
Message-ID: <77a63b1c-1307-8533-4a34-b46768627f46@intel.com>
References: <20180516012947.12474.2286.stgit@scvm10.sc.intel.com>
 <38faf50391a9bc1a8d874a32ce5857a4023dff3e.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <38faf50391a9bc1a8d874a32ce5857a4023dff3e.camel@redhat.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, jgg@ziepe.ca
Cc: Mike Marciniszyn <mike.marciniszyn@intel.com>, linux-rdma@vger.kernel.org, Alex Estrin <alex.estrin@intel.com>, stable@vger.kernel.org, Kaike Wan <kaike.wan@intel.com>, "Michael J. Ruhl" <michael.j.ruhl@intel.com>, Don Dutile <ddutile@redhat.com>, Kamenee Arumugam <kamenee.arumugam@intel.com>
List-Id: linux-rdma@vger.kernel.org

On 5/22/2018 3:33 PM, Doug Ledford wrote:
> On Tue, 2018-05-15 at 18:31 -0700, Dennis Dalessandro wrote:
>> Hi Doug and Jason,
>>
>> Here are some patches to go to for-next. One is a code cleanup. The rest are
>> bug fixes that are probably not serious enough for an -rc6. The one that may be
>> on the fence is the isert patch. Since it only affects debug kernels it can
>> probably even wait till for-next. It has been marked stable though.
>>
>> ---
>>
>> Alex Estrin (1):
>>        IB/isert: Fix for lib/dma_debug check_sync warning
>>
>> Kamenee Arumugam (1):
>>        IB/Hfi1: Mask Unsupported Request error bit in PCIe AER
>>
>> Michael J. Ruhl (1):
>>        IB/hfi1: Set port number for errorinfo MAD response
>>
>> Mike Marciniszyn (2):
>>        IB/hfi1: Cleanup of exp_rcv
>>        IB/{rdmavt,hfi1}; Change hrtimer add to use the pinned variation
> 
> Hi Denny,
> 
> I dropped the PCI bit fiddling patch as per comments.  Please provide a
> more detailed commit message if you want this patch to go in.

Kamenee is looking into this some more. Yeah, OK to drop for now, we'll 
resubmit with at least a better commit message or a different approach 
depending on her investigation.
  > I provided my own guestimate of a commit message touchup to the hrtimers
> patch.  Please let me know if I was wrong in my assumptions there.

Sounds good to me, thanks!

-Denny

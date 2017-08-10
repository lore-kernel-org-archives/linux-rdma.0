From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Subject: Re: [PATCH for-next 00/27] IB/hfi1, rdmavt, core, etc: patches for
 next 08/04/2017
Date: Thu, 10 Aug 2017 13:05:22 -0400
Message-ID: <f73b2f88-bc1b-92ed-1632-d2f3b1583d60@intel.com>
References: <20170804204842.17853.14858.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170804204842.17853.14858.stgit@scvm10.sc.intel.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: dledford@redhat.com
Cc: Mike Marciniszyn <mike.marciniszyn@intel.com>, Bartlomiej Dudek <bartlomiej.dudek@intel.com>, Jakub Byczkowski <jakub.byczkowski@intel.com>, linux-rdma@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>, Alex Estrin <alex.estrin@intel.com>, stable@vger.kernel.org, "Michael J. Ruhl" <michael.j.ruhl@intel.com>, Don Hiatt <don.hiatt@intel.com>, Sebastian Sanchez <sebastian.sanchez@intel.com>
List-Id: linux-rdma@vger.kernel.org

On 8/4/2017 4:52 PM, Dennis Dalessandro wrote:

> Dasaratharaman Chandramouli (10):
>        IB/core: Convert ah_attr from OPA to IB when copying to user
>        IB/srpt: Increase lid and sm_lid to 32 bits
>        IB/IPoIB: Increase local_lid to 32 bits
>        IB/mad: Change slid in RMPP recv from 16 to 32 bits
>        IB/core: Change port_attr.lid size from 16 to 32 bits
>        IB/core: Change port_attr.sm_lid from 16 to 32 bits
>        IB/CM: Create appropriate path records when handling CM request
>        IB/CM: Set appropriate slid and dlid when handling CM request
>        IB/rdmavt,hfi1,qib: Enhance rdmavt and hfi1 to use 32 bit lids
>        IB/hfi1: Enable RDMA_CAP_OPA_AH in hfi driver to support extended LIDs

Leon had some comments with these patches and Don is going to submit an 
updated version of these 10. These were submitted previously back in 
early June and sat on the list without comment. Hearing no feedback I 
rebased them and sent with my other patches so we could get the driver 
patches out.

In hindsight we probably should have just submitted another revision to 
these 10 and sent the following 11 and the other 6 as a separate series. 
If that makes things easier we can still do that. Let me know the 
easiest way for you to consume these.

> Don Hiatt (11):
>        IB/core: Change wc.slid from 16 to 32 bits
>        IB/CM: Add OPA Path record support to CM
>        IB/rdmavt,hfi1,qib: Modify check_ah() to account for extended LIDs
>        IB/hfi1: Add support to receive 16B bypass packets
>        IB/hfi1: Add support to send 16B bypass packets
>        IB/hfi1: Add support to process 16B header errors
>        IB/hfi1: Determine 9B/16B L2 header type based on Address handle
>        IB/hfi1: Add 16B UD support
>        IB/hfi1: Add 16B trace support
>        IB/hfi1: Add 16B RC/UC support
>        IB/hfi1: Enhance PIO/SDMA send for 16B

These will still apply, as will the other 6 patches in this series.

-Denny

From: "Saleem, Shiraz" <shiraz.saleem@intel.com>
Subject: RE: [RFC v1 17/19] RDMA/irdma: Add ABI definitions
Date: Wed, 20 Feb 2019 14:52:03 +0000
Message-ID: <9DD61F30A802C4429A01CA4200E302A7A5A46077@fmsmsx124.amr.corp.intel.com>
References: <20190215171107.6464-1-shiraz.saleem@intel.com>
 <20190215171107.6464-18-shiraz.saleem@intel.com>
 <20190215171638.GA30706@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190215171638.GA30706@ziepe.ca>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: "dledford@redhat.com" <dledford@redhat.com>, "davem@davemloft.net" <davem@davemloft.net>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "Ismail, Mustafa" <mustafa.ismail@intel.com>, "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
List-Id: linux-rdma@vger.kernel.org

>Subject: Re: [RFC v1 17/19] RDMA/irdma: Add ABI definitions
>
>On Fri, Feb 15, 2019 at 11:11:04AM -0600, Shiraz Saleem wrote:
>> From: Mustafa Ismail <mustafa.ismail@intel.com>
>>
>> Add ABI definitions for irdma.

[....]
>>
>> +
>> +#include <linux/types.h>
>> +
>> +#define IRDMA_ABI_VER	6
>
>Starting with high numbers?

It's a bump on the current i40iw ABI ver. of 5 since we
want to be compatible and support current rdma-core's libi40iw
for Gen1 (X722) device.

>
>> +enum irdma_memreg_type {
>> +	IW_MEMREG_TYPE_MEM  = 0,
>> +	IW_MEMREG_TYPE_QP   = 1,
>> +	IW_MEMREG_TYPE_CQ   = 2,
>> +	IW_MEMREG_TYPE_RSVD = 3,
>> +	IW_MEMREG_TYPE_MW   = 4,
>> +};
>> +
>> +struct irdma_alloc_ucontext_req {
>> +	__u32 rsvd32;
>> +	__u8 userspace_ver;
>> +	__u8 rsvd8[3];
>> +};
>> +
>> +struct irdma_alloc_ucontext_resp {
>> +	__u8 kernel_ver;
>> +	__u8 rsvd[7];
>> +	struct irdma_hw_attrs hw_attrs;
>
>This won't even compile like this - don't forget you have to send the rdma-core
>PR along with the kernel patches. You should already be running the travis
>checks yourself. rdma-core should detect malformed user space headers..

Yes. We will be sending the rdma-core patches soon.
Maybe we are missing something here, but this did compile with libirdma
in rdma-core-v22, but we havent run travis checks yet.

>
>> +struct irdma_mem_reg_req {
>> +	__u16 reg_type;	 /* Memory, QP or CQ */
>> +	__u16 cq_pages;
>> +	__u16 rq_pages;
>> +	__u16 sq_pages;
>> +};
>
>New structs should be aligned to 8 bytes.
>
>> +struct i40iw_create_qp_resp {
>> +	__u32 qp_id;
>> +	__u32 actual_sq_size;
>> +	__u32 actual_rq_size;
>> +	__u32 i40iw_drv_opt;
>> +	__u16 push_idx;
>> +	__u8  lsmm;
>> +	__u8  rsvd2;
>> +};
>
>ditto

This is not aligned to 8 bytes. But the previous one is ok right?

>
>> +struct irdma_create_ah_resp {
>> +	__u32 ah_id;
>> +	__u32 rsvd[4];
>
>typo? __u8?
>

Yes. Thanks!

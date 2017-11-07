From: Daniel Jurgens <danielj@mellanox.com>
Subject: Re: [PATCH rdma-next] IB/core: Only maintain real QPs in the security
 lists
Date: Tue, 7 Nov 2017 11:15:12 -0600
Message-ID: <87a902ae-351b-43c4-4a42-b362c981a767@mellanox.com>
References: <20171107163326.23881-1-leon@kernel.org>
 <20171107164632.GA7063@ziepe.ca>
 <065e66ff-e901-bd5c-674d-173eab720989@mellanox.com>
 <20171107165539.GB7063@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20171107165539.GB7063@ziepe.ca>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 11/7/2017 10:55 AM, Jason Gunthorpe wrote:
> On Tue, Nov 07, 2017 at 10:52:11AM -0600, Daniel Jurgens wrote:
>> On 11/7/2017 10:46 AM, Jason Gunthorpe wrote:
>>> On Tue, Nov 07, 2017 at 06:33:26PM +0200, Leon Romanovsky wrote:
>>>
>>>> -	bool special_qp = (qp->qp_type == IB_QPT_SMI ||
>>>> -			   qp->qp_type == IB_QPT_GSI ||
>>>> -			   qp->qp_type >= IB_QPT_RESERVED1);
>>>> +	struct ib_qp *real_qp = qp->real_qp;
>>>> +	bool special_qp = (real_qp->qp_type == IB_QPT_SMI ||
>>>> +			   real_qp->qp_type == IB_QPT_GSI ||
>>>> +			   real_qp->qp_type >= IB_QPT_RESERVED1);
>>> This QPT_RESERVED stuff was not supposed to be visible to the core
>>> layer, so why are we adding checks in security????
>> The checks exclude those QPs from security enforcement.  They've
>> been there the whole time, you reviewed this previously right?
> Nope
>
> .. and they shouldn't be there, those reserved QPTs are totally banned
> from user space so it shouldn't matter for security
>
> Jason
>
This flow is through ib_modify_qp, it's not user space specific.  If it really pains you that much it can be changed an inclusive compare instead of exclusive. This discussion isn't relevant  to the content of the patch in question though.

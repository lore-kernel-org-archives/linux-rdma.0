From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: Re: [PATCH v2] RDMA/rxe: Set wqe->status correctly if an unexpected
 response is received
Date: Wed, 27 Jun 2018 09:41:11 -0700
Message-ID: <ac7e43f3-f753-caf3-3e09-8041bac017f9@wdc.com>
References: <20180626153936.9576-1-bart.vanassche@wdc.com>
 <20180627163150.GA9553@lap1>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180627163150.GA9553@lap1>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Yuval Shaia <yuval.shaia@oracle.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Zhu Yanjun <yanjun.zhu@oracle.com>, Jianchao Wang <jianchao.w.wang@oracle.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On 06/27/18 09:32, Yuval Shaia wrote:
> On Tue, Jun 26, 2018 at 08:39:36AM -0700, Bart Van Assche wrote:
>> Every function that returns COMPST_ERROR must set wqe->status to
>> another value than IB_WC_SUCCESS before returning COMPST_ERROR. Fix
>> the only code path for which this is not yet the case.
> 
> It is unclear to me why other places left out from this fix (e.x. lines
> 248, 288 etc).

Hello Yuval,

wqe->status is already set before the code that you mentioned has been 
reached.

Bart.

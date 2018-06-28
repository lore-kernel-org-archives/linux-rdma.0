From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: Re: [PATCH v2] RDMA/rxe: Set wqe->status correctly if an unexpected
 response is received
Date: Thu, 28 Jun 2018 08:47:39 -0700
Message-ID: <420a0ebb-9b5d-97ee-ccea-f9fdf394daec@wdc.com>
References: <20180626153936.9576-1-bart.vanassche@wdc.com>
 <20180627163150.GA9553@lap1> <ac7e43f3-f753-caf3-3e09-8041bac017f9@wdc.com>
 <CAG9sBKOsm6Sn9pQ6-WiGx325SLCsONPCnKnkcTk0ZqPZmLbRHw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <CAG9sBKOsm6Sn9pQ6-WiGx325SLCsONPCnKnkcTk0ZqPZmLbRHw@mail.gmail.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Moni Shoua <monis@mellanox.com>
Cc: Yuval Shaia <yuval.shaia@oracle.com>, Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>, linux-rdma <linux-rdma@vger.kernel.org>, "yanjun.zhu@oracle.com" <yanjun.zhu@oracle.com>, "jianchao.w.wang@oracle.com" <jianchao.w.wang@oracle.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On 06/28/18 01:58, Moni Shoua wrote:
>> wqe->status is already set before the code that you mentioned has been
>> reached.
 >
> can you be more specific?
> for instance I didn't find similar behavior for the example below
> (also in check_ack())
> 
>          case IB_OPCODE_RC_ATOMIC_ACKNOWLEDGE:
>                  syn = aeth_syn(pkt);
> 
>                  if ((syn & AETH_TYPE_MASK) != AETH_ACK)
>                          return COMPST_ERROR;
> 
>                  if (wqe->wr.opcode != IB_WR_ATOMIC_CMP_AND_SWP &&
>                      wqe->wr.opcode != IB_WR_ATOMIC_FETCH_AND_ADD)
>                          return COMPST_ERROR;   <<<<<<<<<<<<<<<<<<<<<<<<<<
>                  reset_retry_counters(qp);
>                  return COMPST_ATOMIC;

Hello Moni,

I may have been wrong when I claimed that all other paths that return 
COMPST_ERROR already set wqe->status to an error value. However, I only 
have a test case for the path I modified. Hence my patch.

Bart.

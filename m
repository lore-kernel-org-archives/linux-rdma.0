From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: generic RDMA READ/WRITE API V6
Date: Fri, 22 Apr 2016 15:29:28 -0700
Message-ID: <571AA5C8.4080502@sandisk.com>
References: <1460410360-13104-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1460410360-13104-1-git-send-email-hch@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, dledford@redhat.com
Cc: swise@opengridcomputing.com, sagi@grimberg.me, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 04/11/2016 02:32 PM, Christoph Hellwig wrote:
> 	git://git.infradead.org/users/hch/rdma.git rdma-rw-api

Hello Christoph,

Is the version that has been pushed on April 18 the latest and greatest 
version of this patch series ? I'm asking because with that version I 
see error messages appearing that I hadn't seen with the previous version:

ib_srpt:srpt_qp_event: ib_srpt QP event 16 on cm_id=ffff8801713d5628 
sess_name=0x0000000000000000e41d2d03000a85b1 state=1
ib_srpt:srpt_qp_event: ib_srpt 0x0000000000000000e41d2d03000a85b1-522, 
state live: received Last WQE event.
ib_srpt RDMA_READ for ioctx 0xffff8804593092a8 failed with status 4

This test was run with the force_mr=Y:

$ cat /etc/modprobe.d/ib_core.conf
options ib_core force_mr=Y

Thanks,

Bart.

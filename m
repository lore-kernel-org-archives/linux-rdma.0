From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 05/13] IB/core: add a simple MR pool
Date: Wed, 2 Mar 2016 07:22:43 -0800
Message-ID: <56D70543.1000506@sandisk.com>
References: <1456596631-19418-1-git-send-email-hch@lst.de>
 <1456596631-19418-6-git-send-email-hch@lst.de>
 <CAG53R5W2Xi--LdMwwcB68d+2VYS100zEM+zW4Qi79SwoUiQE=w@mail.gmail.com>
 <20160302091554.GC1308@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20160302091554.GC1308@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Parav Pandit <pandit.parav@gmail.com>
Cc: linux-rdma@vger.kernel.org, swise@opengridcomputing.com, Sagi Grimberg <sagig@mellanox.com>, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 03/02/16 01:15, Christoph Hellwig wrote:
> On Wed, Mar 02, 2016 at 08:18:14AM +0530, Parav Pandit wrote:
>>>          struct list_head        xrcd_list;
>>> +
>>> +       spinlock_t              mr_lock;
>>> +       int                     mrs_used;
>>> +
>>
>> Can you please add the comment for mr_lock as requested by the
>> checkpatch script?
>
> No.  checkpath is asking for silly things (and apparently this one
> is so silly it doesn't even ask for it by default).
>
>> Also you might want to consider adding this field after recv_cq so
>> that we find mr_lock and used count in single cache line along with
>> other data for the qp?
>
> That sounds useful, I'll look into it.

Hello Christoph,

With the approach of V2 of this patch series mr_lock and the MR pool 
list head exist in different structures which is unfortunate. How about 
introducing a new structure for the MR pool list head and mr_lock? An 
additional advantage of this approach is that it would allow to move the 
initialization of both structure members into ib_mr_pool_init().

Bart.

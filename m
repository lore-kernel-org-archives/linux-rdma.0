From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [RFC] iser-target: avoid reinitializing rdma contexts for isert
 commands
Date: Sun, 14 Jan 2018 11:26:04 +0200
Message-ID: <143bd378-193e-0bbd-1ee3-25299af61aa8@grimberg.me>
References: <1511893687-29298-1-git-send-email-bharat@chelsio.com>
 <20171218231439.GA31621@ziepe.ca>
 <1515824443.24576.108.camel@haakon3.daterainc.com>
 <20180113180428.GA32353@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20180113180428.GA32353@ziepe.ca>
Content-Language: en-US
Sender: target-devel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Bharat Potnuri <bharat@chelsio.com>, target-devel@vger.kernel.org, linux-rdma <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


>> Per Potnuri, it should be stable CC' to 4.11.y, and depends on:
>>
>> 7a56dc8 iser-target: avoid posting a recv buffer twice
>> 555a65f iser-target: Fix queue-full response handling
>> fa7e25c target: Fix unknown fabric callback queue-full errors
> 
> Hi Nicholas,
> 
> It is too late for us to revise this commit message in the RDMA tree,
> someone will have to notify stable manually instead.

I think it would be easier if nab would take this through the target
tree... Nic?

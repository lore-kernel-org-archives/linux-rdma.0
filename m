From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: SQ overflow seen running isert traffic with high block sizes
Date: Wed, 28 Jun 2017 13:39:35 +0300
Message-ID: <210f538f-8c98-f480-64fc-f2124ed6d01b@grimberg.me>
References: <BN3PR07MB25784033E7FCD062FA0A7855F8DD0@BN3PR07MB2578.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <BN3PR07MB25784033E7FCD062FA0A7855F8DD0@BN3PR07MB2578.namprd07.prod.outlook.com>
Content-Language: en-US
Sender: target-devel-owner@vger.kernel.org
To: "Amrani, Ram" <Ram.Amrani@cavium.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Cc: "Elior, Ariel" <Ariel.Elior@cavium.com>, target-devel <target-devel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

Hey Ram, CC'ing target-devel for iser-target related posts.

> We are hitting SQ overflow on iSER target side with high block sizes over RoCE
> (see dmesg output below).
> 
> We are using Q-Logic/Cavium NIC with a capability of 4 sges.

That's somewhat expected if the device has low max_sge. It was decided
that queue_full mechanism is not something that iser-target should
handle but rather the iscsi-target core on top.

You probably should not get into aborts though... Does the I/O complete?
or does it fail?

Is this upstream? is [1] applied?

I could come up with some queue-full handling in isert that will be more
lightweight, but I'd let Nic make a judgment call before I do anything.

[1]:
commit a4467018c2a7228f4ef58051f0511bd037bff264
Author: Nicholas Bellinger <nab@linux-iscsi.org>
Date:   Sun Oct 30 17:30:08 2016 -0700

     iscsi-target: Propigate queue_data_in + queue_status errors

     This patch changes iscsi-target to propagate iscsit_transport
     ->iscsit_queue_data_in() and ->iscsit_queue_status() callback
     errors, back up into target-core.

     This allows target-core to retry failed iscsit_transport
     callbacks using internal queue-full logic.

     Reported-by: Potnuri Bharat Teja <bharat@chelsio.com>
     Reviewed-by: Potnuri Bharat Teja <bharat@chelsio.com>
     Tested-by: Potnuri Bharat Teja <bharat@chelsio.com>
     Cc: Potnuri Bharat Teja <bharat@chelsio.com>
     Reported-by: Steve Wise <swise@opengridcomputing.com>
     Cc: Steve Wise <swise@opengridcomputing.com>
     Cc: Sagi Grimberg <sagi@grimberg.me>
     Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>

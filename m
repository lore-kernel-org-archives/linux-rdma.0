From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 02/11] IB/srp: simplify state tracking
Date: Mon, 26 Nov 2012 10:46:57 +0100
Message-ID: <50B33A91.3060103@acm.org>
References: <cover.1353903448.git.dillowda@ornl.gov> <6f9ad200f981a2fe49319e7437c842f03063a4f1.1353903448.git.dillowda@ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <6f9ad200f981a2fe49319e7437c842f03063a4f1.1353903448.git.dillowda@ornl.gov>
Sender: linux-scsi-owner@vger.kernel.org
To: David Dillow <dillowda@ornl.gov>
Cc: linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org, roland@purestorage.com
List-Id: linux-rdma@vger.kernel.org

On 11/26/12 05:44, David Dillow wrote:
> The state of the target has several conditions that overlap, making it
> easier to model as a bit-field of exceptional conditions rather than an
> enum of all possible states.
>
> Bart Van Assche did the hard work of identifying the states that can be
> removed, and did a first patch that consolidated the state space.
[ ... ]

Hi Dave,

Could you please explain why you would prefer to use test_bit () / 
test_and_set_bit() and clear_bit() for managing the SRP target state ? 
As far as I can see the target state is not changed in any code path 
where it matters how fast the state is changed. Maybe I'm missing 
something ?

Thanks,

Bart.

From: Tziporet Koren <tziporet@mellanox.co.il>
Subject: Re: [GIT PULL] please pull infiniband.git
Date: Tue, 25 Jan 2011 18:23:01 +0200
Message-ID: <4D3EF8E5.4080607@mellanox.co.il>
References: <adaei8byz3n.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <adaei8byz3n.fsf@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Roland Dreier <rdreier@cisco.com>
Cc: "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

   On 1/17/2011 11:55 PM, Roland Dreier wrote:
> Linus, please pull from
>
>      master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git for-linus
>
> This tree is also available from kernel.org mirrors at:
>
>      git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git for-linus
>
> This will get the last batch of InfiniBand/RDMA patches for the merge
> window.  The biggest thing here is Tejun's conversion of the RDMA
> stack away from flush_scheduled_work(); the remaining stuff is mostly
> driver fixes, with an SRP compile warning fix and a vzalloc()
> conversion patch thrown in.
Roland,

What about the new mlx4 device IDs?
We wish to have them in for CX3 so that the new kernel will support it

Thanks,
Tziporet

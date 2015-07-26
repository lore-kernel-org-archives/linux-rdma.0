From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 00/10] IB: Replace safe uses for ib_get_dma_mr with
 pd->local_dma_lkey
Date: Sun, 26 Jul 2015 11:45:29 +0300
Message-ID: <55B49E29.3070707@dev.mellanox.co.il>
References: <1437608083-22898-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <55B0F06E.8000603@sandisk.com> <20150723183044.GA1868@obsidianresearch.com>
 <55B13583.5010208@sandisk.com> <20150723184725.GB30303@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20150723184725.GB30303@obsidianresearch.com>
Sender: target-devel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Doug Ledford <dledford@redhat.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Amir Vadai <amirv@mellanox.com>, Chien Yen <chien.yen@oracle.com>, Christoph Hellwig <hch@infradead.org>, Dominique Martinet <dominique.martinet@cea.fr>, Eli Cohen <eli@mellanox.com>, Eric Van Hensbergen <ericvh@gmail.com>, Ido Shamay <idos@mellanox.com>, Latchesar Ionkov <lucho@ionkov.net>, Or Gerlitz <ogerlitz@mellanox.com>, Roi Dayan <roid@mellanox.com>, Ron Minnich <rminnich@sandia.gov>, Sagi Grimberg <sagig@mellanox.com>, Simon Derr <simon.derr@bull.net>, Tom Tucker <tom@opengridcomputing.com>, "rds-devel@oss.oracle.com" <rds-devel@oss.oracle.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


>> If we want security by default then I propose not only to change the default
>> value of register_always from false into true but also to change the default
>> value of prefer_fr from false into true such that fast registration becomes
>> the default instead of FMR.
>
> Yes, I was frowning at that stuff too.. We are trying to get rid of
> FMR, so nothing should prefer it over FRWR...
>
> Sagi, perhaps that belongs in your MR unification series?

I don't see how this fits in.

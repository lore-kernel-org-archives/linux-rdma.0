From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH v2 3/4] nvme: enable SG gaps support
Date: Sun, 23 Apr 2017 10:20:59 +0300
Message-ID: <9ff1a2e8-f84f-c772-e294-2339eee8e37d@grimberg.me>
References: <1492098977-5231-1-git-send-email-maxg@mellanox.com>
 <1492098977-5231-4-git-send-email-maxg@mellanox.com>
 <2bd673ee-8455-32b7-1bad-34fa9eebb076@grimberg.me>
 <20170421064427.GB6095@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170421064427.GB6095-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vladimirk-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Christoph,

> All our block I/O must be cache line aligned, so dword aligned SGLs
> should not be an issue.  And for PRPs or MRs we'll always use the
> host page size.

Where is that constraint coming from? Is that new? Back when I wrote
GAP support in rdma I tested a single byte alignment via vectored
direct IO and it seemed to be going through...

I also just tested Bart's unaligned test [1] on scsi_debug and it seems
to go through as well (alignment and length are 4)...

[1]:
https://github.com/bvanassche/srp-test/blob/master/discontiguous-io/discontiguous-io.cpp
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

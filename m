From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH v2 03/10] IB/iser: Don't register memory for all immediate
 data writes
Date: Thu, 10 Dec 2015 10:31:18 +0200
Message-ID: <56693856.6060704@dev.mellanox.co.il>
References: <1449663128-368-1-git-send-email-sagig@mellanox.com>
 <1449663128-368-4-git-send-email-sagig@mellanox.com>
 <20151209193047.GB21477@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20151209193047.GB21477@infradead.org>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Sagi Grimberg <sagig@mellanox.com>
Cc: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org, Or Gerlitz <ogerlitz@mellanox.com>, Jenny Derzhavetz <jennyf@mellanox.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
List-Id: linux-rdma@vger.kernel.org



On 09/12/2015 21:30, Christoph Hellwig wrote:
> The iser_reg_rdma_mem calling conventions seem rather confusing,
> and this patch doesn't help that.  But I think that's something
> to be addressed in bigger cleanup later on.

I do plan to rework this area. It would be nice to have it simpler,
But I want to rework the signature API a little bit before I do that.

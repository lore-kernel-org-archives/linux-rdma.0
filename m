From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH v2 0/2] Handle mlx4 max_sge_rd correctly
Date: Tue, 8 Dec 2015 20:13:00 +0200
Message-ID: <56671DAC.7060001@dev.mellanox.co.il>
References: <1446031696-19022-1-git-send-email-sagig@mellanox.com>
 <5641C8BC.40507@dev.mellanox.co.il> <20151203142730.GA20520@infradead.org>
 <56605AB7.3000705@dev.mellanox.co.il> <20151208170139.GA425@infradead.org>
 <56671A31.7090401@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <56671A31.7090401@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Christoph Hellwig <hch@infradead.org>
Cc: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org, Steve Wise <swise@opengridcomputing.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Or Gerlitz <ogerlitz@mellanox.com>
List-Id: linux-rdma@vger.kernel.org


> I've pulled these in.  Both of them failed to apply, and the first one
> was just flat baffling in terms of how Sagi is working from a source
> base so different than the one in the upstream kernel.  They should be
> double checked just to make sure I'm not missing something since they
> were so far off from applying to an upstream kernel.

Hi Doug,

I mentioned this in v1. This patch set is applied over Christoph's
device attributes patch. Will it go in as well?

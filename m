From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 5/5] IB/isert: Kill the ->isert_cmd back pointer in struct
 iser_tx_desc
Date: Tue, 23 Feb 2016 13:23:58 +0200
Message-ID: <56CC414E.9020109@dev.mellanox.co.il>
References: <1456148958-27973-1-git-send-email-hch@lst.de>
 <1456148958-27973-6-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1456148958-27973-6-git-send-email-hch@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@mellanox.com>
Cc: Max Gurtovoy <maxg@mellanox.com>, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


> We only use the pointer when processing regular iSER commands, and it then
> always points to the struct iser_cmd that contains the TX descriptor.

That was I hack I knew we will be able to get rid of once we move to
the new CQ API. The iscsi login response is not allocate a command
structure and this back-pointer was used to differentiate that. Now
that the login response has it's own done handler we can get rid of
it.

Thanks!

Reviewed-by: Sagi Grimberg <sagig@mellanox.com>

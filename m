From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: isert: convert to the new CQ API and a few random cleanups
Date: Tue, 16 Feb 2016 12:53:18 +0200
Message-ID: <56C2FF9E.2060206@dev.mellanox.co.il>
References: <1455567060-18381-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1455567060-18381-1-git-send-email-hch@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@mellanox.com>
Cc: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org, Max Gurtovoy <maxg@mellanox.com>, Jenny Derzhavetz <jennyf@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

Christoph! :)

> This series uses the new CQ API and cleans up a few random lose arounds
> around the R/W path.  I have a few more changes for the RW path in the
> works, but I think this is a good enough standalone series for now.

Thanks for doing this! I have a developer in my team working on this
but seems you beat him to it :)

I'll have a closer review comments following shortly. We have a few
patches in the pipe for isert so I'll have to see how these fit
together... I'll try to incorporate the needed changes so it'll
save you some respins.

Cheers,
Sagi.

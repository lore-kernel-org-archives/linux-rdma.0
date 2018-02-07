From: Christopher Lameter <cl@linux.com>
Subject: Re: [PATCH 00/24] InfiniBand Transport (IBTRS) and Network Block
 Device (IBNBD)
Date: Wed, 7 Feb 2018 10:35:14 -0600 (CST)
Message-ID: <alpine.DEB.2.20.1802071031590.21957@nuc-kabylake>
References: <20180202140904.2017-1-roman.penyaev@profitbricks.com> <1517591106.2675.28.camel@sandisk.com> <CAMGffEkhqR9Z5bkMfnVn8an2OUM8k+jYoR5EFdtv3k9en1bh=w@mail.gmail.com> <1517847408.3764.5.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1517847408.3764.5.camel@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "jinpu.wang@profitbricks.com" <jinpu.wang@profitbricks.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "roman.penyaev@profitbricks.com" <roman.penyaev@profitbricks.com>, "sagi@grimberg.me" <sagi@grimberg.me>, "ogerlitz@mellanox.com" <ogerlitz@mellanox.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "danil.kipnis@profitbricks.com" <danil.kipnis@profitbricks.com>
List-Id: linux-rdma@vger.kernel.org

On Mon, 5 Feb 2018, Bart Van Assche wrote:

> That approach may work well for your employer but sorry I don't think this is
> sufficient for an upstream driver. I think that most users who configure a
> network storage target expect full control over which storage devices are exported
> and also over which clients do have and do not have access.

Well is that actually true for IPoIB? It seems that I can arbitrarily
attach to any partition I want without access control. In many ways some
of the RDMA layers and modules are loose with security since performance
is what matters mostly and deployments occur in separate production
environments.

We have had security issues (that not fully resolved yet) with the RDMA
RPC API for years.. So maybe lets relax on the security requirements a
bit?

From: Roman Penyaev <roman.penyaev@profitbricks.com>
Subject: Re: [PATCH 00/24] InfiniBand Transport (IBTRS) and Network Block
 Device (IBNBD)
Date: Wed, 7 Feb 2018 18:18:47 +0100
Message-ID: <CAJrWOzBrbV0yJvCvKxAK2Arujf7wiCx_Xoo9jdiwDRj93Lq7Yg@mail.gmail.com>
References: <20180202140904.2017-1-roman.penyaev@profitbricks.com>
 <1517591106.2675.28.camel@sandisk.com> <CAMGffEkhqR9Z5bkMfnVn8an2OUM8k+jYoR5EFdtv3k9en1bh=w@mail.gmail.com>
 <1517847408.3764.5.camel@wdc.com> <alpine.DEB.2.20.1802071031590.21957@nuc-kabylake>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.20.1802071031590.21957@nuc-kabylake>
Sender: linux-block-owner@vger.kernel.org
To: Christopher Lameter <cl@linux.com>
Cc: Bart Van Assche <Bart.VanAssche@wdc.com>, "jinpu.wang@profitbricks.com" <jinpu.wang@profitbricks.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "sagi@grimberg.me" <sagi@grimberg.me>, "ogerlitz@mellanox.com" <ogerlitz@mellanox.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "danil.kipnis@profitbricks.com" <danil.kipnis@profitbricks.com>
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 7, 2018 at 5:35 PM, Christopher Lameter <cl@linux.com> wrote:
> On Mon, 5 Feb 2018, Bart Van Assche wrote:
>
>> That approach may work well for your employer but sorry I don't think this is
>> sufficient for an upstream driver. I think that most users who configure a
>> network storage target expect full control over which storage devices are exported
>> and also over which clients do have and do not have access.
>
> Well is that actually true for IPoIB? It seems that I can arbitrarily
> attach to any partition I want without access control. In many ways some
> of the RDMA layers and modules are loose with security since performance
> is what matters mostly and deployments occur in separate production
> environments.
>
> We have had security issues (that not fully resolved yet) with the RDMA
> RPC API for years.. So maybe lets relax on the security requirements a
> bit?
>

Frankly speaking I do not understand the "security" about this kind of
block devices and RDMA in particular.  I can admit that personally I do
not see the whole picture, so can someone provide the real usecase/scenario?
What we have in our datacenters is trusted environment (do others exist?).
You need a volume, you create it.  You need to map a volume remotely -
you map it.  Of course there are provisioning checks, rw/ro checks, etc.
But in general any IP/key checks (is that client really a "good" guy or not?)
are simply useless.  So the question is: are there real life setups where
some of the local IB network members can be untrusted?

--
Roman

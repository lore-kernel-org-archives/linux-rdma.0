From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [RFC PATCH 00/28] INFINIBAND NETWORK BLOCK DEVICE (IBNBD)
Date: Fri, 24 Mar 2017 13:31:27 +0000
Message-ID: <1490362271.2516.4.camel@sandisk.com>
References: <1490352343-20075-1-git-send-email-jinpu.wangl@profitbricks.com>
         <20170324121526.GF3571@linux-x5ow.site>
         <CAMGffE=CitFGj11NhFKPL2MNiOVVyb-ggRe-MhewcobGY0-u5A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <CAMGffE=CitFGj11NhFKPL2MNiOVVyb-ggRe-MhewcobGY0-u5A@mail.gmail.com>
Content-Language: en-US
Content-ID: <B3379E42443D4F43A4AA3287953A00B2@sandisk.com>
Sender: linux-block-owner@vger.kernel.org
To: "jthumshirn@suse.de" <jthumshirn@suse.de>, "jinpu.wang@profitbricks.com" <jinpu.wang@profitbricks.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "mail@fholler.de" <mail@fholler.de>, "yun.wang@profitbricks.com" <yun.wang@profitbricks.com>, "hch@lst.de" <hch@lst.de>, "axboe@kernel.dk" <axboe@kernel.dk>, "Milind.dumbare@gmail.com" <Milind.dumbare@gmail.com>, "dledford@redhat.com" <dledford@redhat.com>
List-Id: linux-rdma@vger.kernel.org

On Fri, 2017-03-24 at 13:46 +0100, Jinpu Wang wrote:
> Our IBNBD project was started 3 years ago based on our need for Cloud
> Computing, NVMeOF is a bit younger.
> - IBNBD is one of our components, part of our software defined storage so=
lution.
> - As I listed in features, IBNBD has it's own features
>=20
> We're planning to look more into NVMeOF, but it's not a replacement for I=
BNBD.

Hello Jack, Danil and Roman,

Thanks for having taken the time to open source this work and to travel to
Boston to present this work at the Vault conference. However, my
understanding of IBNBD is that this driver has several shortcomings neither
NVMeOF nor iSER nor SRP have:
* Doesn't scale in terms of number of CPUs submitting I/O. The graphs shown
  during the Vault talk clearly illustrate this. This is probably the resul=
t
  of sharing a data structure across all client CPUs, maybe the bitmap that
  tracks which parts of the target buffer space are in use.
* Supports IB but none of the other RDMA transports (RoCE / iWARP).

We also need performance numbers that compare IBNBD against SRP and/or
NVMeOF with memory registration disabled to see whether and how much faster
IBNBD is compared to these two protocols.

The fact that IBNBD only needs to messages per I/O is an advantage it has
today over SRP but not over NVMeOF nor over iSER. The upstream initiator
drivers for the latter two protocols already support inline data.

Another question I have is whether integration with multipathd is supported=
?
If multipathd tries to run scsi_id against an IBNBD client device that will
fail.

Thanks,

Bart.=

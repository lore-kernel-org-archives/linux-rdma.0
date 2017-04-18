From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: RDMA performance comparison: IBNBD, SCST, NVMEoF
Date: Tue, 18 Apr 2017 18:22:16 +0000
Message-ID: <1492539735.2689.7.camel@sandisk.com>
References: <CAJrWOzAM_A6fwFxTZVo9MmiwWF1d6Bp9zTdBvUfnDFCPY_CmCQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <CAJrWOzAM_A6fwFxTZVo9MmiwWF1d6Bp9zTdBvUfnDFCPY_CmCQ@mail.gmail.com>
Content-Language: en-US
Content-ID: <83F3B037000BF6439770785DEEA4F212@namprd04.prod.outlook.com>
Sender: linux-block-owner@vger.kernel.org
To: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "roman.penyaev@profitbricks.com" <roman.penyaev@profitbricks.com>, "mail@fholler.de" <mail@fholler.de>, "sagi@grimberg.me" <sagi@grimberg.me>, "jinpu.wang@profitbricks.com" <jinpu.wang@profitbricks.com>, "yun.wang@profitbricks.com" <yun.wang@profitbricks.com>, "hch@lst.de" <hch@lst.de>, "axboe@kernel.dk" <axboe@kernel.dk>, "danil.kipnis@profitbricks.com" <danil.kipnis@profitbricks.com>, "Milind.dumbare@gmail.com" <Milind.dumbare@gmail.com>, "dledford@redhat.com" <dledford@redhat.com>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2017-04-18 at 19:33 +0200, Roman Penyaev wrote:
> By current email I would like to share some fresh RDMA performance
> results of IBNBD, SCST and NVMEof, based on 4.10 kernel and variety
> of configurations.

Hello Roman,

Thank you for having shared these results. But please do not expect me
to have another look at IBNBD before the design bugs in the driver and
also in the protocol get fixed. The presentation during Vault 2017 made
it clear that the driver does not scale if more than two CPUs submit I/O
simultaneously at the initiator side. The comments Sagi posted should be
addressed but I haven't seen any progress from the IBNBD authors with
regard to these comments ...

See also:
*=A0Danil Kipnis, Infiniband Network Block Device (IBNBD), Vault 2017
(https://vault2017.sched.com/event/9Xjw/infiniband-network-block-device-ibn=
bd-danil-kipnis-profitbricks-gmbh).
* Sagi Grimberg, Re: [RFC PATCH 00/28] INFINIBAND NETWORK BLOCK
DEVICE (IBNBD), March 27th, 2017
(https://www.spinics.net/lists/linux-rdma/msg47879.html).

Best regards,

Bart.=

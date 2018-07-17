From: Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: [RFC PATCH rdma-next 13/18] RDMA/mlx5: Enable decap and packet
 reformat on flow tables
Date: Tue, 17 Jul 2018 15:47:25 +0300
Message-ID: <CAJ3xEMjZQ+HNzFpmJG06Wq0T-Qo+sCfJDEhEM5h=8U+kSS76Mg@mail.gmail.com>
References: <20180716082305.11744-1-leon@kernel.org> <20180716082305.11744-14-leon@kernel.org>
 <CAJ3xEMiLrSZMqZTSySB+PwUsXoHfh99QJZ+_WdQQn4sgA2HYNQ@mail.gmail.com> <AM0PR05MB44032E09426E5E1DB5AD149ED25D0@AM0PR05MB4403.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <AM0PR05MB44032E09426E5E1DB5AD149ED25D0@AM0PR05MB4403.eurprd05.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
To: Mark Bloch <markb@mellanox.com>
Cc: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 17, 2018 at 12:46 AM, Mark Bloch <markb@mellanox.com> wrote:
>> From: Or Gerlitz [mailto:gerlitz.or@gmail.com]

>> > If NIC RX flow tables support decap opertion, enable it on creation.
>> opertion --> operation

saw it?

>> > If NIC TX flow tables support reformat opertion, enable it on creation.

opertion --> operation

>> What is the trigger to use the decap flag on RX table or encap flag on
>> TX table?

> It has no performance penalty to always enable that, so that's what I do if supported.

I was not referring to performance, see below

>> Please note that we have a short blanket w.r.t mutual usage by

> FDB and NIC steering tables have different limitations, so encap/decap on NIC steering
> have nothing to do with the limitations the FDB has with those operations.

no! AFAIK it has to do, the FW maintains three states for encap(decap)
NONE, FDB or NIC
if the state is NIC, an FDB table can't be created with encap set, and
the other way around, if the
state is FDB, NIC TX table can't be created with encap set, etc. This
is the short blanket I was
referring too, you can check me.

>> NIC vs e-Switch  steering, did you consider to do that on demand?
>
> The flow table needs to be created with those flags set if we want to attach
> decap/packet reformat action to it. BTW, there is no modify action for those bits
> so that's why I'm doing it on creation.

The question was if you can let the application tell you that they want to use
rules with encap/decap, as we did in the devlink switchdev API (encap enabled)

From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH for-rc] RDMA/vmw_pvrdma: Return the correct opcode when
 creating WR
Date: Mon, 7 Jan 2019 19:17:23 +0000
Message-ID: <20190107191716.GE27929@mellanox.com>
References: <1546887183-1238-1-git-send-email-aditr@vmware.com>
 <20190107185906.GD27929@mellanox.com>
 <7015989d-38ae-a4fb-5ca9-a88837774738@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <7015989d-38ae-a4fb-5ca9-a88837774738@vmware.com>
Content-Language: en-US
Content-ID: <3F4D33F7232D5C429ACB49BBC55BED05@eurprd05.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
To: Adit Ranadive <aditr@vmware.com>
Cc: "dledford@redhat.com" <dledford@redhat.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Pv-drivers <Pv-drivers@vmware.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jan 07, 2019 at 07:08:36PM +0000, Adit Ranadive wrote:
> On 1/7/19 10:59 AM, Jason Gunthorpe wrote:
> > On Mon, Jan 07, 2019 at 06:53:24PM +0000, Adit Ranadive wrote:
> >> From: Adit Ranadive <aditr@vmware.com>
> >>
> >> Since the IB_WR_REG_MR opcode value changed, set some of the PVRDMA de=
vice
> >> opcodes explicitly.
> >>
> >> Reported-by: Ruishuang Wang <ruishuangw@vmware.com>
> >> Fixes: 9a59739bd01f ("IB/rxe: Revise the ib_wr_opcode enum")
> >> Cc: stable@vger.kernel.org
> >> Reviewed-by: Bryan Tan <bryantan@vmware.com>
> >> Reviewed-by: Ruishuang Wang <ruishuangw@vmware.com>
> >> Reviewed-by: Vishnu Dasa <vdasa@vmware.com>
> >> Signed-off-by: Adit Ranadive <aditr@vmware.com>
> >>  drivers/infiniband/hw/vmw_pvrdma/pvrdma.h | 21 ++++++++++++++++++++-
> >>  1 file changed, 20 insertions(+), 1 deletion(-)
> >=20
> > So naughty!! How many other places in this driver are assuming the
> > intenal IB constants are stable?
> >=20
> > Did you audit for other cases?
>=20
> Lots of places. Though its the values shared with userspace, like QP type=
s,
> IB MTUs, etc. Unless you foresee changes to those ..=20

Constants declared in the include/uapi header should be OK, but you
still need to check that the constants you are using are actually in
that header and either recode them or move them into uapi, as
appropriate.

When constants get moved we may find more mistakes like this that
cause the kernel view to change.

Jason

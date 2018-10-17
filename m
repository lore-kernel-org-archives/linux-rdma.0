From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH v3] IB/rxe: Remove unnecessary enum values
Date: Wed, 17 Oct 2018 10:23:32 +0000
Message-ID: <20181017102331.GA30105@mellanox.com>
References: <20180927050156.20023-1-natechancellor@gmail.com>
 <20180927051222.23084-1-natechancellor@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180927051222.23084-1-natechancellor@gmail.com>
Content-Language: en-US
Content-ID: <1C4E4211A0EDCB4BB626B705499B4E40@eurprd05.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nathan Chancellor <natechancellor@gmail.com>
Cc: Moni Shoua <monis@mellanox.com>, Doug Ledford <dledford@redhat.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Nick Desaulniers <ndesaulniers@google.com>
List-Id: linux-rdma@vger.kernel.org

On Wed, Sep 26, 2018 at 10:12:23PM -0700, Nathan Chancellor wrote:
> Clang warns when an emumerated type is implicitly converted to another.
>=20
> drivers/infiniband/sw/rxe/rxe.c:106:27: warning: implicit conversion
> from enumeration type 'enum rxe_device_param' to different enumeration
> type 'enum ib_atomic_cap' [-Wenum-conversion]
>         rxe->attr.atomic_cap                    =3D RXE_ATOMIC_CAP;
>                                                 ~ ^~~~~~~~~~~~~~
> drivers/infiniband/sw/rxe/rxe.c:131:22: warning: implicit conversion
> from enumeration type 'enum rxe_port_param' to different enumeration
> type 'enum ib_port_state' [-Wenum-conversion]
>         port->attr.state                =3D RXE_PORT_STATE;
>                                         ~ ^~~~~~~~~~~~~~
> drivers/infiniband/sw/rxe/rxe.c:132:24: warning: implicit conversion
> from enumeration type 'enum rxe_port_param' to different enumeration
> type 'enum ib_mtu' [-Wenum-conversion]
>         port->attr.max_mtu              =3D RXE_PORT_MAX_MTU;
>                                         ~ ^~~~~~~~~~~~~~~~
> drivers/infiniband/sw/rxe/rxe.c:133:27: warning: implicit conversion
> from enumeration type 'enum rxe_port_param' to different enumeration
> type 'enum ib_mtu' [-Wenum-conversion]
>         port->attr.active_mtu           =3D RXE_PORT_ACTIVE_MTU;
>                                         ~ ^~~~~~~~~~~~~~~~~~~
> drivers/infiniband/sw/rxe/rxe.c:151:24: warning: implicit conversion
> from enumeration type 'enum rxe_port_param' to different enumeration
> type 'enum ib_mtu' [-Wenum-conversion]
>                                 ib_mtu_enum_to_int(RXE_PORT_ACTIVE_MTU);
>                                 ~~~~~~~~~~~~~~~~~~ ^~~~~~~~~~~~~~~~~~~
> 5 warnings generated.
>=20
> Use the appropriate values from the expected enumerated type so no
> conversion needs to happen then remove the unneeded definitions.
>=20
> Reported-by: Nick Desaulniers <ndesaulniers@google.com>
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
> ---

Applied to for-next

Thanks,
Jason

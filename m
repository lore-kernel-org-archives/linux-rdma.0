From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH] [v4.14.y] infiniband: fix race condition between
 infiniband mlx4, mlx5  driver and core dumping
Date: Mon, 10 Jun 2019 16:05:27 +0000
Message-ID: <20190610160521.GJ18446@mellanox.com>
References: <1560199937-23476-1-git-send-email-akaher@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1560199937-23476-1-git-send-email-akaher@vmware.com>
Content-Language: en-US
Content-ID: <ACA6821CDC8397409049C57892C1C405@eurprd05.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ajay Kaher <akaher@vmware.com>
Cc: "aarcange@redhat.com" <aarcange@redhat.com>, "jannh@google.com" <jannh@google.com>, "oleg@redhat.com" <oleg@redhat.com>, "peterx@redhat.com" <peterx@redhat.com>, "rppt@linux.ibm.com" <rppt@linux.ibm.com>, "mhocko@suse.com" <mhocko@suse.com>, Yishai Hadas <yishaih@mellanox.com>, "dledford@redhat.com" <dledford@redhat.com>, "sean.hefty@intel.com" <sean.hefty@intel.com>, "hal.rosenstock@gmail.com" <hal.rosenstock@gmail.com>, Matan Barak <matanb@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "srivatsab@vmware.com" <srivatsab@vmware.com>, "amakhalov@vmware.com" <amakhalov@vmware.com>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jun 11, 2019 at 02:22:17AM +0530, Ajay Kaher wrote:
> This patch is the extension of following upstream commit to fix
> the race condition between get_task_mm() and core dumping
> for IB->mlx4 and IB->mlx5 drivers:
>=20
> commit 04f5866e41fb ("coredump: fix race condition between
> mmget_not_zero()/get_task_mm() and core dumping")'
>=20
> Thanks to Jason for pointing this.
>=20
> Signed-off-by: Ajay Kaher <akaher@vmware.com>
> ---
>  drivers/infiniband/hw/mlx4/main.c | 4 +++-
>  drivers/infiniband/hw/mlx5/main.c | 3 +++
>  2 files changed, 6 insertions(+), 1 deletion(-)

Acked-by: Jason Gunthorpe <jgg@mellanox.com>

Jason

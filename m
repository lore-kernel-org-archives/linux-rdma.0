From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: [PATCH v4 2/3][v4.9.y] coredump: fix race condition between
 mmget_not_zero()/get_task_mm() and core dumping
Date: Mon, 24 Jun 2019 13:12:30 +0000
Message-ID: <20190624131226.GA7418@mellanox.com>
References: <1561410186-3919-1-git-send-email-akaher@vmware.com>
 <1561410186-3919-2-git-send-email-akaher@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1561410186-3919-2-git-send-email-akaher@vmware.com>
Content-Language: en-US
Content-ID: <626B17CC09D07E449465C19358AB7DB5@eurprd05.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
To: Ajay Kaher <akaher@vmware.com>
Cc: "aarcange@redhat.com" <aarcange@redhat.com>, "jannh@google.com" <jannh@google.com>, "oleg@redhat.com" <oleg@redhat.com>, "peterx@redhat.com" <peterx@redhat.com>, "rppt@linux.ibm.com" <rppt@linux.ibm.com>, "mhocko@suse.com" <mhocko@suse.com>, "jglisse@redhat.com" <jglisse@redhat.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "mike.kravetz@oracle.com" <mike.kravetz@oracle.com>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "riandrews@android.com" <riandrews@android.com>, "arve@android.com" <arve@android.com>, Yishai Hadas <yishaih@mellanox.com>, "dledford@redhat.com" <dledford@redhat.com>, "sean.hefty@intel.com" <sean.hefty@intel.com>, "hal.rosenstock@gmail.com" <hal.rosenstock@gmail.com>, Matan Barak <matanb@mellanox.com>, Leon
List-Id: linux-rdma@vger.kernel.org

On Tue, Jun 25, 2019 at 02:33:04AM +0530, Ajay Kaher wrote:
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

Looks OK

Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>

Thanks
Jason

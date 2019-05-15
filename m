From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: undefined reference to `__aeabi_uldivmod' after 25c13324d03d
 ("IB/mlx5: Add steering SW ICM device memory type")
Date: Wed, 15 May 2019 00:34:00 +0000
Message-ID: <20190515003355.GB14522@ziepe.ca>
References: <20190514194510.GA15465@archlinux-i9>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190514194510.GA15465@archlinux-i9>
Content-Language: en-US
Content-ID: <3F636368DFC389429E2F9FABF9C45786@eurprd05.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nathan Chancellor <natechancellor@gmail.com>
Cc: Ariel Levkovich <lariel@mellanox.com>, Eli Cohen <eli@mellanox.com>, Mark Bloch <markb@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, Doug Ledford <dledford@redhat.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, May 14, 2019 at 12:45:10PM -0700, Nathan Chancellor wrote:
> DIV_ROUND_UP is u64 / u32 in this case. I think DIV_ROUND_UP_ULL is
> needed but I am not sure if that has any unintended side effects so I
> didn't want to send a patch.

Hmm. Most likely those u64 length's should really be size_t.=20

Ariel?

Jason

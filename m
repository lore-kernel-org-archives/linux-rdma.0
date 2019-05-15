From: Leon Romanovsky <leonro@mellanox.com>
Subject: Re: undefined reference to `__aeabi_uldivmod' after 25c13324d03d
 ("IB/mlx5: Add steering SW ICM device memory type")
Date: Wed, 15 May 2019 05:04:29 +0000
Message-ID: <20190515050427.GD5225@mtr-leonro.mtl.com>
References: <20190514194510.GA15465@archlinux-i9>
 <20190515003355.GB14522@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190515003355.GB14522@ziepe.ca>
Content-Language: en-US
Content-ID: <EBC5629F291FC84888414FB7AA42AC27@eurprd05.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@mellanox.com>
Cc: Nathan Chancellor <natechancellor@gmail.com>, Ariel Levkovich <lariel@mellanox.com>, Eli Cohen <eli@mellanox.com>, Mark Bloch <markb@mellanox.com>, Doug Ledford <dledford@redhat.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, May 15, 2019 at 12:34:00AM +0000, Jason Gunthorpe wrote:
> On Tue, May 14, 2019 at 12:45:10PM -0700, Nathan Chancellor wrote:
> > DIV_ROUND_UP is u64 / u32 in this case. I think DIV_ROUND_UP_ULL is
> > needed but I am not sure if that has any unintended side effects so I
> > didn't want to send a patch.
>
> Hmm. Most likely those u64 length's should really be size_t.

Indeed, it should be size_t.

>
> Ariel?
>
> Jason

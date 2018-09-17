From: Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: [PATCH rdma-next 00/24] Extend DEVX functionality
Date: Mon, 17 Sep 2018 23:13:55 +0300
Message-ID: <CAJ3xEMiXhawjV2_MH9CpbONP=HeT6sZZ+pCB2N_Pjd5nq9huEw@mail.gmail.com>
References: <20180917110418.18937-1-leon@kernel.org> <20180917193426.GR3661@mtr-leonro.mtl.com>
 <CAJ3xEMiTG4103+NO1d80n4fyF2BQTFOk9URBFkRG1EopU6vCaA@mail.gmail.com> <20180917200702.GT3661@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180917200702.GT3661@mtr-leonro.mtl.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>
Cc: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Sep 17, 2018 at 11:07 PM, Leon Romanovsky <leonro@mellanox.com> wrote:
> On Mon, Sep 17, 2018 at 10:51:29PM +0300, Or Gerlitz wrote:
>> On Mon, Sep 17, 2018 at 10:34 PM, Leon Romanovsky <leonro@mellanox.com> wrote:
>> > On Mon, Sep 17, 2018 at 02:03:53PM +0300, Leon Romanovsky wrote:
>> >> From: Leon Romanovsky <leonro@mellanox.com>
>> >>
>> >> From Yishai,
>> >>
>> >> This series comes to enable the DEVX functionality in some wider scope,
>> >> specifically,
>> >> - It enables using kernel objects that were created by the verbs
>> >>   API in the DEVX flow.
>> >> - It enables white list commands without DEVX user context.
>> >> - It enables the IB link layer under CAP_NET_RAW capabilities.
>> >> - It exposes the PRM handles for RAW QP (i.e. TIRN, TISN, RQN, SQN)
>> >>   to be used later on directly by the DEVX interface.
>> >>
>> >> In General,
>> >> Each object that is created/destroyed/modified via verbs will be stamped
>> >> with a UID based on its user context. This is already done for DEVX objects
>> >> commands.
>> >>
>> >> This will enable the firmware to enforce the usage of kernel objects
>> >> from the DEVX flow by validating that the same UID is used and the resources are
>> >> really related to the same user.
>> >>
>> >> For example in case a CQ was created with verbs it will be stamped with
>> >> UID and once will be pointed by a DEVX create QP command the firmware will
>> >> validate that the input CQN really belongs to the UID which issues the create QP
>> >> command.
>> >>
>> >> As of the above, all the PRM objects (except of the public ones which
>> >> are managed by the kernel e.g. FLOW, etc.) will have a UID upon their
>> >> create/modify/destroy commands. The detection of UMEM / physical
>> >> addressed in the relevant commands will be done by firmware according to a 'umem
>> >> valid bit' as the UID may be used in both cases.
>> >>
>> >> The series also enables white list commands which don't require a
>> >> specific DEVX context, instead of this a device UID is used so that
>> >> the firmware will mask un-privileged functionality. The IB link layer
>> >> is also enabled once CAP_NET_RAW permission exists.
>> >>
>> >> To enable using the RAW QP underlay objects (e.g. TIRN, RQN, etc.) later
>> >> on by DEVX commands the UHW output for this case was extended to return this
>> >> data when a DEVX context is used.
>> >>
>> >> Thanks
>> >>
>> >> Leon Romanovsky (1):
>> >>   net/mlx5: Update mlx5_ifc with DEVX UID bits
>> >>
>> >> Yishai Hadas (24):
>> >>   net/mlx5: Set uid as part of CQ commands
>> >>   net/mlx5: Set uid as part of QP commands
>> >>   net/mlx5: Set uid as part of RQ commands
>> >>   net/mlx5: Set uid as part of SQ commands
>> >>   net/mlx5: Set uid as part of SRQ commands
>> >>   net/mlx5: Set uid as part of DCT commands
>> >
>> > Hi Doug and Jason,
>> >
>> > Do you want me to resend 7 patches above in one series and other patches
>> > in another series just to be below 15 patches limit? Please be aware
>> > that those patches above are going to mlx5-next and not to
>> > net-next/rdma-next.
>> >
>> > No rebase, no code change, no much meaning too, but it is your call.
>>
>> how about yes! for stop shitting on Dave Miller?
>
> Or, are you ok?
>
> This series is not relevant to Dave Miller and he didn't even listed in CC or TO.

correct, but Dave asked MLNX/Saeed to do X, you should respect X when you post
to the community Dave is maintaining, even if he didn't ask you, not
doing so hurts
our positioning with Dave.


>
> I still prefer to hear answer from respective maintainer to whom this
> series was sent.

Your maintainer asked you to do X, just do it, once and for all

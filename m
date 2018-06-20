From: Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: cx4 sriov problem in stable 4.14.47
Date: Wed, 20 Jun 2018 18:47:33 +0300
Message-ID: <CAJ3xEMhBueWttc8d_yi+rBCXgrsVUJQci9wEB-KP=OJ6ixur0Q@mail.gmail.com>
References: <1ae538be-2699-e0cc-adef-2235489472ab@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1ae538be-2699-e0cc-adef-2235489472ab@grimberg.me>
Sender: stable-owner@vger.kernel.org
To: Sagi Grimberg <sagi@grimberg.me>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Leon Romanovsky <leon@kernel.org>, Saeed Mahameed <saeedm@mellanox.com>, Stable <stable@vger.kernel.org>, Roy Shterman <roys@lightbitslabs.com>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 20, 2018 at 1:40 PM, Sagi Grimberg <sagi@grimberg.me> wrote:
> Hey folks,
>
> Seems that CX4 (Ethernet) sriov ports probe with link down in the latest
> stable 4.14 kernel. I upgrated firmware but with no luck :(
>
> Has anyone seen this issue as well?
>
> Kernel: stable 4.14.47
> Firmware: 12.22.1002
> psid: MT_2140110033
>
> sysfs port state is DOWN and

do you mean ip link on the pf shows link state down for the vf?

> phys port state is Disabled.

where do you see it is disabled and what happens if you take the PF
netdev link up?

We had a bug fix there recently [1] -- but it was for the switchdev
mode not the legacy mode, are you
using the switchdev mode? (if not, I recommend going there, the legacy
mode is not going to last long)

Also, FWIW the whole ethernet sriov upstreaming is done in netdev, not rdma

Or.


[1] 84c9c8f net/mlx5e: Don't override vport admin link state in switchdev mode

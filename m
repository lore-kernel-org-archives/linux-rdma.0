From: Or Gerlitz <gerlitz.or@gmail.com>
Subject: Re: cx4 sriov problem in stable 4.14.47
Date: Thu, 21 Jun 2018 10:05:13 +0300
Message-ID: <CAJ3xEMig1qSxcLdnaLkaOoSFgr2zM=iDaWFq6ELO4MJ1mofd2w@mail.gmail.com>
References: <1ae538be-2699-e0cc-adef-2235489472ab@grimberg.me>
 <CAJ3xEMhBueWttc8d_yi+rBCXgrsVUJQci9wEB-KP=OJ6ixur0Q@mail.gmail.com> <c74ce55f-e793-1bb2-fe4d-bbd815be4ab2@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <c74ce55f-e793-1bb2-fe4d-bbd815be4ab2@grimberg.me>
Sender: stable-owner@vger.kernel.org
To: Sagi Grimberg <sagi@grimberg.me>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Leon Romanovsky <leon@kernel.org>, Saeed Mahameed <saeedm@mellanox.com>, Stable <stable@vger.kernel.org>, Roy Shterman <roys@lightbitslabs.com>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 20, 2018 at 8:06 PM, Sagi Grimberg <sagi@grimberg.me> wrote:

> I'll try switchdev mode.

in switchdev mode you have the take the host side VF representor netdev up
such that the VF vport link will be enabled. Also in switchdev mode you need
some host side controller SW to program the e-switch forwarding rule.
You can make the experiment just to see if the link problem persists.

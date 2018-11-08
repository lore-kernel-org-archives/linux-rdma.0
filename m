From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
Subject: Re: [PATCH net-next 0/4] Remove VLAN_TAG_PRESENT from drivers
Date: Thu, 8 Nov 2018 23:11:45 +0100
Message-ID: <20181108221145.GA11538@qmqm.qmqm.pl>
References: <cover.1541698641.git.mirq-linux@rere.qmqm.pl>
 <20181108185005.GR3695@mtr-leonro.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181108185005.GR3695@mtr-leonro.mtl.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>
Cc: netdev@vger.kernel.org, Claudiu Manoil <claudiu.manoil@nxp.com>, Faisal Latif <faisal.latif@intel.com>, Pravin B Shelar <pshelar@ovn.org>, Shiraz Saleem <shiraz.saleem@intel.com>, dev@openvswitch.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 08, 2018 at 08:50:05PM +0200, Leon Romanovsky wrote:
> On Thu, Nov 08, 2018 at 06:44:46PM +0100, Micha³ Miros³aw wrote:
> > This series removes VLAN_TAG_PRESENT use from network drivers in
> > preparation to removing its special meaning.
> Can you please give an extra explanation why it is removed?
> Such series come out-of-blue, for people who are not following
> netdev mailing list closely (drivers/infiniband/*).

This is one of the steps to remove VLAN_TAG_PRESENT overlap with CFI/DEI
bit of VLAN tag. Currently this overlap causes Linux kernel to always
clear CFI/DEI in packets.

There is skb_vlan_tag_present() that drivers should use to check if
the tag in skb is valid.

Best Regards,
Micha³ Miros³aw

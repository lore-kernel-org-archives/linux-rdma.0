From: Shiraz Saleem <shiraz.saleem@intel.com>
Subject: Re: [PATCH net-next 0/4] Remove VLAN_TAG_PRESENT from drivers
Date: Fri, 9 Nov 2018 15:58:37 -0600
Message-ID: <20181109215837.GA11180@ssaleem-MOBL4.amr.corp.intel.com>
References: <cover.1541698641.git.mirq-linux@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cover.1541698641.git.mirq-linux@rere.qmqm.pl>
Sender: netdev-owner@vger.kernel.org
To: =?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>
Cc: netdev@vger.kernel.org, Claudiu Manoil <claudiu.manoil@nxp.com>, Faisal Latif <faisal.latif@intel.com>, Pravin B Shelar <pshelar@ovn.org>, dev@openvswitch.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 08, 2018 at 06:44:46PM +0100, Michał Mirosław wrote:
> This series removes VLAN_TAG_PRESENT use from network drivers in
> preparation to removing its special meaning.
> 
> Michał Mirosław (4):
>   i40iw: remove use of VLAN_TAG_PRESENT
>   cnic: remove use of VLAN_TAG_PRESENT
>   gianfar: remove use of VLAN_TAG_PRESENT
>   OVS: remove use of VLAN_TAG_PRESENT
> 
>  drivers/infiniband/hw/i40iw/i40iw_cm.c        |  8 +++----
>

i40iw bit looks fine. Thanks!

Acked-by: Shiraz Saleem <shiraz.saleem@intel.com>

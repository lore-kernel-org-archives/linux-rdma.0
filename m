From: David Ahern <dsa-qUQiAmfTcIp+XZJcv9eMoEEOCMrvLtNR@public.gmane.org>
Subject: Re: [PATCH net-next 1/8] net: core: dev: Add extack
 argument to dev_open()
Date: Wed, 5 Dec 2018 09:32:20 -0700
Message-ID: <7fae4abf-6c99-fdcc-4f96-b663062788ce@cumulusnetworks.com>
References: <cover.1544006963.git.petrm@mellanox.com>
	<58aee6a3c1ecba75a780cc303e5fd6e4d92059be.1544006963.git.petrm@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ovs-dev-bounces-yBygre7rU0TnMu66kgdUjQ@public.gmane.org>
In-Reply-To: <58aee6a3c1ecba75a780cc303e5fd6e4d92059be.1544006963.git.petrm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
List-Unsubscribe: <https://mail.openvswitch.org/mailman/options/ovs-dev>,
	<mailto:ovs-dev-request-yBygre7rU0TnMu66kgdUjQ@public.gmane.org?subject=unsubscribe>
List-Archive: <http://mail.openvswitch.org/pipermail/ovs-dev/>
List-Post: <mailto:ovs-dev-yBygre7rU0TnMu66kgdUjQ@public.gmane.org>
List-Help: <mailto:ovs-dev-request-yBygre7rU0TnMu66kgdUjQ@public.gmane.org?subject=help>
List-Subscribe: <https://mail.openvswitch.org/mailman/listinfo/ovs-dev>,
	<mailto:ovs-dev-request-yBygre7rU0TnMu66kgdUjQ@public.gmane.org?subject=subscribe>
Sender: ovs-dev-bounces-yBygre7rU0TnMu66kgdUjQ@public.gmane.org
Errors-To: ovs-dev-bounces-yBygre7rU0TnMu66kgdUjQ@public.gmane.org
To: Petr Machata <petrm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-stm32-XDFAJ8BFU24N7RejjzZ/Li2xQDfSxrLKVpNB7YpNyf8@public.gmane.org" <linux-stm32-XDFAJ8BFU24N7RejjzZ/Li2xQDfSxrLKVpNB7YpNyf8@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "devel-tBiZLqfeLfOHmIFyCCdPziST3g8Odh+X@public.gmane.org" <devel-tBiZLqfeLfOHmIFyCCdPziST3g8Odh+X@public.gmane.org>, "linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org" <devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org>, "sparmaintainer-GLv8BlqOqDDQT0dZR+AlfA@public.gmane.org" <sparmaintainer-GLv8BlqOqDDQT0dZR+AlfA@public.gmane.org>, "linux-bluetooth-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-bluetooth-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dev-yBygre7rU0TnMu66kgdUjQ@public.gmane.org" <dev-yBygre7rU0TnMu66kgdUjQ@public.gmane.org>, "linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "ioana.ciornei-3arQi8VN3Tc@public.gmane.org" <ioana.ciornei-3arQi8VN3Tc@public.gmane.org>, "heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org" <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, "_govind-KK0ffGbhmjU@public.gmane.org" <_govind-KK0ffGbhmjU@public.gmane.org>, "shrijeet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <shrijeet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "ecree-s/n/eUQHGBpZroRs9YW3xA@public.gmane.org" <ecree-s/n/eUQHGBpZroRs9YW3xA@public.gmane.org>, kys <kys-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, "shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "andy-QlMahl40kYEqcZcGjlUOXw@public.gmane.org" <andy-QlMahl40kYEqcZcGjlUOXw@public.gmane.org>, "johan.hedberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <johan.hedberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "sthemmin-0li6OtcxBFHby3iVrkZq2A@public.gmane.org" <sthemmin-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, "ruxandra.radulescu-3arQi8VN3Tc@public.gmane.org" <ruxandra.radulescu-3arQi8VN3Tc@public.gmane.org>, "jwi-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org" <jwi-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, "jgg-uk2M96/98Pc@public.gmane.org" <jgg-uk2M96/98Pc@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "joabreu-HKixBCOQz3hWk0Htik3J/w@public.gmane.org" <joabreu-HKixBCOQz3hWk0Htik3J/w@public.gmane.org>, "vfalico-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <vfalico-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "kuznet-v/Mj1YrvjDBInbfyfbPRSQ@public.gmane.org" <kuznet-v/Mj1YrvjDBInbfyfbPRSQ@public.gmane.org>, "david.kershner-GLv8BlqOqDDQT0dZR+AlfA@public.gmane.org" <david.kershner-GLv8BlqOqDDQT0dZR+AlfA@public.gmane.org>, "marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org" <marcel-kz+m5ild9QBg9hUCZPvPmw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/5/18 3:51 AM, Petr Machata wrote:
> In order to pass extack together with NETDEV_PRE_UP notifications, it's
> necessary to route the extack to __dev_open() from diverse (possibly
> indirect) callers. One prominent API through which the notification is
> invoked is dev_open().
> 
> Therefore extend dev_open() with and extra extack argument and update
> all users. Most of the calls end up just encoding NULL, but bond and
> team drivers have the extack readily available.
> 
> Signed-off-by: Petr Machata <petrm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Acked-by: Jiri Pirko <jiri-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Ido Schimmel <idosch-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  drivers/net/bonding/bond_main.c                     | 2 +-
>  drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c | 2 +-
>  drivers/net/ethernet/cisco/enic/enic_ethtool.c      | 2 +-
>  drivers/net/ethernet/hisilicon/hns/hns_ethtool.c    | 2 +-
>  drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c  | 2 +-
>  drivers/net/ethernet/sfc/ethtool.c                  | 2 +-
>  drivers/net/ethernet/sfc/falcon/ethtool.c           | 2 +-
>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c   | 2 +-
>  drivers/net/hyperv/netvsc_drv.c                     | 4 ++--
>  drivers/net/net_failover.c                          | 8 ++++----
>  drivers/net/team/team.c                             | 2 +-
>  drivers/net/wireless/intersil/hostap/hostap_main.c  | 2 +-
>  drivers/s390/net/qeth_l2_main.c                     | 2 +-
>  drivers/s390/net/qeth_l3_main.c                     | 2 +-
>  drivers/staging/fsl-dpaa2/ethsw/ethsw.c             | 2 +-
>  drivers/staging/unisys/visornic/visornic_main.c     | 2 +-
>  include/linux/netdevice.h                           | 2 +-
>  net/bluetooth/6lowpan.c                             | 2 +-
>  net/core/dev.c                                      | 5 +++--
>  net/core/netpoll.c                                  | 2 +-
>  net/ipv4/ipmr.c                                     | 4 ++--
>  net/ipv6/addrconf.c                                 | 2 +-
>  net/ipv6/ip6mr.c                                    | 2 +-
>  23 files changed, 30 insertions(+), 29 deletions(-)

Reviewed-by: David Ahern <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

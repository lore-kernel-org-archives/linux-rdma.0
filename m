From: David Ahern <dsa@cumulusnetworks.com>
Subject: Re: [PATCH net-next 6/8] net: core: dev: Add
 call_netdevice_notifiers_extack()
Date: Wed, 5 Dec 2018 09:43:10 -0700
Message-ID: <bb24b41f-d77d-f628-8923-25552940dfe3@cumulusnetworks.com>
References: <cover.1544006963.git.petrm@mellanox.com>
 <884365ab9f3d146a2b31a6d66c34de78135bc598.1544006963.git.petrm@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <884365ab9f3d146a2b31a6d66c34de78135bc598.1544006963.git.petrm@mellanox.com>
Content-Language: en-US
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Petr Machata <petrm@mellanox.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-stm32@st-md-mailman.stormreply.com" <linux-stm32@st-md-mailman.stormreply.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>, "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>, "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>, "sparmaintainer@unisys.com" <sparmaintainer@unisys.com>, "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>, "dev@openvswitch.org" <dev@openvswitch.org>, "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>
Cc: "ioana.ciornei@nxp.com" <ioana.ciornei@nxp.com>, "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>, "_govind@gmx.com" <_govind@gmx.com>, "shrijeet@gmail.com" <shrijeet@gmail.com>, "ecree@solarflare.com" <ecree@solarflare.com>, "shuah@kernel.org" <shuah@kernel.org>, "andy@greyhouse.net" <andy@greyhouse.net>, "johan.hedberg@gmail.com" <johan.hedberg@gmail.com>, "sthemmin@microsoft.com" <sthemmin@microsoft.com>, "jwi@linux.ibm.com" <jwi@linux.ibm.com>, "pshelar@ovn.org" <pshelar@ovn.org>, "jgg@ziepe.ca" <jgg@ziepe.ca>, "dledford@redhat.com" <dledford@redhat.com>, "joabreu@synopsys.com" <joabreu@synopsys.com>, "vfalico@gmail.com" <vfalico@gmail.com>, "kuznet@ms2.inr.ac.ru" <kuznet@ms2.inr.ac.ru>, "yisen.zhuang@huawei.com" <yisen.zhuang@huawei.com>, "marcel@holtmann.org" <marcel@holtmann.org>, "pkaustub@cisco.com" <pkaustub@cisco.com>, "jiri@resnulli.us" <jiri@resnul>
List-Id: linux-rdma@vger.kernel.org

On 12/5/18 3:51 AM, Petr Machata wrote:
> In order to propagate extack through NETDEV_PRE_UP, add a new function
> call_netdevice_notifiers_extack() that primes the extack field of the
> notifier info. Convert call_netdevice_notifiers() to a simple wrapper
> around the new function that passes NULL for extack.
> 
> Signed-off-by: Petr Machata <petrm@mellanox.com>
> Acked-by: Jiri Pirko <jiri@mellanox.com>
> Reviewed-by: Ido Schimmel <idosch@mellanox.com>
> ---
>  net/core/dev.c | 21 ++++++++++++++++-----
>  1 file changed, 16 insertions(+), 5 deletions(-)

Reviewed-by: David Ahern <dsahern@gmail.com>

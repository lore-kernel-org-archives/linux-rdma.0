From: David Ahern <dsa@cumulusnetworks.com>
Subject: Re: [PATCH net-next 7/8] net: core: dev: Attach extack to
 NETDEV_PRE_UP
Date: Wed, 5 Dec 2018 09:44:37 -0700
Message-ID: <36cfdf99-3caf-dd8e-ac65-da791e88d7f3@cumulusnetworks.com>
References: <cover.1544006963.git.petrm@mellanox.com>
 <a58682d5b87093bb259748de4ff2a7276c69041c.1544006963.git.petrm@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <a58682d5b87093bb259748de4ff2a7276c69041c.1544006963.git.petrm@mellanox.com>
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

On 12/5/18 3:52 AM, Petr Machata wrote:
> Drivers may need to validate configuration of a device that's about to
> be upped. Should the validation fail, there's currently no way to
> communicate details of the failure to the user, beyond an error number.
> 
> To mend that, change __dev_open() to take an extack argument and pass it
> from __dev_change_flags() and dev_open(), where it was propagated in the
> previous patches.
> 
> Change __dev_open() to call call_netdevice_notifiers_extack() so that
> the passed-in extack is attached to the NETDEV_PRE_UP notifier.
> 
> Signed-off-by: Petr Machata <petrm@mellanox.com>
> Acked-by: Jiri Pirko <jiri@mellanox.com>
> Reviewed-by: Ido Schimmel <idosch@mellanox.com>
> ---
>  net/core/dev.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>

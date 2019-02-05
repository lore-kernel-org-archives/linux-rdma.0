From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH 12/12] net: Get rid of SWITCHDEV_ATTR_ID_PORT_PARENT_ID
Date: Tue, 5 Feb 2019 17:23:50 +0800
Message-ID: <201902051735.d1Ex4lJu%fengguang.wu@intel.com>
References: <20190204233633.20421-13-f.fainelli@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="FL5UXtIhxfXey3p5"
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <20190204233633.20421-13-f.fainelli@gmail.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
Cc: John Hurley <john.hurley@netronome.com>, Alexandre Belloni <alexandre.belloni@bootlin.com>, Jakub Kicinski <jakub.kicinski@netronome.com>, Andrew Lunn <andrew@lunn.ch>, "open list:NETRONOME ETHERNET DRIVERS" <oss-drivers@netronome.com>, Edwin Peer <edwin.peer@netronome.com>, Eric Dumazet <edumazet@google.com>, Ioana Ciornei <ioana.ciornei@nxp.com>, Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>, Ivan Vecera <ivecera@redhat.com>, Florian Fainelli <f.fainelli@gmail.com>, Amritha Nambiar <amritha.nambiar@intel.com>, "David S. Miller" <davem@davemloft.net>, "open list:MELLANOX MLX5 core VPI driver" <linux-rdma@vger.kernel.org>, "moderated list:ETHERNET BRIDGE" <bridge@lists.linux-foundation.org>, Saeed Mahameed <saeedm@mellanox.com>, Dirk van der Merwe <dirk.vandermerwe@netronome.com>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Vivien Didelot <vivien.didelot@g>
List-Id: linux-rdma@vger.kernel.org


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Florian,

I love your patch! Yet something to improve:

[auto build test ERROR on net/master]
[also build test ERROR on next-20190205]
[cannot apply to v5.0-rc4]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Florian-Fainelli/net-Introduce-ndo_get_port_parent_id/20190205-163356
config: i386-randconfig-x002-201905 (attached as .config)
compiler: gcc-8 (Debian 8.2.0-14) 8.2.0
reproduce:
        # save the attached .config to linux build tree
        make ARCH=i386 

All errors (new ones prefixed by >>):

   net//ipv4/ipmr.c: In function 'vif_add':
>> net//ipv4/ipmr.c:920:2: error: 'attr' undeclared (first use in this function); did you mean 'xattr'?
     attr.orig_dev = dev;
     ^~~~
     xattr
   net//ipv4/ipmr.c:920:2: note: each undeclared identifier is reported only once for each function it appears in

vim +920 net//ipv4/ipmr.c

^1da177e4 Linus Torvalds      2005-04-16  835  
0c12295a7 Patrick McHardy     2010-04-13  836  static int vif_add(struct net *net, struct mr_table *mrt,
0c12295a7 Patrick McHardy     2010-04-13  837  		   struct vifctl *vifc, int mrtsock)
^1da177e4 Linus Torvalds      2005-04-16  838  {
ca3b84139 Florian Fainelli    2019-02-04  839  	struct netdev_phys_item_id ppid = { };
f95ad5036 Florian Fainelli    2019-02-04  840  	const struct net_device_ops *ops;
^1da177e4 Linus Torvalds      2005-04-16  841  	int vifi = vifc->vifc_vifi;
0c12295a7 Patrick McHardy     2010-04-13  842  	struct vif_device *v = &mrt->vif_table[vifi];
^1da177e4 Linus Torvalds      2005-04-16  843  	struct net_device *dev;
^1da177e4 Linus Torvalds      2005-04-16  844  	struct in_device *in_dev;
d607032db Wang Chen           2008-07-14  845  	int err;
^1da177e4 Linus Torvalds      2005-04-16  846  
^1da177e4 Linus Torvalds      2005-04-16  847  	/* Is vif busy ? */
0c12295a7 Patrick McHardy     2010-04-13  848  	if (VIF_EXISTS(mrt, vifi))
^1da177e4 Linus Torvalds      2005-04-16  849  		return -EADDRINUSE;
^1da177e4 Linus Torvalds      2005-04-16  850  
^1da177e4 Linus Torvalds      2005-04-16  851  	switch (vifc->vifc_flags) {
^1da177e4 Linus Torvalds      2005-04-16  852  	case VIFF_REGISTER:
1973a4ea6 Nikolay Aleksandrov 2015-11-26  853  		if (!ipmr_pimsm_enabled())
c316c629f Nikolay Aleksandrov 2015-11-21  854  			return -EINVAL;
c316c629f Nikolay Aleksandrov 2015-11-21  855  		/* Special Purpose VIF in PIM
^1da177e4 Linus Torvalds      2005-04-16  856  		 * All the packets will be sent to the daemon
^1da177e4 Linus Torvalds      2005-04-16  857  		 */
0c12295a7 Patrick McHardy     2010-04-13  858  		if (mrt->mroute_reg_vif_num >= 0)
^1da177e4 Linus Torvalds      2005-04-16  859  			return -EADDRINUSE;
f0ad0860d Patrick McHardy     2010-04-13  860  		dev = ipmr_reg_vif(net, mrt);
^1da177e4 Linus Torvalds      2005-04-16  861  		if (!dev)
^1da177e4 Linus Torvalds      2005-04-16  862  			return -ENOBUFS;
d607032db Wang Chen           2008-07-14  863  		err = dev_set_allmulti(dev, 1);
d607032db Wang Chen           2008-07-14  864  		if (err) {
d607032db Wang Chen           2008-07-14  865  			unregister_netdevice(dev);
7dc00c82c Wang Chen           2008-07-14  866  			dev_put(dev);
d607032db Wang Chen           2008-07-14  867  			return err;
d607032db Wang Chen           2008-07-14  868  		}
^1da177e4 Linus Torvalds      2005-04-16  869  		break;
^1da177e4 Linus Torvalds      2005-04-16  870  	case VIFF_TUNNEL:
4feb88e5c Benjamin Thery      2009-01-22  871  		dev = ipmr_new_tunnel(net, vifc);
^1da177e4 Linus Torvalds      2005-04-16  872  		if (!dev)
^1da177e4 Linus Torvalds      2005-04-16  873  			return -ENOBUFS;
d607032db Wang Chen           2008-07-14  874  		err = dev_set_allmulti(dev, 1);
d607032db Wang Chen           2008-07-14  875  		if (err) {
d607032db Wang Chen           2008-07-14  876  			ipmr_del_tunnel(dev, vifc);
7dc00c82c Wang Chen           2008-07-14  877  			dev_put(dev);
d607032db Wang Chen           2008-07-14  878  			return err;
d607032db Wang Chen           2008-07-14  879  		}
^1da177e4 Linus Torvalds      2005-04-16  880  		break;
ee5e81f00 Ilia K              2009-09-16  881  	case VIFF_USE_IFINDEX:
^1da177e4 Linus Torvalds      2005-04-16  882  	case 0:
ee5e81f00 Ilia K              2009-09-16  883  		if (vifc->vifc_flags == VIFF_USE_IFINDEX) {
ee5e81f00 Ilia K              2009-09-16  884  			dev = dev_get_by_index(net, vifc->vifc_lcl_ifindex);
51456b291 Ian Morris          2015-04-03  885  			if (dev && !__in_dev_get_rtnl(dev)) {
ee5e81f00 Ilia K              2009-09-16  886  				dev_put(dev);
ee5e81f00 Ilia K              2009-09-16  887  				return -EADDRNOTAVAIL;
ee5e81f00 Ilia K              2009-09-16  888  			}
a8cb16dd9 Eric Dumazet        2010-10-01  889  		} else {
4feb88e5c Benjamin Thery      2009-01-22  890  			dev = ip_dev_find(net, vifc->vifc_lcl_addr.s_addr);
a8cb16dd9 Eric Dumazet        2010-10-01  891  		}
^1da177e4 Linus Torvalds      2005-04-16  892  		if (!dev)
^1da177e4 Linus Torvalds      2005-04-16  893  			return -EADDRNOTAVAIL;
d607032db Wang Chen           2008-07-14  894  		err = dev_set_allmulti(dev, 1);
7dc00c82c Wang Chen           2008-07-14  895  		if (err) {
7dc00c82c Wang Chen           2008-07-14  896  			dev_put(dev);
d607032db Wang Chen           2008-07-14  897  			return err;
7dc00c82c Wang Chen           2008-07-14  898  		}
^1da177e4 Linus Torvalds      2005-04-16  899  		break;
^1da177e4 Linus Torvalds      2005-04-16  900  	default:
^1da177e4 Linus Torvalds      2005-04-16  901  		return -EINVAL;
^1da177e4 Linus Torvalds      2005-04-16  902  	}
^1da177e4 Linus Torvalds      2005-04-16  903  
a8cb16dd9 Eric Dumazet        2010-10-01  904  	in_dev = __in_dev_get_rtnl(dev);
a8cb16dd9 Eric Dumazet        2010-10-01  905  	if (!in_dev) {
d0490cfdf Dan Carpenter       2009-11-11  906  		dev_put(dev);
^1da177e4 Linus Torvalds      2005-04-16  907  		return -EADDRNOTAVAIL;
d0490cfdf Dan Carpenter       2009-11-11  908  	}
42f811b8b Herbert Xu          2007-06-04  909  	IPV4_DEVCONF(in_dev->cnf, MC_FORWARDING)++;
3b0228656 David Ahern         2017-03-28  910  	inet_netconf_notify_devconf(net, RTM_NEWNETCONF, NETCONFA_MC_FORWARDING,
3b0228656 David Ahern         2017-03-28  911  				    dev->ifindex, &in_dev->cnf);
^1da177e4 Linus Torvalds      2005-04-16  912  	ip_rt_multicast_event(in_dev);
^1da177e4 Linus Torvalds      2005-04-16  913  
a8cb16dd9 Eric Dumazet        2010-10-01  914  	/* Fill in the VIF structures */
6853f21f7 Yuval Mintz         2018-02-28  915  	vif_device_init(v, dev, vifc->vifc_rate_limit,
6853f21f7 Yuval Mintz         2018-02-28  916  			vifc->vifc_threshold,
6853f21f7 Yuval Mintz         2018-02-28  917  			vifc->vifc_flags | (!mrtsock ? VIFF_STATIC : 0),
6853f21f7 Yuval Mintz         2018-02-28  918  			(VIFF_TUNNEL | VIFF_REGISTER));
a8cb16dd9 Eric Dumazet        2010-10-01  919  
5d8b3e69f Yotam Gigi          2017-10-03 @920  	attr.orig_dev = dev;
f95ad5036 Florian Fainelli    2019-02-04  921  	ops = dev->netdev_ops;
f95ad5036 Florian Fainelli    2019-02-04  922  	if (ops->ndo_get_port_parent_id &&
ca3b84139 Florian Fainelli    2019-02-04  923  	    !ops->ndo_get_port_parent_id(dev, &ppid)) {
ca3b84139 Florian Fainelli    2019-02-04  924  		memcpy(v->dev_parent_id.id, ppid.id, ppid.id_len);
ca3b84139 Florian Fainelli    2019-02-04  925  		v->dev_parent_id.id_len = ppid.id_len;
5d8b3e69f Yotam Gigi          2017-10-03  926  	} else {
5d8b3e69f Yotam Gigi          2017-10-03  927  		v->dev_parent_id.id_len = 0;
5d8b3e69f Yotam Gigi          2017-10-03  928  	}
6853f21f7 Yuval Mintz         2018-02-28  929  
^1da177e4 Linus Torvalds      2005-04-16  930  	v->local = vifc->vifc_lcl_addr.s_addr;
^1da177e4 Linus Torvalds      2005-04-16  931  	v->remote = vifc->vifc_rmt_addr.s_addr;
^1da177e4 Linus Torvalds      2005-04-16  932  
^1da177e4 Linus Torvalds      2005-04-16  933  	/* And finish update writing critical data */
^1da177e4 Linus Torvalds      2005-04-16  934  	write_lock_bh(&mrt_lock);
^1da177e4 Linus Torvalds      2005-04-16  935  	v->dev = dev;
^1da177e4 Linus Torvalds      2005-04-16  936  	if (v->flags & VIFF_REGISTER)
0c12295a7 Patrick McHardy     2010-04-13  937  		mrt->mroute_reg_vif_num = vifi;
0c12295a7 Patrick McHardy     2010-04-13  938  	if (vifi+1 > mrt->maxvif)
0c12295a7 Patrick McHardy     2010-04-13  939  		mrt->maxvif = vifi+1;
^1da177e4 Linus Torvalds      2005-04-16  940  	write_unlock_bh(&mrt_lock);
b362053a7 Yotam Gigi          2017-09-27  941  	call_ipmr_vif_entry_notifiers(net, FIB_EVENT_VIF_ADD, v, vifi, mrt->id);
^1da177e4 Linus Torvalds      2005-04-16  942  	return 0;
^1da177e4 Linus Torvalds      2005-04-16  943  }
^1da177e4 Linus Torvalds      2005-04-16  944  

:::::: The code at line 920 was first introduced by commit
:::::: 5d8b3e69fc5e5ccafc9db1251bb7c78a8622fddd ipv4: ipmr: Add the parent ID field to VIF struct

:::::: TO: Yotam Gigi <yotamg@mellanox.com>
:::::: CC: David S. Miller <davem@davemloft.net>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--FL5UXtIhxfXey3p5
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
devel mailing list
devel@linuxdriverproject.org
http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel

--FL5UXtIhxfXey3p5--

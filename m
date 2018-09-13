From: =?utf-8?Q?H=C3=A5kon_Bugge?= <haakon.bugge@oracle.com>
Subject: mutex and rcu list traversal idiosyncrasy
Date: Thu, 13 Sep 2018 13:55:44 +0200
Message-ID: <E4626316-0683-45DF-9F09-D602FC982E21@oracle.com>
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.1\))
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: faisal.latif@intel.com, shiraz.saleem@intel.com
Cc: OFED mailing list <linux-rdma@vger.kernel.org>, linux-kernel@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, anjali.singhai@intel.com, Shannon Nelson <shannon.nelson@oracle.com>
List-Id: linux-rdma@vger.kernel.org

Hi Faisal,


In commit f27b4746f378 ("i40iw: add connection management code") you =
have in i40iw_add_mqh_6():

rtnl_lock();
for_each_netdev_rcu(...) {
	[]
}
rtnl_unlock();

Shouldn't this read:

rtnl_lock();
for_each_netdev(...) {
	[]
}
rtnl_unlock();

or

rcu_read_lock();
for_each_netdev_rcu(...) {
	[]
}
rcu_read_unlock();


?



Thx, H=C3=A5kon

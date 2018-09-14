From: Shiraz Saleem <shiraz.saleem@intel.com>
Subject: Re: mutex and rcu list traversal idiosyncrasy
Date: Fri, 14 Sep 2018 18:46:31 -0500
Message-ID: <20180914234631.GA20084@ssaleem-MOBL4.amr.corp.intel.com>
References: <E4626316-0683-45DF-9F09-D602FC982E21@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <E4626316-0683-45DF-9F09-D602FC982E21@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: =?iso-8859-1?Q?H=E5kon?= Bugge <haakon.bugge@oracle.com>
Cc: "Latif, Faisal" <faisal.latif@intel.com>, OFED mailing list <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Doug Ledford <dledford@redhat.com>, "Hefty, Sean" <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, "Singhai, Anjali" <anjali.singhai@intel.com>, Shannon Nelson <shannon.nelson@oracle.com>
List-Id: linux-rdma@vger.kernel.org

On Thu, Sep 13, 2018 at 05:55:44AM -0600, Håkon Bugge wrote:
> Hi Faisal,
> 
> 
> In commit f27b4746f378 ("i40iw: add connection management code") you have in i40iw_add_mqh_6():
> 
> rtnl_lock();
> for_each_netdev_rcu(...) {
> 	[]
> }
> rtnl_unlock();
> 
> Shouldn't this read:
> rtnl_lock();
> for_each_netdev(...) {
> 	[]
> }
> rtnl_unlock();
>

Yes.

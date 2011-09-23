From: "Hefty, Sean" <sean.hefty@intel.com>
Subject: Re: ib-diags: compatability issue with ibstat
Date: Fri, 23 Sep 2011 16:15:32 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E676FE@ORSMSX101.amr.corp.intel.com>
References: <1828884A29C6694DAF28B7E6B8A8237316E66F5B@ORSMSX101.amr.corp.intel.com>
	<20110921151349.140d95f6.weiny2@llnl.gov>
	<1828884A29C6694DAF28B7E6B8A8237316E6723E@ORSMSX101.amr.corp.intel.com>
	<20110921153254.06c77ebc.weiny2@llnl.gov>
	<20110921171408.4e4087c8.weiny2@llnl.gov>
	<CAKzyTsyUnwJHu=pp=zvhbQ9qC97EVp1oqtkt_wRK3o8RWB9D-g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ofw-bounces@lists.openfabrics.org>
In-Reply-To: <CAKzyTsyUnwJHu=pp=zvhbQ9qC97EVp1oqtkt_wRK3o8RWB9D-g@mail.gmail.com>
Content-Language: en-US
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/options/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ofw>
List-Post: <mailto:ofw@lists.openfabrics.org>
List-Help: <mailto:ofw-request@lists.openfabrics.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ofw>,
	<mailto:ofw-request@lists.openfabrics.org?subject=subscribe>
Sender: ofw-bounces@lists.openfabrics.org
Errors-To: ofw-bounces@lists.openfabrics.org
To: Hal Rosenstock <hal.rosenstock@gmail.com>, Ira Weiny <weiny2@llnl.gov>
Cc: "linux-rdma (linux-rdma@vger.kernel.org)" <linux-rdma@vger.kernel.org>, "ofw@lists.openfabrics.org" <ofw@lists.openfabrics.org>
List-Id: linux-rdma@vger.kernel.org

> Even if ibv_devinfo is updated to include the additional information,
> do we want to require libibverbs, etc. on any IB management machine
> just for this ? That's not the case today on IB management nodes.

IMO, it's acceptable for ibverbs to be the basic requirement for any IB userspace application.  I think you'll find the ibumad duplicates functionally that ibverbs provides, and that's why windows already has the dependency built in.

- Sean

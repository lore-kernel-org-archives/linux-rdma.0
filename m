From: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Subject: Re: [ceph-users] Help needed porting Ceph to RSockets
Date: Thu, 12 Sep 2013 12:20:03 +0200
Message-ID: <CAJH6TXg94x+jcc=1MQQoQaF5JcGKuxbG_SzLEMt3EVQOrFeNjw@mail.gmail.com>
References: <1828884A29C6694DAF28B7E6B8A8237388CA7C88@ORSMSX109.amr.corp.intel.com>
	<20130910154847.3fb7dd02@doppio>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <ceph-devel-owner@vger.kernel.org>
In-Reply-To: <20130910154847.3fb7dd02@doppio>
Sender: ceph-devel-owner@vger.kernel.org
To: Andreas Bluemle <andreas.bluemle@itxperts.de>
Cc: "Hefty, Sean" <sean.hefty@intel.com>, Matthew Anderson <manderson8787@gmail.com>, "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, "linux-rdma@vger.kernel.org (linux-rdma@vger.kernel.org)" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

2013/9/10 Andreas Bluemle <andreas.bluemle@itxperts.de>:
> Since I have added these workarounds to my version of the librdmacm
> library, I can at least start up ceph using LD_PRELOAD and end up in
> a healthy ceph cluster state.

Have you seen any performance improvement by using LD_PRELOAD with ceph?
Which throughput are you able to archive with rsocket and ceph?

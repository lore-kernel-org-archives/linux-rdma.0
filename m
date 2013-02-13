From: "Hefty, Sean" <sean.hefty@intel.com>
Subject: RE: [PATCH v4 4/9] rdma/cm: Update port reservation to support AF_IB
Date: Wed, 13 Feb 2013 18:37:00 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237368B9A460@ORSMSX101.amr.corp.intel.com>
References: <1358891797-14625-1-git-send-email-sean.hefty@intel.com>
 <1358891797-14625-5-git-send-email-sean.hefty@intel.com>
 <511B7474.3040201@mellanox.com>
 <1828884A29C6694DAF28B7E6B8A8237368B9A40F@ORSMSX101.amr.corp.intel.com>
 <20130213181048.GC1601@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A8237368B9A432@ORSMSX101.amr.corp.intel.com>
 <20130213182612.GA11812@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20130213182612.GA11812@obsidianresearch.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Or Gerlitz <ogerlitz@mellanox.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

> A long time ago we discussed having different paths for CM GMP,
> inbound data and outbound data (ie the full IB asymetric pathing
> model), did that get included in the API as well?

Yes - this support made it upstream.

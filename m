From: "Hefty, Sean" <sean.hefty@intel.com>
Subject: RE: [RFC PATCH v2 00/13] SELinux support for Infiniband RDMA
Date: Wed, 13 Apr 2016 16:47:48 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB041285@ORSMSX109.amr.corp.intel.com>
References: <1459985638-37233-1-git-send-email-danielj@mellanox.com>
 <20160411201155.GC371@obsidianresearch.com>
 <DB5PR05MB111168B6670B36F12979705BC4940@DB5PR05MB1111.eurprd05.prod.outlook.com>
 <20160411221210.GA5861@obsidianresearch.com>
 <DB5PR05MB1111E6A72480FF78AAB12747C4940@DB5PR05MB1111.eurprd05.prod.outlook.com>
 <20160411231250.GB5861@obsidianresearch.com>
 <DB5PR05MB1111F04641E58609E51A9630C4940@DB5PR05MB1111.eurprd05.prod.outlook.com>
 <20160412000621.GD5861@obsidianresearch.com>
 <570C85F7.5010101@dev.mellanox.co.il>
 <1828884A29C6694DAF28B7E6B8A82373AB040ABA@ORSMSX109.amr.corp.intel.com>
 <570DD3F5.2060302@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <570DD3F5.2060302@dev.mellanox.co.il>
Content-Language: en-US
Sender: owner-linux-security-module@vger.kernel.org
To: Hal Rosenstock <hal@dev.mellanox.co.il>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Daniel Jurgens <danielj@mellanox.com>
Cc: "selinux@tycho.nsa.gov" <selinux@tycho.nsa.gov>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Yevgeny Petrilin <yevgenyp@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

> Former (multicast modifications of fabric) also requires restricting
> arbitrary UD QPs as well as QP1 as SA access is QPn (n > 0) <-> QP1.

The SA could have an option to ignore all requests that do not originate QP1, then protect access to QP1 on the client nodes.

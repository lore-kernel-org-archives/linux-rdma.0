From: Hal Rosenstock <hal@dev.mellanox.co.il>
Subject: Re: [RFC PATCH v2 00/13] SELinux support for Infiniband RDMA
Date: Wed, 13 Apr 2016 01:07:01 -0400
Message-ID: <570DD3F5.2060302@dev.mellanox.co.il>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AB040ABA@ORSMSX109.amr.corp.intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: "Hefty, Sean" <sean.hefty@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Daniel Jurgens <danielj@mellanox.com>
Cc: "selinux@tycho.nsa.gov" <selinux@tycho.nsa.gov>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Yevgeny Petrilin <yevgenyp@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On 4/12/2016 1:06 PM, Hefty, Sean wrote:
>> Wouldn't QP1 require different access control than QP0 due to SA clients
>> on every end node ?
> 
> QP1 still allows modification of the fabric (e.g. multicast join) or an DoS attack against the SA.  does
> Though the latter probably requires restricting how a UD QP may be used.

Former (multicast modifications of fabric) also requires restricting
arbitrary UD QPs as well as QP1 as SA access is QPn (n > 0) <-> QP1.

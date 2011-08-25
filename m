From: "Latif, Faisal" <faisal.latif@intel.com>
Subject: RE: [PATCH 3/9] IB: nes: convert to SKB paged frag API.
Date: Thu, 25 Aug 2011 08:33:53 -0700
Message-ID: <2EFBCAEF10980645BBCFB605689E08E904E6C67786@azsmsx506.amr.corp.intel.com>
References: <1314260881.10283.48.camel@zakaz.uk.xensource.com>
 <1314260895-15936-3-git-send-email-ian.campbell@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1314260895-15936-3-git-send-email-ian.campbell@citrix.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Ian Campbell <ian.campbell@citrix.com>
Cc: Roland Dreier <roland@kernel.org>, "Hefty, Sean" <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org



Acked-by: Faisal Latif <faisal.latif@intel.com>

Thanks.

> ---
>  drivers/infiniband/hw/nes/nes_nic.c |   21 +++++++++++----------
>  1 files changed, 11 insertions(+), 10 deletions(-)

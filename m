From: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
Subject: RE: [PATCH 1/1] staging: rdma: hfi1 : Prefer using the BIT macro
Date: Thu, 5 Nov 2015 14:24:37 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC25996212@fmsmsx120.amr.corp.intel.com>
References: <1446724683-30092-1-git-send-email-sunnyk@cdac.in>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1446724683-30092-1-git-send-email-sunnyk@cdac.in>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Sunny Kumar <sunny.kumar.roy@gmail.com>, Doug Ledford <dledford@redhat.com>, "Hefty, Sean" <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Sunny Kumar <sunnyk@cdac.in>
List-Id: linux-rdma@vger.kernel.org

> Subject: [PATCH 1/1] staging: rdma: hfi1 : Prefer using the BIT macro
> 
> This patch replaces bit shifting on 1 with the BIT(x) macro
> 
> Signed-off-by: Sunny Kumar <sunnyk@cdac.in>
> ---

Nak.

The patch leaves the shift in.

Mike

From: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
Subject: RE: [PATCH 18/18] staging/rdma/hfi1: Workaround
 CONFIG_SDMA_VERBOSITY timing issue
Date: Fri, 20 Nov 2015 16:01:18 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC259BD8A2@fmsmsx120.amr.corp.intel.com>
References: <1447472236-622-1-git-send-email-jubin.john@intel.com>
 <1447472236-622-18-git-send-email-jubin.john@intel.com>
 <20151120011135.GH11695@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20151120011135.GH11695@kroah.com>
Content-Language: en-US
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Greg KH <gregkh@linuxfoundation.org>, "John, Jubin" <jubin.john@intel.com>
Cc: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "dledford@redhat.com" <dledford@redhat.com>
List-Id: linux-rdma@vger.kernel.org

> That sounds like a horrid hack, and this implies that a slower machine will
> still have this problem...

Greg,

I'm NAK'ing this patch for two reasons:
1. Code underneath the CONFIG option is only used during rework
2. It is a hack as you have noted

We are going to take this up internally to get to the root cause.

Go ahead and drop or whatever you do.

Mike

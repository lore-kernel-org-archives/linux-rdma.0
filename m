From: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
Subject: RE: [PATCH 2/2] qib: Use pci_enable_msix_range() instead of
 pci_enable_msix()
Date: Tue, 18 Feb 2014 16:52:14 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC211F5860@FMSMSX107.amr.corp.intel.com>
References: <cover.1392733151.git.agordeev@redhat.com>
 <f0eabd77b96e0d679ce6c2e2e544c73063c508ee.1392733151.git.agordeev@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <f0eabd77b96e0d679ce6c2e2e544c73063c508ee.1392733151.git.agordeev@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Alexander Gordeev <agordeev@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: infinipath <infinipath@intel.com>, Roland Dreier <roland@kernel.org>, "Hefty, Sean" <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

> Subject: [PATCH 2/2] qib: Use pci_enable_msix_range() instead of
> pci_enable_msix()
> 
We are testing this now.

I suggest a subject/summary adding the IB/:
IB/qib: Use pci_enable_msix_range() instead of pci_enable_msix()

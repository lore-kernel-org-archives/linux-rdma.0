From: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
Subject: RE: [PATCH 2/2] qib: Use pci_enable_msix_range() instead of
 pci_enable_msix()
Date: Wed, 19 Feb 2014 23:11:39 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC211F62DC@FMSMSX107.amr.corp.intel.com>
References: <cover.1392733151.git.agordeev@redhat.com>
 <f0eabd77b96e0d679ce6c2e2e544c73063c508ee.1392733151.git.agordeev@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <f0eabd77b96e0d679ce6c2e2e544c73063c508ee.1392733151.git.agordeev@redhat.com>
Content-Language: en-US
Sender: linux-pci-owner@vger.kernel.org
To: Alexander Gordeev <agordeev@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Roland Dreier <roland@kernel.org>, "Hefty, Sean" <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

> Subject: [PATCH 2/2] qib: Use pci_enable_msix_range() instead of
> pci_enable_msix()
> 
> As result of deprecation of MSI-X/MSI enablement functions
> pci_enable_msix() and pci_enable_msi_block() all drivers using these two
> interfaces need to be updated to use the new pci_enable_msi_range() and
> pci_enable_msix_range() interfaces.
> 
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>

This worked fine!

Roland, can you fix up the subject to change qib to IB/qib when you merge it?

Acked-by: Mike Marciniszyn <mike.marciniszyn@intel.com>

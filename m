From: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
Subject: RE: [PATCH 4/6] IB/qib: Use pcie_set_mps() and pcie_get_mps() to
 simplify code
Date: Mon, 9 Sep 2013 14:55:46 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC2119F081@FMSMSX107.amr.corp.intel.com>
References: <1378732388-4508-1-git-send-email-wangyijing@huawei.com>
 <1378732388-4508-5-git-send-email-wangyijing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <1378732388-4508-5-git-send-email-wangyijing@huawei.com>
Content-Language: en-US
Sender: linux-pci-owner@vger.kernel.org
To: Yijing Wang <wangyijing@huawei.com>, Bjorn Helgaas <bhelgaas@google.com>, Chris Metcalf <cmetcalf@tilera.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, David Airlie <airlied@linux.ie>, infinipath <infinipath@intel.com>, Roland Dreier <roland@kernel.org>, Roland Dreier <roland@purestorage.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Mark Einon <mark.einon@gmail.com>, "Hefty, Sean" <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, Hanjun Guo <guohanjun@huawei.com>
List-Id: linux-rdma@vger.kernel.org

> Subject: [PATCH 4/6] IB/qib: Use pcie_set_mps() and pcie_get_mps() to simplify
> code
> 
> Refactor qib_tune_pcie_caps() function, use pcie_set_mps() and
> pcie_get_mps() to simply code. Because pci core caches the "PCI-E Max
> Payload Size Supported" in pci_dev->pcie_mpss, so use that instead of
> pcie_capability_read_word(). Remove the unused val2fld() and fld2val().
> 

I tested this patch as is and saw no issues.

The only thing I would suggest is that the new use of pcie_get_readrq/pcie_set_readrq() be reflected in the comments with an appropriate adjustment in the subject.

Mike

 

From: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
Subject: RE: [PATCH 4/6] IB/qib: Use pcie_set_mps() and pcie_get_mps() to
 simplify code
Date: Mon, 30 Sep 2013 14:56:37 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC211AE5BF@FMSMSX107.amr.corp.intel.com>
References: <1378732388-4508-1-git-send-email-wangyijing@huawei.com>
 <1378732388-4508-5-git-send-email-wangyijing@huawei.com>
 <32E1700B9017364D9B60AED9960492BC2119F081@FMSMSX107.amr.corp.intel.com>
 <20130924203806.GA9302@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <20130924203806.GA9302@google.com>
Content-Language: en-US
Sender: linux-pci-owner@vger.kernel.org
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Yijing Wang <wangyijing@huawei.com>, Chris Metcalf <cmetcalf@tilera.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, David Airlie <airlied@linux.ie>, infinipath <infinipath@intel.com>, Roland Dreier <roland@kernel.org>, Roland Dreier <roland@purestorage.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Mark Einon <mark.einon@gmail.com>, "Hefty, Sean" <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, Hanjun Guo <guohanjun@huawei.com>
List-Id: linux-rdma@vger.kernel.org

> 
> Is something like the following what you had in mind?  If so, I can
> just queue it up.  Otherwise, I'll wait for Yijing to post a v2 patch.
> 
> 
> IB/qib: Use pcie_set_mps() and pcie_get_mps() to simplify code
> 
> From: Yijing Wang <wangyijing@huawei.com>
> 
> Refactor qib_tune_pcie_caps().  Use pcie_get_mps(), pcie_set_mps(),
> pcie_get_readrq(), and pcie_set_readrq() to simplify the code.  The PCI
> core caches the "PCIe Max Payload Size Supported" in pci_dev->pcie_mpss,
> so use that instead of pcie_capability_read_word().  Remove the unused
> val2fld() and fld2val().
> 
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>

This works!

Go ahead and queue it up.

Mike

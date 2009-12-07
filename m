From: "Tung, Chien Tin" <chien.tin.tung@intel.com>
Subject: RE: [PATCH 3/5] drivers/infiniband: correct size computation
Date: Mon, 7 Dec 2009 09:38:55 -0700
Message-ID: <603F8A3875DCE940BA37B49D0A6EA0AE3CE36C9F@azsmsx501.amr.corp.intel.com>
References: <Pine.LNX.4.64.0912061015540.20858@ask.diku.dk>
 <603F8A3875DCE940BA37B49D0A6EA0AE3CE36BF4@azsmsx501.amr.corp.intel.com>
 <Pine.LNX.4.64.0912071720520.15109@ask.diku.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S935433AbZLGQiy@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0912071720520.15109@ask.diku.dk>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Julia Lawall <julia@diku.dk>
Cc: "Latif, Faisal" <faisal.latif@intel.com>, Roland Dreier <rolandd@cisco.com>, "Hefty, Sean" <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

>> > 	/* Remap the PCI registers in adapter BAR0 to kernel VA space */
>> >-	mmio_regs = ioremap_nocache(pci_resource_start(pcidev, BAR_0), sizeof(mmio_regs));
>> >+	mmio_regs = ioremap_nocache(pci_resource_start(pcidev, BAR_0),
>> >+				    sizeof(*mmio_regs));
>> > 	if (mmio_regs == NULL) {
>> > 		printk(KERN_ERR PFX "Unable to remap BAR0\n");
>> > 		ret = -EIO;
>>
>> mmio_regs is initialized to NULL at the top of the function so
>> *mmio_regs wouldn't be a good idea.  Instead of sizeof(*mmio_regs) use
>> pci_resource_len(pcidev, BAR_0).  If you can recreate the patch with
>> this change I will ack it.
>
>When you say that it isn't a good idea, do you mean that the result is
>wrong, or that it looks odd?  I didn't think sizeof looked at the value,
>but only at the type?


I misspoke on the problem.  Mmio_regs is declared as a void pointer:

        void __iomem *mmio_regs = NULL;

Thus pci_resource_len(pcidev, BAR_0) is the correct fix.

Chien

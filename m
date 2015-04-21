From: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
Subject: RE: [PATCH v3 2/3] IB/qib: use arch_phys_wc_add()
Date: Tue, 21 Apr 2015 20:59:41 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC256FB8E2@fmsmsx120.amr.corp.intel.com>
References: <1429648676-17755-1-git-send-email-mcgrof@do-not-panic.com>
 <1429648676-17755-3-git-send-email-mcgrof@do-not-panic.com>
 <20150421205716.GA474@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150421205716.GA474@obsidianresearch.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: infinipath <infinipath@intel.com>, "roland@kernel.org" <roland@kernel.org>, "Hefty, Sean" <sean.hefty@intel.com>, "hal.rosenstock@gmail.com" <hal.rosenstock@gmail.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "luto@amacapital.net" <luto@amacapital.net>, "mst@redhat.com" <mst@redhat.com>, "cocci@systeme.lip6.fr" <cocci@systeme.lip6.fr>, "Luis R. Rodriguez" <mcgrof@suse.com>, Toshi Kani <toshi.kani@hp.com>, Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>, Roland Dreier <roland@purestorage.com>, "Dalessandro, Dennis" <dennis.dalessandro@intel.com>, Suresh Siddha <sbsiddha@gmail.com>, Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>, Juergen Gross <jgross@suse.com>, Daniel Vetter <daniel.vetter@ffwll.ch>, Dave Airlie <airlied@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>, Antonino Daplas <adaplas@gmail.com>, Jea
List-Id: linux-rdma@vger.kernel.org

> > This driver already makes use of ioremap_wc() on PIO buffers, so
> > convert it to use arch_phys_wc_add().
> 
> This is probably OK, but I think you should also remove the qib_wc_pat module
> parameter.
> 
> Jason

Revise based on Jason's request and I will do some testing.

Mike

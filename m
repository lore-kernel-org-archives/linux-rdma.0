From: Thomas Gleixner <tglx@linutronix.de>
Subject: RE: hrtimer (rdmavt RNR timer) was lost
Date: Mon, 23 Apr 2018 15:35:26 +0200 (CEST)
Message-ID: <alpine.DEB.2.21.1804231528130.2077@nanos.tec.linutronix.de>
References: <3F128C9216C9B84BB6ED23EF16290AFB634C8C87@CRSMSX101.amr.corp.intel.com> <alpine.DEB.2.21.1804231355570.2077@nanos.tec.linutronix.de> <3F128C9216C9B84BB6ED23EF16290AFB634C9420@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3F128C9216C9B84BB6ED23EF16290AFB634C9420@CRSMSX101.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Wan, Kaike" <kaike.wan@intel.com>
Cc: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>, "Dalessandro, Dennis" <dennis.dalessandro@intel.com>, "Weiny, Ira" <ira.weiny@intel.com>, "Fleck, John" <john.fleck@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 23 Apr 2018, Wan, Kaike wrote:
> > Can you apply the following debug patch and enable the hrtimer_start trace
> > point and send me the full trace or upload it somewhere?
> 
> The original trace was about 29GB and I filtered it with
> "0000000066dda1ea" (the offending base) to generate a 1.4GB file that I
> could open and investigate.  I am not sure how I can send them to you. Do
> you have somewhere I can upload to?
>
> I can try your debug patch and again I am anticipating a big trace file.

Well, you can find the spot where the fail happens and then extract the
full thing from 2s before that point to 1s after. That should be reasonably
small and good enough. Let me know when you have it and how big it is
(compressed) and we'll figure something out how to transport it.

Thanks,

	tglx

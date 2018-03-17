From: Sinan Kaya <okaya@codeaurora.org>
Subject: Re: [PATCH v3 18/18] infiniband: cxgb4: Eliminate duplicate barriers
 on weakly-ordered archs
Date: Sat, 17 Mar 2018 00:03:05 -0400
Message-ID: <71e37a55-537b-d75a-cfde-f188b7cfce8e@codeaurora.org>
References: <1521216991-28706-1-git-send-email-okaya@codeaurora.org>
 <1521216991-28706-19-git-send-email-okaya@codeaurora.org>
 <003601d3bd6a$783d6970$68b83c50$@opengridcomputing.com>
 <83387f6e-adcb-14e9-2c22-96abf9493cc6@codeaurora.org>
 <004501d3bd7b$505e70f0$f11b52d0$@opengridcomputing.com>
 <740c7d45-450e-c9b3-ceed-7bc7fcefbc5a@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <740c7d45-450e-c9b3-ceed-7bc7fcefbc5a@codeaurora.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>, netdev@vger.kernel.org, timur@codeaurora.org, sulrich@codeaurora.org
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 'Steve Wise' <swise@chelsio.com>, 'Doug Ledford' <dledford@redhat.com>, 'Jason Gunthorpe' <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 'Michael Werner' <werner@chelsio.com>, 'Casey Leedom' <leedom@chelsio.com>
List-Id: linux-rdma@vger.kernel.org

On 3/16/2018 11:40 PM, Sinan Kaya wrote:
> I'll change writel_relaxed() with __raw_writel() in the series like you suggested
> and also look at your other comments.

I spoke too soon.

Now that I realized, code needs to follow one of the following patterns for correctness

1)
wmb()
writel()/writel_relaxed()

or 

2)
wmb()
__raw_wrltel()
mmiowb()

but definitely not

wmb()
__raw_wrltel()

Since #1 == #2, I'll stick to my current implementation of writel_relaxed()

Changing writel() to writel_relaxed() or __raw_writel() isn't enough. PowerPC needs mmiowb()
for correctness. ARM's mmiowb() implementation is empty.

So, there is no one size fits all solution with the current state of affairs.


-- 
Sinan Kaya
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.

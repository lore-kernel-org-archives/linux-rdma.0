From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v4 5/6] IB/nes: Eliminate duplicate barriers on
 weakly-ordered archs
Date: Tue, 20 Mar 2018 10:29:33 -0600
Message-ID: <20180320162933.GO19744@ziepe.ca>
References: <1521514068-8856-1-git-send-email-okaya@codeaurora.org>
 <1521514068-8856-6-git-send-email-okaya@codeaurora.org>
 <20180320145413.GH19744@ziepe.ca>
 <3b96019a-2b3b-374a-453e-0553fb04c0a7@codeaurora.org>
 <20180320160151.GM19744@ziepe.ca>
 <77565861-7697-699f-c876-adf36db9ab5f@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <77565861-7697-699f-c876-adf36db9ab5f@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Sinan Kaya <okaya@codeaurora.org>
Cc: linux-rdma@vger.kernel.org, timur@codeaurora.org, sulrich@codeaurora.org, linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Faisal Latif <faisal.latif@intel.com>, Doug Ledford <dledford@redhat.com>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 20, 2018 at 11:08:59AM -0500, Sinan Kaya wrote:

> > In this case, I strongly suspect nes really intended to say wmb()
> 
> Should I change barrier() to wmb() or leave it alone? I have no idea if 
> nes is actively being maintained or if it is EOL.

It is dead, and the HW doesn't work on 64 bit machines. Just ignore it
is my advice.

Jason

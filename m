From: Timur Tabi <timur@codeaurora.org>
Subject: Re: [PATCH v3 18/18] infiniband: cxgb4: Eliminate duplicate barriers
 on weakly-ordered archs
Date: Fri, 16 Mar 2018 23:08:16 -0500
Message-ID: <b327cb67-562c-8b95-b31b-96594d6a41ae@codeaurora.org>
References: <1521216991-28706-1-git-send-email-okaya@codeaurora.org>
 <1521216991-28706-19-git-send-email-okaya@codeaurora.org>
 <003601d3bd6a$783d6970$68b83c50$@opengridcomputing.com>
 <20180316221347.GA958@ziepe.ca>
 <004401d3bd7b$2a2e70b0$7e8b5210$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <004401d3bd7b$2a2e70b0$7e8b5210$@opengridcomputing.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>, 'Jason Gunthorpe' <jgg@ziepe.ca>, "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Cc: 'Sinan Kaya' <okaya@codeaurora.org>, netdev@vger.kernel.org, sulrich@codeaurora.org, linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 'Steve Wise' <swise@chelsio.com>, 'Doug Ledford' <dledford@redhat.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, 'Michael Werner' <werner@chelsio.com>, 'Casey Leedom' <leedom@chelsio.com>
List-Id: linux-rdma@vger.kernel.org

On 3/16/18 6:04 PM, Steve Wise wrote:
> Anybody understand why the PPC implementation of writeX_relaxed() isn't
> relaxed?

You probably should ask that on the linuxppc-dev@lists.ozlabs.org 
mailing list.

I've always wondered why PowerPC has non-standard I/O accessors.

-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm
Technologies, Inc.  Qualcomm Technologies, Inc. is a member of the
Code Aurora Forum, a Linux Foundation Collaborative Project.

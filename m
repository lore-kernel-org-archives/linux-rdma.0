From: Igor Stoppa <igor.stoppa@gmail.com>
Subject: Re: [PATCH] infiniband: nes: add unlikely() to assert()
Date: Fri, 7 Sep 2018 18:25:03 +0300
Message-ID: <e7fac148-2347-1303-7725-41b7858a02e4@gmail.com>
References: <20180831192418.12346-1-igor.stoppa@huawei.com>
 <20180905060106.GI2977@mtr-leonro.mtl.com>
 <811a6feca9fdea2db59ac392a4711cd897f46cc7.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <811a6feca9fdea2db59ac392a4711cd897f46cc7.camel@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Leon Romanovsky <leon@kernel.org>
Cc: Faisal Latif <faisal.latif@intel.com>, Igor Stoppa <igor.stoppa@huawei.com>, Chien Tung <chien.tin.tung@intel.com>, Roland Dreier <rolandd@cisco.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 07/09/18 18:13, Doug Ledford wrote:

> This patch was part of a larger series on lkml.  In that context, I
> acked it so that the series could be applied by whomever took it (it
> didn't belong on rdma-list as a series since only one patch out of some
> large number touched rdma files).  Now it is being resent as not part of
> a series, but my ack was preserved.

Yes, apologies for the confusion (and maybe wrong process?).
The patchset as a whole didn't seem to gain traction, so I decided to 
fallback to the more tedious process of submitting them individually.

Since the specific patch was not altered, I assumed the ack was still 
valid - I am sorry if I did it wrongly

--
igor

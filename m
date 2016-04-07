From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 0/4] IB/srpt and the percpu_ida conversion
Date: Thu, 07 Apr 2016 16:47:44 -0700
Message-ID: <1460072864.18732.76.camel@haakon3.risingtidesystems.com>
References: <57055BC6.7070402@sandisk.com>
	 <1460068181.18732.23.camel@haakon3.risingtidesystems.com>
	 <20160407230110.GA9842@lst.de>
	 <1460071464.18732.57.camel@haakon3.risingtidesystems.com>
	 <5706EE71.8010202@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <5706EE71.8010202@sandisk.com>
Sender: target-devel-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Christoph Hellwig <hch@lst.de>, Doug Ledford <dledford@redhat.com>, Sagi Grimberg <sagi@grimberg.me>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2016-04-07 at 16:34 -0700, Bart Van Assche wrote:
> On 04/07/2016 04:24 PM, Nicholas A. Bellinger wrote:
> > [ ... ]
> 
> You are turning this on its head. I do what I can to improve the 
> stability of the ib_srpt driver and the LIO core and you don't provide 
> timely feedback on most of the LIO core patches I post. Nic, this means 
> that you are not doing a proper job as a kernel maintainer. If someone 
> has the right to complain then it's me.
> 

Listen, I've grown tired a long time ago of you repeatably ignoring my
feedback on changes of substance to target-core.

It's fine if you only look at target-core through the eyes of ib_srpt,
but if you propose significant changes to target-core, and I take the
time to explain why there are broken, but you propose them again and
again ignoring the original feedback, don't expect a friendly response
from me.

Also, none of your ib_srpt patches ever seem make it to target-devel.

Why is that..?

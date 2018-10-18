From: Sudeep Dutt <sudeep.dutt@intel.com>
Subject: Re: rdma-core doesn't install driver.h, broke libibscif
Date: Thu, 18 Oct 2018 08:10:00 -0700
Message-ID: <1539875400.18931.450.camel@localhost>
References: <20181017085453.GA30496@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181017085453.GA30496@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Sudeep Dutt <sudeep.dutt@intel.com>, "Woodruff, Robert J" <robert.j.woodruff@intel.com>, james harvey <jamespharvey20@gmail.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Nikhil Rao <nikhil.rao@intel.com>, Ashutosh Dixit <ashutosh.dixit@intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Wed, 2018-10-17 at 01:54 -0700, Christoph Hellwig wrote:
> On Mon, Oct 15, 2018 at 05:53:44PM +0000, Woodruff, Robert J wrote:
> > James Harvey wrote,
> > 
> > >Short: Is libibscif dead, and should OS repositories remove it?
> > 
> > Libibscif is for an old product,  Intel's KNC, that is no longer sold and the S/W is frozen. The open source libibscif is no longer maintained. 
> > It has already been removed from the latest community OFED distribution. The individual package on the OFA downloads is for archive purposed only.
> 
> Does this mean we can kill the kernel scif code as well? 

The MIC COSM drivers are using the kernel SCIF code. These drivers have
been upstream since 2015 and we are not sure who is using them. Our
preference will be to keep these drivers in the kernel for now.

Thanks,
Sudeep Dutt

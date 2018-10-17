From: Christoph Hellwig <hch@infradead.org>
Subject: Re: rdma-core doesn't install driver.h, broke libibscif
Date: Wed, 17 Oct 2018 01:54:53 -0700
Message-ID: <20181017085453.GA30496@infradead.org>
References: <9C6B67F36DCAFC479B1CF6A967258A8CAB401945@ORSMSX115.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <9C6B67F36DCAFC479B1CF6A967258A8CAB401945@ORSMSX115.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Woodruff, Robert J" <robert.j.woodruff@intel.com>
Cc: james harvey <jamespharvey20@gmail.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Nikhil Rao <nikhil.rao@intel.com>, Ashutosh Dixit <ashutosh.dixit@intel.com>, Sudeep Dutt <sudeep.dutt@intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 15, 2018 at 05:53:44PM +0000, Woodruff, Robert J wrote:
> James Harvey wrote,
> 
> >Short: Is libibscif dead, and should OS repositories remove it?
> 
> Libibscif is for an old product,  Intel's KNC, that is no longer sold and the S/W is frozen. The open source libibscif is no longer maintained. 
> It has already been removed from the latest community OFED distribution. The individual package on the OFA downloads is for archive purposed only.

Does this mean we can kill the kernel scif code as well?  It is a
pretty horrible codebase that gets in the way a lot (and hasn't really
seen updates since the initial merge).

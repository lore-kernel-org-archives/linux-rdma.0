From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH for kernel v4.6] IB/srpt: Revert "Convert to percpu_ida
 tag allocation"
Date: Sat, 02 Apr 2016 20:56:03 -0700
Message-ID: <1459655763.13184.45.camel@haakon3.risingtidesystems.com>
References: <56FDBA63.7010804@sandisk.com> <20160401030322.GH2670@leon.nu>
	 <56FDE739.9090801@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <56FDE739.9090801@sandisk.com>
Sender: target-devel-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "leon@leon.nu" <leon@leon.nu>, Doug Ledford <dledford@redhat.com>, Christoph Hellwig <hch@lst.de>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

(Adding missing target-devel CC')

On Thu, 2016-03-31 at 20:12 -0700, Bart Van Assche wrote:
> On 03/31/16 20:05, Leon Romanovsky wrote:
> > On Thu, Mar 31, 2016 at 05:01:39PM -0700, Bart Van Assche wrote:
> >> That patch is wrong because it makes the ib_srpt driver use I/O
> >> contexts allocated by transport_alloc_session_tags() but it does
> >> not initialize these I/O contexts properly.
> >
> > Did you have a chance to see which initializations are missing in this
> > case? What is needed to do if we decide to fix original patch?
> >
> > Except these questions, the revert is fine :)
> > Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
> 
> Hello Leon,
> 
> Thanks for the review. The initializations that are missing from that 
> patch are the 'buf' pointer in the srpt_ioctx structure and mapping that 
> buffer for DMA. Another bug introduced by that patch is that it doubles 
> the amount of memory that is allocated for I/O contexts. New I/O context 
> allocations were added by that patch but the existing I/O context 
> allocation code was not removed.
> 
> Regarding reconsidering the original patch: before we do that it has to 
> be shown with numbers that the percpu_ida conversion does not decrease 
> performance. This is something I had already asked two months ago. See 
> also 
> http://thread.gmane.org/gmane.linux.scsi.target.devel/11253/focus=110559.
> 

Like I said two months ago, there is no reason why ib_srpt needs special
pre-allocation for descriptors containing se_cmd, when every other
single driver in the tree already uses common percpu_ida code for it.

Also, I don't know why none of your ib_srpt patches ever make it to
target-devel, but can you please stop trying to push target driver
changes upstream without first notifying target-devel..?

Beyond that, are you going to send an bug-fix to address this regression
in v4.6 code..?  If not, I'll add this to the queue and just do it
myself.

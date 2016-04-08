From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] IB/srpt: Revert "Convert to percpu_ida tag allocation"
Date: Thu, 07 Apr 2016 17:00:02 -0700
Message-ID: <1460073602.18732.86.camel@haakon3.risingtidesystems.com>
References: <57055BC6.7070402@sandisk.com> <5706E548.3080002@sandisk.com>
	 <1460072224.18732.67.camel@haakon3.risingtidesystems.com>
	 <5706F0E8.5020705@sandisk.com>
	 <1460073123.18732.80.camel@haakon3.risingtidesystems.com>
	 <20160407235422.GB8951@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20160407235422.GB8951@infradead.org>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Linus Torvalds <torvalds@linux-foundation.org>, Doug Ledford <dledford@redhat.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2016-04-07 at 16:54 -0700, Christoph Hellwig wrote:
> On Thu, Apr 07, 2016 at 04:52:03PM -0700, Nicholas A. Bellinger wrote:
> > Because I'm actively working on a bug-fix for the regression, and it's
> > -rc2 in a target driver that hardly anyone cares about.
> > 
> > If the regression is not addressed before v4.6-rc6, then by all means
> > revert the original patch.
> 
> Stop it.  People do care.  At least I do for sure, and it's blocking a
> mayor feature I want to land in 4.7.  Bart has a proper fix, and it's
> perfectly valid that you ask him to resend with various tweaks towards
> how your prefer various details to be done, but there is no reason to
> be agressive and personal.

As mentioned, I'm actively working on a -v2 for this regression.

You'll certainly be the first to hear about it as it's resolved over the
next days.

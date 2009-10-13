From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [ofa-general] Re: [GIT PULL] please pull ummunotify
Date: Tue, 13 Oct 2009 08:40:06 +0200
Message-ID: <20091013064006.GC9470@elte.hu>
References: <1253198976.14935.27.camel@laptop> <adazl8td35u.fsf@cisco.com> <adatyz1d17q.fsf@cisco.com> <20090929171332.GD14405@elf.ucw.cz> <20090930094456.GD24621@elte.hu> <20090930160232.GZ22310@obsidianresearch.com> <20091012181944.GF17138@elte.hu> <20091012193048.GA20313@obsidianresearch.com> <20091012202046.GA7648@elte.hu> <20091013040515.GI18578@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S933091AbZJMGk7@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20091013040515.GI18578@obsidianresearch.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Pavel Machek <pavel@ucw.cz>, Roland Dreier <rdreier@cisco.com>, Peter Zijlstra <peterz@infradead.org>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>, general@lists.openfabrics.org, akpm@linux-foundation.org, torvalds@linux-foundation.org, Jeff Squyres <jsquyres@cisco.com>
List-Id: linux-rdma@vger.kernel.org


* Jason Gunthorpe <jgunthorpe@obsidianresearch.com> wrote:

> On Mon, Oct 12, 2009 at 10:20:46PM +0200, Ingo Molnar wrote:
> > It might be more acceptable because the flag-hint mechanism can at most 
> > cause over-flushing - while with perf events we might miss to invalidate 
> > a range altogether.
> 
> Right. Overflushing is not important, but missing an event entirely is 
> not recoverable (at least within the current kernel APIs).

So if we detect event loss in the perf event case (should not happen 
with sufficient buffering but it is a possibility the code should be 
prepared for) then we can just flush the [0,-1ULL] range, right?

	Ingo

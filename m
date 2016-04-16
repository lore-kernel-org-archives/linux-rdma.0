From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 0/7] IB/hfi1: Remove write() and use ioctl() for user
 access
Date: Sat, 16 Apr 2016 20:19:17 +0100
Message-ID: <20160416191917.GY25498@ZenIV.linux.org.uk>
References: <20160414153727.6387.96381.stgit@scvm10.sc.intel.com>
 <20160414164550.GC6247@obsidianresearch.com>
 <20160414174830.GA11641@rhel.sc.intel.com>
 <20160415040126.GB10689@leon.nu>
 <20160415161754.GA21549@rhel>
 <20160415173035.GC10689@leon.nu>
 <20160415173401.GA10868@infradead.org>
 <20160415212328.GF10689@leon.nu>
 <20160415233732.GB25662@obsidianresearch.com>
 <20160416060042.GA6349@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160416060042.GA6349@leon.nu>
Sender: linux-kernel-owner@vger.kernel.org
To: Leon Romanovsky <leon@leon.nu>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Christoph Hellwig <hch@infradead.org>, Ira Weiny <ira.weiny@intel.com>, Dennis Dalessandro <dennis.dalessandro@intel.com>, dledford@redhat.com, linux-rdma@vger.kernel.org, linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Sat, Apr 16, 2016 at 09:00:42AM +0300, Leon Romanovsky wrote:
> On Fri, Apr 15, 2016 at 05:37:32PM -0600, Jason Gunthorpe wrote:
> > On Sat, Apr 16, 2016 at 12:23:28AM +0300, Leon Romanovsky wrote:
> > 
> > > Intel as usual decided to do it in their way and the result is presented
> > > on this mailing list.
> > 
> > Dennis was pretty clear he was going to send the patches to address
> > Al's concern, which he has done.
> > 
> > I was also pretty clear I was looking to get rid of the char dev :)
> 
> Yes, and I was pretty clear that we need to converge on one common API
> prior to converting old code (including drivers in staging) in order to
> do it once only.

While we are at it, could the person who'd come up with ui_lseek() be located
and made to stand up and explain the rationale behind the SEEK_END semantics
therein?  To quote the manpage (and paraphrase just about any introductory
textbook):
       SEEK_END
              The file offset is set to the size of the file plus offset bytes.

I'm really curious - which part of "plus" might have lead to
        case SEEK_END:
                offset = ((dd->kregend - dd->kregbase) + DC8051_DATA_MEM_SIZE) -
                        offset;
and, if its author has decided that of course it _must_ have meant "minus",
why had he or she failed to post a correction to the manpage?  Or, on the
off-chance that this "plus" might have something to do with reality,
experimented with some file, for that matter.

Folks, this is a well-earned "F".  And not just for Unix Programming 101 -
the same semantics applies to fseek(3), which is a part of C standard.
Incidentally, lseek(fd, 0, SEEK_END) is "seek to end", not "fail with EINVAL".

As for the use of ioctl...  Frankly, considering the above, it does sound like
"that'll make them STFU about the weirdness - ioctl *is* weird, so there!"

Single-consumer APIs stink, film at 11...

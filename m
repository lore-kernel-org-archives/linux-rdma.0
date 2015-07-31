From: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: [PATCH v4 17/50] IB/hfi1: add PSM driver control/data path
Date: Fri, 31 Jul 2015 09:22:33 +0100
Message-ID: <20150731082207.GT17109@ZenIV.linux.org.uk>
References: <20150730191631.25256.95511.stgit@phlsvslse11.ph.intel.com>
 <20150730191859.25256.28987.stgit@phlsvslse11.ph.intel.com>
 <20150730194041.GA28754@obsidianresearch.com>
 <32E1700B9017364D9B60AED9960492BC25777DA0@fmsmsx120.amr.corp.intel.com>
 <55BA9A38.2030401@redhat.com>
 <20150731073158.GA2485@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150731073158.GA2485-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jul 31, 2015 at 12:31:58AM -0700, Christoph Hellwig wrote:
> On Thu, Jul 30, 2015 at 05:42:16PM -0400, Doug Ledford wrote:
> > I have no problem with this code.  That Al finds the user space ABI for
> > this driver to be bizarre is neither here nor there to me.  Sure, this
> > file does not exhibit normal file API behavior.  Who cares?
> 
> Everyone who cares about filesystem semantics does.
> 
> A NACK from me for a this features, and b) for trying to sneak it in
> after a negative comment without cc to -fsdevel and Al.

FWIW, the lack of comments appears to have tripped Doug, judging by his
"another option would be to drop the write function altogether and just make
all commands come through writev/write_iter and if you only have one command,
you only send one element".

The thing is, ipath and qib (and AFAICS this one as well) have write(2) and
writev(2) take different and completely unrelated sets of commands.  On
the same file.  IOW, the effects of
	writev(fd, &(struct iovec){buf, len}, 1)
and
	write(fd, buf, len)
are not even remotely similar.  _That_ is the gratuitous weirdness I'd been
unhappy with.  And yes, it is gratuitous - it's trivial to have separate files
for separate command sets.

If you drop ->write() in there, you certainly lose the weirdness - along with
one of those command sets.  Sure, having individual iovecs correspond to
separate datagrams is fine; tons of drivers are like that.  qib and ipath
are unique, though, in having *two* command sets overloaded on the same file,
with write() vs. writev() acting as selector (BTW, single-element AIO
going like writev(), not like write()).

PS: I'm back after several weeks of being sick (recipe for fun: start with
40C in shade, get completely soaked in serious rain, then have half an hour
cab ride, with AC set to ~15C) and while I'd managed to get the mailbox
down to relatively sane size, I might have easily deleted more than I should
have.  If there had been anything important sent my way and I don't reply to 
it by Saturday, please resend.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

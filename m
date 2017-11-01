From: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH RFC] rdma/ib: Add trace point macros to display
 human-readable values
Date: Wed, 1 Nov 2017 11:29:32 -0400
Message-ID: <20171101112932.4485ba6a@gandalf.local.home>
References: <20171030215809.31286.46685.stgit@manet.1015granger.net>
        <20171101062743.GO16127@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171101062743.GO16127-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 1 Nov 2017 08:27:43 +0200
Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:

> On Mon, Oct 30, 2017 at 06:01:23PM -0400, Chuck Lever wrote:
> > These can be shared with all kernel ULPs, and more can easily be
> > added as needed.
> >
> > Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > ---
> >  include/trace/events/rdma.h |  128 +++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 128 insertions(+)
> >  create mode 100644 include/trace/events/rdma.h
> >
> > Hi-
> >
> > I'm putting together a series of patches for v4.16 (or later) that
> > add static ftrace trace points to the RPC-over-RDMA client imple-
> > mentation. As part of that effort, I've constructed some trace point
> > helpers that might be useful for other kernel ULPs.
> >
> > So far this patch adds just helpers that xprtrdma needs. It is not
> > complete, but additional helpers can be introduced as they are
> > needed.
> >
> > I'd like to hear comments about these, or please let me know if
> > such helpers already exist and where xprtrdma can find them.  
> 
> Bart, Steve
> 
> You attended the MS track, and for the rest of us, the quote below
> sounds a little bit cryptic. Does the quote below mean that Chuck's
> proposal is no-go?

Actually, I wasn't invited to the Maintainer's Summit. Perhaps I should
have been.

> 
> From LWN.net "Another attempt to address the tracepoint ABI problem" [1]
> 
> "The solution that was arrived at for now, as related by Torvalds,
>  is to hold off on adding explicit tracepoints to the kernel. Instead,
>  support will be added to make it easy for an application to attach a
>  BPF script to any function in the kernel, with access to that function's
>  arguments."
> 
> [1] https://lwn.net/Articles/737530/

What I can tell you is what I talked to Linus about when I cornered him
in the hallway. ;-)

Basically, nothing has changed. If a maintainer is fine with
trace events, then they can add new trace events. The issue is with the
maintainers that don't want the possibility of having to maintain stale
trace events because some tool depends on them and it becomes a burden
in the future. This is mostly an issues with the scheduler and VFS.

What Linus asked me to do is to build an infrastructure on top of
ftrace, and make it easier to extract data from these "dynamic function
trace events". I need to add easier use cases for eBPF because the
usage of eBPF is still a large learning curve compared to the ease of
accessing the current trace event infrastructure.

I'll be working on this in the very near future, but I don't expect
anything to be useful for within a year's time. Thus, continue doing
what you have been doing, and hopefully in a year we will be able to
extract more data from the kernel from anywhere a function is traced.

-- Steve

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

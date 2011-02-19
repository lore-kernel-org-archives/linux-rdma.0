From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 0/2] Improved node descriptions
Date: Sat, 19 Feb 2011 12:24:58 -0700
Message-ID: <20110219192458.GB4506@obsidianresearch.com>
References: <20110217213017.25708.95042.stgit@homer>
 <AANLkTim5MrHMVjaNFtHeWBy82dag4XNxdBcjBEW+d1yb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <AANLkTim5MrHMVjaNFtHeWBy82dag4XNxdBcjBEW+d1yb-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Michael Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Feb 17, 2011 at 03:20:31PM -0800, Roland Dreier wrote:
> On Thu, Feb 17, 2011 at 1:30 PM, Michael Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org> wrote:
> > This patch addresses the problem by providing a function to build the node
> > description. If the provided source string for the description contains an
> > '@' character, the function will substitute the current utsname.
> >
> > This ensures that even after a fabric has been completely initialized, if
> > a node's hostname changes, that change will be reflected in the next sweep
> > of the SM, but also maintains compatibility with existing code since the
> > behavior is unchanged if the description string does not contain an '@'
> > character.
> 
> This looks like a reasonable approach to me, although of course the SM
> has no way of knowing it should update a port's node description if a
> hostname changes.
> 
> Aside from some minor quibbles
>  - next time please use different subjects for each patch in the thread
>  - the prototype of ib_build_node_desc() seems to force every call
>    site to have a cast; maybe the function should take a pointer to
>    struct ib_smp instead?
>  - the internals of ib_build_node_desc() look a bit ugly, is there any
>    way to make it a little cleaner?
> I do like this.  Does anyone have any feelings about applying this
> for 2.6.39?  Is this shipping in OFED?

If the main concern is DHCP what is the problem with using
/etc/dhcp/dhclient-enter-hooks.d/ or alike?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

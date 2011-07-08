From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 3/4] infiniband-diags: properly resolve node guids
Date: Fri, 8 Jul 2011 16:55:10 -0600
Message-ID: <20110708225510.GC10216@obsidianresearch.com>
References: <20110705120815.3cc7d59b.weiny2@llnl.gov>
 <4E1779CE.9030502@dev.mellanox.co.il>
 <20110708215046.GB10216@obsidianresearch.com>
 <4E177DA5.9030600@dev.mellanox.co.il>
 <20110708152953.0063fb7b.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20110708152953.0063fb7b.weiny2-i2BcT+NCU+M@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jul 08, 2011 at 03:29:53PM -0700, Ira Weiny wrote:
> On Fri, 8 Jul 2011 14:59:01 -0700
> Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> 
> > On 7/8/2011 5:50 PM, Jason Gunthorpe wrote:
> > > On Fri, Jul 08, 2011 at 05:42:38PM -0400, Hal Rosenstock wrote:
> > > 
> > >> Should the request just be a GET rather than GET_TABLE and avoid this
> > >> check ? I don't think multiple nodes can register with same Node GUID,
> > >> can they ? Also, I think it makes eliminates this check and the missing
> > >> 0 check.
> > > 
> > > Multiport HCAs should (and do..) show up with multiple node
> > > records. There is one node record per end port, not per node. This is
> > > why using node GUID as an end port identifier is a bad choice.
> 
> It is _not_ a bad choice if you are looking for a "node".

But very few diags seem to be designed around the idea that they will
operate on a bundle of end ports (eg a node), they tend to be one end
port only, so asking for a "node" is nonsense. What does it mean?
Operate on a random end port of that node? All end ports? Just fail
with error?

I don't like this trend to make node GUID the default GUID input
format for diags. FWIW, ibtool consistently uses port GUID as the
default GUID type for all end port specifications.

> > Before this patch, it did used to use the port GUID for this.
> 
> The point of this patch is to do the right thing when the user is
> requesting a node they want information about.  The next step is to
> accept NodeDescription and use that from the NodeRecord as a key.

Well, it looks like this is a bug fix for both iblinkinfo and
ibqueryerrors, eg they seem to be documented to accept node GUIDs but
were treating them as port GUIDs in one place and node GUIDs in
another. Though please update the -S section of the man page for
iblinkinfo to reflect the GUID is a node GUID..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

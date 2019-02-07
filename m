From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [LSF/MM TOPIC] Discuss least bad options for resolving
 longterm-GUP usage by RDMA
Date: Wed, 6 Feb 2019 18:48:18 -0800
Message-ID: <CAPcyv4i-sW9gu4nrRvvb24=uAUQms9=+Yx5=EQSj+CxpmoNkSw@mail.gmail.com>
References: <20190205175059.GB21617@iweiny-DESK2.sc.intel.com>
 <20190206095000.GA12006@quack2.suse.cz> <20190206173114.GB12227@ziepe.ca>
 <20190206175233.GN21860@bombadil.infradead.org>
 <47820c4d696aee41225854071ec73373a273fd4a.camel@redhat.com>
 <01000168c43d594c-7979fcf8-b9c1-4bda-b29a-500efe001d66-000000@email.amazonses.com>
 <20190206210356.GZ6173@dastard> <20190206220828.GJ12227@ziepe.ca>
 <0c868bc615a60c44d618fb0183fcbe0c418c7c83.camel@redhat.com>
 <CAPcyv4hqya1iKCfHJRXQJRD4qXZa3VjkoKGw6tEvtWNkKVbP+A@mail.gmail.com>
 <645c5e11b28ff10d354ae17ed3016bc895c9028b.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <645c5e11b28ff10d354ae17ed3016bc895c9028b.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, John Hubbard <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, linux-nvdimm <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, Jerome Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christopher Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, lsf-pc-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 6, 2019 at 5:57 PM Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
[..]
> > > > Dave, you said the FS is responsible to arbitrate access to the
> > > > physical pages..
> > > >
> > > > Is it possible to have a filesystem for DAX that is more suited to
> > > > this environment? Ie designed to not require block reallocation (no
> > > > COW, no reflinks, different approach to ftruncate, etc)
> > >
> > > Can someone give me a real world scenario that someone is *actually*
> > > asking for with this?
> >
> > I'll point to this example. At the 6:35 mark Kodi talks about the
> > Oracle use case for DAX + RDMA.
> >
> > https://youtu.be/ywKPPIE8JfQ?t=395
>
> Thanks for the link, I'll review the panel.
>
> > Currently the only way to get this to work is to use ODP capable
> > hardware, or Device-DAX. Device-DAX is a facility to map persistent
> > memory statically through device-file. It's great for statically
> > allocated use cases, but loses all the nice things (provisioning,
> > permissions, naming) that a filesystem gives you. This debate is what
> > to do about non-ODP capable hardware and Filesystem-DAX facility. The
> > current answer is "no RDMA for you".
> >
> > > Are DAX users demanding xfs, or is it just the
> > > filesystem of convenience?
> >
> > xfs is the only Linux filesystem that supports DAX and reflink.
>
> Is it going to be clear from the link above why reflink + DAX + RDMA is
> a good/desirable thing?
>

No, unfortunately it will only clarify the DAX + RDMA use case, but
you don't need to look very far to see that the trend for storage
management is more COW / reflink / thin-provisioning etc in more
places. Users want the flexibility to be able delay, change, and
consolidate physical storage allocation decisions, otherwise
device-dax would have solved all these problems and we would not be
having this conversation.

> > > Do they need to stick with xfs?
> >
> > Can you clarify the motivation for that question?
>
> I did a little googling and research before I asked that question.
> According to the documentation, other FSes can work with DAX too (namely
> ext2 and ext4).  The question was more or less pondering whether or not
> ext2 or ext4 + RDMA + DAX would solve people's problems without the
> issues that xfs brings.

No, ext4 also supports hole punch, and the ext2 support is a toy. We
went through quite a bit of work to solve this problem for the
O_DIRECT pinned page case.

6b2bb7265f0b sched/wait: Introduce wait_var_event()
d6dc57e251a4 xfs, dax: introduce xfs_break_dax_layouts()
69eb5fa10eb2 xfs: prepare xfs_break_layouts() for another layout type
c63a8eae63d3 xfs: prepare xfs_break_layouts() to be called with
XFS_MMAPLOCK_EXCL
5fac7408d828 mm, fs, dax: handle layout changes to pinned dax mappings
b1f382178d15 ext4: close race between direct IO and ext4_break_layouts()
430657b6be89 ext4: handle layout changes to pinned DAX mappings
cdbf8897cb09 dax: dax_layout_busy_page() warn on !exceptional

So the fs is prepared to notify RDMA applications of the need to
evacuate a mapping (layout change), and the timeout to respond to that
notification can be configured by the administrator. The debate is
about what to do when the platform owner needs to get a mapping out of
the way in bounded time.

> >  This problem exists
> > for any filesystem that implements an mmap that where the physical
> > page backing the mapping is identical to the physical storage location
> > for the file data. I don't see it as an xfs specific problem. Rather,
> > xfs is taking the lead in this space because it has already deployed
> > and demonstrated that leases work for the pnfs4 block-server case, so
> > it seems logical to attempt to extend that case for non-ODP-RDMA.
> >
> > > Are they
> > > really trying to do COW backed mappings for the RDMA targets?  Or do
> > > they want a COW backed FS but are perfectly happy if the specific RDMA
> > > targets are *not* COW and are statically allocated?
> >
> > I would expect the COW to be broken at registration time. Only ODP
> > could possibly support reflink + RDMA. So I think this devolves the
> > problem back to just the "what to do about truncate/punch-hole"
> > problem in the specific case of non-ODP hardware combined with the
> > Filesystem-DAX facility.
>
> If that's the case, then we are back to EBUSY *could* work (despite the
> objections made so far).

I linked it in my response to Jason [1], but the entire reason ext2,
ext4, and xfs scream "experimental" when DAX is enabled is because DAX
makes typical flows fail that used to work in the page-cache backed
mmap case. The failure of a data space management command like
fallocate(punch_hole) is more risky than just not allowing the memory
registration to happen in the first place. Leases result in a system
that has a chance at making forward progress.

The current state of disallowing RDMA for FS-DAX is one of the "if
(dax) goto fail;" conditions that needs to be solved before filesystem
developers graduate DAX from experimental status.

[1]: https://lists.01.org/pipermail/linux-nvdimm/2019-February/019884.html

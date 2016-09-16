From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [Ofvwg] [ANNOUNCE] Open Fabrics Verbs Working Group (OFVWG)
 meeting tomorrow - 9/13/2016 at 11:00PDT
Date: Fri, 16 Sep 2016 07:19:31 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E24EE469A@CRSMSX101.amr.corp.intel.com>
References: <VI1PR0501MB2189FBF50563679C4E61B1EFB1FF0@VI1PR0501MB2189.eurprd05.prod.outlook.com>
 <CAG53R5XUDkVgu5R2wHOyxd0FGEuEU+CTf1H_d9=Mk+DnDS51Ug@mail.gmail.com>
 <20160913064857.GA5988@infradead.org>
 <CAG53R5UO50zXYF_oUUA_MUhx+xYS8FbDkTsAzon6Fn4syDyWvQ@mail.gmail.com>
 <20160913070418.GA31616@infradead.org> <20160913103238.GW8812@leon.nu>
 <20160914123059.GA868@infradead.org>
 <20160914171349.GG16014@obsidianresearch.com>
 <20160915050005.GF26069@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160915050005.GF26069-2ukJVAZIZ/Y@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "ofvwg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofvwg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> 
> On Wed, Sep 14, 2016 at 11:13:49AM -0600, Jason Gunthorpe wrote:
> > On Wed, Sep 14, 2016 at 05:30:59AM -0700, Christoph Hellwig wrote:
> >
> > > I'm not fine with HFI exposing the non-verbs interfaces through
> > > drivers/infiniband/core interface, which as far as I can tell it
> > > currently does not even do, although some discussions here suggest
> > > that a future interface should cater to those interface.
> >
> > The counter balance is that the Kernel Community has had a lot of bad
> > experiences with drivers growing their own user APIs and 'subsystem'
> > like functionality.
> 
> Do you see any desire of HFI authors to move to new general user API?

Obviously we designed to have PSM be it's own interface just like qib was.

I see advantages and disadvantages for both us and the community with both directions.

The largest issue we have right now is that we are not sure about the performance of PSM through the proposed interface.  Lack of performance would, of course, be a show stopper.  Validating performance will take time and will probably not be effective until we get farther down the interface.

Frankly, I just have not had time to try to evaluate what it would take to get a command through the new interface.  I have spent some time assessing which commands (verbs and PSM) need to be fast path.  And I have done a quick review of the latest rfc from a few weeks ago from Matan.  I hoping to find more time soon.

For the current set of patches, I noticed an "escape clause" for vendor specific IOCTLs.

        if (cmd == RDMA_DIRECT_IOCTL) {
                /* TODO? */
                err = -ENOSYS;
                goto out;
        } else {

I think we should have this but to Christophs point if you have something like this why not just have a separate cdev?

Christoph, do you think the addition of the PSM interface to infiniband/core is a pollution of that ABI?  I made a similar argument that from a user side opening /dev/infiniband/uverbsX and then doing PSM on that FD was "unclean".   Jason however, brought up some good points on why we may want to do that.

Frankly I think we should focus on verbs and keep the interface flexible, which is what we are doing.

Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

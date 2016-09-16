From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [Ofvwg] [ANNOUNCE] Open Fabrics Verbs Working Group (OFVWG)
 meeting tomorrow - 9/13/2016 at 11:00PDT
Date: Fri, 16 Sep 2016 02:12:19 -0700
Message-ID: <20160916091219.GC21078@infradead.org>
References: <VI1PR0501MB2189FBF50563679C4E61B1EFB1FF0@VI1PR0501MB2189.eurprd05.prod.outlook.com>
 <CAG53R5XUDkVgu5R2wHOyxd0FGEuEU+CTf1H_d9=Mk+DnDS51Ug@mail.gmail.com>
 <20160913064857.GA5988@infradead.org>
 <CAG53R5UO50zXYF_oUUA_MUhx+xYS8FbDkTsAzon6Fn4syDyWvQ@mail.gmail.com>
 <20160913070418.GA31616@infradead.org>
 <20160913103238.GW8812@leon.nu>
 <20160914123059.GA868@infradead.org>
 <20160914171349.GG16014@obsidianresearch.com>
 <20160915050005.GF26069@leon.nu>
 <2807E5FD2F6FDA4886F6618EAC48510E24EE469A@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2807E5FD2F6FDA4886F6618EAC48510E24EE469A-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "ofvwg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org" <ofvwg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Sep 16, 2016 at 07:19:31AM +0000, Weiny, Ira wrote:
> I think we should have this but to Christophs point if you have something like this why not just have a separate cdev?

Yes, please.  It's not relate to the verbs interface in any way, so
don't shoer horn it into the verbs interface - that's just going to
create problems for both the verbs interface and psm.

> Christoph, do you think the addition of the PSM interface to infiniband/core is a pollution of that ABI?  I made a similar argument that from a user side opening /dev/infiniband/uverbsX and then doing PSM on that FD was "unclean".   Jason however, brought up some good points on why we may want to do that.

It's not infiniband infiniband core code, so it should not go there.  If
you think there is a reasonable chance of more PSM drivers we can have a
drivers/psm for it, otherwise leave it in the driver.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

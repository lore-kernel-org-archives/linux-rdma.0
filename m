From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 4/4] glue/redhat/spec: build split rpm packages
Date: Tue, 18 Oct 2016 13:28:53 -0600
Message-ID: <20161018192853.GA16536@obsidianresearch.com>
References: <20161014192136.11731-1-jarod@redhat.com>
 <20161014192136.11731-5-jarod@redhat.com>
 <20161014233904.GD16509@obsidianresearch.com>
 <20161017184506.GL14983@redhat.com>
 <20161017190705.GB8122@obsidianresearch.com>
 <20161018144411.GS14983@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20161018144411.GS14983-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jarod Wilson <jarod-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 18, 2016 at 10:44:11AM -0400, Jarod Wilson wrote:

> > I think you can just add ../README.md to the
> > Documentation/CMakeFile.txt
> 
> First cut, I added a Files line to the root CMakeLists.txt. Would the
> above be preferred over that? Both seem to work.

It is nitpicky, but I'd put it in the Documentation/CMakelists as
currently the top level is all setup and doesn't build or install
anything.

eg the top level plays a role like configure.ac

Might be more familiar for people..

> $ git archive --prefix=rdma-core-11/ -o ~/rpmbuild/SOURCES/rdma-core-11.tgz --format tar.gz HEAD

Yah, that is the right thing, it should match the tar file what github
will autogenerate when we make a tag.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

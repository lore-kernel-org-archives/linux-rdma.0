From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: rdma-core: Location of 70-persistent-ipoib.rules
Date: Fri, 22 Sep 2017 12:45:26 -0400
Message-ID: <1506098726.5172.2.camel@redhat.com>
References: <1505129627.3732.3.camel@profitbricks.com>
         <20170911162521.GD32117@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170911162521.GD32117-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, 2017-09-11 at 10:25 -0600, Jason Gunthorpe wrote:
> On Mon, Sep 11, 2017 at 01:33:47PM +0200, Benjamin Drung wrote:
> 
> > Since 70-persistent-ipoib.rules is just a commented example, should
> > we
> > better put it into /usr/share/doc/rdma-core instead (where udev.md
> > is
> > placed)?
> 
> That would be fine for me, but I think /etc/ is appropriate in this
> case and the lintian rule is just overzealous.

I agree with Jason on this.  I think lintian should possibly be fixed
instead ;-)

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

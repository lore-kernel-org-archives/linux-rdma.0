From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Possible rdma-core header conflict
Date: Mon, 21 Aug 2017 09:57:29 -0600
Message-ID: <20170821155729.GC4401@obsidianresearch.com>
References: <CACTTzNa3EzABie9=h2X-ONBefyaoWE1+RAT-T+uxJVvVij15Rg@mail.gmail.com>
 <20170821120310.GL1724@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170821120310.GL1724-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Yigal Korman <yigal-/8YdC2HfS5554TAoqtyWWQ@public.gmane.org>, Linux RDMA Mailing List <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Aug 21, 2017 at 03:03:10PM +0300, Leon Romanovsky wrote:
> On Mon, Aug 21, 2017 at 12:24:14PM +0300, Yigal Korman wrote:
> > Hi,
> > Has anyone noticed that installing rdma-core (or older
> > librdmacm-devel) package and then installing kernel headers manually
> > (make headers_install) removes the librdmacm headers?
> > I actually see it in the make output:
> >
> > make INSTALL_HDR_PATH=/usr headers_install
> >   CHK     include/generated/uapi/linux/version.h
> >   REMOVE  rdma_cma_abi.h rdma_verbs.h rdma_cma.h rsocket.h
> >
> > Am I doing something wrong?
> > Sounds like the kernel rdma headers and librdmacm headers shouldn't
> > sit in the same directory...
> 
> It looks like this behavior (removal of header files) was from the beginning of git era.
> ➜  linux-rdma git:(rdma-next) ✗ git co -b tmp v2.6.34.8
> ➜  linux-rdma git:(tmp) ✗ cp ~/src/rdma-core/librdmacm/rdma_verbs.h /tmp/h/include/rdma/ && make INSTALL_HDR_PATH=/tmp/h headers_install | grep REMOVE
>   REMOVE  rdma_verbs.h

The user space files have also been sharing the directory with the
kernel files since the start.. Not sure why, but I don't think we can
change it now.

Maybe someone can patch the kernel to exempt rdma/ from the removal
process?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

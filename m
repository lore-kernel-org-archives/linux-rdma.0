From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Building 3.1-rc9 in kernel infiniband support with OFED
 libraries
Date: Thu, 13 Oct 2011 18:32:04 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E6AD8D@ORSMSX101.amr.corp.intel.com>
References: <alpine.DEB.2.00.1110110900290.3388@router.home>
 <20111011173929.GH26965@obsidianresearch.com>
 <CAO+b5-pxyc0LpGQ4kkOXJVi7cgYm_cgyJ0qM-m81=fZ+MGXHwQ@mail.gmail.com>
 <1828884A29C6694DAF28B7E6B8A8237316E6A98C@ORSMSX101.amr.corp.intel.com>
 <CAL1RGDW_usQ8o4FJzZqkmoZAvSTHBLZJuJ_YpsHL-=ErbgSw-A@mail.gmail.com>
 <1828884A29C6694DAF28B7E6B8A8237316E6A9C0@ORSMSX101.amr.corp.intel.com>
 <CAL1RGDXm-v52ZRjvNd=jieEeE=rDkatvJcxfporue6x5XjFURA@mail.gmail.com>
 <1828884A29C6694DAF28B7E6B8A8237316E6AD2E@ORSMSX101.amr.corp.intel.com>
 <CAL1RGDXw=NK4TWvvf-gx7Fs1K3iC7yY-DAOZ8pmnni7oRaO=Ww@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDXw=NK4TWvvf-gx7Fs1K3iC7yY-DAOZ8pmnni7oRaO=Ww-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Christoph Lameter <cl-gkYfJU5Cukgdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Wait, now I'm baffled by the patch (ie
> http://git.openfabrics.org/git?p=~shefty/rdma-
> dev.git;a=commitdiff;h=1ec4e62a6e967ddc258e7c4e674168debb727d39)
> 
> I don't see anything that calls ib_uverbs_open_qp().  Am I missing something??
> 
> Does the OFED API compatibility actually call this function and care
> if it fails?

I'm confused now.  The patch definitely looks like it's missing a change to uverbs_main.c to setup the command table.  (I thought you were referring to needing a change to struct ib_device before.)

I'm looking at the code on my test system and trying to understand what exactly is happening.  The OFED compatibility should call this routine and care if it fails, and it looks like mpi cares too, but I don't see how it can work...  Give me some time to look into this.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 05/13] Have cmake run man pages through text substitution
Date: Mon, 26 Sep 2016 18:17:03 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E24EEC6E9@CRSMSX101.amr.corp.intel.com>
References: <1474658228-5390-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1474658228-5390-6-git-send-email-jgunthorpe@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB08E9D8@ORSMSX109.amr.corp.intel.com>
 <20160923213819.GC8490@obsidianresearch.com>
 <2807E5FD2F6FDA4886F6618EAC48510E24EEBF1A@CRSMSX101.amr.corp.intel.com>
 <1828884A29C6694DAF28B7E6B8A82373AB08EFE3@ORSMSX109.amr.corp.intel.com>
 <20160926174713.GF22965@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160926174713.GF22965-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> On Mon, Sep 26, 2016 at 03:19:53PM +0000, Hefty, Sean wrote:
> > > Infiniband-diags uses rst through rst2man.  But if I had to do it
> > > over I would probably do it different.  rst2man is not always
> > > installed and has caused build issues for some people.  Whatever
> > > tool we use I would recommend it be something common.  I'm not too
> familiar with markdown.
> > > Is this really common now?
> >
> > Only by those who want to provide actual documentation.
> 
> Markdown is very popular on github and the integrated processing of the
> web UI is why I picked it for the docs I started. But rst started the trend of
> structued ascii..
> 
> IMHO, rst is more widely available in distros today than pandoc.
> 
> rst2man is incredibly widely distributed: it comes with python-docutils which
> is widely included in every distribution. I have no idea why people would
> complain to you on that point. If something comes in-box in all the distros
> then it is fair game to depend upon, IMHO.

I thought so to.  But python-docutils is in the "optional" section of RH.

https://ask.openstack.org/en/question/67176/python-docutils-openstack-installation/

> 
> > Libfabric uses a daemon that checks for updates to the markdown pages.
> > If it finds any, it generates the man page and commits those changes
> > to the source tree.  So the tar file always has the actual man page.
> > Our tool selection was based on what worked well with github and web
> > page generation.
> 
> I generally frown on checking in built files, but yeah, that is an option.

Yep I agree.  But I resorted to this as well.

:-(

Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

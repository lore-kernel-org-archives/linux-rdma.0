From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 05/13] Have cmake run man pages through text substitution
Date: Mon, 26 Sep 2016 12:21:54 -0600
Message-ID: <20160926182154.GA27094@obsidianresearch.com>
References: <1474658228-5390-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1474658228-5390-6-git-send-email-jgunthorpe@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB08E9D8@ORSMSX109.amr.corp.intel.com>
 <20160923213819.GC8490@obsidianresearch.com>
 <2807E5FD2F6FDA4886F6618EAC48510E24EEBF1A@CRSMSX101.amr.corp.intel.com>
 <1828884A29C6694DAF28B7E6B8A82373AB08EFE3@ORSMSX109.amr.corp.intel.com>
 <20160926174713.GF22965@obsidianresearch.com>
 <2807E5FD2F6FDA4886F6618EAC48510E24EEC6E9@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2807E5FD2F6FDA4886F6618EAC48510E24EEC6E9-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Sep 26, 2016 at 06:17:03PM +0000, Weiny, Ira wrote:

> > rst2man is incredibly widely distributed: it comes with python-docutils which
> > is widely included in every distribution. I have no idea why people would
> > complain to you on that point. If something comes in-box in all the distros
> > then it is fair game to depend upon, IMHO.
> 
> I thought so to.  But python-docutils is in the "optional" section of RH.

I mean it is available via 'yum' with no special repositories. I do
not expect software to build out of the box on any arbitary distro
install. I expect builders to install the required set of
packages. This is why the exect package set is documented in the
README.md

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

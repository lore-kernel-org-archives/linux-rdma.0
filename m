From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 05/13] Have cmake run man pages through text substitution
Date: Mon, 26 Sep 2016 15:19:53 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB08EFE3@ORSMSX109.amr.corp.intel.com>
References: <1474658228-5390-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1474658228-5390-6-git-send-email-jgunthorpe@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AB08E9D8@ORSMSX109.amr.corp.intel.com>
 <20160923213819.GC8490@obsidianresearch.com>
 <2807E5FD2F6FDA4886F6618EAC48510E24EEBF1A@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2807E5FD2F6FDA4886F6618EAC48510E24EEBF1A-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Infiniband-diags uses rst through rst2man.  But if I had to do it over
> I would probably do it different.  rst2man is not always installed and
> has caused build issues for some people.  Whatever tool we use I would
> recommend it be something common.  I'm not too familiar with markdown.
> Is this really common now?

Only by those who want to provide actual documentation.
 
Libfabric uses a daemon that checks for updates to the markdown pages.  If it finds any, it generates the man page and commits those changes to the source tree.  So the tar file always has the actual man page.  Our tool selection was based on what worked well with github and web page generation.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

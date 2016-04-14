From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [RFC PATCH v2 00/13] SELinux support for Infiniband RDMA
Date: Thu, 14 Apr 2016 04:22:56 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB041706@ORSMSX109.amr.corp.intel.com>
References: <DB5PR05MB111168B6670B36F12979705BC4940@DB5PR05MB1111.eurprd05.prod.outlook.com>
 <20160411221210.GA5861@obsidianresearch.com>
 <DB5PR05MB1111E6A72480FF78AAB12747C4940@DB5PR05MB1111.eurprd05.prod.outlook.com>
 <20160411231250.GB5861@obsidianresearch.com>
 <DB5PR05MB1111F04641E58609E51A9630C4940@DB5PR05MB1111.eurprd05.prod.outlook.com>
 <20160412000621.GD5861@obsidianresearch.com>
 <570C85F7.5010101@dev.mellanox.co.il>
 <1828884A29C6694DAF28B7E6B8A82373AB040ABA@ORSMSX109.amr.corp.intel.com>
 <570DD3F5.2060302@dev.mellanox.co.il>
 <1828884A29C6694DAF28B7E6B8A82373AB041285@ORSMSX109.amr.corp.intel.com>
 <20160414002718.GA6660@rhel>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160414002718.GA6660@rhel>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org" <selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > > Former (multicast modifications of fabric) also requires restricting
> > > arbitrary UD QPs as well as QP1 as SA access is QPn (n > 0) <-> QP1.
> >
> > The SA could have an option to ignore all requests that do not originate
> QP1,
> > then protect access to QP1 on the client nodes.
> 
> I'm not really sure what we are protecting against here.  Is it simply DoS
> against the SA?

This would protect against a non-privileged QP trying to change multicast or event subscription, for example.  Though it could help with DoS, by avoiding the processing associated with requests.  Jason's original question was why would you want to leave qp1 open, and I think the answer to that depends on what restrictions could be enforced for qpX: X > 1.  Restricting both seem desirable, IMO.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Is there is any code example to test the XRC?
Date: Wed, 15 Jun 2011 14:24:36 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373021147@ORSMSX101.amr.corp.intel.com>
References: <201106151054.12651.dotanb@sw.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201106151054.12651.dotanb-g2bIKuvJtcQanlnWow0HJg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dotan Barak <dotan-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Is there is any code example that you used for the development of the
> "Allow 3rd party extensions to verb routines" and the XRC that you can
> share?
> 
> If you have such, it can be most usefull for us. If not, i guess we'll
> develop
> an xrc_pingpong that will:
> 1) Gives an example on how to use the verbs extention
> 2) Provides basic testing for the XRC feature

I have very simple example client/server programs that use the librdmacm.  I was just getting too tired last night to post the patches.  I'll send out the patches today and push out git trees with the changes.  (I'd like to extend the samples to send traffic both directions, plus test multiple processes, but that will take a while to get to.)

I also wanted to look at the OFED XRC APIs and see if I could somehow layer them over the submitted changes, or provide some way to ease migrating to the new APIs.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

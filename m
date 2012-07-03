From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [Q] How to tranfer a file which is over 2GB(2^31) size in RDMA
 network?
Date: Tue, 3 Jul 2012 22:40:04 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A4E8E9@ORSMSX101.amr.corp.intel.com>
References: <CA+Tq-Rpk-Q74k2z=ToCK+eeDKuF_84fU2t0LwMBM==QG4P8XgA@mail.gmail.com>
	<5D6C0ABE6A236946864C45679362BBE20ACA83E1@CMEXMB1.ad.emulex.com>
 <CA+Tq-Rqm0vVnnvd6Zvtazs=qdwxKuC+9NwPt0LdbVS5HJa8=Ww@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+Tq-Rqm0vVnnvd6Zvtazs=qdwxKuC+9NwPt0LdbVS5HJa8=Ww-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hiroyuki Sato <hiroysato-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Parav.Pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org" <Parav.Pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Hello Parav.Pandit
> 
> Thank you for your advice.
> 
> I'll try it.

You can also look at rsockets in the latest librdmacm library.  You'd need to download and build the library yourself, since rsockets is not yet available in any release.  But there's a sample program (rcopy) that will copy a file between two systems over that API.

I haven't tried using it to copy a very large files, but in theory it should work.  (Hey, maybe you'll get lucky!)  If you do try it and hit into any problems, please let me know.

- Sean 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

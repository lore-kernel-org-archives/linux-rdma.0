From: Viral Mehta <Viral.Mehta-oonXi/34qI7c+919tysfdA@public.gmane.org>
Subject: RE: MTU value affected RDMA performance?
Date: Wed, 28 Jul 2010 10:23:05 +0530
Message-ID: <70376CA23424B34D86F1C7DE6B997343068C875FA7@VSHINMSMBX01.vshodc.lntinfotech.com>
References: <7686034.1280236021632.SLOX.WebMail.wwwrun@imap.lnl.infn.it>
 <2EFBCAEF10980645BBCFB605689E08E9049ED0AA33@azsmsx506.amr.corp.intel.com>,<5912490.1280239119794.SLOX.WebMail.wwwrun@imap.lnl.infn.it>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5912490.1280239119794.SLOX.WebMail.wwwrun-XDIR3SKYeFbgKi2NxijLtw@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrea Gozzelino <Andrea.Gozzelino-PK20h7lG/Rc1GQ1Ptb7lUw@public.gmane.org>, "Tung, Chien Tin" <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org" <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi,

>I have not idea about RDMA performance and MTU relationship.
>MTU=9000 Bytes; latency decreases and throughpt increases.
>Is the statement above correct?

Yes.

>I will study how operate on swicth.
>Actually, I modify MTU value on two machines, I run test and it stops
>when client RDMA sends buffers to RDMA server: it seems there is no
>communication channel. Both machines are in pending status probably
>because the switch is not configured with MTU=9000 Bytes.

See, if you can connect two machines back-to-back and it works...
This will eliminate the switch issue...

Viral

This Email may contain confidential or privileged information for the intended recipient (s) If you are not the intended recipient, please do not use or disseminate the information, notify the sender and delete it from your system.

______________________________________________________________________
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

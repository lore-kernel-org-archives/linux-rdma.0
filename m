From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] ib_core: Enable and expose force_mr module parameter
Date: Tue, 16 May 2017 10:57:20 -0400
Message-ID: <92A6DB1F-E9C6-4793-88A6-BA068F7E2AFB@oracle.com>
References: <20170515145203.10708.16921.stgit@klimt.1015granger.net> <20170515145757.GI3616@mtr-leonro.local> <02AFF424-A387-47F7-BD24-61C7734B9008@oracle.com> <20170515170021.GJ3616@mtr-leonro.local> <AE3152CC-B7C8-4C51-ADDE-C3822533BB94@oracle.com> <20170516054256.GA4013@lst.de> <d46b0a41-92c2-2ce2-5cf2-ac5c6c3811cd@grimberg.me>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <d46b0a41-92c2-2ce2-5cf2-ac5c6c3811cd-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, List Linux RDMA Mailing <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> On May 16, 2017, at 3:22 AM, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org> wrote:
> 
> 
>> I think I only added it on requests from someone (you?), and when
>> writing the code debugged it by manually forcing it to on.  Thay
>> being said a module parameter is entirely trivial and thus I'm fine
>> with it.  Think like debugfs or per-device setting for such a trivial
>> debug tool have just way to much boilerplate code.

Agree that debugfs would work, but might be overkill.


> I tend to agree. It's a very simple knob, can't imagine why we'd want it
> to be per-device.

Per-device port ... The internal helper includes @port_num as a
parameter:

static inline bool rdma_rw_can_use_mr(struct ib_device *dev, u8 port_num)

IIRC the idea was to eventually have a white list of devices
(besides iWARP devices, which require it) that prefer FRWR. And
some modes of operation (VF, or split RoCE-IB) might want to
force FRWR or not. See core/rw.c:

 48  * XXX: In the future we can hopefully fine tune this based on HCA driver
 49  * input.

The original impetus was to have a simple method of forcing the
use of FRWR so we could study the performance differences. When I
started using rdma_rw for NFSD, however, it was clear that there
were different constraints on ULP behavior depending on whether
FRWR was used or not.

However, I'm not stuck on keeping it. It's certainly not hard to
build a patched kernel that forces the use of FRWR, when I need
to test specific code paths.


--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
